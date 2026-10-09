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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol482")]
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
         this.tileData = param1;
         this.tfStatValue.autoSize = TextFieldAutoSize.RIGHT;
         this.tfStatLabel.autoSize = TextFieldAutoSize.LEFT;
         this.mcChevron.gotoAndStop(1);
         this.mcChevron.visible = false;
         buttonMode = true;
         useHandCursor = true;
         mouseEnabled = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
         addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.setTileData();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         this._chainLoader = param1;
      }
      
      public function enable() : void
      {
         if(!this.isSelected)
         {
            buttonMode = true;
            useHandCursor = true;
            mouseEnabled = true;
         }
      }
      
      public function startTimedRollOver(param1:int) : void
      {
         this.onOver();
         if(!this.timedROTimer)
         {
            this.timedROTimer = new Timer(param1,1);
         }
         this.timedROTimer.addEventListener(TimerEvent.TIMER,this.stopTimedRollOver);
         this.timedROTimer.start();
      }
      
      private function stopTimedRollOver(param1:TimerEvent) : void
      {
         this.timedROTimer.stop();
         this.timedROTimer.removeEventListener(TimerEvent.TIMER,this.stopTimedRollOver);
         this.onOut();
      }
      
      private function setTileData() : void
      {
         this._loadeeName = "CollectionTile" + this.tileData.nanovor.assetId;
         this.tfName.text = this.tileData.nanovor.nickName.toUpperCase();
         this._treeId = this.tileData.treeId;
         if(this.tileData.nanovor.nickName == "")
         {
            this.tfName.text = "";
         }
         this.faction = this.tileData.nanovor.faction.toLowerCase();
         switch(this.faction)
         {
            case NanovorFaction.MAGNAMOD.toLowerCase():
               this.factionColor = ColorMap.FACTION_MAGNAMOD;
               break;
            case NanovorFaction.VELOCITRON.toLowerCase():
               this.factionColor = ColorMap.FACTION_VELOCITRON;
               break;
            case NanovorFaction.HEXITE.toLowerCase():
               this.factionColor = ColorMap.FACTION_HEXITE;
         }
         this.createNanoscopeIcon();
      }
      
      override public function get name() : String
      {
         return this._loadeeName;
      }
      
      public function hideNanoscopeIcon() : void
      {
         this.nanoscopeIcon.visible = false;
      }
      
      private function createNanovorIcon(param1:DisplayObject) : GlowDistort
      {
         this._bmdSource = new BitmapData(param1.width,param1.height,true,0);
         this._bmdSource.draw(param1);
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(new Bitmap(this._bmdSource));
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(new Bitmap(this._bmdSource));
         return new GlowDistort(_loc2_,_loc3_,this.factionColor);
      }
      
      public function changeCurrentStat(param1:String) : void
      {
         switch(param1)
         {
            case StatsDisplayInfo.SWARMVALUE:
               this.tfStatValue.text = this.tileData.nanovor.swarmValue;
               this.tfStatLabel.text = StatsDisplayInfo.SWARMVALUE_LABEL;
               this.tfStatLabel.textColor = StatsDisplayInfo.SWARMVALUE_COLOR;
               break;
            case StatsDisplayInfo.SPEED:
               this.tfStatValue.text = this.tileData.nanovor.speed;
               this.tfStatLabel.text = StatsDisplayInfo.SPEED_LABEL;
               this.tfStatLabel.textColor = StatsDisplayInfo.SPEED_COLOR;
               break;
            case StatsDisplayInfo.ARMOR:
               this.tfStatValue.text = this.tileData.nanovor.armor;
               this.tfStatLabel.text = StatsDisplayInfo.ARMOR_LABEL;
               this.tfStatLabel.textColor = StatsDisplayInfo.ARMOR_COLOR;
               break;
            case StatsDisplayInfo.STRENGTH:
               this.tfStatValue.text = this.tileData.nanovor.strength;
               this.tfStatLabel.text = StatsDisplayInfo.STRENGTH_LABEL;
               this.tfStatLabel.textColor = StatsDisplayInfo.STRENGTH_COLOR;
               break;
            case StatsDisplayInfo.HEALTH:
               this.tfStatValue.text = this.tileData.nanovor.health;
               this.tfStatLabel.text = StatsDisplayInfo.HEALTH_LABEL;
               this.tfStatLabel.textColor = StatsDisplayInfo.HEALTH_COLOR;
         }
         this.currentStat = param1;
         this.tfStatLabel.x = this.mcBG.width - (this.tfStatLabel.textWidth + 5);
         this.tfStatValue.x = this.tfStatLabel.x - (this.tfStatValue.textWidth + 4);
      }
      
      public function get nanovor() : INanovor
      {
         return this.tileData.nanovor;
      }
      
      private function createNanoscopeIcon() : void
      {
         this.nanoscopeIcon = new NanoscopeIcon();
         this.nanoscopeIcon.scaleX = (this.isFacingRight ? -1 : 1) * NANOSCOPE_ICON_SCALE;
         this.nanoscopeIcon.scaleY = NANOSCOPE_ICON_SCALE;
         this.nanoscopeIcon.x = NANOSCOPE_ICON_X;
         this.nanoscopeIcon.y = NANOSCOPE_ICON_Y;
         this.nanoscopeIcon.color = this.factionColor;
         addChild(this.nanoscopeIcon);
         this.hideNanoscopeIcon();
      }
      
      public function updateNanovor(param1:INanovor) : void
      {
         this.tileData.nanovor = param1;
         this.setTileData();
         this.changeCurrentStat(this.currentStat);
      }
      
      public function simulateRollOver() : void
      {
         this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,false));
      }
      
      public function showNanoscopeIcon() : void
      {
         this.nanoscopeIcon.visible = true;
      }
      
      public function deselect() : void
      {
         this.isSelected = false;
         this.nanovorIcon.disable();
         this.enable();
         this.hideNanoscopeIcon();
      }
      
      public function faceRight(param1:Boolean = true) : void
      {
         this.isFacingRight = param1;
         this.nanovor.isFacingRight = param1;
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
         this.nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onNanovorLoadComplete);
         this.nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onNanovorLoadError);
         this.mcNanovor = MovieClip(param1.target.content);
         this.mcNanovor.getChildAt(0).x = this.mcNanovor.getChildAt(0).x + 40;
         this.mcNanovor.getChildAt(0).y = this.mcNanovor.getChildAt(0).y + 40;
         _iconAssetCache[this.tileData.nanovor.assetTypeId] = this.mcNanovor;
         this.treatLoadedIcon();
      }
      
      private function onNanovorLoadError(param1:IOErrorEvent) : void
      {
         this.nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onNanovorLoadComplete);
         this.nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onNanovorLoadError);
         this.disable();
         this.logError("onNanovorLoadError [tileData.nanovor=" + this.tileData.nanovor + "]: " + param1.text);
         this._chainLoader.handleChainLoadeeError();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<CollectionTile>>\t" + param1);
      }
      
      private function resizeNanovor() : void
      {
         if(this.nanovorIcon.width >= this.nanovorIcon.height)
         {
            this.nanovorIcon.width = MAX_NANOVOR_WIDTH;
            this.nanovorIcon.scaleY = this.nanovorIcon.scaleX;
            this.nanovorIcon.scaleX = (this.isFacingRight ? -1 : 1) * this.nanovorIcon.scaleX;
         }
         else
         {
            this.nanovorIcon.height = MAX_NANOVOR_HEIGHT;
            this.nanovorIcon.scaleX = (this.isFacingRight ? -1 : 1) * this.nanovorIcon.scaleY;
         }
         this.nanovorIcon.x = NANOVOR_ORIGIN.x + (MAX_NANOVOR_WIDTH - (this.isFacingRight ? -1 : 1) * this.nanovorIcon.width) / 2;
         this.nanovorIcon.y = NANOVOR_ORIGIN.y + (MAX_NANOVOR_HEIGHT - this.nanovorIcon.height) / 2;
      }
      
      private function onOver(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         if(!this.isSelected)
         {
            this.mcChevron.visible = true;
            this.mcChevron.gotoAndPlay(1);
            if(param1 != null)
            {
               _loc2_ = new Object();
               _loc2_.nanovor = this.tileData.nanovor;
               dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.COLLECTIONTILE_ROLLOVER,_loc2_,true));
            }
         }
      }
      
      public function get treeId() : int
      {
         return this._treeId;
      }
      
      private function loadNanovor(param1:int) : void
      {
         this.nanovorLoader = new Loader();
         this.nanovorLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onNanovorLoadComplete,false,0,true);
         this.nanovorLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onNanovorLoadError,false,0,true);
         var _loc2_:String = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterWidgetURL(CharacterWidgetAssetType.IDLE,param1).url;
         this.nanovorLoader.load(new URLRequest(_loc2_));
      }
      
      public function load() : void
      {
         if(this.mcNanovor == null)
         {
            if(_iconAssetCache[this.tileData.nanovor.assetTypeId] == null)
            {
               this.loadNanovor(this.tileData.nanovor.assetTypeId);
            }
            else
            {
               this.mcNanovor = _iconAssetCache[this.tileData.nanovor.assetTypeId];
               this.treatLoadedIcon();
            }
         }
         this.tfNew.visible = this.tileData.isNew;
      }
      
      private function treatLoadedIcon() : void
      {
         this.nanovorIcon = this.createNanovorIcon(this.mcNanovor);
         addChild(this.nanovorIcon);
         this.resizeNanovor();
         if(this.isSelected)
         {
            this.select();
         }
         if(Boolean(this._chainLoader))
         {
            this._chainLoader.handleChainLoadeeComplete();
         }
         this._chainLoader = null;
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
         if(!this.isSelected)
         {
            this.select();
            _loc2_ = new Object();
            _loc2_.nanovor = this.tileData.nanovor;
            dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.COLLECTIONTILE_CLICK,_loc2_,true));
         }
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         if(!this.isSelected)
         {
            this.mcChevron.gotoAndStop(1);
            this.mcChevron.visible = false;
            if(param1 != null)
            {
               _loc2_ = new Object();
               _loc2_.nanovor = this.tileData.nanovor;
               dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.COLLECTIONTILE_ROLLOUT,_loc2_,true));
            }
         }
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         removeEventListener(MouseEvent.CLICK,this.onClick);
         if(null != this._bmdSource)
         {
            this._bmdSource.dispose();
         }
         if(null != this._chainLoader)
         {
            this._chainLoader = null;
         }
      }
      
      public function select() : void
      {
         this.isSelected = true;
         if(!this.nanovorIcon)
         {
            return;
         }
         this.mcChevron.gotoAndStop(1);
         this.mcChevron.visible = false;
         this.nanovorIcon.enable();
         this.disable();
      }
   }
}

