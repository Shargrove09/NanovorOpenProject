/**
 * Main Nanovor Server Implementation
 * Emulates the original SmartFoxServer and Service Request Broker (SRB) architecture
 */

const express = require('express');
const http = require('http');
const net = require('net');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const crypto = require('crypto');

// Import helper modules
const { parseString } = require('xml2js');
const { create } = require('xmlbuilder2');
// Rebuilds the evolution graph from the shipped master data (see evolutionData.js)
const {
    getEvolutionListXml,
    getEvolutionById,
    getVirmonMaster,
    getEmMaster,
    getAllEms,
} = require('./evolutionData');
// Booster packs, drop rolls, nanocodes, starter grant - all tunable values live here
const {
    STARTER_NANOCASH,
    PACKS,
    PACK_BY_ID,
    CODE_BY_VALUE,
    GIFT_BY_VALUE,
    rollPack,
    grantToUser,
    newNanovorAssetId,
    buildSkuListXml,
} = require('./economy');
// Nanoscope handheld: on-device file formats and the vault of captured signed files
const nanoscope = require('./nanoscope');
const deviceVault = new nanoscope.DeviceVault(path.join(__dirname, 'DeviceVault'));
const DEVICE_CHARACTERS_DIR = path.join(__dirname, 'Manifests', 'device', 'Characters');

// Initialize Express app
const app = express();
const server = http.createServer(app);

// Middleware for XML-RPC endpoint specifically for SRB
app.use('/xmlrpc', express.raw({ type: 'text/xml', limit: '10mb' }));
app.use('/xmlrpc', express.raw({ type: 'application/xml', limit: '10mb' }));
app.use('/xmlrpc', express.raw({ type: '*/*', limit: '10mb' })); // Catch-all for xmlrpc in case content-type varies

// General middleware for other endpoints (avoid raw middleware that interferes with GET requests)
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(express.text({ type: 'text/plain', limit: '10mb' }));
// The client POSTs bankfe bodies (evolution attempts, jolt spends, profile saves,
// asset miscellany) with contentType "application/xml". Without a parser for that
// type req.body stays undefined and every such handler sees an empty body.
// The /xmlrpc mounts above are registered first, so SRB is unaffected.
app.use(express.text({ type: ['application/xml', 'text/xml'], limit: '10mb' }));
// Nanoscope uploads (deviceid.bbb, jolts-N.bbb, clog.bbb) arrive as raw
// application/octet-stream; without this req.body is {} and the bytes are lost.
app.use('/device', express.raw({ type: 'application/octet-stream', limit: '10mb' }));

// ---------------------------------------------------------------------------
// Web-hook path aliases.
//
// Config/WebClient.xml points every hook at /manifests/*, but this server only
// ever implemented /bankfe/manifests/*. So all seven hooks 404 - including
// buy-nanocash, which is why the in-game "get more nanocash" button goes
// nowhere. Rewrite the client's paths onto the handlers that exist.
//
// The three /manifests/*.xml routes (AppManifest, AppManifest-props, manifest)
// are real and must NOT be rewritten.
// ---------------------------------------------------------------------------
app.use((req, res, next) => {
    if (req.path.startsWith('/manifests/') && !req.path.toLowerCase().endsWith('.xml')) {
        const rewritten = '/bankfe' + req.url;
        console.log(`[hook] ${req.url} -> ${rewritten}`);
        req.url = rewritten;
    }
    next();
});

// In-memory storage for users and sessions
let users = {};
let sessions = {};

// Enhanced game room management with game state tracking
let gameRooms = {};

// Game state tracking
let gameStates = {};

// Function to create a new game room
function createGameRoom(name, maxUsers = 4, gameSwarmValue = 1000) {
    const roomId = Object.keys(gameRooms).length + 100; // Start from 100 to avoid conflicts

    const room = {
        id: roomId,
        name: name,
        maxUsers: maxUsers,
        maxSpectators: 0,
        isTemp: true,
        isGame: true,
        isPrivate: false,
        limbo: false,
        userCount: 0,
        spectatorCount: 0,
        users: [],
        variables: {},
        gameSwarmValue: gameSwarmValue,
        gameState: 'waiting_for_players', // Possible states: waiting_for_players, in_progress, finished
        players: [],
        currentTurn: 0,
        battleHistory: [], // Track battle events
        roundNumber: 1,
        turnOrder: [] // Order of players for turns
    };

    gameRooms[name] = room;
    return room;
}

// Function to get a user's game room
function getUserGameRoom(userId) {
    for (const roomId in gameRooms) {
        const room = gameRooms[roomId];
        const userInRoom = room.users.find(u => u.id === userId);
        if (userInRoom) {
            return room;
        }
    }
    return null;
}

// Function to advance to next turn
function advanceTurn(room) {
    room.currentTurn = (room.currentTurn + 1) % room.users.length;

    // Send notification to the player whose turn it is
    const currentPlayer = room.users[room.currentTurn];
    const readyForTurnMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"readyForTurn","battleName":"${room.name}","nanovorId":0,"isDead":false}]]></body></msg>\x00`;

    // In a real implementation, we would send this to the specific player
    console.log(`Advancing turn to player: ${currentPlayer.name} in room: ${room.name}`);
}

console.log('Starting Nanovor Server...');

// Load configuration files
const versionIni = fs.readFileSync(path.join(__dirname, 'version.INI'), 'utf8');
const connectionSettings = fs.readFileSync(path.join(__dirname, 'Config/connection_settings.xml'), 'utf8');
const loginScreenConfig = fs.readFileSync(path.join(__dirname, 'Config/LoginScreenConfig.xml'), 'utf8');

// Parse version info
const versionRegex = /(\w+)=(\d+)/g;
let match;
const versionInfo = {};
while ((match = versionRegex.exec(versionIni)) !== null) {
    versionInfo[match[1]] = match[2];
}

console.log(`Server version: ${versionInfo.major}.${versionInfo.minor}.${versionInfo.build}`);

// Service Request Broker (SRB) Implementation
app.post('/xmlrpc', (req, res) => {
    console.log(`[${new Date().toISOString()}] SRB Request received:`, typeof req.body);
    console.log(`Request details - Path: ${req.path}, Headers:`, req.headers);

    // Parse the XML-RPC request - handle Buffer, string, or object
    let requestBody;
    if (Buffer.isBuffer(req.body)) {
        // If body is a Buffer, convert to string
        requestBody = req.body.toString();
    } else if (typeof req.body === 'object') {
        // If body is parsed as object, it might be form data
        // The XML might be in a single field like 'xml' or might be the whole body
        if (req.body.xml && typeof req.body.xml === 'string') {
            // XML is in a field named 'xml'
            requestBody = req.body.xml;
        } else if (Object.keys(req.body).length === 1 && typeof Object.values(req.body)[0] === 'string') {
            // XML might be in a single unnamed field
            requestBody = Object.values(req.body)[0];
        } else if (JSON.stringify(req.body).includes('<methodCall>') || JSON.stringify(req.body).includes('<methodName>')) {
            // The XML might be embedded in the JSON representation of the form data
            requestBody = JSON.stringify(req.body);
        } else {
            // Convert form data object to string representation to see if XML is embedded
            requestBody = Object.keys(req.body).map(key => `${key}=${req.body[key]}`).join('&');
            // If it starts with something like "xml=", extract the actual XML
            if (requestBody.startsWith('xml=')) {
                requestBody = requestBody.substring(4); // Remove 'xml=' prefix
                requestBody = decodeURIComponent(requestBody);
            } else if (requestBody.includes('<methodCall>')) {
                // The XML is embedded in the form data string
                // Extract the XML portion
                const xmlMatch = requestBody.match(/<methodCall>[\s\S]*<\/methodCall>/);
                if (xmlMatch) {
                    requestBody = xmlMatch[0];
                }
            }
        }
    } else {
        requestBody = req.body.toString();
    }

    console.log(`[${new Date().toISOString()}] Parsed SRB request body:`, requestBody.substring(0, 200) + '...');

    // Check if it's a connect request - look specifically for srb.Connect method
    if (requestBody.includes('<methodName>srb.Connect</methodName>') || requestBody.includes('srb.Connect')) {
        // Extract parameters from the request (could be XML or form data)
        const params = extractParamsFromRequest(requestBody);
        console.log(`[${new Date().toISOString()}] Extracted SRB parameters:`, params);
        console.log(`[${new Date().toISOString()}] Request body preview:`, requestBody.substring(0, 500) + '...');

        // Generate a login token
        const loginToken = generateToken();

        // Create a mock user account if it doesn't exist
        const username = params.playername || 'n';
        console.log(`[${new Date().toISOString()}] Using username: '${username}' (from params: '${params.playername}')`);
        const accountId = generateAccountId(username);

        // First, try to load existing user data from file
        const existingUser = loadUserDataByUsername(username);
        console.log(`[${new Date().toISOString()}] Existing user lookup for ${username}: ${existingUser ? 'found' : 'not found'}`);
        if (!existingUser) {
            // User doesn't exist in file, create a new profile
            if (!users[accountId]) {
                users[accountId] = createUserProfile(accountId, username);
                console.log(`[${new Date().toISOString()}] Created new user profile for ${username} (ID: ${accountId})`);
                console.log(`[${new Date().toISOString()}] New user nanovor inventory:`, users[accountId].nanovorInventory);
                console.log(`[${new Date().toISOString()}] Full new user profile nanovor inventory:`, JSON.stringify(users[accountId].nanovorInventory, null, 2));

                // Save the new user data to file
                saveUserData(accountId);
            }
        } else {
            console.log(`[${new Date().toISOString()}] Loaded existing user profile for ${username} (ID: ${accountId})`);
            console.log(`[${new Date().toISOString()}] Existing user nanovor inventory:`, existingUser.nanovorInventory);
        }
        // If existingUser exists, it's already loaded into the users object by loadUserDataByUsername

        // Create session
        const sessionId = uuidv4();
        sessions[sessionId] = {
            accountId: accountId,
            loginToken: loginToken,
            expires: Date.now() + 30 * 60 * 1000, // 30 minutes
            ip: req.ip
        };

        console.log(`[${new Date().toISOString()}] Created session for user ${username} (ID: ${accountId}), session ID: ${sessionId}`);

        // Prepare SRB response with service endpoints
        const srbResponse = createSrbResponse(accountId, loginToken);

        // Send XML-RPC response
        res.set('Content-Type', 'application/xml; charset=utf-8');
        res.send(srbResponse);
        console.log(`[${new Date().toISOString()}] SRB Response sent successfully for user ${username} (ID: ${accountId})`);
    } else {
        // Handle other XML-RPC methods
        console.log(`[${new Date().toISOString()}] Unsupported SRB method:`, requestBody);
        res.status(400).send('Unsupported method');
    }
});

// Shard List Service
app.get('/scws/', (req, res) => {
    console.log('Shard list request received');

    // Log the request headers and query parameters to understand what the client is sending
    console.log('Shard list request headers:', req.headers);
    console.log('Shard list request query:', req.query);

    const shardList = `<?xml version="1.0" encoding="UTF-8"?>
<shard-list xmlns="http://127.0.0.1:8443/xsd/shard/shard-list.xsd">
  <shard>
    <name>Tank</name>
    <url>127.0.0.1</url>
    <max-capacity>1000</max-capacity>
    <used-capacity>10</used-capacity>
    <nice>1</nice>
    <population>Tank</population>
    <locales>
      <locale>en-US</locale>
    </locales>
  </shard>
</shard-list>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(shardList);
    console.log('Shard list response sent successfully');
});

// Bank Frontend Service
app.get('/bankfe/resources/account/:accountId', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account info request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for account info request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Return user account info
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account info request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    const accountInfo = `
<account xmlns="http://127.0.0.1:8443/xsd/account/account.xsd">
  <username>${user.username}</username>
  <screenname>${user.screenname}</screenname>
  <email-address>${user.email}</email-address>
  <phone-number>${user.phoneNumber || ''}</phone-number>
  <avatar-id>${user.avatarId}</avatar-id>
  <token-balance>${user.nanocash}</token-balance>
  <jolt_health_balance>${user.healthJolts}</jolt_health_balance>
  <jolt_armor_balance>${user.armorJolts}</jolt_armor_balance>
  <jolt_strength_balance>${user.strengthJolts}</jolt_strength_balance>
  <jolt_speed_balance>${user.speedJolts}</jolt_speed_balance>
  <virmon-master-rating>${user.nmp}</virmon-master-rating>
  <games-played>${user.gamesPlayed}</games-played>
</account>`;

    console.log(`[${new Date().toISOString()}] Sending account info response for ${accountId}`);
    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(accountInfo);
});

