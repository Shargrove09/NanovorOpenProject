'use strict';

// ---------------------------------------------------------------------------
// Account identity + save-file locations, shared by the server and tools/dev.js.
//
// The client's UserProfile._id is an int and it does int(ACCOUNT_ID), so account
// ids must be DECIMAL (see AGENTS.md "Account IDs must be decimal"). The id is
// derived from the username, so it is stable: 'n' is always 2072745562. That is
// why the dev CLI can take a username everywhere the dev endpoints want an id.
//
// Save files are named by USERNAME (saveUserData sanitises it), while the in
// memory `users` map is keyed by ACCOUNT ID - hence the two helpers below.
// ---------------------------------------------------------------------------

const crypto = require('crypto');
const path = require('path');

// Accounts that tools may reset/delete without --force. Everything else -
// including any real progress account you create later - is protected by
// default, so a reflex `reset` can never wipe it.
const TEST_ACCOUNTS = ['n'];

function generateAccountId(username) {
    const digest = crypto.createHash('md5').update(username).digest('hex');
    const numeric = parseInt(digest.substring(0, 8), 16) % 2147483647;
    return String(numeric || 1); // never 0 - the client treats 0 as "no account"
}

// Mirrors saveUserData's sanitising so tools can find the right file.
function userFileName(username) {
    return `${String(username).replace(/[^a-zA-Z0-9_-]/g, '_')}.json`;
}

const userDataDir = serverRoot => path.join(serverRoot, 'UserData');
const baselineDir = serverRoot => path.join(serverRoot, 'UserData.orig-backup');
const snapshotDir = (serverRoot, username) =>
    path.join(serverRoot, 'UserData.snapshots', String(username).replace(/[^a-zA-Z0-9_-]/g, '_'));

const userFile = (serverRoot, username) => path.join(userDataDir(serverRoot), userFileName(username));
const baselineFile = (serverRoot, username) => path.join(baselineDir(serverRoot), userFileName(username));
const snapshotFile = (serverRoot, username, label) =>
    path.join(snapshotDir(serverRoot, username), `${String(label).replace(/[^a-zA-Z0-9_.-]/g, '_')}.json`);

const isTestAccount = username => TEST_ACCOUNTS.includes(String(username));

module.exports = {
    TEST_ACCOUNTS,
    generateAccountId,
    userFileName,
    userDataDir,
    baselineDir,
    snapshotDir,
    userFile,
    baselineFile,
    snapshotFile,
    isTestAccount,
};
