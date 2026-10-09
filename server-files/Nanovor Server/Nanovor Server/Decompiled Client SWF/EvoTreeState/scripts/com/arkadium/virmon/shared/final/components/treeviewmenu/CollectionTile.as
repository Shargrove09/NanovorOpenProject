package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.common.StatsDisplayInfo;
   import com.arkadium.virmon.framework.asset.enum.CharacterWidgetAssetType;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.effects.GlowDistort;
   import com.arkadium.virmon.shared.elements.icons.NanoscopeIcon;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class CollectionTile extends MovieClip implements IChainLoadee
   {
      
      public static const WIDTH:int = 68;
      
      public static const HEIGHT:int = 79;
      
      private static const MAX_NANOVOR_WIDTH:int = 68;
      
      private static const MAX_NANOVOR_HEIGHT:int = 65;
      
      private static const NANOVOR_ORIGIN:Point = new Point(0,15);
      
      private static const NANOSCOPE_ICON_SCALE:Number = 0.07;
      
      private static const NANOSCOPE_ICON_X:int = 55;
      
      private static const NANOSCOPE_ICON_Y:int = 18;
      
      private static var _iconAssetCache:Dictionary = new Dictionary();
      
      private var _bmdSource:BitmapData;
      
      private var nanovorLoader:Loader;
      
      public var tfName:TextField;
      
      private var faction:String;
      
      private var factionColor:uint;
      
      public var tfStatValue:TextField;
      
      public var tfStatLabel:TextField;
      
      private var mcNanovor:MovieClip;
      
      private var nanoscopeIcon:NanoscopeIcon;
      
      private var nanovorIcon:GlowDistort;
      
      public var mcChevron:MovieClip;
      
      private var _loadeeName:String;
      
      public var tfNew:TextField;
      
      private var isFacingRight:Boolean = false;
      
      public var mcBG:MovieClip;
      
      private var isSelected:Boolean = false;
      
      private var currentStat:String;
      
      private var timedROTimer:Timer;
      
      private var _chainLoader:IChainLoader;
      
      private var _treeId:int;
      
      private var tileData:Object;
      
      public function CollectionTile(param1:Object)
      {
         super();
         tileData = param1;
         tfStatValue.autoSize = TextFieldAutoSize.RIGHT;
         tfStatLabel.autoSize = TextFieldAutoSize.LEFT;
         mcChevron.gotoAndStop(1);
         mcChevron.visible = false;
         buttonMode = true;
         useHandCursor = true;
         mouseEnabled = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         setTileData();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function enable() : void
      {
         if(!isSelected)
         {
            buttonMode = true;
            useHandCursor = true;
            mouseEnabled = true;
         }
      }
      
      public function startTimedRollOver(param1:int) : void
      {
         onOver();
         if(!timedROTimer)
         {
            timedROTimer = new Timer(param1,1);
         }
         timedROTimer.addEventListener(TimerEvent.TIMER,stopTimedRollOver);
         timedROTimer.start();
      }
      
      private function stopTimedRollOver(param1:TimerEvent) : void
      {
         timedROTimer.stop();
         timedROTimer.removeEventListener(TimerEvent.TIMER,stopTimedRollOver);
         onOut();
      }
      
      private function setTileData() : void
      {
         _loadeeName = "CollectionTile" + tileData.nanovor.assetId;
         tfName.text = tileData.nanovor.nickName.toUpperCase();
         _treeId = tileData.treeId;
         if(tileData.nanovor.nickName == "")
         {
            tfName.text = "";
         }
         faction = tileData.nanovor.faction.toLowerCase();
         switch(faction)
         {
            case NanovorFaction.MAGNAMOD.toLowerCase():
               factionColor = ColorMap.FACTION_MAGNAMOD;
               break;
            case NanovorFaction.VELOCITRON.toLowerCase():
               factionColor = ColorMap.FACTION_VELOCITRON;
               break;
            case NanovorFaction.HEXITE.toLowerCase():
               factionColor = ColorMap.FACTION_HEXITE;
         }
         createNanoscopeIcon();
      }
      
      override public function get name() : String
      {
         return _loadeeName;
      }
      
      public function hideNanoscopeIcon() : void
      {
         nanoscopeIcon.visible = false;
      }
      
      private function createNanovorIcon(param1:DisplayObject) : GlowDistort
      {
         _bmdSource = new BitmapData(param1.width,param1.height,true,0);
         _bmdSource.draw(param1);
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(new Bitmap(_bmdSource));
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(new Bitmap(_bmdSource));
         return new GlowDistort(_loc2_,_loc3_,factionColor);
      }
      
      public function changeCurrentStat(param1:String) : void
      {
         switch(param1)
         {
            case StatsDisplayInfo.SWARMVALUE:
               tfStatValue.text = tileData.nanovor.swarmValue;
               tfStatLabel.text = StatsDisplayInfo.SWARMVALUE_LABEL;
               tfStatLabel.textColor = StatsDisplayInfo.SWARMVALUE_COLOR;
               break;
            case StatsDisplayInfo.SPEED:
               tfStatValue.text = tileData.nanovor.speed;
               tfStatLabel.text = StatsDisplayInfo.SPEED_LABEL;
               tfStatLabel.textColor = StatsDisplayInfo.SPEED_COLOR;
               break;
            case StatsDisplayInfo.ARMOR:
               tfStatValue.text = tileData.nanovor.armor;
               tfStatLabel.text = StatsDisplayInfo.ARMOR_LABEL;
               tfStatLabel.textColor = StatsDisplayInfo.ARMOR_COLOR;
               break;
            case StatsDisplayInfo.STRENGTH:
               tfStatValue.text = tileData.nanovor.strength;
               tfStatLabel.text = StatsDisplayInfo.STRENGTH_LABEL;
               tfStatLabel.textColor = StatsDisplayInfo.STRENGTH_COLOR;
               break;
            case StatsDisplayInfo.HEALTH:
               tfStatValue.text = tileData.nanovor.health;
               tfStatLabel.text = StatsDisplayInfo.HEALTH_LABEL;
               tfStatLabel.textColor = StatsDisplayInfo.HEALTH_COLOR;
         }
         currentStat = param1;
         tfStatLabel.x = mcBG.width - (tfStatLabel.textWidth + 5);
         tfStatValue.x = tfStatLabel.x - (tfStatValue.textWidth + 4);
      }
      
      public function get nanovor() : INanovor
      {
         return tileData.nanovor;
      }
      
      private function createNanoscopeIcon() : void
      {
         nanoscopeIcon = new NanoscopeIcon();
         nanoscopeIcon.scaleX = (isFacingRight ? -1 : 1) * NANOSCOPE_ICON_SCALE;
         nanoscopeIcon.scaleY = NANOSCOPE_ICON_SCALE;
         nanoscopeIcon.x = NANOSCOPE_ICON_X;
         nanoscopeIcon.y = NANOSCOPE_ICON_Y;
         nanoscopeIcon.color = factionColor;
         addChild(nanoscopeIcon);
         hideNanoscopeIcon();
      }
      
      public function updateNanovor(param1:INanovor) : void
      {
         tileData.nanovor = param1;
         setTileData();
         changeCurrentStat(currentStat);
      }
      
      public function simulateRollOver() : void
      {
         this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,false));
      }
      
      public function showNanoscopeIcon() : void
      {
         nanoscopeIcon.visible = true;
      }
      
      public function deselect() : void
      {
         isSelected = false;
         nanovorIcon.disable();
         enable();
         hideNanoscopeIcon();
      }
      
      public function faceRight(param1:Boolean = true) : void
      {
         isFacingRight = param1;
         nanovor.isFacingRight = param1;
      }
      
      public function simulateClick() : void
      {
         this.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false));
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<CollectionTile>> ERROR\t" + param1);
      }
      
      private function onNanovorLoadComplete(param1:Event) : void
      {
         nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
         mcNanovor = MovieClip(param1.target.content);
         mcNanovor.getChildAt(0).x = mcNanovor.getChildAt(0).x + 40;
         mcNanovor.getChildAt(0).y = mcNanovor.getChildAt(0).y + 40;
         _iconAssetCache[tileData.nanovor.assetTypeId] = mcNanovor;
         treatLoadedIcon();
      }
      
      private function onNanovorLoadError(param1:IOErrorEvent) : void
      {
         nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
         disable();
         logError("onNanovorLoadError [tileData.nanovor=" + tileData.nanovor + "]: " + param1.text);
         _chainLoader.handleChainLoadeeError();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<CollectionTile>>\t" + param1);
      }
      
      private function resizeNanovor() : void
      {
         if(nanovorIcon.width >= nanovorIcon.height)
         {
            nanovorIcon.width = MAX_NANOVOR_WIDTH;
            nanovorIcon.scaleY = nanovorIcon.scaleX;
            nanovorIcon.scaleX = (isFacingRight ? -1 : 1) * nanovorIcon.scaleX;
         }
         else
         {
            nanovorIcon.height = MAX_NANOVOR_HEIGHT;
            nanovorIcon.scaleX = (isFacingRight ? -1 : 1) * nanovorIcon.scaleY;
         }
         nanovorIcon.x = NANOVOR_ORIGIN.x + (MAX_NANOVOR_WIDTH - (isFacingRight ? -1 : 1) * nanovorIcon.width) / 2;
         nanovorIcon.y = NANOVOR_ORIGIN.y + (MAX_NANOVOR_HEIGHT - nanovorIcon.height) / 2;
      }
      
      private function onOver(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         if(!isSelected)
         {
            mcChevron.visible = true;
            mcChevron.gotoAndPlay(1);
            if(param1 != null)
            {
               _loc2_ = new Object();
               _loc2_.nanovor = tileData.nanovor;
               dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.COLLECTIONTILE_ROLLOVER,_loc2_,true));
            }
         }
      }
      
      public function get treeId() : int
      {
         return _treeId;
      }
      
      private function loadNanovor(param1:int) : void
      {
         nanovorLoader = new Loader();
         nanovorLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onNanovorLoadComplete,false,0,true);
         nanovorLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError,false,0,true);
         var _loc2_:String = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterWidgetURL(CharacterWidgetAssetType.IDLE,param1).url;
         nanovorLoader.load(new URLRequest(_loc2_));
      }
      
      public function load() : void
      {
         if(mcNanovor == null)
         {
            if(_iconAssetCache[tileData.nanovor.assetTypeId] == null)
            {
               loadNanovor(tileData.nanovor.assetTypeId);
            }
            else
            {
               mcNanovor = _iconAssetCache[tileData.nanovor.assetTypeId];
               treatLoadedIcon();
            }
         }
         tfNew.visible = tileData.isNew;
      }
      
      private function treatLoadedIcon() : void
      {
         nanovorIcon = createNanovorIcon(mcNanovor);
         addChild(nanovorIcon);
         resizeNanovor();
         if(isSelected)
         {
            select();
         }
         if(Boolean(_chainLoader))
         {
            _chainLoader.handleChainLoadeeComplete();
         }
         _chainLoader = null;
      }
      
      public function disable() : void
      {
         buttonMode = false;
         useHandCursor = false;
         mouseEnabled = false;
      }
      
      private function onClick(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         if(!isSelected)
         {
            select();
            _loc2_ = new Object();
            _loc2_.nanovor = tileData.nanovor;
            dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.COLLECTIONTILE_CLICK,_loc2_,true));
         }
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         if(!isSelected)
         {
            mcChevron.gotoAndStop(1);
            mcChevron.visible = false;
            if(param1 != null)
            {
               _loc2_ = new Object();
               _loc2_.nanovor = tileData.nanovor;
               dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.COLLECTIONTILE_ROLLOUT,_loc2_,true));
            }
         }
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         removeEventListener(MouseEvent.CLICK,onClick);
         if(null != _bmdSource)
         {
            _bmdSource.dispose();
         }
         if(null != _chainLoader)
         {
            _chainLoader = null;
         }
      }
      
      public function select() : void
      {
         isSelected = true;
         if(!nanovorIcon)
         {
            return;
         }
         mcChevron.gotoAndStop(1);
         mcChevron.visible = false;
         nanovorIcon.enable();
         disable();
      }
   }
}