app.get('/bankfe/resources/account/:accountId/stat', (req, res) => {
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account stats request, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for account stats request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    const user = users[session.accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account stats request - accountId: ${session.accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    const accountStats = `
<account-statistics xmlns="http://127.0.0.1:8443/xsd/account-statistics/account-statistics.xsd">
  <virmon-master-rating>${user.nmp}</virmon-master-rating>
  <kill-count>${user.totalKills}</kill-count>
  <game-count>${user.gamesPlayed}</game-count>
  <win-count>${user.gamesWon}</win-count>
  <two-player-game-count>${user.twoPlayerGames}</two-player-game-count>
  <three-player-game-count>${user.threePlayerGames}</three-player-game-count>
  <four-player-game-count>${user.fourPlayerGames}</four-player-game-count>
  <hexite-kill-count>${user.hexiteKills}</hexite-kill-count>
  <magnamod-kill-count>${user.magnamodKills}</magnamod-kill-count>
  <velocitron-kill-count>${user.velocitronKills}</velocitron-kill-count>
  <nanovor-count>${user.nanovorCount}</nanovor-count>
  <unique-nanovor-count>${user.nanovorCountUnique}</unique-nanovor-count>
</account-statistics>`;

    console.log(`[${new Date().toISOString()}] Sending account stats response for ${session.accountId}`);
    res.set('Content-Type', 'application/xml');
    res.send(accountStats);
});

// Additional account statistics endpoint by account ID (might be used by client)
app.get('/bankfe/resources/account/:accountId/stat', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account stats request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for account stats request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Verify that the requested account ID matches the authenticated session
    if (session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Unauthorized account stats request - session accountId: ${session.accountId}, requested accountId: ${accountId}`);
        return res.status(403).send('<error>Unauthorized</error>');
    }

    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account stats request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    const accountStats = `
<account-statistics xmlns="http://127.0.0.1:8443/xsd/account-statistics/account-statistics.xsd">
  <virmon-master-rating>${user.nmp}</virmon-master-rating>
  <kill-count>${user.totalKills}</kill-count>
  <game-count>${user.gamesPlayed}</game-count>
  <win-count>${user.gamesWon}</win-count>
  <two-player-game-count>${user.twoPlayerGames}</two-player-game-count>
  <three-player-game-count>${user.threePlayerGames}</three-player-game-count>
  <four-player-game-count>${user.fourPlayerGames}</four-player-game-count>
  <hexite-kill-count>${user.hexiteKills}</hexite-kill-count>
  <magnamod-kill-count>${user.magnamodKills}</magnamod-kill-count>
  <velocitron-kill-count>${user.velocitronKills}</velocitron-kill-count>
  <nanovor-count>${user.nanovorCount}</nanovor-count>
  <unique-nanovor-count>${user.nanovorCountUnique}</unique-nanovor-count>
</account-statistics>`;

    console.log(`[${new Date().toISOString()}] Sending account stats response for ${accountId}`);
    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(accountStats);
});

// XSD Schema endpoint for account statistics
app.get('/xsd/account-statistics/account-statistics.xsd', (req, res) => {
    console.log(`[${new Date().toISOString()}] Account statistics XSD schema requested, Query:`, req.query, 'Headers:', req.headers);

    // Return XSD schema for account statistics
    const xsdSchema = `<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           targetNamespace="http://127.0.0.1:8443/xsd/account-statistics/account-statistics.xsd"
           xmlns:tns="http://127.0.0.1:8443/xsd/account-statistics/account-statistics.xsd"
           elementFormDefault="qualified">

    <xs:element name="account-statistics">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="virmon-master-rating" type="xs:integer" minOccurs="0"/>
                <xs:element name="kill-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="game-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="win-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="two-player-game-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="three-player-game-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="four-player-game-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="hexite-kill-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="magnamod-kill-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="velocitron-kill-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="nanovor-count" type="xs:integer" minOccurs="0"/>
                <xs:element name="unique-nanovor-count" type="xs:integer" minOccurs="0"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(xsdSchema);
});

// Endpoint for account statistics (used by requestFromBank with path "/stat/account/{accountId}")
// The client requests this as: {bankURLRead}/stat/account/{accountId}?auth={token}
app.get('/stat/account/:accountId', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account statistics request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for account stats request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Verify that the requested account ID matches the authenticated session
    if (session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Unauthorized account stats request - session accountId: ${session.accountId}, requested accountId: ${accountId}`);
        return res.status(403).send('<error>Unauthorized</error>');
    }

    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account stats request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    // Return account statistics in the expected format
    const accountStats = `
<account-statistics xmlns="http://127.0.0.1:8443/xsd/account-statistics/account-statistics.xsd">
  <virmon-master-rating>${user.nmp || 0}</virmon-master-rating>
  <kill-count>${user.totalKills || 0}</kill-count>
  <game-count>${user.gamesPlayed || 0}</game-count>
  <win-count>${user.gamesWon || 0}</win-count>
  <two-player-game-count>${user.twoPlayerGames || 0}</two-player-game-count>
  <three-player-game-count>${user.threePlayerGames || 0}</three-player-game-count>
  <four-player-game-count>${user.fourPlayerGames || 0}</four-player-game-count>
  <hexite-kill-count>${user.hexiteKills || 0}</hexite-kill-count>
  <magnamod-kill-count>${user.magnamodKills || 0}</magnamod-kill-count>
  <velocitron-kill-count>${user.velocitronKills || 0}</velocitron-kill-count>
  <nanovor-count>${user.nanovorCount || 2}</nanovor-count>
  <unique-nanovor-count>${user.nanovorCountUnique || 2}</unique-nanovor-count>
</account-statistics>`;

    console.log(`[${new Date().toISOString()}] Sending account statistics response for ${accountId}`);
    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(accountStats);
});

// Also keep the original endpoint for backward compatibility
app.get('/stat/account/', (req, res) => {
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account statistics request (general endpoint), auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for account stats request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    const user = users[session.accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account stats request - accountId: ${session.accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    // Return account statistics in the expected format
    const accountStats = `
<account-statistics xmlns="http://127.0.0.1:8443/xsd/account-statistics/account-statistics.xsd">
  <virmon-master-rating>${user.nmp || 0}</virmon-master-rating>
  <kill-count>${user.totalKills || 0}</kill-count>
  <game-count>${user.gamesPlayed || 0}</game-count>
  <win-count>${user.gamesWon || 0}</win-count>
  <two-player-game-count>${user.twoPlayerGames || 0}</two-player-game-count>
  <three-player-game-count>${user.threePlayerGames || 0}</three-player-game-count>
  <four-player-game-count>${user.fourPlayerGames || 0}</four-player-game-count>
  <hexite-kill-count>${user.hexiteKills || 0}</hexite-kill-count>
  <magnamod-kill-count>${user.magnamodKills || 0}</magnamod-kill-count>
  <velocitron-kill-count>${user.velocitronKills || 0}</velocitron-kill-count>
  <nanovor-count>${user.nanovorCount || 2}</nanovor-count>
  <unique-nanovor-count>${user.nanovorCountUnique || 2}</unique-nanovor-count>
</account-statistics>`;

    console.log(`[${new Date().toISOString()}] Sending account statistics response for ${session.accountId}`);
    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(accountStats);
});

// More specific catch-all for account-related requests to avoid interfering with asset requests
app.get('/bankfe/resources/account/:accountId', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account info request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for account info request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Get user account
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account info request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    // Return account info in the expected format
    const accountInfo = `
<account xmlns="http://127.0.0.1:8443/xsd/account/account.xsd">
  <username>${user.username}</username>
  <screenname>${user.screenname}</screenname>
  <email-address>${user.email}</email-address>
  <phone-number>${user.phoneNumber || ''}</phone-number>
  <avatar-id>${user.avatarId || 1}</avatar-id>
  <token-balance>${user.nanocash || 0}</token-balance>
  <jolt_health_balance>${user.healthJolts || 0}</jolt_health_balance>
  <jolt_armor_balance>${user.armorJolts || 0}</jolt_armor_balance>
  <jolt_strength_balance>${user.strengthJolts || 0}</jolt_strength_balance>
  <jolt_speed_balance>${user.speedJolts || 0}</jolt_speed_balance>
  <virmon-master-rating>${user.nmp || 0}</virmon-master-rating>
  <games-played>${user.gamesPlayed || 0}</games-played>
</account>`;

    console.log(`[${new Date().toISOString()}] Sending account info response for ${accountId}`);
    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(accountInfo);
});

// Additional endpoint that might be needed for user profile data
app.get('/bankfe/resources/account/profile/:accountId', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account profile request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for account profile request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Return user profile info
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account profile request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    const profileInfo = `
<account-profile xmlns="http://127.0.0.1:8443/xsd/account/account-profile.xsd">
  <virmon-master-rating>${user.nmp || 0}</virmon-master-rating>
  <game-count>${user.gamesPlayed || 0}</game-count>
  <phone-number>${user.phoneNumber || ''}</phone-number>
  <avatar-id>${user.avatarId || 1}</avatar-id>
</account-profile>`;

    console.log(`[${new Date().toISOString()}] Sending account profile response for ${accountId}`);
    res.set('Content-Type', 'application/xml');
    res.send(profileInfo);
});

// Endpoint to add a nanovor to a user's inventory
app.post('/bankfe/resources/account/:accountId/nanovor', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Add nanovor request for account ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers, 'Body:', req.body.toString());

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for add nanovor request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Parse nanovor data from request
    let nanovorData;

    // Check if the body is JSON or XML
    const bodyStr = req.body.toString();
    if (bodyStr.trim().startsWith('{')) {
        // It's JSON
        try {
            nanovorData = JSON.parse(bodyStr);
        } catch (e) {
            console.error('Error parsing JSON nanovor data:', e);
            return res.status(400).send('<error>Invalid JSON data</error>');
        }
    } else {
        // It's XML, parse it synchronously
        const parseString = require('xml2js').parseStringSync;
        try {
            const result = parseString(bodyStr);
            const nanovor = result.nanovor || result.virmon || (result.root ? (result.root.nanovor || result.root.virmon) : null);
            if (nanovor && nanovor[0]) {
                const n = nanovor[0];
                nanovorData = {
                    id: parseInt(n.id?.[0]) || 0,
                    name: n.name?.[0] || 'Unknown Nanovor',
                    faction: n.faction?.[0] || 'Unknown',
                    rarity: n.rarity?.[0] || 'common',
                    wave: parseInt(n.wave?.[0]) || 1,
                    health: parseInt(n.health?.[0]) || 100,
                    armor: parseInt(n.armor?.[0]) || 0,
                    speed: parseInt(n.speed?.[0]) || 50,
                    strength: parseInt(n.strength?.[0]) || 50,
                    type: 'nanovor',
                    assetTypeId: parseInt(n.assetTypeId?.[0]) || parseInt(n.id?.[0]) || 0
                };
            } else {
                return res.status(400).send('<error>No valid nanovor data found in XML</error>');
            }
        } catch (e) {
            console.error('Error parsing XML nanovor data:', e);
            return res.status(400).send('<error>Invalid XML data</error>');
        }
    }

    // Add nanovor to user's inventory
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for add nanovor request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    // Ensure nanovorInventory exists
    if (!user.nanovorInventory) {
        user.nanovorInventory = [];
    }

    // Add the new nanovor to inventory
    user.nanovorInventory.push(nanovorData);

    // Update counts
    user.nanovorCount = user.nanovorInventory.length;
    user.nanovorCountUnique = user.nanovorInventory.length; // Simplified for now

    // Save user data after updating inventory
    saveUserData(accountId);

    const response = `<nanovor-add-success xmlns="http://127.0.0.1:8443/xsd/nanovor-add/nanovor-add-success.xsd"/>`;

    console.log(`[${new Date().toISOString()}] Successfully added nanovor to account ${accountId}`);
    res.set('Content-Type', 'application/xml');
    res.send(response);
});

// Endpoint to remove a nanovor from a user's inventory
app.delete('/bankfe/resources/account/:accountId/nanovor/:nanovorId', (req, res) => {
    const accountId = req.params.accountId;
    const nanovorId = parseInt(req.params.nanovorId);
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Remove nanovor request for account ${accountId}, nanovorId: ${nanovorId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for remove nanovor request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Remove nanovor from user's inventory
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for remove nanovor request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    if (user.nanovorInventory) {
        // Filter out the nanovor with the specified ID
        user.nanovorInventory = user.nanovorInventory.filter(nanovor => nanovor.id !== nanovorId);

        // Update counts
        user.nanovorCount = user.nanovorInventory.length;
        user.nanovorCountUnique = user.nanovorInventory.length; // Simplified for now

        // Save user data after updating inventory
        saveUserData(accountId);
    }

    const response = `<nanovor-remove-success xmlns="http://127.0.0.1:8443/xsd/nanovor-remove/nanovor-remove-success.xsd"/>`;

    console.log(`[${new Date().toISOString()}] Successfully removed nanovor ${nanovorId} from account ${accountId}`);
    res.set('Content-Type', 'application/xml');
    res.send(response);
});

// Endpoint to add an Energy Matrix to a user's inventory
app.post('/bankfe/resources/account/:accountId/em', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Add EM request for account ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers, 'Body:', req.body.toString());

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for add EM request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Parse EM data from request
    let emData;

    // Check if the body is JSON or XML
    const bodyStr = req.body.toString();
    if (bodyStr.trim().startsWith('{')) {
        // It's JSON
        try {
            emData = JSON.parse(bodyStr);
        } catch (e) {
            console.error('Error parsing JSON EM data:', e);
            return res.status(400).send('<error>Invalid JSON data</error>');
        }
    } else {
        // It's XML, parse it synchronously
        const parseString = require('xml2js').parseStringSync;
        try {
            const result = parseString(bodyStr);
            const em = result.em || (result.root ? result.root.em : null);
            if (em && em[0]) {
                const e = em[0];
                emData = {
                    id: parseInt(e.id?.[0]) || 0,
                    name: e.name?.[0] || 'Unknown EM',
                    assetTypeId: parseInt(e.assetTypeId?.[0]) || parseInt(e.id?.[0]) || 0
                };
            } else {
                return res.status(400).send('<error>No valid EM data found in XML</error>');
            }
        } catch (e) {
            console.error('Error parsing XML EM data:', e);
            return res.status(400).send('<error>Invalid XML data</error>');
        }
    }

    // Add EM to user's inventory
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for add EM request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    // Ensure emInventory exists
    if (!user.emInventory) {
        user.emInventory = [];
    }

    // Add the new EM to inventory
    user.emInventory.push(emData);

    // Update EM count
    user.ems = user.emInventory.length;

    // Save user data after updating inventory
    saveUserData(accountId);

    const response = `<em-add-success xmlns="http://127.0.0.1:8443/xsd/em-add/em-add-success.xsd"/>`;

    console.log(`[${new Date().toISOString()}] Successfully added EM to account ${accountId}`);
    res.set('Content-Type', 'application/xml');
    res.send(response);
});

// ---------------------------------------------------------------------------
// Dev / admin: grant EMs to an account.
//
// The game itself only hands out EMs through the NanoMall and battle rewards,
// neither of which is implemented yet, so there is no in-game way to accumulate
// the EMs an evolution needs. This exists purely so evolution can be exercised.
//
// Deliberately NOT token-authenticated and bound to loopback only - it is a
// local testing tool. Remove or gate it before exposing this server publicly.
//
//   POST /dev/account/:accountId/grant-ems            -> one of every EM type
//   POST /dev/account/:accountId/grant-ems?types=1007,1013
//   POST /dev/account/:accountId/grant-ems?types=1007&count=3
// ---------------------------------------------------------------------------
app.post('/dev/account/:accountId/grant-ems', (req, res) => {
    const remote = req.socket.remoteAddress || '';
    if (!/^(::1|::ffff:127\.0\.0\.1|127\.0\.0\.1)$/.test(remote)) {
        console.warn(`[dev] rejected grant-ems from non-loopback address ${remote}`);
        return res.status(403).json({ error: 'dev endpoints are loopback-only' });
    }

    const accountId = req.params.accountId;
    const user = users[accountId];
    if (!user) {
        return res.status(404).json({ error: `no such account: ${accountId}`, known: Object.keys(users) });
    }

    const all = getAllEms(__dirname);
    let wanted;
    if (req.query.types) {
        wanted = String(req.query.types).split(',').map(s => parseInt(s.trim(), 10)).filter(Number.isFinite);
    } else {
        wanted = all.map(e => e.assetTypeId); // one of everything
    }

    const count = Math.max(1, parseInt(req.query.count, 10) || 1);
    const unknown = wanted.filter(id => !getEmMaster(__dirname, id));
    if (unknown.length) {
        return res.status(400).json({ error: `unknown EM asset-type-ids: ${unknown.join(',')}` });
    }

    if (!user.emInventory) user.emInventory = [];

    const granted = [];
    for (const typeId of wanted) {
        const master = getEmMaster(__dirname, typeId);
        for (let i = 0; i < count; i++) {
            const now = formatDateForNanovor(new Date());
            const em = {
                id: `em_${typeId}_${uuidv4().substring(0, 4)}`,
                name: master.shortName || master.longName || `EM ${typeId}`,
                type: 'em',
                assetTypeId: typeId,
                // Unique per-instance id - this is what the client sends back as
                // <em-asset-id> when submitting an evolution.
                assetId: uuidv4().substring(0, 8),
                productionNumber: 1,
                birthDate: now,
                lastEvolutionDate: now,
                nickname: '',
            };
            user.emInventory.push(em);
            granted.push({ assetTypeId: typeId, name: em.name, assetId: em.assetId });
        }
    }

    user.ems = user.emInventory.length;
    saveUserData(accountId);

    console.log(`[dev] granted ${granted.length} EM(s) to ${accountId}; inventory now ${user.emInventory.length}`);
    res.json({ granted: granted.length, totalEms: user.emInventory.length, items: granted });
});

// Endpoint to remove an Energy Matrix from a user's inventory
app.delete('/bankfe/resources/account/:accountId/em/:emId', (req, res) => {
    const accountId = req.params.accountId;
    const emId = parseInt(req.params.emId);
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Remove EM request for account ${accountId}, emId: ${emId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for remove EM request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Remove EM from user's inventory
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for remove EM request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    if (user.emInventory) {
        // Filter out the EM with the specified ID
        user.emInventory = user.emInventory.filter(em => em.id !== emId);

        // Update EM count
        user.ems = user.emInventory.length;

        // Save user data after updating inventory
        saveUserData(accountId);
    }

    const response = `<em-remove-success xmlns="http://127.0.0.1:8443/xsd/em-remove/em-remove-success.xsd"/>`;

    console.log(`[${new Date().toISOString()}] Successfully removed EM ${emId} from account ${accountId}`);
    res.set('Content-Type', 'application/xml');
    res.send(response);
});

app.use('/xsd', express.static(path.join(__dirname, 'xsd')));

// Account badges endpoint
app.get('/bankfe/resources/account/:accountId/badge', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account badges request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for account badges request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Return user badges info
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account badges request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    // Return empty badges for now, or populate with user's badges
    const badges = user.badges || [];

    const badgesXml = `
<badges xmlns="http://127.0.0.1:8443/xsd/badges/badges.xsd">
</badges>`;

    console.log(`[${new Date().toISOString()}] Sending account badges response for ${accountId} with ${badges.length} badges`);
    res.set('Content-Type', 'application/xml');
    res.send(badgesXml);
});

// Asset list endpoint - this is what the VirmonManager uses to get collection data
app.get('/bankfe/resources/account/:accountId/asset-list', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Asset list request received for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    console.log(`[${new Date().toISOString()}] Verifying token for asset list request - auth: ${auth}, accountId: ${accountId}`);
    const session = findSessionByToken(auth);
    console.log(`[${new Date().toISOString()}] Session lookup result:`, session ? {accountId: session.accountId, loginToken: session.loginToken} : 'no session found');
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for asset list request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Return user's asset list in the format expected by VirmonManager
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for asset list request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    console.log(`[${new Date().toISOString()}] Asset list request for user:`, user.username);
    console.log(`[${new Date().toISOString()}] User nanovor inventory count:`, user.nanovorInventory ? user.nanovorInventory.length : 0);
    console.log(`[${new Date().toISOString()}] User nanovor inventory:`, user.nanovorInventory);
    console.log(`[${new Date().toISOString()}] Full user object nanovorInventory:`, JSON.stringify(user.nanovorInventory, null, 2));

    // Build XML for nanovor inventory in the exact format expected by VirmonData.parseXMLData
    let assetsXml = '';

    // Add nanovor to the asset list (only include nanovor for now, excluding EMs)
    const nanovorList = user.nanovorInventory || [];
    for (const nanovor of nanovorList) {
        // Format as asset with the exact structure expected by the client
        const assetId = `${nanovor.assetId || nanovor.id}`; // Use the assetId if available, otherwise use id

        // Use stored data if available, otherwise use defaults
        const productionNumber = nanovor.productionNumber || 1;
        const birthDate = nanovor.birthDate || formatDateForNanovor(new Date());
        const lastEvolutionDate = nanovor.lastEvolutionDate || formatDateForNanovor(new Date());

        assetsXml += `
    <asset id="1" xmlns:ns2="http://smithandtinker.com/xsd/asset-miscellany" xmlns:ns3="http://smithandtinker.com/xsd/asset-stat">
    <asset-type-category>virmon</asset-type-category>
    <asset-type-id>1</asset-type-id>
    <asset-type-name>Electropod 1.0</asset-type-name>
    <production-number>1</production-number>
    <birth-date>2024-01-01T00:00:00.000+00:00</birth-date>
    <last-evolution-date>2024-01-01T00:00:00.000+00:00</last-evolution-date>
    <ns2:asset-miscellany>
      <ns2:nickname></ns2:nickname>
    </ns2:asset-miscellany>
    <ns3:asset-stat>
      <ns3:asset-type-id>1</ns3:asset-type-id>
      <ns3:speed>10</ns3:speed>
      <ns3:strength>120</ns3:strength>
      <ns3:armor>5</ns3:armor>
      <ns3:health>100</ns3:health>
      <ns3:kill-count>0</ns3:kill-count>
      <ns3:kill-count-lifetime>0</ns3:kill-count-lifetime>
      <ns3:battle-count>0</ns3:battle-count>
      <ns3:battle-count-lifetime>0</ns3:battle-count-lifetime>
      <ns3:death-count>0</ns3:death-count>
      <ns3:death-count-lifetime>0</ns3:death-count-lifetime>
      <ns3:magnamod-kill-count>0</ns3:magnamod-kill-count>
      <ns3:magnamod-kill-count-lifetime>0</ns3:magnamod-kill-count-lifetime>
      <ns3:hexite-kill-count>0</ns3:hexite-kill-count>
      <ns3:hexite-kill-count-lifetime>0</ns3:hexite-kill-count-lifetime>
      <ns3:velocitron-kill-count>0</ns3:velocitron-kill-count>
      <ns3:velocitron-kill-count-lifetime>0</ns3:velocitron-kill-count-lifetime>
      <ns3:win-count>0</ns3:win-count>
      <ns3:win-count-lifetime>0</ns3:win-count-lifetime>
      <ns3:critical-hit-count>0</ns3:critical-hit-count>
      <ns3:whiff-count>0</ns3:whiff-count>
      <ns3:screen-star>false</ns3:screen-star>
      <ns3:scraped-by>false</ns3:scraped-by>
      <ns3:all-attacks-used>false</ns3:all-attacks-used>
      <ns3:slacker>false</ns3:slacker>
      <ns3:max-damage-game>0</ns3:max-damage-game>
      <ns3:max-damage-hit>0</ns3:max-damage-hit>
      <ns3:max-round-count>0</ns3:max-round-count>
    </ns3:asset-stat>
  </asset>
  <asset id="2" xmlns:ns2="http://smithandtinker.com/xsd/asset-miscellany" xmlns:ns3="http://smithandtinker.com/xsd/asset-stat">
    <asset-type-category>virmon</asset-type-category>
    <asset-type-id>24</asset-type-id>
    <asset-type-name>Doom Blade 1.0</asset-type-name>
    <production-number>1</production-number>
    <birth-date>2024-01-01T00:00:00.000+00:00</birth-date>
    <last-evolution-date>2024-01-01T00:00:00.000+00:00</last-evolution-date>
    <ns2:asset-miscellany>
      <ns2:nickname></ns2:nickname>
    </ns2:asset-miscellany>
    <ns3:asset-stat>
      <ns3:asset-type-id>24</ns3:asset-type-id>
      <ns3:speed>25</ns3:speed>
      <ns3:strength>85</ns3:strength>
      <ns3:armor>0</ns3:armor>
      <ns3:health>100</ns3:health>
      <ns3:kill-count>0</ns3:kill-count>
      <ns3:kill-count-lifetime>0</ns3:kill-count-lifetime>
      <ns3:battle-count>0</ns3:battle-count>
      <ns3:battle-count-lifetime>0</ns3:battle-count-lifetime>
      <ns3:death-count>0</ns3:death-count>
      <ns3:death-count-lifetime>0</ns3:death-count-lifetime>
      <ns3:magnamod-kill-count>0</ns3:magnamod-kill-count>
      <ns3:magnamod-kill-count-lifetime>0</ns3:magnamod-kill-count-lifetime>
      <ns3:hexite-kill-count>0</ns3:hexite-kill-count>
      <ns3:hexite-kill-count-lifetime>0</ns3:hexite-kill-count-lifetime>
      <ns3:velocitron-kill-count>0</ns3:velocitron-kill-count>
      <ns3:velocitron-kill-count-lifetime>0</ns3:velocitron-kill-count-lifetime>
      <ns3:win-count>0</ns3:win-count>
      <ns3:win-count-lifetime>0</ns3:win-count-lifetime>
      <ns3:critical-hit-count>0</ns3:critical-hit-count>
      <ns3:whiff-count>0</ns3:whiff-count>
      <ns3:screen-star>false</ns3:screen-star>
      <ns3:scraped-by>false</ns3:scraped-by>
      <ns3:all-attacks-used>false</ns3:all-attacks-used>
      <ns3:slacker>false</ns3:slacker>
      <ns3:max-damage-game>0</ns3:max-damage-game>
      <ns3:max-damage-hit>0</ns3:max-damage-hit>
      <ns3:max-round-count>0</ns3:max-round-count>
    </ns3:asset-stat>
  </asset>`;
    }

    // NOTE: EM assets are intentionally excluded for now to simplify the asset list

    const assetList = `<?xml version="1.0" encoding="UTF-8"?>
<asset-list>
${assetsXml}
</asset-list>`;

    console.log(`[${new Date().toISOString()}] Sending asset list response for ${accountId}`);
    console.log(`[${new Date().toISOString()}] Asset list XML being sent:`, assetList);
    res.set('Content-Type', 'application/xml');
    res.send(assetList);
});

// Endpoint for refreshing user token (might be called periodically)
app.post('/bankfe/resources/account/refresh-login', (req, res) => {
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Token refresh request, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers, 'Body:', req.body.toString());

    // Find and refresh the session
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for refresh request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Generate new token
    const newToken = generateToken();
    session.loginToken = newToken;
    session.expires = Date.now() + 30 * 60 * 1000; // 30 minutes

    // Update user's token in all references
    for (const userId in users) {
        if (users[userId].loginToken === auth) {
            users[userId].loginToken = newToken;
            console.log(`[${new Date().toISOString()}] Updated token for user ${userId}`);
            break;
        }
    }

    const refreshResponse = `<token>${newToken}</token>`;

    console.log(`[${new Date().toISOString()}] Token refreshed successfully, new token: ${newToken}`);
    res.set('Content-Type', 'application/xml');
    res.send(refreshResponse);
});

// Additional endpoints that might be needed for inventory/collections after login
app.get('/bankfe/resources/account/collections/:accountId', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account collections request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for account collections request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Return user's collection data
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account collections request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    // Return user's collection data from their inventory
    const nanovorList = user.nanovorInventory || [];
    const emList = user.emInventory || [];

    // Build XML for nanovor inventory
    let virmonXml = '';
    for (const nanovor of nanovorList) {
        // Use the assetTypeId as the type identifier and create a unique instance ID
        // For simplicity, we'll use the same ID as both assetTypeId and assetId for now
        // In a real implementation, assetId would be a unique instance identifier
        const assetId = nanovor.assetTypeId.toString(); // This could be a unique instance ID in production
        virmonXml += `
    <virmon>
      <id>${nanovor.id}</id>
      <name>${nanovor.name}</name>
      <assetTypeId>${nanovor.assetTypeId}</assetTypeId>
      <assetId>${assetId}</assetId>
      <faction>${nanovor.faction}</faction>
      <rarity>${nanovor.rarity}</rarity>
      <wave>${nanovor.wave}</wave>
      <base-health>${nanovor.health}</base-health>
      <base-armor>${nanovor.armor}</base-armor>
      <base-speed>${nanovor.speed}</base-speed>
      <base-strength>${nanovor.strength}</base-strength>
    </virmon>`;
    }

    // NOTE: EM inventory is intentionally excluded for now to simplify the collection list

    const collectionsData = `
<collections xmlns="http://127.0.0.1:8443/xsd/collections/collections.xsd">
  <virmonList>
${virmonXml}
  </virmonList>
  <emList>
    <!-- EMs intentionally excluded for now -->
  </emList>
</collections>`;

    console.log(`[${new Date().toISOString()}] Sending account collections response for ${accountId}`);
    res.set('Content-Type', 'application/xml');
    res.send(collectionsData);
});

// Asset badges endpoint
app.get('/bankfe/resources/asset/:assetId/badge', (req, res) => {
    const assetId = req.params.assetId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Asset badges request for asset ${assetId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for asset badges request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Return asset badges info
    // For now, return empty badges
    const badgesXml = `
<asset-badges xmlns="http://127.0.0.1:8443/xsd/asset/asset-badges.xsd">
</asset-badges>`;

    console.log(`[${new Date().toISOString()}] Sending asset badges response for asset ${assetId}`);
    res.set('Content-Type', 'application/xml');
    res.send(badgesXml);
});

// Endpoint for saving/updating user profile information
app.post('/bankfe/resources/account/:accountId/profile', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account profile update request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers, 'Body:', req.body.toString());

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for account profile update request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Parse the profile data from the request
    const profileData = req.body.toString();
    console.log(`[${new Date().toISOString()}] Profile update data: ${profileData}`);

    // Update user profile
    if (users[accountId]) {
        // This is a simplified update - in a real implementation you'd parse the XML
        // and update specific fields
        console.log(`[${new Date().toISOString()}] Updated profile for user ${accountId}`);
    }

    // Return success response
    const response = `<profile-update-success xmlns="http://127.0.0.1:8443/xsd/account/profile-update-success.xsd"/>`;

    console.log(`[${new Date().toISOString()}] Sending profile update success response for ${accountId}`);
    res.set('Content-Type', 'application/xml');
    res.send(response);
});

// Asset jolt spend endpoint
app.post('/bankfe/resources/asset/:assetId/jolt', (req, res) => {
    const assetId = req.params.assetId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Asset jolt spend request for asset ${assetId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers, 'Body:', req.body.toString());

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for asset jolt spend request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Parse the jolt spend data from the request
    const joltSpendData = req.body.toString();
    console.log(`[${new Date().toISOString()}] Jolt spend data: ${joltSpendData}`);

    // For now, just acknowledge the request
    // In a real implementation, you would parse the XML and update the asset's stats
    console.log(`[${new Date().toISOString()}] Processed jolt spend for asset ${assetId}`);

    // Return success response
    const response = `<jolt-spend-success xmlns="http://127.0.0.1:8443/xsd/jolt-spend/jolt-spend-success.xsd"/>`;

    console.log(`[${new Date().toISOString()}] Sending jolt spend success response for asset ${assetId}`);
    res.set('Content-Type', 'application/xml');
    res.send(response);
});

// Account activity endpoint for determining new user status
app.get('/bankfe/resources/account/activity/:accountId', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account activity request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for account activity request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Get user account
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account activity request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    // Create activity XML based on user stats
    // NOTE: The client-side NewUserStatusDeterminator has a bug where the logic is inverted
    // It treats users as "new" when they have MORE than 7 login activities, which is backwards
    // To work with the buggy client logic, we need to return appropriate values
    let loginActivities = user.gamesPlayed || 8;
    // For the buggy client logic: if login count > 7, client thinks user IS new
    // So to make experienced users NOT appear as new, keep their login count at 7 or below
    if (loginActivities === 8) {
        loginActivities = 8; // New user - will trigger new user experience correctly
    } else {
        // For existing users, cap login activities at 7 to avoid the buggy client treating them as new
        // This works with the inverted client logic
        loginActivities = Math.min(loginActivities, 8);
    }

    let activityXml = '<activity-list xmlns="http://127.0.0.1:8443/xsd/activity/activity-list.xsd">';

    // Add login activities (the client checks for ACCOUNT_LOGIN type)
    for (let i = 0; i < loginActivities; i++) {
        const timestamp = new Date(Date.now() - (loginActivities - i) * 24 * 60 * 60 * 1000); // Simulate past logins
        activityXml += `
        <activity>
            <activity-type>ACCOUNT_LOGIN</activity-type>
            <timestamp>${timestamp.toISOString()}</timestamp>
            <metadata>
                <login-session-duration>600</login-session-duration>
            </metadata>
        </activity>`;
    }

    activityXml += '</activity-list>';

    console.log(`[${new Date().toISOString()}] Sending account activity response for ${accountId} with ${loginActivities} login activities`);
    res.set('Content-Type', 'application/xml');
    res.send(activityXml);
});

// Evolution endpoint
app.post('/bankfe/resources/evolution/:evolutionId', (req, res) => {
    const evolutionId = req.params.evolutionId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Evolution request for evolution ${evolutionId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers, 'Body:', req.body.toString());

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for evolution request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // IMPORTANT: the client inspects this response as a PLAIN STRING, not XML.
    // EvoGameSubStateGame.evolutionResultFromServer:
    //     if (String(data) == "success")              -> evolution succeeded
    //     else if (data.substr(0,5) != "error")       -> treated as a HINT (two ints)
    //     else                                        -> "server error" dialog
    // Returning <evolution-success/> lands in the HINT branch, which is why every
    // evolution used to silently fail. The body must be exactly "success".

    const body = req.body.toString();
    console.log(`[${new Date().toISOString()}] Evolution attempt data: ${body}`);

    const sendError = (code, why) => {
        console.log(`[${new Date().toISOString()}] Evolution ${evolutionId} rejected: ${why}`);
        res.set('Content-Type', 'text/plain');
        res.send(`error${code}:${why}`); // client shows substring(5, indexOf(':'))
    };

    const evolution = getEvolutionById(__dirname, evolutionId);
    if (!evolution) return sendError(404, 'unknown evolution');

    const user = users[session.accountId];
    if (!user) return sendError(404, 'account not found');

    // <evolution-attempt><source-asset-id>..</source-asset-id><em-asset-id>..</em-asset-id>*
    const sourceAssetId = (body.match(/<source-asset-id>([\s\S]*?)<\/source-asset-id>/) || [, ''])[1].trim();
    const emAssetIds = [...body.matchAll(/<em-asset-id>([\s\S]*?)<\/em-asset-id>/g)].map(m => m[1].trim()).filter(Boolean);

    const source = (user.nanovorInventory || []).find(n => String(n.assetId) === sourceAssetId);
    if (!source) return sendError(400, 'source nanovor not owned');

    if (Number(source.assetTypeId) !== Number(evolution.sourceTypeId)) {
        return sendError(400, 'nanovor does not match this evolution');
    }

    // Resolve submitted EM instances to their types. The client sends the circuit
    // arrangement, so duplicates are meaningful - match per instance, not per type.
    const owned = user.emInventory || [];
    const used = [];
    for (const instanceId of emAssetIds) {
        const em = owned.find(e => String(e.assetId) === instanceId && !used.includes(e));
        if (!em) return sendError(400, 'EM not owned');
        used.push(em);
    }

    // ---- grade the circuit --------------------------------------------------
    // The evo game is Mastermind: the player fills `slotCount` clamps from the
    // hopper palette and gets 5 attempts (EvoGameStateUI.NUM_CIRCUITS). Grading:
    //   green lamps = right EM type in the right slot
    //   yellow lamps = right EM type in the wrong slot
    // The client calls showHint(child(0), child(1) - child(0)), so we return
    // exact and (exact + partial).
    const guess = used.map(e => Number(e.assetTypeId));
    const solution = evolution.solution;

    if (guess.length !== solution.length) {
        return sendError(400, `expected ${solution.length} EMs, got ${guess.length}`);
    }

    let exact = 0;
    const leftoverGuess = [];
    const leftoverSolution = [];
    for (let i = 0; i < solution.length; i++) {
        if (guess[i] === solution[i]) exact++;
        else { leftoverGuess.push(guess[i]); leftoverSolution.push(solution[i]); }
    }
    // Partial credit, counting each unmatched solution entry at most once.
    let partial = 0;
    for (const g of leftoverGuess) {
        const at = leftoverSolution.indexOf(g);
        if (at !== -1) { leftoverSolution.splice(at, 1); partial++; }
    }

    if (exact !== solution.length) {
        // Not "success" and not starting with "error" -> the client treats this as
        // a hint and lights the ring. EMs are NOT consumed on a failed attempt;
        // the player gets 5 tries.
        console.log(`[${new Date().toISOString()}] Evolution ${evolutionId} wrong: ` +
                    `guess=[${guess}] exact=${exact} partial=${partial}`);
        res.set('Content-Type', 'application/xml');
        return res.send(`<evolution-hint><exact>${exact}</exact><total>${exact + partial}</total></evolution-hint>`);
    }

    // Solved - consume the EMs that were fed into the circuit
    user.emInventory = owned.filter(e => !used.includes(e));
    user.ems = user.emInventory.length;

    // Evolve in place: the instance keeps its id, but becomes the destination type.
    const destination = getVirmonMaster(__dirname, evolution.destinationTypeId);
    const previousName = source.name;
    source.assetTypeId = evolution.destinationTypeId;
    source.id = evolution.destinationTypeId;
    if (destination) {
        source.name = destination.name;
        source.faction = destination.faction;
    }
    source.lastEvolutionDate = formatDateForNanovor(new Date());
    // Per-evolution counters reset; the *-lifetime ones deliberately do not.
    source.killCount = 0;
    source.battleCount = 0;
    source.deathCount = 0;
    source.winCount = 0;

    user.nanovorCountUnique = new Set((user.nanovorInventory || []).map(n => n.assetTypeId)).size;
    saveUserData(session.accountId);

    console.log(`[${new Date().toISOString()}] Evolution ${evolutionId} OK: ` +
                `${previousName} -> ${source.name} (consumed ${used.length} EM(s), ${user.ems} left)`);

    // Exactly "success" - see the note at the top of this handler.
    res.set('Content-Type', 'text/plain');
    res.send('success');
});

// Nanoscopes associated with the account.
//
// AssociatedDevices.as reads <device id="..."/> as DIRECT children of the root and
// compares Number(id) with the id in the device's deviceid.bbb. A device missing
// from this list gets the Associate panel, whose "+" button deletes v1..v10 on
// the device immediately (DeviceManager.associateDevice) - so a device must be
// registered here (nanoscope-cli import) before anyone opens the Nanoscope screen.
app.get('/bankfe/resources/account/:accountId/device', (req, res) => {
    const accountId = req.params.accountId;
    const session = findSessionByToken(req.query.auth);
    if (!session || session.accountId !== accountId) {
        console.log(`[nanoscope] device list: invalid token for account ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }
    const user = users[accountId];
    if (!user) return res.status(404).send('<error>User not found</error>');

    const ids = (user.devices || []).map(d => nanoscope.normalizeDeviceId(d.deviceId));
    console.log(`[nanoscope] device list for ${accountId}: [${ids.join(', ')}]`);
    res.set('Content-Type', 'application/xml');
    res.send(`<devices>${ids.map(id => `<device id="${id}"/>`).join('')}</devices>`);
});

// Account asset endpoint - returns user's assets/collections
app.get('/bankfe/resources/account/:accountId/asset', (req, res) => {
    const accountId = req.params.accountId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Account asset request for ${accountId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    console.log(`[${new Date().toISOString()}] Verifying token for account asset request - auth: ${auth}, accountId: ${accountId}`);
    const session = findSessionByToken(auth);
    console.log(`[${new Date().toISOString()}] Session lookup result for account asset:`, session ? {accountId: session.accountId, loginToken: session.loginToken} : 'no session found');
    if (!session || session.accountId !== accountId) {
        console.log(`[${new Date().toISOString()}] Invalid token for account asset request - session: ${session ? session.accountId : 'none'}, accountId: ${accountId}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Return user's asset info
    const user = users[accountId];
    if (!user) {
        console.log(`[${new Date().toISOString()}] User not found for account asset request - accountId: ${accountId}`);
        return res.status(404).send('<error>User not found</error>');
    }

    // Return user's assets from their inventory
    // Use the existing inventory from user.nanovorInventory, don't override it
    const nanovorList = user.nanovorInventory || [];

    // Build XML for nanovor inventory in the exact format expected by VirmonData.parseXMLData
    let assetsXml = '';
    for (const nanovor of nanovorList) {
        // Format as asset with the exact structure expected by the client
        // The asset-id should be a unique instance identifier
        const assetId = `${nanovor.assetId || nanovor.id}`; // Use the assetId if available, otherwise use id

        // Use stored data if available, otherwise use defaults
        const productionNumber = nanovor.productionNumber || 1;
        const birthDate = nanovor.birthDate || formatDateForNanovor(new Date());
        const lastEvolutionDate = nanovor.lastEvolutionDate || formatDateForNanovor(new Date());

        assetsXml += `
    <asset id="${assetId}" xmlns:ns2="http://127.0.0.1:8443/xsd/asset-miscellany/asset-miscellany.xsd" xmlns:ns3="http://127.0.0.1:8443/xsd/asset-stat/asset-stat.xsd">
      <asset-type-category>virmon</asset-type-category>
      <asset-type-id>${nanovor.assetTypeId || nanovor.id}</asset-type-id>
      <asset-type-name>${nanovor.name || 'Unknown Nanovor'}</asset-type-name>
      <production-number>${productionNumber}</production-number>
      <birth-date>${birthDate}</birth-date>
      <last-evolution-date>${lastEvolutionDate}</last-evolution-date>
      <ns2:asset-miscellany>
        <ns2:nickname>${nanovor.nickname || ''}</ns2:nickname>
      </ns2:asset-miscellany>
      <ns3:asset-stat>
        <ns3:asset-type-id>${nanovor.assetTypeId || nanovor.id}</ns3:asset-type-id>
        <ns3:speed>${nanovor.speed ?? 10}</ns3:speed>
        <ns3:strength>${nanovor.strength ?? 100}</ns3:strength>
        <ns3:armor>${nanovor.armor ?? 5}</ns3:armor>
        <ns3:health>${nanovor.health ?? 100}</ns3:health>
        <ns3:kill-count>${nanovor.killCount || 0}</ns3:kill-count>
        <ns3:kill-count-lifetime>${nanovor.lifetimeKillCount || 0}</ns3:kill-count-lifetime>
        <ns3:battle-count>${nanovor.battleCount || 0}</ns3:battle-count>
        <ns3:battle-count-lifetime>${nanovor.lifetimeBattleCount || 0}</ns3:battle-count-lifetime>
        <ns3:death-count>${nanovor.deathCount || 0}</ns3:death-count>
        <ns3:death-count-lifetime>${nanovor.lifetimeDeathCount || 0}</ns3:death-count-lifetime>
        <ns3:magnamod-kill-count>${nanovor.magnamodKillCount || 0}</ns3:magnamod-kill-count>
        <ns3:magnamod-kill-count-lifetime>${nanovor.magnamodLifetimeKillCount || 0}</ns3:magnamod-kill-count-lifetime>
        <ns3:hexite-kill-count>${nanovor.hexiteKillCount || 0}</ns3:hexite-kill-count>
        <ns3:hexite-kill-count-lifetime>${nanovor.hexiteLifetimeKillCount || 0}</ns3:hexite-kill-count-lifetime>
        <ns3:velocitron-kill-count>${nanovor.velocitronKillCount || 0}</ns3:velocitron-kill-count>
        <ns3:velocitron-kill-count-lifetime>${nanovor.velocitronLifetimeKillCount || 0}</ns3:velocitron-kill-count-lifetime>
        <ns3:win-count>${nanovor.winCount || 0}</ns3:win-count>
        <ns3:win-count-lifetime>${nanovor.lifetimeWinCount || 0}</ns3:win-count-lifetime>
        <ns3:critical-hit-count>${nanovor.criticalHitCount || 0}</ns3:critical-hit-count>
        <ns3:whiff-count>${nanovor.whiffCount || 0}</ns3:whiff-count>
        <ns3:screen-star>${nanovor.isScreenStar || false}</ns3:screen-star>
        <ns3:scraped-by>${nanovor.isScrapedBy || false}</ns3:scraped-by>
        <ns3:all-attacks-used>${nanovor.areAllAttacksUsed || false}</ns3:all-attacks-used>
        <ns3:slacker>${nanovor.isSlacker || false}</ns3:slacker>
        <ns3:max-damage-game>${nanovor.maxDamageGame || 0}</ns3:max-damage-game>
        <ns3:max-damage-hit>${nanovor.maxDamageHit || 0}</ns3:max-damage-hit>
        <ns3:max-round-count>${nanovor.maxRoundCount || 0}</ns3:max-round-count>
      </ns3:asset-stat>
    </asset>`;
    }

    // EM assets ride in this same response - EMManager.assetListReceived consumes the
    // identical payload and picks out asset-type-category == "em". Excluding them left
    // the EM collection permanently empty and made every evolution unsatisfiable.
    //
    // EMData.parseXMLData only reads the default namespace (id attribute,
    // asset-type-name, birth-date, last-evolution-date) - no ns2/ns3 needed. The dates
    // must still parse, though: it calls _dBirthDate.getTime() with no null check, and
    // MakeDate.dateFromBankTime returns null for anything that doesn't match
    // YYYY-MM-DDTHH:MM:SS.mmm±HH:MM, so reuse the same formatter as above.
    const emList = user.emInventory || [];
    for (const em of emList) {
        const emAssetId = `${em.assetId || em.id}`;
        const emBirthDate = em.birthDate || formatDateForNanovor(new Date());
        const emEvolutionDate = em.lastEvolutionDate || emBirthDate;

        assetsXml += `
    <asset id="${emAssetId}">
      <asset-type-category>em</asset-type-category>
      <asset-type-id>${em.assetTypeId || em.id}</asset-type-id>
      <asset-type-name>${em.name || em.shortName || 'Unknown EM'}</asset-type-name>
      <production-number>${em.productionNumber || 1}</production-number>
      <birth-date>${emBirthDate}</birth-date>
      <last-evolution-date>${emEvolutionDate}</last-evolution-date>
    </asset>`;
    }

    const assetInfo = `<?xml version="1.0" encoding="UTF-8"?>
<asset-list>
${assetsXml}
</asset-list>`;

    console.log(`[${new Date().toISOString()}] Sending account asset response for ${accountId}`);
    console.log(`[${new Date().toISOString()}] Full user object nanovorInventory for account assets:`, JSON.stringify(user.nanovorInventory, null, 2));
    console.log(`[${new Date().toISOString()}] Account assets XML being sent:`, assetInfo);
    res.set('Content-Type', 'application/xml');
    res.send(assetInfo);
});

// Asset miscellany endpoint - for nickname and other asset-specific data
app.get('/bankfe/resources/asset/:assetId/miscellany', (req, res) => {
    const assetId = req.params.assetId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Asset miscellany request for asset ${assetId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for asset miscellany request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Return asset miscellany info (placeholder for nickname editor functionality)
    const miscellanyInfo = `
<asset-miscellany xmlns="http://127.0.0.1:8443/xsd/asset-miscellany/asset-miscellany.xsd">
</asset-miscellany>`;

    console.log(`[${new Date().toISOString()}] Sending asset miscellany response for asset ${assetId}`);
    res.set('Content-Type', 'application/xml');
    res.send(miscellanyInfo);
});

// Evolution list endpoint - returns all available evolutions for the user
app.get('/bankfe/resources/evolution', (req, res) => {
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Evolution list request, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for evolution list request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // The reconstructed evolution graph. This MUST NOT be empty: the client's
    // EvoManager feeds it into TreeViewMenu, which reads index 0 of each tree's
    // nanovor array with no null guard, so an empty list throws TypeError #1009
    // and silently blanks both the COLLECTION and EVOLVE screens.
    //
    // Note the shape is dictated by EvoManager.init(), NOT by
    // xsd/evolution/evolution-list.xsd - that XSD is a reconstruction and does
    // not match what the client actually parses. EvoManager strips namespaces
    // first, so no xmlns is needed here.
    let evolutionList;
    try {
        evolutionList = getEvolutionListXml(__dirname);
    } catch (err) {
        console.error(`[${new Date().toISOString()}] FAILED to build evolution list:`, err.message);
        return res.status(500).send('<error><type>evolution</type><message>could not build evolution data</message></error>');
    }

    console.log(`[${new Date().toISOString()}] Sending evolution list (${evolutionList.length} bytes)`);
    res.set('Content-Type', 'application/xml');
    res.send(evolutionList);
});

// Specific evolution endpoint - handles evolution attempts
app.get('/bankfe/resources/evolution/:evolutionId', (req, res) => {
    const evolutionId = req.params.evolutionId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Specific evolution request for ${evolutionId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for specific evolution request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Return evolution data (placeholder)
    const evolutionData = `
<evolution xmlns="http://127.0.0.1:8443/xsd/evolution/evolution.xsd">
  <evolution-id>${evolutionId}</evolution-id>
</evolution>`;

    console.log(`[${new Date().toISOString()}] Sending specific evolution response for ${evolutionId}`);
    res.set('Content-Type', 'application/xml');
    res.send(evolutionData);
});

// Retail/SKU resources endpoint for nanoMall
app.get('/bankfe/resources/retail', (req, res) => {
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] Retail/SKU list request, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for retail/SKU list request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // Contract lives in economy.buildSkuListXml(). The critical rule: <sku>
    // elements must be DIRECT children of the root. The old stub emitted an
    // empty <sku-list> with a default xmlns, so WaveList.init looped zero times -
    // that was the empty store.
    const skuList = buildSkuListXml();

    console.log(`[${new Date().toISOString()}] Sending SKU list (${PACKS.length} packs)`);
    res.set('Content-Type', 'application/xml');
    res.send(skuList);
});

// ---------------------------------------------------------------------------
// Nanocode redemption - GET /cpnfe/coupon/{code}?auth=
//
// Originally the codes printed on the physical toys, cards and tie-in books.
//
// The client (ModalNanocodeEntry.as:269-312) reads a <code> child:
//     0 = success  4 = invalid  5 = expired  7 = used too many times  8 = too early
// On 0 it calls refreshData() and re-reads the balance; grants are never
// returned inline, so everything is applied server-side before we answer.
//
// TWO TRAPS:
//  * int() of a missing or non-numeric <code> is 0, i.e. SUCCESS. Always emit
//    an explicit code, even on failure.
//  * This path does NOT run StripXmlNamespace, so a default xmlns on the root
//    would break the child("code") lookup. Emit no namespace.
// ---------------------------------------------------------------------------
function sendCouponCode(res, code, why) {
    console.log(`[${new Date().toISOString()}] Coupon result ${code}${why ? ' - ' + why : ''}`);
    res.set('Content-Type', 'application/xml');
    res.send(`<coupon-response><code>${code}</code></coupon-response>`);
}

app.get('/cpnfe/coupon/:code', (req, res) => {
    const raw = String(req.params.code || '').toUpperCase();
    const session = findSessionByToken(req.query.auth);
    console.log(`[${new Date().toISOString()}] Nanocode redemption attempt: ${raw}`);

    if (!session) return sendCouponCode(res, 4, 'invalid token');

    const user = users[session.accountId];
    if (!user) return sendCouponCode(res, 4, 'account not found');

    const entry = CODE_BY_VALUE.get(raw);
    if (!entry) return sendCouponCode(res, 4, 'unknown code');

    if (!user.redeemedCodes) user.redeemedCodes = {};
    const used = user.redeemedCodes[raw] || 0;
    if (entry.maxUses && used >= entry.maxUses) return sendCouponCode(res, 7, 'max uses reached');

    const now = formatDateForNanovor(new Date());
    const g = entry.grants || {};
    let summary = [];

    // A code may grant a whole pack, explicit asset-type-ids, nanocash, or any mix.
    if (g.pack) {
        const rolled = rollPack(__dirname, g.pack);
        if (rolled) {
            const minted = grantToUser(user, rolled, now);
            summary.push(`pack ${g.pack}: ${minted.nanovor.length} nanovor + ${minted.ems.length} EM(s)`);
        }
    }
    if (g.nanovor || g.ems) {
        const rolled = {
            nanovor: (g.nanovor || []).map(id => getVirmonMaster(__dirname, id)).filter(Boolean),
            ems: (g.ems || []).map(id => getEmMaster(__dirname, id)).filter(Boolean),
        };
        const minted = grantToUser(user, rolled, now);
        summary.push(`${minted.nanovor.length} nanovor + ${minted.ems.length} EM(s)`);
    }
    if (g.nanocash) {
        user.nanocash = (Number(user.nanocash) || 0) + g.nanocash;
        summary.push(`+${g.nanocash} nanocash (now ${user.nanocash})`);
    }

    user.redeemedCodes[raw] = used + 1;
    saveUserData(session.accountId);

    console.log(`[${new Date().toISOString()}] Nanocode ${raw} redeemed: ${summary.join('; ') || 'nothing'}`);
    return sendCouponCode(res, 0);
});

// Gift card - GET /gftfe/giftCard/{code}?auth=&zip=
// Same code semantics plus 13 = "has not been activated". Nanocash only: the
// client does NOT call refreshData() here, it just re-reads <token-balance>.
app.get('/gftfe/giftCard/:code', (req, res) => {
    const raw = String(req.params.code || '').toUpperCase();
    const session = findSessionByToken(req.query.auth);
    console.log(`[${new Date().toISOString()}] Gift card redemption attempt: ${raw} zip=${req.query.zip}`);

    if (!session) return sendCouponCode(res, 4, 'invalid token');
    const user = users[session.accountId];
    if (!user) return sendCouponCode(res, 4, 'account not found');

    const card = GIFT_BY_VALUE.get(raw);
    if (!card) return sendCouponCode(res, 4, 'unknown card');
    if (card.zip && String(req.query.zip || '') !== card.zip) return sendCouponCode(res, 13, 'zip mismatch');

    if (!user.redeemedCodes) user.redeemedCodes = {};
    const used = user.redeemedCodes[raw] || 0;
    if (card.maxUses && used >= card.maxUses) return sendCouponCode(res, 7, 'max uses reached');

    user.nanocash = (Number(user.nanocash) || 0) + card.nanocash;
    user.redeemedCodes[raw] = used + 1;
    saveUserData(session.accountId);

    console.log(`[${new Date().toISOString()}] Gift card ${raw}: +${card.nanocash} nanocash (now ${user.nanocash})`);
    return sendCouponCode(res, 0);
});

// Specific SKU purchase endpoint
app.post('/bankfe/resources/retail/:skuId', (req, res) => {
    const skuId = req.params.skuId;
    const auth = req.query.auth;

    console.log(`[${new Date().toISOString()}] SKU purchase request for ${skuId}, auth: ${auth}`);
    console.log(`Request details - Path: ${req.path}, Query:`, req.query, 'Headers:', req.headers, 'Body:', req.body.toString());

    // Verify token
    const session = findSessionByToken(auth);
    if (!session) {
        console.log(`[${new Date().toISOString()}] Invalid token for SKU purchase request - auth: ${auth}`);
        return res.status(401).send('<error>Invalid token</error>');
    }

    // NOTE: the request body is form-encoded "auth=<token>" even though the
    // client sets Content-Type: application/xml. Do not XML-parse it.
    //
    // Rejections MUST be a non-2xx status, not an error document.
    // NanoMallConnector only listens for IOErrorEvent, so a 200 carrying an
    // <error> body is read as a successful purchase of zero items: the client
    // plays the whole success animation and then shows an empty panel.
    const reject = (status, why) => {
        console.log(`[${new Date().toISOString()}] Purchase of SKU ${skuId} rejected: ${why}`);
        return res.status(status).send(`<error><type>retail</type><message>${why}</message></error>`);
    };

    const pack = PACK_BY_ID.get(Number(skuId));
    if (!pack) return reject(404, 'unknown SKU');

    const user = users[session.accountId];
    if (!user) return reject(404, 'account not found');

    // The client checks affordability before calling, so an honest client never
    // gets here short - but it is trivially spoofable, so enforce it anyway.
    const balance = Number(user.nanocash) || 0;
    if (balance < pack.price) return reject(402, `insufficient nanocash (${balance} < ${pack.price})`);

    const rolled = rollPack(__dirname, pack.id);
    if (!rolled) return reject(500, 'could not roll pack contents');

    // Mint BEFORE responding. The ids below are resolved by the client against
    // the asset list it re-fetches immediately after, and CollectionPanelItem
    // calls getEMData(id).getEMMasterData() with no null check - an id that
    // isn't in the refreshed inventory yet throws.
    const now = formatDateForNanovor(new Date());
    const minted = grantToUser(user, rolled, now);

    user.nanocash = balance - pack.price;
    saveUserData(session.accountId);

    // Only the id attribute and <asset-type-category> are read (CollectionPanel
    // .buildCollection). <asset> must be a direct child of the root.
    const rows = [
        ...minted.nanovor.map(n => `  <asset id="${n.assetId}"><asset-type-category>virmon</asset-type-category></asset>`),
        ...minted.ems.map(e => `  <asset id="${e.assetId}"><asset-type-category>em</asset-type-category></asset>`),
    ];
    const purchaseResponse = `<?xml version="1.0" encoding="UTF-8"?>\n<purchase-response>\n${rows.join('\n')}\n</purchase-response>`;

    console.log(`[${new Date().toISOString()}] Purchased "${pack.name}" (${pack.price}n): ` +
                `${minted.nanovor.length} nanovor + ${minted.ems.length} EM(s); ` +
                `balance ${balance} -> ${user.nanocash}`);
    minted.nanovor.forEach(n => console.log(`    nanovor ${n.name} [${n.rarity}] id=${n.assetId}`));
    minted.ems.forEach(e => console.log(`    EM      ${e.name} [${e.rarity}] id=${e.assetId}`));

    res.set('Content-Type', 'application/xml');
    res.send(purchaseResponse);
});


/// ---------------------------------------------------------------------------
// Nanoscope sync (the client's DeviceState screen).
//
// The handheld is a USB drive; the client copies files on and off it and calls
// these routes to move them to and from the server. Formats: nanoscope.js.
//
// What works and what can't yet:
//   - device list, association, jolt uploads: fully handled.
//   - sign/vinfo and sign/plyinfo must return bytes SIGNED for the device, and we
//     can't sign. They replay files captured from the device by
//     `node tools/nanoscope-cli.js import` (DeviceVault/). Anything else is refused,
//     so only nanovor imported from a device can go back onto that device.
//   - firmware, required files, minigames: device-manifest.xml lists none and a
//     firmware version of -1, so the client never pushes any of them.
//   - /device/:id/manifest, /device/:id/firmware/signature, /device/reset/*: 404 on
//     purpose. Those flows rewrite the device's firmware and keys.
//
// HAZARD: a transfer starts by deleting v1..v10 on the device and only then asks
// for each vinfo. A refused vinfo leaves the device short of nanovor; restore
// from a backup with nanoscope-cli.
// ---------------------------------------------------------------------------

// /device/* URLs carry ?auth= but mostly no account id; the token identifies it.
function deviceRequestUser(req, res, what) {
    const session = findSessionByToken(req.query.auth);
    const user = session && users[session.accountId];
    if (!user) {
        console.log(`[nanoscope] ${what}: invalid token`);
        res.status(401).send('<error>Invalid token</error>');
        return null;
    }
    return { accountId: session.accountId, user };
}

function findUserDevice(user, deviceId) {
    const want = nanoscope.normalizeDeviceId(deviceId);
    return (user.devices || []).find(d => nanoscope.normalizeDeviceId(d.deviceId) === want) || null;
}

function associateDeviceWithUser(user, parsedDeviceId, source) {
    if (!user.devices) user.devices = [];
    let entry = findUserDevice(user, parsedDeviceId.deviceId);
    if (!entry) {
        entry = { deviceId: parsedDeviceId.deviceId, associatedAt: new Date().toISOString(), source };
        user.devices.push(entry);
    }
    entry.firmware = parsedDeviceId.firmware;
    entry.lastSeenAt = new Date().toISOString();
    return entry;
}

// Body: the device's raw deviceid.bbb. Any 2xx counts as success. By the time
// this arrives the client has already deleted v1..v10 on the device.
app.post('/device/associate', (req, res) => {
    const ctx = deviceRequestUser(req, res, 'associate');
    if (!ctx) return;
    let parsed;
    try {
        parsed = nanoscope.parseDeviceId(Buffer.isBuffer(req.body) ? req.body : Buffer.alloc(0));
    } catch (err) {
        console.log(`[nanoscope] associate: unreadable deviceid.bbb (${err.message})`);
        return res.status(400).send('<error>Bad device id file</error>');
    }
    associateDeviceWithUser(ctx.user, parsed, 'client');
    saveUserData(ctx.accountId);
    console.log(`[nanoscope] associated device ${parsed.deviceId} (firmware field ${parsed.firmware}) with ${ctx.accountId}`);
    res.set('Content-Type', 'application/xml');
    res.send('<device-associate-success/>');
});

// Body: one raw jolts-N.bbb (jolt points earned in the device's minigames since
// the last successful upload). The client deletes the file only after a 2xx.
app.post('/device/:deviceId/jolt', (req, res) => {
    const ctx = deviceRequestUser(req, res, 'jolt upload');
    if (!ctx) return;
    const { accountId, user } = ctx;
    const deviceId = req.params.deviceId;
    if (!findUserDevice(user, deviceId)) {
        console.log(`[nanoscope] jolt upload: device ${deviceId} is not associated with ${accountId}`);
        return res.status(403).send('<error>Device not associated</error>');
    }
    const body = Buffer.isBuffer(req.body) ? req.body : Buffer.alloc(0);
    let jolts;
    try {
        jolts = nanoscope.parseJolts(body);
    } catch (err) {
        console.log(`[nanoscope] jolt upload: unreadable file (${err.message})`);
        return res.status(400).send('<error>Bad jolts file</error>');
    }
    deviceVault.archiveUpload(deviceId, 'jolts', body);

    // A failed upload is retried on the next sync, so the same file can arrive
    // twice. The device rewrites the tag with the content, so (device, session,
    // tag) identifies one upload.
    const key = `${nanoscope.normalizeDeviceId(deviceId)}:${jolts.session}:${jolts.tag}`;
    if (!user.deviceJoltUploads) user.deviceJoltUploads = [];
    if (user.deviceJoltUploads.includes(key)) {
        console.log(`[nanoscope] jolt upload ${key} was already credited - ignoring`);
    } else {
        // Credited as-is. The tag can't be verified yet, and the original server's
        // earn-rate cap (~1 jolt/sec, per DeviceJoltsUploadChainLoadee) isn't known
        // precisely enough to reproduce.
        user.speedJolts = (user.speedJolts || 0) + Math.max(0, jolts.speed);
        user.strengthJolts = (user.strengthJolts || 0) + Math.max(0, jolts.strength);
        user.armorJolts = (user.armorJolts || 0) + Math.max(0, jolts.armor);
        user.healthJolts = (user.healthJolts || 0) + Math.max(0, jolts.health);
        user.deviceJoltUploads.push(key);
        saveUserData(accountId);
        console.log(`[nanoscope] credited jolts from ${deviceId} to ${accountId}: speed +${jolts.speed}, strength +${jolts.strength}, ` +
            `armor +${jolts.armor}, health +${jolts.health}`);
    }
    res.set('Content-Type', 'application/xml');
    res.send('<device-jolt-success/>');
});

// Dead with the shipped client - DeviceBattleLogUploadChainLoadee deletes clog.bbb
// before reading it - but answered properly in case anything sends one.
// DeviceLogChainLoadee reads <total-updates> and <successful-updates>.
app.post('/device/:deviceId/battle-log', (req, res) => {
    const ctx = deviceRequestUser(req, res, 'battle-log upload');
    if (!ctx) return;
    const body = Buffer.isBuffer(req.body) ? req.body : Buffer.alloc(0);
    if (body.length) deviceVault.archiveUpload(req.params.deviceId, 'clog', body);
    console.log(`[nanoscope] battle log from ${req.params.deviceId}: ${body.length} bytes archived, not processed`);
    res.set('Content-Type', 'application/xml');
    res.send('<battle-log-result><total-updates>0</total-updates><successful-updates>0</successful-updates></battle-log-result>');
});

// Raw bytes, written unchanged to v<N>\vinfo.bbb on the device.
app.get('/device/:deviceId/asset/:assetId/sign/vinfo', (req, res) => {
    const ctx = deviceRequestUser(req, res, 'sign/vinfo');
    if (!ctx) return;
    const { deviceId, assetId } = req.params;
    if (!findUserDevice(ctx.user, deviceId)) {
        console.log(`[nanoscope] sign/vinfo: device ${deviceId} is not associated with ${ctx.accountId}`);
        return res.status(403).send('<error>Device not associated</error>');
    }
    if (!(ctx.user.nanovorInventory || []).some(n => String(n.assetId) === assetId)) {
        console.log(`[nanoscope] sign/vinfo: asset ${assetId} is not in ${ctx.accountId}'s collection`);
        return res.status(404).send('<error>No such asset</error>');
    }
    const blob = deviceVault.getVinfo(deviceId, assetId);
    if (!blob) {
        console.log(`[nanoscope] sign/vinfo: NO SIGNED COPY of asset ${assetId} for device ${deviceId}. ` +
            'Only nanovor imported from this device can go back onto it. The client has already ' +
            'cleared v1..v10 - restore them with nanoscope-cli.');
        return res.status(409).send('<error>No signed copy for this device</error>');
    }
    console.log(`[nanoscope] sign/vinfo: replaying captured vinfo for asset ${assetId} to device ${deviceId}`);
    res.set('Content-Type', 'application/octet-stream');
    res.send(blob);
});

// Raw bytes, written unchanged to plyinfo.bbb. On failure the client shows
// "Transfer Error" and goes Home before touching the device's copy.
app.get('/device/:deviceId/account/:accountId/sign/plyinfo', (req, res) => {
    const ctx = deviceRequestUser(req, res, 'sign/plyinfo');
    if (!ctx) return;
    const { deviceId, accountId } = req.params;
    if (ctx.accountId !== accountId || !findUserDevice(ctx.user, deviceId)) {
        console.log(`[nanoscope] sign/plyinfo: device ${deviceId} is not associated with ${accountId}`);
        return res.status(403).send('<error>Device not associated</error>');
    }
    const blob = deviceVault.getPlyinfo(deviceId);
    if (!blob) {
        console.log(`[nanoscope] sign/plyinfo: no captured plyinfo for device ${deviceId} - the server cannot sign one`);
        return res.status(404).send('<error>No signed player info for this device</error>');
    }
    console.log(`[nanoscope] sign/plyinfo: replaying captured plyinfo to device ${deviceId}`);
    res.set('Content-Type', 'application/octet-stream');
    res.send(blob);
});

// Never served: these rewrite the device's system manifest, firmware and keys.
// device-manifest.xml keeps the client from asking for the first two; the
// recovery flow (reset/*) is reachable from the write-error dialog.
app.get(['/device/:deviceId/manifest', '/device/:deviceId/firmware/signature', '/device/reset/*'], (req, res) => {
    console.log(`[nanoscope] refused ${req.path} - firmware/manifest/recovery are deliberately not served`);
    res.status(404).send('<error>Not available</error>');
});

// ---------------------------------------------------------------------------
// Dev / admin: import a Nanoscope into an account.
//
// Takes a live drive ("E:\\") or the files/ folder of a nanoscope-cli backup.
// Registers the device (so the client never shows the destructive Associate
// panel), adds its nanovor with their on-device asset ids and jolted stats,
// vaults the signed vinfo/plyinfo for replay, and copies sprites/sounds for
// types the served /device/characters tree lacks. Re-running is safe.
//
// Loopback-only and unauthenticated, like grant-ems.
//   POST /dev/nanoscope/import   {"account":"2072745562","root":"E:\\"}
// ---------------------------------------------------------------------------
app.post('/dev/nanoscope/import', (req, res) => {
    const remote = req.socket.remoteAddress || '';
    if (!/^(::1|::ffff:127\.0\.0\.1|127\.0\.0\.1)$/.test(remote)) {
        console.warn(`[dev] rejected nanoscope import from non-loopback address ${remote}`);
        return res.status(403).json({ error: 'dev endpoints are loopback-only' });
    }
    const { account, root } = req.body || {};
    const user = users[account];
    if (!user) return res.status(404).json({ error: `no such account: ${account}`, known: Object.keys(users) });

    let snap;
    try {
        snap = nanoscope.readDeviceRoot(String(root || ''));
    } catch (err) {
        return res.status(400).json({ error: err.message });
    }
    const deviceId = snap.device.deviceId;
    associateDeviceWithUser(user, snap.device, 'import');
    if (snap.plyinfo) deviceVault.putPlyinfo(deviceId, snap.plyinfo);
    if (!user.nanovorInventory) user.nanovorInventory = [];

    const now = formatDateForNanovor(new Date());
    const report = [];
    for (const n of snap.nanovor) {
        const p = n.parsed;
        const master = getVirmonMaster(__dirname, p.assetTypeId);
        if (!master) {
            report.push({ slot: `v${n.slot}`, assetId: p.assetId, error: `unknown asset-type-id ${p.assetTypeId}` });
            continue;
        }
        deviceVault.putVinfo(deviceId, n.vinfo);
        const characterAssets = nanoscope.harvestCharacterAssets(n.dir, p.assetTypeId, DEVICE_CHARACTERS_DIR);

        let inst = user.nanovorInventory.find(x => String(x.assetId) === p.assetId);
        const imported = !inst;
        if (!inst) {
            inst = {
                id: p.assetTypeId,
                name: master.name,
                type: 'virmon',
                assetTypeId: p.assetTypeId,
                assetId: p.assetId, // must equal the vinfo's u64 as decimal - see DeviceNanovorRetriever
                faction: master.faction,
                rarity: master.rarity,
                wave: master.wave,
                productionNumber: 1,
                birthDate: now,
                lastEvolutionDate: now,
                nickname: '',
                source: 'nanoscope',
            };
            user.nanovorInventory.push(inst);
        }
        // The device copy carries the stats as jolted on the handheld.
        Object.assign(inst, { speed: p.speed, strength: p.strength, armor: p.armor, health: p.health });

        report.push({
            slot: `v${n.slot}`,
            name: master.name,
            assetTypeId: p.assetTypeId,
            assetId: p.assetId,
            imported,
            characterAssets,
            // Can a transfer put it back? Needs the vaulted vinfo (just stored) and
            // the type's sprite/sound on the server.
            deviceReady: fs.existsSync(path.join(DEVICE_CHARACTERS_DIR, String(p.assetTypeId), 'manifest.xml')),
        });
    }
    saveUserData(account);

    console.log(`[dev] imported Nanoscope ${deviceId} into ${account}: ${report.filter(r => r.imported).length} new nanovor, ` +
        `${report.filter(r => r.deviceReady).length}/${report.length} device-ready`);
    res.json({
        device: { deviceId, firmware: snap.device.firmware },
        plyinfoVaulted: Boolean(snap.plyinfo),
        nanovor: report,
    });
});

// Manifest endpoints for version checking and updates
app.get('/bankfe/manifests/news', (req, res) => {
    console.log('News manifest requested');

    // Return sample news data
    const newsData = {
        "news": [
            {
                "id": 1,
                "title": "Welcome to Nanovor!",
                "content": "Welcome to the Nanovor game world. Enjoy your battles!",
                "date": new Date().toISOString().split('T')[0],
                "priority": "normal"
            }
        ]
    };

    res.json(newsData);
});

// Nanolog endpoint - might be needed for the NANOLOG state
app.get('/bankfe/manifests/nanolog', (req, res) => {
    console.log(`[${new Date().toISOString()}] Nanolog requested, Query:`, req.query, 'Headers:', req.headers);

    // Return empty nanolog response to allow client to continue
    const nanologResponse = `<?xml version="1.0" encoding="UTF-8"?>
<nanolog xmlns="http://127.0.0.1:8443/xsd/nanolog/nanolog.xsd">
    <entries>
        <!-- Placeholder for nanolog entries -->
    </entries>
</nanolog>`;

    console.log(`[${new Date().toISOString()}] Sending nanolog response`);
    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(nanologResponse);
});

// Additional nanolog endpoint that might be accessed directly
app.get('/nanolog', (req, res) => {
    console.log(`[${new Date().toISOString()}] Direct nanolog requested, Query:`, req.query, 'Headers:', req.headers);

    // Return empty nanolog response to allow client to continue
    const nanologResponse = `<?xml version="1.0" encoding="UTF-8"?>
<nanolog xmlns="http://127.0.0.1:8443/xsd/nanolog/nanolog.xsd">
    <entries>
        <!-- Placeholder for nanolog entries -->
    </entries>
</nanolog>`;

    console.log(`[${new Date().toISOString()}] Sending direct nanolog response`);
    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(nanologResponse);
});

// Endpoint to serve the nanolog XSD schema
app.get('/xsd/nanolog/nanolog.xsd', (req, res) => {
    console.log(`[${new Date().toISOString()}] Nanolog XSD schema requested, Query:`, req.query, 'Headers:', req.headers);

    const xsdPath = path.join(__dirname, 'xsd', 'nanolog', 'nanolog.xsd');

    if (fs.existsSync(xsdPath)) {
        const xsdContent = fs.readFileSync(xsdPath, 'utf8');
        console.log(`[${new Date().toISOString()}] Sending nanolog XSD schema`);
        res.set('Content-Type', 'application/xml; charset=utf-8');
        res.send(xsdContent);
    } else {
        console.log(`[${new Date().toISOString()}] Nanolog XSD schema not found at ${xsdPath}`);
        res.status(404).send('<error>XSD schema not found</error>');
    }
});

// Additional nanolog endpoint that might be accessed via bankfe
app.get('/bankfe/resources/nanolog', (req, res) => {
    console.log(`[${new Date().toISOString()}] BankFE nanolog requested, Query:`, req.query, 'Headers:', req.headers);

    // Return empty nanolog response to allow client to continue
    const nanologResponse = `<?xml version="1.0" encoding="UTF-8"?>
<nanolog xmlns="http://127.0.0.1:8443/xsd/nanolog/nanolog.xsd">
    <entries>
        <!-- Placeholder for nanolog entries -->
    </entries>
</nanolog>`;

    console.log(`[${new Date().toISOString()}] Sending bankfe nanolog response`);
    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(nanologResponse);
});

app.get('/bankfe/manifests/register.php', (req, res) => {
    console.log('Registration page requested');

    // Return registration page info
    res.set('Content-Type', 'text/html');
    res.send(`
        <html>
            <body>
                <h1>Nanovor Registration</h1>
                <p>Registration is handled by the game client.</p>
            </body>
        </html>
    `);
});

app.get('/bankfe/manifests/password_request.php', (req, res) => {
    console.log('Password reset requested');

    // Return password reset page info
    res.set('Content-Type', 'text/html');
    res.send(`
        <html>
            <body>
                <h1>Password Reset</h1>
                <p>Password reset is handled by the game client.</p>
            </body>
        </html>
    `);
});

app.get('/bankfe/manifests/nanolog', (req, res) => {
    console.log('Nanolog requested');

    // Return empty nanolog response
    res.json({});
});

app.get('/bankfe/manifests/nanocash.php', (req, res) => {
    console.log('Nanocash page requested');

    // Return nanocash page info
    res.set('Content-Type', 'text/html');
    res.send(`
        <html>
            <body>
                <h1>Nanocash Purchase</h1>
                <p>Nanocash purchase is handled by the game client.</p>
            </body>
        </html>
    `);
});

// Assets endpoint for news banner
// The 'news-banner' hook in Config/WebClient.xml points at
// /Assets/Client/NewsBanner.swf, but the only copy of that SWF shipped inside
// Client/Breadcrumbs/. Returning 404 here made HomeNewsController report
// "FAILED TO LOAD BANNER: Error #2036" (Load Never Completed) on every home
// screen, so map the hook path onto where the file actually lives.
app.get('/Assets/Client/NewsBanner.swf', (req, res) => {
    console.log('News banner SWF requested');

    const bannerPath = path.join(__dirname, 'Manifests', 'Assets', 'Client', 'Breadcrumbs', 'NewsBanner.swf');

    if (fs.existsSync(bannerPath)) {
        res.set('Content-Type', 'application/x-shockwave-flash');
        res.sendFile(bannerPath);
    } else {
        console.log(`News banner not found at ${bannerPath}`);
        res.status(404).send('News banner file not available');
    }
});

// Application manifest endpoint - serves the AppManifest.xml file
app.get('/AppManifest.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] AppManifest.xml requested - Query:`, req.query, 'Headers:', req.headers);

    // Read the AppManifest.xml file from the Manifests directory
    const manifestPath = path.join(__dirname, 'Manifests', 'AppManifest.xml');

    if (fs.existsSync(manifestPath)) {
        const manifestContent = fs.readFileSync(manifestPath, 'utf8');
        console.log(`[${new Date().toISOString()}] Sending AppManifest.xml`);
        res.set('Content-Type', 'application/xml; charset=utf-8');
        res.send(manifestContent);
    } else {
        console.log(`[${new Date().toISOString()}] AppManifest.xml not found at ${manifestPath}`);
        res.status(404).send('<error>Manifest file not found</error>');
    }
});

// Application manifest properties endpoint - serves the AppManifest-props.xml file
app.get('/AppManifest-props.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] AppManifest-props.xml requested - Query:`, req.query, 'Headers:', req.headers);

    // Read the AppManifest-props.xml file from the Manifests directory
    const manifestPropsPath = path.join(__dirname, 'Manifests', 'AppManifest-props.xml');

    if (fs.existsSync(manifestPropsPath)) {
        const manifestPropsContent = fs.readFileSync(manifestPropsPath, 'utf8');
        console.log(`[${new Date().toISOString()}] Sending AppManifest-props.xml`);
        res.set('Content-Type', 'application/xml; charset=utf-8');
        res.send(manifestPropsContent);
    } else {
        console.log(`[${new Date().toISOString()}] AppManifest-props.xml not found at ${manifestPropsPath}`);
        res.status(404).send('<error>Manifest properties file not found</error>');
    }
});

// Asset manifest endpoint - serves the manifest.xml file
app.get('/manifest.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] manifest.xml requested - Query:`, req.query, 'Headers:', req.headers);

    // Read the manifest.xml file from the Manifests directory
    const manifestPath = path.join(__dirname, 'Manifests', 'manifest.xml'); // Using the specific asset manifest file

    if (fs.existsSync(manifestPath)) {
        const manifestContent = fs.readFileSync(manifestPath, 'utf8');
        console.log(`[${new Date().toISOString()}] Sending manifest.xml`);
        res.set('Content-Type', 'application/xml; charset=utf-8');
        res.send(manifestContent);
    } else {
        console.log(`[${new Date().toISOString()}] manifest.xml not found at ${manifestPath}`);
        res.status(404).send('<error>Manifest file not found</error>');
    }
});

