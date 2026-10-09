package com.arkadium.virmon.collection.substates.ems.components
{
   import com.arkadium.virmon.collection.substates.ems.EMTreeMenuEvent;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.EMData;
   import com.arkadium.virmon.framework.EMMasterData;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.final.elements.GenericEM;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.AdjustColor;
   import fl.motion.Color;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol110")]
   public class EMTileComponent extends MovieClip
   {
      
      public static const WIDTH:int = 68;
      
      public static const HEIGHT:int = 80;
      
      private static const MAX_EM_WIDTH:int = 70;
      
      public var mcChevron:MovieClip;
      
      private var _data:EMMasterData;
      
      private var _count:int;
      
      public var tfNew:TextField;
      
      private var _isNew:Boolean = false;
      
      public var mcBG:MovieClip;
      
      private var _faction:String;
      
      public var tfNumber:TextField;
      
      public var tfName:TextField;
      
      private var isSelected:Boolean = false;
      
      private var factionColor:int;
      
      public var mcEM:MovieClip;
      
      public function EMTileComponent()
      {
         super();
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
         removeEventListener(MouseEvent.CLICK,onClick);
      }
      
      public function select() : void
      {
         isSelected = true;
         tfNumber.textColor = 2236962;
         mcBG.gotoAndStop("selected");
         mcChevron.gotoAndPlay(1);
         mcChevron.visible = true;
      }
      
      public function deselect() : void
      {
         isSelected = false;
         mcEM.visible = true;
         mcBG.gotoAndStop("up");
         tfNumber.textColor = _count > 0 ? uint(factionColor) : 16777215;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** EMTileComponent: " + param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> EMTileComponent: " + param1);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(!isSelected)
         {
            mcBG.gotoAndPlay("over");
            _loc2_ = new Object();
            _loc2_.tile = this;
            _loc2_.emdata = _data;
            dispatchEvent(new EMTreeMenuEvent(EMTreeMenuEvent.EMTILE_ROLLOVER,_loc2_,true));
         }
      }
      
      public function get isNew() : Boolean
      {
         return _isNew;
      }
      
      private function getEMIcon(param1:int) : void
      {
         var _loc3_:AdjustColor = null;
         while(mcEM.numChildren > 0)
         {
            mcEM.removeChildAt(0);
         }
         var _loc2_:GenericEM = new GenericEM(param1);
         _loc2_.stopCrystal();
         mcEM.addChild(_loc2_);
         resizeEM();
         if(_count == 0)
         {
            _loc3_ = new AdjustColor();
            _loc3_.brightness = 0;
            _loc3_.contrast = 0;
            _loc3_.saturation = -100;
            _loc3_.hue = 0;
            mcEM.filters = [new ColorMatrixFilter(_loc3_.CalculateFinalFlatArray())];
         }
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         if(isSelected)
         {
         }
      }
      
      public function get faction() : String
      {
         return _faction;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(!isSelected)
         {
            select();
            _loc2_ = new Object();
            _loc2_.tile = this;
            _loc2_.emdata = _data;
            dispatchEvent(new EMTreeMenuEvent(EMTreeMenuEvent.EMTILE_CLICK,_loc2_,true));
         }
      }
      
      public function get data() : EMMasterData
      {
         return _data;
      }
      
      private function resizeEM() : void
      {
         mcEM.scaleX = mcEM.scaleY = 0.6593406593406592;
      }
      
      public function setData(param1:EMMasterData, param2:int) : void
      {
         _data = param1;
         _count = param2;
         setTileData();
         mcChevron.gotoAndStop(1);
         mcChevron.visible = false;
         getEMIcon(_data.getAssetTypeID());
      }
      
      private function setTileData() : void
      {
         _faction = _data.getFaction();
         _isNew = hasNEWStatus();
         tfNew.text = _isNew ? "NEW!" : "";
         tfNumber.text = "" + _count;
         tfName.text = _data.getLongName();
         setFrameColor(_faction);
         enableButton();
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(!isSelected)
         {
            mcBG.gotoAndPlay("up");
            _loc2_ = new Object();
            _loc2_.tile = this;
            _loc2_.emdata = _data;
            dispatchEvent(new EMTreeMenuEvent(EMTreeMenuEvent.EMTILE_ROLLOUT,_loc2_,true));
         }
      }
      
      private function enableButton() : void
      {
         buttonMode = true;
         useHandCursor = true;
         mouseEnabled = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
      }
      
      private function hasNEWStatus() : Boolean
      {
         var _loc1_:EMData = null;
         var _loc2_:Array = DataManager.getInstance().getEMManager().getEMDataListByMasterID(_data.getAssetTypeID());
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_ = _loc2_[_loc3_];
            if(_loc1_.isNew())
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function setFrameColor(param1:String) : void
      {
         switch(param1.toLowerCase())
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
         var _loc2_:Color = new Color();
         _loc2_.color = factionColor;
         mcBG.transform.colorTransform = _loc2_;
         tfNumber.textColor = _count > 0 ? uint(factionColor) : 16777215;
      }
   }
}

