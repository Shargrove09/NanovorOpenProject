package com.arkadium.virmon.shared.effects
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import fl.motion.AdjustColor;
   import fl.motion.Color;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   
   public class GlowDistort extends Sprite
   {
      
      private static var _colorMatrix:ColorMatrixFilter;
      
      private static var _blur:BlurFilter;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      private var _blurTintLayer:Sprite;
      
      private var _blendLayer:Sprite;
      
      public function GlowDistort(param1:DisplayObject, param2:DisplayObject, param3:uint = 16777215, param4:Number = 1)
      {
         var _loc6_:AdjustColor = null;
         super();
         if(null == _blur)
         {
            _blur = new BlurFilter(10,5);
         }
         if(null == _colorMatrix)
         {
            _loc6_ = new AdjustColor();
            _loc6_.brightness = 35;
            _loc6_.contrast = -12;
            _loc6_.saturation = -100;
            _loc6_.hue = 0;
            _colorMatrix = new ColorMatrixFilter(_loc6_.CalculateFinalFlatArray());
         }
         this._blendLayer = new Sprite();
         this._blendLayer.addChild(param1);
         var _loc5_:Color = new Color();
         _loc5_.setTint(param3,param4);
         this._blurTintLayer = new Sprite();
         this._blurTintLayer.filters = [_blur];
         this._blurTintLayer.transform.colorTransform = _loc5_;
         this._blurTintLayer.addChild(param2);
         this._blurTintLayer.alpha = 0;
         this.addChild(this._blurTintLayer);
         this.addChild(this._blendLayer);
      }
      
      public function disable() : void
      {
         this._blendLayer.blendMode = BlendMode.NORMAL;
         this._blendLayer.filters = [];
         Tweener.addTween(this._blurTintLayer,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
      }
      
      public function enable() : void
      {
         this._blendLayer.blendMode = BlendMode.HARDLIGHT;
         this._blendLayer.filters = [_colorMatrix];
         Tweener.addTween(this._blurTintLayer,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
      }
   }
}

