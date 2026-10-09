package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class DeviceMiniGameRetriever implements IDeviceMiniGameRetriever
   {
      
      private static const GAME_COUNT:int = 4;
      
      private static const GAME_INFO_FILE:String = "game.bin";
      
      private var _driveLetter:String;
      
      private var _deviceMiniGameRetrieverProvider:IDeviceMiniGameRetrieverProvider;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceMiniGameRetriever(param1:IDeviceMiniGameRetrieverProvider, param2:IFileOperator, param3:String)
      {
         super();
         _deviceMiniGameRetrieverProvider = param1;
         _fileOperator = param2;
         _driveLetter = param3;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceMiniGameRetriever>> " + param1);
      }
      
      public function getDeviceMiniGames(param1:IDeviceMiniGamesReceiver, param2:Array = null, param3:int = 1) : void
      {
         var folderName:String;
         var folderSize:Number = NaN;
         var gameFilePath:String = null;
         var loader:URLLoader = null;
         var deviceFileFormat:String = null;
         var request:URLRequest = null;
         var deviceMiniGamesReceiver:IDeviceMiniGamesReceiver = param1;
         var deviceMiniGameList:Array = param2;
         var gameFolderIndex:int = param3;
         log("getDeviceMiniGames(): gameFolderIndex: " + gameFolderIndex);
         if(null == deviceMiniGameList)
         {
            deviceMiniGameList = new Array();
         }
         folderName = _driveLetter + "g" + gameFolderIndex;
         log("FolderName: " + folderName);
         if(_fileOperator.doesFolderExist(folderName))
         {
            folderSize = Number(_fileOperator.getFolderSize(folderName));
            log("folderSize: " + folderSize);
            if(folderSize > 0)
            {
               gameFilePath = folderName + "\\" + GAME_INFO_FILE;
               log("GameFilePath: " + gameFilePath);
               loader = new URLLoader();
               deviceFileFormat = URLLoaderDataFormat.BINARY;
               loader.dataFormat = deviceFileFormat;
               loader.addEventListener(Event.COMPLETE,function(param1:Event):void
               {
                  IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
                  IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,onGameFileError);
                  handleGameFileLoaded(ByteArray(param1.target.data),deviceMiniGamesReceiver,deviceMiniGameList,gameFolderIndex);
               });
               loader.addEventListener(IOErrorEvent.IO_ERROR,onGameFileError);
               request = new URLRequest(gameFilePath);
               try
               {
                  loader.load(request);
               }
               catch(error:Error)
               {
                  trace("error loading gameFilePath");
               }
            }
            else
            {
               gameFolderIndex++;
               if(gameFolderIndex > GAME_COUNT)
               {
                  deviceMiniGamesReceiver.handleDeviceMiniGamesReceived(deviceMiniGameList);
               }
               else
               {
                  getDeviceMiniGames(deviceMiniGamesReceiver,deviceMiniGameList,gameFolderIndex);
               }
            }
         }
         else
         {
            gameFolderIndex++;
            log("gameFolderIndex: " + gameFolderIndex.toString());
            if(gameFolderIndex > GAME_COUNT)
            {
               deviceMiniGamesReceiver.handleDeviceMiniGamesReceived(deviceMiniGameList);
            }
            else
            {
               getDeviceMiniGames(deviceMiniGamesReceiver,deviceMiniGameList,gameFolderIndex);
            }
         }
      }
      
      private function onGameFileError(param1:IOErrorEvent) : void
      {
         log("onGameFileError()" + param1.text);
      }
      
      private function handleGameFileLoaded(param1:ByteArray, param2:IDeviceMiniGamesReceiver, param3:Array, param4:int) : void
      {
         log("handleGameFileLoaded()");
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:String = MiniGames.getName(param1);
         log("GameName: " + _loc6_);
         var _loc7_:String = MiniGames.getDescription(param1);
         log("GameDescription: " + _loc7_);
         var _loc8_:int = MiniGames.getJolts(param1);
         log("GameJolts: " + _loc8_);
         var _loc9_:GameData = new GameData(_loc6_,MiniGames.getJoltType(_loc8_),_loc7_);
         param3.push(_loc9_);
         param4++;
         if(param4 > GAME_COUNT)
         {
            param2.handleDeviceMiniGamesReceived(param3);
         }
         else
         {
            _deviceMiniGameRetrieverProvider.deviceMiniGameRetriever.getDeviceMiniGames(param2,param3,param4);
         }
      }
   }
}

