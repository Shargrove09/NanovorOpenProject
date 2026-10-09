package com.arkadium.virmon.shared.widgets.megawidget
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class AutoBattlePicker
   {
      
      private var _tf2Player:TextField;
      
      private var _tf3Player:TextField;
      
      private var _tf4Player:TextField;
      
      private var _mask:MovieClip;
      
      private var _autoBattlePicker:MovieClip;
      
      private var _topBar:MovieClip;
      
      private var _mc2Player:MovieClip;
      
      private var _mc3Player:MovieClip;
      
      private var _mc4Player:MovieClip;
      
      private var _bottomBar:MovieClip;
      
      private var _open:Boolean;
      
      public function AutoBattlePicker(param1:MovieClip)
      {
         var _loc3_:MovieClip = null;
         super();
         _autoBattlePicker = param1;
         _topBar = _autoBattlePicker.mcTopBar;
         _bottomBar = _autoBattlePicker.mcBottomBar;
         _mc2Player = _autoBattlePicker.mc2Player;
         _mc3Player = _autoBattlePicker.mc3Player;
         _mc4Player = _autoBattlePicker.mc4Player;
         _mask = _autoBattlePicker.mcAutoBattlePickerMask;
         var _loc2_:Array = [_mc2Player,_mc3Player,_mc4Player];
         for each(_loc3_ in _loc2_)
         {
            _loc3_.hitArea = _loc3_.mcHitArea;
            _loc3_.mcHitArea.visible = false;
            stopSpinner(_loc3_);
            _loc3_.buttonMode = true;
         }
         _tf2Player = _autoBattlePicker.tf2Player;
         _tf3Player = _autoBattlePicker.tf3Player;
         _tf4Player = _autoBattlePicker.tf4Player;
         _autoBattlePicker.mouseEnabled = false;
         _topBar.mouseEnabled = false;
         _bottomBar.mouseEnabled = false;
         _topBar.width = 0;
         _bottomBar.width = 0;
         _mask.width = 0;
      }
      
      public function get buttons() : Array
      {
         return [_mc2Player,_mc3Player,_mc4Player];
      }
      
      public function open() : void
      {
         var _loc2_:MovieClip = null;
         if(_open)
         {
            return;
         }
         _open = true;
         var _loc1_:Array = [_mc2Player,_mc3Player,_mc4Player];
         for each(_loc2_ in _loc1_)
         {
            _loc2_.mouseEnabled = true;
         }
         Tweener.removeTweens(_topBar);
         Tweener.removeTweens(_bottomBar);
         Tweener.removeTweens(_mask);
         Tweener.addTween(_topBar,{
            "width":274,
            "time":0.5,
            "transition":"easeInOutQuad",
            "delay":2
         });
         Tweener.addTween(_bottomBar,{
            "width":274,
            "time":0.5,
            "transition":"easeInOutQuad",
            "delay":2
         });
         Tweener.addTween(_mask,{
            "width":280,
            "time":0.5,
            "transition":"easeInOutQuad",
            "delay":2.5
         });
      }
      
      private function startSpinner(param1:MovieClip) : void
      {
         param1.mcClampSpinner.play();
         Tweener.addTween(param1.mcClampSpinner,{
            "alpha":1,
            "time":0.5,
            "transition":"easeInOutQuad"
         });
      }
      
      public function isOpen() : Boolean
      {
         return _open;
      }
      
      public function setActiveSlot(param1:int) : void
      {
         stopSpinner(_mc2Player);
         stopSpinner(_mc3Player);
         stopSpinner(_mc4Player);
         _tf2Player.textColor = 5295069;
         _tf3Player.textColor = 5295069;
         _tf4Player.textColor = 5295069;
         switch(param1)
         {
            case 2:
               _tf2Player.textColor = 16777215;
               startSpinner(_mc2Player);
               break;
            case 3:
               _tf3Player.textColor = 16777215;
               startSpinner(_mc3Player);
               break;
            case 4:
               _tf4Player.textColor = 16777215;
               startSpinner(_mc4Player);
         }
      }
      
      private function stopSpinner(param1:MovieClip) : void
      {
         Tweener.addTween(param1.mcClampSpinner,{
            "alpha":0,
            "time":1,
            "transition":"easeInOutQuad",
            "onComplete":param1.mcClampSpinner.stop
         });
      }
      
      public function close() : void
      {
         var _loc2_:MovieClip = null;
         if(!_open)
         {
            return;
         }
         _open = false;
         Tweener.removeTweens(_topBar);
         Tweener.removeTweens(_bottomBar);
         Tweener.removeTweens(_mask);
         Tweener.addTween(_topBar,{
            "width":0,
            "time":0.5,
            "transition":"easeInOutQuad"
         });
         Tweener.addTween(_bottomBar,{
            "width":0,
            "time":0.5,
            "transition":"easeInOutQuad"
         });
         Tweener.addTween(_mask,{
            "width":0,
            "time":0.5,
            "transition":"easeInOutQuad"
         });
         var _loc1_:Array = [_mc2Player,_mc3Player,_mc4Player];
         for each(_loc2_ in _loc1_)
         {
            _loc2_.mouseEnabled = false;
         }
      }
   }
}

