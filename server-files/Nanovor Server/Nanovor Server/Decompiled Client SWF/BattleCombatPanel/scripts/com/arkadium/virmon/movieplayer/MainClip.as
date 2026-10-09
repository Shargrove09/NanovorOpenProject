package com.arkadium.virmon.movieplayer
{
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.xml.*;
   
   public dynamic class MainClip extends MovieClip
   {
      
      public var _nPlayers:Number;
      
      public var _smcFightEngine:FightEngine;
      
      internal var xmlLoader:URLLoader;
      
      public var _smcVersionControl:VersionDisplay;
      
      public function MainClip()
      {
         super();
         onInitialize();
      }
      
      public function clearBattle() : void
      {
         _smcFightEngine.clearBattle();
      }
      
      public function initFlashVars() : *
      {
      }
      
      public function startTurn(param1:*) : *
      {
         DebugLog.instance.log("MainClip::startTurn xTurn:\n" + param1);
         _smcFightEngine.prepareTurn(param1);
      }
      
      public function onInitialize() : *
      {
         initSounds();
         _smcVersionControl._sdtVersionHistory.text = "AS3T.0.2_VirMPlayer.0.9.5" + "\n";
      }
      
      public function initSounds() : *
      {
      }
      
      public function initiateNewBattle(param1:Number, param2:ICharacterAssetTypeCache, param3:IOverlayAssetRetriever) : *
      {
         _nPlayers = param1;
         DataManager.getInstance()._nFirstContainerX = Number(170);
         DataManager.getInstance()._nContainerSeperationX = Number(650);
         DataManager.getInstance()._nContainerY = Number(500);
         DataManager.getInstance()._nMaxOverlays = Number(6);
         DataManager.getInstance()._nContainerBaselineY = Number(590);
         _smcFightEngine.initiateBattle(_nPlayers,param2,param3);
         dispatchEvent(new Event("ON_LEVEL_XML_LOADED"));
      }
   }
}

