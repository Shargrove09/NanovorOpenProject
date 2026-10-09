package com.smithandtinker.nanovor.debug
{
   import caurina.transitions.Tweener;
   import caurina.transitions.properties.ColorShortcuts;
   import caurina.transitions.properties.DisplayShortcuts;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.*;
   import flash.net.LocalConnection;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class DebugLogWindow extends MovieClip implements IDebugLogWindow
   {
      
      protected static const CONNECTION_NAME:String = "DebugLog";
      
      protected static const FILTER_CONNECTION_NAME:String = "DebugLogFilterChannel";
      
      private static const _TIME_SORTING:Boolean = true;
      
      private static const _SHOW_TIME_DEFAULT:Boolean = true;
      
      private static const _ALL_CLIENT_FILTER_KEY:String = "NAM-EHT-SI-AREHCTUK-DRAHCIR";
      
      private var _aErrorLog:Array;
      
      protected var _allLogHitClip:MovieClip;
      
      private var _lastDateFormatted:Number = 0;
      
      private var _mcClientFilterBG:MovieClip;
      
      private var _filterSenders:Dictionary;
      
      private var _breakThreshold:int;
      
      private var _aAllLog:Array;
      
      protected var __lcReceiver:LocalConnection;
      
      private var _errorLabel:TextField;
      
      private var _txtBreaks:TextField;
      
      private var _bShowTime:Boolean = true;
      
      public var mcMainMenu:MovieClip;
      
      public var txt:TextField;
      
      private var _txtClientFilter:TextField;
      
      private var _errorLog:String;
      
      private var _bClientFilterTextChange:Boolean;
      
      private var _errorCount:int;
      
      protected var _currentLogAllClip:MovieClip;
      
      protected var _errorLogHitClip:MovieClip;
      
      private var _txtFilter:TextField;
      
      protected var _showingAllLogs:Boolean;
      
      private var _lcPollingConnection:LocalConnection;
      
      private var _longLogBuffer:Array;
      
      private var _btnTimestamps:SimpleButton;
      
      protected var _currentLogErrorsClip:MovieClip;
      
      private var _emptyArray:Array;
      
      private var _mcClientFilterList:MovieClip;
      
      protected var __lcFilterReceiver:LocalConnection;
      
      private var _txtTimestampsSetting:TextField;
      
      private var _txtLines:TextField;
      
      private var _currentAllClientFilter:String = "";
      
      private var _mcClientFilterLabel:MovieClip;
      
      private var _bClientFilterListOpened:Boolean = false;
      
      private var _clientListItems:Array;
      
      public function DebugLogWindow()
      {
         _filterSenders = new Dictionary();
         _clientListItems = new Array();
         _longLogBuffer = new Array();
         _emptyArray = [];
         super();
         addFrameScript(0,frame1);
         ColorShortcuts.init();
         DisplayShortcuts.init();
         __lcReceiver = new LocalConnection();
         __lcFilterReceiver = new LocalConnection();
         __lcReceiver.addEventListener(StatusEvent.STATUS,handleNothing);
         __lcReceiver.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleNothing);
         __lcReceiver.addEventListener(AsyncErrorEvent.ASYNC_ERROR,handleNothing);
         __lcFilterReceiver.addEventListener(StatusEvent.STATUS,handleNothing);
         __lcFilterReceiver.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleNothing);
         __lcFilterReceiver.addEventListener(AsyncErrorEvent.ASYNC_ERROR,handleNothing);
         try
         {
            __lcReceiver.connect(CONNECTION_NAME);
            __lcFilterReceiver.connect(FILTER_CONNECTION_NAME);
         }
         catch(e:Error)
         {
            txt.text = " ______ _____  _____   ____  _____  \n|  ____|  __ \\|  __ \\ / __ \\|  __ \\ \n| |__  | |__) | |__) | |  | | |__) |\n|  __| |  _  /|  _  /| |  | |  _  / \n| |____| | \\ \\| | \\ \\| |__| | | \\ \\ \n|______|_|  \\_\\_|  \\_\\\\____/|_|  \\_\\" + "\n\nYou cannot have multiple DebugLog windows open at the same time!" + "\n\nPlease close and try again." + "\n\n\n[" + e.getStackTrace() + "]";
            mouseEnabled = false;
            mouseChildren = false;
            while(mcMainMenu.numChildren > 1)
            {
               mcMainMenu.removeChildAt(mcMainMenu.numChildren - 1);
            }
            Tweener.addTween(mcMainMenu.purp,{
               "_color":10027008,
               "time":1,
               "delay":3,
               "transition":"linear"
            });
            Tweener.addTween(txt,{
               "_color":10027008,
               "time":1,
               "delay":3,
               "transition":"linear"
            });
            return;
         }
         __lcReceiver.client = this;
         __lcFilterReceiver.client = this;
         _currentLogAllClip = mcMainMenu._currentLogAllClip;
         _currentLogErrorsClip = mcMainMenu._currentLogErrorsClip;
         _errorLabel = mcMainMenu._errorLabel;
         _allLogHitClip = mcMainMenu._allLogHitClip;
         _errorLogHitClip = mcMainMenu._errorLogHitClip;
         _txtFilter = mcMainMenu.txtFilter;
         _txtLines = mcMainMenu.txtLines;
         _txtBreaks = mcMainMenu.txtBreaks;
         _txtTimestampsSetting = mcMainMenu.txtTimestampsSetting;
         _txtTimestampsSetting.mouseEnabled = false;
         _btnTimestamps = mcMainMenu.btnTimestamps;
         _updateTimestampSettingText();
         _mcClientFilterLabel = mcMainMenu.mcClientFilterLabel;
         _txtClientFilter = mcMainMenu.txtClientFilter;
         _mcClientFilterBG = mcMainMenu.mcClientFilterBG;
         _mcClientFilterList = mcMainMenu.mcClientFilterList;
         _mcClientFilterList.visible = false;
         _mcClientFilterList.scaleX = 0;
         _mcClientFilterList.scaleY = 0;
         updateClientFilterList();
         _txtClientFilter.addEventListener(FocusEvent.FOCUS_IN,onTxtClientFilterFocusIn);
         _txtClientFilter.addEventListener(FocusEvent.FOCUS_OUT,onTxtClientFilterFocusOut);
         _txtClientFilter.addEventListener(Event.CHANGE,onTxtClientFilterChange);
         _txtLines.restrict = "0-9";
         _txtBreaks.restrict = "0-9";
         _breakThreshold = 0;
         _btnTimestamps.addEventListener(MouseEvent.CLICK,_onBtnTimestampsClick);
         _btnTimestamps.addEventListener(MouseEvent.ROLL_OVER,_onBtnTimestampsOver);
         _btnTimestamps.addEventListener(MouseEvent.ROLL_OUT,_onBtnTimestampsOut);
         _allLogHitClip.addEventListener(MouseEvent.CLICK,_allLogClickHandler);
         _errorLogHitClip.addEventListener(MouseEvent.CLICK,_errorLogClickHandler);
         _txtFilter.addEventListener(Event.CHANGE,_filterChangeHandler);
         _txtLines.addEventListener(Event.CHANGE,_linesChangeHandler);
         _txtBreaks.addEventListener(Event.CHANGE,_breaksChangeHandler);
         _allLogHitClip.buttonMode = true;
         _errorLogHitClip.buttonMode = true;
         _aAllLog = new Array();
         _aErrorLog = new Array();
         _errorCount = 0;
         _showAllLogs();
         mcMainMenu.btnClear.addEventListener(MouseEvent.CLICK,_buttonClearClickHandler);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         onStageResize(null);
         stage.addEventListener(Event.RESIZE,onStageResize);
         log("--------------------------------------------------------------------------------------------------------------");
         log("DebugLog Window Loaded...");
         log("--------------------------------------------------------------------------------------------------------------");
         pollAndRegisterOpenClients();
      }
      
      private function onTxtClientFilterAnyEvent(param1:Event) : void
      {
         log(" $$$$ onTxtClientFilterAnyEvent: " + param1);
      }
      
      private function pollAndRegisterOpenClients() : void
      {
         var i:int;
         var key:String = null;
         var LIMIT:int = 6;
         _lcPollingConnection = new LocalConnection();
         _lcPollingConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onPollingConnectionEvent,false,0,true);
         _lcPollingConnection.addEventListener(StatusEvent.STATUS,onPollingConnectionEvent,false,0,true);
         _lcPollingConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onPollingConnectionEvent,false,0,true);
         i = 1;
         while(i <= LIMIT)
         {
            key = DebugFilterReceiver.FILTER_CONNECTION_KEY_BASE + i;
            if(_filterSenders[key] == null)
            {
               try
               {
                  _lcPollingConnection.send(key,"registerFromPoll");
               }
               catch(e:*)
               {
               }
            }
            i++;
         }
      }
      
      public function error(param1:String = "", param2:Number = -1, param3:int = -1) : void
      {
         if(param2 == -1)
         {
            param2 = Number(new Date().getTime());
         }
         _aErrorLog.push({
            "n":param2,
            "i":param3,
            "t":param1
         });
         _aAllLog.push({
            "n":param2,
            "i":param3,
            "t":param1
         });
         ++_errorCount;
         _updateText();
      }
      
      public function registerFilterReceiver(param1:String, param2:String, param3:String = "") : void
      {
         if(param1 == _ALL_CLIENT_FILTER_KEY)
         {
            error("(((( client attempted to set filter receiver key to reserved key name for all clients ))))");
            return;
         }
         var _loc4_:DebugFilterSender = new DebugFilterSender(param1,param2,IDebugLogWindow(this),param3);
         _filterSenders[param1] = _loc4_;
         log("))))))))) registered Client: \'" + _loc4_.displayName + "\'" + (param3 == " " ? "" : ", which has a filter: \'" + param3 + "\' ") + "(((((((((");
         if(param3 == "")
         {
            _loc4_.sendFilter(_currentAllClientFilter);
         }
         _loc4_.onClientRegistered();
         updateClientFilterList();
      }
      
      private function onStageResize(param1:Event) : void
      {
         var _loc2_:int = stage.stageWidth;
         var _loc3_:int = stage.stageHeight < 60 ? 60 : stage.stageHeight;
         mcMainMenu.purp.width = _loc2_;
         txt.width = _loc2_;
         txt.height = _loc3_ - 50;
      }
      
      protected function _filterChangeHandler(param1:Event) : void
      {
         _updateText();
      }
      
      private function _onBtnTimestampsOver(param1:MouseEvent) : void
      {
         _txtTimestampsSetting.textColor = 10027008;
      }
      
      protected function _updateText() : void
      {
         var _loc1_:Array = null;
         if(_showingAllLogs)
         {
            _loc1_ = _aAllLog;
         }
         else
         {
            _loc1_ = _aErrorLog;
         }
         _filterText(_loc1_);
         if(_errorCount > 0)
         {
            _errorLabel.text = "Errors (" + _errorCount + ")";
         }
         else
         {
            _errorLabel.text = "Errors";
         }
      }
      
      protected function _buttonClearClickHandler(param1:MouseEvent) : void
      {
         clear();
      }
      
      private function _getTimestampPrefixedString(param1:String, param2:Number, param3:int) : String
      {
         var _loc4_:Boolean = _breakThreshold != 0 && _lastDateFormatted - param2 > _breakThreshold;
         var _loc5_:String = _loc4_ ? "#" : "|";
         var _loc6_:Date = new Date(param2);
         var _loc7_:String = _loc6_.toLocaleTimeString().substr(0,8) + "." + param2.toString().substr(-3);
         var _loc8_:String = _loc7_ + _loc5_ + param3 + " ";
         param1 = _loc8_ + param1.replace(/[\n\r]/g,"\n" + _getSpaces(_loc8_.length));
         if(_loc4_)
         {
            param1 = "..........................................................................................................................................\n" + param1;
         }
         _lastDateFormatted = param2;
         return param1;
      }
      
      private function get _isClientFilterSenderRegistered() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:* = _filterSenders;
         for(_loc1_ in _loc3_)
         {
            return true;
         }
         return false;
      }
      
      public function log(param1:String = "", param2:Number = -1, param3:int = -1) : void
      {
         if(param2 == -1)
         {
            param2 = Number(new Date().getTime());
         }
         var _loc4_:int = checkSplitLogId(param1);
         if(_loc4_ == -1)
         {
            _aAllLog.push({
               "n":param2,
               "i":param3,
               "t":param1
            });
            _updateText();
            return;
         }
         var _loc5_:Object = processLongLog(_loc4_,param1,param2,param3);
         if(_loc5_ == null)
         {
            return;
         }
         _aAllLog.push(_loc5_);
         _updateText();
      }
      
      private function onTxtClientFilterFocusOut(param1:FocusEvent) : void
      {
         closeClientFilterList();
      }
      
      public function clear() : void
      {
         _aAllLog = new Array();
         _aErrorLog = new Array();
         error("Cleared...");
         _errorCount = 0;
         _updateText();
      }
      
      private function updateClientFilterList() : void
      {
         var _loc1_:ClientListItemElement = null;
         var _loc2_:DebugFilterSender = null;
         Tweener.removeTweens(_mcClientFilterLabel);
         Tweener.addTween(_mcClientFilterLabel,{
            "alpha":(_isClientFilterSenderRegistered ? 1 : 0.6),
            "time":1
         });
         while(Boolean(_mcClientFilterList.numChildren))
         {
            _mcClientFilterList.removeChildAt(0);
         }
         while(Boolean(_clientListItems.length))
         {
            _loc1_ = _clientListItems.shift();
            _loc1_.btnHit.removeEventListener(MouseEvent.CLICK,onClientListItemClick);
            _loc1_.btnHit.removeEventListener(MouseEvent.ROLL_OVER,onClientListItemRollOver);
            _loc1_.btnHit.removeEventListener(MouseEvent.ROLL_OUT,onClientListItemRollOut);
         }
         _clientListItems.push(new ClientListItemElement(_ALL_CLIENT_FILTER_KEY,"[ALL CLIENTS]",_currentAllClientFilter));
         for each(_loc2_ in _filterSenders)
         {
            _clientListItems.push(new ClientListItemElement(_loc2_.key,_loc2_.displayName,_loc2_.currentFilter));
         }
         for each(_loc1_ in _clientListItems)
         {
            _loc1_.btnHit.addEventListener(MouseEvent.CLICK,onClientListItemClick,false,0,true);
            _loc1_.btnHit.addEventListener(MouseEvent.ROLL_OVER,onClientListItemRollOver,false,0,true);
            _loc1_.btnHit.addEventListener(MouseEvent.ROLL_OUT,onClientListItemRollOut,false,0,true);
            _loc1_.btnHit.tabIndex = _mcClientFilterList.numChildren;
            _loc1_.y = _mcClientFilterList.numChildren * 20;
            _mcClientFilterList.addChild(_loc1_);
         }
      }
      
      protected function _linesChangeHandler(param1:Event) : void
      {
         _updateText();
      }
      
      protected function _showErrorLogs() : void
      {
         _showingAllLogs = false;
         _currentLogAllClip.visible = false;
         _currentLogErrorsClip.visible = true;
         _allLogHitClip.visible = true;
         _errorLogHitClip.visible = false;
         _updateText();
      }
      
      public function comment(param1:String = "", param2:Number = -1, param3:int = -1) : void
      {
         if(param2 == -1)
         {
            param2 = Number(new Date().getTime());
         }
         _aAllLog.push({
            "n":param2,
            "i":param3,
            "t":param1
         });
         _updateText();
      }
      
      protected function _filterText(param1:Array) : void
      {
         var _loc2_:String = _txtFilter.text.toLowerCase();
         _breakThreshold = _txtBreaks.text == "" ? 0 : int(Number(_txtBreaks.text));
         var _loc3_:Boolean = false;
         var _loc4_:Array = _loc2_.split("|");
         if(_loc2_.length == 0)
         {
            txt.text = _TIME_SORTING ? _getSortedString(param1) : _getString(param1);
            return;
         }
         if(_loc4_.length == 1)
         {
            _loc3_ = true;
            _loc4_ = _loc2_.split("&");
         }
         var _loc5_:String = "";
         if(_TIME_SORTING)
         {
            param1.sortOn(["n","i"],[Array.NUMERIC,Array.NUMERIC]);
         }
         var _loc6_:int = _txtLines.text == "" ? int.MAX_VALUE : int(_txtLines.text);
         _loc6_ = param1.length <= _loc6_ ? int(param1.length) : _loc6_;
         var _loc7_:int = 0;
         _lastDateFormatted = 0;
         var _loc8_:int = param1.length - 1;
         while(_loc8_ > -1)
         {
            if(_loc7_ == _loc6_)
            {
               break;
            }
            if(_loc4_.length > 1)
            {
               if(matchFilters(String(param1[_loc8_].t).toLowerCase(),_loc4_,_loc3_))
               {
                  _loc7_++;
                  if(_bShowTime)
                  {
                     _loc5_ += _getTimestampPrefixedString(param1[_loc8_].t,param1[_loc8_].n,param1[_loc8_].i) + "\n";
                  }
                  else
                  {
                     _loc5_ += param1[_loc8_].t + "\n";
                  }
               }
            }
            else if(String(param1[_loc8_].t).toLowerCase().indexOf(_loc2_) != -1)
            {
               _loc7_++;
               if(_bShowTime)
               {
                  _loc5_ += _getTimestampPrefixedString(param1[_loc8_].t,param1[_loc8_].n,param1[_loc8_].i) + "\n";
               }
               else
               {
                  _loc5_ += param1[_loc8_].t + "\n";
               }
            }
            _loc8_--;
         }
         txt.text = _loc5_;
      }
      
      private function matchFilters(param1:String, param2:*, param3:Boolean = false) : Boolean
      {
         var _loc4_:String = null;
         for each(_loc4_ in param2)
         {
            if(param3)
            {
               if(param1.indexOf(_loc4_) != -1)
               {
                  return true;
               }
            }
            else
            {
               if(_loc4_.indexOf("&") != -1)
               {
                  return matchFilters(param1,_loc4_.split("&"),true);
               }
               if(param1.indexOf(_loc4_) == -1)
               {
                  return false;
               }
            }
         }
         return !param3;
      }
      
      public function removeFilterSender(param1:DebugFilterSender) : void
      {
         log("((((((((( removed Client: \'" + param1.displayName + "\' )))))))))");
         delete _filterSenders[param1.key];
         updateClientFilterList();
      }
      
      private function closeClientFilterList() : void
      {
         if(!_bClientFilterListOpened)
         {
            return;
         }
         _bClientFilterListOpened = false;
         Tweener.addTween(_mcClientFilterList,{
            "_autoAlpha":0,
            "scaleX":0,
            "scaleY":0,
            "time":0.6,
            "transition":"easeInBack"
         });
      }
      
      private function _getSortedString(param1:Array) : String
      {
         return _getString(param1,true);
      }
      
      private function handleNothing(param1:*) : void
      {
      }
      
      private function onClientListItemRollOver(param1:MouseEvent) : void
      {
         var _loc2_:ClientListItemElement = ClientListItemElement(param1.target.parent);
         _loc2_.showFilter();
      }
      
      private function _onBtnTimestampsClick(param1:MouseEvent) : void
      {
         _bShowTime = !_bShowTime;
         _updateTimestampSettingText();
         _updateText();
      }
      
      private function _getString(param1:Array, param2:Boolean = false) : String
      {
         var _loc3_:String = "";
         if(param2)
         {
            param1.sortOn(["n","i"],[Array.NUMERIC,Array.NUMERIC]);
         }
         var _loc4_:int = _txtLines.text == "" ? int.MAX_VALUE : int(_txtLines.text);
         _loc4_ = param1.length <= _loc4_ ? int(param1.length) : _loc4_;
         var _loc5_:int = param1.length - _loc4_ - 1;
         _loc3_ = "";
         _lastDateFormatted = 0;
         var _loc6_:int = param1.length - 1;
         while(_loc6_ > _loc5_)
         {
            if(_bShowTime)
            {
               _loc3_ += _getTimestampPrefixedString(param1[_loc6_].t,param1[_loc6_].n,param1[_loc6_].i) + "\n";
            }
            else
            {
               _loc3_ += param1[_loc6_].t + "\n";
            }
            _loc6_--;
         }
         return _loc3_;
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      private function _onBtnTimestampsOut(param1:MouseEvent) : void
      {
         _txtTimestampsSetting.textColor = 0;
      }
      
      public function updateFilterReceiverDisplayName(param1:String, param2:String) : void
      {
         if(_filterSenders[param1] != null)
         {
            DebugFilterSender(_filterSenders[param1]).displayName = param2;
            updateClientFilterList();
         }
      }
      
      protected function _showAllLogs() : void
      {
         _showingAllLogs = true;
         _currentLogAllClip.visible = true;
         _currentLogErrorsClip.visible = false;
         _allLogHitClip.visible = false;
         _errorLogHitClip.visible = true;
         _updateText();
      }
      
      private function onTxtClientFilterChange(param1:Event) : void
      {
         if(!_bClientFilterTextChange)
         {
            if(_txtClientFilter.text != _currentAllClientFilter)
            {
               Tweener.addTween(_mcClientFilterLabel,{
                  "_color":10027008,
                  "time":0.4,
                  "transition":"easeInOutQuad"
               });
               _bClientFilterTextChange = true;
            }
         }
         else if(_txtClientFilter.text == _currentAllClientFilter)
         {
            Tweener.addTween(_mcClientFilterLabel,{
               "_color":0,
               "time":0.4,
               "transition":"easeInOutQuad"
            });
            _bClientFilterTextChange = false;
         }
      }
      
      private function onTxtClientFilterFocusIn(param1:FocusEvent) : void
      {
         openClientFilterList();
      }
      
      private function checkSplitLogId(param1:String) : int
      {
         var _loc2_:RegExp = null;
         var _loc3_:int = 1;
         if(param1.indexOf("[... log split for large packet") != -1)
         {
            _loc2_ = /log split for large packet, id=(.+?)\]/;
         }
         else if(param1.indexOf("[ log split, continued with split") != -1)
         {
            _loc2_ = /\[ log split, continued with split id=(.+?)\./;
            _loc3_ = -1;
         }
         if(_loc2_ == null)
         {
            return -1;
         }
         var _loc4_:Array = param1.match(_loc2_);
         if(_loc4_ == null || _loc4_[1] == null)
         {
            return -1;
         }
         return _loc3_ * _loc4_[1];
      }
      
      private function onClientListItemRollOut(param1:MouseEvent) : void
      {
         var _loc2_:ClientListItemElement = ClientListItemElement(param1.target.parent);
         _loc2_.hideHilter();
      }
      
      private function _updateTimestampSettingText() : void
      {
         _txtTimestampsSetting.text = _bShowTime ? "ON" : "OFF";
      }
      
      private function _getSpaces(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_ += " ";
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function processLongLog(param1:int, param2:String, param3:Number, param4:int) : Object
      {
         var _loc10_:Object = null;
         var _loc5_:Boolean = param1 < 0;
         if(_loc5_)
         {
            param1 *= -1;
         }
         if(_longLogBuffer[param1] == null)
         {
            _longLogBuffer[param1] = _emptyArray.concat();
         }
         param2 = param2.replace(/\[\.\.\. log split for large packet, id=.+\]\n*/,"");
         param2 = param2.replace(/\n*\[ log split, continued with split id=.+\.\.\.\]\n*/,"");
         param2 = param2.replace(/\n*\[ log split chunk END, continued with split id=.+\.\.\.\]\n*/,"");
         param2 = param2.replace(/\n*\[ TOTAL END for log split id=.+ \]\n*/,"");
         param2 += "\n";
         _longLogBuffer[param1][_longLogBuffer[param1].length] = {
            "n":param3,
            "i":param4,
            "t":param2
         };
         if(!_loc5_)
         {
            return null;
         }
         var _loc6_:String = "";
         var _loc7_:Number = Number(_longLogBuffer[param1][0].n);
         var _loc8_:Number = Number(_longLogBuffer[param1][0].i);
         var _loc9_:int = 0;
         while(_loc9_ < _longLogBuffer[param1].length)
         {
            _loc10_ = _longLogBuffer[param1][_loc9_];
            _loc6_ = _loc10_.t + _loc6_;
            _loc9_++;
         }
         _loc6_ = "//## note: long log entry concatenated from segmented log calls -- not a problem ##\\\n" + _loc6_;
         _longLogBuffer[param1] = null;
         return {
            "n":_loc7_,
            "i":_loc8_,
            "t":_loc6_
         };
      }
      
      protected function _errorLogClickHandler(param1:MouseEvent) : void
      {
         _showErrorLogs();
      }
      
      protected function _allLogClickHandler(param1:MouseEvent) : void
      {
         _showAllLogs();
      }
      
      protected function _breaksChangeHandler(param1:Event) : void
      {
         _updateText();
      }
      
      private function openClientFilterList() : void
      {
         if(_bClientFilterListOpened)
         {
            return;
         }
         _bClientFilterListOpened = true;
         Tweener.addTween(_mcClientFilterList,{
            "_autoAlpha":1,
            "time":0.6,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(_mcClientFilterList,{
            "scaleX":1,
            "scaleY":1,
            "time":1.2,
            "transition":"easeOutElastic"
         });
      }
      
      private function onClientListItemClick(param1:MouseEvent) : void
      {
         var _loc2_:ClientListItemElement = ClientListItemElement(param1.target.parent);
         sendClientFilter(_txtClientFilter.text,_loc2_.key);
         closeClientFilterList();
      }
      
      private function sendClientFilter(param1:String, param2:String = "NAM-EHT-SI-AREHCTUK-DRAHCIR") : void
      {
         var listItem:ClientListItemElement = null;
         var debugFilterSender:DebugFilterSender = null;
         var filter:String = param1;
         var clientKey:String = param2;
         if(clientKey == _ALL_CLIENT_FILTER_KEY)
         {
            for each(debugFilterSender in _filterSenders)
            {
               debugFilterSender.sendFilter(filter);
            }
            for each(listItem in _clientListItems)
            {
               listItem.currentFilter = filter;
            }
            _currentAllClientFilter = filter;
            Tweener.addTween(_mcClientFilterLabel,{
               "_color":0,
               "time":0.4,
               "transition":"easeInOutQuad"
            });
            _bClientFilterTextChange = false;
            return;
         }
         try
         {
            DebugFilterSender(_filterSenders[clientKey]).sendFilter(filter);
            Tweener.addTween(_mcClientFilterLabel,{
               "_color":0,
               "time":0.4,
               "transition":"easeInOutQuad"
            });
            _bClientFilterTextChange = false;
            for each(listItem in _clientListItems)
            {
               if(listItem.key == clientKey)
               {
                  listItem.currentFilter = filter;
                  break;
               }
            }
         }
         catch(e:Error)
         {
            error("**** An error occurred trying to send the filter to client \'" + clientKey + "\':\n" + e.message);
         }
      }
      
      private function onPollingConnectionEvent(param1:Event) : void
      {
      }
      
      public function handleFilterSenderLog(param1:String) : void
      {
         log(param1);
      }
      
      public function handleFilterSenderError(param1:String) : void
      {
         error(param1);
      }
      
      protected function _formatEntry(param1:String, param2:String = "") : String
      {
         var _loc3_:String = null;
         _loc3_ = param1;
         return param2 + "\n" + _loc3_;
      }
   }
}

