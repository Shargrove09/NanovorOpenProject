package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import caurina.transitions.Tweener;
   import com.smithandtinker.nanovor.common.event.CustomEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol12")]
   public class SmallTab extends Sprite
   {
      
      public static var SMALL_TAB_CLICK:* = "smallTabClick";
      
      private var _szPositionState:String = "down";
      
      private var _szLabel:String;
      
      public var stfLabel:TextField;
      
      public var mcBG:MovieClip;
      
      public var mcHit:MovieClip;
      
      private var _bEnabled:Boolean = false;
      
      private var _bSelected:Boolean = false;
      
      public var mcShading:MovieClip;
      
      private var _mcBarHighlight:MovieClip;
      
      public function SmallTab(param1:String, param2:Boolean = true, param3:* = false)
      {
         super();
         _mcBarHighlight = MovieClip(mcBG.mcBarHighlight);
         szLabel = param1;
         bEnabled = param2;
         bSelected = param3;
         _mcBarHighlight.alpha = 0;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(!_bSelected)
         {
            moveUp();
         }
      }
      
      private function moveUp() : void
      {
         _szPositionState = "up";
         Tweener.addTween(mcBG,{
            "y":-1,
            "time":0.1,
            "transition":"linear"
         });
         Tweener.addTween(mcShading,{
            "y":18,
            "time":0.1,
            "transition":"linear"
         });
         Tweener.addTween(stfLabel,{
            "y":-1,
            "time":0.1,
            "transition":"linear"
         });
      }
      
      public function get szLabel() : String
      {
         return _szLabel;
      }
      
      private function moveDown() : void
      {
         _szPositionState = "down";
         Tweener.addTween(mcBG,{
            "y":2,
            "time":0.1,
            "transition":"linear"
         });
         Tweener.addTween(mcShading,{
            "y":16,
            "time":0.1,
            "transition":"linear"
         });
         Tweener.addTween(stfLabel,{
            "y":2,
            "time":0.1,
            "transition":"linear"
         });
      }
      
      private function toggleEnabled(param1:Boolean) : void
      {
         if(param1 == _bEnabled)
         {
            return;
         }
         if(param1)
         {
            mcHit.addEventListener(MouseEvent.ROLL_OVER,onMouseOver,false,0,true);
            mcHit.addEventListener(MouseEvent.ROLL_OUT,onMouseOut,false,0,true);
            mcHit.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
            mcHit.buttonMode = true;
            mcHit.useHandCursor = true;
         }
         else
         {
            mcHit.removeEventListener(MouseEvent.ROLL_OVER,onMouseOver);
            mcHit.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
            mcHit.removeEventListener(MouseEvent.CLICK,onClick);
            mcHit.buttonMode = false;
            mcHit.useHandCursor = false;
         }
         _bEnabled = param1;
      }
      
      private function toggleSelected(param1:Boolean) : void
      {
         if(param1 == _bSelected)
         {
            return;
         }
         if(param1)
         {
            if(_szPositionState == "down")
            {
               moveUp();
            }
            toggleEnabled(false);
            Tweener.addTween(_mcBarHighlight,{
               "alpha":1,
               "time":0.2,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(stfLabel,{
               "_Glow_alpha":1,
               "time":0.2,
               "transition":"easeOutQuad"
            });
         }
         else
         {
            if(_szPositionState == "up")
            {
               moveDown();
            }
            toggleEnabled(true);
            Tweener.addTween(_mcBarHighlight,{
               "alpha":0,
               "time":0.2,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(stfLabel,{
               "_Glow_alpha":0,
               "time":0.2,
               "transition":"easeOutQuad"
            });
         }
         _bSelected = param1;
      }
      
      public function set szLabel(param1:String) : *
      {
         _szLabel = param1;
         stfLabel.text = _szLabel.toUpperCase();
      }
      
      public function get bSelected() : Boolean
      {
         return _bSelected;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         bSelected = true;
         dispatchEvent(new CustomEvent(SMALL_TAB_CLICK,{"szLabel":_szLabel}));
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(!_bSelected)
         {
            moveDown();
         }
      }
      
      public function clearListeners() : void
      {
         mcHit.removeEventListener(MouseEvent.ROLL_OVER,onMouseOver);
         mcHit.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
         mcHit.removeEventListener(MouseEvent.CLICK,onClick);
      }
      
      public function set bSelected(param1:Boolean) : *
      {
         toggleSelected(param1);
      }
      
      public function set bEnabled(param1:Boolean) : *
      {
         toggleEnabled(param1);
      }
      
      public function get bEnabled() : Boolean
      {
         return _bEnabled;
      }
   }
}

