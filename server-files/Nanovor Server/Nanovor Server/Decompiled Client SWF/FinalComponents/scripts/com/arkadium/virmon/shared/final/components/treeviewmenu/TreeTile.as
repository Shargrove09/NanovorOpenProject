package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.framework.asset.enum.CharacterWidgetAssetType;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.effects.GlowDistort;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionHexite;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionMagnamod;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionVelocitron;
   import com.arkadium.virmon.shared.final.elements.AlertBubble;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.Color;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol472")]
   public class TreeTile extends MovieClip
   {
      
      public static const WIDTH:int = 68;
      
      public static const HEIGHT:int = 80;
      
      private static const MAX_NANOVOR_WIDTH:int = 68;
      
      private static const MAX_NANOVOR_HEIGHT:int = 65;
      
      private static const NANOVOR_ORIGIN:Point = new Point(0,15);
      
      private var _bmdSource:BitmapData;
      
      public var mcNanovorContainer:MovieClip;
      
      private var nanovorLoader:Loader;
      
      private var faction:String;
      
      private var bgColor:uint;
      
      private var hasMembers:Boolean;
      
      public var mcFaction:MovieClip;
      
      private var factionColor:uint;
      
      private var position:int;
      
      private var mcNanovor:MovieClip;
      
      private var _allowEmptyTreeSelect:Boolean = false;
      
      public var mcHighlight:MovieClip;
      
      public var mcChevron:MovieClip;
      
      private var nanovorIcon:GlowDistort;
      
      public var tfTreeName:TextField;
      
      public var txNone:TextField;
      
      private var isSelected:Boolean = false;
      
      public var mcAlert:AlertBubble;
      
      public var mcBG:MovieClip;
      
      private var frameColor:uint;
      
      public var mcFrame:MovieClip;
      
      private var timedROTimer:Timer;
      
      private var tileData:Object;
      
      public function TreeTile(param1:Object, param2:int)
      {
         super();
         this.txNone.visible = false;
         this.position = param2;
         this.tileData = param1;
         this.mcAlert = new AlertBubble();
         this.mcAlert.x = 45;
         this.mcAlert.y = 8;
         addChild(this.mcAlert);
         this.setTileData();
         this.mcChevron.gotoAndStop(1);
         this.mcChevron.visible = false;
         this.mcBG.visible = false;
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
      }
      
      public function select() : void
      {
         this.isSelected = true;
         this.mcBG.visible = true;
         this.mcFrame.gotoAndPlay("over");
         this.tfTreeName.textColor = ColorMap.TREETILE_LABEL_OVER;
         if(!this.mcNanovor)
         {
            return;
         }
         this.mcNanovor.visible = false;
         this.nanovorIcon.visible = true;
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
      
      private function setFrameColor() : void
      {
         var _loc1_:Color = new Color();
         _loc1_.color = this.frameColor;
         this.mcFrame.transform.colorTransform = _loc1_;
      }
      
      private function setTileData() : void
      {
         this.hasMembers = this.tileData.hasMembers;
         this.faction = this.tileData.nanovor.faction.toLowerCase();
         switch(this.faction)
         {
            case NanovorFaction.MAGNAMOD.toLowerCase():
               this.mcFaction.addChild(new FactionMagnamod());
               this.factionColor = ColorMap.FACTION_MAGNAMOD;
               this.frameColor = ColorMap.TREETILE_FRAME_MAGNAMOD;
               this.bgColor = ColorMap.TREETILE_BG_MAGNAMOD;
               break;
            case NanovorFaction.VELOCITRON.toLowerCase():
               this.mcFaction.addChild(new FactionVelocitron());
               this.factionColor = ColorMap.FACTION_VELOCITRON;
               this.frameColor = ColorMap.TREETILE_FRAME_VELOCITRON;
               this.bgColor = ColorMap.TREETILE_BG_VELOCITRON;
               break;
            case NanovorFaction.HEXITE.toLowerCase():
               this.mcFaction.addChild(new FactionHexite());
               this.factionColor = ColorMap.FACTION_HEXITE;
               this.frameColor = ColorMap.TREETILE_FRAME_HEXITE;
               this.bgColor = ColorMap.TREETILE_BG_HEXITE;
         }
         this.setName(this.tileData.name);
         this.setFrameColor();
         this.setBGColor();
         if(this.hasMembers || this._allowEmptyTreeSelect)
         {
            this.enableButton();
            this.loadNanovor(this.tileData.nanovor.assetTypeId);
         }
         this.setAlertBubble(this.tileData.totalNew);
      }
      
      private function setName(param1:String) : void
      {
         this.tfTreeName.text = param1;
         this.tfTreeName.textColor = ColorMap.TREETILE_LABEL_UP;
         if(!this.hasMembers)
         {
            this.txNone.visible = true;
            this.txNone.textColor = this.factionColor;
         }
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         var dataObj:Object = null;
         var me:MouseEvent = param1;
         try
         {
            if(!this.isSelected)
            {
               if(this.hasMembers || this._allowEmptyTreeSelect)
               {
                  this.mcChevron.visible = false;
                  this.mcChevron.gotoAndStop(1);
                  this.mcBG.visible = false;
                  this.mcFrame.gotoAndPlay("up");
                  this.tfTreeName.textColor = ColorMap.TREETILE_LABEL_UP;
                  dataObj = new Object();
                  dataObj.tile = this;
                  dataObj.posID = this.position;
                  dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.TREETILE_ROLLOUT,dataObj,true));
                  if(!this.mcNanovor)
                  {
                     return;
                  }
                  this.mcNanovor.visible = true;
                  this.nanovorIcon.visible = false;
               }
            }
         }
         catch(e:Error)
         {
            logError("TreeTile.onOut ERROR: " + e.message);
         }
      }
      
      private function setBGColor() : void
      {
         var _loc1_:Color = new Color();
         _loc1_.color = this.bgColor;
         this.mcBG.transform.colorTransform = _loc1_;
      }
      
      public function getHasMembers() : Boolean
      {
         return this.tileData.hasMembers;
      }
      
      private function createNanovorIcon(param1:DisplayObject) : GlowDistort
      {
         this._bmdSource = new BitmapData(param1.width,param1.height,true,0);
         this._bmdSource.draw(param1);
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(new Bitmap(this._bmdSource));
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(new Bitmap(this._bmdSource));
         var _loc4_:GlowDistort = new GlowDistort(_loc2_,_loc3_,this.factionColor);
         _loc4_.enable();
         return _loc4_;
      }
      
      private function onNanovorLoadError(param1:IOErrorEvent) : void
      {
         this.logError("onNanovorLoadError() [tileData.nanovor=" + this.tileData.nanovor + "]: " + param1.text);
         this.nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onNanovorLoadComplete);
         this.nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onNanovorLoadError);
      }
      
      private function onNanovorLoadComplete(param1:Event) : void
      {
         this.nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onNanovorLoadComplete);
         this.nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onNanovorLoadError);
         this.mcNanovor = MovieClip(param1.target.content);
         this.mcNanovorContainer.addChild(this.mcNanovor);
         this.mcNanovor.getChildAt(0).x = this.mcNanovor.getChildAt(0).x + 40;
         this.mcNanovor.getChildAt(0).y = this.mcNanovor.getChildAt(0).y + 40;
         this.applyNanovorTint();
         this.nanovorIcon = this.createNanovorIcon(this.mcNanovor);
         this.mcNanovorContainer.addChild(this.nanovorIcon);
         this.nanovorIcon.visible = false;
         this.resizeNanovor();
         this.resizeNanovorIcon();
         if(this._allowEmptyTreeSelect && !this.hasMembers)
         {
            this.mcNanovor.alpha = 0.3;
            this.nanovorIcon.alpha = 0.3;
         }
         if(this.isSelected)
         {
            this.select();
         }
      }
      
      public function get isAllowEmptyTreeSelect() : Boolean
      {
         return this._allowEmptyTreeSelect;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** TreeTile: " + param1);
      }
      
      private function enableButton() : void
      {
         buttonMode = true;
         useHandCursor = true;
         mouseEnabled = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
         addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
      }
      
      public function getPosition() : int
      {
         return this.position;
      }
      
      public function deselect() : void
      {
         this.isSelected = false;
         this.mcBG.visible = false;
         this.mcFrame.gotoAndPlay("up");
         this.tfTreeName.textColor = ColorMap.TREETILE_LABEL_UP;
         if(!this.mcNanovor)
         {
            return;
         }
         this.mcNanovor.visible = true;
         this.nanovorIcon.visible = false;
      }
      
      private function setAlertBubble(param1:int) : void
      {
         if(param1 > 0)
         {
            this.mcAlert.number = param1;
         }
         else
         {
            this.mcAlert.visible = false;
         }
      }
      
      public function getTreeID() : int
      {
         return this.tileData.treeID;
      }
      
      public function simulateClick() : void
      {
         this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,false));
         this.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false));
      }
      
      private function resizeNanovor() : void
      {
         if(this.mcNanovor.width >= this.mcNanovor.height)
         {
            this.mcNanovor.width = MAX_NANOVOR_WIDTH;
            this.mcNanovor.scaleY = this.mcNanovor.scaleX;
         }
         else
         {
            this.mcNanovor.height = MAX_NANOVOR_HEIGHT;
            this.mcNanovor.scaleX = this.mcNanovor.scaleY;
         }
         this.mcNanovor.x = NANOVOR_ORIGIN.x + (MAX_NANOVOR_WIDTH - this.mcNanovor.width) / 2;
         this.mcNanovor.y = NANOVOR_ORIGIN.y + (MAX_NANOVOR_HEIGHT - this.mcNanovor.height) / 2;
      }
      
      private function onOver(param1:MouseEvent = null) : void
      {
         var dataObj:Object = null;
         var me:MouseEvent = param1;
         try
         {
            if(!this.isSelected)
            {
               if(this.hasMembers || this._allowEmptyTreeSelect)
               {
                  this.mcChevron.visible = true;
                  this.mcChevron.gotoAndPlay("loop");
                  this.mcBG.visible = true;
                  this.mcFrame.gotoAndPlay("over");
                  this.tfTreeName.textColor = ColorMap.TREETILE_LABEL_OVER;
                  dataObj = new Object();
                  dataObj.tile = this;
                  dataObj.posID = this.position;
                  dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.TREETILE_ROLLOVER,dataObj,true));
                  if(!this.mcNanovor)
                  {
                     return;
                  }
                  this.mcNanovor.visible = false;
                  this.nanovorIcon.visible = true;
               }
            }
         }
         catch(e:Error)
         {
            logError("TreeTile.onOver ERROR: " + e.message);
         }
      }
      
      private function loadNanovor(param1:int) : void
      {
         this.nanovorLoader = new Loader();
         this.nanovorLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onNanovorLoadComplete,false,0,true);
         this.nanovorLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onNanovorLoadError,false,0,true);
         var _loc2_:String = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterWidgetURL(CharacterWidgetAssetType.IDLE,param1).url;
         this.nanovorLoader.load(new URLRequest(_loc2_));
      }
      
      private function onClick(param1:MouseEvent = null) : void
      {
         var dataObj:Object = null;
         var me:MouseEvent = param1;
         try
         {
            if(!this.isSelected)
            {
               if(this.hasMembers || this._allowEmptyTreeSelect)
               {
                  this.isSelected = true;
                  this.mcChevron.gotoAndStop(1);
                  this.mcChevron.visible = false;
                  dataObj = new Object();
                  dataObj.faction = this.tileData.nanovor.faction.toLowerCase();
                  dataObj.tile = this;
                  dataObj.posID = this.position;
                  dataObj.treeID = this.tileData.treeID;
                  dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.TREETILE_CLICK,dataObj,true));
               }
            }
         }
         catch(e:Error)
         {
            logError("TreeTile.onClick ERROR: " + e.message);
         }
      }
      
      public function allowEmptyTreeSelect() : void
      {
         if(!this.hasMembers)
         {
            this._allowEmptyTreeSelect = true;
            this.txNone.visible = false;
            this.enableButton();
            this.loadNanovor(this.tileData.nanovor.assetTypeId);
         }
      }
      
      public function get posID() : int
      {
         return this.position;
      }
      
      private function applyNanovorTint() : void
      {
         var _loc1_:Color = new Color();
         _loc1_.setTint(this.factionColor,1);
         this.mcNanovor.transform.colorTransform = _loc1_;
      }
      
      public function get tileFactionColor() : uint
      {
         return this.factionColor;
      }
      
      private function resizeNanovorIcon() : void
      {
         this.nanovorIcon.width = this.mcNanovor.width;
         this.nanovorIcon.height = this.mcNanovor.height;
         this.nanovorIcon.x = this.mcNanovor.x;
         this.nanovorIcon.y = this.mcNanovor.y;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> TreeTile: " + param1);
      }
      
      private function stopTimedRollOver(param1:TimerEvent) : void
      {
         this.timedROTimer.stop();
         this.timedROTimer.removeEventListener(TimerEvent.TIMER,this.stopTimedRollOver);
         this.onOut();
      }
   }
}

