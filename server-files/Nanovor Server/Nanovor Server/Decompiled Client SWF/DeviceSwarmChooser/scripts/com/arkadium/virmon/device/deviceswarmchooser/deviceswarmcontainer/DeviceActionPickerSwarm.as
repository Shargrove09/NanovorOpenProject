package com.arkadium.virmon.device.deviceswarmchooser.deviceswarmcontainer
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.substates.swarmchooser.ActionPickerSwarm;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.elements.icons.NanoscopeIcon;
   
   public class DeviceActionPickerSwarm extends ActionPickerSwarm
   {
      
      public static const NANOSCOPE_ICON_X:int = 10;
      
      public static const NANOSCOPE_ICON_Y:int = 200;
      
      public static const NANOSCOPE_ICON_SCALE:Number = 0.1;
      
      private var nanoscopeIcon:NanoscopeIcon;
      
      public function DeviceActionPickerSwarm(param1:INanovor, param2:INanovorFactory, param3:IPlayerFactory, param4:IEvoManager, param5:IBadgeManager, param6:IEMManager, param7:IUserProfile)
      {
         super(param1,param2,param3,param4,param5,param6,param7);
         createNanoscopeIcon();
      }
      
      private function createNanoscopeIcon() : void
      {
         nanoscopeIcon = new NanoscopeIcon();
         addChild(nanoscopeIcon);
         nanoscopeIcon.scaleX = nanoscopeIcon.scaleY = NANOSCOPE_ICON_SCALE;
         nanoscopeIcon.x = NANOSCOPE_ICON_X;
         nanoscopeIcon.y = this._infoWindowTitle.y;
         nanoscopeIcon.color = ColorMap.UI_GREEN_4;
      }
   }
}

