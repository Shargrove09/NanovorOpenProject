package com.arkadium.virmon.shared.ui.gameOptions
{
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.arkadium.virmon.common.StoredSetting;
   import com.arkadium.virmon.common.StoredSettingManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.ui.CheckBox;
   import com.arkadium.virmon.shared.ui.ICheckBoxHandler;
   import com.arkadium.virmon.shared.ui.RadioButton;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class CGameOptions extends MovieClip implements ICGameOptions, ICheckBoxHandler
   {
      
      public var mcRBHigh:RadioButton;
      
      private var _sVisualQuality:String;
      
      public var _sBtFullScr:MovieClip;
      
      public var _sBtWind:MovieClip;
      
      private var _consumer:ICGameOptionsConsumer;
      
      public var mcCheckBox:CheckBox;
      
      public var mcRBMedium:RadioButton;
      
      private var _bFullScreen:Boolean = false;
      
      public var _sBtOk:SimpleButton;
      
      public var _mcVolume2:CVolumeScroller;
      
      public var _mcVolume1:CVolumeScroller;
      
      public var _btnExit:SimpleButton;
      
      public var mcRBLow:RadioButton;
      
      public var _mcBack:MovieClip;
      
      public function CGameOptions()
      {
         super();
      }
      
      private function onVisualQualityChange(param1:CustomEvent) : void
      {
         setVisualQualityRadioBtns(String(param1.data.id));
         var _loc2_:Object = new Object();
         _loc2_.quality = String(param1.data.id);
         EventManager.getInstance().dispatchEvent(new ProjectEvent("CHANGE_VISUAL_QUALITY",_loc2_));
      }
      
      public function setParams(param1:Boolean = false, param2:Number = 0.5, param3:Number = 0.5, param4:String = "high", param5:Boolean = false) : void
      {
         _mcVolume1.setType("music");
         _mcVolume2.setType("effects");
         _mcVolume1.position = param2;
         _mcVolume2.position = param3;
         mcRBHigh.btnID = "high";
         mcRBMedium.btnID = "medium";
         mcRBLow.btnID = "low";
         setVisualQualityRadioBtns(param4);
         mcCheckBox.init(ICheckBoxHandler(this),1,param5);
      }
      
      public function init(param1:ICGameOptionsConsumer) : void
      {
         _consumer = param1;
         _mcVolume1.setConsumer(_consumer);
         _mcVolume2.setConsumer(_consumer);
         _sBtOk.addEventListener(MouseEvent.MOUSE_DOWN,mdOk,false,0,true);
         _btnExit.addEventListener(MouseEvent.MOUSE_DOWN,mdOk,false,0,true);
         mcRBHigh.addEventListener(RadioButton.ON_CLICK,onVisualQualityChange,false,0,true);
         mcRBMedium.addEventListener(RadioButton.ON_CLICK,onVisualQualityChange,false,0,true);
         mcRBLow.addEventListener(RadioButton.ON_CLICK,onVisualQualityChange,false,0,true);
         tabEnabled = false;
         tabChildren = false;
      }
      
      private function setVisualQualityRadioBtns(param1:String) : void
      {
         _sVisualQuality = param1;
         mcRBHigh.deselect();
         mcRBMedium.deselect();
         mcRBLow.deselect();
         switch(_sVisualQuality)
         {
            case "high":
               mcRBHigh.select();
               break;
            case "medium":
               mcRBMedium.select();
               break;
            case "low":
               mcRBLow.select();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<CGameOptions>>\t" + param1);
      }
      
      public function onCheckBoxClick(param1:int, param2:Boolean) : void
      {
         _consumer.handleGameOptionsToggleHelp(param2);
      }
      
      private function mdOk(param1:MouseEvent) : void
      {
         saveAndClose();
      }
      
      private function mdOnOff(param1:MouseEvent) : *
      {
         var _loc2_:String = String(param1.currentTarget.name);
         var _loc3_:Object = new Object();
         switch(_loc2_)
         {
            case "_sBtFullScr":
               _loc3_.type = "full_screen";
               _sBtFullScr.gotoAndStop("on");
               _sBtWind.gotoAndStop("off");
               break;
            case "_sBtWind":
               _loc3_.type = "windowed";
               _sBtFullScr.gotoAndStop("off");
               _sBtWind.gotoAndStop("on");
         }
         if(null != _consumer)
         {
            _consumer.handleGameOptionsChangeScreenSize(_loc3_.type);
         }
      }
      
      public function destroy() : void
      {
         _sBtOk.removeEventListener(MouseEvent.MOUSE_DOWN,mdOk);
         _btnExit.removeEventListener(MouseEvent.MOUSE_DOWN,mdOk);
         mcRBHigh.removeEventListener(RadioButton.ON_CLICK,onVisualQualityChange);
         mcRBMedium.removeEventListener(RadioButton.ON_CLICK,onVisualQualityChange);
         mcRBLow.removeEventListener(RadioButton.ON_CLICK,onVisualQualityChange);
      }
      
      public function saveAndClose() : void
      {
         var _loc1_:Number = Number(Managers.soundManager.getMusicGlobalVolume());
         var _loc2_:Number = Number(Managers.soundManager.getSoundGlobalVolume());
         StoredSettingManager.getInstance().storeSetting(StoredSetting.GAMEOPTIONS_SOUND,int(_loc2_));
         StoredSettingManager.getInstance().storeSetting(StoredSetting.GAMEOPTIONS_MUSIC,int(_loc1_));
         StoredSettingManager.getInstance().storeSetting(StoredSetting.GAMEOPTIONS_QUALITY,_sVisualQuality);
         StoredSettingManager.getInstance().storeSetting(StoredSetting.GAMEOPTIONS_HELP,Boolean(mcCheckBox.isOn));
         StoredSettingManager.getInstance().saveSettingsToDisk();
         if(null != _consumer)
         {
            _consumer.handleGameOptionsClose();
         }
      }
   }
}

