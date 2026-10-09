package com.arkadium.virmon.device.deviceswarmchooser.deviceswarmcontainer
{
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.elements.icons.spikedattack.SmallBlueSpike;
   import com.arkadium.virmon.shared.elements.icons.spikedattack.SmallRedSpike;
   import com.arkadium.virmon.shared.elements.icons.spikedattack.SmallYellowSpike;
   import flash.display.Sprite;
   
   public class SpikeBoard extends Sprite
   {
      
      public static const SPIKE_ICON_Y:int = 10;
      
      public static const REDSPIKE_ICON_X:int = 0;
      
      public static const YELLOWSPIKE_ICON_X:int = 84;
      
      public static const BLUESPIKE_ICON_X:int = 184;
      
      public static const SPIKE_COLOR_RED:uint = ColorMap.FACTION_MAGNAMOD;
      
      public static const SPIKE_COLOR_YELLOW:uint = ColorMap.FACTION_VELOCITRON;
      
      public static const SPIKE_COLOR_BLUE:uint = ColorMap.FACTION_HEXITE;
      
      private var _txYellowSpikes:SpikeBoardTallyText;
      
      private var _blueSpikeIcon:SmallBlueSpike;
      
      private var _txBlueSpikes:SpikeBoardTallyText;
      
      private var _yellowSpikeIcon:SmallYellowSpike;
      
      private var _redSpikeIcon:SmallRedSpike;
      
      private var _txBlueSpikedAttacks:SpikeBoardTallyText;
      
      private var _txRedSpikes:SpikeBoardTallyText;
      
      private var _txYellowSpikedAttacks:SpikeBoardTallyText;
      
      private var _txRedSpikedAttacks:SpikeBoardTallyText;
      
      public function SpikeBoard()
      {
         super();
         addSpikeIcons();
         createTextLabels();
      }
      
      private function createTextLabels() : void
      {
         _txRedSpikes = new SpikeBoardTallyText("0 RED SPIKES",SPIKE_COLOR_RED);
         addChild(_txRedSpikes);
         _txRedSpikes.x = _redSpikeIcon.x + _redSpikeIcon.width + 5;
         _txRedSpikes.y = _redSpikeIcon.y - 5;
         _txRedSpikedAttacks = new SpikeBoardTallyText("0 ATTACKS",SPIKE_COLOR_RED);
         addChild(_txRedSpikedAttacks);
         _txRedSpikedAttacks.x = _txRedSpikes.x;
         _txRedSpikedAttacks.y = _txRedSpikes.y + _txRedSpikes.textHeight;
         _txYellowSpikes = new SpikeBoardTallyText("0 YELLOW SPIKES",SPIKE_COLOR_YELLOW);
         addChild(_txYellowSpikes);
         _txYellowSpikes.x = _yellowSpikeIcon.x + _yellowSpikeIcon.width + 5;
         _txYellowSpikes.y = _yellowSpikeIcon.y - 5;
         _txYellowSpikedAttacks = new SpikeBoardTallyText("0 ATTACKS",SPIKE_COLOR_YELLOW);
         addChild(_txYellowSpikedAttacks);
         _txYellowSpikedAttacks.x = _txYellowSpikes.x;
         _txYellowSpikedAttacks.y = _txYellowSpikes.y + _txYellowSpikes.textHeight;
         _txBlueSpikes = new SpikeBoardTallyText("0 BLUE SPIKES",SPIKE_COLOR_BLUE);
         addChild(_txBlueSpikes);
         _txBlueSpikes.x = _blueSpikeIcon.x + _blueSpikeIcon.width + 5;
         _txBlueSpikes.y = _blueSpikeIcon.y - 5;
         _txBlueSpikedAttacks = new SpikeBoardTallyText("0 ATTACKS",SPIKE_COLOR_BLUE);
         addChild(_txBlueSpikedAttacks);
         _txBlueSpikedAttacks.x = _txBlueSpikes.x;
         _txBlueSpikedAttacks.y = _txBlueSpikes.y + _txBlueSpikes.textHeight;
      }
      
      public function updateBoard(param1:Object) : void
      {
         _txRedSpikes.updateText(param1.redSpikes + " RED SPIKES");
         _txRedSpikedAttacks.updateText(param1.redSpikedAttacks + " ATTACKS");
         _txYellowSpikes.updateText(param1.yellowSpikes + " YELLOW SPIKES");
         _txYellowSpikedAttacks.updateText(param1.yellowSpikedAttacks + " ATTACKS");
         _txBlueSpikes.updateText(param1.blueSpikes + " BLUE SPIKES");
         _txBlueSpikedAttacks.updateText(param1.blueSpikedAttacks + " ATTACKS");
      }
      
      public function resetBoard() : void
      {
         _txRedSpikes.updateText("0 RED SPIKES");
         _txRedSpikedAttacks.updateText("0 ATTACKS");
         _txYellowSpikes.updateText("0 YELLOW SPIKES");
         _txYellowSpikedAttacks.updateText("0 ATTACKS");
         _txBlueSpikes.updateText("0 BLUE SPIKES");
         _txBlueSpikedAttacks.updateText("0 ATTACKS");
      }
      
      private function addSpikeIcons() : void
      {
         _redSpikeIcon = new SmallRedSpike();
         addChild(_redSpikeIcon);
         _redSpikeIcon.y = SPIKE_ICON_Y;
         _redSpikeIcon.x = REDSPIKE_ICON_X;
         _yellowSpikeIcon = new SmallYellowSpike();
         addChild(_yellowSpikeIcon);
         _yellowSpikeIcon.y = SPIKE_ICON_Y;
         _yellowSpikeIcon.x = YELLOWSPIKE_ICON_X;
         _blueSpikeIcon = new SmallBlueSpike();
         addChild(_blueSpikeIcon);
         _blueSpikeIcon.y = SPIKE_ICON_Y;
         _blueSpikeIcon.x = BLUESPIKE_ICON_X;
      }
   }
}

