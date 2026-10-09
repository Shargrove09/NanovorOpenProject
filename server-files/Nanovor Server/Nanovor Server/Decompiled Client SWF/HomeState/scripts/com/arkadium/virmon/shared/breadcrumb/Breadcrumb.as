package com.arkadium.virmon.shared.breadcrumb
{
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.events.GlobalLogEvent;
   import com.arkadium.virmon.shared.events.JumpToBattleEvent;
   import com.arkadium.virmon.shared.events.LoadQuicktipsEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Breadcrumb extends MovieClip
   {
      
      private var _clickableTips:Array = [{
         "mc":"swarmSelectTip",
         "tip":Const.QUICKTIP_GENERATE_SWARM
      },{
         "mc":"battleTip",
         "tip":Const.QUICKTIP_ATTACK_SWAP
      },{
         "mc":"evoGameTip",
         "tip":Const.QUICKTIP_EVOLUTION_GAME
      },{
         "mc":"storeTip",
         "tip":Const.QUICKTIP_NANOMALL
      },{
         "mc":"tradeTip",
         "tip":Const.QUICKTIP_TRADE
      },{
         "mc":"dashboardTip",
         "tip":Const.QUICKTIP_DASHBOARD
      },{
         "mc":"profileTip",
         "tip":Const.QUICKTIP_PROFILE
      },{
         "mc":"collectionTip",
         "tip":Const.QUICKTIP_COLLECTION
      }];
      
      public var mcContent:MovieClip;
      
      public function Breadcrumb()
      {
         super();
         trace("Breadcrumb instantiated");
         setListeners();
      }
      
      private function handleClick(param1:MouseEvent) : void
      {
         log("handling click from: " + param1.currentTarget);
         var _loc2_:int = 0;
         while(_loc2_ < _clickableTips.length)
         {
            if(mcContent.getChildByName(_clickableTips[_loc2_].mc) == param1.currentTarget)
            {
               log(_clickableTips[_loc2_].mc + " hit -- loading quicktip: " + _clickableTips[_loc2_].tip);
               EventManager.getInstance().dispatchEvent(new LoadQuicktipsEvent(LoadQuicktipsEvent.LOAD_QUICKTIPS,Const.QUICKTIP_PATH + _clickableTips[_loc2_].tip));
            }
            _loc2_++;
         }
      }
      
      public function sizzleFinished() : void
      {
         log("sizzleFinished");
         EventManager.getInstance().dispatchEvent(new Event(Const.SIZZLE_FINISHED));
      }
      
      protected function log(param1:String) : void
      {
         EventManager.getInstance().dispatchEvent(new GlobalLogEvent(GlobalLogEvent.LOG,">> Breadcrumb: " + param1));
      }
      
      private function checkFrame(param1:Event) : void
      {
         var _loc2_:Number = mcContent == null ? this.currentFrame : mcContent.currentFrame;
         var _loc3_:Number = mcContent == null ? this.totalFrames : mcContent.totalFrames;
         if(_loc2_ == _loc3_)
         {
            removeEventListener(Event.ENTER_FRAME,checkFrame);
            stop();
            sizzleFinished();
         }
      }
      
      private function skipBreadcrumb(param1:MouseEvent) : void
      {
         log("skipping breadcrumb");
         removeListeners();
         EventManager.getInstance().dispatchEvent(new Event(Const.SIZZLE_SKIPPED));
      }
      
      private function onPlaySoloBattleUltraSuperEasyClick(param1:MouseEvent) : void
      {
         EventManager.getInstance().dispatchEvent(new JumpToBattleEvent(JumpToBattleEvent.SOLO_BATTLE,-1));
      }
      
      private function onPlayAutoBattleClick(param1:MouseEvent) : void
      {
         EventManager.getInstance().dispatchEvent(new JumpToBattleEvent(JumpToBattleEvent.AUTO_BATTLE,0));
      }
      
      private function onPlaySoloBattleSuperEasyClick(param1:MouseEvent) : void
      {
         EventManager.getInstance().dispatchEvent(new JumpToBattleEvent(JumpToBattleEvent.SOLO_BATTLE,-2));
      }
      
      public function removeListeners() : void
      {
         log("removeListeners()");
         removeEventListener(Event.ENTER_FRAME,checkFrame);
         if(mcContent == null)
         {
            return;
         }
         if(mcContent.skipClip != null)
         {
            mcContent.skipClip.removeEventListener(MouseEvent.CLICK,skipBreadcrumb);
         }
         if(mcContent.btnPlaySoloBattleUltraSuperEasy != null)
         {
            mcContent.btnPlaySoloBattleUltraSuperEasy.removeEventListener(MouseEvent.CLICK,onPlaySoloBattleUltraSuperEasyClick);
         }
         if(mcContent.btnPlaySoloBattleSuperEasy != null)
         {
            mcContent.btnPlaySoloBattleSuperEasy.removeEventListener(MouseEvent.CLICK,onPlaySoloBattleSuperEasyClick);
         }
         if(mcContent.btnPlayAutoBattle != null)
         {
            mcContent.btnPlayAutoBattle.removeEventListener(MouseEvent.CLICK,onPlayAutoBattleClick);
         }
         var _loc1_:int = 0;
         while(_loc1_ < _clickableTips.length)
         {
            if(mcContent.getChildByName(_clickableTips[_loc1_].mc) != null)
            {
               log("found " + _clickableTips[_loc1_].mc + " -- removing listener");
               mcContent.getChildByName(_clickableTips[_loc1_].mc).removeEventListener(MouseEvent.CLICK,handleClick);
            }
            _loc1_++;
         }
      }
      
      public function setListeners() : void
      {
         log("setListeners()");
         addEventListener(Event.ENTER_FRAME,checkFrame,false,0,true);
         if(mcContent == null)
         {
            return;
         }
         if(mcContent.skipClip != null)
         {
            mcContent.skipClip.addEventListener(MouseEvent.CLICK,skipBreadcrumb,false,0,true);
         }
         if(mcContent.btnPlaySoloBattleUltraSuperEasy != null)
         {
            mcContent.btnPlaySoloBattleUltraSuperEasy.addEventListener(MouseEvent.CLICK,onPlaySoloBattleUltraSuperEasyClick,false,0,true);
         }
         if(mcContent.btnPlaySoloBattleSuperEasy != null)
         {
            mcContent.btnPlaySoloBattleSuperEasy.addEventListener(MouseEvent.CLICK,onPlaySoloBattleSuperEasyClick,false,0,true);
         }
         if(mcContent.btnPlayAutoBattle != null)
         {
            mcContent.btnPlayAutoBattle.addEventListener(MouseEvent.CLICK,onPlayAutoBattleClick,false,0,true);
         }
         var _loc1_:int = 0;
         while(_loc1_ < _clickableTips.length)
         {
            if(mcContent.getChildByName(_clickableTips[_loc1_].mc) != null)
            {
               log("found " + _clickableTips[_loc1_].mc + " -- adding listener");
               mcContent.getChildByName(_clickableTips[_loc1_].mc).addEventListener(MouseEvent.CLICK,handleClick,false,0,true);
            }
            _loc1_++;
         }
      }
   }
}

