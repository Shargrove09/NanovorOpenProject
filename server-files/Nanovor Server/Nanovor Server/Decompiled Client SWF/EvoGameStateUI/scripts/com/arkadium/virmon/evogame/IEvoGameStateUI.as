package com.arkadium.virmon.evogame
{
   import com.arkadium.virmon.shared.final.elements.GenericEM;
   import com.smithandtinker.nanovor.nanovormegaviewerui.NanovorMegaViewer;
   
   public interface IEvoGameStateUI
   {
      
      function getQuickTipsButton() : EvoGameQuickTipsButton;
      
      function burnHeader() : void;
      
      function addHopper(param1:Hopper) : void;
      
      function addMegaViewer(param1:NanovorMegaViewer) : void;
      
      function makeBackButton() : void;
      
      function makeQuickTipsButton() : void;
      
      function closeDoors() : void;
      
      function setCircuit(param1:int) : void;
      
      function getBackButton() : EvoGameQuitButton;
      
      function makeFooter() : void;
      
      function makeBurst() : void;
      
      function getCircuit(param1:int) : Circuit;
      
      function openHopperTray() : void;
      
      function lockHopperTray(param1:Boolean = true) : void;
      
      function makeDoors() : void;
      
      function makeHopperTray() : void;
      
      function resetHopperTray() : void;
      
      function destroy() : void;
      
      function makeHeader() : void;
      
      function onEMPress(param1:GenericEM) : void;
      
      function hideBurst() : void;
      
      function makeCircuits() : void;
   }
}

