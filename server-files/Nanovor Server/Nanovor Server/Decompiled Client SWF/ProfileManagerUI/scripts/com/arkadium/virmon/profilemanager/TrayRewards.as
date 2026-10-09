package com.arkadium.virmon.profilemanager
{
   import caurina.transitions.Tweener;
   import caurina.transitions.properties.ColorShortcuts;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.BadgeData;
   import com.arkadium.virmon.framework.DataManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol230")]
   public class TrayRewards extends Sprite
   {
      
      public static const PASSWORD_CHANGE_CLICK:String = "passwordChangeClick";
      
      public var stfScreenname:TextField;
      
      private var _mcRingSelector:MovieClip;
      
      private var _szMessageSelect:String = "SELECT BADGE TO VIEW";
      
      public var b1:MovieClip;
      
      public var mcScrollBar:ScrollBar;
      
      public var b3:MovieClip;
      
      public var b4:MovieClip;
      
      public var b5:MovieClip;
      
      public var b6:MovieClip;
      
      public var b7:MovieClip;
      
      public var b8:MovieClip;
      
      public var b2:MovieClip;
      
      private var _szMessageNoBadges:String = "YOU HAVE NOT EARNED ANY BADGES YET";
      
      private var _iCellsSpacingX:int = 102;
      
      private var _iCellsSpacingY:int = 85;
      
      public var mcChangePassword:MovieClip;
      
      private var _iCellsNestOffsetY:int = 19;
      
      private var _aCells:Array = new Array();
      
      private var _aBadges:Array = [1595,1596,1597,154,157,1598,155,148];
      
      private var _iCellsNestOffsetX:int = 18;
      
      private var _tmrMouseGone:Timer;
      
      private var _mcRingSelected:MovieClip;
      
      public var stfBoxMessage:TextField;
      
      private var _nCellsNestOrigY:Number;
      
      private var _iSelectedOffsetX:int = 39;
      
      private var _iSelectedOffsetY:int = 38;
      
      public var mcCellsNest:MovieClip;
      
      private var _oBadgeCellSelected:BadgeCell = null;
      
      private var _currentBreadcrumb:MovieClip;
      
      private var _iCellsNestColumns:int = 5;
      
      public var mcCellsNestMask:MovieClip;
      
      private var _iBadgesLoaded:int = 0;
      
      private var _btnChangePassword:SimpleButton;
      
      private var _nCellsNestMaskHeight:Number;
      
      public var stfEmail:TextField;
      
      private var _iSelectorOffsetX:int = 37;
      
      private var _iSelectorOffsetY:int = 38;
      
      public function TrayRewards()
      {
         super();
         mcScrollBar.visible = false;
         mcScrollBar.y = mcCellsNestMask.y;
         mcScrollBar.addEventListener(ScrollBar.MOUSE_DOWN,onScrollMouseDown,false,0,true);
         mcScrollBar.addEventListener(ScrollBar.MOUSE_UP,onScrollMouseUp,false,0,true);
         _nCellsNestOrigY = mcCellsNest.y;
         _nCellsNestMaskHeight = mcCellsNestMask.height;
         _btnChangePassword = mcChangePassword.btnHit;
         _btnChangePassword.addEventListener(MouseEvent.ROLL_OVER,onChangePasswordRollOver,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.ROLL_OUT,onChangePasswordRollOut,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.MOUSE_DOWN,onChangePasswordDown,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.CLICK,onChangePasswordClick,false,0,true);
         _tmrMouseGone = new Timer(400);
         _tmrMouseGone.addEventListener(TimerEvent.TIMER,onTimerMouseGone);
         Tweener.init();
      }
      
      private function onBadgeRollOut(param1:Event) : void
      {
         _tmrMouseGone.start();
         var _loc2_:BadgeCell = param1.target as BadgeCell;
         if(_loc2_.bSelected)
         {
         }
      }
      
      private function onChangePasswordRollOut(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("out");
      }
      
      protected function comment(param1:String) : void
      {
         DebugLog.instance.comment(">> PM TrayRewards: " + param1);
      }
      
      public function init() : *
      {
         var userProfile:UserProfile;
         var oBC:BadgeCell = null;
         var mcHit:MovieClip = null;
         var iId:int = 0;
         var i:int = 0;
         var badgeArray:Array = null;
         var checked:Boolean = false;
         var b:int = 0;
         log("init()");
         userProfile = UserProfile.getInstance();
         stfScreenname.text = userProfile.screenname;
         stfEmail.text = userProfile.email;
         _mcRingSelected = mcCellsNest.mcRingSelected;
         _mcRingSelector = mcCellsNest.mcRingSelector;
         _mcRingSelector.alpha = 0;
         _mcRingSelected.alpha = 0;
         b1.visible = false;
         b1.alpha = 0;
         b2.visible = false;
         b2.alpha = 0;
         b3.visible = false;
         b3.alpha = 0;
         b4.visible = false;
         b4.alpha = 0;
         b5.visible = false;
         b5.alpha = 0;
         b6.visible = false;
         b6.alpha = 0;
         b7.visible = false;
         b7.alpha = 0;
         b8.visible = false;
         b8.alpha = 0;
         if(mcScrollBar.visible)
         {
            mcScrollBar.reset();
            mcScrollBar.visible = false;
         }
         mcCellsNest.y = _nCellsNestOrigY;
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
            iId = int(_aBadges[i]);
            log("iId: " + iId);
            try
            {
               oBC = mcCellsNest.addChildAt(new BadgeCell(iId),0) as BadgeCell;
               badgeArray = DataManager.getInstance().getBadgeManager().getUserBadgeList();
               checked = false;
               b = 0;
               while(b < badgeArray.length)
               {
                  if(BadgeData(badgeArray[b]).getID() == iId)
                  {
                     checked = true;
                     break;
                  }
                  b++;
               }
               if(checked == true)
               {
                  oBC.setChecked();
               }
               else
               {
                  ColorShortcuts._brightness_set(oBC.mcContainer,-0.6,[true]);
               }
               oBC.addEventListener(BadgeCell.LOAD_COMPLETE,onBadgeLoadComplete,false,0,true);
               oBC.addEventListener(BadgeCell.LOAD_ERROR,onBadgeLoadComplete,false,0,true);
               oBC.addEventListener(BadgeCell.ROLL_OVER,onBadgeRollOver,false,0,true);
               oBC.addEventListener(BadgeCell.ROLL_OUT,onBadgeRollOut,false,0,true);
               oBC.addEventListener(BadgeCell.CLICK,onBadgeClick,false,0,true);
               mcHit = mcCellsNest.addChild(oBC.mcHit) as MovieClip;
               mcHit.x = oBC.x = _iCellsNestOffsetX + i % _iCellsNestColumns * _iCellsSpacingX;
               mcHit.y = oBC.y = _iCellsNestOffsetY + Math.floor(i / _iCellsNestColumns) * _iCellsSpacingY;
               _aCells.push(oBC);
            }
            catch(e:Error)
            {
               log("BadgeCell failed on badge iid: " + iId);
            }
            i++;
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
         }
         _oBadgeCellSelected = param1;
         param1.bSelected = true;
         var _loc2_:int = int(_aBadges.indexOf(param1.iBadgeId));
         if(_loc2_ > -1)
         {
            if(Boolean(_currentBreadcrumb))
            {
               Tweener.addTween(_currentBreadcrumb,{
                  "_autoAlpha":0,
                  "time":1
               });
            }
            _currentBreadcrumb = this["b" + (_loc2_ + 1)];
            Tweener.addTween(_currentBreadcrumb,{
               "_autoAlpha":1,
               "time":1
            });
         }
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
      
      private function onChangePasswordRollOver(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("over");
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> PM TrayRewards: " + param1);
      }
      
      private function onScrollMouseDown(param1:Event) : void
      {
      }
      
      private function fleeSelector() : void
      {
         Tweener.addTween(_mcRingSelector,{
            "alpha":0,
            "time":1.2,
            "transition":"easeInOutQuad"
         });
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
         if(_loc2_.bSelected)
         {
         }
      }
      
      protected function error(param1:String) : void
      {
         DebugLog.instance.error(">> PM TrayRewards: " + param1);
      }
      
      private function onBadgeLoadComplete(param1:Event) : void
      {
         var _loc2_:BadgeCell = null;
         param1.target.removeEventListener(BadgeCell.LOAD_COMPLETE,onBadgeLoadComplete);
         param1.target.removeEventListener(BadgeCell.LOAD_ERROR,onBadgeLoadComplete);
         ++_iBadgesLoaded;
         if(_iBadgesLoaded == _aBadges.length)
         {
            _loc2_ = findBadgeCellById(_aBadges[0]);
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
      
      private function onChangePasswordClick(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("over");
         dispatchEvent(new Event(PASSWORD_CHANGE_CLICK));
      }
   }
}

