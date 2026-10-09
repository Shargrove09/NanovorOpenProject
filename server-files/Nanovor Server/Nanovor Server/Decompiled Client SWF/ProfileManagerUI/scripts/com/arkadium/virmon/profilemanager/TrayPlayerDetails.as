package com.arkadium.virmon.profilemanager
{
   import com.arkadium.virmon.common.UserProfile;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol276")]
   public class TrayPlayerDetails extends Sprite
   {
      
      public static const PASSWORD_CHANGE_CLICK:String = "passwordChangeClick";
      
      public var stfGamesPlayed:TextField;
      
      public var stfGamesWon:TextField;
      
      public var mcChangePassword:MovieClip;
      
      public var stfEMS:TextField;
      
      private var _btnChangePassword:SimpleButton;
      
      public var stfNMP:TextField;
      
      public var stfNanovorCount:TextField;
      
      public var stfTotalKills:TextField;
      
      public var stfEmail:TextField;
      
      public var stfScreenname:TextField;
      
      public function TrayPlayerDetails()
      {
         super();
         clearFields();
         _btnChangePassword = mcChangePassword.btnHit;
         _btnChangePassword.addEventListener(MouseEvent.ROLL_OVER,onChangePasswordRollOver,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.ROLL_OUT,onChangePasswordRollOut,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.MOUSE_DOWN,onChangePasswordDown,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.CLICK,onChangePasswordClick,false,0,true);
      }
      
      private function onChangePasswordRollOut(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("out");
      }
      
      protected function error(param1:String) : void
      {
         DebugLog.instance.error(">> PM TrayPlayerDetails: " + param1);
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> PM TrayPlayerDetails: " + param1);
      }
      
      private function onChangePasswordDown(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("down");
      }
      
      public function init() : *
      {
         var _loc1_:UserProfile = UserProfile.getInstance();
         log("init()");
         var _loc2_:Object = new Object();
         _loc2_.color = "#FFC709";
         _loc2_.fontWeight = "bold";
         var _loc3_:StyleSheet = new StyleSheet();
         _loc3_.setStyle(".orange",_loc2_);
         stfNanovorCount.styleSheet = _loc3_;
         stfScreenname.text = _loc1_.screenname;
         stfEmail.text = _loc1_.email;
         stfNMP.text = _loc1_.nmp.toString();
         stfNanovorCount.htmlText = _loc1_.nanovorCount.toString() + "/<span class=\"orange\">" + _loc1_.nanovorCountUnique.toString() + "</span>";
         stfEMS.text = _loc1_.ems.toString();
         stfGamesPlayed.text = _loc1_.gamesPlayed.toString();
         stfGamesWon.text = _loc1_.gamesWon.toString();
         stfTotalKills.text = _loc1_.totalKills.toString();
      }
      
      protected function comment(param1:String) : void
      {
         DebugLog.instance.comment(">> PM TrayPlayerDetails: " + param1);
      }
      
      private function clearFields() : void
      {
         stfScreenname.text = stfEmail.text = stfNMP.text = stfNanovorCount.text = stfEMS.text = stfGamesPlayed.text = stfGamesWon.text = stfTotalKills.text = "";
      }
      
      public function clearListeners() : *
      {
         _btnChangePassword.removeEventListener(MouseEvent.ROLL_OVER,onChangePasswordRollOver);
         _btnChangePassword.removeEventListener(MouseEvent.ROLL_OUT,onChangePasswordRollOut);
         _btnChangePassword.removeEventListener(MouseEvent.MOUSE_DOWN,onChangePasswordDown);
         _btnChangePassword.removeEventListener(MouseEvent.CLICK,onChangePasswordClick);
      }
      
      private function onChangePasswordRollOver(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("over");
      }
      
      private function onChangePasswordClick(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("over");
         dispatchEvent(new Event(PASSWORD_CHANGE_CLICK));
      }
   }
}

