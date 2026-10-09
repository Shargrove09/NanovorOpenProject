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
         _target = param1;
         _wire = _target.mcWire;
         _title = _target.tfTop;
         _subtitle = _target.tfBottom;
         _titleOriginalX = _title.x;
         _subtitleOriginalX = _subtitle.x;
         _superTitle = _target.tfTopTop;
         if(_superTitle != null)
         {
            _superTitle.text = "";
         }
         _target.mouseEnabled = false;
         _target.mouseChildren = false;
         _target.stop();
         _title.alpha = 0;
         _title.visible = false;
         _subtitle.alpha = 0;
         _subtitle.visible = false;
      }
      
      public function get wire() : MovieClip
      {
         return _wire;
      }
      
      public function set mouseEnabled(param1:Boolean) : void
      {
      }
      
      public function flipV(param1:Boolean) : void
      {
         if(_isFlippedV == param1)
         {
            return;
         }
         _isFlippedV = param1;
         if(param1)
         {
            _target.scaleY = -1;
            _title.scaleY = -1;
            _title.y += _title.height - 4;
            _subtitle.scaleY = -1;
            _subtitle.y += _subtitle.height - 4;
         }
         swapExistingTextAndColor();
      }
      
      public function open() : void
      {
         Tweener.addTween(_target,{
            "_autoAlpha":1,
            "time":0.5
         });
         _target.addEventListener(Event.COMPLETE,showNameText);
         _target.gotoAndPlay(1);
      }
      
      public function set mouseChildren(param1:Boolean) : void
      {
      }
      
      private function getSubtitleX() : Number
      {
         if(_isFlippedV)
         {
            return _titleOriginalX;
         }
         return _subtitleOriginalX;
      }
      
      public function get title() : TextField
      {
         if(_isFlippedV)
         {
            return _subtitle;
         }
         return _title;
      }
      
      public function get superTitle() : TextField
      {
         return _superTitle;
      }
      
      public function get subtitle() : TextField
      {
         if(_isFlippedV)
         {
            return _title;
         }
         return _subtitle;
      }
      
      private function showNameText(param1:Event) : void
      {
         this.title.x = getTitleX() + 10;
         Tweener.addTween(this.title,{
            "_autoAlpha":1,
            "time":0.5,
            "x":getTitleX()
         });
         this.subtitle.x = getSubtitleX() - 10;
         Tweener.addTween(this.subtitle,{
            "_autoAlpha":1,
            "time":0.5,
            "x":getSubtitleX()
         });
      }
      
      private function getTitleX() : Number
      {
         if(_isFlippedV)
         {
            return _subtitleOriginalX;
         }
         return _titleOriginalX;
      }
      
      public function close() : void
      {
         Tweener.addTween(_target,{
            "_autoAlpha":0,
            "time":0.5
         });
         Tweener.addTween(this.title,{
            "_autoAlpha":0,
            "x":getTitleX() + 10,
            "time":0.5
         });
         Tweener.addTween(this.subtitle,{
            "_autoAlpha":0,
            "x":getSubtitleX() - 10,
            "time":0.5
         });
      }
      
      private function swapExistingTextAndColor() : void
      {
         var _loc1_:String = _title.text;
         var _loc2_:uint = _title.textColor;
         _title.text = _subtitle.text;
         _title.textColor = _subtitle.textColor;
         _subtitle.text = _loc1_;
         _subtitle.textColor = _loc2_;
      }
   }
}