// Master data endpoints for nanovor definitions
app.get('/Assets/Client/Characters/virmon-master.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] virmon-master.xml requested - Query:`, req.query, 'Headers:', req.headers);

    // Read the virmon-master.xml file from the Characters directory
    const masterDataPath = path.join(__dirname, 'Manifests', 'Client', 'Characters', 'virmon-master.xml');

    if (fs.existsSync(masterDataPath)) {
        const masterDataContent = fs.readFileSync(masterDataPath, 'utf8');
        console.log(`[${new Date().toISOString()}] Sending virmon-master.xml`);
        res.set('Content-Type', 'application/xml; charset=utf-8');
        res.send(masterDataContent);
    } else {
        console.log(`[${new Date().toISOString()}] virmon-master.xml not found at ${masterDataPath}`);
        res.status(404).send('<error>Master data file not found</error>');
    }
});

app.get('/Assets/Client/Characters/virmon-master-value.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] virmon-master-value.xml requested - Query:`, req.query, 'Headers:', req.headers);

    // Read the virmon-master-value.xml file from the Characters directory
    const masterValuePath = path.join(__dirname, 'Manifests', 'Client', 'Characters', 'virmon-master-value.xml');

    if (fs.existsSync(masterValuePath)) {
        const masterValueContent = fs.readFileSync(masterValuePath, 'utf8');
        console.log(`[${new Date().toISOString()}] Sending virmon-master-value.xml`);
        res.set('Content-Type', 'application/xml; charset=utf-8');
        res.send(masterValueContent);
    } else {
        console.log(`[${new Date().toISOString()}] virmon-master-value.xml not found at ${masterValuePath}`);
        res.status(404).send('<error>Master value data file not found</error>');
    }
});

