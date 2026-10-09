package com.arkadium.virmon.senseibattle.ui
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.components.ISwarmometer;
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   import com.arkadium.virmon.shared.components.avatar.OverridePopupController;
   import com.arkadium.virmon.shared.final.elements.UnknownNanovorSpinner;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol81")]
   public class SenseiAvatar extends Sprite implements IAvatar
   {
      
      private static const OVERRIDE_TWEEN_SECONDS:Number = 0.15;
      
      private static const GENERAL_TWEEN_SECONDS:Number = 1;
      
      private static const SENSEI_AVATAR_SCALE:Number = 0.35;
      
      private static const SENSEI_AVATAR_POINT:Point = new Point(14,11);
      
      private var _energyField:TextField;
      
      public var mcAvatarHolder:MovieClip;
      
      private var _override:Sprite;
      
      private var _nameField:TextField;
      
      private var _playerId:int;
      
      private var _overridePopupController:OverridePopupController;
      
      private var _overrideSlot:MovieClip;
      
      public var mcBackPanel:MovieClip;
      
      public var mcSwarmometer:ISwarmometer;
      
      public function SenseiAvatar()
      {
         super();
         _energyField = mcBackPanel.tfEnergy;
         _nameField = mcBackPanel.tfName;
         _overrideSlot = mcAvatarHolder.mcOverride;
         this.mouseEnabled = false;
         mcAvatarHolder.mouseEnabled = false;
         mcBackPanel.mouseEnabled = false;
         mcBackPanel.mouseChildren = false;
         _overrideSlot.alpha = 0;
         _overrideSlot.mouseEnabled = false;
         _energyField.mouseEnabled = false;
         _nameField.mouseEnabled = false;
         _energyField.text = "";
         _nameField.text = "";
         createOverrideSlot();
         createSenseiAvatar();
         _overridePopupController = new OverridePopupController(_overrideSlot.mcOverridePopup);
         _overrideSlot.setChildIndex(_overrideSlot.mcOverridePopup,_overrideSlot.numChildren - 1);
      }
      
      private function createOverrideSlot() : void
      {
         _override = new Sprite();
         _override.x = 7;
         _override.y = 8;
         _overrideSlot.addChild(_override);
      }
      
      public function set playerID(param1:int) : void
      {
         _playerId = param1;
      }
      
      private function removeOverrideTint() : void
      {
         Tweener.addTween(_overrideSlot,{
            "_colorTransform":new ColorTransform(),
            "time":OVERRIDE_TWEEN_SECONDS
         });
      }
      
      public function get playerName() : String
      {
         return _nameField.text;
      }
      
      public function set energy(param1:int) : void
      {
         _energyField.text = param1.toString();
      }
      
      public function set playerName(param1:String) : void
      {
         _nameField.text = param1.toUpperCase();
      }
      
      public function set override(param1:Boolean) : void
      {
         if(param1)
         {
            showOverrideChain();
         }
         else
         {
            hideOverride();
         }
      }
      
      public function set glow(param1:Boolean) : void
      {
      }
      
      public function set nmp(param1:int) : void
      {
      }
      
      public function loadAvatarPicture(param1:int) : void
      {
      }
      
      private function hideOverride() : void
      {
         Tweener.removeTweens(_overrideSlot,"alpha");
         Tweener.addTween(_overrideSlot,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS,
            "onComplete":function():*
            {
               _overrideSlot.visible = false;
            }
         });
      }
      
      public function get playerID() : int
      {
         return _playerId;
      }
      
      public function setStatusText(param1:String, param2:uint = 16777216) : void
      {
      }
      
      private function onOverrideRollOut(param1:MouseEvent) : void
      {
         _overridePopupController.close();
      }
      
      public function set mode(param1:String) : void
      {
      }
      
      private function createSenseiAvatar() : void
      {
         var _loc1_:MovieClip = new UnknownNanovorSpinner();
         _loc1_.scaleX = _loc1_.scaleY = SENSEI_AVATAR_SCALE;
         _loc1_.x = SENSEI_AVATAR_POINT.x;
         _loc1_.y = SENSEI_AVATAR_POINT.y;
         mcAvatarHolder.addChild(_loc1_);
      }
      
      public function set nanocash(param1:int) : void
      {
      }
      
      private function showOverrideChain() : void
      {
         _overrideSlot.visible = true;
         Tweener.removeTweens(_overrideSlot,"alpha");
         Tweener.addTween(_overrideSlot,{
            "alpha":1,
            "time":OVERRIDE_TWEEN_SECONDS
         });
         Tweener.addTween(_overrideSlot,{
            "_color":16777215,
            "time":OVERRIDE_TWEEN_SECONDS,
            "onComplete":removeOverrideTint
         });
      }
      
      private function onOverrideRollOver(param1:MouseEvent) : void
      {
         _overridePopupController.open();
      }
      
      public function setOverride(param1:*) : void
      {
         while(_override.numChildren > 0)
         {
            _override.removeChildAt(0);
         }
         _override.removeEventListener(MouseEvent.ROLL_OVER,onOverrideRollOver);
         _override.removeEventListener(MouseEvent.ROLL_OUT,onOverrideRollOut);
         if(param1 != null)
         {
            _override.addChild(param1);
            _overridePopupController.text = param1.overrideDescription;
            _override.addEventListener(MouseEvent.ROLL_OVER,onOverrideRollOver,false,0,true);
            _override.addEventListener(MouseEvent.ROLL_OUT,onOverrideRollOut,false,0,true);
         }
         else
         {
            _overridePopupController.close();
         }
      }
      
      public function set status(param1:String) : void
      {
      }
      
      public function get swarmometer() : ISwarmometer
      {
         return mcSwarmometer;
      }
      
      public function set color(param1:uint) : void
      {
      }
   }
}

