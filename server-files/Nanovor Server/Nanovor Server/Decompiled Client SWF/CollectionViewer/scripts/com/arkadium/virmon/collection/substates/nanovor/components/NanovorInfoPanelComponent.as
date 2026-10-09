package com.arkadium.virmon.collection.substates.nanovor.components
{
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.asset.enum.CharacterWidgetAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionHexite;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionMagnamod;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionVelocitron;
   import com.arkadium.virmon.shared.final.components.infowindow.InfoWindowTitle;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.Color;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol67")]
   public class NanovorInfoPanelComponent extends MovieClip
   {
      
      private static const MAX_NANOVOR_WIDTH:int = 60;
      
      private static const MAX_NANOVOR_HEIGHT:int = 60;
      
      private static const NANOVOR_ORIGIN:Point = new Point(5,10);
      
      private static const NAME_INPUT_POSITION:Point = new Point(52,43);
      
      public var viewField:TextField;
      
      protected var _startY:int = 76;
      
      public var silhouette:MovieClip;
      
      private var nanovorLoader:Loader;
      
      public var mcMask:MovieClip;
      
      private var szTree:String;
      
      public var mcFaction:MovieClip;
      
      public var infoWindowTitleContainer:MovieClip;
      
      private var mcNanovor:MovieClip;
      
      private var _infoWindowTitle:InfoWindowTitle;
      
      protected var _virmonData:IVirmonData;
      
      public var nameField:TextField;
      
      public function NanovorInfoPanelComponent()
      {
         super();
         mcMask.visible = false;
         _infoWindowTitle = new InfoWindowTitle();
         infoWindowTitleContainer.addChild(_infoWindowTitle);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorInfoPanelComponent: " + param1);
      }
      
      private function onNameChanged(param1:CustomEvent) : void
      {
         var _loc2_:IVirmonData = IVirmonData(param1.data.virmon);
         setNanovor(_loc2_,szTree);
      }
      
      public function setFaction(param1:String) : void
      {
         var _loc2_:Sprite = null;
         while(mcFaction.numChildren > 0)
         {
            mcFaction.removeChildAt(0);
         }
         switch(param1)
         {
            case Icon.FACTION_MAGNAMOD:
               _loc2_ = new FactionMagnamod();
               break;
            case Icon.FACTION_VELOCITRON:
               _loc2_ = new FactionVelocitron();
               break;
            case Icon.FACTION_HEXITE:
               _loc2_ = new FactionHexite();
               break;
            default:
               _loc2_ = new MovieClip();
         }
         mcFaction.addChild(_loc2_);
      }
      
      private function onNanovorLoadError(param1:IOErrorEvent) : void
      {
         logError("onNanovorLoadError() [Master Id=" + _virmonData.getVirmonMasterData().getAssetTypeID() + "]: " + param1.text);
         nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
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
         mcNanovor.x = NANOVOR_ORIGIN.x;
         mcNanovor.y = NANOVOR_ORIGIN.y;
      }
      
      public function setNanovor(param1:IVirmonData, param2:String) : void
      {
         _virmonData = param1;
         _infoWindowTitle.nanovorName = param1.getTypeName();
         _infoWindowTitle.nanovorNickName = "";
         _infoWindowTitle.sv = param1.getSwarmValue();
         _infoWindowTitle.faction = param1.getVirmonMasterData().getFaction();
         nameField.text = param2.toUpperCase() + " TREE";
         szTree = param2;
         loadNanovor(param1.getAssetTypeID());
         setFaction(param1.getVirmonMasterData().getFaction());
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorInfoPanelComponent: " + param1);
      }
      
      private function loadNanovor(param1:int) : void
      {
         nanovorLoader = new Loader();
         nanovorLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onNanovorLoadComplete,false,0,true);
         nanovorLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError,false,0,true);
         var _loc2_:String = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterWidgetURL(CharacterWidgetAssetType.IDLE,param1).url;
         nanovorLoader.load(new URLRequest(_loc2_));
      }
      
      private function onNanovorLoadComplete(param1:Event) : void
      {
         while(silhouette.numChildren > 0)
         {
            silhouette.removeChildAt(0);
         }
         nanovorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         nanovorLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
         mcNanovor = MovieClip(param1.target.content);
         silhouette.addChild(mcNanovor);
         resizeNanovor();
         shadeNanovor();
      }
      
      private function shadeNanovor() : void
      {
         var _loc1_:Color = new Color();
         _loc1_.setTint(16777215,1);
         mcNanovor.transform.colorTransform = _loc1_;
      }
      
      public function destroy() : void
      {
      }
   }
}

