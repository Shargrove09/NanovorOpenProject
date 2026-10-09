package com.arkadium.virmon.profilemanager
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol105")]
   public class ModalGiftcardEntry extends MovieClip
   {
      
      public static const EVENT_EXIT:String = "modalGiftcardEntryExitEvent";
      
      public static const MIN_CODE_CHARS:int = 16;
      
      public static const MIN_ZIP_CHARS:int = 5;
      
      private var _mcLogoAdd:MovieClip;
      
      public var mcTransferSection:MovieClip;
      
      private var _iNCAdd:int;
      
      private var _stfCounterAdd:TextField;
      
      private var _nTweenCounterAddStart:Number;
      
      private var _mcAssetsAddedText:MovieClip;
      
      private var _stfCounterTotal:TextField;
      
      public var btnGiftcards:SimpleButton;
      
      private var _nTweenCounterAddEnd:Number;
      
      private var _nTweenCounterTotalStart:Number;
      
      private var _nTweenAssetsAddedTextEnd:Number;
      
      private var _nTweenAssetsAddedTextStart:Number;
      
      private var _btnExit:SimpleButton;
      
      private var _nTweenLogoTotalStart:Number;
      
      public var mcEntryBoxFlash:MovieClip;
      
      public var stfEntry1:TextField;
      
      public var stfEntry2:TextField;
      
      public var stfEntry3:TextField;
      
      public var stfEntry4:TextField;
      
      public var iNCSum:int;
      
      private var _nTweenBalanceTextStart:Number;
      
      public var mcSuccessSection:MovieClip;
      
      private var _mcViewNanomallBtn:MovieClip;
      
      public var mcReenterCode:MovieClip;
      
      private var _mcLogoTotal:MovieClip;
      
      private var _nTweenLogoTotalEnd:Number;
      
      private var _nTweenViewNanomallBtnEnd:Number;
      
      private var _mcViewNanomallText:MovieClip;
      
      private var _mcBalanceText:MovieClip;
      
      private var _nTweenCounterTotalEnd:Number;
      
      private var _mcCashTransferAnim:MovieClip;
      
      private var _nTweenViewNanomallTextEnd:Number;
      
      private var _nTweenViewNanomallTextStart:Number;
      
      private var _nTweenBalanceTextEnd:Number;
      
      private var _iNCInit:int;
      
      public var mcSuccessfulCode:MovieClip;
      
      public var dash1:TextField;
      
      public var dash2:TextField;
      
      public var dash3:TextField;
      
      private var _dialogBox:CommonDialogBox;
      
      public var mcExitBtn:MovieClip;
      
      private var _nTweenViewNanomallBtnStart:Number;
      
      private var _nTweenLogoAddEnd:Number;
      
      private var _nTweenLogoAddStart:Number;
      
      public var txZip:TextField;
      
      public function ModalGiftcardEntry()
      {
         super();
         setPrivateRefs();
         setTransferTweenVars();
         setSuccessTweenVars();
      }
      
      private function joinEntries() : String
      {
         return stfEntry1.text + stfEntry2.text + stfEntry3.text + stfEntry4.text;
      }
      
      private function onExitBtnRollOut(param1:MouseEvent) : void
      {
         mcExitBtn.gotoAndPlay("default");
      }
      
      public function init() : void
      {
         var _loc1_:UserProfile = UserProfile.getInstance();
         _iNCInit = _loc1_.nanocash;
         clearFields();
         initTransferPositions();
         initSuccessPositions();
         clearListeners();
         initListeners();
         enableEntry();
      }
      
      private function onMsgTimeOutGeneric(param1:Object) : void
      {
         if(Boolean(param1.callingCDB) && Boolean(param1.callingCDB as CommonDialogBox))
         {
            (param1.callingCDB as CommonDialogBox).kill();
         }
      }
      
      private function makeDialogBox(param1:String, param2:String) : void
      {
         _dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,param1,param2,10,null,null,null,onMsgTimeOutGeneric);
      }
      
      private function initListeners() : void
      {
         btnGiftcards.addEventListener(MouseEvent.CLICK,onSubmitBtnClick,false,0,true);
         _btnExit.addEventListener(MouseEvent.CLICK,onExitBtnClick,false,0,true);
         _btnExit.addEventListener(MouseEvent.ROLL_OVER,onExitBtnRollOver,false,0,true);
         _btnExit.addEventListener(MouseEvent.ROLL_OUT,onExitBtnRollOut,false,0,true);
         _btnExit.addEventListener(MouseEvent.MOUSE_DOWN,onExitBtnMouseDown,false,0,true);
         _btnExit.addEventListener(MouseEvent.MOUSE_UP,onExitBtnMouseUp,false,0,true);
         _mcViewNanomallBtn.addEventListener(MouseEvent.CLICK,onViewNanomallBtnClick,false,0,true);
         _mcViewNanomallBtn.addEventListener(MouseEvent.ROLL_OVER,onViewNanomallBtnRollOver,false,0,true);
         _mcViewNanomallBtn.addEventListener(MouseEvent.ROLL_OUT,onViewNanomallBtnRollOut,false,0,true);
      }
      
      private function onExitBtnMouseDown(param1:MouseEvent) : void
      {
         mcExitBtn.gotoAndPlay("down");
      }
      
      private function onNanoCashCodeFailed(param1:IOErrorEvent) : *
      {
         var oEvent:IOErrorEvent = param1;
         DebugLog.instance.log("onNanoCashCodeFailed");
         makeDialogBox("Unexpected Error","An unexpected error has occurred. Please try your code again.");
         try
         {
            oEvent.target.removeEventListener(Event.COMPLETE,onNanoCashCodeSuccess);
            oEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,onNanoCashCodeFailed);
         }
         catch(e:Error)
         {
         }
         onBadEntry();
      }
      
      private function onExitBtnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(EVENT_EXIT));
         mcReenterCode.keepPlaying = false;
         mcSuccessfulCode.keepPlaying = false;
      }
      
      private function setTransferTweenVars() : void
      {
         _nTweenBalanceTextEnd = _mcBalanceText.x;
         _nTweenBalanceTextStart = _mcBalanceText.x + 530;
         _nTweenCounterTotalEnd = _stfCounterTotal.x;
         _nTweenCounterTotalStart = _stfCounterTotal.x + 530;
         _nTweenLogoTotalEnd = _mcLogoTotal.x;
         _nTweenLogoTotalStart = _mcLogoTotal.x + 530;
         _nTweenCounterAddEnd = _stfCounterAdd.x;
         _nTweenCounterAddStart = _stfCounterAdd.x - 510;
         _nTweenLogoAddEnd = _mcLogoAdd.x;
         _nTweenLogoAddStart = _mcLogoAdd.x - 510;
      }
      
      private function revealButton() : void
      {
         Tweener.addTween(_mcAssetsAddedText,{
            "x":_nTweenAssetsAddedTextEnd,
            "time":0.4,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_mcViewNanomallBtn,{
            "x":_nTweenViewNanomallBtnEnd,
            "time":0.4,
            "delay":0.1,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_mcViewNanomallText,{
            "x":_nTweenViewNanomallTextEnd,
            "time":0.4,
            "delay":0.2,
            "transition":"easeOutQuart",
            "onComplete":onSuccessObjectsIn
         });
      }
      
      private function clearFields() : void
      {
         txZip.text = stfEntry1.text = stfEntry2.text = stfEntry3.text = stfEntry4.text = _stfCounterTotal.text = _stfCounterAdd.text = "";
         stfEntry1.maxChars = stfEntry2.maxChars = stfEntry3.maxChars = stfEntry4.maxChars = 4;
         stfEntry1.restrict = stfEntry2.restrict = stfEntry3.restrict = stfEntry4.restrict = "a-zA-Z0-9";
         txZip.restrict = "0-9";
         txZip.maxChars = 5;
      }
      
      private function disableEntry() : void
      {
         txZip.type = stfEntry1.type = stfEntry2.type = stfEntry3.type = stfEntry4.type = TextFieldType.DYNAMIC;
         stfEntry1.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry2.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry3.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry4.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         txZip.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         btnGiftcards.removeEventListener(MouseEvent.CLICK,onSubmitBtnClick);
      }
      
      private function onBadEntry() : void
      {
         enableEntry();
         mcReenterCode.keepPlaying = true;
         mcReenterCode.gotoAndPlay("on");
         stfEntry1.addEventListener(Event.CHANGE,onEntryTextChange,false,0,true);
         stfEntry2.addEventListener(Event.CHANGE,onEntryTextChange,false,0,true);
         stfEntry3.addEventListener(Event.CHANGE,onEntryTextChange,false,0,true);
         stfEntry4.addEventListener(Event.CHANGE,onEntryTextChange,false,0,true);
         focus();
      }
      
      private function onNanoCashCodeSuccess(param1:Event) : *
      {
         var response:XML;
         var returnCode:int;
         var oEvent:Event = param1;
         try
         {
            oEvent.target.removeEventListener(Event.COMPLETE,onNanoCashCodeSuccess);
            oEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,onNanoCashCodeFailed);
         }
         catch(e:Error)
         {
         }
         response = XML(oEvent.target.data);
         DebugLog.instance.log("onNanoCashCodeSuccess: " + response);
         returnCode = int(response.child("code"));
         DebugLog.instance.log("returnCode: " + returnCode);
         switch(returnCode)
         {
            case 0:
               EventManager.getInstance().dispatchEvent(new Event("NANOCASH_BALANCE_CHANGE"));
               EventManager.getInstance().addEventListener("NANOCASH_BALANCE_UPDATED",onGoodEntry,false,0,true);
               break;
            case 4:
               makeDialogBox("Invalid Code","The code you entered is invalid. Please try again.");
               onBadEntry();
               break;
            case 5:
               makeDialogBox("Expired Code","This code has expired.");
               onBadEntry();
               break;
            case 7:
               makeDialogBox("Expired Code","This code has been used too many times.");
               onBadEntry();
               break;
            case 8:
               makeDialogBox("Too Early","This code is not valid yet. Please try again later.");
               onBadEntry();
               break;
            case 13:
               makeDialogBox("Invalid Code","The code you entered has not been activated.");
               onBadEntry();
               break;
            default:
               makeDialogBox("Unexpected Error","An unexpected error has occurred. Please try your code again.");
               onBadEntry();
         }
      }
      
      public function clearListeners() : void
      {
         btnGiftcards.removeEventListener(MouseEvent.CLICK,onSubmitBtnClick);
         _btnExit.removeEventListener(MouseEvent.CLICK,onExitBtnClick);
         _btnExit.removeEventListener(MouseEvent.ROLL_OVER,onExitBtnRollOver);
         _btnExit.removeEventListener(MouseEvent.ROLL_OUT,onExitBtnRollOut);
         _btnExit.removeEventListener(MouseEvent.MOUSE_DOWN,onExitBtnMouseDown);
         _btnExit.removeEventListener(MouseEvent.MOUSE_UP,onExitBtnMouseUp);
         stfEntry1.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry2.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry3.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry4.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         txZip.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         _mcViewNanomallBtn.removeEventListener(MouseEvent.CLICK,onViewNanomallBtnClick);
         _mcViewNanomallBtn.removeEventListener(MouseEvent.ROLL_OVER,onViewNanomallBtnRollOver);
         _mcViewNanomallBtn.removeEventListener(MouseEvent.ROLL_OUT,onViewNanomallBtnRollOut);
         _mcViewNanomallBtn.clearListeners();
      }
      
      private function onEntryTextChange(param1:Event) : void
      {
         stfEntry1.removeEventListener(Event.CHANGE,onEntryTextChange);
         stfEntry2.removeEventListener(Event.CHANGE,onEntryTextChange);
         stfEntry3.removeEventListener(Event.CHANGE,onEntryTextChange);
         stfEntry4.removeEventListener(Event.CHANGE,onEntryTextChange);
         mcReenterCode.keepPlaying = false;
      }
      
      private function onTransferAnimComplete() : void
      {
         Tweener.addTween(_mcCashTransferAnim,{
            "alpha":0,
            "time":1,
            "transition":"easeInQuart",
            "onComplete":revealSuccessText
         });
         Tweener.addTween(_mcLogoAdd,{
            "x":_nTweenLogoAddStart,
            "time":0.4,
            "delay":1.7,
            "transition":"easeInOutQuart"
         });
         Tweener.addTween(_stfCounterAdd,{
            "x":_nTweenCounterAddStart,
            "time":0.4,
            "delay":1.8,
            "transition":"easeInOutQuart",
            "onComplete":revealButton
         });
      }
      
      private function onSubmitBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:String = joinEntries();
         if(_loc2_ == "" || _loc2_ === null || _loc2_.length < MIN_CODE_CHARS)
         {
            makeDialogBox("Code Missing","Please enter your 16-digit code and click the button.");
            return;
         }
         if(txZip.text == "" || txZip.text === null || txZip.length < MIN_ZIP_CHARS)
         {
            makeDialogBox("Zip Code Missing","Please enter your zip code and click the button.");
            return;
         }
         disableEntry();
         var _loc3_:String = Managers.serviceRequestBrokerManager.getNanoCashURL(_loc2_);
         _loc3_ += "&zip=" + escape(txZip.text);
         var _loc4_:URLLoader = new URLLoader();
         var _loc5_:URLRequest = new URLRequest(_loc3_);
         _loc4_.addEventListener(Event.COMPLETE,onNanoCashCodeSuccess,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,onNanoCashCodeFailed,false,0,true);
         _loc4_.load(_loc5_);
      }
      
      private function initTransferPositions() : void
      {
         _mcBalanceText.x = _nTweenBalanceTextStart;
         _stfCounterTotal.x = _nTweenCounterTotalStart;
         _mcLogoTotal.x = _nTweenLogoTotalStart;
         _stfCounterAdd.x = _nTweenCounterAddStart;
         _mcLogoAdd.x = _nTweenLogoAddStart;
         _mcCashTransferAnim.gotoAndStop(0);
         _mcCashTransferAnim.alpha = 0;
      }
      
      private function onExitBtnRollOver(param1:MouseEvent) : void
      {
         mcExitBtn.gotoAndPlay("over");
      }
      
      private function onGoodEntry(param1:Event) : void
      {
         EventManager.getInstance().removeEventListener("NANOCASH_BALANCE_UPDATED",onGoodEntry);
         var _loc2_:UserProfile = UserProfile.getInstance();
         iNCSum = _loc2_.nanocash;
         _iNCAdd = iNCSum - _iNCInit;
         updateCounterText();
         stfEntry1.stage.focus = stfEntry1;
         stfEntry1.setSelection(0,stfEntry1.text.length);
         Tweener.addTween(_mcLogoTotal,{
            "x":_nTweenLogoTotalEnd,
            "time":0.4,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_stfCounterTotal,{
            "x":_nTweenCounterTotalEnd,
            "time":0.4,
            "delay":0.1,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_mcBalanceText,{
            "x":_nTweenBalanceTextEnd,
            "time":0.4,
            "delay":0.2,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_stfCounterAdd,{
            "x":_nTweenCounterAddEnd,
            "time":0.4,
            "delay":0.3,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_mcLogoAdd,{
            "x":_nTweenLogoAddEnd,
            "time":0.4,
            "delay":0.4,
            "transition":"easeOutQuart",
            "onComplete":onTransferObjectsIn
         });
      }
      
      private function onTransferObjectsIn() : void
      {
         var _loc1_:Number = 3;
         Tweener.addTween(this,{
            "iNCSum":_iNCInit + _iNCAdd,
            "time":_loc1_,
            "transition":"easeInOutQuad",
            "onUpdate":updateCounterText,
            "rounded":true
         });
         _mcCashTransferAnim.alpha = 1;
         Tweener.addTween(_mcCashTransferAnim,{
            "_frame":_mcCashTransferAnim.totalFrames,
            "time":_loc1_,
            "transition":"linear",
            "onComplete":onTransferAnimComplete
         });
      }
      
      private function onSuccessObjectsIn() : void
      {
         mcExitBtn.gotoAndPlay("attention");
      }
      
      private function setPrivateRefs() : void
      {
         _btnExit = mcExitBtn.btnHit;
         _stfCounterTotal = mcTransferSection.stfCounterTotal;
         _stfCounterAdd = mcTransferSection.stfCounterAdd;
         _mcLogoTotal = mcTransferSection.mcLogoTotal;
         _mcLogoAdd = mcTransferSection.mcLogoAdd;
         _mcBalanceText = mcTransferSection.mcBalanceText;
         _mcCashTransferAnim = mcTransferSection.mcCashTransferAnim;
         _mcAssetsAddedText = mcSuccessSection.mcAssetsAddedText;
         _mcViewNanomallBtn = mcSuccessSection.mcViewNanomallBtn;
         _mcViewNanomallText = mcSuccessSection.mcViewNanomallText;
      }
      
      private function onViewNanomallBtnClick(param1:MouseEvent) : void
      {
         Managers.stateManager.setState(StateType.NANOMALL);
      }
      
      private function onExitBtnMouseUp(param1:MouseEvent) : void
      {
         mcExitBtn.gotoAndPlay("over");
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:int = 0;
         if(param1.keyCode == Keyboard.ENTER)
         {
            onSubmitBtnClick(null);
         }
         else
         {
            _loc2_ = TextField(param1.target);
            _loc3_ = int(String(param1.target.name).substr(8,1));
            if(_loc2_ != txZip)
            {
               if(_loc2_.text.length == 4)
               {
                  _loc3_++;
                  if(_loc3_ <= 4)
                  {
                     _loc2_ = this["stfEntry" + _loc3_];
                     focus(_loc2_);
                  }
                  else
                  {
                     focus(txZip);
                  }
               }
               else if(_loc2_.text.length == 0 && param1.keyCode == Keyboard.BACKSPACE)
               {
                  _loc3_--;
                  if(_loc3_ >= 1)
                  {
                     _loc2_ = this["stfEntry" + _loc3_];
                     focus(_loc2_);
                  }
               }
            }
         }
      }
      
      private function onViewNanomallBtnRollOver(param1:MouseEvent) : void
      {
         _mcViewNanomallBtn.gotoAndPlay("over");
      }
      
      private function revealSuccessText() : void
      {
         mcSuccessfulCode.keepPlaying = true;
         mcSuccessfulCode.gotoAndPlay("on");
      }
      
      private function updateCounterText() : void
      {
         _stfCounterTotal.text = Utils.IntToCommaFormat(iNCSum);
         _stfCounterAdd.text = Utils.IntToCommaFormat(_iNCAdd);
      }
      
      private function enableEntry() : void
      {
         txZip.type = stfEntry1.type = stfEntry2.type = stfEntry3.type = stfEntry4.type = TextFieldType.INPUT;
         stfEntry1.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         stfEntry2.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         stfEntry3.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         stfEntry4.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         txZip.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         btnGiftcards.addEventListener(MouseEvent.CLICK,onSubmitBtnClick,false,0,true);
      }
      
      public function focus(param1:TextField = null) : void
      {
         if(!param1)
         {
            param1 = stfEntry1;
         }
         param1.selectable = true;
         if(param1.stage != null)
         {
            param1.stage.focus = param1;
         }
         param1.setSelection(0,param1.text.length);
      }
      
      private function onViewNanomallBtnRollOut(param1:MouseEvent) : void
      {
         _mcViewNanomallBtn.gotoAndStop("up");
      }
      
      private function initSuccessPositions() : void
      {
         _mcAssetsAddedText.x = _nTweenAssetsAddedTextStart;
         _mcViewNanomallBtn.x = _nTweenViewNanomallBtnStart;
         _mcViewNanomallText.x = _nTweenViewNanomallTextStart;
      }
      
      private function setSuccessTweenVars() : void
      {
         _nTweenAssetsAddedTextEnd = _mcAssetsAddedText.x;
         _nTweenAssetsAddedTextStart = _mcAssetsAddedText.x - 600;
         _nTweenViewNanomallBtnEnd = _mcViewNanomallBtn.x;
         _nTweenViewNanomallBtnStart = _mcViewNanomallBtn.x + 530;
         _nTweenViewNanomallTextEnd = _mcViewNanomallText.x;
         _nTweenViewNanomallTextStart = _mcViewNanomallText.x - 530;
      }
      
      public function flash() : void
      {
         mcEntryBoxFlash.play();
      }
   }
}