// Nanoscope system manifest, fetched three times per sync (no auth). The client reads
// three things, all as direct children of the root:
//   <firmware-version>  pushed when greater than the device's (DeviceFirmwareChainLoadee).
//                       -1 never triggers; an absent element reads as 0, which DOES
//                       trigger on a freshly associated device (version -1).
//   <file><name>        root files the device must have, else downloaded from
//                       /device/<name> and followed by a signed manifest.bbb.
//   <minigame-file><name> games copied from Assets\Device\minigames into g1..gN.
// Listing nothing makes all three steps no-ops, so a sync never overwrites the
// device's system files, games or firmware.
app.get('/device/device-manifest.xml', (req, res) => {
    console.log('[nanoscope] device-manifest.xml (firmware -1, no files, no minigames)');
    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send('<device-manifest><firmware-version>-1</firmware-version></device-manifest>');
});

// Serve the real asset tree. This used to be a blanket 404 that blackholed every
// /Assets/... request (~21,000 files) and silently shadowed the more specific
// handlers registered further down this file.
app.use('/Assets', express.static(path.join(__dirname, 'Manifests', 'Assets')));

// Per-type Nanoscope sprites and sounds: /device/characters/<typeId>/{manifest.xml,
// spr.v2z,nano.snd}. The client compares manifest.xml as text with its local copy
// and downloads all three when they differ. (Folder is "Characters" on disk - mind
// the case on a case-sensitive host.)
app.use('/device/characters', express.static(DEVICE_CHARACTERS_DIR), (req, res) => {
    // A miss here aborts a transfer AFTER the client has already cleared v1..v10.
    console.log(`[nanoscope] no device sprite/sound for ${req.path} - that nanovor type can't go onto a Nanoscope yet`);
    res.status(404).send('Not found');
});

// Download manager endpoints
app.get('/bankfe/manifests/*', (req, res) => {
    console.log(`[${new Date().toISOString()}] Manifest request: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Return empty manifest to allow download process to continue
    const emptyManifest = `<?xml version="1.0" encoding="UTF-8"?>
<manifest xmlns="http://127.0.0.1:8443/xsd/manifest/manifest.xsd">
</manifest>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(emptyManifest);
});

// (removed: /Assets/Client/* catch-all 404 - the express.static mount above now
// serves these, and falls through to a normal 404 for genuinely missing files)

// Download status endpoint that might be used by download manager
app.get('/bankfe/resources/download-status', (req, res) => {
    console.log(`[${new Date().toISOString()}] Download status request, Query:`, req.query, 'Headers:', req.headers);

    // Return success status to indicate downloads are complete
    const statusResponse = `<?xml version="1.0" encoding="UTF-8"?>
<download-status xmlns="http://127.0.0.1:8443/xsd/download-status/download-status.xsd">
    <status>complete</status>
    <progress>100</progress>
</download-status>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(statusResponse);
});

// Additional endpoint that might be used by download manager to check download progress
app.get('/bankfe/resources/download-progress', (req, res) => {
    console.log(`[${new Date().toISOString()}] Download progress request, Query:`, req.query, 'Headers:', req.headers);

    // Return immediate completion to allow login to proceed
    const progressResponse = `<?xml version="1.0" encoding="UTF-8"?>
<download-progress xmlns="http://127.0.0.1:8443/xsd/download-progress/download-progress.xsd">
    <files-downloaded>1</files-downloaded>
    <total-files>1</total-files>
    <bytes-downloaded>1000</bytes-downloaded>
    <total-bytes>1000</total-bytes>
    <status>complete</status>
</download-progress>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(progressResponse);
});

// Endpoint for asset manifest loading that might be required before login
app.get('/bankfe/resources/asset-manifests', (req, res) => {
    console.log(`[${new Date().toISOString()}] Asset manifests request, Query:`, req.query, 'Headers:', req.headers);

    // Return empty manifests to allow download process to continue
    const manifestsResponse = `<?xml version="1.0" encoding="UTF-8"?>
<asset-manifests xmlns="http://127.0.0.1:8443/xsd/asset-manifests/asset-manifests.xsd">
</asset-manifests>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(manifestsResponse);
});

// Catch-all for asset manifest related requests that might be needed
app.get('/bankfe/resources/manifests/*', (req, res) => {
    console.log(`[${new Date().toISOString()}] Asset manifest catch-all request: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Return a generic manifest response to allow download process to continue
    const genericManifest = `<?xml version="1.0" encoding="UTF-8"?>
<generic-manifest xmlns="http://127.0.0.1:8443/xsd/generic-manifest/generic-manifest.xsd">
</generic-manifest>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(genericManifest);
});

// Catch-all for any download-related requests
app.all('/bankfe/resources/download*', (req, res) => {
    console.log(`[${new Date().toISOString()}] Download-related request: ${req.path}, Method: ${req.method}, Query:`, req.query, 'Headers:', req.headers);

    // Return a success response to allow download process to complete
    const downloadResponse = `<?xml version="1.0" encoding="UTF-8"?>
<download-response xmlns="http://127.0.0.1:8443/xsd/download-response/download-response.xsd">
    <status>success</status>
    <message>Download completed</message>
</download-response>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(downloadResponse);
});

// Additional catch-all for asset-related requests
app.all('/bankfe/resources/asset*', (req, res) => {
    console.log(`[${new Date().toISOString()}] Asset-related request: ${req.path}, Method: ${req.method}, Query:`, req.query, 'Headers:', req.headers);

    // Return a generic asset response
    const assetResponse = `<?xml version="1.0" encoding="UTF-8"?>
<asset-response xmlns="http://127.0.0.1:8443/xsd/asset-response/asset-response.xsd">
    <status>success</status>
</asset-response>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(assetResponse);
});

// Endpoint for AppManifest.xml that the client is requesting.
//
// This MUST serve the genuine manifest, not a placeholder. Tab enablement on the
// home screen is driven entirely off the <Packages> section:
//   ApplicationManifestParser builds packageList from AppManifest.Packages.Package
//   -> ApplicationManager.isPackageOutdated() returns true when getPackage() is null
//   -> StatePackageStatusUpdater.populateReadyStates() skips that state
//   -> HeaderButtonRenderer never calls MainButton.toggleDisabled(false)
// A manifest with no <Packages> therefore greys out every tab except NANOLOG
// (which maps to PackageType.NONE and is short-circuited to always-ready).
app.get('/clientbin/data/AppManifest.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] AppManifest.xml requested via clientbin, Query:`, req.query);

    const manifestPath = path.join(__dirname, 'Manifests', 'AppManifest.xml');

    if (fs.existsSync(manifestPath)) {
        const manifestContent = fs.readFileSync(manifestPath, 'utf8');
        console.log(`[${new Date().toISOString()}] Sending AppManifest.xml (${manifestContent.length} bytes)`);
        res.set('Content-Type', 'application/xml; charset=utf-8');
        res.send(manifestContent);
    } else {
        console.error(`[${new Date().toISOString()}] AppManifest.xml NOT FOUND at ${manifestPath} - all tabs will stay greyed out`);
        res.status(404).send('<error>Manifest file not found</error>');
    }
});

// Endpoint for other manifest files that might be requested
app.get('/clientbin/data/*', (req, res) => {
    console.log(`[${new Date().toISOString()}] Clientbin data request: ${req.path}, Query:`, req.query, 'Headers:', req.headers);

    // Return a generic response for any clientbin data requests
    res.status(404).send('<error>Resource not found</error>');
});

// Add endpoints for common manifest files that might be requested
app.get('/manifests/AppManifest.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] AppManifest.xml requested, Query:`, req.query, 'Headers:', req.headers);

    const appManifest = `<?xml version="1.0" encoding="UTF-8"?>
<AppManifest xmlns="http://127.0.0.1:8443/xsd/app-manifest/app-manifest.xsd">
    <version>1.2.0</version>
    <assets>
        <!-- Placeholder for required assets -->
    </assets>
</AppManifest>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(appManifest);
});

app.get('/manifests/AppManifest-props.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] AppManifest-props.xml requested, Query:`, req.query, 'Headers:', req.headers);

    const appManifestProps = `<?xml version="1.0" encoding="UTF-8"?>
<AppManifest-props xmlns="http://127.0.0.1:8443/xsd/app-manifest-props/app-manifest-props.xsd">
    <properties>
        <!-- Placeholder for app properties -->
    </properties>
</AppManifest-props>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(appManifestProps);
});

app.get('/manifests/manifest.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] manifest.xml requested, Query:`, req.query, 'Headers:', req.headers);

    const manifest = `<?xml version="1.0" encoding="UTF-8"?>
<manifest xmlns="http://127.0.0.1:8443/xsd/manifest/manifest.xsd">
    <assets>
        <!-- Placeholder for assets -->
    </assets>
</manifest>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(manifest);
});

// Main manifest file that might be requested first by the download manager
app.get('/Assets/Client/manifest.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] Main client manifest requested, Query:`, req.query, 'Headers:', req.headers);

    // Return a manifest indicating no downloads are needed to allow process to continue
    const mainManifest = `<?xml version="1.0" encoding="UTF-8"?>
<asset-manifest xmlns="http://127.0.0.1:8443/xsd/asset-manifest/asset-manifest.xsd">
    <assets>
        <!-- Empty assets list to indicate no downloads needed -->
    </assets>
    <download-required>false</download-required>
</asset-manifest>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(mainManifest);
});

// Root manifest file that might be needed
app.get('/Assets/manifest.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] Root manifest requested, Query:`, req.query, 'Headers:', req.headers);

    // Return a root manifest indicating no downloads are needed
    const rootManifest = `<?xml version="1.0" encoding="UTF-8"?>
<root-manifest xmlns="http://127.0.0.1:8443/xsd/root-manifest/root-manifest.xsd">
    <manifests>
        <!-- No additional manifests needed -->
    </manifests>
    <download-required>false</download-required>
</root-manifest>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(rootManifest);
});

// Manifest properties file that the RootMetadataChecker looks for first
app.get('/Assets/manifest-props.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] Manifest properties file requested, Query:`, req.query, 'Headers:', req.headers);

    // Return properties indicating manifests are up to date
    const manifestProps = `<?xml version="1.0" encoding="UTF-8"?>
<manifest-props xmlns="http://127.0.0.1:8443/xsd/manifest-props/manifest-props.xsd">
    <valid>true</valid>
    <last-checked>${Date.now()}</last-checked>
    <needs-update>false</needs-update>
    <assets-loaded>true</assets-loaded>
</manifest-props>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(manifestProps);
});

// Client manifest properties file
app.get('/Assets/Client/manifest-props.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] Client manifest properties requested, Query:`, req.query, 'Headers:', req.headers);

    // Return properties indicating client manifests are up to date
    const clientManifestProps = `<?xml version="1.0" encoding="UTF-8"?>
<client-manifest-props xmlns="http://127.0.0.1:8443/xsd/client-manifest-props/client-manifest-props.xsd">
    <valid>true</valid>
    <last-checked>${Date.now()}</last-checked>
    <needs-update>false</needs-update>
    <assets-loaded>true</assets-loaded>
</client-manifest-props>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(clientManifestProps);
});

// Additional manifest endpoint that might be the first one requested by the download manager
app.get('/bankfe/manifests/main-manifest.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] Main manifest requested via bankfe, Query:`, req.query, 'Headers:', req.headers);

    // Return a manifest that will trigger the download manager to consider manifests loaded
    const mainManifest = `<?xml version="1.0" encoding="UTF-8"?>
<main-manifest xmlns="http://127.0.0.1:8443/xsd/main-manifest/main-manifest.xsd">
    <assets-loaded>true</assets-loaded>
    <download-required>false</download-required>
    <asset-groups>
        <!-- Indicate that all required asset groups are already available -->
    </asset-groups>
</main-manifest>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(mainManifest);
});

// Another common manifest pattern that might be requested
app.get('/bankfe/manifests/master-manifest.xml', (req, res) => {
    console.log(`[${new Date().toISOString()}] Master manifest requested, Query:`, req.query, 'Headers:', req.headers);

    // Return a master manifest indicating all assets are up-to-date
    const masterManifest = `<?xml version="1.0" encoding="UTF-8"?>
<master-manifest xmlns="http://127.0.0.1:8443/xsd/master-manifest/master-manifest.xsd">
    <status>ready</status>
    <assets-complete>true</assets-complete>
    <next-action>proceed</next-action>
