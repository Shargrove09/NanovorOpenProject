package com.arkadium.virmon.collection.substates.ems.components
{
   import com.arkadium.virmon.collection.substates.ems.EMTreeMenuEvent;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionHexite;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionMagnamod;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionVelocitron;
   import com.arkadium.virmon.shared.final.elements.AlertBubble;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.Color;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol60")]
   public class EMFactionTileComponent extends MovieClip
   {
      
      public static const WIDTH:int = 68;
      
      public static const HEIGHT:int = 80;
      
      public var mcChevron:MovieClip;
      
      public var mcHighlight:MovieClip;
      
      private var _wave:int;
      
      public var tfTreeName:TextField;
      
      private var _faction:String;
      
      private var hasMembers:Boolean;
      
      private var isSelected:Boolean = false;
      
      public var mcFaction:MovieClip;
      
      private var factionColor:uint;
      
      public var mcAlert:AlertBubble;
      
      private var _newEms:int;
      
      public var tfFactionName:TextField;
      
      public var mcFrame:MovieClip;
      
      public var mcEM:MovieClip;
      
      public function EMFactionTileComponent(param1:String, param2:int, param3:Boolean, param4:int)
      {
         super();
         _faction = param1;
         _wave = param2;
         hasMembers = param3;
         _newEms = param4;
         mcAlert = new AlertBubble();
         mcAlert.x = 45;
         mcAlert.y = 8;
         addChild(mcAlert);
         setTileData();
         mcChevron.gotoAndStop(1);
         mcChevron.visible = false;
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
         removeEventListener(MouseEvent.CLICK,onClick);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> FactionTile: " + param1);
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
      
      private function onOut(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(!isSelected && hasMembers)
         {
            mcFrame.gotoAndPlay("up");
            mcChevron.gotoAndStop(1);
            mcChevron.visible = false;
            _loc2_ = new Object();
            _loc2_.tile = this;
            _loc2_.faction = _faction;
            dispatchEvent(new EMTreeMenuEvent(EMTreeMenuEvent.FACTIONTILE_ROLLOUT,_loc2_,true));
         }
      }
      
      private function setTileData() : void
      {
         if(hasMembers)
         {
            enableButton();
         }
         setFaction(_faction.toLowerCase());
         setName(_faction,_wave);
         setAlertBubble(_newEms);
         setFrameColor();
      }
      
      public function select() : void
      {
         isSelected = true;
         mcFrame.gotoAndPlay("over");
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
      
      private function setFaction(param1:String) : void
      {
         switch(param1)
         {
            case NanovorFaction.MAGNAMOD.toLowerCase():
               mcFaction.addChild(new FactionMagnamod());
               factionColor = ColorMap.FACTION_MAGNAMOD;
               break;
            case NanovorFaction.VELOCITRON.toLowerCase():
               mcFaction.addChild(new FactionVelocitron());
               factionColor = ColorMap.FACTION_VELOCITRON;
               break;
            case NanovorFaction.HEXITE.toLowerCase():
               mcFaction.addChild(new FactionHexite());
               factionColor = ColorMap.FACTION_HEXITE;
         }
      }
      
      public function get faction() : String
      {
         return _faction;
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         if(!isSelected && hasMembers)
         {
            mcChevron.visible = true;
            mcChevron.gotoAndPlay(1);
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(!isSelected && hasMembers)
         {
            mcFrame.gotoAndPlay("over");
            _loc2_ = new Object();
            _loc2_.tile = this;
            _loc2_.faction = _faction;
            dispatchEvent(new EMTreeMenuEvent(EMTreeMenuEvent.FACTIONTILE_ROLLOVER,_loc2_,true));
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** FactionTile: " + param1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(!isSelected && hasMembers)
         {
            select();
            _loc2_ = new Object();
            _loc2_.tile = this;
            _loc2_.faction = _faction;
            dispatchEvent(new EMTreeMenuEvent(EMTreeMenuEvent.FACTIONTILE_CLICK,_loc2_,true));
         }
      }
      
      private function setName(param1:String, param2:int) : void
      {
         tfFactionName.text = param1.toUpperCase();
         tfFactionName.textColor = factionColor;
         tfTreeName.text = param2.toString() + param1.substr(0,1) + " EMs";
      }
      
      private function setFrameColor() : void
      {
         var _loc1_:Color = new Color();
         _loc1_.color = factionColor;
         mcFrame.transform.colorTransform = _loc1_;
         mcEM.gotoAndStop(_faction.toLowerCase());
      }
      
      public function deselect() : void
      {
         isSelected = false;
         mcFrame.gotoAndPlay("up");
      }
   }
}

