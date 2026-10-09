package com.arkadium.virmon.profilemanager
{
   import caurina.transitions.Tweener;
   import caurina.transitions.properties.ColorShortcuts;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.IBadgeData;
   import com.smithandtinker.nanovor.common.utils.BitmapSwap;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol242")]
   public class TrayBadges extends Sprite
   {
      
      public static const PASSWORD_CHANGE_CLICK:String = "passwordChangeClick";
      
      private var _iSelectorOffsetX:int = 37;
      
      private var _mcRingSelector:MovieClip;
      
      private var _szMessageSelect:String = "SELECT BADGE TO VIEW";
      
      private var _aCells:Array = new Array();
      
      public var mcScrollBar:ScrollBar;
      
      private var _szMessageNoBadges:String = "YOU HAVE NOT EARNED ANY BADGES YET";
      
      private var _iCellsSpacingX:int = 102;
      
      private var _iCellsSpacingY:int = 85;
      
      public var mcSelectedBadgeHolder:MovieClip;
      
      public var mcChangePassword:MovieClip;
      
      private var _iCellsNestOffsetY:int = 19;
      
      private var _tmrMouseGone:Timer;
      
      private var _iCellsNestOffsetX:int = 18;
      
      private var _aBadges:* = new Array();
      
      private var _mcRingSelected:MovieClip;
      
      public var stfBoxMessage:TextField;
      
      private var _nCellsNestOrigY:Number;
      
      private var _iSelectedOffsetX:int = 39;
      
      private var _iSelectedOffsetY:int = 38;
      
      public var stfSelectedBadgeShortDesc:TextField;
      
      public var mcCellsNest:MovieClip;
      
      private var _oBadgeCellSelected:BadgeCell = null;
      
      private var _iCellsNestColumns:int = 5;
      
      public var mcCellsNestMask:MovieClip;
      
      private var _iBadgesLoaded:int = 0;
      
      private var _btnChangePassword:SimpleButton;
      
      private var _nCellsNestMaskHeight:Number;
      
      public var stfSelectedBadgeLongDesc:TextField;
      
      public var stfSelectedBadgeTitle:TextField;
      
      public var stfEmail:TextField;
      
      public var stfScreenname:TextField;
      
      private var _iSelectorOffsetY:int = 38;
      
      public function TrayBadges()
      {
         super();
         clearFields();
         mcScrollBar.visible = false;
         mcScrollBar.y = mcCellsNestMask.y;
         mcScrollBar.addEventListener(ScrollBar.MOUSE_DOWN,onScrollMouseDown,false,0,true);
         mcScrollBar.addEventListener(ScrollBar.MOUSE_UP,onScrollMouseUp,false,0,true);
         _nCellsNestOrigY = mcCellsNest.y;
         _nCellsNestMaskHeight = mcCellsNestMask.height;
         stfSelectedBadgeTitle.autoSize = TextFieldAutoSize.LEFT;
         stfSelectedBadgeShortDesc.autoSize = TextFieldAutoSize.LEFT;
         stfSelectedBadgeLongDesc.autoSize = TextFieldAutoSize.LEFT;
         _btnChangePassword = mcChangePassword.btnHit;
         _btnChangePassword.addEventListener(MouseEvent.ROLL_OVER,onChangePasswordRollOver,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.ROLL_OUT,onChangePasswordRollOut,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.MOUSE_DOWN,onChangePasswordDown,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.CLICK,onChangePasswordClick,false,0,true);
         _tmrMouseGone = new Timer(400);
         _tmrMouseGone.addEventListener(TimerEvent.TIMER,onTimerMouseGone);
         Tweener.init();
      }
      
      private function onChangePasswordClick(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("over");
         dispatchEvent(new Event(PASSWORD_CHANGE_CLICK));
      }
      
      private function onChangePasswordRollOut(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("out");
      }
      
      private function onBadgeRollOver(param1:Event) : void
      {
         _tmrMouseGone.reset();
         var _loc2_:BadgeCell = param1.target as BadgeCell;
         _mcRingSelector.x = _loc2_.x + _iSelectorOffsetX;
         _mcRingSelector.y = _loc2_.y + _iSelectorOffsetY;
         Tweener.addTween(_mcRingSelector,{
            "alpha":1,
            "time":1.2,
            "transition":"easeInOutQuad"
         });
         if(!_loc2_.bSelected)
         {
            Tweener.addTween(_loc2_.mcContainer,{
               "_tintBrightness":-0.4,
               "time":0.3,
               "transition":"easeInOutQuad"
            });
         }
      }
      
      private function selectBadge(param1:BadgeCell) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(_oBadgeCellSelected !== null)
         {
            if(_oBadgeCellSelected.iBadgeId == param1.iBadgeId)
            {
               return;
            }
            _oBadgeCellSelected.bSelected = false;
            Tweener.addTween(_oBadgeCellSelected.mcContainer,{
               "_tintBrightness":-0.6,
               "time":0.4,
               "transition":"easeInOutQuad"
            });
         }
         _oBadgeCellSelected = param1;
         param1.bSelected = true;
         BitmapSwap.QuickRun(mcSelectedBadgeHolder,new Bitmap(param1.getBitmap().bitmapData),0.4);
         var _loc2_:IBadgeData = DataManager.getInstance().getBadgeManager().getUserBadge(param1.iBadgeId);
         stfSelectedBadgeTitle.text = _loc2_.getName();
         stfSelectedBadgeShortDesc.text = _loc2_.getShortDescription();
         stfSelectedBadgeLongDesc.text = _loc2_.getLongDescription();
         _mcRingSelected.alpha = 0;
         _mcRingSelected.x = param1.x + _iSelectedOffsetX;
         _mcRingSelected.y = param1.y + _iSelectedOffsetY;
         Tweener.addTween(_mcRingSelected,{
            "alpha":1,
            "time":0.6,
            "transition":"easeInOutQuad"
         });
         Tweener.addTween(_mcRingSelected,{
            "rotation":_mcRingSelected.rotation + 180,
            "time":0.8,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(param1.mcContainer,{
            "_tintBrightness":0,
            "time":0.6,
            "transition":"easeInOutQuad"
         });
      }
      
      public function init() : *
      {
         var userProfile:UserProfile;
         var oBC:BadgeCell = null;
         var mcHit:MovieClip = null;
         var iId:int = 0;
         var i:int = 0;
         log("init()");
         userProfile = UserProfile.getInstance();
         stfScreenname.text = userProfile.screenname;
         stfEmail.text = userProfile.email;
         _mcRingSelected = mcCellsNest.mcRingSelected;
         _mcRingSelector = mcCellsNest.mcRingSelector;
         _mcRingSelector.alpha = 0;
         _mcRingSelected.alpha = 0;
         if(mcScrollBar.visible)
         {
            mcScrollBar.reset();
            mcScrollBar.visible = false;
         }
         mcCellsNest.y = _nCellsNestOrigY;
         _aBadges = DataManager.getInstance().getBadgeManager().getUserBadgeList();
         if(_aBadges.length == 0)
         {
            stfBoxMessage.text = _szMessageNoBadges;
            stfBoxMessage.autoSize = TextFieldAutoSize.CENTER;
            return;
         }
         stfBoxMessage.text = _szMessageSelect;
         stfBoxMessage.autoSize = TextFieldAutoSize.CENTER;
         i = 0;
         while(i < _aBadges.length)
         {
            try
            {
               iId = int(IBadgeData(_aBadges[i]).getID());
            }
            catch(e:Error)
            {
               error("CHOKED on getting badge data for i=" + i + "... _aBadges[i]=" + _aBadges[i]);
            }
            log("iId: " + iId);
            try
            {
               oBC = mcCellsNest.addChildAt(new BadgeCell(iId),0) as BadgeCell;
               oBC.addEventListener(BadgeCell.LOAD_COMPLETE,onBadgeLoadComplete,false,0,true);
               oBC.addEventListener(BadgeCell.LOAD_ERROR,onBadgeLoadComplete,false,0,true);
               oBC.addEventListener(BadgeCell.ROLL_OVER,onBadgeRollOver,false,0,true);
               oBC.addEventListener(BadgeCell.ROLL_OUT,onBadgeRollOut,false,0,true);
               oBC.addEventListener(BadgeCell.CLICK,onBadgeClick,false,0,true);
               ColorShortcuts._brightness_set(oBC.mcContainer,-0.6,[true]);
               mcHit = mcCellsNest.addChild(oBC.mcHit) as MovieClip;
               mcHit.x = oBC.x = _iCellsNestOffsetX + i % _iCellsNestColumns * _iCellsSpacingX;
               mcHit.y = oBC.y = _iCellsNestOffsetY + Math.floor(i / _iCellsNestColumns) * _iCellsSpacingY;
               _aCells.push(oBC);
            }
            catch(e:Error)
            {
               log("BadgeCell failed on badge id: " + iId);
            }
            i++;
         }
      }
      
      protected function comment(param1:String) : void
      {
         DebugLog.instance.comment(">> PM TrayBadges: " + param1);
      }
      
      private function onBadgeRollOut(param1:Event) : void
      {
         _tmrMouseGone.start();
         var _loc2_:BadgeCell = param1.target as BadgeCell;
         if(!_loc2_.bSelected)
         {
            Tweener.addTween(_loc2_.mcContainer,{
               "_tintBrightness":-0.6,
               "time":0.4,
               "transition":"easeInOutQuad"
            });
         }
      }
      
      private function checkForScrollable() : void
      {
         mcScrollBar.visible = false;
         if(mcCellsNest.height >= _nCellsNestMaskHeight + 1)
         {
            mcScrollBar.visible = true;
            mcScrollBar.init(mcCellsNest,_nCellsNestMaskHeight,true);
         }
      }
      
      private function fleeSelector() : void
      {
         Tweener.addTween(_mcRingSelector,{
            "alpha":0,
            "time":1.2,
            "transition":"easeInOutQuad"
         });
      }
      
      protected function error(param1:String) : void
      {
         DebugLog.instance.error(">> PM TrayBadges: " + param1);
      }
      
      private function onChangePasswordRollOver(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("over");
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> PM TrayBadges: " + param1);
      }
      
      private function onScrollMouseDown(param1:Event) : void
      {
      }
      
      private function onBadgeLoadComplete(param1:Event) : void
      {
         var _loc2_:BadgeCell = null;
         param1.target.removeEventListener(BadgeCell.LOAD_COMPLETE,onBadgeLoadComplete);
         param1.target.removeEventListener(BadgeCell.LOAD_ERROR,onBadgeLoadComplete);
         ++_iBadgesLoaded;
         if(_iBadgesLoaded == _aBadges.length)
         {
            _loc2_ = findBadgeCellById(IBadgeData(_aBadges[0]).getID());
            selectBadge(_loc2_);
            checkForScrollable();
            if(mcScrollBar.visible)
            {
               mcScrollBar.jumpToRatio((_loc2_.y - _iCellsNestOffsetY + Math.round(_loc2_.y / mcCellsNest.height) * _loc2_.height) / mcCellsNest.height);
            }
         }
      }
      
      private function onTimerMouseGone(param1:TimerEvent) : void
      {
         _tmrMouseGone.stop();
         fleeSelector();
      }
      
      private function onBadgeClick(param1:Event) : void
      {
         var _loc2_:BadgeCell = param1.target as BadgeCell;
         if(_oBadgeCellSelected !== null)
         {
            if(_oBadgeCellSelected.iBadgeId != _loc2_.iBadgeId)
            {
               selectBadge(_loc2_);
            }
         }
      }
      
      private function onChangePasswordDown(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("down");
      }
      
      public function clearListeners() : *
      {
         var _loc1_:BadgeCell = null;
         mcScrollBar.destroy();
         _tmrMouseGone.removeEventListener(TimerEvent.TIMER,onTimerMouseGone);
         mcScrollBar.removeEventListener(ScrollBar.MOUSE_DOWN,onScrollMouseDown);
         mcScrollBar.removeEventListener(ScrollBar.MOUSE_UP,onScrollMouseUp);
         _btnChangePassword.removeEventListener(MouseEvent.ROLL_OVER,onChangePasswordRollOver);
         _btnChangePassword.removeEventListener(MouseEvent.ROLL_OUT,onChangePasswordRollOut);
         _btnChangePassword.removeEventListener(MouseEvent.MOUSE_DOWN,onChangePasswordDown);
         _btnChangePassword.removeEventListener(MouseEvent.CLICK,onChangePasswordClick);
         var _loc2_:int = 0;
         while(_loc2_ < _aCells.length)
         {
            _loc1_ = BadgeCell(_aCells[_loc2_]);
            _loc1_.removeEventListener(BadgeCell.LOAD_COMPLETE,onBadgeLoadComplete);
            _loc1_.removeEventListener(BadgeCell.LOAD_ERROR,onBadgeLoadComplete);
            _loc1_.removeEventListener(BadgeCell.ROLL_OVER,onBadgeRollOver);
            _loc1_.removeEventListener(BadgeCell.ROLL_OUT,onBadgeRollOut);
            _loc1_.removeEventListener(BadgeCell.CLICK,onBadgeClick);
            _loc1_.clearListeners();
            _loc1_.clearLoaded();
            _loc2_++;
         }
      }
      
      private function onScrollMouseUp(param1:Event) : void
      {
      }
      
      private function findBadgeCellById(param1:int) : BadgeCell
      {
         var _loc2_:int = 0;
         while(_loc2_ < _aCells.length)
         {
            if((_aCells[_loc2_] as BadgeCell).iBadgeId == param1)
            {
               return _aCells[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function clearFields() : void
      {
         stfScreenname.text = stfEmail.text = stfSelectedBadgeTitle.text = stfSelectedBadgeShortDesc.text = stfSelectedBadgeLongDesc.text = stfBoxMessage.text = "";
      }
   }
}