</master-manifest>`;

    res.set('Content-Type', 'application/xml; charset=utf-8');
    res.send(masterManifest);
});

// Test endpoint to simulate login process
app.get('/test-login/:username', (req, res) => {
    const username = req.params.username;
    console.log(`Test login request for user: ${username}`);

    // Generate a login token
    const loginToken = generateToken();
    const accountId = generateAccountId(username);

    // First, try to load existing user data from file
    const existingUser = loadUserDataByUsername(username);
    if (!existingUser) {
        // User doesn't exist in file, create a new profile
        if (!users[accountId]) {
            users[accountId] = createUserProfile(accountId, username);

            // Save the new user data to file
            saveUserData(accountId);
        }
    }
    // If existingUser exists, it's already loaded into the users object by loadUserDataByUsername

    // Create session
    const sessionId = uuidv4();
    sessions[sessionId] = {
        accountId: accountId,
        loginToken: loginToken,
        expires: Date.now() + 30 * 60 * 1000, // 30 minutes
        ip: req.ip
    };

    res.json({
        success: true,
        accountId: accountId,
        loginToken: loginToken,
        message: `User ${username} created and ready for login`
    });
});

// --- Flash socket security policy -------------------------------------------
// Flash Player refuses to open a raw socket until it has been granted
// permission by a policy file. It looks for one on TCP 843 first, and falls
// back to sending <policy-file-request/> on the target port itself.
// The response MUST be NUL-terminated.
const FLASH_SOCKET_POLICY =
    '<?xml version="1.0"?>' +
    '<!DOCTYPE cross-domain-policy SYSTEM "/xml/dtds/cross-domain-policy.dtd">' +
    '<cross-domain-policy>' +
    '<site-control permitted-cross-domain-policies="master-only"/>' +
    '<allow-access-from domain="*" to-ports="*"/>' +
    '</cross-domain-policy>\0';

const policyPort = 843;
const policyServer = net.createServer((socket) => {
    console.log('=== FLASH POLICY CONNECTION from', socket.remoteAddress, '===');
    socket.on('data', (data) => {
        console.log('Policy request:', JSON.stringify(data.toString()));
        socket.write(FLASH_SOCKET_POLICY);
        socket.end();
    });
    socket.on('error', (err) => console.error('Policy socket error:', err.message));
    // Some Flash builds connect and wait without sending anything.
    socket.setTimeout(3000, () => { try { socket.write(FLASH_SOCKET_POLICY); } catch (e) {} socket.end(); });
});

// SmartFoxServer TCP Socket Implementation
const sfsPort = 9339;
// ---------------------------------------------------------------------------
// SFS 1.x extension-response encoding
//
// The client asks for JSON extension messages (AbstractSmartFoxGameService.as:30
// passes SmartFoxClient.XTMSG_TYPE_JSON). ExtHandler.as only populates dataObj
// from `param1.o` on the JSON branch; its XML branch runs the body through
// SFS's ObjectSerializer, which cannot read a CDATA JSON blob and yields null.
//
// So `<msg t="xt">...<![CDATA[{...}]]></msg>` arrives with dataObj == null and
// every service logs "command: undefined". The wire format the client actually
// parses is a raw JSON frame:  {"t":"xt","b":{"o":{...}}}\0
//
// Rather than rewrite 150+ response strings, re-encode them at the write
// boundary. Sys messages ("<msg t='sys'>") stay XML - SysHandler expects XML.
// ---------------------------------------------------------------------------

// SFS 1.x message terminator. Defined via fromCharCode so it survives any editor
// or tooling that would otherwise mangle a literal NUL in source.
const SFS_FRAME_TERMINATOR = String.fromCharCode(0);

// Guard against a peer that never sends a terminator. Real frames are a few KB at most.
const MAX_SFS_BUFFER = 1024 * 1024;

// Pull a brace-balanced JSON object out of `s` starting at/after `from`.
// Brace counting (rather than searching for "]]>") means the 18 responses with
// malformed CDATA terminators still encode correctly.
function extractJsonObject(s, from) {
    const start = s.indexOf('{', from);
    if (start === -1) return null;
    let depth = 0, inStr = false, esc = false;
    for (let i = start; i < s.length; i++) {
        const c = s[i];
        if (esc) { esc = false; continue; }
        if (c === '\\') { if (inStr) esc = true; continue; }
        if (c === '"') { inStr = !inStr; continue; }
        if (inStr) continue;
        if (c === '{') depth++;
        else if (c === '}' && --depth === 0) return s.slice(start, i + 1);
    }
    return null;
}

// `<msg t="xt">..<![CDATA[{json}]]>..</msg>\0`  ->  `{"t":"xt","b":{"o":{json}}}\0`
// Returns null for anything that isn't an xt+CDATA frame, so it passes through.
function xmlXtToJsonFrame(str) {
    if (typeof str !== 'string') return null;
    if (!/^\s*<msg\s+t=["']xt["']/.test(str)) return null;
    const cd = str.indexOf('<![CDATA[');
    if (cd === -1) return null;
    const raw = extractJsonObject(str, cd + 9);
    if (raw === null) {
        console.error('XT ENCODE: no JSON object found in CDATA:', str.slice(0, 200));
        return null;
    }
    try {
        return JSON.stringify({ t: 'xt', b: { o: JSON.parse(raw) } }) + '\x00';
    } catch (e) {
        console.error('XT ENCODE: bad JSON in CDATA:', e.message, '|', raw.slice(0, 200));
        return null;
    }
}

const sfsServer = net.createServer((socket) => {
    console.log('=== NEW SMARTFOXSERVER CONNECTION ===');
    console.log('New SmartFoxServer connection from:', socket.remoteAddress);
    console.log('Remote address:', socket.remoteAddress, 'Remote port:', socket.remotePort);
    console.log('Local address:', socket.localAddress, 'Local port:', socket.localPort);

    // Store socket reference
    socket.id = uuidv4();
    socket.loggedIn = false;
    socket.userId = null;
    socket.userName = null;
    socket.activeRoomId = -1;
    socket.activeBattle = null;

    // SFS 1.x frames messages as UTF-8 text terminated by a NUL byte. A single TCP
    // chunk may contain several frames, or only part of one, so we accumulate here
    // and only dispatch complete frames. See the framing block in socket.on('data').
    socket.sfsBuffer = '';

    // Re-encode XML-wrapped extension responses as the JSON frames the client
    // actually parses. See xmlXtToJsonFrame above. Everything else passes through.
    const rawWrite = socket.write.bind(socket);
    socket.write = function (chunk, ...rest) {
        if (typeof chunk === 'string') {
            const jsonFrame = xmlXtToJsonFrame(chunk);
            if (jsonFrame !== null) {
                console.log('XT ->', jsonFrame.replace(/\x00/g, '\\x00'));
                return rawWrite(jsonFrame, ...rest);
            }
        }
        return rawWrite(chunk, ...rest);
    };

    socket.on('data', (data) => {
        const message = data.toString();
        console.log(`>>> SFS DATA RECEIVED from ${socket.remoteAddress}:${socket.remotePort} >>>`);
        console.log(`Message length: ${message.length}, Raw: ${message.substring(0, 200)}...`);
        console.log(`Socket state - loggedIn: ${socket.loggedIn}, userId: ${socket.userId}, userName: ${socket.userName}, activeRoomId: ${socket.activeRoomId}`);

        // Flash asks for a socket policy before it will talk to a raw socket.
        // It tries port 843 first (see policyServer below); if that fails it
        // sends <policy-file-request/> inline on the target port. Answer both.
        if (message.indexOf('<policy-file-request') !== -1) {
            console.log('*** FLASH POLICY FILE REQUEST (inline on game port) ***');
            socket.write(FLASH_SOCKET_POLICY);
            return;
        }

        // Check if this is an HTTP request (starts with GET, POST, etc.)
        if (message.startsWith('GET ') || message.startsWith('POST ') || message.startsWith('PUT ') || message.startsWith('DELETE ') || message.startsWith('HEAD ')) {
            console.log('*** HTTP REQUEST DETECTED ***');
            console.log('Client is sending HTTP request to SmartFoxServer port - this is likely a manifest download attempt');

            // Parse the HTTP request to get the path
            const lines = message.split('\r\n');
            const requestLine = lines[0];
            const pathMatch = requestLine.match(/^GET (\S+)/);

            if (pathMatch) {
                const path = pathMatch[1];

                // Handle manifest file requests by serving from the Manifests directory
                if (path.includes('AppManifest.xml')) {
                    console.log('Serving AppManifest.xml from Manifests directory');

                    // Read the actual AppManifest.xml file from the Manifests directory
                    const fs = require('fs');
                    const pathModule = require('path');

                    try {
                        // Map the client request path to the server's Manifests directory
                        let filePath = pathModule.join(__dirname, 'Manifests', 'AppManifest.xml');

                        // Check if the file exists
                        if (fs.existsSync(filePath)) {
                            const fileContent = fs.readFileSync(filePath, 'utf8');

                            const httpResponse = 'HTTP/1.1 200 OK\r\n' +
                                               'Content-Type: application/xml\r\n' +
                                               'Content-Length: ' + Buffer.byteLength(fileContent, 'utf8') + '\r\n' +
                                               'Connection: keep-alive\r\n' +
                                               '\r\n' +
                                               fileContent;

                            socket.write(httpResponse);
                            console.log('Sent actual AppManifest.xml from Manifests directory');
                            return;
                        } else {
                            console.log('AppManifest.xml not found in Manifests directory, sending default');
                            // Fall back to default response if file doesn't exist
                        }
                    } catch (error) {
                        console.error('Error reading AppManifest.xml:', error);
                        // Fall back to default response if there's an error
                    }
                }
                // Handle other manifest file requests
                else if (path.includes('/clientbin/data/') || path.includes('manifest')) {
                    console.log(`Serving manifest file from path: ${path}`);

                    const fs = require('fs');
                    const pathModule = require('path');

                    try {
                        // Extract filename from the path (remove query parameters)
                        const cleanPath = path.split('?')[0]; // Remove query parameters like ?killcache=...
                        const fileName = cleanPath.split('/').pop();

                        // Try multiple possible locations for the manifest file
                        let filePath = null;

                        // First, try the main Manifests directory
                        filePath = pathModule.join(__dirname, 'Manifests', fileName);
                        if (!fs.existsSync(filePath)) {
                            // Then try the Assets subdirectory
                            filePath = pathModule.join(__dirname, 'Manifests', 'Assets', fileName);
                            if (!fs.existsSync(filePath)) {
                                // Then try the Assets/Client subdirectory
                                filePath = pathModule.join(__dirname, 'Manifests', 'Assets', 'Client', fileName);
                                if (!fs.existsSync(filePath)) {
                                    // If not found in any of these locations, try to match partial names
                                    const manifestDir = pathModule.join(__dirname, 'Manifests');
                                    const files = fs.readdirSync(manifestDir);
                                    for (const file of files) {
                                        if (file.toLowerCase().includes(fileName.toLowerCase())) {
                                            filePath = pathModule.join(manifestDir, file);
                                            break;
                                        }
                                    }

                                    if (!filePath) {
                                        // Check Assets directory
                                        const assetsDir = pathModule.join(__dirname, 'Manifests', 'Assets');
                                        if (fs.existsSync(assetsDir)) {
                                            const assetFiles = fs.readdirSync(assetsDir);
                                            for (const file of assetFiles) {
                                                if (file.toLowerCase().includes(fileName.toLowerCase())) {
                                                    filePath = pathModule.join(assetsDir, file);
                                                    break;
                                                }
                                            }

                                            if (!filePath) {
                                                // Check Assets/Client directory
                                                const clientDir = pathModule.join(__dirname, 'Manifests', 'Assets', 'Client');
                                                if (fs.existsSync(clientDir)) {
                                                    const clientFiles = fs.readdirSync(clientDir);
                                                    for (const file of clientFiles) {
                                                        if (file.toLowerCase().includes(fileName.toLowerCase())) {
                                                            filePath = pathModule.join(clientDir, file);
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Check if the file exists in any of the checked locations
                        if (filePath && fs.existsSync(filePath)) {
                            const fileContent = fs.readFileSync(filePath, 'utf8');

                            const httpResponse = 'HTTP/1.1 200 OK\r\n' +
                                               'Content-Type: application/xml\r\n' +
                                               'Content-Length: ' + Buffer.byteLength(fileContent, 'utf8') + '\r\n' +
                                               'Connection: keep-alive\r\n' +
                                               '\r\n' +
                                               fileContent;

                            socket.write(httpResponse);
                            console.log(`Sent actual ${fileName} from ${filePath}`);
                            return;
                        } else {
                            console.log(`${fileName} not found in any manifest directories`);
                        }
                    } catch (error) {
                        console.error(`Error reading manifest file ${path}:`, error);
                    }
                }
            }

            // For other requests, send 404
            const httpResponse = 'HTTP/1.1 404 Not Found\r\n' +
                               'Content-Type: text/html\r\n' +
                               'Content-Length: 134\r\n' +
                               'Connection: keep-alive\r\n' +
                               '\r\n' +
                               '<html><body>404 - Resource not found. This is a SmartFoxServer port. Available: /clientbin/data/AppManifest.xml</body></html>';

            socket.write(httpResponse);
            console.log('Sent HTTP response for manifest request');
            return;
        }

        // ---------------------------------------------------------------------
        // SFS 1.x framing: messages are NUL-terminated, and a TCP chunk carries
        // zero or more complete frames plus possibly a partial trailing one.
        //
        // Note String.prototype.trim() does NOT strip NUL (it is a control
        // character, not whitespace), which is why JSON.parse used to fail with
        // "Unexpected non-whitespace character after JSON at position N" on every
        // extension command. Splitting on NUL is what actually removes it.
        // ---------------------------------------------------------------------
        socket.sfsBuffer += message;

        const frames = socket.sfsBuffer.split(SFS_FRAME_TERMINATOR);
        socket.sfsBuffer = frames.pop(); // trailing partial frame (or '' if the chunk ended cleanly)

        if (socket.sfsBuffer.length > MAX_SFS_BUFFER) {
            console.error(`SFS buffer overflow (${socket.sfsBuffer.length} bytes) without a terminator - dropping buffer`);
            socket.sfsBuffer = '';
        }

        for (const frame of frames) {
            const msg = frame.trim();
            if (!msg) continue;

            // Per-frame isolation: the global uncaughtException handler would keep
            // the process alive, but it would abandon the remaining frames in this
            // chunk. Catching here means one bad frame costs only that frame.
            try {
                if (msg.startsWith('<')) {
                    console.log('Processing as XML message');
                    handleXmlMessage(socket, msg);
                } else if (msg.startsWith('{')) {
                    console.log('Processing as JSON message');
                    handleJsonMessage(socket, msg);
                } else if (msg.startsWith('%')) {
                    console.log('Processing as String message');
                    handleStringMessage(socket, msg);
                } else {
                    console.log('Unknown message type received');
                    console.log('Raw frame:', msg.substring(0, 500));
                }
            } catch (err) {
                console.error('Error handling SFS frame:', err);
                console.error('Offending frame:', msg.substring(0, 500));
            }
        }
    });

    // Add connection debugging
    socket.on('connect', () => {
        console.log(`SFS socket connected from ${socket.remoteAddress}:${socket.remotePort}`);
    });

    socket.on('ready', () => {
        console.log(`SFS socket ready from ${socket.remoteAddress}:${socket.remotePort}`);
    });


    // When a client connects to the SFS server, we need to handle the connection sequence properly
    // The client will send a verChk message first, which we handle in the XML message handler
    // We should NOT send any response immediately upon connection
    // The responses will be sent when the client sends specific messages
    console.log(`SFS socket connection established for ${socket.remoteAddress}:${socket.remotePort}`);

    // Debugging: Log when connection is established
    console.log(`DEBUG: SmartFoxServer connection established from ${socket.remoteAddress}:${socket.remotePort}`);
    console.log(`DEBUG: Waiting for verChk message from client...`);

    
    socket.on('close', () => {
        console.log(`=== SOCKET CONNECTION CLOSED ===`);
        console.log(`Connection closed for ${socket.userName || socket.id} (ID: ${socket.id})`);
        console.log(`Socket state at close - loggedIn: ${socket.loggedIn}, userId: ${socket.userId}, activeRoomId: ${socket.activeRoomId}`);

        // Drop just this connection. The client holds four of them, so the user is
        // only really offline once the last one goes - otherwise the first socket to
        // close would mark them offline while three are still active.
        const remainingConnections = unregisterUserSocket(socket);

        if (socket.userId && users[socket.userId] && remainingConnections === 0) {
            users[socket.userId].online = false;

            // Save user data when they fully disconnect
            saveUserData(socket.userId);
        }

        // Remove user from any rooms they were in
        if (socket.activeRoomId !== -1) {
            for (const roomId in gameRooms) {
                const room = gameRooms[roomId];
                if (room.id === socket.activeRoomId) {
                    console.log(`Removing user ${socket.userId} from room ${socket.activeRoomId}`);
                    // Remove user from room
                    room.users = room.users.filter(user => user.id !== socket.userId);
                    // Decrease user count
                    if (room.userCount > 0) room.userCount--;
                    break;
                }
            }
        }
        socket.activeRoomId = -1;

        // Remove user from any battles they were in
        if (socket.activeBattle) {
            const battle = battleRooms[socket.activeBattle];
            if (battle) {
                // Remove player from battle
                battle.players = battle.players.filter(p => p.id !== socket.userId);

                // If there's only one player left, end the game
                if (battle.players.length <= 1) {
                    battle.gameState = 'finished';

                    // Notify remaining players that the game is over
                    for (const player of battle.players) {
                        const gameOverMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameOver","winnerId":"${battle.players[0]?.id || ''}","results":"Game ended due to player disconnect"}]]></body></msg>\x00`;

                        // In a real implementation, we would send this to each player's socket
                        // For now, we'll just log it
                        console.log(`Game over message for remaining player: ${player.name}`);
                    }
                }

                // Clean up the battle if it's empty
                if (battle.players.length === 0) {
                    delete battleRooms[socket.activeBattle];
                }
            }
        }
        socket.activeBattle = null;

        // (socket already removed from socketMap at the top of this handler)
        console.log(`=== SOCKET CONNECTION CLOSED COMPLETE ===`);
    });
    
    socket.on('error', (err) => {
        console.error('=== SOCKET ERROR ===');
        console.error(`Socket error for ${socket.userName || socket.id} (ID: ${socket.id}):`, err);
        console.error(`Socket state at error - loggedIn: ${socket.loggedIn}, userId: ${socket.userId}, activeRoomId: ${socket.activeRoomId}`);
        console.error('==================');
    });
});

