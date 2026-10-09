package com.arkadium.virmon.shared.final.components.actionslot
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.shared.elements.icons.actions.*;
   import com.arkadium.virmon.shared.elements.icons.overrides.*;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class ConsequenceSlot extends ActionSlotComponent
   {
      
      private var _selfAttackOffset:Number;
      
      private var _bOpened:Boolean = false;
      
      public function ConsequenceSlot(param1:IAttack = null)
      {
         super(param1);
         mcLine.visible = false;
         tfGlowingActionTitle.visible = false;
         tfActionTitle.visible = false;
         mcActionIcon.visible = false;
         mcActionIconGlow.visible = false;
         mcEnergyIcon.visible = false;
         tfEnergyCost.visible = false;
         mcCostText.visible = false;
         this.backgroundState = ActionSlotComponent.BACKGROUND_STATE_CLEAR;
         this.buttonMode = false;
         this.mouseChildren = false;
      }
      
      private function finishClosing() : void
      {
         log("finishClosing: _bOpened=" + _bOpened);
         if(_bOpened)
         {
            return;
         }
         Tweener.addTween(this,{
            "alpha":0,
            "time":0.3,
            "transition":"easeOutQuad"
         });
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> ConsequenceSlot: " + param1);
      }
      
      private function finishOpening() : void
      {
         this.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
      }
      
      public function open(param1:Number = 1, param2:Number = 1) : void
      {
         var _loc3_:int = 0;
         log("open (" + attack.name + ")");
         _bOpened = true;
         Tweener.removeTweens(this);
         this.alpha = 1;
         this.backgroundState = ActionSlotComponent.BACKGROUND_STATE_CLEAR;
         Tweener.removeTweens(mcIconContainer);
         Tweener.addTween(mcIconContainer,{
            "x":2,
            "time":param1,
            "transition":"easeOutQuad"
         });
         var _loc4_:int = int(icons.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            Tweener.removeTweens(icons[_loc3_].tfText,"alpha");
            if(_loc3_ < _loc4_ - 1)
            {
               Tweener.addTween(icons[_loc3_].tfText,{
                  "alpha":1,
                  "time":param2,
                  "transition":"easeOutQuad"
               });
            }
            else
            {
               Tweener.addTween(icons[_loc3_].tfText,{
                  "alpha":1,
                  "time":param2,
                  "onComplete":finishOpening,
                  "transition":"easeOutQuad"
               });
            }
            _loc3_++;
         }
      }
      
      protected function logError(param1:String) : void
      {
         DebugLog.instance.error("** ConsequenceSlot: " + param1);
      }
      
      public function setInfo(param1:Array, param2:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         removeAllIcons();
         for(_loc6_ in param1)
         {
            _loc3_ = Boolean(_loc6_.substr(0,4) == "self");
            if(!_loc3_)
            {
               addIcon(_loc6_,param1[_loc6_].delta,param1[_loc6_].type);
            }
         }
         _loc7_ = 2;
         _loc9_ = int(icons.length);
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            icons[_loc8_].tfText.alpha = 0;
            icons[_loc8_].x = _loc7_;
            _loc7_ += ActionSlotStatIconComponent.WIDTH + 2;
            _loc8_++;
         }
         _selfAttackOffset = param2 * (ActionSlotStatIconComponent.WIDTH + 2);
         mcIconContainer.x = 36 + _selfAttackOffset;
      }
      
      private function removeAllIcons() : void
      {
         while(mcIconContainer.numChildren > 0)
         {
            mcIconContainer.removeChildAt(0);
         }
         icons = new Array();
      }
      
      public function close(param1:Number = 1, param2:Number = 1) : void
      {
         var _loc3_:int = 0;
         log("close (" + attack.name + ")");
         _bOpened = false;
         this.backgroundState = ActionSlotComponent.BACKGROUND_STATE_CLEAR;
         Tweener.removeTweens(mcIconContainer);
         Tweener.addTween(mcIconContainer,{
            "x":36 + _selfAttackOffset,
            "time":param1,
            "transition":"easeOutQuad"
         });
         var _loc4_:int = int(icons.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            Tweener.removeTweens(icons[_loc3_].tfText);
            if(_loc3_ < _loc4_ - 1)
            {
               Tweener.addTween(icons[_loc3_].tfText,{
                  "alpha":0,
                  "time":param2,
                  "transition":"easeOutQuad"
               });
            }
            else
            {
               Tweener.addTween(icons[_loc3_].tfText,{
                  "alpha":0,
                  "time":param2,
                  "onComplete":finishClosing,
                  "transition":"easeOutQuad"
               });
            }
            _loc3_++;
         }
      }
   }
}

