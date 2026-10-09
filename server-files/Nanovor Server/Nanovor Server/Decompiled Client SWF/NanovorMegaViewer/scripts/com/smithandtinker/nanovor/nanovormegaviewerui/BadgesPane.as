package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import caurina.transitions.*;
   import com.arkadium.virmon.framework.BadgeData;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.IBadgeData;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.events.VirmonDataEvent;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol151")]
   public class BadgesPane extends MovieClip
   {
      
      private var _iScrollerOffsetBottom:int = -10;
      
      private var _aCells:Array = new Array();
      
      public var mcScrollBar:ScrollBar;
      
      private var _szMessageNoBadges:String = "NO BADGES EARNED YET";
      
      private var _iCellsSpacingX:int = 89;
      
      private var _iCellsSpacingY:int = 92;
      
      public var mcSelectedBadgeHolder:MovieClip;
      
      private var _iCellsNestOffsetX:int = 2;
      
      private var _oVirmon:IVirmon = null;
      
      private var _iCellsNestOffsetY:int = 41;
      
      private var _aBadges:Array = new Array();
      
      private var _nCellsNestOrigY:Number;
      
      public var stfBoxMessage:TextField;
      
      public var stfSelectedBadgeShortDesc:TextField;
      
      private var _dictVirmonBadgesCache:Dictionary = new Dictionary();
      
      public var mcCellsNest:MovieClip;
      
      private var _oBadgeCellSelected:BadgeCell = null;
      
      private var _szMessageLoading:String = "LOADING BADGES...";
      
      private var _iCellsNestColumns:int = 3;
      
      public var mcCellsNestMask:MovieClip;
      
      private var _iScrollerOffsetTop:int = 43;
      
      private var _iBadgesLoaded:int = 0;
      
      public var mcCellsNestFade:MovieClip;
      
      public var stfSelectedBadgeLongDesc:TextField;
      
      private var _nCellsNestMaskHeight:Number;
      
      public var stfSelectedBadgeTitle:TextField;
      
      private var _szMessageSelect:String = "SELECT BADGE TO VIEW";
      
      public function BadgesPane()
      {
         super();
         clearFields();
         mcCellsNestFade.mouseEnabled = false;
         mcScrollBar.visible = false;
         mcScrollBar.y = mcCellsNestMask.y + _iScrollerOffsetTop;
         mcScrollBar.addEventListener(ScrollBar.MOUSE_DOWN,onScrollMouseDown,false,0,true);
         mcScrollBar.addEventListener(ScrollBar.MOUSE_UP,onScrollMouseUp,false,0,true);
         _nCellsNestOrigY = mcCellsNest.y;
         _nCellsNestMaskHeight = mcCellsNestMask.height;
      }
      
      private function onBadgeRollOut(param1:Event) : void
      {
      }
      
      private function selectBadge(param1:BadgeCell) : void
      {
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
         var _loc2_:IBadgeData = DataManager.getInstance().getVirmonManager().getVirmonData(_oVirmon.getID()).getBadgeById(param1.iBadgeId);
         if(Boolean(_loc2_))
         {
            stfSelectedBadgeTitle.text = _loc2_.getName();
            stfSelectedBadgeShortDesc.text = _loc2_.getShortDescription();
            stfSelectedBadgeLongDesc.text = _loc2_.getLongDescription();
         }
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
            _loc1_.removeEventListener(BadgeCell.ROLL_OVER,onBadgeRollOver);
            _loc1_.removeEventListener(BadgeCell.ROLL_OUT,onBadgeRollOut);
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
      
      public function init(param1:IVirmon) : void
      {
         reset();
         _oVirmon = param1;
         if(_dictVirmonBadgesCache[_oVirmon] !== undefined)
         {
            _aBadges = _dictVirmonBadgesCache[_oVirmon];
            loadBadges();
         }
         else
         {
            loadBadgeList();
         }
      }
      
      private function loadBadgeList() : void
      {
         stfBoxMessage.text = _szMessageLoading;
         stfBoxMessage.autoSize = TextFieldAutoSize.CENTER;
         var _loc1_:IVirmonData = DataManager.getInstance().getVirmonManager().getVirmonData(_oVirmon.getID());
         _loc1_.addEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,onLoadBadgeListComplete,false,0,true);
         _loc1_.addEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,onLoadBadgeListError,false,0,true);
         _loc1_.loadBadges();
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
         DebugLog.instance.error("** BadgesPane: " + param1);
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
            stfBoxMessage.text = _szMessageNoBadges;
            stfBoxMessage.autoSize = TextFieldAutoSize.CENTER;
            return;
         }
         i = 0;
         for(; i < _aBadges.length; i++)
         {
            try
            {
               iId = BadgeData(_aBadges[i]).getID();
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
            oBC.addEventListener(BadgeCell.ROLL_OVER,onBadgeRollOver,false,0,true);
            oBC.addEventListener(BadgeCell.ROLL_OUT,onBadgeRollOut,false,0,true);
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
         DebugLog.instance.log(">> BadgesPane: " + param1);
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
         mcScrollBar.removeEventListener(ScrollBar.MOUSE_DOWN,onScrollMouseDown);
         mcScrollBar.removeEventListener(ScrollBar.MOUSE_UP,onScrollMouseUp);
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
            _loc2_ = _aCells[0];
            selectBadge(_loc2_);
            checkForScrollable();
            stfBoxMessage.text = _szMessageSelect;
            stfBoxMessage.autoSize = TextFieldAutoSize.CENTER;
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
         stfBoxMessage.text = _szMessageNoBadges;
         stfBoxMessage.autoSize = TextFieldAutoSize.CENTER;
         logError("** NMV: BadgesPane: " + param1);
      }
      
      private function onScrollMouseUp(param1:Event) : void
      {
      }
      
      private function clearFields() : void
      {
         stfSelectedBadgeTitle.text = stfSelectedBadgeShortDesc.text = stfSelectedBadgeLongDesc.text = stfBoxMessage.text = "";
      }
   }
}

