package com.arkadium.virmon.battle.substates.combatgame.animation
{
   import com.arkadium.virmon.battle.control.BattleEngineEvent;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.movieplayer.MainClip;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.events.*;
   import flash.net.URLRequest;
   
   public class CAnimation extends EventDispatcher
   {
      
      public static var ON_LOAD:* = "onload";
      
      public static var ON_TURN_COMPLETE:* = "onturncomplete";
      
      public static var ON_EVENT_TRIGGER:* = "oneventtrigger";
      
      private var _nPlayers:Number;
      
      private var _xTurn:XML;
      
      private var _bLevelXmlLoaded:Boolean;
      
      private var _overlayAssetRetriever:IOverlayAssetRetriever;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _loader:Loader;
      
      private var _mcBattleGround:DisplayObjectContainer;
      
      private var _mcMoviePlayer:MainClip;
      
      private var _sPacketHackAndOverrideChanges:*;
      
      public function CAnimation(param1:ICharacterAssetTypeCache, param2:IOverlayAssetRetriever)
      {
         super();
         _characterAssetTypeCache = param1;
         _overlayAssetRetriever = param2;
         _bLevelXmlLoaded = false;
         _xTurn = null;
      }
      
      public function linkEvent(param1:BattleEngineEvent) : *
      {
         this.dispatchEvent(new BattleEngineEvent(ON_EVENT_TRIGGER,param1.data));
      }
      
      public function endTurn(param1:Event) : *
      {
         DebugLog.instance.log("CAnimation::endTurn fma");
         _mcMoviePlayer._smcFightEngine._oEventDispatcher.removeEventListener("ON_EVENT_TRIGGER",linkEvent);
         _mcMoviePlayer._smcFightEngine._oEventDispatcher.removeEventListener("END_TURN_ACTION",endTurn);
         this.dispatchEvent(new Event(ON_TURN_COMPLETE));
         setSound(false);
      }
      
      public function clearVirmon(param1:uint) : void
      {
         if(Boolean(_mcMoviePlayer) && Boolean(_mcMoviePlayer._smcFightEngine))
         {
            _mcMoviePlayer._smcFightEngine.clearVirmon(param1);
         }
      }
      
      public function setHackAndOverrideChanges(param1:String) : void
      {
         _sPacketHackAndOverrideChanges = param1;
      }
      
      public function setSound(param1:Boolean) : void
      {
         _mcMoviePlayer._smcFightEngine.setSound(param1);
      }
      
      public function destroy() : void
      {
         DebugLog.instance.log("destroying CAnimation");
         if(_mcMoviePlayer != null)
         {
            _mcMoviePlayer._smcFightEngine._oEventDispatcher.removeEventListener("END_TURN_ACTION",endTurn);
            _mcMoviePlayer._smcFightEngine._oEventDispatcher.removeEventListener("EVENT_TRIGGER",linkEvent);
            _mcMoviePlayer.removeEventListener("ON_LEVEL_XML_LOADED",onLevelXmlLoaded);
         }
         if(_loader != null)
         {
            _loader.contentLoaderInfo.removeEventListener(Event.INIT,onMoviePlayerLoaded);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onMoviePlayerLoaded);
         }
      }
      
      private function onLevelXmlLoaded(param1:Event) : void
      {
         _mcMoviePlayer.removeEventListener("ON_LEVEL_XML_LOADED",onLevelXmlLoaded);
         _bLevelXmlLoaded = true;
         if(_xTurn != null)
         {
            DebugLog.instance.log("CAnimation::onLevelXmlLoaded -- attempting to start turn");
            startTurn(_xTurn);
            _xTurn = null;
         }
      }
      
      public function initiateNewBattle(param1:Number) : void
      {
         _nPlayers = param1;
         if(_mcMoviePlayer == null)
         {
            loadMoviePlayer();
         }
      }
      
      public function clearBattle() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < _nPlayers)
         {
            clearVirmon(_loc1_);
            _loc1_++;
         }
         if(Boolean(_mcMoviePlayer))
         {
            Utils.clearAllChildren(_mcMoviePlayer);
            _mcMoviePlayer.clearBattle();
            _mcMoviePlayer = null;
         }
         _loader = null;
         delete global[this];
      }
      
      public function loadMoviePlayer() : void
      {
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(Event.INIT,onMoviePlayerLoaded,false,0,true);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onMoviePlayerLoaded,false,0,true);
         var _loc1_:URLRequest = new URLRequest("MoviePlayer.swf");
         _loader.load(_loc1_);
      }
      
      public function get moviePlayer() : MainClip
      {
         return _mcMoviePlayer;
      }
      
      private function onMoviePlayerLoaded(param1:Event) : *
      {
         DebugLog.instance.log("CAnimation: onMoviePlayerLoaded");
         if(_loader == null || _loader.contentLoaderInfo == null)
         {
            DebugLog.instance.error("** CAnimation: onMoviePlayerLoaded called when ( * ) is null!!!");
            return;
         }
         _loader.contentLoaderInfo.removeEventListener(Event.INIT,onMoviePlayerLoaded);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onMoviePlayerLoaded);
         if(param1 is IOErrorEvent)
         {
            DebugLog.instance.error("CAnimation: " + param1.toString());
            return;
         }
         _mcMoviePlayer = param1.currentTarget.content;
         _loader.unload();
         _loader = null;
         _mcMoviePlayer.addEventListener("ON_LEVEL_XML_LOADED",onLevelXmlLoaded,false,0,true);
         _mcMoviePlayer.initiateNewBattle(_nPlayers,_characterAssetTypeCache,_overlayAssetRetriever);
         _mcBattleGround.addChild(_mcMoviePlayer);
         this.dispatchEvent(new Event(ON_LOAD));
         this.dispatchEvent(new BattleEngineEvent(BattleEngineEvent.INITIALIZE,{"ed":_mcMoviePlayer._smcFightEngine._oEventDispatcher}));
      }
      
      public function defineBattleGround(param1:DisplayObjectContainer) : void
      {
         _mcBattleGround = param1;
      }
      
      public function getHackAndOverrideChanges() : String
      {
         return _sPacketHackAndOverrideChanges;
      }
      
      public function startTurn(param1:XML) : void
      {
         if(!_bLevelXmlLoaded)
         {
            _xTurn = param1;
            return;
         }
         setSound(true);
         if(!moviePlayer._smcFightEngine.choosingNanovor)
         {
            _mcMoviePlayer._smcFightEngine._oEventDispatcher.addEventListener("END_TURN_ACTION",endTurn,false,0,true);
            _mcMoviePlayer._smcFightEngine._oEventDispatcher.addEventListener("EVENT_TRIGGER",linkEvent,false,0,true);
         }
         _mcMoviePlayer.startTurn(param1);
      }
   }
}

