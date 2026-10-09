package com.arkadium.virmon.shared.data
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.BadgeMasterData;
   import com.arkadium.virmon.framework.EMData;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class Pedigree
   {
      
      private static var _evoCriteria:EvoCriteria;
      
      private static const DEBUG_SHOW_LOGS:Boolean = true;
      
      private static const ASSET_BADGES:String = "assetBadges";
      
      private static const ACCOUNT_BADGES:String = "accountBadges";
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _evoManager:IEvoManager;
      
      private var _evoBranches:Array;
      
      private var _userProfile:IUserProfile;
      
      private var _pedigree:Array;
      
      private var _nanovor:INanovor;
      
      private var _badgeManager:IBadgeManager;
      
      private var _emManager:IEMManager;
      
      private var _virmonData:IVirmonData;
      
      public function Pedigree(param1:INanovorFactory, param2:IEvoManager, param3:IBadgeManager, param4:IEMManager, param5:IUserProfile, param6:String)
      {
         super();
         _nanovorFactory = param1;
         _evoManager = param2;
         _badgeManager = param3;
         _emManager = param4;
         _userProfile = param5;
         _nanovor = _nanovorFactory.createNanovorInstanceById(param6);
         _virmonData = _nanovorFactory.findNanovorInstanceById(param6);
         _evoBranches = _safeEvoCriteria.getBranches(_nanovor.assetTypeId);
         buildPedigree();
      }
      
      private function getAccountBadges(param1:Array) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:BadgeMasterData = null;
         var _loc5_:IPedigreeBadge = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc4_ = _badgeManager.getAccountBadgeData(_loc3_);
            _loc5_ = new PedigreeBadge(_loc3_,Boolean(null != _badgeManager.getUserBadge(_loc3_)),trimPrereqDesc(null == _loc4_ ? "" : _loc4_.getPrereqDescription()),getAccountProgress(null == _loc4_ ? "" : _loc4_.getCriteriaVar()),null == _loc4_ ? 0 : _loc4_.getCriteriaValue());
            if(-1 == _loc5_.progress)
            {
               _loc5_.progress = 0;
            }
            if(0 == _loc5_.goal)
            {
               _loc5_.goal = 1;
            }
            if(_loc5_.isOwned)
            {
               _loc5_.progress = _loc5_.goal;
            }
            _loc2_.push(_loc5_);
         }
         return _loc2_;
      }
      
      private function getAssetBadges(param1:Array) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:BadgeMasterData = null;
         var _loc5_:IPedigreeBadge = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc4_ = _badgeManager.getAssetBadgeData(_loc3_);
            _loc5_ = new PedigreeBadge(_loc3_,Boolean(null != _virmonData.getBadgeById(_loc3_)),trimPrereqDesc(null == _loc4_ ? "" : _loc4_.getPrereqDescription()),getProgress(null == _loc4_ ? "" : _loc4_.getCriteriaVar()),null == _loc4_ ? 0 : _loc4_.getCriteriaValue());
            if(-1 == _loc5_.progress)
            {
               _loc5_.progress = 0;
            }
            if(0 == _loc5_.goal)
            {
               _loc5_.goal = 1;
            }
            if(_loc5_.isOwned)
            {
               _loc5_.progress = _loc5_.goal;
            }
            _loc2_.push(_loc5_);
         }
         return _loc2_;
      }
      
      private function getAccountProgress(param1:String) : int
      {
         switch(param1)
         {
            case "battle-count":
               return _userProfile.getBattleCount();
            case "death-count":
               return _nanovor.deathCount;
            case "hexite-kill-count":
               return _userProfile.hexiteKills;
            case "kill-count":
               return _userProfile.totalKills;
            case "magnamod-kill-count":
               return _userProfile.magnamodKills;
            case "max-damage-game":
               return _nanovor.maxDamageGame;
            case "max-damage-hit":
               return _nanovor.maxDamageHit;
            case "max-round-count":
               return _nanovor.maxRoundCount;
            case "velocitron-kill-count":
               return _userProfile.velocitronKills;
            case "win-count":
               return _userProfile.gamesWon;
            default:
               return -1;
         }
      }
      
      private function get _safeEvoCriteria() : EvoCriteria
      {
         if(_evoCriteria == null)
         {
            _evoCriteria = new EvoCriteria(_evoManager);
         }
         return _evoCriteria;
      }
      
      private function buildPedigree() : void
      {
         var _loc2_:EvoBranch = null;
         var _loc3_:INanovor = null;
         var _loc4_:IPedigreeData = null;
         _pedigree = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < _evoBranches.length)
         {
            _loc2_ = _evoBranches[_loc1_];
            if(_loc2_ != null)
            {
               if(_nanovorFactory == null)
               {
                  throw new Error("buildPedigree(): _nanovorFactory is null");
               }
               _loc3_ = _nanovorFactory.createNanovorTypeById(_loc2_.destID);
               _loc4_ = new PedigreeData(_loc2_.sourceID,_loc2_.destID,_nanovor.name,_loc3_.name,getAssetBadges(_loc2_.assetBadges),getAccountBadges(_loc2_.accountBadges),getEMReqs(_loc2_.ems));
               _pedigree.push(_loc4_);
            }
            _loc1_++;
         }
      }
      
      private function trimPrereqDesc(param1:String) : String
      {
         var _loc2_:RegExp = /Nanovor badge: /;
         param1 = param1.replace(_loc2_,"");
         _loc2_ = /Nanovor: /;
         param1 = param1.replace(_loc2_,"");
         _loc2_ = /Player badge: /;
         param1 = param1.replace(_loc2_,"");
         _loc2_ = /Player: /;
         return param1.replace(_loc2_,"");
      }
      
      private function DEBUG_PEDIGREE() : void
      {
         var _loc2_:* = undefined;
         log("=======================================================");
         log("PEDIGREE FOR " + _nanovor.name + "  (" + _nanovor.assetId + ")");
         log("=======================================================");
         var _loc1_:* = 0;
         while(_loc1_ < _pedigree.length)
         {
            log("-------------------------------------");
            log(_pedigree[_loc1_].sourceName + " --> " + _pedigree[_loc1_].destName);
            _loc2_ = 0;
            while(_loc2_ < _pedigree[_loc1_].badges.length)
            {
               log(_pedigree[_loc1_].badges[_loc2_].prereqDesc + "  (" + _pedigree[_loc1_].badges[_loc2_].progress + "/" + _pedigree[_loc1_].badges[_loc2_].goal + ")");
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function getProgress(param1:String) : int
      {
         switch(param1)
         {
            case "battle-count":
               return _nanovor.battleCount;
            case "death-count":
               return _nanovor.deathCount;
            case "hexite-kill-count":
               return _nanovor.hexiteKillCount;
            case "kill-count":
               return _nanovor.killCount;
            case "magnamod-kill-count":
               return _nanovor.magnamodKillCount;
            case "max-damage-game":
               return _nanovor.maxDamageGame;
            case "max-damage-hit":
               return _nanovor.maxDamageHit;
            case "max-round-count":
               return _nanovor.maxRoundCount;
            case "velocitron-kill-count":
               return _nanovor.velocitronKillCount;
            case "win-count":
               return _nanovor.winCount;
            default:
               return -1;
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** Pedigree: " + param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> Pedigree: " + param1);
      }
      
      private function getEMReqs(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:IPedigreeEm = null;
         var _loc6_:EMData = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = _emManager.getEMDataList();
         for each(_loc4_ in param1)
         {
            _loc5_ = new PedigreeEm(_emManager.getEMMasterData(_loc4_).getAssetTypeID(),_emManager.getEMMasterData(_loc4_).getShortName(),false);
            for each(_loc6_ in _loc3_)
            {
               if(_loc5_.id == _loc6_.getEMMasterData().getAssetTypeID())
               {
                  _loc5_.isOwned = true;
                  _loc3_.splice(_loc3_.indexOf(_loc6_),1);
                  break;
               }
            }
            _loc2_.push(_loc5_);
         }
         return _loc2_;
      }
      
      public function getPedigree() : Array
      {
         return _pedigree;
      }
   }
}

