package com.arkadium.virmon.shared.components
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol18")]
   public class SwarmHealthMeter extends Sprite
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeOutQuad
      };
      
      private static const BG_Y_START:Number = 0;
      
      private static const BG_Y_END:Number = 15;
      
      private static const BG_PERCENT_DELTA:Number = 15 / 100;
      
      private static const COLOR_RED:Number = 9709351;
      
      private static const POPUP_OFFSET_DEFAULT_FRAME:String = "default";
      
      private static const POPUP_OFFSET_ALT_FRAME:String = "altLeft";
      
      public static const UNKNOWN_NANOVOR_ID:String = "-1";
      
      public static const POPUP_OFFSET_DEFAULT:int = -15;
      
      public static const POPUP_OFFSET_ALT_LEFT:int = -67;
      
      public var sortTieBreaker:int;
      
      private var _mask:Sprite;
      
      public var mcOutline:Sprite;
      
      private var _szMasterName:String;
      
      public var mcBG:Sprite;
      
      private var _iPopupOffset:int = -15;
      
      private var _iMaxHealth:int = 1;
      
      private var _iAssetId:String = "-1";
      
      public var mcMask:MovieClip;
      
      public var mcHit:MovieClip;
      
      private var _iHealth:int = 1;
      
      private var _szNickName:String;
      
      public var mcPopup:MovieClip;
      
      public function SwarmHealthMeter()
      {
         super();
         _mask = mcMask.mcBG;
         mcPopup.mouseEnabled = false;
         mcPopup.mouseChildren = false;
         mcPopup.visible = false;
         masterName = "(UNKNOWN)";
         nickName = "";
         mcPopup.tfHealth.text = "?";
         mcOutline.alpha = 0.75;
         mcBG.cacheAsBitmap = true;
         mcMask.cacheAsBitmap = true;
         mcBG.mask = mcMask;
         mcHit.addEventListener(MouseEvent.ROLL_OVER,onHitRollOver,false,0,true);
         mcHit.addEventListener(MouseEvent.ROLL_OUT,onHitRollOut,false,0,true);
      }
      
      public function set maxHealth(param1:int) : void
      {
         _iMaxHealth = param1;
      }
      
      public function set popupOffset(param1:int) : void
      {
         setPopupOffset(param1);
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,onHitRollOver);
         removeEventListener(MouseEvent.ROLL_OUT,onHitRollOut);
      }
      
      public function get masterName() : String
      {
         return _szMasterName;
      }
      
      public function get nickName() : String
      {
         return _szNickName;
      }
      
      public function get healthRatio() : Number
      {
         return _iHealth / _iMaxHealth;
      }
      
      private function setNickName(param1:String) : void
      {
         _szNickName = param1;
         mcPopup.tfNickName.text = param1.toUpperCase();
         if(_szNickName.length > 0)
         {
            mcPopup.mcBG.height += 11;
            mcPopup.tfNickName.visible = true;
         }
         else
         {
            mcPopup.tfNickName.visible = false;
         }
      }
      
      private function onHitRollOver(param1:MouseEvent) : void
      {
         mcPopup.visible = true;
      }
      
      private function setHealth(param1:int) : void
      {
         param1 = param1 < 0 ? 0 : (param1 > _iMaxHealth ? _iMaxHealth : param1);
         _iHealth = param1;
         mcPopup.tfHealth.text = param1;
         setFillPercentage(100 * (_iHealth / _iMaxHealth));
         if(_iHealth <= 0)
         {
            Tweener.addTween(mcOutline,{
               "_color":COLOR_RED,
               "time":0.4,
               "transition":"easeInOutQuad"
            });
            Tweener.addTween(mcBG,{
               "_color":COLOR_RED,
               "time":0.4,
               "transition":"easeInOutQuad"
            });
         }
      }
      
      public function set masterName(param1:String) : void
      {
         setMasterName(param1);
      }
      
      private function setMasterName(param1:String) : void
      {
         _szMasterName = param1;
         mcPopup.tfMasterName.text = _szMasterName.toUpperCase();
         mcPopup.tfMasterName.autoSize = TextFieldAutoSize.LEFT;
      }
      
      private function onHitRollOut(param1:MouseEvent) : void
      {
         mcPopup.visible = false;
      }
      
      public function get maxHealth() : int
      {
         return _iMaxHealth;
      }
      
      public function set nickName(param1:String) : void
      {
         setNickName(param1);
      }
      
      public function set assetId(param1:String) : void
      {
         _iAssetId = param1;
      }
      
      public function get assetId() : String
      {
         return _iAssetId;
      }
      
      override public function set width(param1:Number) : void
      {
         mcOutline.width = param1;
         mcBG.width = param1;
         _mask.width = param1 - 1;
         mcHit.width = param1 - 1;
         mcPopup.x = Math.round(param1 / 2 + _iPopupOffset);
      }
      
      private function setPopupOffset(param1:int) : void
      {
         _iPopupOffset = param1;
         mcPopup.mcBG.gotoAndStop(param1 == POPUP_OFFSET_ALT_LEFT ? POPUP_OFFSET_ALT_FRAME : POPUP_OFFSET_DEFAULT_FRAME);
         mcPopup.x = Math.round(mcOutline.width / 2 + _iPopupOffset);
      }
      
      public function set health(param1:int) : void
      {
         setHealth(param1);
      }
      
      public function get health() : int
      {
         return _iHealth;
      }
      
      private function setFillPercentage(param1:Number) : void
      {
         Tweener.addTween(mcBG,{
            "base":TWEEN_BASE,
            "y":BG_Y_START + Math.floor((100 - param1) * BG_PERCENT_DELTA)
         });
      }
   }
}

