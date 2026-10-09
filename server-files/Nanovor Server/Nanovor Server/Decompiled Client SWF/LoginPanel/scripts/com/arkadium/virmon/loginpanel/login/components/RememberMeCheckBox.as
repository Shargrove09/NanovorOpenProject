package com.arkadium.virmon.loginpanel.login.components
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol76")]
   public class RememberMeCheckBox extends Sprite
   {
      
      public var mcHitArea:Sprite;
      
      public var mcCheckBoxUnchecked:Sprite;
      
      public var mcCheckBoxChecked:Sprite;
      
      public function RememberMeCheckBox()
      {
         super();
         this.hitArea = this.mcHitArea;
         this.mcHitArea.alpha = 0;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.handleCheckBoxClick);
         this.removeChild(this.mcCheckBoxChecked);
      }
      
      public function toggle(param1:Boolean) : void
      {
         var _loc2_:Sprite = param1 ? this.mcCheckBoxUnchecked : this.mcCheckBoxChecked;
         var _loc3_:Sprite = param1 ? this.mcCheckBoxChecked : this.mcCheckBoxUnchecked;
         this.addChild(_loc3_);
         if(null != _loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
      }
      
      public function get isSelected() : Boolean
      {
         return Boolean(null != this.mcCheckBoxChecked.parent);
      }
      
      private function handleCheckBoxClick(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null == this.mcCheckBoxChecked.parent ? this.mcCheckBoxUnchecked : this.mcCheckBoxChecked;
         var _loc3_:Sprite = null == this.mcCheckBoxChecked.parent ? this.mcCheckBoxChecked : this.mcCheckBoxUnchecked;
         this.addChild(_loc3_);
         _loc2_.parent.removeChild(_loc2_);
      }
   }
}

