package com.arkadium.virmon.shared.elements.viewer
{
   import caurina.transitions.*;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.ITradeGameService;
   import com.arkadium.communications.handlers.trade.IBadgeListReceivedHandler;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.events.VirmonDataEvent;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.Dictionary;
   
   public class BadgesPane extends MovieClip implements IBadgeListReceivedHandler
   {
      
      private var _iScrollerOffsetBottom:int = -30;
      
      private var _aCells:Array = new Array();
      
      public var mcScrollBar:ScrollBar;
      
      private var _szMessageNoBadges:String = "NO BADGES EARNED YET";
      
      private var _iCellsSpacingX:int = 89;
      
      private var _iCellsSpacingY:int = 92;
      
      public var mcSelectedBadgeHolder:MovieClip;
      
      private var _oVirmon:IVirmon = null;
      
      private var _iCellsNestOffsetX:int = 2;
      
      private var _iCellsNestOffsetY:int = 41;
      
      private var _aBadges:Array = new Array();
      
      private var _nCellsNestOrigY:Number;
      
      public var stfSelectedBadgeShortDesc:TextField;
      
      private var _dictVirmonBadgesCache:Dictionary = new Dictionary();
      
      public var mcCellsNest:MovieClip;
      
      private var _tradeGameService:ITradeGameService;
      
      private var _oBadgeCellSelected:BadgeCell = null;
      
      private var _szMessageLoading:String = "LOADING BADGES...";
      
      private var _iCellsNestColumns:int = 3;
      
      public var mcCellsNestMask:MovieClip;
      
      private var _iScrollerOffsetTop:int = 43;
      
      private var _iBadgesLoaded:int = 0;
      
      private var _nCellsNestMaskHeight:Number;
      
      public var stfSelectedBadgeLongDesc:TextField;
      
      public var stfSelectedBadgeTitle:TextField;
      
      private var _bUseMasterData:Boolean = false;
      
      private var _szMessageSelect:String = "SELECT BADGE TO VIEW";
      
      public function BadgesPane()
      {
         super();
         clearFields();
         mcScrollBar.visible = false;
         mcScrollBar.y = mcCellsNestMask.y + _iScrollerOffsetTop;
         _nCellsNestOrigY = mcCellsNest.y;
         _nCellsNestMaskHeight = mcCellsNestMask.height;
         _tradeGameService = GameServiceProvider.getInstance().tradeGameService;
         _tradeGameService.addBadgeListReceivedHandler(IBadgeListReceivedHandler(this));
      }
      
      private function selectBadge(param1:BadgeCell) : void
      {
         var _loc2_:* = undefined;
         if(_oBadgeCellSelected !== null)
         {
            if(_oBadgeCellSelected.iBadgeId == param1.iBadgeId)
            {
               return;
            }
            _oBadgeCellSelected.selected = false;
         }
         _oBadgeCellSelected = param1;
         param1.selected = true;
         if(_bUseMasterData)
         {
            _loc2_ = DataManager.getInstance().getBadgeManager().getAssetBadgeData(param1.iBadgeId);
         }
         else
         {
            _loc2_ = DataManager.getInstance().getVirmonManager().getVirmonData(_oVirmon.getID()).getBadgeById(param1.iBadgeId);
         }
         stfSelectedBadgeTitle.text = _loc2_.getName();
         stfSelectedBadgeShortDesc.text = _loc2_.getShortDescription();
         stfSelectedBadgeLongDesc.text = _loc2_.getLongDescription();
      }
      
      public function clearCells() : *
      {
         var _loc1_:BadgeCell = null;
         _oBadgeCellSelected = null;
         var _loc2_:int = 0;
         while(_loc2_ < _aCells.length)
         {
            _loc1_ = BadgeCell(_aCells[_loc2_]);
            if(mcCellsNest.contains(_loc1_.mcHit))
            {
               mcCellsNest.removeChild(_loc1_.mcHit);
            }
            if(mcCellsNest.contains(_loc1_))
            {
               mcCellsNest.removeChild(_loc1_);
            }
            _loc1_.removeEventListener(BadgeCell.CLICK,onBadgeClick);
            _loc1_.clearListeners();
            _loc1_.clearLoaded();
            _loc2_++;
         }
         _aCells = new Array();
      }
      
      private function onBadgeRollOver(param1:Event) : void
      {
      }
      
      public function init(param1:IVirmon, param2:Array = null, param3:uint = 0, param4:* = null) : void
      {
         reset();
         _oVirmon = param1;
         if(_dictVirmonBadgesCache[_oVirmon] !== undefined)
         {
            _aBadges = _dictVirmonBadgesCache[_oVirmon];
            loadBadges();
         }
         else if(param2 !== null)
         {
            _bUseMasterData = true;
            if(param3 > 0 && param4 !== null && false)
            {
               loadBadgeListFromGameServer(param3,param4);
            }
            else
            {
               log("init: using badge list array passed to method");
               _aBadges = param2;
               loadBadges();
            }
         }
         else
         {
            loadBadgeList();
         }
      }
      
      private function loadBadgeListFromGameServer(param1:uint, param2:*) : void
      {
         _tradeGameService.getBadgeList(String(param1),String(_oVirmon.getID()));
         stfSelectedBadgeShortDesc.text = _szMessageLoading;
      }
      
      private function loadBadgeList() : void
      {
         stfSelectedBadgeShortDesc.text = _szMessageLoading;
         var _loc1_:IVirmonData = DataManager.getInstance().getVirmonManager().getVirmonData(_oVirmon.getID());
         _loc1_.addEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,onLoadBadgeListComplete,false,0,true);
         _loc1_.addEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,onLoadBadgeListError,false,0,true);
         _loc1_.loadBadges();
      }
      
      public function handleBadgeListReceived(param1:Object = null) : void
      {
         log("handleBadgeListReceived");
         var _loc2_:IBadgeManager = DataManager.getInstance().getBadgeManager();
         var _loc3_:Array = param1.badgeList.split(",");
         _aBadges = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _aBadges.push(_loc2_.getAssetBadgeData(int(_loc3_[_loc4_])));
            _loc4_++;
         }
         _dictVirmonBadgesCache[_oVirmon] = _aBadges.slice();
         loadBadges();
      }
      
      private function checkForScrollable() : void
      {
         mcScrollBar.visible = false;
         if(mcCellsNest.height >= _nCellsNestMaskHeight + 1)
         {
            mcScrollBar.visible = true;
            mcScrollBar.init(mcCellsNest,_nCellsNestMaskHeight - _iScrollerOffsetTop + _iScrollerOffsetBottom,true);
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** CVV: BadgesPane: " + param1);
      }
      
      private function onScrollMouseDown(param1:Event) : void
      {
      }
      
      private function loadBadges() : void
      {
         var oBC:BadgeCell = null;
         var mcHit:MovieClip = null;
         var iId:int = 0;
         var i:int = 0;
         _iBadgesLoaded = 0;
         if(_aBadges.length == 0)
         {
            stfSelectedBadgeShortDesc.text = _szMessageNoBadges;
            return;
         }
         i = 0;
         for(; i < _aBadges.length; i++)
         {
            try
            {
               iId = int(_aBadges[i].getID());
            }
            catch(e:Error)
            {
               logError("CHOKED on getting badge data for i=" + i + "... _aBadges[i]=" + _aBadges[i]);
               ++_iBadgesLoaded;
               continue;
            }
            oBC = mcCellsNest.addChildAt(new BadgeCell(iId,false),0) as BadgeCell;
            oBC.addEventListener(BadgeCell.LOAD_COMPLETE,onBadgeLoadComplete,false,0,true);
            oBC.addEventListener(BadgeCell.LOAD_ERROR,onBadgeLoadComplete,false,0,true);
            oBC.addEventListener(BadgeCell.CLICK,onBadgeClick,false,0,true);
            oBC.alpha = 0;
            oBC.iIndexHack = i;
            oBC.load();
            mcHit = mcCellsNest.addChild(oBC.mcHit) as MovieClip;
            mcHit.x += oBC.x = _iCellsNestOffsetX + i % _iCellsNestColumns * _iCellsSpacingX;
            mcHit.y += oBC.y = _iCellsNestOffsetY + Math.floor(i / _iCellsNestColumns) * _iCellsSpacingY;
            _aCells.push(oBC);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CVV: BadgesPane: " + param1);
      }
      
      public function reset() : void
      {
         clearCells();
         clearFields();
         if(mcScrollBar.visible)
         {
            mcScrollBar.reset();
            mcScrollBar.visible = false;
         }
         mcCellsNest.y = _nCellsNestOrigY;
      }
      
      public function clear() : *
      {
         clearCells();
         _aBadges = null;
         _aCells = null;
         _dictVirmonBadgesCache = null;
      }
      
      private function onLoadBadgeListComplete(param1:Event) : void
      {
         var _loc2_:IVirmonData = IVirmonData(param1.target);
         _loc2_.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,onLoadBadgeListComplete);
         _loc2_.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,onLoadBadgeListError);
         _aBadges = _loc2_.getBadgeList();
         _dictVirmonBadgesCache[_oVirmon] = _aBadges.slice();
         loadBadges();
      }
      
      private function onBadgeLoadComplete(param1:Event) : void
      {
         var _loc2_:BadgeCell = null;
         param1.target.removeEventListener(BadgeCell.LOAD_COMPLETE,onBadgeLoadComplete);
         param1.target.removeEventListener(BadgeCell.LOAD_ERROR,onBadgeLoadComplete);
         Tweener.addTween(param1.target,{
            "alpha":1,
            "time":0.3,
            "delay":0.02 * param1.target.iIndexHack,
            "transition":"easeOutQuad"
         });
         ++_iBadgesLoaded;
         if(_iBadgesLoaded == _aBadges.length)
         {
            stfSelectedBadgeShortDesc.text = "";
            _loc2_ = _aCells[0];
            selectBadge(_loc2_);
            checkForScrollable();
         }
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
      
      private function onLoadBadgeListError(param1:Event) : void
      {
         var _loc2_:IVirmonData = IVirmonData(param1.target);
         _loc2_.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,onLoadBadgeListComplete);
         _loc2_.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,onLoadBadgeListError);
         stfSelectedBadgeShortDesc.text = _szMessageNoBadges;
         logError("onLoadBadgeListError: " + param1);
      }
      
      private function onBadgeRollOut(param1:Event) : void
      {
      }
      
      private function onScrollMouseUp(param1:Event) : void
      {
      }
      
      private function clearFields() : void
      {
         stfSelectedBadgeTitle.text = "";
         stfSelectedBadgeShortDesc.text = _szMessageNoBadges;
         stfSelectedBadgeLongDesc.text = "";
      }
   }
}

