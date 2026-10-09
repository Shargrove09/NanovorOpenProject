package com.arkadium.virmon.collection.substates.ems
{
   import com.arkadium.virmon.collection.substates.ems.components.EMTileComponent;
   import com.arkadium.virmon.collection.substates.ems.components.EMsBGComponent;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.EMMasterData;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import fl.motion.AdjustColor;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   
   public class EMSubTreeMenu extends MovieClip
   {
      
      private static const FACTION_BG_ORIGIN:Point = new Point(80,150);
      
      private var _iNewCount:int = 0;
      
      private var _bg:EMsBGComponent;
      
      private var _currentTile:EMTileComponent;
      
      private var _foilEnabled:Boolean;
      
      private var _faction:String;
      
      public function EMSubTreeMenu()
      {
         super();
         _bg = new EMsBGComponent();
         addChild(_bg);
      }
      
      public function destroy() : void
      {
         _bg.common1.removeEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEmClick);
         _bg.common2.removeEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEmClick);
         _bg.uncommon1.removeEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEmClick);
         _bg.uncommon2.removeEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEmClick);
         _bg.rare1.removeEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEmClick);
         _bg.rare2.removeEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEmClick);
         _bg.rareFoil.removeEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEmClick);
         _currentTile = null;
         _bg.common1.destroy();
         _bg.common2.destroy();
         _bg.uncommon1.destroy();
         _bg.uncommon2.destroy();
         _bg.rare1.destroy();
         _bg.rare2.destroy();
         _bg.rareFoil.destroy();
      }
      
      private function onEmClick(param1:EMTreeMenuEvent) : void
      {
         if(_currentTile != null)
         {
            _currentTile.deselect();
         }
         var _loc2_:EMTileComponent = EMTileComponent(param1.data.tile);
         _currentTile = _loc2_;
         dispatchEvent(new EMTreeMenuEvent(EMTreeMenuEvent.EMTILE_CLICK,{"tile":_currentTile},true));
      }
      
      public function openFirst() : void
      {
         _bg.common1.select();
         onEmClick(new EMTreeMenuEvent("",{"tile":_bg.common1}));
      }
      
      public function get currentTile() : EMTileComponent
      {
         return _currentTile;
      }
      
      public function get foilEnabled() : Boolean
      {
         return _foilEnabled;
      }
      
      public function get isNewCount() : int
      {
         return _iNewCount;
      }
      
      public function setData(param1:Array, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:EMMasterData = null;
         var _loc5_:int = 0;
         var _loc6_:EMTileComponent = null;
         var _loc7_:String = null;
         _faction = param2;
         if(param1.length == 7)
         {
            _bg.typeLabels.visible = !(_bg.typeLabelsWithFoil.visible = _bg.rareFoil.visible = _foilEnabled = true);
         }
         else
         {
            _bg.typeLabels.visible = !(_bg.typeLabelsWithFoil.visible = _bg.rareFoil.visible = _foilEnabled = false);
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = int(DataManager.getInstance().getEMManager().getEMCountByMasterId(_loc4_.getAssetTypeID()));
            _loc7_ = _loc4_.getLongName().substr(-1);
            if(_loc4_.getRarity() == "common")
            {
               if(_loc7_ == "1")
               {
                  _loc6_ = _bg.common1;
               }
               else if(_loc7_ == "2")
               {
                  _loc6_ = _bg.common2;
               }
            }
            else if(_loc4_.getRarity() == "uncommon")
            {
               if(_loc7_ == "3")
               {
                  _loc6_ = _bg.uncommon1;
               }
               else if(_loc7_ == "4")
               {
                  _loc6_ = _bg.uncommon2;
               }
            }
            else if(_loc4_.getRarity() == "rare")
            {
               if(_loc7_ == "5")
               {
                  _loc6_ = _bg.rare1;
               }
               else if(_loc7_ == "6")
               {
                  _loc6_ = _bg.rare2;
               }
               else if(_loc7_ == "7")
               {
                  _loc6_ = _bg.rareFoil;
               }
            }
            _loc6_.setData(_loc4_,_loc5_);
            _loc6_.addEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEmClick,false,0,true);
            if(_loc6_.isNew)
            {
               ++_iNewCount;
            }
            _loc3_++;
         }
         setBGColor(_faction);
      }
      
      private function setBGColor(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:AdjustColor = new AdjustColor();
         switch(param1.toLowerCase())
         {
            case NanovorFaction.MAGNAMOD.toLowerCase():
               _loc2_ = int(ColorMap.FACTION_MAGNAMOD);
               _loc3_.brightness = 0;
               _loc3_.contrast = 0;
               _loc3_.saturation = 0;
               _loc3_.hue = 0;
               break;
            case NanovorFaction.VELOCITRON.toLowerCase():
               _loc2_ = int(ColorMap.FACTION_VELOCITRON);
               _loc3_.brightness = 65;
               _loc3_.contrast = 18;
               _loc3_.saturation = 47;
               _loc3_.hue = 55;
               break;
            case NanovorFaction.HEXITE.toLowerCase():
               _loc2_ = int(ColorMap.FACTION_HEXITE);
               _loc3_.brightness = 5;
               _loc3_.contrast = 6;
               _loc3_.saturation = 26;
               _loc3_.hue = -180;
         }
         var _loc4_:Color = new Color();
         _loc4_.color = _loc2_;
         _bg.typeLabels.transform.colorTransform = _loc4_;
         _bg.typeLabelsWithFoil.transform.colorTransform = _loc4_;
         _bg.bg.filters = [new ColorMatrixFilter(_loc3_.CalculateFinalFlatArray())];
      }
      
      public function deselect() : void
      {
         if(Boolean(_currentTile))
         {
            _currentTile.deselect();
            _currentTile = null;
         }
      }
   }
}

