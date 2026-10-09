package com.arkadium.virmon.profilemanager
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.common.UserProfileEvent;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.state.StateType;
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol128")]
   public class ModalNanocodeEntry extends MovieClip
   {
      
      public static const EVENT_EXIT:String = "modalNanocodeEntryExitEvent";
      
      public static const MAX_CODE_CHARS:int = 16;
      
      public var mcEntryBoxFlash:MovieClip;
      
      public var stfEntry1:TextField;
      
      public var stfEntry2:TextField;
      
      public var stfEntry3:TextField;
      
      public var stfEntry4:TextField;
      
      private var _mcViewCollectionBtn:MovieClip;
      
      private var _mcViewCollectionText:MovieClip;
      
      private var _mcAssetsAddedText:MovieClip;
      
      public var mcSuccessSection:MovieClip;
      
      public var mcReenterCode:MovieClip;
      
      private var _nTweenViewCollectionBtnStart:Number;
      
      private var _nTweenGetMoreNanovorTextStart:Number;
      
      private var _nTweenGetMoreNanovorBtnEnd:Number;
      
      private var _nTweenGetMoreNanovorBtnStart:Number;
      
      private var _nTweenViewCollectionBtnEnd:Number;
      
      private var _mcGetMoreNanovorText:MovieClip;
      
      private var _nTweenAssetsAddedTextEnd:Number;
      
      private var _nTweenAssetsAddedTextStart:Number;
      
      private var _nTweenGetMoreNanovorTextEnd:Number;
      
      private var _btnExit:SimpleButton;
      
      public var mcSuccessfulCode:MovieClip;
      
      public var dash1:TextField;
      
      public var dash2:TextField;
      
      public var dash3:TextField;
      
      private var _dialogBox:CommonDialogBox;
      
      public var mcExitBtn:MovieClip;
      
      private var _mcGetMoreNanovorBtn:MovieClip;
      
      private var _nTweenViewCollectionTextEnd:Number;
      
      private var _nTweenViewCollectionTextStart:Number;
      
      public var btnNanocodes:SimpleButton;
      
      public function ModalNanocodeEntry()
      {
         super();
         setPrivateRefs();
         setSuccessTweenVars();
      }
      
      private function onSubmitBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:String = joinEntries();
         if(_loc2_ == "" || _loc2_ === null || _loc2_.length < MAX_CODE_CHARS)
         {
            makeDialogBox("Code Missing","Please enter your 16-digit code and click the button.");
            return;
         }
         disableEntry();
         var _loc3_:String = Managers.serviceRequestBrokerManager.getCouponURL(_loc2_);
         DebugLog.instance.log("onSubmitBtnClick - URL: " + _loc3_);
         var _loc4_:URLLoader = new URLLoader();
         var _loc5_:URLRequest = new URLRequest(_loc3_);
         _loc4_.addEventListener(Event.COMPLETE,onCouponCodeSuccess,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,onCouponCodeFailed,false,0,true);
         _loc4_.load(_loc5_);
      }
      
      private function joinEntries() : String
      {
         return stfEntry1.text + stfEntry2.text + stfEntry3.text + stfEntry4.text;
      }
      
      public function init() : void
      {
         clearFields();
         initSuccessPositions();
         clearListeners();
         initListeners();
         enableEntry();
      }
      
      private function onExitBtnRollOut(param1:MouseEvent) : void
      {
         mcExitBtn.gotoAndPlay("default");
      }
      
      private function initListeners() : void
      {
         btnNanocodes.addEventListener(MouseEvent.CLICK,onSubmitBtnClick,false,0,true);
         _btnExit.addEventListener(MouseEvent.CLICK,onExitBtnClick,false,0,true);
         _btnExit.addEventListener(MouseEvent.ROLL_OVER,onExitBtnRollOver,false,0,true);
         _btnExit.addEventListener(MouseEvent.ROLL_OUT,onExitBtnRollOut,false,0,true);
         _btnExit.addEventListener(MouseEvent.MOUSE_DOWN,onExitBtnMouseDown,false,0,true);
         _btnExit.addEventListener(MouseEvent.MOUSE_UP,onExitBtnMouseUp,false,0,true);
         _mcViewCollectionBtn.addEventListener(MouseEvent.CLICK,onViewCollectionBtnClick,false,0,true);
         _mcViewCollectionBtn.addEventListener(MouseEvent.ROLL_OVER,onViewCollectionBtnRollOver,false,0,true);
         _mcViewCollectionBtn.addEventListener(MouseEvent.ROLL_OUT,onViewCollectionBtnRollOut,false,0,true);
         _mcGetMoreNanovorBtn.addEventListener(MouseEvent.CLICK,onGetMoreNanovorBtnClick,false,0,true);
         _mcGetMoreNanovorBtn.addEventListener(MouseEvent.ROLL_OVER,onGetMoreNanovorBtnRollOver,false,0,true);
         _mcGetMoreNanovorBtn.addEventListener(MouseEvent.ROLL_OUT,onGetMoreNanovorBtnRollOut,false,0,true);
      }
      
      private function onExitBtnRollOver(param1:MouseEvent) : void
      {
         mcExitBtn.gotoAndPlay("over");
      }
      
      private function onGetMoreNanovorBtnRollOver(param1:MouseEvent) : void
      {
         _mcGetMoreNanovorBtn.gotoAndPlay("over");
      }
      
      private function onViewCollectionBtnRollOut(param1:MouseEvent) : void
      {
         _mcViewCollectionBtn.gotoAndStop("up");
      }
      
      private function setPrivateRefs() : void
      {
         _btnExit = mcExitBtn.btnHit;
         _mcAssetsAddedText = mcSuccessSection.mcAssetsAddedText;
         _mcViewCollectionBtn = mcSuccessSection.mcViewCollectionBtn;
         _mcViewCollectionText = mcSuccessSection.mcViewCollectionText;
         _mcGetMoreNanovorBtn = mcSuccessSection.mcGetMoreNanovorBtn;
         _mcGetMoreNanovorText = mcSuccessSection.mcGetMoreNanovorText;
      }
      
      private function setSuccessTweenVars() : void
      {
         _nTweenAssetsAddedTextEnd = _mcAssetsAddedText.x;
         _nTweenAssetsAddedTextStart = _mcAssetsAddedText.x - 600;
         _nTweenViewCollectionBtnEnd = _mcViewCollectionBtn.x;
         _nTweenViewCollectionBtnStart = _mcViewCollectionBtn.x + 530;
         _nTweenViewCollectionTextEnd = _mcViewCollectionText.x;
         _nTweenViewCollectionTextStart = _mcViewCollectionText.x - 530;
         _nTweenGetMoreNanovorBtnEnd = _mcGetMoreNanovorBtn.x;
         _nTweenGetMoreNanovorBtnStart = _mcGetMoreNanovorBtn.x + 530;
         _nTweenGetMoreNanovorTextEnd = _mcGetMoreNanovorText.x;
         _nTweenGetMoreNanovorTextStart = _mcGetMoreNanovorText.x - 530;
      }
      
      private function makeDialogBox(param1:String, param2:String) : void
      {
         _dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,param1,param2,10,null,null,null,onMsgTimeOutGeneric);
      }
      
      private function onUserProfileReload(param1:Event) : void
      {
         UserProfile.getInstance().removeEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUserProfileReload);
         DebugLog.instance.log(">> PM >> ModalNanocodeEntry: onUserProfileReload");
         onGoodEntry();
      }
      
      private function onViewCollectionBtnClick(param1:MouseEvent) : void
      {
         Managers.stateManager.setState(StateType.COLLECTION);
      }
      
      private function onMsgTimeOutGeneric(param1:Object) : void
      {
         if(Boolean(param1.callingCDB) && Boolean(param1.callingCDB as CommonDialogBox))
         {
            (param1.callingCDB as CommonDialogBox).kill();
         }
      }
      
      private function onViewCollectionBtnRollOver(param1:MouseEvent) : void
      {
         _mcViewCollectionBtn.gotoAndPlay("over");
      }
      
      private function onSuccessObjectsIn() : void
      {
         mcExitBtn.gotoAndPlay("attention");
      }
      
      private function onGoodEntry() : void
      {
         stfEntry1.stage.focus = stfEntry1;
         stfEntry1.setSelection(0,stfEntry1.text.length);
         mcSuccessfulCode.keepPlaying = true;
         mcSuccessfulCode.gotoAndPlay("on");
         Tweener.addTween(_mcAssetsAddedText,{
            "x":_nTweenAssetsAddedTextEnd,
            "time":0.4,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_mcViewCollectionBtn,{
            "x":_nTweenViewCollectionBtnEnd,
            "time":0.4,
            "delay":0.1,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_mcViewCollectionText,{
            "x":_nTweenViewCollectionTextEnd,
            "time":0.4,
            "delay":0.2,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_mcGetMoreNanovorBtn,{
            "x":_nTweenGetMoreNanovorBtnEnd,
            "time":0.4,
            "delay":0.3,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(_mcGetMoreNanovorText,{
            "x":_nTweenGetMoreNanovorTextEnd,
            "time":0.4,
            "delay":0.4,
            "transition":"easeOutQuart",
            "onComplete":onSuccessObjectsIn
         });
      }
      
      private function onExitBtnMouseDown(param1:MouseEvent) : void
      {
         mcExitBtn.gotoAndPlay("down");
      }
      
      private function onCouponCodeSuccess(param1:Event) : *
      {
         var response:XML;
         var returnCode:int;
         var oEvent:Event = param1;
         try
         {
            oEvent.target.removeEventListener(Event.COMPLETE,onCouponCodeSuccess);
            oEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,onCouponCodeFailed);
         }
         catch(e:Error)
         {
         }
         response = XML(oEvent.target.data);
         DebugLog.instance.log("onCouponCodeSuccess: " + response);
         returnCode = int(response.child("code"));
         switch(returnCode)
         {
            case 0:
               DataManager.getInstance().refreshData();
               EventManager.getInstance().dispatchEvent(new Event("NANOCASH_BALANCE_CHANGE"));
               onGoodEntry();
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
            default:
               makeDialogBox("Unexpected Error","An unexpected error has occurred. Please try your code again.");
               onBadEntry();
         }
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
            if(_loc2_.text.length == 4)
            {
               _loc3_++;
               if(_loc3_ <= 4)
               {
                  focus(_loc3_);
               }
            }
            else if(_loc2_.text.length == 0 && param1.keyCode == Keyboard.BACKSPACE)
            {
               _loc3_--;
               if(_loc3_ >= 1)
               {
                  focus(_loc3_);
               }
            }
         }
      }
      
      private function onGetMoreNanovorBtnRollOut(param1:MouseEvent) : void
      {
         _mcGetMoreNanovorBtn.gotoAndStop("up");
      }
      
      private function onExitBtnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(EVENT_EXIT));
         mcSuccessfulCode.keepPlaying = false;
         mcReenterCode.keepPlaying = false;
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         var szData:String = null;
         var e:IOErrorEvent = param1;
         try
         {
            szData = e.target.data as String;
         }
         catch(err:Error)
         {
            szData = "[NO DATA]";
         }
         DebugLog.instance.error(">> PM >> ModalNanocodeEntry: onIOError...\n" + szData);
         onBadEntry();
      }
      
      private function onGetMoreNanovorBtnClick(param1:MouseEvent) : void
      {
         Managers.stateManager.setState(StateType.NANOMALL);
      }
      
      private function onCouponCodeFailed(param1:IOErrorEvent) : *
      {
         var oEvent:IOErrorEvent = param1;
         DebugLog.instance.log("onCouponCodeFailed");
         makeDialogBox("Unexpected Error","An unexpected error has occurred. Please try your code again.");
         try
         {
            oEvent.target.removeEventListener(Event.COMPLETE,onCouponCodeSuccess);
            oEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,onCouponCodeFailed);
         }
         catch(e:Error)
         {
         }
         onBadEntry();
      }
      
      private function enableEntry() : void
      {
         stfEntry1.type = stfEntry2.type = stfEntry3.type = stfEntry4.type = TextFieldType.INPUT;
         stfEntry1.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         stfEntry2.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         stfEntry3.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         stfEntry4.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         btnNanocodes.addEventListener(MouseEvent.CLICK,onSubmitBtnClick,false,0,true);
      }
      
      private function initSuccessPositions() : void
      {
         _mcAssetsAddedText.x = _nTweenAssetsAddedTextStart;
         _mcViewCollectionBtn.x = _nTweenViewCollectionBtnStart;
         _mcViewCollectionText.x = _nTweenViewCollectionTextStart;
         _mcGetMoreNanovorBtn.x = _nTweenGetMoreNanovorBtnStart;
         _mcGetMoreNanovorText.x = _nTweenGetMoreNanovorTextStart;
      }
      
      private function clearFields() : void
      {
         stfEntry1.text = stfEntry2.text = stfEntry3.text = stfEntry4.text = "";
         stfEntry1.maxChars = stfEntry2.maxChars = stfEntry3.maxChars = stfEntry4.maxChars = 4;
         stfEntry1.restrict = stfEntry2.restrict = stfEntry3.restrict = stfEntry4.restrict = "a-zA-Z0-9";
      }
      
      public function focus(param1:int = 1) : void
      {
         this["stfEntry" + param1].selectable = true;
         if(this["stfEntry" + param1].stage != null)
         {
            this["stfEntry" + param1].stage.focus = this["stfEntry" + param1];
         }
         this["stfEntry" + param1].setSelection(0,this["stfEntry" + param1].text.length);
      }
      
      public function flash() : void
      {
         mcEntryBoxFlash.play();
      }
      
      private function disableEntry() : void
      {
         stfEntry1.type = stfEntry2.type = stfEntry3.type = stfEntry4.type = TextFieldType.DYNAMIC;
         stfEntry1.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry2.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry3.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry4.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         btnNanocodes.removeEventListener(MouseEvent.CLICK,onSubmitBtnClick);
      }
      
      public function clearListeners() : void
      {
         btnNanocodes.removeEventListener(MouseEvent.CLICK,onSubmitBtnClick);
         _btnExit.removeEventListener(MouseEvent.CLICK,onExitBtnClick);
         _btnExit.removeEventListener(MouseEvent.ROLL_OVER,onExitBtnRollOver);
         _btnExit.removeEventListener(MouseEvent.ROLL_OUT,onExitBtnRollOut);
         _btnExit.removeEventListener(MouseEvent.MOUSE_DOWN,onExitBtnMouseDown);
         _btnExit.removeEventListener(MouseEvent.MOUSE_UP,onExitBtnMouseUp);
         stfEntry1.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry2.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry3.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         stfEntry4.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         _mcViewCollectionBtn.removeEventListener(MouseEvent.CLICK,onViewCollectionBtnClick);
         _mcViewCollectionBtn.removeEventListener(MouseEvent.ROLL_OVER,onViewCollectionBtnRollOver);
         _mcViewCollectionBtn.removeEventListener(MouseEvent.ROLL_OUT,onViewCollectionBtnRollOut);
         _mcViewCollectionBtn.clearListeners();
         _mcGetMoreNanovorBtn.removeEventListener(MouseEvent.CLICK,onGetMoreNanovorBtnClick);
         _mcGetMoreNanovorBtn.removeEventListener(MouseEvent.ROLL_OVER,onGetMoreNanovorBtnRollOver);
         _mcGetMoreNanovorBtn.removeEventListener(MouseEvent.ROLL_OUT,onGetMoreNanovorBtnRollOut);
         _mcGetMoreNanovorBtn.clearListeners();
      }
      
      private function onEntryTextChange(param1:Event) : void
      {
         stfEntry1.removeEventListener(Event.CHANGE,onEntryTextChange);
         stfEntry2.removeEventListener(Event.CHANGE,onEntryTextChange);
         stfEntry3.removeEventListener(Event.CHANGE,onEntryTextChange);
         stfEntry4.removeEventListener(Event.CHANGE,onEntryTextChange);
         mcReenterCode.keepPlaying = false;
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
   }
}

