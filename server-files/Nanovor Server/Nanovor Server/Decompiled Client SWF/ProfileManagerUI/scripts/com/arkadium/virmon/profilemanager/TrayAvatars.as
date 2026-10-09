package com.arkadium.virmon.profilemanager
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.asset.IAsset;
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol255")]
   public class TrayAvatars extends Sprite
   {
      
      public static const AVATAR_SELECTED:String = "avatarSelected";
      
      public static const PASSWORD_CHANGE_CLICK:String = "passwordChangeClick";
      
      public static const AVATAR_EXCLUDE_START:int = 990;
      
      public static const AVATAR_EXCLUDE_END:int = 999;
      
      private var _mcRingSelector:MovieClip;
      
      private var _iSelectorOffsetX:int = 43;
      
      private var _aCells:Array = new Array();
      
      public var mcScrollBar:ScrollBar;
      
      private var _iAvatarsLoaded:int = 0;
      
      private var _iCellsSpacingX:int = 102;
      
      private var _iCellsSpacingY:int = 98;
      
      public var mcChangePassword:MovieClip;
      
      private var _iCellsNestOffsetY:int = 17;
      
      private var _iCellsNestOffsetX:int = 11;
      
      private var _tmrMouseGone:Timer;
      
      private var _oAvatarCellSelected:AvatarCell = null;
      
      private var _nCellsNestOrigY:Number;
      
      private var _mcRingSelected:MovieClip;
      
      private var _iSelectedOffsetY:int = 43;
      
      private var _iSelectedOffsetX:int = 43;
      
      public var mcCellsNest:MovieClip;
      
      private var _aAvatarIds:* = new Array();
      
      private var _iCellsNestColumns:int = 5;
      
      public var mcCellsNestMask:MovieClip;
      
      private var _btnChangePassword:SimpleButton;
      
      private var _nCellsNestMaskHeight:Number;
      
      public var stfEmail:TextField;
      
      public var stfScreenname:TextField;
      
      private var _iSelectorOffsetY:int = 44;
      
      public function TrayAvatars()
      {
         super();
         clearFields();
         mcScrollBar.visible = false;
         mcScrollBar.y = mcCellsNestMask.y;
         mcScrollBar.addEventListener(ScrollBar.MOUSE_DOWN,onScrollMouseDown,false,0,true);
         mcScrollBar.addEventListener(ScrollBar.MOUSE_UP,onScrollMouseUp,false,0,true);
         _btnChangePassword = mcChangePassword.btnHit;
         _btnChangePassword.addEventListener(MouseEvent.ROLL_OVER,onChangePasswordRollOver,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.ROLL_OUT,onChangePasswordRollOut,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.MOUSE_DOWN,onChangePasswordDown,false,0,true);
         _btnChangePassword.addEventListener(MouseEvent.CLICK,onChangePasswordClick,false,0,true);
         _nCellsNestOrigY = mcCellsNest.y;
         _nCellsNestMaskHeight = mcCellsNestMask.height;
         _tmrMouseGone = new Timer(400);
         _tmrMouseGone.addEventListener(TimerEvent.TIMER,onTimerMouseGone);
      }
      
      protected function comment(param1:String) : void
      {
         DebugLog.instance.comment(">> PM TrayAvatars: " + param1);
      }
      
      private function onAvatarLoadComplete(param1:Event) : void
      {
         var _loc2_:AvatarCell = null;
         param1.target.removeEventListener(AvatarCell.LOAD_COMPLETE,onAvatarLoadComplete);
         param1.target.removeEventListener(AvatarCell.LOAD_ERROR,onAvatarLoadComplete);
         ++_iAvatarsLoaded;
         if(_iAvatarsLoaded == _aAvatarIds.length)
         {
            checkForScrollable();
            _loc2_ = findAvatarCellById(UserProfile.getInstance().avatarId);
            if(_loc2_ != null)
            {
               selectAvatar(_loc2_);
               if(mcScrollBar.visible)
               {
                  mcScrollBar.jumpToRatio((_loc2_.y - _iCellsNestOffsetY + Math.round(_loc2_.y / mcCellsNest.height) * _loc2_.height) / mcCellsNest.height);
               }
            }
         }
      }
      
      private function onChangePasswordRollOut(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("out");
      }
      
      private function fleeSelector() : void
      {
         Tweener.addTween(_mcRingSelector,{
            "alpha":0,
            "time":1.2,
            "transition":"easeInOutQuad"
         });
      }
      
      private function findAvatarCellById(param1:int) : AvatarCell
      {
         var _loc2_:int = 0;
         while(_loc2_ < _aCells.length)
         {
            if((_aCells[_loc2_] as AvatarCell).iAvatarId == param1)
            {
               return _aCells[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function init() : *
      {
         var _loc3_:IAsset = null;
         var _loc4_:AvatarCell = null;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:UserProfile = UserProfile.getInstance();
         stfScreenname.text = _loc1_.screenname;
         stfEmail.text = _loc1_.email;
         _mcRingSelected = mcCellsNest.mcRingSelected;
         _mcRingSelector = mcCellsNest.mcRingSelector;
         _mcRingSelector.alpha = 0;
         if(mcScrollBar.visible)
         {
            mcScrollBar.reset();
            mcScrollBar.visible = false;
         }
         mcCellsNest.y = _nCellsNestOrigY;
         clearCellListeners();
         _aAvatarIds = new Array();
         _aCells = new Array();
         _iAvatarsLoaded = 0;
         var _loc2_:Array = Managers.assetRetrieverManager.avatarAssetRetriever.getAvatarAssetList(AvatarAssetType.MEDIUM);
         for each(_loc3_ in _loc2_)
         {
            _loc7_ = int(_loc3_.id);
            if(_loc7_ < AVATAR_EXCLUDE_START || _loc7_ > AVATAR_EXCLUDE_END)
            {
               _aAvatarIds.push(_loc7_);
            }
         }
         _aAvatarIds.sort(shuffle);
         _loc6_ = 0;
         while(_loc6_ < _aAvatarIds.length)
         {
            _loc4_ = mcCellsNest.addChildAt(new AvatarCell(_aAvatarIds[_loc6_]),0) as AvatarCell;
            _loc4_.addEventListener(AvatarCell.LOAD_COMPLETE,onAvatarLoadComplete,false,0,true);
            _loc4_.addEventListener(AvatarCell.LOAD_ERROR,onAvatarLoadComplete,false,0,true);
            _loc4_.addEventListener(AvatarCell.ROLL_OVER,onAvatarRollOver,false,0,true);
            _loc4_.addEventListener(AvatarCell.ROLL_OUT,onAvatarRollOut,false,0,true);
            _loc4_.addEventListener(AvatarCell.CLICK,onAvatarClick,false,0,true);
            _loc5_ = mcCellsNest.addChild(_loc4_.mcHit) as MovieClip;
            _loc5_.x = _loc4_.x = _iCellsNestOffsetX + _loc6_ % _iCellsNestColumns * _iCellsSpacingX;
            _loc5_.y = _loc4_.y = _iCellsNestOffsetY + Math.floor(_loc6_ / _iCellsNestColumns) * _iCellsSpacingY;
            _aCells.push(_loc4_);
            _loc6_++;
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
      
      private function onAvatarRollOver(param1:Event) : void
      {
         _tmrMouseGone.reset();
         var _loc2_:AvatarCell = param1.target as AvatarCell;
         _mcRingSelector.x = _loc2_.x + _iSelectorOffsetX;
         _mcRingSelector.y = _loc2_.y + _iSelectorOffsetY;
         Tweener.addTween(_mcRingSelector,{
            "alpha":1,
            "time":0.7,
            "transition":"easeInOutQuad"
         });
         if(!_loc2_.bSelected)
         {
            Tweener.addTween(_loc2_.mcShading,{
               "alpha":0.5,
               "time":0.7,
               "transition":"easeInOutQuad"
            });
         }
      }
      
      private function clearCellListeners() : void
      {
         var _loc1_:AvatarCell = null;
         var _loc2_:int = 0;
         while(_loc2_ < _aCells.length)
         {
            _loc1_ = AvatarCell(_aCells[_loc2_]);
            _loc1_.removeEventListener(AvatarCell.ROLL_OVER,onAvatarRollOver);
            _loc1_.removeEventListener(AvatarCell.ROLL_OUT,onAvatarRollOut);
            _loc1_.removeEventListener(AvatarCell.CLICK,onAvatarClick);
            _loc1_.clearListeners();
            _loc1_.clearLoaded();
            _loc2_++;
         }
      }
      
      private function onChangePasswordRollOver(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("over");
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> PM TrayAvatars: " + param1);
      }
      
      private function onScrollMouseDown(param1:Event) : void
      {
      }
      
      private function onAvatarClick(param1:Event) : void
      {
         var _loc2_:AvatarCell = param1.target as AvatarCell;
         if(_oAvatarCellSelected !== null)
         {
            if(_oAvatarCellSelected.iAvatarId != _loc2_.iAvatarId)
            {
               selectAvatar(_loc2_);
               dispatchEvent(new CustomEvent(AVATAR_SELECTED,_loc2_.iAvatarId));
            }
         }
      }
      
      private function onAvatarRollOut(param1:Event) : void
      {
         _tmrMouseGone.start();
         var _loc2_:AvatarCell = param1.target as AvatarCell;
         if(!_loc2_.bSelected)
         {
            Tweener.addTween(_loc2_.mcShading,{
               "alpha":1,
               "time":0.7,
               "transition":"easeInOutQuad"
            });
         }
      }
      
      protected function error(param1:String) : void
      {
         DebugLog.instance.error(">> PM TrayAvatars: " + param1);
      }
      
      private function onTimerMouseGone(param1:TimerEvent) : void
      {
         _tmrMouseGone.stop();
         fleeSelector();
      }
      
      private function clearFields() : void
      {
         stfScreenname.text = stfEmail.text = "";
      }
      
      private function onChangePasswordDown(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("down");
      }
      
      public function clearListeners() : *
      {
         mcScrollBar.destroy();
         _tmrMouseGone.removeEventListener(TimerEvent.TIMER,onTimerMouseGone);
         mcScrollBar.removeEventListener(ScrollBar.MOUSE_DOWN,onScrollMouseDown);
         mcScrollBar.removeEventListener(ScrollBar.MOUSE_UP,onScrollMouseUp);
         _btnChangePassword.removeEventListener(MouseEvent.ROLL_OVER,onChangePasswordRollOver);
         _btnChangePassword.removeEventListener(MouseEvent.ROLL_OUT,onChangePasswordRollOut);
         _btnChangePassword.removeEventListener(MouseEvent.MOUSE_DOWN,onChangePasswordDown);
         _btnChangePassword.removeEventListener(MouseEvent.CLICK,onChangePasswordClick);
         clearCellListeners();
      }
      
      private function onScrollMouseUp(param1:Event) : void
      {
      }
      
      private function selectAvatar(param1:AvatarCell) : void
      {
         if(_oAvatarCellSelected !== null)
         {
            if(_oAvatarCellSelected.iAvatarId == param1.iAvatarId)
            {
               return;
            }
            _oAvatarCellSelected.bSelected = false;
            _oAvatarCellSelected.mcShading.alpha = 1;
         }
         _mcRingSelected.alpha = 0;
         if(Boolean(param1))
         {
            _oAvatarCellSelected = param1;
            param1.bSelected = true;
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
            Tweener.addTween(param1.mcShading,{
               "alpha":0,
               "time":0.3,
               "transition":"easeInOutQuad"
            });
         }
         else
         {
            _oAvatarCellSelected = null;
         }
      }
      
      private function shuffle(param1:*, param2:*) : Number
      {
         return Math.round(Math.random() * 2) - 1;
      }
      
      private function onChangePasswordClick(param1:MouseEvent) : void
      {
         mcChangePassword.gotoAndPlay("over");
         dispatchEvent(new Event(PASSWORD_CHANGE_CLICK));
      }
   }
}

