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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol498")]
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
         this._serviceRequestBrokerManager = param1;
         this.mcEntryBtn.tfLabel.autoSize = TextFieldAutoSize.LEFT;
         this.tfName.maxChars = 10;
         this.tfName.restrict = "A-Za-z";
         this.blinkTimer = new Timer(this.BTN_BLINK_TIME,0);
         this.blinkTimer.addEventListener("timer",this.blinkTimerHandler,false,0,true);
         this.tfName.addEventListener(KeyboardEvent.KEY_UP,this.onTextChange,false,0,true);
      }
      
      private function onNickNameError(param1:IOErrorEvent) : void
      {
         this.log("NICKNAME SAVE ERROR: " + param1.toString());
         param1.target.removeEventListener(Event.COMPLETE,this.onNickNameSave);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onNickNameError);
         this.nickNameAttempt = "";
         var _loc2_:String = "";
         if(this.tfName.text.length == 0)
         {
            _loc2_ = "You cannot enter an empty nickname. Please enter a name and try again.";
         }
         else
         {
            _loc2_ = "You have entered an invalid nickname. Please try again.";
         }
         if(this.nickName.length == 0)
         {
            this.setNameField(this.NAME_TEXT_ADD);
            this.setEntryBtn(this.BTN_TYPE_ENTER);
         }
         else
         {
            this.setNameField(this.nickName);
            this.setEntryBtn(this.BTN_TYPE_EDIT);
         }
         this.dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Invalid Nickname",_loc2_,10,null,null,null,this.onMsgTimeOutGeneric);
      }
      
      private function animateEntryBtn() : void
      {
         this.mcEntryBtn.x = this.BTN_START_X;
         Tweener.addTween(this.mcEntryBtn,{
            "x":this.BTN_END_X,
            "time":this.BTN_ANI_TIME,
            "delay":1,
            "transition":"easeOutQuad",
            "onComplete":this.onEntryBtnAniComplete
         });
      }
      
      private function stopEntryBtnBlink() : void
      {
         this.blinkTimer.stop();
         this.mcEntryBtn.tfLabel.textColor = this.BTN_TEXT_ENTER_COLOR_1;
      }
      
      public function setName(param1:IVirmonData) : void
      {
         this.hideNameBackground();
         this.virmon = param1;
         this.nickName = this.virmon.getNickName().toUpperCase();
         this.instanceID = this.virmon.getAssetID();
         if(Boolean(this.nickName.length))
         {
            this.setNameField(this.nickName);
            this.setEntryBtn(this.BTN_TYPE_EDIT);
            this.setMouseListeners();
         }
         else
         {
            this.setEntryBtn(this.BTN_TYPE_ENTER);
            if(this.isFirst)
            {
               this.isFirst = false;
               this.setNameField("");
               this.animateEntryBtn();
            }
            else
            {
               this.setNameField(this.NAME_TEXT_ADD);
               this.startEntryBtnBlink();
            }
         }
      }
      
      private function setEntryBtn(param1:String) : void
      {
         switch(param1)
         {
            case this.BTN_TYPE_ENTER:
               this.btnMode = this.BTN_MODE_ENTER;
               this.mcEntryBtn.tfLabel.text = this.BTN_TEXT_ENTER;
               this.startEntryBtnBlink();
               break;
            case this.BTN_TYPE_SAVE:
               this.btnMode = this.BTN_MODE_SAVE;
               this.mcEntryBtn.tfLabel.text = this.BTN_TEXT_SAVE;
               this.startEntryBtnBlink();
               break;
            case this.BTN_TYPE_EDIT:
               this.btnMode = this.BTN_MODE_EDIT;
               this.mcEntryBtn.tfLabel.text = this.BTN_TEXT_EDIT;
         }
      }
      
      private function onTextChange(param1:KeyboardEvent) : void
      {
         var _loc2_:RegExp = null;
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.tfName.text = this.tfName.text.toUpperCase();
            this.onClick(null);
         }
         else
         {
            _loc2_ = /\d+/g;
            this.tfName.text = this.tfName.text.replace(_loc2_,"");
            if(!this.tfName.background)
            {
               this.showNameBackground();
            }
            if(this.isFirstTextChange)
            {
               this.isFirstTextChange = false;
               this.setEntryBtn(this.BTN_TYPE_SAVE);
            }
         }
      }
      
      private function onNickNameSave(param1:Event = null) : void
      {
         if(Boolean(param1))
         {
            param1.target.removeEventListener(Event.COMPLETE,this.onNickNameSave);
            param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onNickNameError);
         }
         this.nickName = this.nickNameAttempt;
         this.virmon.setNickName(this.nickName);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         this.setEntryBtn(this.BTN_TYPE_EDIT);
         var _loc3_:Object = new Object();
         _loc3_.virmon = this.virmon;
         dispatchEvent(new CustomEvent(NickNameEditor.UPDATED,_loc3_,true));
      }
      
      private function setMouseListeners() : void
      {
         this.mcEntryBtn.buttonMode = true;
         this.mcEntryBtn.useHandCursor = true;
         this.mcEntryBtn.mouseEnabled = true;
         this.mcEntryBtn.mouseChildren = false;
         this.mcEntryBtn.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.tfName.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
      }
      
      private function startEntryBtnBlink() : void
      {
         this.blinkTimer.start();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NickNameEditor: " + param1);
      }
      
      private function saveNickName() : void
      {
         this.nickNameAttempt = this.tfName.text;
         this.tfName.stage.focus = null;
         var _loc1_:XML = <asset-miscellany xmlns="http://smithandtinker.com/backend/xsd/asset/asset-miscellany.xsd" id=""></asset-miscellany>;
         _loc1_.@id = this.instanceID;
         _loc1_.appendChild(<nickname></nickname>);
         _loc1_.child("nickname")[0] = this.nickNameAttempt;
         var _loc2_:String = this._serviceRequestBrokerManager.bankURL;
         var _loc3_:String = this._serviceRequestBrokerManager.getLoginToken();
         var _loc4_:Array = this.NICKNAME_URL.split("INSTANCE_ID");
         var _loc5_:String = _loc2_ + _loc4_[0] + this.instanceID + _loc4_[1] + _loc3_;
         var _loc6_:URLRequest = new URLRequest(_loc5_);
         _loc6_.contentType = "application/xml";
         _loc6_.data = _loc1_;
         _loc6_.method = URLRequestMethod.POST;
         this.urlLoader = new URLLoader();
         this.urlLoader.addEventListener(Event.COMPLETE,this.onNickNameSave);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onNickNameError);
         this.urlLoader.load(_loc6_);
      }
      
      private function blinkTimerHandler(param1:TimerEvent) : void
      {
         if(this.curBlink % 2 == 0)
         {
            this.mcEntryBtn.tfLabel.textColor = this.BTN_TEXT_ENTER_COLOR_1;
         }
         else
         {
            this.mcEntryBtn.tfLabel.textColor = this.BTN_TEXT_ENTER_COLOR_2;
         }
         ++this.curBlink;
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
         switch(this.btnMode)
         {
            case this.BTN_MODE_ENTER:
               this.showNameBackground();
               this.setNameField(this.NAME_TEXT_ADD);
               break;
            case this.BTN_MODE_SAVE:
               this.tfName.text = this.tfName.text.toUpperCase();
               this.hideNameBackground();
               this.stopEntryBtnBlink();
               this.saveNickName();
               break;
            case this.BTN_MODE_EDIT:
               this.showNameBackground();
         }
      }
      
      private function onEntryBtnAniComplete() : void
      {
         this.setNameField(this.NAME_TEXT_ADD);
         this.setMouseListeners();
      }
      
      private function setNameField(param1:String) : void
      {
         this.tfName.text = param1;
      }
      
      private function showNameBackground() : void
      {
         this.isFirstTextChange = true;
         this.tfName.stage.focus = this.tfName;
         this.tfName.background = true;
         this.tfName.backgroundColor = 15438603;
         this.tfName.border = false;
         this.tfName.setSelection(0,this.tfName.text.length);
      }
      
      public function destroy() : void
      {
         this.stopEntryBtnBlink();
         this.blinkTimer.removeEventListener("timer",this.blinkTimerHandler);
         this.tfName.removeEventListener(KeyboardEvent.KEY_UP,this.onTextChange);
         this.mcEntryBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.tfName.removeEventListener(MouseEvent.CLICK,this.onClick);
         Tweener.removeTweens(this.mcEntryBtn);
      }
      
      private function hideNameBackground() : void
      {
         this.tfName.background = false;
      }
      
      public function show() : void
      {
         visible = true;
      }
   }
}

