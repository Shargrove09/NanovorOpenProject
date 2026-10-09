package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class FriendsMenuTab extends TabTemplate
   {
      
      public static const PADDING:Number = 12;
      
      private var _isActive:Boolean = false;
      
      public function FriendsMenuTab(param1:String, param2:Number = 0)
      {
         super();
         this.mouseChildren = false;
         tfText.mouseEnabled = false;
         mcOutline.mouseEnabled = false;
         this.hitArea = mcFill;
         mcFill.alpha = 0;
         this.buttonMode = true;
         this.useHandCursor = true;
         tfText.mouseEnabled = false;
         tfText.autoSize = TextFieldAutoSize.LEFT;
         tfText.wordWrap = false;
         tfText.x = PADDING + param2;
         tfText.text = param1;
         mcFill.width = mcOutline.width = tfText.width + PADDING * 2 + param2;
         addEventListener(MouseEvent.ROLL_OVER,this.onTabRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onTabRollOut);
         this.active = false;
      }
      
      private function deactivate() : void
      {
         Tweener.addTween(mcFill,{
            "_autoAlpha":0,
            "time":1
         });
         tfText.textColor = 9737364;
      }
      
      private function onTabRollOver(param1:MouseEvent) : void
      {
         if(!this._isActive)
         {
            this.activate();
         }
      }
      
      override public function toString() : String
      {
         var _loc1_:String = "[FriendsMenuTab]";
         _loc1_ += "tfText.text: " + tfText.text;
         return _loc1_ + (", active: " + this._isActive);
      }
      
      private function activate() : void
      {
         Tweener.addTween(mcFill,{
            "_autoAlpha":1,
            "time":1
         });
         tfText.textColor = 16777215;
      }
      
      private function onTabRollOut(param1:MouseEvent) : void
      {
         if(!this._isActive)
         {
            this.deactivate();
         }
      }
      
      public function set active(param1:Boolean) : void
      {
         if(param1 == this._isActive)
         {
            return;
         }
         if(this._isActive && !param1)
         {
            this.deactivate();
         }
         if(!this._isActive && param1)
         {
            this.activate();
         }
         this._isActive = param1;
         this.mouseEnabled = !param1;
         this.mouseChildren = !param1;
      }
   }
}

