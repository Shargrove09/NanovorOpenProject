package com.arkadium.virmon.shared.widgets.megawidget
{
   public class MegaWidgetPendingInvite
   {
      
      public var playerName:String;
      
      public var secondsLeft:Number;
      
      public var avatarSpinner:MegaWidgetAvatarSpinner;
      
      public function MegaWidgetPendingInvite(param1:String = "", param2:Number = 0, param3:MegaWidgetAvatarSpinner = null)
      {
         super();
         this.playerName = param1;
         this.avatarSpinner = param3;
         this.secondsLeft = param2;
      }
   }
}

