package com.arkadium.virmon.evogame
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.EMMasterData;
   import com.arkadium.virmon.shared.final.elements.GenericEM;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol726")]
   public class EMClamp extends MovieClip
   {
      
      public var burns:MovieClip;
      
      public var bigLock1:MovieClip;
      
      private var _em:GenericEM;
      
      private const DOTS:String = "......";
      
      public var glow:MovieClip;
      
      public var bigLock2:MovieClip;
      
      public var rolledOver:Boolean;
      
      public var lightning:MovieClip;
      
      public var base:MovieClip;
      
      public var spark:MovieClip;
      
      public var smallLock1:MovieClip;
      
      public var smallLock2:MovieClip;
      
      public var isOpen:Boolean;
      
      private var _circuit:Circuit;
      
      public var smoke:MovieClip;
      
      public var emHolder:MovieClip;
      
      public var blast:MovieClip;
      
      public function EMClamp(param1:Circuit)
      {
         super();
         addFrameScript(0,frame1);
         _circuit = param1;
         base.visible = false;
         smoke.visible = false;
         burns.visible = false;
         blast.visible = false;
         glow.visible = false;
         lightning.visible = false;
         spark.visible = false;
         smoke.stop();
         base.stop();
         smallLock1.stop();
         smallLock2.stop();
         bigLock1.stop();
         bigLock2.stop();
         smallLock1.mouseEnabled = false;
         smallLock2.mouseEnabled = false;
         glow.mouseEnabled = false;
         glow.mouseChildren = false;
         isOpen = false;
      }
      
      public function getEM() : GenericEM
      {
         return _em;
      }
      
      public function lockEM(param1:Boolean = false) : *
      {
         isOpen = !param1;
         if(param1)
         {
            smallLock1.gotoAndPlay("close");
            smallLock2.gotoAndPlay("close");
            bigLock1.gotoAndPlay("close");
            bigLock2.gotoAndPlay("close");
         }
         else
         {
            smallLock1.gotoAndStop("open");
            smallLock2.gotoAndStop("open");
            bigLock1.gotoAndPlay("begin");
            bigLock2.gotoAndPlay("begin");
         }
         _circuit.updateLights();
      }
      
      public function openClamp() : void
      {
         base.visible = true;
         setText(DOTS);
         base.gotoAndPlay("open");
         lockEM(false);
      }
      
      public function setEM(param1:GenericEM) : void
      {
         var _loc3_:ColorTransform = null;
         var _loc4_:ColorTransform = null;
         while(emHolder.numChildren > 0)
         {
            emHolder.removeChildAt(0);
         }
         _em = new GenericEM(param1.getID());
         _em.assetId = param1.assetId;
         emHolder.addChild(_em);
         _em.stopCrystal();
         var _loc2_:EMMasterData = DataManager.getInstance().getEMManager().getEMMasterData(param1.getID());
         switch(int(_loc2_.getShortName().charAt(2)))
         {
            case 1:
               _loc4_ = new ColorTransform(1,0,1,1,51,-140,255,0);
               _loc3_ = new ColorTransform(1,1,1,1,55,-98,111,0);
               break;
            case 2:
               _loc4_ = new ColorTransform(1,1,1,1,-120,-56,255,0);
               _loc3_ = new ColorTransform(1,1,1,1,-98,37,255,0);
               break;
            case 3:
               _loc4_ = new ColorTransform(1,1,1,1,-255,70,-255,0);
               _loc3_ = new ColorTransform(1,1,1,1,-56,27,-102,0);
               break;
            case 4:
               _loc4_ = new ColorTransform(1,1,1,1,100,-20,-255,0);
               _loc3_ = new ColorTransform(1,1,1,1,166,0,-112,0);
               break;
            case 5:
               _loc4_ = new ColorTransform(1,1,1,1,255,-120,-255,0);
               _loc3_ = new ColorTransform(1,0.58,0.49,1,148,64,-38,0);
               break;
            case 6:
               _loc4_ = new ColorTransform(1,1,1,1,255,-255,-255,0);
               _loc3_ = new ColorTransform(1,1,0.72,1,255,-84,-65,0);
               break;
            case 7:
            default:
               _loc4_ = new ColorTransform(0.6,0.92,0,1,64,-191,-255,0);
               _loc3_ = new ColorTransform(1,1,0.92,1,255,69,0,0);
         }
         glow.transform.colorTransform = _loc4_;
         smoke.transform.colorTransform = _loc3_;
         setText(_loc2_.getShortName());
         lockEM(true);
         glow.alpha = 0.25;
         glow.visible = true;
         _em.addEventListener(MouseEvent.MOUSE_DOWN,onEmPress,false,0,true);
      }
      
      private function onEmPress(param1:MouseEvent) : void
      {
         _em.removeEventListener(MouseEvent.MOUSE_DOWN,onEmPress);
         _em.visible = false;
         glow.visible = false;
         _circuit.onEMPress(_em);
         setText(DOTS);
         emHolder.removeChild(_em);
         rolledOver = false;
         _em = null;
         lockEM(false);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      public function rollOut() : void
      {
         bigLock1.gotoAndPlay("rollout");
         bigLock2.gotoAndPlay("rollout");
         rolledOver = false;
      }
      
      public function rollOver() : void
      {
         bigLock1.gotoAndPlay("rollover");
         bigLock2.gotoAndPlay("rollover");
         rolledOver = true;
      }
      
      private function setText(param1:String) : void
      {
         base._mcHead._mcHeadTxt._tfName.text = param1;
      }
      
      public function burnClamp(param1:Boolean) : void
      {
         _em.removeEventListener(MouseEvent.MOUSE_DOWN,onEmPress);
         smoke.visible = true;
         smoke.gotoAndPlay(1);
         lightning.visible = true;
         lightning.gotoAndPlay(1);
         spark.visible = true;
         spark.gotoAndPlay(1);
         if(param1)
         {
            Tweener.addTween(glow,{
               "time":0.5,
               "_autoAlpha":0.5
            });
            Tweener.addTween(glow,{
               "delay":0.5,
               "time":0.5,
               "_autoAlpha":0
            });
         }
         else
         {
            burns.visible = true;
            blast.visible = true;
            glow.visible = false;
            Tweener.addTween(_em.stone,{
               "_tintBrightness":-0.4,
               "time":1,
               "transition":"easeOutQuad"
            });
         }
      }
   }
}

