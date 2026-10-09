package com.arkadium.virmon.shared.widgets.header
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.framework.asset.retriever.IAvatarAssetRetriever;
   import com.arkadium.virmon.shared.components.avatar.Avatar;
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class HeaderAvatarRenderer implements IHeaderAvatarRenderer
   {
      
      private static const _AVATAR_POINTS_2PLAYER:Array = [0,482];
      
      private static const _AVATAR_POINTS_3PLAYER:Array = [0,366,723];
      
      private static const _AVATAR_POINTS_4PLAYER:Array = [0,241,482,723];
      
      private var _myAvatar:IAvatar;
      
      private var _enemyAvatarsContainer:MovieClip;
      
      private var _playerCount:int;
      
      private var _enemyAvatars:Array;
      
      private var _avatarAssetRetriever:IAvatarAssetRetriever;
      
      public function HeaderAvatarRenderer(param1:IAvatarAssetRetriever, param2:MovieClip)
      {
         super();
         _avatarAssetRetriever = param1;
         _enemyAvatarsContainer = param2;
         _enemyAvatarsContainer.mouseEnabled = false;
         _playerCount = 0;
         _enemyAvatars = new Array();
      }
      
      public function removeEnemyAvatars() : void
      {
         var _loc1_:IAvatar = null;
         while(_enemyAvatarsContainer.numChildren > 0)
         {
            _loc1_ = _enemyAvatarsContainer.removeChildAt(0) as IAvatar;
            _loc1_.swarmometer.hide();
            _loc1_.swarmometer.clearMeters();
            Utils.clearAllChildren(_loc1_);
         }
         _enemyAvatars = new Array();
      }
      
      public function resetNumberOfPlayers(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:IAvatar = null;
         var _loc5_:Number = NaN;
         _playerCount = param1;
         if(_enemyAvatars == null || _enemyAvatars.length == 0)
         {
            return;
         }
         switch(_playerCount)
         {
            case 2:
               _loc2_ = _AVATAR_POINTS_2PLAYER;
               break;
            case 3:
               _loc2_ = _AVATAR_POINTS_3PLAYER;
               break;
            case 4:
            default:
               _loc2_ = _AVATAR_POINTS_4PLAYER;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _enemyAvatars.length)
         {
            _loc3_ = _enemyAvatars[_loc4_];
            if(_loc3_ != null)
            {
               Tweener.removeTweens(_loc3_,"x");
               _loc5_ = Number(_loc2_[_loc4_ + 1]);
               log("(resetNumberOfPlayers) [i=" + _loc4_ + "] player \'" + _loc3_.playerName + "\' moveTo=" + _loc5_);
               Tweener.addTween(_loc3_,{
                  "x":_loc5_,
                  "time":1,
                  "delay":2,
                  "transition":"easeOutQuad"
               });
            }
            _loc4_++;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<HeaderAvatarRenderer>> " + param1);
      }
      
      public function loadEnemyAvatarPictureById(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:IAvatar = getAvatarByPlayerID(param1);
         if(null != _loc4_)
         {
            _loc4_.nmp = param3;
            _loc4_.loadAvatarPicture(param2);
         }
      }
      
      public function setPlayerName(param1:String) : void
      {
         _myAvatar.playerName = param1;
      }
      
      public function setNumberOfPlayers(param1:int) : void
      {
         _playerCount = param1;
      }
      
      public function get enemyAvatars() : Array
      {
         return _enemyAvatars;
      }
      
      public function removeEnemyAvatar(param1:IAvatar) : void
      {
         if(false == _enemyAvatarsContainer.contains(param1 as DisplayObject))
         {
            return;
         }
         _enemyAvatarsContainer.removeChild(param1 as DisplayObject);
         _enemyAvatars.splice(_enemyAvatars.indexOf(param1),1);
      }
      
      public function loadAvatarPicture(param1:int) : void
      {
         _myAvatar.loadAvatarPicture(param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">>HeaderAvatarRenderer<< " + param1);
      }
      
      public function setAvatarMode(param1:String) : void
      {
         _myAvatar.mode = param1;
      }
      
      public function addEnemyAvatar(param1:IAvatar) : void
      {
         var _loc3_:Array = null;
         var _loc2_:Sprite = param1 as Sprite;
         if(null == _loc2_)
         {
            return;
         }
         switch(_playerCount)
         {
            case 2:
               _loc3_ = _AVATAR_POINTS_2PLAYER;
               break;
            case 3:
               _loc3_ = _AVATAR_POINTS_3PLAYER;
               break;
            case 4:
            default:
               _loc3_ = _AVATAR_POINTS_4PLAYER;
         }
         var _loc4_:Number = Number(_loc3_[_enemyAvatars.length + 1]);
         log("(addEnemyAvatar) moveTo=" + _loc4_ + " avatar.width=" + _loc2_.width + " _enemyAvatars.length=" + _enemyAvatars.length);
         log("(addEnemyAvatar) playerCount=" + _playerCount);
         _enemyAvatars.push(param1);
         _loc2_.x = 1024;
         _enemyAvatarsContainer.addChild(_loc2_);
         Tweener.addTween(param1,{
            "x":_loc4_,
            "time":1,
            "delay":3,
            "transition":"easeOutQuad"
         });
      }
      
      public function getAvatarByPlayerID(param1:int) : IAvatar
      {
         if(param1 == _myAvatar.playerID)
         {
            return _myAvatar;
         }
         log("getAvatarByPlayerID() - _enemyAvatars.lengh: " + _enemyAvatars.length);
         var _loc2_:int = 0;
         while(_loc2_ < _enemyAvatars.length)
         {
            log("getAvatarByPlayerID() - enemyAvatar.playerID: " + _enemyAvatars[_loc2_].playerID);
            if(_enemyAvatars[_loc2_].playerID == param1)
            {
               return IAvatar(_enemyAvatars[_loc2_]);
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setPlayerNanocash(param1:int) : void
      {
         _myAvatar.nanocash = param1;
      }
      
      public function get myAvatar() : IAvatar
      {
         return _myAvatar;
      }
      
      public function setAvatarStatus(param1:String) : void
      {
         _myAvatar.status = param1;
      }
      
      public function createAvatar(param1:int, param2:int, param3:int, param4:DisplayObjectContainer) : void
      {
         _myAvatar = new Avatar(_avatarAssetRetriever);
         _myAvatar.playerID = param1;
         _myAvatar.loadAvatarPicture(param2);
         (_myAvatar as DisplayObject).y = param3;
         (_myAvatar as Avatar).mcSlider.gotoAndStop("masked");
         param4.addChild(_myAvatar as DisplayObject);
         param4.setChildIndex(_enemyAvatarsContainer,param4.numChildren - 1);
         _myAvatar.nmp = 100000;
         _myAvatar.nanocash = 2041;
      }
      
      public function setPlayerNMP(param1:int) : void
      {
         _myAvatar.nmp = param1;
      }
   }
}

