package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CategoryButtonController extends MovieClip
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.3,
         "transition":Equations.easeInOutQuad
      };
      
      private static const ACTIVE_TEXT_COLOR:uint = 1597303;
      
      private static const DEACTIVE_TEXT_COLOR:uint = 16777215;
      
      private var _mcBorder:MovieClip;
      
      private var _tfTitle:TextField;
      
      public var categoryText:String = "Duke of New York, A Number One";
      
      private var _mcFill:MovieClip;
      
      private var _isActive:Boolean;
      
      private var _base:MovieClip;
      
      public var categoryId:int = 10;
      
      public var categoryPhrases:Array;
      
      public function CategoryButtonController(param1:MovieClip)
      {
         super();
         param1.controller = this;
         this._base = param1;
         this._tfTitle = this._base.tfTitle;
         this._mcBorder = this._base.mcBorder;
         this._mcFill = this._base.mcFill;
         this.init();
      }
      
      public function hide() : void
      {
         this._base.visible = false;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._isActive = param1;
         if(this._isActive)
         {
            this.activate();
         }
         else
         {
            this.deactivate();
         }
      }
      
      private function init() : void
      {
         this._base.mouseChildren = false;
         this._isActive = false;
         this._base.buttonMode = true;
         this._tfTitle.text = "";
         this._mcFill.alpha = 0;
         this._base.addEventListener(MouseEvent.ROLL_OVER,this.onBaseRollOver,false,0,true);
         this._base.addEventListener(MouseEvent.ROLL_OUT,this.onBaseRollOut,false,0,true);
      }
      
      private function onBaseRollOver(param1:MouseEvent) : void
      {
         if(!this._isActive)
         {
            this.activate();
         }
      }
      
      private function onBaseRollOut(param1:MouseEvent) : void
      {
         if(!this._isActive)
         {
            this.deactivate();
         }
      }
      
      public function set title(param1:String) : void
      {
         this._tfTitle.text = param1;
      }
      
      public function deactivate() : void
      {
         Tweener.addTween(this._mcFill,{
            "base":TWEEN_BASE,
            "alpha":0
         });
         Tweener.addTween(this._tfTitle,{
            "base":TWEEN_BASE,
            "_color":DEACTIVE_TEXT_COLOR
         });
      }
      
      public function activate() : void
      {
         Tweener.addTween(this._mcFill,{
            "base":TWEEN_BASE,
            "alpha":1
         });
         Tweener.addTween(this._tfTitle,{
            "base":TWEEN_BASE,
            "_color":ACTIVE_TEXT_COLOR
         });
      }
      
      public function show() : void
      {
         this._base.visible = true;
      }
   }
}

