package com.arkadium.virmon.avatar
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class NameWire
   {
      
      private var _titleOriginalX:Number;
      
      private var _subtitleOriginalX:Number;
      
      private var _title:TextField;
      
      private var _wire:MovieClip;
      
      private var _target:MovieClip;
      
      private var _subtitle:TextField;
      
      private var _superTitle:TextField;
      
      private var _isFlippedV:Boolean = false;
      
      public function NameWire(param1:MovieClip)
      {
         super();
         this._target = param1;
         this._wire = this._target.mcWire;
         this._title = this._target.tfTop;
         this._subtitle = this._target.tfBottom;
         this._titleOriginalX = this._title.x;
         this._subtitleOriginalX = this._subtitle.x;
         this._superTitle = this._target.tfTopTop;
         if(this._superTitle != null)
         {
            this._superTitle.text = "";
         }
         this._target.mouseEnabled = false;
         this._target.mouseChildren = false;
         this._target.stop();
         this._title.alpha = 0;
         this._title.visible = false;
         this._subtitle.alpha = 0;
         this._subtitle.visible = false;
      }
      
      public function get wire() : MovieClip
      {
         return this._wire;
      }
      
      public function set mouseEnabled(param1:Boolean) : void
      {
      }
      
      public function flipV(param1:Boolean) : void
      {
         if(this._isFlippedV == param1)
         {
            return;
         }
         this._isFlippedV = param1;
         if(param1)
         {
            this._target.scaleY = -1;
            this._title.scaleY = -1;
            this._title.y += this._title.height - 4;
            this._subtitle.scaleY = -1;
            this._subtitle.y += this._subtitle.height - 4;
         }
         this.swapExistingTextAndColor();
      }
      
      public function open() : void
      {
         Tweener.addTween(this._target,{
            "_autoAlpha":1,
            "time":0.5
         });
         this._target.addEventListener(Event.COMPLETE,this.showNameText);
         this._target.gotoAndPlay(1);
      }
      
      public function set mouseChildren(param1:Boolean) : void
      {
      }
      
      private function getSubtitleX() : Number
      {
         if(this._isFlippedV)
         {
            return this._titleOriginalX;
         }
         return this._subtitleOriginalX;
      }
      
      public function get title() : TextField
      {
         if(this._isFlippedV)
         {
            return this._subtitle;
         }
         return this._title;
      }
      
      public function get superTitle() : TextField
      {
         return this._superTitle;
      }
      
      public function get subtitle() : TextField
      {
         if(this._isFlippedV)
         {
            return this._title;
         }
         return this._subtitle;
      }
      
      private function showNameText(param1:Event) : void
      {
         this.title.x = this.getTitleX() + 10;
         Tweener.addTween(this.title,{
            "_autoAlpha":1,
            "time":0.5,
            "x":this.getTitleX()
         });
         this.subtitle.x = this.getSubtitleX() - 10;
         Tweener.addTween(this.subtitle,{
            "_autoAlpha":1,
            "time":0.5,
            "x":this.getSubtitleX()
         });
      }
      
      private function getTitleX() : Number
      {
         if(this._isFlippedV)
         {
            return this._subtitleOriginalX;
         }
         return this._titleOriginalX;
      }
      
      public function close() : void
      {
         Tweener.addTween(this._target,{
            "_autoAlpha":0,
            "time":0.5
         });
         Tweener.addTween(this.title,{
            "_autoAlpha":0,
            "x":this.getTitleX() + 10,
            "time":0.5
         });
         Tweener.addTween(this.subtitle,{
            "_autoAlpha":0,
            "x":this.getSubtitleX() - 10,
            "time":0.5
         });
      }
      
      private function swapExistingTextAndColor() : void
      {
         var _loc1_:String = this._title.text;
         var _loc2_:uint = this._title.textColor;
         this._title.text = this._subtitle.text;
         this._title.textColor = this._subtitle.textColor;
         this._subtitle.text = _loc1_;
         this._subtitle.textColor = _loc2_;
      }
   }
}

