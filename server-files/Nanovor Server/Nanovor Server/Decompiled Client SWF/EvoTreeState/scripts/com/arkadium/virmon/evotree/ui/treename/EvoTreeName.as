package com.arkadium.virmon.evotree.ui.treename
{
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionHexite;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionMagnamod;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionVelocitron;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol145")]
   public class EvoTreeName extends Sprite
   {
      
      private static const FACTION_POINT:Point = new Point(0,18);
      
      private static const FACTION_SCALE:Number = 2.3;
      
      public var tfTitle:TextField;
      
      private var _factionIcon:Sprite;
      
      private var _treeNames:Dictionary;
      
      public function EvoTreeName(param1:Dictionary)
      {
         super();
         _treeNames = param1;
         tfTitle.text = "";
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      private function setFactionIcon(param1:String) : void
      {
         if(null != _factionIcon && _factionIcon.parent != null)
         {
            _factionIcon.parent.removeChild(_factionIcon);
         }
         switch(param1)
         {
            case NanovorFaction.HEXITE.toLowerCase():
               _factionIcon = new FactionHexite();
               break;
            case NanovorFaction.MAGNAMOD.toLowerCase():
               _factionIcon = new FactionMagnamod();
               break;
            case NanovorFaction.VELOCITRON.toLowerCase():
               _factionIcon = new FactionVelocitron();
               break;
            default:
               _factionIcon = new Sprite();
         }
         _factionIcon.scaleX = _factionIcon.scaleY = FACTION_SCALE;
         _factionIcon.x = FACTION_POINT.x;
         _factionIcon.y = FACTION_POINT.y;
         this.addChild(_factionIcon);
      }
      
      public function changeTreeId(param1:int, param2:String) : void
      {
         var _loc3_:String = _treeNames[param1];
         if(null == _loc3_)
         {
            _loc3_ = "";
         }
         tfTitle.text = _loc3_.toUpperCase() + " TREE";
         setFactionIcon(param2);
      }
   }
}