function handleXmlMessage(socket, message) {
    // Add debugging to see incoming XML messages
    console.log(`DEBUG: Received XML message from client: ${message.substring(0, 200)}...`);

    // Parse the XML message
    parseString(message, (err, result) => {
        if (err) {
            console.error('Error parsing XML:', err);
            console.log('Raw message:', message);
            return;
        }

        console.log(`DEBUG: Parsed XML result keys:`, Object.keys(result || {}));

        // Safely extract the action from the XML
        let action = null;
        let body = null;
        let msg = null;

        try {
            msg = result.msg;
            console.log(`DEBUG: XML message structure - msg exists: ${!!msg}, body exists: ${!!(msg && msg.body)}, body length: ${(msg && msg.body) ? msg.body.length : 0}`);

            if (!msg || !msg.body || !msg.body[0]) {
                console.error('Invalid XML structure - missing msg.body[0]:', result);
                return;
            }

            body = msg.body[0];

            // Check if body has attributes (accessed via $ in xml2js)
            if (body.$ && body.$.action) {
                action = body.$.action;
            } else {
                // Some actions might be stored differently in the parsed XML
                // Check for other possible locations of the action
                if (body['@'] && body['@'].action) {
                    action = body['@'].action;
                } else if (msg.body[0]['@action']) {
                    action = msg.body[0]['@action'];
                }
            }
        } catch (parseErr) {
            console.error('Error extracting action from XML:', parseErr);
            console.log('Full XML message:', message);
            console.log('Parsed result:', result);
            return;
        }

        console.log(`Processing XML action: ${action}`);
        console.log(`Full XML message: ${message}`);

        switch (action) {
            case 'verChk':
                // Version check - respond with version compatibility check
                // The client expects a verChk response to confirm version compatibility
                console.log('DEBUG: Processing verChk request from client');
                const verResponse = '<msg t="sys"><body action="verChk" r="0"><result v="156"/></body></msg>\x00';
                console.log('Sending verChk response:', verResponse.replace(/\x00/g, '\\x00'));
                socket.write(verResponse);

                // After version check, send apiOK to indicate connection is established
                const apiOKResponse = '<msg t="sys"><body action="apiOK" r="0"></body></msg>\x00';
                console.log('Sending apiOK response:', apiOKResponse.replace(/\x00/g, '\\x00'));
                socket.write(apiOKResponse);

                console.log('Sent version check response (verChk) and apiOK');
                break;

            case 'login':
                // Handle login
                console.log('DEBUG: Processing login request from client');
                // The client sends:
                //   <msg t='sys'><body action='login' r='0'>
                //     <login z='ZONE'><nick><![CDATA[user]]></nick><pword><![CDATA[token]]></pword></login>
                //   </body></msg>
                // (verbatim from SmartFoxClient.as:627)
                //
                // Two things to be careful about with xml2js:
                //  - 'z' is an attribute of <login>, NOT of <msg>
                //  - a CDATA-only element parses to a plain String, so node[0]._
                //    is undefined; '._' only appears when the element has attributes.
                const xmlText = (node) => {
                    if (!node || !node[0]) return null;
                    const v = node[0];
                    if (typeof v === 'string') return v;
                    return (typeof v._ === 'string') ? v._ : null;
                };

                const loginEl = body.login && body.login[0] ? body.login[0] : null;
                const zone = (loginEl && loginEl.$ && loginEl.$.z)
                    || (msg && msg.$ && msg.$.z)
                    || null;
                const username = xmlText(loginEl && loginEl.nick) || xmlText(body.nick);
                const password = xmlText(loginEl && loginEl.pword) || xmlText(body.pword);

                console.log(`Login attempt - zone: ${zone}, username: ${username}, password length: ${password ? password.length : 'null'}`);

                // Validate the login token
                const session = findSessionByToken(password);
                if (session) {
                    console.log(`DEBUG: Valid session found for token, accountId: ${session.accountId}`);

                    // Successful login
                    socket.loggedIn = true;
                    socket.userId = session.accountId;
                    socket.userName = username;

                    // Register socket in the global socket map
                    registerUserSocket(session.accountId, socket);

                    // Update user status
                    if (users[session.accountId]) {
                        users[session.accountId].online = true;
                        users[session.accountId].lastLogin = new Date();

                        // Save user data after updating status
                        saveUserData(session.accountId);
                    } else {
                        // If user doesn't exist in memory, try to load from file
                        const existingUser = loadUserData(session.accountId);
                        if (!existingUser) {
                            // User doesn't exist in file either, create a new profile
                            users[session.accountId] = createUserProfile(session.accountId, username);

                            // Save the new user data to file
                            saveUserData(session.accountId);
                        } else {
                            // User was loaded from file, just update online status
                            users[session.accountId].online = true;
                            users[session.accountId].lastLogin = new Date();

                            // Save user data after updating status
                            saveUserData(session.accountId);
                        }
                    }

                    // Ensure the user profile exists in the users object
                    if (!users[session.accountId]) {
                        // This shouldn't happen if the above logic is correct, but as a fallback:
                        users[session.accountId] = createUserProfile(session.accountId, username);
                        saveUserData(session.accountId);
                    }

                    // Send system login response first (this follows the expected SFS protocol)
                    const sysLoginResponse = `<msg t="sys"><body action="logOK" r="0"><login id="${session.accountId}" mod="0" n="${username}"/></body></msg>\x00`;
                    console.log('Sending system login response:', sysLoginResponse.replace(/\x00/g, '\\x00'));
                    socket.write(sysLoginResponse);

                    // Add a small delay before sending the extension response to ensure proper sequencing
                    setTimeout(() => {
                        // After successful system login, send the logOK message from the loginXt extension
                        // This is what the client expects to receive to finalize the login process
                        const user = users[socket.userId] || {}; // Use socket.userId instead of session.accountId to ensure consistency
                        const loginOkResponse = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"logOK","username":"${socket.userName}","chatRoomName":"Lobby","avatarId":${user.avatarId || 1},"nmp":${user.nmp || 0}}]]></body></msg>\x00`;
                        console.log('Sending extension login response:', loginOkResponse.replace(/\x00/g, '\\x00'));
                        socket.write(loginOkResponse);

                        console.log(`User ${socket.userName} (${socket.userId}) logged in successfully at system level and extension level`);
                    }, 100); // Small delay to ensure proper message sequencing
                } else {
                    console.log(`DEBUG: No valid session found for token: ${password ? password.substring(0, 10) + '...' : 'null'}`);

                    // Login failed - send system error response
                    const sysLoginFailure = `<msg t="sys"><body action="logKO" r="0"><login e="Invalid login token"/></body></msg>\x00`; // Standard SFS error code
                    socket.write(sysLoginFailure);

                    console.log(`Login failed for user ${username} with token ${password ? password.substring(0, 10) + '...' : 'null'}`);
                }
                break;

            case 'autoJoin':
                // Auto join lobby room
                if (socket.loggedIn) {
                    // Create or get lobby room
                    if (!gameRooms['lobby']) {
                        gameRooms['lobby'] = {
                            id: 1,
                            name: 'Lobby',
                            maxUsers: 100,
                            maxSpectators: 100,
                            isTemp: false,
                            isGame: false,
                            isPrivate: false,
                            limbo: false,
                            userCount: 0,
                            spectatorCount: 0,
                            users: [],
                            variables: {}
                        };
                    }

                    // Add user to room
                    gameRooms['lobby'].users.push({
                        id: socket.userId,
                        name: socket.userName
                    });

                    // Update room user count
                    gameRooms['lobby'].userCount++;

                    // Set active room ID
                    socket.activeRoomId = 1;

                    // Send join room response with proper format that client expects
                    // The client's handleJoinOk function expects specific elements in the body
                    // Include user variables that the client expects
                    const user = users[socket.userId] || {};
                    const userVars = `<vars><var n="avatarId" t="n"><![CDATA[${user.avatarId || 1}]]></var><var n="nmp" t="n"><![CDATA[${user.nmp || 0}]]></var><var n="gamesPlayed" t="n"><![CDATA[${user.gamesPlayed || 0}]]></var></vars>`;
                    const joinResponse = `<msg t="sys"><body action="joinOK" r="1"><joined roomId="1" roomName="Lobby"/><uLs><u i="${socket.userId}" n="${socket.userName}" m="0" s="0">${userVars}</u></uLs><pid id="1"/></body></msg>\x00`;
                    console.log('Sending join room response:', joinResponse.replace(/\x00/g, '\\x00'));
                    socket.write(joinResponse);

                    console.log(`User ${socket.userName} auto-joined lobby room`);
                } else {
                    // If not logged in, send error
                    const joinError = `<msg t="sys"><body action="joinKO" r="1"><error msg="Not logged in"/></body></msg>\x00`;
                    socket.write(joinError);
                }
                break;

            case 'getRmList':
                // Send room list to the client
                if (socket.loggedIn) {
                    // Create default rooms if they don't exist
                    if (!gameRooms['lobby']) {
                        gameRooms['lobby'] = {
                            id: 1,
                            name: 'Lobby',
                            maxUsers: 100,
                            maxSpectators: 100,
                            isTemp: false,
                            isGame: false,
                            isPrivate: false,
                            limbo: false,
                            userCount: 0,
                            spectatorCount: 0,
                            users: [],
                            variables: {} // Room variables
                        };
                    }

                    // Ensure battle room exists
                    if (!gameRooms['battle']) {
                        gameRooms['battle'] = {
                            id: 2,
                            name: 'Battle Arena',
                            maxUsers: 4,
                            maxSpectators: 10,
                            isTemp: false,
                            isGame: true,
                            isPrivate: false,
                            limbo: false,
                            userCount: 0,
                            spectatorCount: 0,
                            users: [],
                            variables: {} // Room variables
                        };
                    }

                    // Build XML response for room list
                    let roomListXml = '<rmList>';
                    for (const roomId in gameRooms) {
                        const room = gameRooms[roomId];
                        let varsXml = '<vars>';
                        for (const varName in room.variables) {
                            const value = room.variables[varName];
                            const type = typeof value === 'boolean' ? 'b' : typeof value === 'number' ? 'n' : 's';
                            const strValue = value ? value.toString() : '';
                            varsXml += `<var n="${varName}" t="${type}"><![CDATA[${strValue}]]></var>`;
                        }
                        varsXml += '</vars>';

                        roomListXml += `<rm id="${room.id}" maxu="${room.maxUsers}" maxs="${room.maxSpectators}" ` +
                                      `temp="${room.isTemp ? '1' : '0'}" game="${room.isGame ? '1' : '0'}" ` +
                                      `priv="${room.isPrivate ? '1' : '0'}" lmb="${room.limbo ? '1' : '0'}" ` +
                                      `ucnt="${room.userCount}" scnt="${room.spectatorCount}">` +
                                      `<n><![CDATA[${room.name}]]></n>` +
                                      `<pwd></pwd>` +
                                      `<max>${room.maxUsers}</max>` +
                                      `${varsXml}` +
                                      `</rm>`;
                    }
                    roomListXml += '</rmList>';

                    const roomListResponse = `<msg t="sys"><body action="rmList" r="${socket.activeRoomId || -1}">${roomListXml}</body></msg>\x00`;
                    socket.write(roomListResponse);

                    console.log(`Sent room list to user ${socket.userName}`);
                } else {
                    // If not logged in, send error
                    const roomListError = `<msg t="sys"><body action="rmList" r="-1"><error msg="Not logged in"/></body></msg>\x00`;
                    socket.write(roomListError);
                }
                break;

            case 'setUvars':
                // Set user variables
                if (socket.loggedIn && body && body['@r']) {
                    // Parse variables from the XML
                    const user = users[socket.userId];
                    if (user) {
                        // In a real implementation, we would parse the XML properly
                        // For now, just acknowledge the request
                        console.log(`User ${socket.userName} updated user variables`);
                    }

                    // Send confirmation - get room ID from the body attributes
                    const roomId = body['@r'] ? parseInt(body['@r']) : socket.activeRoomId;
                    const setUserVarsResponse = `<msg t="sys"><body action="uVarsUpdate" r="${roomId}"><![CDATA[]]></body></msg>\x00`;
                    socket.write(setUserVarsResponse);
                }
                break;

            case 'setRvars':
                // Set room variables
                if (socket.loggedIn && body && body['@r']) {
                    const roomId = parseInt(body['@r']);
                    const room = gameRooms[roomId];
                    if (room) {
                        // In a real implementation, we would parse the room variables
                        // For now, just acknowledge the request
                        console.log(`User ${socket.userName} updated room ${roomId} variables`);
                    }

                    // Send confirmation
                    const setRoomVarsResponse = `<msg t="sys"><body action="rVarsUpdate" r="${roomId}"><![CDATA[]]></body></msg>\x00`;
                    socket.write(setRoomVarsResponse);
                }
                break;

            case 'logout':
                // Handle logout
                console.log(`Logout request for user: ${socket.userName || socket.id}`);

                // Remove just this connection; the user stays online while any of
                // their other three sockets are still up.
                const remainingAfterLogout = unregisterUserSocket(socket);

                if (socket.userId && users[socket.userId] && remainingAfterLogout === 0) {
                    users[socket.userId].online = false;

                    // Save user data before logging out
                    saveUserData(socket.userId);
                }

                socket.loggedIn = false;
                socket.userId = null;
                socket.userName = null;
                socket.activeRoomId = -1;

                // Send logout confirmation
                const logoutResponse = `<msg t="sys"><body action="logout" r="-1"><![CDATA[{}]]></body></msg>\x00`;
                socket.write(logoutResponse);
                break;

            default:
                console.log(`Unhandled XML action: ${action}`);
                console.log('Available actions in body:', Object.keys(body || {}).filter(key => key !== '$'));
                break;
        }
    });
}

function handleJsonMessage(socket, message) {
    try {
        const obj = JSON.parse(message);
        const msgType = obj.t;
        
        if (msgType === 'xt') {
            // Extension message
            const body = obj.b;
            const extension = body.x;
            const command = body.c;
            
            console.log(`Extension command: ${extension}.${command}`);
            
            // Handle extension commands
            handleExtensionCommand(socket, extension, command, body.p);
        }
    } catch (e) {
        console.error('Error parsing JSON message:', e);
    }
}

function handleStringMessage(socket, message) {
    console.log('String message received:', message);
    // String messages use '%' as separator
    const parts = message.split('%');
    if (parts.length > 0) {
        const msgType = parts[0];
        console.log(`String message type: ${msgType}`);
    }
}

// Global socket mapping to find sockets by user ID.
//
// The game client opens FOUR connections per user (user/buddy, chat, battle,
// trade), all to this same port. Keying one socket per account made each login
// overwrite the previous one, so only the most recent connection could ever
// receive a server push, and whichever socket closed first wiped the entry for
// all of them. Each user therefore maps to an ARRAY of live sockets.
let socketMap = {};

function registerUserSocket(userId, socket) {
    if (!userId || !socket) return;
    if (!socketMap[userId]) socketMap[userId] = [];
    if (!socketMap[userId].includes(socket)) socketMap[userId].push(socket);
    console.log(`Socket registered for ${userId} (${socketMap[userId].length} live connection(s))`);
}

// Removes just this socket. Returns how many of the user's connections remain,
// so callers can tell a single connection dropping from the user going offline.
function unregisterUserSocket(socket) {
    const userId = socket && socket.userId;
    if (!userId || !socketMap[userId]) return 0;

    socketMap[userId] = socketMap[userId].filter(s => s !== socket);
    const remaining = socketMap[userId].length;
    if (remaining === 0) delete socketMap[userId];

    console.log(`Socket unregistered for ${userId} (${remaining} connection(s) remaining)`);
    return remaining;
}

function getUserSockets(userId) {
    const list = socketMap[userId];
    if (!list) return [];
    return list.filter(s => s && !s.destroyed);
}

// Battle state management
let battleRooms = {};
let battleIdCounter = 1000; // Start from 1000 to avoid conflicts with other IDs

// Function to send message to a specific user by ID.
//
// Delivered to every live connection the user has. Each client-side service
// filters on the response's _cmd and ignores anything outside its own
// vocabulary, so fanning out is safe and avoids having to track which socket
// belongs to which extension.
function sendMessageToUser(userId, message) {
    const sockets = getUserSockets(userId);
    if (sockets.length === 0) return false;

    for (const socket of sockets) {
        socket.write(message);
    }
    return true;
}

// Function to broadcast message to all players in a battle
function broadcastToBattle(battleName, message, excludeUserId = null) {
    const battle = battleRooms[battleName];
    if (!battle) return;

    for (const player of battle.players) {
        if (player.id !== excludeUserId) {
            sendMessageToUser(player.id, message);
        }
    }
}

function handleGameXtCommand(socket, command, params) {
    console.log(`[GAMEXT_LOG] Handling gameXt command: ${command}`, params);

    let response = '';

    switch (command) {
        case 'createQuickBattle':
            console.log(`[GAMEXT_LOG] createQuickBattle command called by user ${socket.userId} (${socket.userName})`, params);
            // Create a quick battle with specified parameters
            const gameSwarmValue = params.gameSwarmValue || 1000;
            const totalPlayers = params.totalPlayers || 2;

            // Generate a unique battle name
            const newBattleName = `quick_battle_${Date.now()}_${socket.userId}`;

            // Create battle room
            const battleRoom = {
                id: battleIdCounter++,
                name: newBattleName,
                gameSwarmValue: gameSwarmValue,
                maxPlayers: totalPlayers,
                players: [{
                    id: socket.userId,
                    name: socket.userName,
                    ready: false,
                    nanovorSwarm: [],
                    selectedNanovor: null,
                    enemyTarget: null
                }],
                creator: socket.userId,
                creatorName: socket.userName,
                gameState: 'waiting_for_players', // waiting_for_players, in_progress, finished
                turnOrder: [],
                currentTurn: 0,
                round: 1,
                battleHistory: []
            };

            battleRooms[newBattleName] = battleRoom;

            // Update socket's active battle
            socket.activeBattle = newBattleName;

            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameCreated","battleName":"${newBattleName}","gameCreator":"${socket.userName}","convertedChatRoom":false}]]></body></msg>\x00`;
            console.log(`[GAMEXT_LOG] createQuickBattle completed, battle created: ${newBattleName}`);
            break;

        case 'createGame':
            // Create a custom game
            const customSwarmValue = params.gameSwarmValue || 1000;
            const convertedChatRoom = params.convertedChatRoom || false;

            // Generate a unique battle name
            const customBattleName = `custom_battle_${Date.now()}_${socket.userId}`;

            // Create battle room
            const customBattleRoom = {
                id: battleIdCounter++,
                name: customBattleName,
                gameSwarmValue: customSwarmValue,
                maxPlayers: 2, // Default to 2 players
                players: [{
                    id: socket.userId,
                    name: socket.userName,
                    ready: false,
                    nanovorSwarm: [],
                    selectedNanovor: null,
                    enemyTarget: null
                }],
                creator: socket.userId,
                creatorName: socket.userName,
                gameState: 'waiting_for_players',
                turnOrder: [],
                currentTurn: 0,
                round: 1,
                battleHistory: []
            };

            battleRooms[customBattleName] = customBattleRoom;

            // Update socket's active battle
            socket.activeBattle = customBattleName;

            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameCreated","battleName":"${customBattleName}","gameCreator":"${socket.userName}","convertedChatRoom":${convertedChatRoom}}]]></body></msg>\x00`;
            break;

        case 'inviteUser':
            // Invite a user to a battle
            const invitee = params.buddy; // Username of the person to invite
            const battleToInvite = params.battleName;
            const convertedRoom = params.convertedChatRoom || false;

            // Find the user ID for the invitee
            let inviteeId = null;
            for (const userId in users) {
                if (users[userId].username === invitee) {
                    inviteeId = userId;
                    break;
                }
            }

            if (inviteeId) {
                // Send invitation to the invitee
                const invitationMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"invitationRequest","battleName":"${battleToInvite}","inviter":{"username":"${socket.userName}","userRefId":"${socket.userId}"},"gameSwarmValue":${battleRooms[battleToInvite]?.gameSwarmValue || 1000},"convertedChatRoom":${convertedRoom}}]]></body></msg>\x00`;

                if (sendMessageToUser(inviteeId, invitationMsg)) {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"invitationSent","battleName":"${battleToInvite}","invitedUser":"${invitee}"}]]></body></msg>\x00`;
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameInvitationError","errorMessage":"Player offline"}]]></body></msg>\x00`;
                }
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameInvitationError","errorMessage":"Player not found"}]]></body></msg>\x00`;
            }
            break;

        case 'replyInvitation':
            // Reply to a battle invitation (accept/decline)
            const battleName = params.battleName;
            const accept = params.accept;
            const replyReason = params.replyReason || 'ACCEPTED';

            if (accept) {
                // User accepted the invitation
                const battleRoom = battleRooms[battleName];

                if (battleRoom) {
                    // Add the user to the battle room if there's space
                    if (battleRoom.players.length < battleRoom.maxPlayers) {
                        battleRoom.players.push({
                            id: socket.userId,
                            name: socket.userName,
                            ready: false,
                            nanovorSwarm: [],
                            selectedNanovor: null,
                            enemyTarget: null
                        });

                        // Update socket's active battle
                        socket.activeBattle = battleName;

                        // Send invitation response to the game creator
                        const responseMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"invitationResponse","battleName":"${battleName}","player":"${socket.userName}","inviterName":"${battleRoom.creatorName}","inviterId":"${battleRoom.creator}","otherPlayers":${JSON.stringify(battleRoom.players.filter(p => p.id !== socket.userId && p.id !== battleRoom.creator).map(p => ({username: p.name, userRefId: p.id})))}}]]></body></msg>\x00`;

                        sendMessageToUser(battleRoom.creator, responseMsg);

                        // If we now have enough players, start the game
                        if (battleRoom.players.length === battleRoom.maxPlayers) {
                            battleRoom.gameState = 'in_progress';

                            // Set up turn order
                            battleRoom.turnOrder = [...battleRoom.players];

                            // Send game started message to all players
                            const gameStartMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameStarted","battleName":"${battleName}","players":${JSON.stringify(battleRoom.players.map(p => ({username: p.name, userRefId: p.id})))},"gameCreator":"${battleRoom.creatorName}"}]]></body></msg>\x00`;

                            broadcastToBattle(battleName, gameStartMsg);
                        }

                        response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"invitationResponse","battleName":"${battleName}","accepted":true}]]></body></msg>\x00`;
                    } else {
                        response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                    }
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                // User declined the invitation
                const battleRoom = battleRooms[battleName];
                if (battleRoom) {
                    // Send decline notification to the game creator
                    const declineMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"invitationResponse","battleName":"${battleName}","accepted":false,"player":"${socket.userName}","reason":"${replyReason}"}]]></body></msg>\x00`;

                    sendMessageToUser(battleRoom.creator, declineMsg);
                }

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"invitationResponse","battleName":"${battleName}","accepted":false,"reason":"${replyReason}"}]]></body></msg>\x00`;
            }
            break;

        case 'setGameSwarmValue':
            // Set the game swarm value for the battle
            const newSwarmValue = params.gameSwarmValue || 1000;
            const currentBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (currentBattle && currentBattle.creator === socket.userId) {
                currentBattle.gameSwarmValue = newSwarmValue;

                // Notify other players of the change
                const swarmValueSetMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameSwarmValueSet","battleName":"${currentBattle.name}","gameSwarmValue":${newSwarmValue}}]]></body></msg>\x00`;

                broadcastToBattle(currentBattle.name, swarmValueSetMsg, socket.userId);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameSwarmValueSet","battleName":"${currentBattle.name}","gameSwarmValue":${newSwarmValue}}]]></body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'setSwarm':
            console.log(`[GAMEXT_LOG] setSwarm command called by user ${socket.userId} (${socket.userName})`, params);
            // Set the player's battle swarm with enhanced validation for NewUserState
            const nanovorIds = params.nanovorIds ? params.nanovorIds.split(',').map(id => parseInt(id)) : [];
            const activeBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (activeBattle) {
                const playerIndex = activeBattle.players.findIndex(p => p.id === socket.userId);
                if (playerIndex !== -1) {
                    // Validate that the user actually owns these nanovor
                    const user = users[socket.userId];
                    if (user && user.nanovorInventory) {
                        // Check if all requested nanovor IDs are in the user's inventory
                        const validNanovorIds = nanovorIds.filter(nanovorId =>
                            user.nanovorInventory.some(nano => nano.id === nanovorId)
                        );

                        // Check if the swarm size is within limits
                        const gameSwarmValue = activeBattle.gameSwarmValue || 1000;
                        let totalSwarmValue = 0;

                        for (const nanovorId of validNanovorIds) {
                            const nanovor = user.nanovorInventory.find(nano => nano.id === nanovorId);
                            if (nanovor) {
                                totalSwarmValue += nanovor.pv || 0; // Use point value from nanovor data
                            }
                        }

                        // For NewUserState, we might want to allow a lower swarm value or different validation
                        if (totalSwarmValue > gameSwarmValue && activeBattle.name.includes('newuser')) {
                            // Allow some flexibility for new user experience
                            console.log(`[GAMEXT_LOG] Allowing swarm value ${totalSwarmValue} for new user battle (limit: ${gameSwarmValue})`);
                        } else if (totalSwarmValue > gameSwarmValue) {
                            // Swarm exceeds the game limit
                            console.log(`[GAMEXT_LOG] setSwarm rejected - swarm value ${totalSwarmValue} exceeds limit ${gameSwarmValue}`);
                            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError","errorMessage":"Swarm value ${totalSwarmValue} exceeds limit ${gameSwarmValue}"}]]></body></msg>\x00`;
                        } else {
                            // Valid swarm, update the player's swarm
                            activeBattle.players[playerIndex].nanovorSwarm = validNanovorIds;
                            console.log(`[GAMEXT_LOG] setSwarm accepted - user ${socket.userId} set swarm with ${validNanovorIds.length} nanovors (value: ${totalSwarmValue})`);

                            // Notify other players that this player has set their swarm
                            const swarmSelectedMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"swarmSelected","battleName":"${activeBattle.name}","swarmCount":${validNanovorIds.length},"swarmValue":${totalSwarmValue},"username":"${socket.userName}","userRefId":"${socket.userId}"}]]></body></msg>\x00`;

                            broadcastToBattle(activeBattle.name, swarmSelectedMsg, socket.userId);

                            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"swarmSelected","battleName":"${activeBattle.name}","swarmCount":${validNanovorIds.length},"swarmValue":${totalSwarmValue},"username":"${socket.userName}","userRefId":"${socket.userId}"}]]></body></msg>\x00`;
                        }
                    } else {
                        // User doesn't have inventory data, use basic validation
                        activeBattle.players[playerIndex].nanovorSwarm = nanovorIds;
                        console.log(`[GAMEXT_LOG] setSwarm accepted (no inventory validation) - user ${socket.userId} set swarm with ${nanovorIds.length} nanovors`);

                        // Notify other players that this player has set their swarm
                        const swarmSelectedMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"swarmSelected","battleName":"${activeBattle.name}","swarmCount":${nanovorIds.length},"username":"${socket.userName}","userRefId":"${socket.userId}"}]]></body></msg>\x00`;

                        broadcastToBattle(activeBattle.name, swarmSelectedMsg, socket.userId);

                        response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"swarmSelected","battleName":"${activeBattle.name}","swarmCount":${nanovorIds.length},"username":"${socket.userName}","userRefId":"${socket.userId}"}]]></body></msg>\x00`;
                    }
                } else {
                    console.log(`[GAMEXT_LOG] setSwarm failed - user ${socket.userId} not found in battle ${socket.activeBattle}`);
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                console.log(`[GAMEXT_LOG] setSwarm failed - no active battle for user ${socket.userId}`);
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'setSelectedNanovor':
            // Set the selected nanovor for the player
            const selectedNanovorId = params.nanovorId || 0;
            const selectedBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (selectedBattle) {
                const playerIndex = selectedBattle.players.findIndex(p => p.id === socket.userId);
                if (playerIndex !== -1) {
                    selectedBattle.players[playerIndex].selectedNanovor = selectedNanovorId;

                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"selectedNanovorSet","nanovorId":${selectedNanovorId}}]]></body></msg>\x00`;
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'setEnemy':
            // Set the target enemy for attack
            const enemyUsername = params.enemyUsername;
            const enemyBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (enemyBattle) {
                const playerIndex = enemyBattle.players.findIndex(p => p.id === socket.userId);
                if (playerIndex !== -1) {
                    // Find the target player by username
                    const targetIndex = enemyBattle.players.findIndex(p => p.name === enemyUsername);
                    if (targetIndex !== -1) {
                        enemyBattle.players[playerIndex].enemyTarget = enemyBattle.players[targetIndex].id;

                        // Send target selected notification to all players
                        const targetSelectedMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"targetSelected","userRefId":"${socket.userId}","targetUserRefId":"${enemyBattle.players[targetIndex].id}","attackId":0}]]></body></msg>\x00`;

                        broadcastToBattle(enemyBattle.name, targetSelectedMsg);

                        response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"enemyTargetSet","targetUsername":"${enemyUsername}","targetId":"${enemyBattle.players[targetIndex].id}"}]]></body></msg>\x00`;
                    } else {
                        response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                    }
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'setAttackInfo':
            // Set complete attack information
            const targetPlayerName = params.enemyUsername;
            const myNanovorId = params.nanovorId;
            const setAttackId = params.attackId;
            const swapNanovorId = params.swapNanovorId;
            const attackBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (attackBattle) {
                const playerIndex = attackBattle.players.findIndex(p => p.id === socket.userId);
                if (playerIndex !== -1) {
                    // Find the target player
                    const targetIndex = attackBattle.players.findIndex(p => p.name === targetPlayerName);
                    if (targetIndex !== -1) {
                        // Record the attack info
                        const attackInfo = {
                            attackerId: socket.userId,
                            targetId: attackBattle.players[targetIndex].id,
                            nanovorId: myNanovorId,
                            attackId: setAttackId,
                            swapNanovorId: swapNanovorId,
                            timestamp: Date.now()
                        };

                        attackBattle.battleHistory.push(attackInfo);

                        // Send attack performed notification to all players
                        const attackMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"performAttack","attackResults":{"attackerId":"${socket.userId}","targetId":"${attackBattle.players[targetIndex].id}","nanovorId":${myNanovorId},"attackId":${setAttackId}}}]]></body></msg>\x00`;

                        broadcastToBattle(attackBattle.name, attackMsg);

                        response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"attackInfoSet","attackId":${setAttackId}}]]></body></msg>\x00`;
                    } else {
                        response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                    }
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'endRound':
            // End the current round
            const roundBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (roundBattle) {
                // Increment round number
                roundBattle.round++;

                // Reset turn counter for the new round
                roundBattle.currentTurn = 0;

                // Send round completed notification to all players
                const roundCompleteMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"roundCompleted","round":${roundBattle.round}}]]></body></msg>\x00`;

                broadcastToBattle(roundBattle.name, roundCompleteMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"roundEnded","round":${roundBattle.round}}]]></body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'quitGame':
            console.log(`[GAMEXT_LOG] quitGame command called by user ${socket.userId} (${socket.userName})`, params);
            // Quit the current game
            const quittingUserId = params.userRefId;
            const quitBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (quitBattle) {
                // Remove player from the battle
                quitBattle.players = quitBattle.players.filter(p => p.id !== quittingUserId);
                console.log(`[GAMEXT_LOG] quitGame - user ${quittingUserId} removed from battle ${quitBattle.name}, ${quitBattle.players.length} players remaining`);

                // If there's only one player left, end the game
                if (quitBattle.players.length <= 1) {
                    quitBattle.gameState = 'finished';
                    console.log(`[GAMEXT_LOG] quitGame - only ${quitBattle.players.length} player left, ending game`);

                    // Notify remaining players that the game is over
                    const gameOverMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameOver","winnerId":"${quitBattle.players[0]?.id || ''}","results":"Game ended due to player quit"}]]></body></msg>\x00`;

                    broadcastToBattle(quitBattle.name, gameOverMsg);
                } else {
                    // Notify other players that someone quit
                    const playerQuitMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerQuitGame","userRefId":"${quittingUserId}","username":"${users[quittingUserId]?.username || 'Unknown'}"}]]></body></msg>\x00`;
                    console.log(`[GAMEXT_LOG] quitGame - notifying other players about user ${quittingUserId} quitting`);

                    broadcastToBattle(quitBattle.name, playerQuitMsg);
                }

                // Clear the active battle for the socket
                socket.activeBattle = null;

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"quitGameConfirmed","userRefId":"${quittingUserId}"}]]></body></msg>\x00`;
                console.log(`[GAMEXT_LOG] quitGame completed for user ${quittingUserId}`);
            } else {
                // Not an error. SmartFoxBattleGameService.quitGame() is unconditional -
                // the client fires it as cleanup on every state exit, with no "am I in a
                // battle?" guard. Answering gameError here makes the client show the modal
                // CommonDialogBox "Battle Error / Error during battle" on ordinary
                // navigation. Nothing to quit is success, so stay silent.
                console.log(`[GAMEXT_LOG] quitGame - no active battle for user ${socket.userId}; nothing to do`);
                response = '';
            }
            break;

        case 'cancelQuickBattle':
            // Cancel matchmaking
            const cancelUserId = params.userRefId;
            const cancelBattleName = Object.keys(battleRooms).find(battleName => {
                const battle = battleRooms[battleName];
                return battle.creator === cancelUserId && battle.gameState === 'waiting_for_players';
            });

            if (cancelBattleName) {
                // Notify other players in the battle that it's cancelled
                const cancelMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameOver","results":"Game was cancelled by the creator"}]]></body></msg>\x00`;

                broadcastToBattle(cancelBattleName, cancelMsg);

                delete battleRooms[cancelBattleName];

                // Clear the active battle for the socket
                socket.activeBattle = null;

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"quickBattleCancelled"}]]></body></msg>\x00`;
            } else {
                // Same as quitGame above: cancelMatchMaking() is unconditional on the
                // client, so "no matchmaking in progress" is a no-op, not an error.
                console.log(`[GAMEXT_LOG] cancelQuickBattle - no pending quick battle for user ${socket.userId}; nothing to do`);
                response = '';
            }
            break;

        case 'getBadgeList':
            // Get badge list for a player
            const ownerId = params.ownerId;
            const nanovorId = params.nanovorId;

            // Return empty badge list for now
            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"badgeList","ownerId":"${ownerId}","nanovorId":"${nanovorId}","badges":[]}]]></body></msg>\x00`;
            break;

        case 'startGame':
            console.log(`[GAMEXT_LOG] startGame command called by user ${socket.userId} (${socket.userName})`, params);
            // Start the game manually (when all players are ready)
            const startBattleName = params.battleName;
            const startBattle = battleRooms[startBattleName];

            if (startBattle) {
                startBattle.gameState = 'in_progress';
                console.log(`[GAMEXT_LOG] startGame - starting game in battle ${startBattleName}, ${startBattle.players.length} players`);

                // Set up turn order
                startBattle.turnOrder = [...startBattle.players];

                // Send game started message to all players
                const gameStartMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameStarted","battleName":"${startBattleName}","players":${JSON.stringify(startBattle.players.map(p => ({username: p.name, userRefId: p.id})))},"gameCreator":"${startBattle.creatorName}"}]]></body></msg>\x00`;

                broadcastToBattle(startBattleName, gameStartMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameStarted","battleName":"${startBattleName}"}]]></body></msg>\x00`;
                console.log(`[GAMEXT_LOG] startGame completed for battle ${startBattleName}`);
            } else {
                console.log(`[GAMEXT_LOG] startGame failed - battle ${startBattleName} not found`);
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'setAttack':
            // Set attack to perform
            const attackToSet = params.attackId || 0;

            // In a real implementation, this would record the player's chosen attack
            // For now, just acknowledge the command
            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"attackSet","attackId":${attackToSet}}]]></body></msg>\x00`;
            break;

        case 'setNextSwap':
            // Set next nanovor to swap to
            const nextNanovorId = params.nanovorId || 0;
            const swapBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (swapBattle) {
                const playerIndex = swapBattle.players.findIndex(p => p.id === socket.userId);
                if (playerIndex !== -1) {
                    // Record the swap intention
                    swapBattle.players[playerIndex].nextSwap = nextNanovorId;

                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"nextSwapSet","nanovorId":${nextNanovorId}}]]></body></msg>\x00`;
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'declinedToWatch':
            // Player declined to watch an ongoing battle
            const declinerId = params.userRefId;

            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"declinedToWatchConfirmed","userRefId":"${declinerId}"}]]></body></msg>\x00`;
            break;

        case 'kickPlayerOut':
            // Kick a player from the battle
            const usernameToKick = params.username;
            const kickBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (kickBattle && kickBattle.creator === socket.userId) {
                // Find and remove the player
                const playerToKickIndex = kickBattle.players.findIndex(p => p.name === usernameToKick);
                if (playerToKickIndex !== -1) {
                    const kickedPlayer = kickBattle.players[playerToKickIndex];

                    // Send kick notification to the kicked player
                    const kickMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerKickedOut","userRefId":"${kickedPlayer.id}"}]]></body></msg>\x00`;

                    sendMessageToUser(kickedPlayer.id, kickMsg);

                    // Remove the player from the battle
                    kickBattle.players.splice(playerToKickIndex, 1);

                    // If there's only one player left, end the game
                    if (kickBattle.players.length <= 1) {
                        kickBattle.gameState = 'finished';

                        // Notify remaining players that the game is over
                        const gameOverMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameOver","winnerId":"${kickBattle.players[0]?.id || ''}","results":"Game ended due to player kick"}]]></body></msg>\x00`;

                        broadcastToBattle(kickBattle.name, gameOverMsg);
                    } else {
                        // Notify other players that someone was kicked
                        const playerKickedMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerQuitGame","userRefId":"${kickedPlayer.id}","username":"${kickedPlayer.name}"}]]></body></msg>\x00`;

                        broadcastToBattle(kickBattle.name, playerKickedMsg);
                    }

                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerKickedOut","userRefId":"${kickedPlayer.id}"}]]></body></msg>\x00`;
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'setReady':
            console.log(`[GAMEXT_LOG] setReady command called by user ${socket.userId} (${socket.userName})`, params);
            // Set player ready state
            const readyBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (readyBattle) {
                const playerIndex = readyBattle.players.findIndex(p => p.id === socket.userId);
                if (playerIndex !== -1) {
                    readyBattle.players[playerIndex].ready = true;
                    console.log(`[GAMEXT_LOG] setReady - user ${socket.userId} marked as ready in battle ${readyBattle.name}`);

                    // Check if all players are ready
                    const allReady = readyBattle.players.every(p => p.ready);

                    if (allReady && readyBattle.players.length >= 2) {
                        // Start the game if all players are ready
                        readyBattle.gameState = 'in_progress';
                        console.log(`[GAMEXT_LOG] setReady - all players ready, starting game in battle ${readyBattle.name}`);

                        // Set up turn order
                        readyBattle.turnOrder = [...readyBattle.players];

                        // Send game started message to all players
                        const gameStartMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameStarted","battleName":"${readyBattle.name}","players":${JSON.stringify(readyBattle.players.map(p => ({username: p.name, userRefId: p.id})))},"gameCreator":"${readyBattle.creatorName}"}]]></body></msg>\x00`;

                        broadcastToBattle(readyBattle.name, gameStartMsg);
                    }

                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerReady","userRefId":"${socket.userId}","ready":true}]]></body></msg>\x00`;
                } else {
                    console.log(`[GAMEXT_LOG] setReady failed - user ${socket.userId} not found in battle ${socket.activeBattle}`);
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                console.log(`[GAMEXT_LOG] setReady failed - no active battle for user ${socket.userId}`);
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'getPlayerStatus':
            // Get status of players in battle
            const statusBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (statusBattle) {
                const playerStatus = statusBattle.players.map(p => ({
                    userRefId: p.id,
                    username: p.name,
                    ready: p.ready,
                    nanovorSwarmSize: p.nanovorSwarm ? p.nanovorSwarm.length : 0
                }));

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerStatusList","players":${JSON.stringify(playerStatus)}}]}</body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'getBattleStatus':
            // Get current battle state
            const battleStatus = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (battleStatus) {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"battleStatus","battleName":"${battleStatus.name}","gameState":"${battleStatus.gameState}","currentRound":${battleStatus.round},"playerCount":${battleStatus.players.length}}]}</body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'performAttack':
            console.log(`[GAMEXT_LOG] performAttack command called by user ${socket.userId} (${socket.userName})`, params);
            // Perform an attack action
            const targetUserRefId = params.targetUserRefId;
            const attackNanovorId = params.nanovorId;
            const attackId = params.attackId;
            const performAttackBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (performAttackBattle) {
                // Record the attack in battle history
                const attackRecord = {
                    attackerId: socket.userId,
                    targetId: targetUserRefId,
                    nanovorId: attackNanovorId,
                    attackId: attackId,
                    timestamp: Date.now()
                };

                performAttackBattle.battleHistory.push(attackRecord);
                console.log(`[GAMEXT_LOG] performAttack recorded - ${socket.userId} attacked ${targetUserRefId} with nanovor ${attackNanovorId}, attackId: ${attackId}`);

                // Send attack notification to all players
                const attackMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"performAttack","attackResults":{"attackerId":"${socket.userId}","targetId":"${targetUserRefId}","nanovorId":${attackNanovorId},"attackId":${attackId}}}]]></body></msg>\x00`;

                broadcastToBattle(performAttackBattle.name, attackMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"attackPerformed","attackId":${attackId}}]]></body></msg>\x00`;
                console.log(`[GAMEXT_LOG] performAttack completed successfully`);
            } else {
                console.log(`[GAMEXT_LOG] performAttack failed - no active battle for user ${socket.userId}`);
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'swapNanovor':
            // Swap active nanovor during battle
            const newNanovorId = params.newNanovorId;
            const swapNanovorBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (swapNanovorBattle) {
                const playerIndex = swapNanovorBattle.players.findIndex(p => p.id === socket.userId);
                if (playerIndex !== -1) {
                    // Update the selected nanovor
                    swapNanovorBattle.players[playerIndex].selectedNanovor = newNanovorId;

                    // Notify all players about the swap
                    const swapMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"swapNanovor","userRefId":"${socket.userId}","newNanovorId":${newNanovorId}}]]></body></msg>\x00`;

                    broadcastToBattle(swapNanovorBattle.name, swapMsg);

                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"nanovorSwapped","newNanovorId":${newNanovorId}}]]></body></msg>\x00`;
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'killNanovor':
            // Mark a nanovor as defeated
            const killedNanovorId = params.nanovorId;
            const killerId = params.killerId;
            const killBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (killBattle) {
                // Notify all players about the nanovor death
                const killMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"killNanovor","nanovorId":${killedNanovorId},"killerId":"${killerId}"}]]></body></msg>\x00`;

                broadcastToBattle(killBattle.name, killMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"nanovorKilled","nanovorId":${killedNanovorId}}]]></body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'blockSwap':
            // Block nanovor swapping
            const blockerId = params.blockerId;
            const blockBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (blockBattle) {
                // Notify all players about the swap block
                const blockMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"blockSwap","blockerId":"${blockerId}"}]]></body></msg>\x00`;

                broadcastToBattle(blockBattle.name, blockMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"swapBlocked","blockerId":"${blockerId}"}]]></body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'selectNanovor':
            // Select a nanovor for battle
            const selectNanovorId = params.nanovorId;
            const selectBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (selectBattle) {
                const playerIndex = selectBattle.players.findIndex(p => p.id === socket.userId);
                if (playerIndex !== -1) {
                    selectBattle.players[playerIndex].selectedNanovor = selectNanovorId;

                    // Notify all players about the selection
                    const selectMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"selectNanovor","userRefId":"${socket.userId}","nanovorId":${selectNanovorId}}]]></body></msg>\x00`;

                    broadcastToBattle(selectBattle.name, selectMsg);

                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"nanovorSelected","nanovorId":${selectNanovorId}}]]></body></msg>\x00`;
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
                }
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'setRoundInfo':
            // Set round information
            const roundInfo = params.roundInfo;
            const roundInfoBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (roundInfoBattle) {
                // Update round info in battle
                roundInfoBattle.currentRoundInfo = roundInfo;

                // Notify all players about the round info
                const roundInfoMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"setRoundInfo","roundInfo":${JSON.stringify(roundInfo)}}]}</body></msg>\x00`;

                broadcastToBattle(roundInfoBattle.name, roundInfoMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"roundInfoSet","round":${roundInfoBattle.round}}]}</body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'showGameResults':
            // Show game results
            const gameResults = params.results;
            const resultsBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (resultsBattle) {
                // Notify all players about the game results
                const resultsMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"showGameResults","results":${JSON.stringify(gameResults)}}]}</body></msg>\x00`;

                broadcastToBattle(resultsBattle.name, resultsMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameResultsShown","battleName":"${resultsBattle.name}"}]]></body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'gameQuit':
            console.log(`[GAMEXT_LOG] gameQuit command called by user ${socket.userId} (${socket.userName})`, params);
            // Quit the game
            const gameQuitBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (gameQuitBattle) {
                // Remove player from the battle
                gameQuitBattle.players = gameQuitBattle.players.filter(p => p.id !== socket.userId);
                console.log(`[GAMEXT_LOG] gameQuit - user ${socket.userId} removed from battle ${gameQuitBattle.name}, ${gameQuitBattle.players.length} players remaining`);

                // If there's only one player left, end the game
                if (gameQuitBattle.players.length <= 1) {
                    gameQuitBattle.gameState = 'finished';
                    console.log(`[GAMEXT_LOG] gameQuit - only ${gameQuitBattle.players.length} player left, ending game`);

                    // Notify remaining players that the game is over
                    const gameOverMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameOver","winnerId":"${gameQuitBattle.players[0]?.id || ''}","results":"Game ended due to player quit"}]]></body></msg>\x00`;

                    broadcastToBattle(gameQuitBattle.name, gameOverMsg);
                } else {
                    // Notify other players that someone quit
                    const playerQuitMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerQuitGame","userRefId":"${socket.userId}","username":"${users[socket.userId]?.username || 'Unknown'}"}]]></body></msg>\x00`;
                    console.log(`[GAMEXT_LOG] gameQuit - notifying other players about user ${socket.userId} quitting`);

                    broadcastToBattle(gameQuitBattle.name, playerQuitMsg);
                }

                // Clear the active battle for the socket
                socket.activeBattle = null;

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameQuitConfirmed","userRefId":"${socket.userId}"}]]></body></msg>\x00`;
                console.log(`[GAMEXT_LOG] gameQuit completed for user ${socket.userId}`);
            } else {
                console.log(`[GAMEXT_LOG] gameQuit failed - no active battle for user ${socket.userId}`);
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'playerJoinAutoBattle':
            // Join an auto battle
            const autoBattleName = params.battleName;
            const gameCreator = params.gameCreator;
            const gameCreatorId = params.gameCreatorId;

            // Create or join the auto battle
            if (!battleRooms[autoBattleName]) {
                battleRooms[autoBattleName] = {
                    id: battleIdCounter++,
                    name: autoBattleName,
                    gameSwarmValue: 1000, // Default value
                    maxPlayers: 2,
                    players: [{
                        id: gameCreatorId,
                        name: gameCreator,
                        ready: true,
                        nanovorSwarm: [],
                        selectedNanovor: null,
                        enemyTarget: null
                    }, {
                        id: socket.userId,
                        name: socket.userName,
                        ready: true,
                        nanovorSwarm: [],
                        selectedNanovor: null,
                        enemyTarget: null
                    }],
                    creator: gameCreatorId,
                    creatorName: gameCreator,
                    gameState: 'in_progress',
                    turnOrder: [],
                    currentTurn: 0,
                    round: 1,
                    battleHistory: []
                };
            } else {
                // Add player to existing auto battle if there's space
                const existingAutoBattle = battleRooms[autoBattleName];
                if (existingAutoBattle.players.length < existingAutoBattle.maxPlayers) {
                    existingAutoBattle.players.push({
                        id: socket.userId,
                        name: socket.userName,
                        ready: true,
                        nanovorSwarm: [],
                        selectedNanovor: null,
                        enemyTarget: null
                    });
                }
            }

            // Update socket's active battle
            socket.activeBattle = autoBattleName;

            // Set up turn order and start the game
            const finalAutoBattle = battleRooms[autoBattleName];
            finalAutoBattle.turnOrder = [...finalAutoBattle.players];
            finalAutoBattle.gameState = 'in_progress';

            // Send join auto battle message to all players
            const joinAutoMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerJoinAutoBattle","battleName":"${autoBattleName}","username":"${socket.userName}","userRefId":"${socket.userId}","gameCreator":"${gameCreator}","gameCreatorId":"${gameCreatorId}"}]]></body></msg>\x00`;

            broadcastToBattle(autoBattleName, joinAutoMsg);

            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"joinedAutoBattle","battleName":"${autoBattleName}","gameCreator":"${gameCreator}","gameCreatorId":"${gameCreatorId}"}]]></body></msg>\x00`;
            break;

        case 'allPlayersReady':
            // Signal all players are ready
            const readyCheckBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (readyCheckBattle) {
                // Check if all players are ready
                const allPlayersReady = readyCheckBattle.players.every(p => p.ready);

                if (allPlayersReady) {
                    // Start the game if all players are ready
                    readyCheckBattle.gameState = 'in_progress';

                    // Set up turn order
                    readyCheckBattle.turnOrder = [...readyCheckBattle.players];

                    // Send game started message to all players
                    const gameStartMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameStarted","battleName":"${readyCheckBattle.name}","players":${JSON.stringify(readyCheckBattle.players.map(p => ({username: p.name, userRefId: p.id})))},"gameCreator":"${readyCheckBattle.creatorName}"}]]></body></msg>\x00`;

                    broadcastToBattle(readyCheckBattle.name, gameStartMsg);

                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"allPlayersReady","battleStarted":true}]]></body></msg>\x00`;
                } else {
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"allPlayersReady","battleStarted":false}]]></body></msg>\x00`;
                }
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'waitingForPlayers':
            // Indicate waiting for players state
            const waitingBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (waitingBattle) {
                waitingBattle.gameState = 'waiting_for_players';

                // Notify all players that we're waiting for more players
                const waitingMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"waitingForPlayers","battleName":"${waitingBattle.name}","currentPlayers":${waitingBattle.players.length},"maxPlayers":${waitingBattle.maxPlayers}}]}</body></msg>\x00`;

                broadcastToBattle(waitingBattle.name, waitingMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"waitingForPlayers","battleName":"${waitingBattle.name}","currentPlayers":${waitingBattle.players.length}}]}</body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'gameStarted':
            // Confirm game has started
            const startedBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (startedBattle) {
                startedBattle.gameState = 'in_progress';

                // Set up turn order
                startedBattle.turnOrder = [...startedBattle.players];

                // Send game started message to all players
                const gameStartMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameStarted","battleName":"${startedBattle.name}","players":${JSON.stringify(startedBattle.players.map(p => ({username: p.name, userRefId: p.id})))},"gameCreator":"${startedBattle.creatorName}"}]]></body></msg>\x00`;

                broadcastToBattle(startedBattle.name, gameStartMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameStarted","battleName":"${startedBattle.name}","players":${JSON.stringify(startedBattle.players.map(p => ({username: p.name, userRefId: p.id})))}}]}</body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'gameSwarmValueSet':
            // Confirm swarm value is set
            const swarmValue = params.gameSwarmValue;
            const swarmValueBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (swarmValueBattle) {
                swarmValueBattle.gameSwarmValue = swarmValue;

                // Notify other players of the change
                const swarmValueSetMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameSwarmValueSet","battleName":"${swarmValueBattle.name}","gameSwarmValue":${swarmValue}}]}</body></msg>\x00`;

                broadcastToBattle(swarmValueBattle.name, swarmValueSetMsg, socket.userId);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameSwarmValueSet","battleName":"${swarmValueBattle.name}","gameSwarmValue":${swarmValue}}]}</body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'swarmSelected':
            // Confirm swarm selection
            const swarmCount = params.swarmCount;
            const username = params.username;
            const userRefId = params.userRefId;
            const swarmSelectBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (swarmSelectBattle) {
                // Notify other players that this player has set their swarm
                const swarmSelectedMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"swarmSelected","battleName":"${swarmSelectBattle.name}","swarmCount":${swarmCount},"username":"${username}","userRefId":"${userRefId}"}]]></body></msg>\x00`;

                broadcastToBattle(swarmSelectBattle.name, swarmSelectedMsg, socket.userId);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"swarmSelected","battleName":"${swarmSelectBattle.name}","swarmCount":${swarmCount},"username":"${username}","userRefId":"${userRefId}"}]]></body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'targetSelected':
            // Confirm target selection
            const userRefIdTarget = params.userRefId;
            const selectedTargetUserRefId = params.targetUserRefId;
            const attackIdTarget = params.attackId;
            const targetSelectBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (targetSelectBattle) {
                // Find the player who selected the target
                const playerIndex = targetSelectBattle.players.findIndex(p => p.id === userRefIdTarget);
                if (playerIndex !== -1) {
                    targetSelectBattle.players[playerIndex].enemyTarget = selectedTargetUserRefId;
                }

                // Send target selected notification to all players
                const targetSelectedMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"targetSelected","userRefId":"${userRefIdTarget}","targetUserRefId":"${selectedTargetUserRefId}","attackId":${attackIdTarget}}]}</body></msg>\x00`;

                broadcastToBattle(targetSelectBattle.name, targetSelectedMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"targetSelected","userRefId":"${userRefIdTarget}","targetUserRefId":"${selectedTargetUserRefId}","attackId":${attackIdTarget}}]}</body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'readyForTurn':
            // Signal player is ready for turn
            const nanovorIdTurn = params.nanovorId;
            const isDead = params.isDead;
            const turnBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (turnBattle) {
                // Send ready for turn notification to the player
                const readyForTurnMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"readyForTurn","battleName":"${turnBattle.name}","nanovorId":${nanovorIdTurn},"isDead":${isDead}}]}</body></msg>\x00`;

                socket.write(readyForTurnMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"readyForTurn","battleName":"${turnBattle.name}","nanovorId":${nanovorIdTurn},"isDead":${isDead}}]}</body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'roundCompleted':
            // Report round completion
            const roundNum = params.round;
            const roundCompleteBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (roundCompleteBattle) {
                // Increment round number
                roundCompleteBattle.round = roundNum || roundCompleteBattle.round + 1;

                // Reset turn counter for the new round
                roundCompleteBattle.currentTurn = 0;

                // Send round completed notification to all players
                const roundCompleteMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"roundCompleted","round":${roundCompleteBattle.round}}]}</body></msg>\x00`;

                broadcastToBattle(roundCompleteBattle.name, roundCompleteMsg);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"roundCompleted","round":${roundCompleteBattle.round}}]}</body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'playerQuitGame':
            // Report player quit
            const quitUserId = params.userRefId;
            const quitUsername = params.username;
            const quitGameBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (quitGameBattle) {
                // Remove player from the battle
                quitGameBattle.players = quitGameBattle.players.filter(p => p.id !== quitUserId);

                // If there's only one player left, end the game
                if (quitGameBattle.players.length <= 1) {
                    quitGameBattle.gameState = 'finished';

                    // Notify remaining players that the game is over
                    const gameOverMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameOver","winnerId":"${quitGameBattle.players[0]?.id || ''}","results":"Game ended due to player quit"}]]></body></msg>\x00`;

                    broadcastToBattle(quitGameBattle.name, gameOverMsg);
                } else {
                    // Notify other players that someone quit
                    const playerQuitMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerQuitGame","userRefId":"${quitUserId}","username":"${quitUsername}"}]]></body></msg>\x00`;

                    broadcastToBattle(quitGameBattle.name, playerQuitMsg);
                }

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"playerQuitConfirmed","userRefId":"${quitUserId}","username":"${quitUsername}"}]]></body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'gameOver':
            console.log(`[GAMEXT_LOG] gameOver command called by user ${socket.userId} (${socket.userName})`, params);
            // Report game over
            const winnerId = params.winnerId;
            const results = params.results;
            const gameOverBattle = socket.activeBattle ? battleRooms[socket.activeBattle] : null;

            if (gameOverBattle) {
                gameOverBattle.gameState = 'finished';
                console.log(`[GAMEXT_LOG] gameOver - battle ${gameOverBattle.name} finished, winner: ${winnerId}, results: ${results}`);

                // Notify all players that the game is over
                const gameOverMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameOver","winnerId":"${winnerId}","results":"${results}"}]]></body></msg>\x00`;

                broadcastToBattle(gameOverBattle.name, gameOverMsg);

                // Update user stats based on game results
                if (users[winnerId]) {
                    users[winnerId].gamesWon = (users[winnerId].gamesWon || 0) + 1;
                    users[winnerId].gamesPlayed = (users[winnerId].gamesPlayed || 0) + 1;
                    console.log(`[GAMEXT_LOG] gameOver - updated stats for winner ${winnerId}: wins=${users[winnerId].gamesWon}, games=${users[winnerId].gamesPlayed}`);

                    // Save user data after updating stats
                    saveUserData(winnerId);
                }

                // Clean up the battle room
                delete battleRooms[gameOverBattle.name];
                console.log(`[GAMEXT_LOG] gameOver - cleaned up battle room ${gameOverBattle.name}`);

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameOver","winnerId":"${winnerId}","results":"${results}"}]]></body></msg>\x00`;
            } else {
                console.log(`[GAMEXT_LOG] gameOver failed - no active battle for user ${socket.userId}`);
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        case 'roomDestroyed':
            // Report room destroyed
            const roomName = params.roomName;
            const destroyBattle = roomName ? battleRooms[roomName] : null;

            if (destroyBattle) {
                // Notify all players in the battle that the room is destroyed
                const roomDestroyMsg = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"roomDestroyed"}]}</body></msg>\x00`;

                broadcastToBattle(roomName, roomDestroyMsg);

                // Clean up the battle room
                delete battleRooms[roomName];

                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"roomDestroyed","roomName":"${roomName}"}]]></body></msg>\x00`;
            } else {
                response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"gameError"}]]></body></msg>\x00`;
            }
            break;

        default:
            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"unknownCommand"}]]></body></msg>\x00`;
    }

    // Only send response if it's not handled by a specific case that sends its own messages
    if (response && !response.includes('invitationSent') && !response.includes('invitationRequest')) {  // Some responses are sent separately
        socket.write(response);
    }
}

