package com.arkadium.virmon.movieplayer
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.final.elements.IdentifyingNanovorElement;
   import flash.display.*;
   
   public dynamic class VirmonContainer extends AnimationContainer
   {
      
      public var _nOverlayNumber:Number;
      
      private var _identifyingGraphicEnabled:Boolean = false;
      
      private var _identifyingGraphic:IdentifyingNanovorElement;
      
      public var _mcIdleAnimation:MovieClip;
      
      public var _aOverlayNamesPerFrame:Array;
      
      public var _nPlayerOrder:Number;
      
      public function VirmonContainer()
      {
         super();
      }
      
      override public function doAction(param1:MovieClip) : *
      {
         disableIdentifyingGraphic();
         super.doAction(param1);
      }
      
      override public function set scaleX(param1:Number) : void
      {
         if(_identifyingGraphic != null)
         {
            setIdentifyingGraphicProps(param1);
         }
         super.scaleX = param1;
      }
      
      private function onIdentifyingGraphicAlphaZero() : void
      {
         if(_identifyingGraphic == null)
         {
            return;
         }
         _identifyingGraphic.stop();
         removeChild(_identifyingGraphic);
      }
      
      private function disableIdentifyingGraphic() : void
      {
         if(!_identifyingGraphicEnabled)
         {
            return;
         }
         _identifyingGraphicEnabled = false;
         if(_identifyingGraphic == null)
         {
            return;
         }
         Tweener.removeTweens(_identifyingGraphic);
         Tweener.addTween(_identifyingGraphic,{
            "_autoAlpha":0,
            "time":0.4,
            "transition":"easeOutQuad",
            "onComplete":onIdentifyingGraphicAlphaZero
         });
      }
      
      private function doActionForIdle(param1:MovieClip) : *
      {
         if(Boolean(param1.isPrototypeCharacter))
         {
            enableIdentifyingGraphic();
         }
         else
         {
            disableIdentifyingGraphic();
         }
         super.doAction(param1);
      }
      
      public function playIdleAnimation(param1:AnimationContainer) : *
      {
         setEndFunction(playIdleAnimation);
         doActionForIdle(_mcIdleAnimation);
      }
      
      public function setNewIdleAnimation(param1:MovieClip) : *
      {
         _mcIdleAnimation = null;
         _mcIdleAnimation = param1;
      }
      
      private function enableIdentifyingGraphic() : void
      {
         if(_identifyingGraphicEnabled)
         {
            return;
         }
         _identifyingGraphicEnabled = true;
         if(_identifyingGraphic == null)
         {
            _identifyingGraphic = new IdentifyingNanovorElement(true);
            setIdentifyingGraphicProps(scaleX);
            _identifyingGraphic.alpha = 0;
         }
         _identifyingGraphic.play();
         addChild(_identifyingGraphic);
         Tweener.removeTweens(_identifyingGraphic);
         Tweener.addTween(_identifyingGraphic,{
            "_autoAlpha":1,
            "time":0.8,
            "transition":"easeInOutQuad"
         });
      }
      
      public function getOverlayList() : *
      {
         return _aOverlayNamesPerFrame[_mcActiveAnimation.currentFrame];
      }
      
      private function setIdentifyingGraphicProps(param1:Number) : void
      {
         _identifyingGraphic.scaleX = param1 >= 0 ? 1 : -1;
         _identifyingGraphic.y = -20;
         if(_identifyingGraphic.scaleX >= 0)
         {
            _identifyingGraphic.x = -92;
         }
         else
         {
            _identifyingGraphic.x = 92;
         }
      }
   }
}

