package com.arkadium.virmon.device.ui
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DeviceActionPicker extends Sprite
   {
      
      private static const DEBUG_HIDE_GAMES_AND_BADGES:Boolean = true;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      public var mcForeground:Sprite;
      
      private var _buttons:Array;
      
      private var _currentButton:MovieClip;
      
      public var mcGamesSpinner:MovieClip;
      
      public var mcBadgesSpinner:MovieClip;
      
      private var _gamesButtonHandler:Function;
      
      public var mcButtonsMask:Sprite;
      
      public var mcBackground:Sprite;
      
      private var _badgesButtonHandler:Function;
      
      public var mcNanovorSpinner:MovieClip;
      
      private var _nanovorButtonHandler:Function;
      
      public function DeviceActionPicker()
      {
         super();
         mcForeground.visible = false;
         mcBackground.visible = false;
      }
      
      private function activateButton(param1:MovieClip) : void
      {
         param1.mcClampSpinner.play();
         Tweener.addTween(param1.mcClampSpinner,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         param1.mcClampSpinner.play();
      }
      
      private function deactivateButton(param1:MovieClip) : void
      {
         Tweener.addTween(param1.mcClampSpinner,{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":param1.mcClampSpinner.stop
         });
         param1.mcClampSpinner.stop();
      }
      
      private function onBadgesButtonClick(param1:MouseEvent) : void
      {
         if(null != _badgesButtonHandler)
         {
            _badgesButtonHandler.call(this);
         }
      }
      
      public function destroy() : void
      {
         if(mcNanovorSpinner != null)
         {
            mcNanovorSpinner.stop();
         }
         if(mcBadgesSpinner != null)
         {
            mcBadgesSpinner.stop();
         }
         if(mcGamesSpinner != null)
         {
            mcGamesSpinner.stop();
         }
         _badgesButtonHandler = null;
         _gamesButtonHandler = null;
         _nanovorButtonHandler = null;
      }
      
      public function open() : void
      {
         Tweener.addTween(mcBackground,{
            "width":274,
            "time":0.8,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(mcForeground,{
            "width":274,
            "time":0.8,
            "delay":0.2,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(mcButtonsMask,{
            "width":274,
            "time":0.8,
            "delay":0.4,
            "transition":Equations.easeInOutQuad
         });
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceActionPicker>>\t" + param1);
      }
      
      private function onNanovorButtonClick(param1:MouseEvent) : void
      {
         if(null != _nanovorButtonHandler)
         {
            _nanovorButtonHandler.call(this);
         }
      }
      
      public function selectNanovors() : void
      {
         if(null != _currentButton)
         {
            deactivateButton(_currentButton);
            _currentButton.addEventListener(MouseEvent.MOUSE_OVER,onButtonMouseOver,false,0,true);
            _currentButton.addEventListener(MouseEvent.MOUSE_OUT,onButtonMouseOut,false,0,true);
         }
         _currentButton = mcNanovorSpinner;
         activateButton(_currentButton);
         _currentButton.removeEventListener(MouseEvent.MOUSE_OVER,onButtonMouseOver);
         _currentButton.removeEventListener(MouseEvent.MOUSE_OUT,onButtonMouseOut);
      }
      
      public function setNanovorButtonHandler(param1:Function) : void
      {
         _nanovorButtonHandler = param1;
      }
      
      public function selectBadges() : void
      {
         if(null != _currentButton)
         {
            deactivateButton(_currentButton);
            _currentButton.addEventListener(MouseEvent.MOUSE_OVER,onButtonMouseOver,false,0,true);
            _currentButton.addEventListener(MouseEvent.MOUSE_OUT,onButtonMouseOut,false,0,true);
         }
         _currentButton = mcBadgesSpinner;
         activateButton(_currentButton);
         _currentButton.removeEventListener(MouseEvent.MOUSE_OVER,onButtonMouseOver);
         _currentButton.removeEventListener(MouseEvent.MOUSE_OUT,onButtonMouseOut);
      }
      
      public function init() : void
      {
         var _loc1_:MovieClip = null;
         mcForeground.width = 0;
         mcBackground.width = 0;
         mcButtonsMask.width = 0;
         if(!DEBUG_HIDE_GAMES_AND_BADGES)
         {
            _buttons = [mcNanovorSpinner,mcGamesSpinner,mcBadgesSpinner];
         }
         else
         {
            _buttons = [mcNanovorSpinner];
         }
         for each(_loc1_ in _buttons)
         {
            _loc1_.hitArea = _loc1_.mcHitArea;
            _loc1_.mcHitArea.alpha = 0;
            _loc1_.mcHitArea.buttonMode = true;
            _loc1_.mcClampSpinner.visible = false;
            _loc1_.mcClampSpinner.stop();
         }
         mcNanovorSpinner.addEventListener(MouseEvent.CLICK,onNanovorButtonClick,false,0,true);
         mcNanovorSpinner.addEventListener(MouseEvent.MOUSE_OVER,onButtonMouseOver,false,0,true);
         mcNanovorSpinner.addEventListener(MouseEvent.MOUSE_OUT,onButtonMouseOut,false,0,true);
         if(!DEBUG_HIDE_GAMES_AND_BADGES)
         {
            mcGamesSpinner.addEventListener(MouseEvent.CLICK,onGamesButtonClick,false,0,true);
            mcGamesSpinner.addEventListener(MouseEvent.MOUSE_OVER,onButtonMouseOver,false,0,true);
            mcGamesSpinner.addEventListener(MouseEvent.MOUSE_OUT,onButtonMouseOut,false,0,true);
            mcBadgesSpinner.addEventListener(MouseEvent.CLICK,onBadgesButtonClick,false,0,true);
            mcBadgesSpinner.addEventListener(MouseEvent.MOUSE_OVER,onButtonMouseOver,false,0,true);
            mcBadgesSpinner.addEventListener(MouseEvent.MOUSE_OUT,onButtonMouseOut,false,0,true);
         }
      }
      
      public function selectGames() : void
      {
         if(null != _currentButton)
         {
            deactivateButton(_currentButton);
            _currentButton.addEventListener(MouseEvent.MOUSE_OVER,onButtonMouseOver,false,0,true);
            _currentButton.addEventListener(MouseEvent.MOUSE_OUT,onButtonMouseOut,false,0,true);
         }
         _currentButton = mcGamesSpinner;
         activateButton(_currentButton);
         _currentButton.removeEventListener(MouseEvent.MOUSE_OVER,onButtonMouseOver);
         _currentButton.removeEventListener(MouseEvent.MOUSE_OUT,onButtonMouseOut);
      }
      
      private function onButtonMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         activateButton(_loc2_);
      }
      
      public function setBadgesButtonHandler(param1:Function) : void
      {
         _badgesButtonHandler = param1;
      }
      
      private function onGamesButtonClick(param1:MouseEvent) : void
      {
         if(null != _gamesButtonHandler)
         {
            _gamesButtonHandler.call(this);
         }
      }
      
      public function close() : void
      {
         Tweener.addTween(mcButtonsMask,{
            "width":0,
            "time":0.8,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(mcForeground,{
            "width":0,
            "time":0.8,
            "delay":0.2,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(mcBackground,{
            "width":0,
            "time":0.8,
            "delay":0.4,
            "transition":Equations.easeInOutQuad
         });
      }
      
      public function setGamesButtonHandler(param1:Function) : void
      {
         _gamesButtonHandler = param1;
      }
      
      private function onButtonMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         deactivateButton(_loc2_);
      }
   }
}

