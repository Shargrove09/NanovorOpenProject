package com.arkadium.virmon.shared.final.components
{
   import caurina.transitions.Tweener;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   
   public class NickNameEditor extends MovieClip
   {
      
      public static const UPDATED:String = "NANOVOR_UPDATED";
      
      private var curBlink:int = 0;
      
      private const BTN_MODE_ENTER:String = "enter";
      
      private const BTN_TEXT_ENTER_COLOR_2:uint = 14176522;
      
      private const BTN_TEXT_ENTER:String = "ENTER";
      
      private var isFirstTextChange:Boolean = true;
      
      private const BTN_TEXT_SAVE:String = "SAVE";
      
      private var virmon:IVirmonData;
      
      private var nickName:String;
      
      private const BTN_END_X:int = 130;
      
      private const BTN_ANI_TIME:Number = 1;
      
      private const NICKNAME_URL:String = "/bankfe/resources/asset/INSTANCE_ID/miscellany?auth=";
      
      private const BTN_TEXT_EDIT:String = "CHANGE";
      
      public var tfName:TextField;
      
      private const BTN_TYPE_SAVE:String = "saveBtn";
      
      private const NAME_TEXT_ADD:String = "ADD NICKNAME";
      
      private const BTN_TEXT_EDIT_COLOR:uint = 16777215;
      
      private const BTN_START_X:int = 0;
      
      private var btnMode:String;
      
      private var isFirst:Boolean = true;
      
      private const BTN_TYPE_EDIT:String = "editBtn";
      
      public var mcEntryBtn:MovieClip;
      
      private var blinkTimer:Timer;
      
      private const BTN_TEXT_SAVE_COLOR:uint = 16777215;
      
      private const BTN_BLINK_TIME:int = 500;
      
      private const BTN_MODE_SAVE:String = "save";
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private const BTN_TYPE_ENTER:String = "enterBtn";
      
      private var nickNameAttempt:String;
      
      private var urlLoader:URLLoader;
      
      private const BTN_MODE_EDIT:String = "edit";
      
      private var dialogBox:CommonDialogBox;
      
      private var instanceID:String;
      
      private const BTN_TEXT_ENTER_COLOR_1:uint = 16777215;
      
      public function NickNameEditor(param1:IServiceRequestBrokerManager)
      {
         super();
         _serviceRequestBrokerManager = param1;
         mcEntryBtn.tfLabel.autoSize = TextFieldAutoSize.LEFT;
         tfName.maxChars = 10;
         tfName.restrict = "A-Za-z";
         blinkTimer = new Timer(BTN_BLINK_TIME,0);
         blinkTimer.addEventListener("timer",blinkTimerHandler,false,0,true);
         tfName.addEventListener(KeyboardEvent.KEY_UP,onTextChange,false,0,true);
      }
      
      private function onNickNameError(param1:IOErrorEvent) : void
      {
         log("NICKNAME SAVE ERROR: " + param1.toString());
         param1.target.removeEventListener(Event.COMPLETE,onNickNameSave);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onNickNameError);
         nickNameAttempt = "";
         var _loc2_:String = "";
         if(tfName.text.length == 0)
         {
            _loc2_ = "You cannot enter an empty nickname. Please enter a name and try again.";
         }
         else
         {
            _loc2_ = "You have entered an invalid nickname. Please try again.";
         }
         if(nickName.length == 0)
         {
            setNameField(NAME_TEXT_ADD);
            setEntryBtn(BTN_TYPE_ENTER);
         }
         else
         {
            setNameField(nickName);
            setEntryBtn(BTN_TYPE_EDIT);
         }
         dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Invalid Nickname",_loc2_,10,null,null,null,onMsgTimeOutGeneric);
      }
      
      private function animateEntryBtn() : void
      {
         mcEntryBtn.x = BTN_START_X;
         Tweener.addTween(mcEntryBtn,{
            "x":BTN_END_X,
            "time":BTN_ANI_TIME,
            "delay":1,
            "transition":"easeOutQuad",
            "onComplete":onEntryBtnAniComplete
         });
      }
      
      private function stopEntryBtnBlink() : void
      {
         blinkTimer.stop();
         mcEntryBtn.tfLabel.textColor = BTN_TEXT_ENTER_COLOR_1;
      }
      
      public function setName(param1:IVirmonData) : void
      {
         hideNameBackground();
         virmon = param1;
         nickName = virmon.getNickName().toUpperCase();
         instanceID = virmon.getAssetID();
         if(Boolean(nickName.length))
         {
            setNameField(nickName);
            setEntryBtn(BTN_TYPE_EDIT);
            setMouseListeners();
         }
         else
         {
            setEntryBtn(BTN_TYPE_ENTER);
            if(isFirst)
            {
               isFirst = false;
               setNameField("");
               animateEntryBtn();
            }
            else
            {
               setNameField(NAME_TEXT_ADD);
               startEntryBtnBlink();
            }
         }
      }
      
      private function setEntryBtn(param1:String) : void
      {
         switch(param1)
         {
            case BTN_TYPE_ENTER:
               btnMode = BTN_MODE_ENTER;
               mcEntryBtn.tfLabel.text = BTN_TEXT_ENTER;
               startEntryBtnBlink();
               break;
            case BTN_TYPE_SAVE:
               btnMode = BTN_MODE_SAVE;
               mcEntryBtn.tfLabel.text = BTN_TEXT_SAVE;
               startEntryBtnBlink();
               break;
            case BTN_TYPE_EDIT:
               btnMode = BTN_MODE_EDIT;
               mcEntryBtn.tfLabel.text = BTN_TEXT_EDIT;
         }
      }
      
      private function onTextChange(param1:KeyboardEvent) : void
      {
         var _loc2_:RegExp = null;
         if(param1.keyCode == Keyboard.ENTER)
         {
            tfName.text = tfName.text.toUpperCase();
            onClick(null);
         }
         else
         {
            _loc2_ = /\d+/g;
            tfName.text = tfName.text.replace(_loc2_,"");
            if(!tfName.background)
            {
               showNameBackground();
            }
            if(isFirstTextChange)
            {
               isFirstTextChange = false;
               setEntryBtn(BTN_TYPE_SAVE);
            }
         }
      }
      
      private function onNickNameSave(param1:Event = null) : void
      {
         if(Boolean(param1))
         {
            param1.target.removeEventListener(Event.COMPLETE,onNickNameSave);
            param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onNickNameError);
         }
         nickName = nickNameAttempt;
         virmon.setNickName(nickName);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         setEntryBtn(BTN_TYPE_EDIT);
         var _loc3_:Object = new Object();
         _loc3_.virmon = virmon;
         dispatchEvent(new CustomEvent(NickNameEditor.UPDATED,_loc3_,true));
      }
      
      private function setMouseListeners() : void
      {
         mcEntryBtn.buttonMode = true;
         mcEntryBtn.useHandCursor = true;
         mcEntryBtn.mouseEnabled = true;
         mcEntryBtn.mouseChildren = false;
         mcEntryBtn.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         tfName.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
      }
      
      private function startEntryBtnBlink() : void
      {
         blinkTimer.start();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NickNameEditor: " + param1);
      }
      
      private function saveNickName() : void
      {
         nickNameAttempt = tfName.text;
         tfName.stage.focus = null;
         var _loc1_:XML = <asset-miscellany xmlns="http://smithandtinker.com/backend/xsd/asset/asset-miscellany.xsd" id=""></asset-miscellany>;
         _loc1_.@id = instanceID;
         _loc1_.appendChild(<nickname></nickname>);
         _loc1_.child("nickname")[0] = nickNameAttempt;
         var _loc2_:String = _serviceRequestBrokerManager.bankURL;
         var _loc3_:String = _serviceRequestBrokerManager.getLoginToken();
         var _loc4_:Array = NICKNAME_URL.split("INSTANCE_ID");
         var _loc5_:String = _loc2_ + _loc4_[0] + instanceID + _loc4_[1] + _loc3_;
         var _loc6_:URLRequest = new URLRequest(_loc5_);
         _loc6_.contentType = "application/xml";
         _loc6_.data = _loc1_;
         _loc6_.method = URLRequestMethod.POST;
         urlLoader = new URLLoader();
         urlLoader.addEventListener(Event.COMPLETE,onNickNameSave);
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onNickNameError);
         urlLoader.load(_loc6_);
      }
      
      private function blinkTimerHandler(param1:TimerEvent) : void
      {
         if(curBlink % 2 == 0)
         {
            mcEntryBtn.tfLabel.textColor = BTN_TEXT_ENTER_COLOR_1;
         }
         else
         {
            mcEntryBtn.tfLabel.textColor = BTN_TEXT_ENTER_COLOR_2;
         }
         ++curBlink;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NickNameEditor: " + param1);
      }
      
      public function hide() : void
      {
         visible = false;
      }
      
      private function onMsgTimeOutGeneric(param1:Object) : void
      {
         if(Boolean(param1.callingCDB) && Boolean(param1.callingCDB as CommonDialogBox))
         {
            (param1.callingCDB as CommonDialogBox).kill();
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         switch(btnMode)
         {
            case BTN_MODE_ENTER:
               showNameBackground();
               setNameField(NAME_TEXT_ADD);
               break;
            case BTN_MODE_SAVE:
               tfName.text = tfName.text.toUpperCase();
               hideNameBackground();
               stopEntryBtnBlink();
               saveNickName();
               break;
            case BTN_MODE_EDIT:
               showNameBackground();
         }
      }
      
      private function onEntryBtnAniComplete() : void
      {
         setNameField(NAME_TEXT_ADD);
         setMouseListeners();
      }
      
      private function setNameField(param1:String) : void
      {
         tfName.text = param1;
      }
      
      private function showNameBackground() : void
      {
         isFirstTextChange = true;
         tfName.stage.focus = tfName;
         tfName.background = true;
         tfName.backgroundColor = 15438603;
         tfName.border = false;
         tfName.setSelection(0,tfName.text.length);
      }
      
      public function destroy() : void
      {
         stopEntryBtnBlink();
         blinkTimer.removeEventListener("timer",blinkTimerHandler);
         tfName.removeEventListener(KeyboardEvent.KEY_UP,onTextChange);
         mcEntryBtn.removeEventListener(MouseEvent.CLICK,onClick);
         tfName.removeEventListener(MouseEvent.CLICK,onClick);
         Tweener.removeTweens(mcEntryBtn);
      }
      
      private function hideNameBackground() : void
      {
         tfName.background = false;
      }
      
      public function show() : void
      {
         visible = true;
      }
   }
}