function handleExtensionCommand(socket, extension, command, params) {
    console.log(`Handling extension command: ${extension}.${command}`);
    
    let response = '';
    
    switch (extension) {
        case 'loginXt':
            switch (command) {
                case 'updateUserToken':
                    // Update user token
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"userTokenUpdated"}]]></body></msg>\x00`;
                    break;
                case 'updateAvatar':
                    // Update avatar
                    const newAvatarId = params.avatarId || 1;
                    if (users[socket.userId]) {
                        users[socket.userId].avatarId = parseInt(newAvatarId);

                        // Save user data after updating avatar
                        saveUserData(socket.userId);
                    }
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"avatarUpdated"}]]></body></msg>\x00`;
                    break;
                case 'getBuddyAvatar':
                    // Return user's avatar info
                    const user = users[socket.userId] || {};
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"buddyAvatarData","avatarId":${user.avatarId || 1},"nmp":${user.nmp || 0}}]]></body></msg>\x00`;
                    break;
                case 'getUserData':
                case 'syncUserData':
                    // Return comprehensive user data
                    const userData = users[socket.userId] || {};
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"userDataSynced","username":"${socket.userName || 'n'}","avatarId":${userData.avatarId || 1},"nmp":${userData.nmp || 0},"gamesPlayed":${userData.gamesPlayed || 0},"hasSeenNewUserExperience":${userData.hasSeenNewUserExperience || false}}]]></body></msg>\x00`;
                    break;
                case 'updateNanovorCount':
                    // Update nanovor count
                    if (params.nanovorCount !== undefined && users[socket.userId]) {
                        users[socket.userId].nanovorCount = parseInt(params.nanovorCount) || 0;

                        // Save user data after updating nanovor count
                        saveUserData(socket.userId);
                    }
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"nanovorCountUpdated"}]]></body></msg>\x00`;
                    break;

                case 'addNanovor':
                    // Add a nanovor to the user's inventory
                    if (params.nanovorData && users[socket.userId]) {
                        const nanovorData = params.nanovorData;

                        // Ensure nanovorInventory exists
                        if (!users[socket.userId].nanovorInventory) {
                            users[socket.userId].nanovorInventory = [];
                        }

                        // Add the new nanovor to inventory
                        users[socket.userId].nanovorInventory.push(nanovorData);

                        // Update counts
                        users[socket.userId].nanovorCount = users[socket.userId].nanovorInventory.length;
                        users[socket.userId].nanovorCountUnique = users[socket.userId].nanovorInventory.length; // Simplified for now

                        // Save user data after updating inventory
                        saveUserData(socket.userId);
                    }
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"nanovorAdded"}]]></body></msg>\x00`;
                    break;

                case 'removeNanovor':
                    // Remove a nanovor from the user's inventory
                    if (params.nanovorId !== undefined && users[socket.userId]) {
                        const removeNanovorId = parseInt(params.nanovorId);

                        if (users[socket.userId].nanovorInventory) {
                            // Filter out the nanovor with the specified ID
                            users[socket.userId].nanovorInventory = users[socket.userId].nanovorInventory.filter(nanovor => nanovor.id !== removeNanovorId);

                            // Update counts
                            users[socket.userId].nanovorCount = users[socket.userId].nanovorInventory.length;
                            users[socket.userId].nanovorCountUnique = users[socket.userId].nanovorInventory.length; // Simplified for now

                            // Save user data after updating inventory
                            saveUserData(socket.userId);
                        }
                    }
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"nanovorRemoved"}]]></body></msg>\x00`;
                    break;

                case 'addEm':
                    // Add an Energy Matrix to the user's inventory
                    if (params.emData && users[socket.userId]) {
                        const emData = params.emData;

                        // Ensure emInventory exists
                        if (!users[socket.userId].emInventory) {
                            users[socket.userId].emInventory = [];
                        }

                        // Add the new EM to inventory
                        users[socket.userId].emInventory.push(emData);

                        // Update EM count
                        users[socket.userId].ems = users[socket.userId].emInventory.length;

                        // Save user data after updating inventory
                        saveUserData(socket.userId);
                    }
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"emAdded"}]]></body></msg>\x00`;
                    break;

                case 'removeEm':
                    // Remove an Energy Matrix from the user's inventory
                    if (params.emId !== undefined && users[socket.userId]) {
                        const emId = parseInt(params.emId);

                        if (users[socket.userId].emInventory) {
                            // Filter out the EM with the specified ID
                            users[socket.userId].emInventory = users[socket.userId].emInventory.filter(em => em.id !== emId);

                            // Update EM count
                            users[socket.userId].ems = users[socket.userId].emInventory.length;

                            // Save user data after updating inventory
                            saveUserData(socket.userId);
                        }
                    }
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"emRemoved"}]]></body></msg>\x00`;
                    break;
                case 'initialize':  // Likely initial command sent by client to loginXt extension
                case 'login':       // Another possibility for initial login command to extension
                case 'init':        // Another possible initialization command
                    // Send logOK as response to initial extension request
                    // For new users, ensure nmp and gamesPlayed are 0 to trigger NewUserState
                    const userData1 = users[socket.userId] || {};
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"logOK","username":"${socket.userName || 'n'}","chatRoomName":"Lobby","avatarId":${userData1.avatarId || 1},"nmp":${userData1.nmp || 0},"gamesPlayed":${userData1.gamesPlayed || 0}}]]></body></msg>\x00`;
                    break;
                case 'getUserData':  // Request for user data after login
                case 'syncUserData': // Sync user data request
                    // Send user data response
                    const userData2 = users[socket.userId] || {};
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"userDataSynced","username":"${socket.userName || 'n'}","avatarId":${userData2.avatarId || 1},"nmp":${userData2.nmp || 0},"nanocash":${userData2.nanocash || 0},"gamesPlayed":${userData2.gamesPlayed || 0},"hasSeenNewUserExperience":${userData2.hasSeenNewUserExperience || false}}]]></body></msg>\x00`;
                    break;
                default:
                    // For unknown commands, return unknown command response
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"unknownCommand"}]]></body></msg>\x00`;
                    break;
            }
            break;
            
        case 'chatXt':
            switch (command) {
                case 'getChatRoomList':
                    // Room name must match the one handed out in the loginXt logOK
                    // payload, which is "Lobby" - the client joins that and then asks
                    // for the list.
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"chatRoomListResponse","rooms":[{"id":1,"name":"Lobby","userCount":1}]}]]></body></msg>\x00`;
                    break;
                case 'joinChatRoom':
                case 'exitChatRoom':
                    // Chat is push-driven: SmartFoxChatGameService has no ack response
                    // for either of these, so staying silent is correct.
                    response = '';
                    break;
                default:
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"unknownCommand"}]]></body></msg>\x00`;
            }
            break;
            
        case 'tradeXt':
            switch (command) {
                case 'getBadgeList':
                    // Return empty badge list for trade
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"tradeBadgeList","badges":[]}]]></body></msg>\x00`;
                    break;
                default:
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"unknownCommand"}]]></body></msg>\x00`;
            }
            break;
            
        case 'buddyListXt':
            switch (command) {
                case 'getBuddyList':
                    // Return empty buddy list
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"buddyListLoaded","buddies":[]}]]></body></msg>\x00`;
                    break;
                case 'getRecentlyPlayedList':
                    // SmartFoxBuddyListGameService already handles these two; answering
                    // properly instead of unknownCommand lets the buddy panel finish
                    // initializing rather than waiting on a reply it never gets.
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"recentlyPlayedListLoaded","recentlyPlayed":[]}]]></body></msg>\x00`;
                    break;
                case 'loadInvitations':
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"noInvitations"}]]></body></msg>\x00`;
                    break;
                default:
                    response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"unknownCommand"}]]></body></msg>\x00`;
            }
            break;

        case 'gameXt':
            // Handle battle-related commands
            handleGameXtCommand(socket, command, params);
            return; // Return early since response is handled in the function

        default:
            response = `<msg t="xt"><body action="xtRes" r="-1"><![CDATA[{"_cmd":"unknownExtension"}]]></body></msg>\x00`;
    }

    // An empty response means "deliberately no reply" (see chatXt above).
    if (response) {
        socket.write(response);
    }
}

