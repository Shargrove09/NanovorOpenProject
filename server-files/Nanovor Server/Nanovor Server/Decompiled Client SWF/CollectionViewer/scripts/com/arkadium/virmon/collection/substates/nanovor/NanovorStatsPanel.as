package com.arkadium.virmon.collection.substates.nanovor
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.collection.substates.nanovor.components.NanovorInfoPanelComponent;
   import com.arkadium.virmon.collection.substates.nanovor.components.NanovorStatViewComponent;
   import com.arkadium.virmon.collection.substates.nanovor.elements.BuffedTextElement;
   import com.arkadium.virmon.collection.substates.nanovor.elements.SpendJoltsButtonElement;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.IVirmonMasterData;
   import com.smithandtinker.nanovor.common.Stat;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class NanovorStatsPanel extends NanovorInfoPanelComponent
   {
      
      private var _healthView:NanovorStatViewComponent;
      
      private var _armorView:NanovorStatViewComponent;
      
      private var _speedView:NanovorStatViewComponent;
      
      private var ITEM_HEIGHT:int = 65;
      
      private var _strengthView:NanovorStatViewComponent;
      
      private var _buffedText:BuffedTextElement;
      
      private var _spendButton:SpendJoltsButtonElement;
      
      private var _bSpendButtonEnabled:Boolean = false;
      
      public function NanovorStatsPanel()
      {
         super();
         init();
      }
      
      private function onStrengthBuff(param1:Event) : void
      {
         dispatchEvent(new NanovorStatsPanelEvent(param1.type == "buffEvent" ? NanovorStatsPanelEvent.BUFF_UP : NanovorStatsPanelEvent.BUFF_DOWN,Stat.STRENGTH));
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorStatsPanel: " + param1);
      }
      
      private function _checkMouseEventTrail(param1:MouseEvent) : void
      {
         log("//---------------------------------------------------------------------------------------------------");
         var _loc2_:* = param1.target;
         while(_loc2_)
         {
            log("_checkMouseEventTrail >> " + _loc2_.name + ": " + _loc2_);
            _loc2_ = _loc2_.parent;
         }
         log("//---------------------------------------------------------------------------------------------------");
      }
      
      private function onSpendClick(param1:MouseEvent) : void
      {
         dispatchEvent(new NanovorStatsPanelEvent(NanovorStatsPanelEvent.CONFIRM_SPEND));
         log("onSpendClick()");
      }
      
      private function removeSpendButton() : void
      {
         if(null != _spendButton.parent)
         {
            _spendButton.parent.removeChild(_spendButton);
         }
      }
      
      private function onHealthBuff(param1:Event) : void
      {
         dispatchEvent(new NanovorStatsPanelEvent(param1.type == "buffEvent" ? NanovorStatsPanelEvent.BUFF_UP : NanovorStatsPanelEvent.BUFF_DOWN,Stat.HEALTH));
      }
      
      public function enableSpendButton(param1:Boolean) : void
      {
         if(param1)
         {
            if(_bSpendButtonEnabled)
            {
               return;
            }
            _bSpendButtonEnabled = true;
            this.addChild(_spendButton);
            Tweener.addTween(_spendButton,{
               "_autoAlpha":1,
               "time":0.5
            });
         }
         else
         {
            if(!_bSpendButtonEnabled)
            {
               return;
            }
            _bSpendButtonEnabled = false;
            Tweener.addTween(_spendButton,{
               "_autoAlpha":0,
               "time":0.5,
               "onComplete":removeSpendButton
            });
         }
      }
      
      private function init() : void
      {
         viewField.text = "STATS and JOLTS";
         _healthView = new NanovorStatViewComponent("health",13378082);
         _strengthView = new NanovorStatViewComponent("strength",13412898);
         _armorView = new NanovorStatViewComponent("armor",6697932);
         _speedView = new NanovorStatViewComponent("speed",2280482);
         _healthView.y = _startY;
         _strengthView.y = _startY + ITEM_HEIGHT;
         _armorView.y = _startY + ITEM_HEIGHT * 2;
         _speedView.y = _startY + ITEM_HEIGHT * 3;
         _spendButton = new SpendJoltsButtonElement();
         _spendButton.x = 180;
         _spendButton.y = _speedView.y + ITEM_HEIGHT;
         _spendButton.alpha = 0;
         _spendButton.visible = false;
         _buffedText = new BuffedTextElement();
         _buffedText.stop();
         _buffedText.visible = false;
         _buffedText.x = 400;
         _buffedText.y = 100;
         addChild(_healthView);
         addChild(_strengthView);
         addChild(_armorView);
         addChild(_speedView);
         addChild(_buffedText);
         addListeners();
      }
      
      public function setStat(param1:String, param2:int, param3:int, param4:int) : void
      {
         switch(param1)
         {
            case Stat.HEALTH:
               _healthView.setValue(param2,param3,param4);
               break;
            case Stat.ARMOR:
               _armorView.setValue(param2,param3,param4);
               break;
            case Stat.STRENGTH:
               _strengthView.setValue(param2,param3,param4);
               break;
            case Stat.SPEED:
               _speedView.setValue(param2,param3,param4);
         }
      }
      
      private function removeListeners() : void
      {
         _spendButton.removeEventListener(MouseEvent.CLICK,onSpendClick);
         _healthView.removeEventListener("buffEvent",onHealthBuff);
         _armorView.removeEventListener("buffEvent",onArmorBuff);
         _strengthView.removeEventListener("buffEvent",onStrengthBuff);
         _speedView.removeEventListener("buffEvent",onSpeedBuff);
         _healthView.removeEventListener("unbuffEvent",onHealthBuff);
         _armorView.removeEventListener("unbuffEvent",onArmorBuff);
         _strengthView.removeEventListener("unbuffEvent",onStrengthBuff);
         _speedView.removeEventListener("unbuffEvent",onSpeedBuff);
      }
      
      private function addListeners() : void
      {
         _spendButton.addEventListener(MouseEvent.CLICK,onSpendClick,false,0,true);
         _healthView.addEventListener("buffEvent",onHealthBuff,false,0,true);
         _armorView.addEventListener("buffEvent",onArmorBuff,false,0,true);
         _strengthView.addEventListener("buffEvent",onStrengthBuff,false,0,true);
         _speedView.addEventListener("buffEvent",onSpeedBuff,false,0,true);
         _healthView.addEventListener("unbuffEvent",onHealthBuff,false,0,true);
         _armorView.addEventListener("unbuffEvent",onArmorBuff,false,0,true);
         _strengthView.addEventListener("unbuffEvent",onStrengthBuff,false,0,true);
         _speedView.addEventListener("unbuffEvent",onSpeedBuff,false,0,true);
      }
      
      private function onStage(param1:Event) : void
      {
         stage.addEventListener(MouseEvent.CLICK,_checkMouseEventTrail);
      }
      
      override public function setNanovor(param1:IVirmonData, param2:String) : void
      {
         if(param2 != null)
         {
            super.setNanovor(param1,param2);
         }
         var _loc3_:IVirmonMasterData = param1.getVirmonMasterData();
         _healthView.setData(param1.getHealth(),_loc3_.getMaxHealth(),_loc3_.getBaseHealth(),_loc3_.getHealthBuffFormula(),UserProfile.getInstance().healthJolts);
         _armorView.setData(param1.getArmor(),_loc3_.getMaxArmor(),_loc3_.getBaseArmor(),_loc3_.getArmorBuffFormula(),UserProfile.getInstance().armorJolts);
         _strengthView.setData(param1.getStrength(),_loc3_.getMaxStrength(),_loc3_.getBaseStrength(),_loc3_.getStrengthBuffFormula(),UserProfile.getInstance().strengthJolts);
         _speedView.setData(param1.getSpeed(),_loc3_.getMaxSpeed(),_loc3_.getBaseSpeed(),_loc3_.getSpeedBuffFormula(),UserProfile.getInstance().speedJolts);
         enableSpendButton(false);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorStatsPanel: " + param1);
      }
      
      private function onSpeedBuff(param1:Event) : void
      {
         dispatchEvent(new NanovorStatsPanelEvent(param1.type == "buffEvent" ? NanovorStatsPanelEvent.BUFF_UP : NanovorStatsPanelEvent.BUFF_DOWN,Stat.SPEED));
      }
      
      private function onArmorBuff(param1:Event) : void
      {
         dispatchEvent(new NanovorStatsPanelEvent(param1.type == "buffEvent" ? NanovorStatsPanelEvent.BUFF_UP : NanovorStatsPanelEvent.BUFF_DOWN,Stat.ARMOR));
      }
      
      public function getBuffObject() : Object
      {
         return {
            "health":_healthView.getDelta(),
            "strength":_strengthView.getDelta(),
            "speed":_speedView.getDelta(),
            "armor":_armorView.getDelta()
         };
      }
      
      public function buffSuccess() : void
      {
         _buffedText.visible = true;
         _buffedText.gotoAndPlay(1);
      }
      
      override public function destroy() : void
      {
         removeListeners();
         _healthView.destroy();
         _armorView.destroy();
         _strengthView.destroy();
         _speedView.destroy();
         _spendButton.destroy();
         super.destroy();
      }
   }
}

