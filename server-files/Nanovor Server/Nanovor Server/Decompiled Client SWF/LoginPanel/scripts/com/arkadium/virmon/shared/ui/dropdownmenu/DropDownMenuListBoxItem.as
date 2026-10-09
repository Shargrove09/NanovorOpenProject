package com.arkadium.virmon.shared.ui.dropdownmenu
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol23")]
   public class DropDownMenuListBoxItem extends MovieClip
   {
      
      public static const NAME_COLOR_ACTIVE:uint = 11141119;
      
      public static const NAME_COLOR_INACTIVE:uint = 6710886;
      
      public static const STATUS_COLOR_OPEN:uint = 13369088;
      
      public static const STATUS_COLOR_FULL:uint = 13390336;
      
      public var tfStatus:TextField;
      
      private var _handler:IDropDownMenuHandler;
      
      public var tfName:TextField;
      
      private var _isActive:Boolean;
      
      private var _id:int;
      
      public var mcBG:MovieClip;
      
      public function DropDownMenuListBoxItem(param1:IDropDownMenuHandler, param2:int, param3:String, param4:Boolean = true)
      {
         super();
         this._handler = param1;
         this._id = param2;
         this._isActive = param4;
         this.tfName.text = param3;
         this.mcBG.alpha = 0;
         if(this._isActive)
         {
            this.tfName.textColor = NAME_COLOR_ACTIVE;
            this.tfStatus.text = "OPEN";
            this.tfStatus.textColor = STATUS_COLOR_OPEN;
            this.buttonMode = true;
            this.useHandCursor = true;
            this.mouseEnabled = true;
            this.mouseChildren = false;
            this.addListeners();
         }
         else
         {
            this.tfName.textColor = NAME_COLOR_INACTIVE;
            this.tfStatus.text = "FULL";
            this.tfStatus.textColor = STATUS_COLOR_FULL;
         }
      }
      
      private function addListeners() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOverHandler,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOutHandler,false,0,true);
         addEventListener(MouseEvent.CLICK,this.onClickHandler,false,0,true);
      }
      
      private function onRollOverHandler(param1:MouseEvent) : void
      {
         Tweener.removeTweens(this.mcBG);
         Tweener.addTween(this.mcBG,{
            "alpha":0.5,
            "time":0.25,
            "transition":"easeOutQuad"
         });
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         this._handler.itemClicked(this._id);
      }
      
      private function onRollOutHandler(param1:MouseEvent) : void
      {
         Tweener.removeTweens(this.mcBG);
         Tweener.addTween(this.mcBG,{
            "alpha":0,
            "time":0.25,
            "transition":"easeOutQuad"
         });
      }
   }
}