function extractParamsFromRequest(input) {
    // Extract parameters from XML-RPC format
    const params = {};

    // Look for the specific parameter names in the XML-RPC structure
    // The parameters are in the <params> section of the XML-RPC call
    const paramsSection = input.match(/<params>([\s\S]*)<\/params>/);
    if (paramsSection) {
        const paramsContent = paramsSection[1];

        // Look for each parameter individually in the params content
        const playernameMatch = paramsContent.match(/<member><name>playername<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (playernameMatch) params.playername = playernameMatch[1];

        const playerpasswordMatch = paramsContent.match(/<member><name>playerpassword<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (playerpasswordMatch) params.playerpassword = playerpasswordMatch[1];

        const majorversionMatch = paramsContent.match(/<member><name>majorversion<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (majorversionMatch) params.majorversion = majorversionMatch[1];

        const minorversionMatch = paramsContent.match(/<member><name>minorversion<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (minorversionMatch) params.minorversion = minorversionMatch[1];

        const buildversionMatch = paramsContent.match(/<member><name>buildversion<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (buildversionMatch) params.buildversion = buildversionMatch[1];

        // Also look for other common parameters based on the LoginScreenConfig.xml
        const protocolversionMatch = paramsContent.match(/<member><name>protocolversion<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (protocolversionMatch) params.protocolversion = protocolversionMatch[1];

        const appkeyMatch = paramsContent.match(/<member><name>appkey<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (appkeyMatch) params.appkey = appkeyMatch[1];

        const sequencenumberMatch = paramsContent.match(/<member><name>sequencenumber<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (sequencenumberMatch) params.sequencenumber = sequencenumberMatch[1];

        const osnameMatch = paramsContent.match(/<member><name>osname<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (osnameMatch) params.osname = osnameMatch[1];

        const osversionMatch = paramsContent.match(/<member><name>osversion<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (osversionMatch) params.osversion = osversionMatch[1];

        const ostypeMatch = paramsContent.match(/<member><name>ostype<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (ostypeMatch) params.ostype = ostypeMatch[1];

        const serviceMatch = paramsContent.match(/<member><name>service<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (serviceMatch) params.service = serviceMatch[1];

        const localeMatch = paramsContent.match(/<member><name>locale<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
        if (localeMatch) params.locale = localeMatch[1];
    } else {
        // If no params section found with named parameters, try to extract from positional parameters
        // Based on the client log, the username is in the 10th position among the string parameters
        // Extract all string values from param tags
        const allStringValues = input.match(/<param>\s*<value>\s*<string>(.*?)<\/string>\s*<\/value>\s*<\/param>/g);
        if (allStringValues && allStringValues.length >= 12) {  // Need at least 12 params to get to username (10th) and password (11th)
            // The username is in the 10th position (0-indexed: 9th element), password in 11th (0-indexed: 10th element)
            // Extract just the string content from the 9th and 10th parameters
            const usernameMatch = allStringValues[9]?.match(/<param>\s*<value>\s*<string>(.*?)<\/string>\s*<\/value>\s*<\/param>/);
            const passwordMatch = allStringValues[10]?.match(/<param>\s*<value>\s*<string>(.*?)<\/string>\s*<\/value>\s*<\/param>/);

            if (usernameMatch) params.playername = usernameMatch[1];
            if (passwordMatch) params.playerpassword = passwordMatch[1];
        } else {
            // Alternative: extract all string values regardless of param structure
            const allStrings = input.match(/<string>(.*?)<\/string>/g);
            if (allStrings && allStrings.length >= 12) {  // Need at least 12 strings to reach username
                // Extract just the content from the 9th and 10th string elements (0-indexed)
                const usernameContent = allStrings[9]?.match(/<string>(.*?)<\/string>/);
                const passwordContent = allStrings[10]?.match(/<string>(.*?)<\/string>/);

                if (usernameContent) params.playername = usernameContent[1];
                if (passwordContent) params.playerpassword = passwordContent[1];
            } else {
                // Try a more comprehensive approach
                // 0: method version
                // 1: license key
                // 2: major version
                // 3: minor version
                // 4: build
                // 5: revision
                // 6: OS name
                // 7: SP
                // 8: architecture
                // 9: username 
                // 10: password
                // 11: locale
                // 12: app name

                console.log(`[${new Date().toISOString()}] Attempting to extract positional parameters from input`);
                // Use match() instead of matchAll() for better compatibility
                const allStringMatches = input.match(/<string>(.*?)<\/string>/g);
                console.log(`[${new Date().toISOString()}] Found ${allStringMatches ? allStringMatches.length : 0} string matches`);

                if (allStringMatches && allStringMatches.length >= 10) {
                    // Extract the content from each match
                    const extractedStrings = allStringMatches.map(match => {
                        const contentMatch = match.match(/<string>(.*?)<\/string>/);
                        return contentMatch ? contentMatch[1] : null;
                    }).filter(content => content !== null);

                    console.log(`[${new Date().toISOString()}] Extracted ${extractedStrings.length} string values:`, extractedStrings);

                    if (extractedStrings.length >= 10) {
                        params.playername = extractedStrings[9];  // 10th parameter (0-indexed: 9)
                        params.playerpassword = extractedStrings[10] || '';  // 11th parameter (0-indexed: 10)
                        console.log(`[${new Date().toISOString()}] Extracted playername: '${params.playername}', playerpassword: '${params.playerpassword}'`);
                    }
                } else {
                    // If no params section found, try to extract from the methodCall directly
                    // This might happen if the XML structure is different
                    console.log('No params section found, trying alternative extraction');

                    // Extract from the connect attributes in the original XML structure if it exists
                    const connectMatch = input.match(/<connect\s+([^>]+)>/);
                    if (connectMatch) {
                        const attrs = connectMatch[1];

                        // Extract each attribute using regex
                        const playernameMatch = attrs.match(/playername="([^"]*)"/);
                        if (playernameMatch) params.playername = playernameMatch[1];

                        const playerpasswordMatch = attrs.match(/playerpassword="([^"]*)"/);
                        if (playerpasswordMatch) params.playerpassword = playerpasswordMatch[1];

                        const majorversionMatch = attrs.match(/majorversion="([^"]*)"/);
                        if (majorversionMatch) params.majorversion = majorversionMatch[1];

                        const minorversionMatch = attrs.match(/minorversion="([^"]*)"/);
                        if (minorversionMatch) params.minorversion = minorversionMatch[1];

                        const buildversionMatch = attrs.match(/buildversion="([^"]*)"/);
                        if (buildversionMatch) params.buildversion = buildversionMatch[1];

                        const protocolversionMatch = attrs.match(/protocolversion="([^"]*)"/);
                        if (protocolversionMatch) params.protocolversion = protocolversionMatch[1];

                        const appkeyMatch = attrs.match(/appkey="([^"]*)"/);
                        if (appkeyMatch) params.appkey = appkeyMatch[1];

                        const sequencenumberMatch = attrs.match(/sequencenumber="([^"]*)"/);
                        if (sequencenumberMatch) params.sequencenumber = sequencenumberMatch[1];

                        const osnameMatch = attrs.match(/osname="([^"]*)"/);
                        if (osnameMatch) params.osname = osnameMatch[1];

                        const osversionMatch = attrs.match(/osversion="([^"]*)"/);
                        if (osversionMatch) params.osversion = osversionMatch[1];

                        const ostypeMatch = attrs.match(/ostype="([^"]*)"/);
                        if (ostypeMatch) params.ostype = ostypeMatch[1];

                        const serviceMatch = attrs.match(/service="([^"]*)"/);
                        if (serviceMatch) params.service = serviceMatch[1];

                        const localeMatch = attrs.match(/locale="([^"]*)"/);
                        if (localeMatch) params.locale = localeMatch[1];
                    }
                }
            }
        }
    }

    return params;
}

function extractParamsFromXmlRpc(xml) {
    // Simple extraction of parameters from XML-RPC
    const params = {};

    // Extract common parameters
    const playernameMatch = xml.match(/<member><name>playername<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
    if (playernameMatch) params.playername = playernameMatch[1];

    const playerpasswordMatch = xml.match(/<member><name>playerpassword<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
    if (playerpasswordMatch) params.playerpassword = playerpasswordMatch[1];

    const majorversionMatch = xml.match(/<member><name>majorversion<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
    if (majorversionMatch) params.majorversion = majorversionMatch[1];

    const minorversionMatch = xml.match(/<member><name>minorversion<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
    if (minorversionMatch) params.minorversion = minorversionMatch[1];

    const buildversionMatch = xml.match(/<member><name>buildversion<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
    if (buildversionMatch) params.buildversion = buildversionMatch[1];

    const revisionversionMatch = xml.match(/<member><name>revisionversion<\/name><value><string>(.*?)<\/string><\/value><\/member>/);
    if (revisionversionMatch) params.revisioinversion = revisionversionMatch[1];

    return params;
}

function createSrbResponse(accountId, loginToken) {
    // Create XML-RPC response with service endpoints
    // Using the format that the client's ServiceRequestBrokerParser expects
    // Each entry should be in the format "Name: Value" so the parser can split on ":"
    // Avoid colons in values to prevent parsing issues (like in URLs with http://)
    // Note: Using direct text content in value elements instead of wrapping in string elements
    const response = `<?xml version="1.0"?>
<methodResponse>
  <params>
    <param>
      <value>
        <array>
          <data>
            <value>Action: CONNECT</value>  <!-- Action type in the format "Action: TYPE" -->
            <value>Game Service IP: 127.0.0.1: 9339</value>  <!-- Game Service IP in format "Name: IP: Port" for port extraction -->
            <value>Login Token: ${loginToken}</value>  <!-- Login Token with proper naming -->
            <value>AccountId: ${accountId}</value>  <!-- Account ID with proper naming -->
            <value>Web service bankfe: 127.0.0.1:8443</value>  <!-- BANK_URL with IP:PORT format (no http://) -->
            <value>Web service bankfe read: 127.0.0.1:8443</value>  <!-- BANK_URL_READ with IP:PORT format (no http://) -->
            <value>Static File Service IP: 127.0.0.1: 8443</value>  <!-- SFS_URL. MUST NOT be the game port (9339): the client treats this as a plain HTTP file service and was sending GET /manifest.xml to the SmartFox socket, so the game socket never opened. Express serves /manifest.xml and /clientbin/data/AppManifest.xml on 8443. -->
            <value>Download Service IP: 127.0.0.1</value>  <!-- DOWNLOAD_SERVICE_IP with proper naming -->
            <value>Download Service URL: 127.0.0.1:8443</value>  <!-- DOWNLOAD_SERVICE_URL with IP:PORT format (no http://) -->
            <value>Web service cpnfe: 127.0.0.1:8443</value>  <!-- COUPON_HOST_URL with IP:PORT format (no http://) -->
            <value>Web service gftfe: 127.0.0.1:8443</value>  <!-- NANOCASH_CARD_HOST_URL with IP:PORT format (no http://) -->
            <value>Shard List URL: 127.0.0.1:8443/scws/</value>  <!-- SHARD_LIST_URL with IP:PORT/PATH format (no http://) -->
            <value>Protocol Version: 1.5.6</value>  <!-- PROTOCOL_VERSION with proper naming -->
            <value>Client Version: 1.2.0</value>  <!-- CLIENT_VERSION with proper naming -->
          </data>
        </array>
      </value>
    </param>
  </params>
</methodResponse>`;

    return response;
}

function generateToken() {
    return crypto.randomBytes(32).toString('hex');
}

// Account IDs must be DECIMAL NUMERIC strings.
//
// The client stores the account id in an int:
//   UserProfile.as:92      private var _id:int;
//   ServiceRequestBrokerManager.as:454
//       _userProfile.setId(int(getServiceRequestBrokerValue(ACCOUNT_ID)));
// AS3's int("7b8b965a") is 0, so a hex id silently became 0 and every gameXt /
// tradeXt command went out with userRefId: 0 - no identity comparison could ever
// match. The HTTP side is unaffected (bank URLs use the id as a string), but the
// socket side is not.
//
// Derived from the username so an existing account keeps a stable id across
// restarts. 2^31-1 ceiling keeps it inside int range.
function generateAccountId(username) {
    const digest = crypto.createHash('md5').update(username).digest('hex');
    const numeric = parseInt(digest.substring(0, 8), 16) % 2147483647;
    return String(numeric || 1); // never 0 - the client treats 0 as "no account"
}

// Function to format date in the correct format: YYYY-MM-DDTHH:MM:SS.mmm+HH:MM
function formatDateForNanovor(date) {
    const year = date.getFullYear().toString().padStart(4, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    const seconds = date.getSeconds().toString().padStart(2, '0');
    const milliseconds = date.getMilliseconds().toString().padStart(3, '0');

    // Get timezone offset in the format +HH:MM or -HH:MM
    const tzOffset = -date.getTimezoneOffset();
    const tzSign = tzOffset >= 0 ? '+' : '-';
    const tzHours = Math.floor(Math.abs(tzOffset) / 60).toString().padStart(2, '0');
    const tzMinutes = (Math.abs(tzOffset) % 60).toString().padStart(2, '0');
    const tzString = `${tzSign}${tzHours}:${tzMinutes}`;

    return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}.${milliseconds}${tzString}`;
}

function createUserProfile(accountId, username) {
    // Create a comprehensive user profile with all required fields
    const userProfile = {
        id: accountId,
        username: username,
        screenname: username, // Display name
        email: `${username}@nanovor.example.com`,
        phoneNumber: "",
        nanocash: STARTER_NANOCASH, // CONFIRMED: the original game started players at 400
        nmp: 0, // Nanovor Mastery Points
        nanovorCount: 2, // Total nanovor owned (starting with 2 default nanovor)
        nanovorCountUnique: 2, // Number of unique nanovor types owned
        ems: 0, // Count of Energy Matrices owned
        healthJolts: 0, // Available health enhancement points
        armorJolts: 0, // Available armor enhancement points
        strengthJolts: 0, // Available strength enhancement points
        speedJolts: 0, // Available speed enhancement points
        avatarId: 1, // Selected avatar ID
        breadcrumbCount: 0, // Number of breadcrumbs collected
        gamesWon: 0, // Total games won
        gamesPlayed: 0, // Total games played
        totalKills: 0, // Total kills across all battles
        hexiteKills: 0, // Kills with Hexite faction nanovor
        magnamodKills: 0, // Kills with Magnamod faction nanovor
        velocitronKills: 0, // Kills with Velocitron faction nanovor
        twoPlayerGames: 0, // Number of 2-player games
        threePlayerGames: 0, // Number of 3-player games
        fourPlayerGames: 0, // Number of 4-player games
        battleCount: 0, // Number of battles participated (client-side counter)
        hasSeenNewUserExperience: false, // Flag to track if user has completed new user experience
        created: new Date(),
        lastLogin: new Date(),
        online: true,
        // Inventory data
        nanovorInventory: [
            // Default starting nanovor for new players - Electropod 1.0 (assetTypeId 1)
            {
                id: 1,  // Electropod 1.0
                name: "Electropod 1.0",
                faction: "Magnamod",
                rarity: "common",
                wave: 1,
                health: 100,  // base-health from virmon-master-decoded.xml
                armor: 5,     // base-armor from virmon-master-decoded.xml
                speed: 10,    // base-speed from virmon-master-decoded.xml
                strength: 120,// base-strength from virmon-master-decoded.xml
                pv: 175,      // point value for Electropod 1.0 from virmon-master-decoded.xml
                type: "virmon",
                assetTypeId: 1,
                assetId: newNanovorAssetId(),  // Unique instance ID; decimal so it can round-trip through a Nanoscope vinfo.bbb
                productionNumber: 1,
                birthDate: formatDateForNanovor(new Date()),
                lastEvolutionDate: formatDateForNanovor(new Date()),
                killCount: 0,
                lifetimeKillCount: 0,
                battleCount: 0,
                lifetimeBattleCount: 0,
                deathCount: 0,
                lifetimeDeathCount: 0,
                magnamodKillCount: 0,
                magnamodLifetimeKillCount: 0,
                hexiteKillCount: 0,
                hexiteLifetimeKillCount: 0,
                velocitronKillCount: 0,
                velocitronLifetimeKillCount: 0,
                winCount: 0,
                lifetimeWinCount: 0,
                criticalHitCount: 0,
                whiffCount: 0,
                isScreenStar: false,
                isScrapedBy: false,
                areAllAttacksUsed: false,
                isSlacker: false,
                maxDamageGame: 0,
                maxDamageHit: 0,
                maxRoundCount: 0,
                nickname: ""
            },
            // Default starting nanovor for new players - Doom Blade 1.0 (assetTypeId 24)
            {
                id: 24,  // Doom Blade 1.0
                name: "Doom Blade 1.0",
                faction: "Velocitron",  // Correct faction from virmon-master-decoded.xml
                rarity: "common",
                wave: 1,
                health: 100,  // base-health from virmon-master-decoded.xml
                armor: 0,     // base-armor from virmon-master-decoded.xml
                speed: 25,    // base-speed from virmon-master-decoded.xml
                strength: 85, // base-strength from virmon-master-decoded.xml
                pv: 160,      // point value for Doom Blade 1.0 from virmon-master-decoded.xml
                type: "virmon",
                assetTypeId: 24,
                assetId: newNanovorAssetId(),  // Unique instance ID; decimal so it can round-trip through a Nanoscope vinfo.bbb
                productionNumber: 1,
                birthDate: formatDateForNanovor(new Date()),
                lastEvolutionDate: formatDateForNanovor(new Date()),
                killCount: 0,
                lifetimeKillCount: 0,
                battleCount: 0,
                lifetimeBattleCount: 0,
                deathCount: 0,
                lifetimeDeathCount: 0,
                magnamodKillCount: 0,
                magnamodLifetimeKillCount: 0,
                hexiteKillCount: 0,
                hexiteLifetimeKillCount: 0,
                velocitronKillCount: 0,
                velocitronLifetimeKillCount: 0,
                winCount: 0,
                lifetimeWinCount: 0,
                criticalHitCount: 0,
                whiffCount: 0,
                isScreenStar: false,
                isScrapedBy: false,
                areAllAttacksUsed: false,
                isSlacker: false,
                maxDamageGame: 0,
                maxDamageHit: 0,
                maxRoundCount: 0,
                nickname: ""
            }
        ], // Array of owned nanovor
        emInventory: [
            // Starting EMs for new players - one from each faction to match starting nanovor
            {
                id: "em_1007",  // 1M1 - Magnamod common EM to match Electropod 1.0 (Magnamod)
                name: "1M1",
                type: "em",
                assetTypeId: 1007,
                assetId: uuidv4().substring(0, 8),  // Unique instance ID for this specific EM (without prefix that might cause parsing issues)
                productionNumber: 1,
                birthDate: formatDateForNanovor(new Date()),
                lastEvolutionDate: formatDateForNanovor(new Date()),
                nickname: ""
            },
            {
                id: "em_1013",  // 1V1 - Velocitron common EM to match Doom Blade 1.0 (Velocitron)
                name: "1V1",
                type: "em",
                assetTypeId: 1013,
                assetId: uuidv4().substring(0, 8),  // Unique instance ID for this specific EM (without prefix that might cause parsing issues)
                productionNumber: 1,
                birthDate: formatDateForNanovor(new Date()),
                lastEvolutionDate: formatDateForNanovor(new Date()),
                nickname: ""
            }
        ], // Array of owned Energy Matrices
        badges: [] // Array of earned badges
    };

    return userProfile;
}

function findSessionByToken(token) {
    for (const sessionId in sessions) {
        if (sessions[sessionId].loginToken === token) {
            return sessions[sessionId];
        }
    }
    return null;
}

// Function to save user data to a file
function saveUserData(userId) {
    if (!users[userId]) {
        console.log(`User ${userId} not found, cannot save data`);
        return;
    }

    const userDataDir = path.join(__dirname, 'UserData');
    if (!fs.existsSync(userDataDir)) {
        fs.mkdirSync(userDataDir, { recursive: true });
    }

    // Use username as the filename instead of userId
    const username = users[userId].username;
    console.log(`[${new Date().toISOString()}] Saving user data for username: '${username}', userId: '${userId}'`);
    const fileName = username.replace(/[^a-zA-Z0-9_-]/g, '_'); // Sanitize filename
    const filePath = path.join(userDataDir, `${fileName}.json`);
    const userData = { ...users[userId] }; // Create a copy to avoid reference issues

    // Don't save session-specific data
    delete userData.online;

    try {
        fs.writeFileSync(filePath, JSON.stringify(userData, null, 2));
        console.log(`Saved user data for ${username} (ID: ${userId}) to ${filePath}`);
    } catch (error) {
        console.error(`Error saving user data for ${username} (ID: ${userId}):`, error);
    }
}

// Function to load user data from a file by username
function loadUserDataByUsername(username) {
    const userDataDir = path.join(__dirname, 'UserData');
    const fileName = username.replace(/[^a-zA-Z0-9_-]/g, '_'); // Sanitize filename
    const filePath = path.join(userDataDir, `${fileName}.json`);

    if (fs.existsSync(filePath)) {
        try {
            const userData = JSON.parse(fs.readFileSync(filePath, 'utf8'));

            // Normalize legacy account files. reset-account.bat restores
            // UserData.orig-backup/n.json, which predates two format changes:
            //  * account ids are now decimal (see generateAccountId - the client
            //    int()s the id, so a hex id became 0). The session is keyed by
            //    generateAccountId(username), so a file still carrying the old id
            //    would be filed under the wrong key and every bank call would miss.
            //  * nanovor instance ids used to equal their type id ("1", "24"), so
            //    a second copy of the same nanovor collided on <asset id>.
            //  * nanovor instance ids used to be 8 hex chars. A Nanoscope stores the
            //    id as a u64 and the client finds the nanovor by its decimal string,
            //    so a hex id can never make it onto a device.
            let migrated = false;
            const expectedId = generateAccountId(username);
            if (String(userData.id) !== expectedId) {
                console.log(`Migrating ${username}: account id ${userData.id} -> ${expectedId}`);
                userData.id = expectedId;
                migrated = true;
            }
            const seenAssetIds = new Set();
            for (const n of userData.nanovorInventory || []) {
                const aid = String(n.assetId);
                if (!/^[1-9]\d*$/.test(aid) || aid === String(n.assetTypeId) || seenAssetIds.has(aid)) {
                    let fresh;
                    do { fresh = newNanovorAssetId(); } while (seenAssetIds.has(fresh));
                    console.log(`Migrating ${username}: nanovor ${n.name} instance id ${n.assetId} -> ${fresh}`);
                    n.assetId = fresh;
                    migrated = true;
                }
                seenAssetIds.add(String(n.assetId));
            }

            // Use the username's account ID to store in the users object
            const userId = userData.id;

            // Ensure emInventory exists and has starting EMs for users who don't have any
            if (!userData.emInventory || userData.emInventory.length === 0) {
                console.log(`User ${username} (ID: ${userId}) has no EMs, adding starting EMs`);
                userData.emInventory = [
                    // Add starting EMs for users who don't have any
                    {
                        id: "em_1007",  // 1M1 - Magnamod common EM to match Electropod 1.0 (Magnamod)
                        name: "1M1",
                        type: "em",
                        assetTypeId: 1007,
                        assetId: uuidv4().substring(0, 8),  // Unique instance ID for this specific EM (without prefix that might cause parsing issues)
                        productionNumber: 1,
                        birthDate: formatDateForNanovor(new Date()),
                        lastEvolutionDate: formatDateForNanovor(new Date()),
                        nickname: ""
                    },
                    {
                        id: "em_1013",  // 1V1 - Velocitron common EM to match Doom Blade 1.0 (Velocitron)
                        name: "1V1",
                        type: "em",
                        assetTypeId: 1013,
                        assetId: uuidv4().substring(0, 8),  // Unique instance ID for this specific EM (without prefix that might cause parsing issues)
                        productionNumber: 1,
                        birthDate: formatDateForNanovor(new Date()),
                        lastEvolutionDate: formatDateForNanovor(new Date()),
                        nickname: ""
                    }
                ];

                // Update the user's EM count
                userData.ems = userData.emInventory.length;

                // Saved below, once users[userId] exists. This used to call
                // saveUserData() here, before the user was registered, so the
                // backfill never persisted and was re-granted on every load.
                migrated = true;
            }

            // Counters drift from the inventories they summarize
            const emCount = (userData.emInventory || []).length;
            if (userData.ems !== emCount) { userData.ems = emCount; migrated = true; }

            // Restore the user data
            users[userId] = { ...userData, online: false }; // Set as offline initially
            if (migrated) saveUserData(userId);
            console.log(`Loaded user data for ${username} (ID: ${userId}) from ${filePath}`);
            console.log(`Loaded user nanovor inventory:`, userData.nanovorInventory);
            console.log(`Loaded user em inventory:`, userData.emInventory);
            console.log(`Full loaded user nanovor inventory:`, JSON.stringify(userData.nanovorInventory, null, 2));
            return users[userId];
        } catch (error) {
            console.error(`Error loading user data for ${username}:`, error);
            return null;
        }
    } else {
        console.log(`User data file does not exist for ${username} at ${filePath}`);
    }
    return null; // User file doesn't exist
}

// Function to load user data from a file by userId (for backward compatibility)
function loadUserData(userId) {
    // First try to find the user by looking through saved files
    const userDataDir = path.join(__dirname, 'UserData');
    if (!fs.existsSync(userDataDir)) {
        return null;
    }

    const files = fs.readdirSync(userDataDir);
    for (const file of files) {
        if (file.endsWith('.json')) {
            try {
                const userData = JSON.parse(fs.readFileSync(path.join(userDataDir, file), 'utf8'));
                if (userData.id === userId) {
                    // Restore the user data
                    users[userId] = { ...userData, online: false }; // Set as offline initially
                    console.log(`Loaded user data for ${userData.username} (ID: ${userId}) from ${file}`);
                    return users[userId];
                }
            } catch (error) {
                console.error(`Error loading user data from ${file}:`, error);
            }
        }
    }
    return null; // User file doesn't exist
}

// Function to load all user data at startup
function loadAllUserData() {
    const userDataDir = path.join(__dirname, 'UserData');
    if (!fs.existsSync(userDataDir)) {
        console.log('UserData directory does not exist, no users to load');
        return;
    }

    const files = fs.readdirSync(userDataDir);
    let loadedUsers = 0;

    for (const file of files) {
        if (file.endsWith('.json')) {
            // Load user data by reading the file and extracting username
            const filePath = path.join(userDataDir, file);
            try {
                const userData = JSON.parse(fs.readFileSync(filePath, 'utf8'));
                const username = userData.username;
                if (username) {
                    // Use the username-based loader to properly map the data
                    loadUserDataByUsername(username);
                    loadedUsers++;
                }
            } catch (error) {
                console.error(`Error loading user data from ${file}:`, error);
            }
        }
    }

    console.log(`Loaded ${loadedUsers} user profiles from saved data`);
}

// Keep the process alive when a protocol handler throws.
// Last-resort net. The SFS data path now catches per-frame (see the framing block
// in sfsServer's 'data' handler), so this mainly covers everything else.
process.on('uncaughtException', (err) => {
    console.error('!!! UNCAUGHT EXCEPTION (server kept alive) !!!');
    console.error(err && err.stack ? err.stack : err);
});

process.on('unhandledRejection', (reason) => {
    console.error('!!! UNHANDLED REJECTION (server kept alive) !!!');
    console.error(reason && reason.stack ? reason.stack : reason);
});

// Load existing user data at startup
loadAllUserData();

// Start servers with error handling
const httpPort = 8443;

server.listen(httpPort, () => {
    console.log(`HTTP server running on port ${httpPort}`);
});

server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.error(`Port ${httpPort} is already in use. Please stop the existing server first.`);
    } else {
        console.error('HTTP server error:', err);
    }
    process.exit(1);
});

sfsServer.listen(sfsPort, () => {
    console.log(`SmartFoxServer emulator running on port ${sfsPort}`);
});

// Flash socket policy server. Non-fatal if it cannot bind: port 843 is
// privileged on Linux, and Flash falls back to an inline <policy-file-request/>
// on the game port, which is handled in the socket data handler.
policyServer.listen(policyPort, () => {
    console.log(`Flash socket policy server running on port ${policyPort}`);
});

policyServer.on('error', (err) => {
    console.error(`Flash policy server could NOT bind port ${policyPort}: ${err.code}.`);
    console.error('Continuing anyway - relying on the inline policy request on the game port.');
});

sfsServer.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.error(`Port ${sfsPort} is already in use. Please stop the existing server first.`);
    } else {
        console.error('SmartFoxServer error:', err);
    }
    process.exit(1);
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\nShutting down servers...');

    // Save all user data before shutting down
    for (const userId in users) {
        saveUserData(userId);
    }

    server.close(() => console.log('HTTP server closed'));
    sfsServer.close(() => console.log('SFS server closed'));
    process.exit(0);
});

console.log('Nanovor Server started successfully!');