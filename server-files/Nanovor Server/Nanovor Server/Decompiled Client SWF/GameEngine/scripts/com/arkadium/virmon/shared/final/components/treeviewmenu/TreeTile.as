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
         txNone.visible = false;
         position = param2;
         tileData = param1;
         mcAlert = new AlertBubble();
         mcAlert.x = 45;
         mcAlert.y = 8;
         addChild(mcAlert);
         setTileData();
         mcChevron.gotoAndStop(1);
         mcChevron.visible = false;
         mcBG.visible = false;
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
      }
      
      public function select() : void
      {
         isSelected = true;
         mcBG.visible = true;
         mcFrame.gotoAndPlay("over");
         tfTreeName.textColor = ColorMap.TREETILE_LABEL_OVER;
         if(!mcNanovor)
         {
            return;
         }
         mcNanovor.visible = false;
         nanovorIcon.visible = true;
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
      
      private function setFrameColor() : void
      {
         var _loc1_:Color = new Color();
         _loc1_.color = frameColor;
         mcFrame.transform.colorTransform = _loc1_;
      }
      
      private function setTileData() : void
      {
         hasMembers = tileData.hasMembers;
         faction = tileData.nanovor.faction.toLowerCase();
         switch(faction)
         {
            case NanovorFaction.MAGNAMOD.toLowerCase():
               mcFaction.addChild(new FactionMagnamod());
               factionColor = ColorMap.FACTION_MAGNAMOD;
               frameColor = ColorMap.TREETILE_FRAME_MAGNAMOD;
               bgColor = ColorMap.TREETILE_BG_MAGNAMOD;
               break;
            case NanovorFaction.VELOCITRON.toLowerCase():
               mcFaction.addChild(new FactionVelocitron());
               factionColor = ColorMap.FACTION_VELOCITRON;
               frameColor = ColorMap.TREETILE_FRAME_VELOCITRON;
               bgColor = ColorMap.TREETILE_BG_VELOCITRON;
               break;
            case NanovorFaction.HEXITE.toLowerCase():
               mcFaction.addChild(new FactionHexite());
               factionColor = ColorMap.FACTION_HEXITE;
               frameColor = ColorMap.TREETILE_FRAME_HEXITE;
               bgColor = ColorMap.TREETILE_BG_HEXITE;
         }
         setName(tileData.name);
         setFrameColor();
         setBGColor();
         if(hasMembers || _allowEmptyTreeSelect)
         {
            enableButton();
            loadNanovor(tileData.nanovor.assetTypeId);
         }
         setAlertBubble(tileData.totalNew);
      }
      
      private function setName(param1:String) : void
      {
         tfTreeName.text = param1;
         tfTreeName.textColor = ColorMap.TREETILE_LABEL_UP;
         if(!hasMembers)
         {
            txNone.visible = true;
            txNone.textColor = factionColor;
         }
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         var dataObj:Object = null;
         var me:MouseEvent = param1;
         try
         {
            if(!isSelected)
            {
               if(hasMembers || _allowEmptyTreeSelect)
               {
                  mcChevron.visible = false;
                  mcChevron.gotoAndStop(1);
                  mcBG.visible = false;
                  mcFrame.gotoAndPlay("up");
                  tfTreeName.textColor = ColorMap.TREETILE_LABEL_UP;
                  dataObj = new Object();
                  dataObj.tile = this;
                  dataObj.posID = position;
                  dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.TREETILE_ROLLOUT,dataObj,true));
                  if(!mcNanovor)
                  {
                     return;
                  }
                  mcNanovor.visible = true;
                  nanovorIcon.visible = false;
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
         _loc1_.color = bgColor;
         mcBG.transform.colorTransform = _loc1_;
      }
      
      public function getHasMembers() : Boolean
      {
         return tileData.hasMembers;
      }
      
      private function createNanovorIcon(param1:DisplayObject) : GlowDistort
      {
         _bmdSource = new BitmapData(param1.width,param1.height,true,0);
         _bmdSource.draw(param1);
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(new Bitmap(_bmdSource));
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(new Bitmap(_bmdSource));
         var _loc4_:GlowDistort = new GlowDistort(_loc2_,_loc3_,factionColor);
         _loc4_.enable();
         return _loc4_;
      }
      
      private function onNanovorLoadError(param1:IOErrorEvent) : void
      {
         logError("onNanovorLoadError() [tileData.nanovor=" + tileData.nanovor + "]: " + param1.text);
         nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
      }
      
      private function onNanovorLoadComplete(param1:Event) : void
      {
         nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
         mcNanovor = MovieClip(param1.target.content);
         mcNanovorContainer.addChild(mcNanovor);
         mcNanovor.getChildAt(0).x = mcNanovor.getChildAt(0).x + 40;
         mcNanovor.getChildAt(0).y = mcNanovor.getChildAt(0).y + 40;
         applyNanovorTint();
         nanovorIcon = createNanovorIcon(mcNanovor);
         mcNanovorContainer.addChild(nanovorIcon);
         nanovorIcon.visible = false;
         resizeNanovor();
         resizeNanovorIcon();
         if(_allowEmptyTreeSelect && !hasMembers)
         {
            mcNanovor.alpha = 0.3;
            nanovorIcon.alpha = 0.3;
         }
         if(isSelected)
         {
            select();
         }
      }
      
      public function get isAllowEmptyTreeSelect() : Boolean
      {
         return _allowEmptyTreeSelect;
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
         addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
      }
      
      public function getPosition() : int
      {
         return position;
      }
      
      public function deselect() : void
      {
         isSelected = false;
         mcBG.visible = false;
         mcFrame.gotoAndPlay("up");
         tfTreeName.textColor = ColorMap.TREETILE_LABEL_UP;
         if(!mcNanovor)
         {
            return;
         }
         mcNanovor.visible = true;
         nanovorIcon.visible = false;
      }
      
      private function setAlertBubble(param1:int) : void
      {
         if(param1 > 0)
         {
            mcAlert.number = param1;
         }
         else
         {
            mcAlert.visible = false;
         }
      }
      
      public function getTreeID() : int
      {
         return tileData.treeID;
      }
      
      public function simulateClick() : void
      {
         this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,false));
         this.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false));
      }
      
      private function resizeNanovor() : void
      {
         if(mcNanovor.width >= mcNanovor.height)
         {
            mcNanovor.width = MAX_NANOVOR_WIDTH;
            mcNanovor.scaleY = mcNanovor.scaleX;
         }
         else
         {
            mcNanovor.height = MAX_NANOVOR_HEIGHT;
            mcNanovor.scaleX = mcNanovor.scaleY;
         }
         mcNanovor.x = NANOVOR_ORIGIN.x + (MAX_NANOVOR_WIDTH - mcNanovor.width) / 2;
         mcNanovor.y = NANOVOR_ORIGIN.y + (MAX_NANOVOR_HEIGHT - mcNanovor.height) / 2;
      }
      
      private function onOver(param1:MouseEvent = null) : void
      {
         var dataObj:Object = null;
         var me:MouseEvent = param1;
         try
         {
            if(!isSelected)
            {
               if(hasMembers || _allowEmptyTreeSelect)
               {
                  mcChevron.visible = true;
                  mcChevron.gotoAndPlay("loop");
                  mcBG.visible = true;
                  mcFrame.gotoAndPlay("over");
                  tfTreeName.textColor = ColorMap.TREETILE_LABEL_OVER;
                  dataObj = new Object();
                  dataObj.tile = this;
                  dataObj.posID = position;
                  dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.TREETILE_ROLLOVER,dataObj,true));
                  if(!mcNanovor)
                  {
                     return;
                  }
                  mcNanovor.visible = false;
                  nanovorIcon.visible = true;
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
         nanovorLoader = new Loader();
         nanovorLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onNanovorLoadComplete,false,0,true);
         nanovorLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError,false,0,true);
         var _loc2_:String = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterWidgetURL(CharacterWidgetAssetType.IDLE,param1).url;
         nanovorLoader.load(new URLRequest(_loc2_));
      }
      
      private function onClick(param1:MouseEvent = null) : void
      {
         var dataObj:Object = null;
         var me:MouseEvent = param1;
         try
         {
            if(!isSelected)
            {
               if(hasMembers || _allowEmptyTreeSelect)
               {
                  isSelected = true;
                  mcChevron.gotoAndStop(1);
                  mcChevron.visible = false;
                  dataObj = new Object();
                  dataObj.faction = tileData.nanovor.faction.toLowerCase();
                  dataObj.tile = this;
                  dataObj.posID = position;
                  dataObj.treeID = tileData.treeID;
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
         if(!hasMembers)
         {
            _allowEmptyTreeSelect = true;
            txNone.visible = false;
            enableButton();
            loadNanovor(tileData.nanovor.assetTypeId);
         }
      }
      
      public function get posID() : int
      {
         return position;
      }
      
      private function applyNanovorTint() : void
      {
         var _loc1_:Color = new Color();
         _loc1_.setTint(factionColor,1);
         mcNanovor.transform.colorTransform = _loc1_;
      }
      
      public function get tileFactionColor() : uint
      {
         return factionColor;
      }
      
      private function resizeNanovorIcon() : void
      {
         nanovorIcon.width = mcNanovor.width;
         nanovorIcon.height = mcNanovor.height;
         nanovorIcon.x = mcNanovor.x;
         nanovorIcon.y = mcNanovor.y;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> TreeTile: " + param1);
      }
      
      private function stopTimedRollOver(param1:TimerEvent) : void
      {
         timedROTimer.stop();
         timedROTimer.removeEventListener(TimerEvent.TIMER,stopTimedRollOver);
         onOut();
      }
   }
}

