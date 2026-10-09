package com.arkadium.virmon.wrapper
{
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.ExitBtn;
   import com.arkadium.virmon.soundmanager.*;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol39")]
   public class Dialog extends MovieClip
   {
      
      private const BTN_X_1:int = 433;
      
      private const BTN_X_2:int = 527;
      
      public var mcShimmer:MovieClip;
      
      private const BTN_X:int = 480;
      
      public var mcScrim:MovieClip;
      
      private const BTN_Y:int = 444;
      
      public var mcExitBtn:ExitBtn;
      
      public var txMainText:TextField;
      
      private var btnYes:DialogBtn;
      
      public var txTitle:TextField;
      
      private var btnCancel:DialogBtn;
      
      public var txSupportText:TextField;
      
      private var oData:Object;
      
      private var btnNo:DialogBtn;
      
      private var btnOK:DialogBtn;
      
      public function Dialog()
      {
         super();
         mcShimmer.stop();
         mcShimmer.visible = false;
         makeBtns();
         mcExitBtn.addEventListener("EXITBTN_CLICK",onExitClick);
      }
      
      private function onNoClick(param1:Event) : void
      {
         EventManager.getInstance().dispatchEvent(new ProjectEvent("DIALOG_CLICK_NO"));
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_AcceptNo",true,SoundManagerConst.soundApplicationDomain));
      }
      
      private function onExitClick(param1:Event) : void
      {
         EventManager.getInstance().dispatchEvent(new ProjectEvent("DIALOG_CLICK_EXIT"));
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_AcceptNo",true,SoundManagerConst.soundApplicationDomain));
      }
      
      public function show(param1:Object = null) : void
      {
         oData = param1;
         visible = true;
         mcShimmer.play();
         mcShimmer.visible = true;
         switch(oData.sType)
         {
            case CommonDialogBox.TYPE_INFO:
               txTitle.text = "INFO";
               btnOK.visible = true;
               btnOK.x = BTN_X;
               break;
            case CommonDialogBox.TYPE_CONFIRM:
               txTitle.text = "CONFIRM";
               btnYes.visible = true;
               btnYes.x = BTN_X_1;
               btnNo.visible = true;
               btnNo.x = BTN_X_2;
               break;
            case CommonDialogBox.TYPE_ALERT:
               txTitle.text = "ALERT";
               btnOK.visible = true;
               btnOK.x = BTN_X_1;
               btnCancel.visible = true;
               btnCancel.x = BTN_X_2;
               break;
            case CommonDialogBox.TYPE_WAITING:
               txTitle.text = "WAITING";
               btnCancel.visible = true;
               btnCancel.x = BTN_X;
         }
         txMainText.text = oData.sMainText;
         txSupportText.text = oData.sSupportText;
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_PopUp",true,SoundManagerConst.soundApplicationDomain));
      }
      
      public function hide() : void
      {
         visible = false;
         mcShimmer.stop();
         mcShimmer.visible = false;
         btnYes.visible = false;
         btnNo.visible = false;
         btnOK.visible = false;
         btnCancel.visible = false;
      }
      
      private function onOKClick(param1:Event) : void
      {
         EventManager.getInstance().dispatchEvent(new ProjectEvent("DIALOG_CLICK_OK"));
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_AcceptYes",true,SoundManagerConst.soundApplicationDomain));
      }
      
      private function onCancelClick(param1:Event) : void
      {
         EventManager.getInstance().dispatchEvent(new ProjectEvent("DIALOG_CLICK_CANCEL"));
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_AcceptNo",true,SoundManagerConst.soundApplicationDomain));
      }
      
      private function makeBtns() : void
      {
         btnYes = new DialogBtn("YES");
         addChild(btnYes);
         btnYes.addEventListener("DIALOGBTN_CLICK",onYesClick);
         btnYes.y = BTN_Y;
         btnNo = new DialogBtn("NO");
         addChild(btnNo);
         btnNo.addEventListener("DIALOGBTN_CLICK",onNoClick);
         btnNo.y = BTN_Y;
         btnOK = new DialogBtn("OK");
         addChild(btnOK);
         btnOK.addEventListener("DIALOGBTN_CLICK",onOKClick);
         btnOK.y = BTN_Y;
         btnCancel = new DialogBtn("CANCEL");
         addChild(btnCancel);
         btnCancel.addEventListener("DIALOGBTN_CLICK",onCancelClick);
         btnCancel.y = BTN_Y;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> Wrapper/Dialog: " + param1);
      }
      
      private function onYesClick(param1:Event) : void
      {
         EventManager.getInstance().dispatchEvent(new ProjectEvent("DIALOG_CLICK_YES"));
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_AcceptYes",true,SoundManagerConst.soundApplicationDomain));
      }
      
      private function error(param1:String) : void
      {
         DebugLog.instance.error(">> Wrapper/Dialog: " + param1);
      }
   }
}

