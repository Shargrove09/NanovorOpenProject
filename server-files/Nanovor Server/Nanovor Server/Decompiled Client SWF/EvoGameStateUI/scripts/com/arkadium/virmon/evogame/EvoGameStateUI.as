package com.arkadium.virmon.evogame
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.EvoData;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.final.elements.GenericEM;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import com.smithandtinker.nanovor.nanovormegaviewerui.NanovorMegaViewer;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EvoGameStateUI extends MovieClip implements IEvoGameStateUI
   {
      
      private static const HOPPERTRAY_X:int = -30;
      
      private static const HOPPERTRAY_Y_OUT:int = -112;
      
      private static const HOPPERTRAY_Y_IN:int = 36;
      
      private static const NUM_CIRCUITS:int = 5;
      
      private static const CIRCUIT_X:int = 85;
      
      private static const CIRCUIT_Y_START:int = 225;
      
      private static const CIRCUIT_Y_SPACING:int = 80;
      
      private var _doors:EvoGameDoors;
      
      private var _circuits:Array;
      
      private var _quickTipsButton:EvoGameQuickTipsButton;
      
      private var _burst:EvoGameBurst;
      
      private var _backButton:EvoGameQuitButton;
      
      private var _hopperTray:HopperTray;
      
      private var _nanovorMegaViewer:NanovorMegaViewer;
      
      private var _header:EvoGameHeader;
      
      private var _slots:int;
      
      private var _footer:EvoGameFooter;
      
      private var _hoveringClamp:EMClamp;
      
      private var _hints:Array;
      
      private var _currentCircuit:Circuit;
      
      private var _draggingEM:GenericEM;
      
      public var mcBG:MovieClip;
      
      public function EvoGameStateUI()
      {
         super();
         getHints();
      }
      
      public function makeBackButton() : void
      {
         if(_backButton == null)
         {
            _backButton = new EvoGameQuitButton();
            _backButton.x = 511;
            _backButton.y = 706;
         }
         addChild(_backButton);
      }
      
      public function makeQuickTipsButton() : void
      {
         if(_quickTipsButton == null)
         {
            _quickTipsButton = new EvoGameQuickTipsButton();
            _quickTipsButton.x = 930;
            _quickTipsButton.y = 735;
         }
         addChild(_quickTipsButton);
      }
      
      private function checkHover(param1:Event) : void
      {
         var _loc3_:EMClamp = null;
         var _loc2_:DisplayObject = _draggingEM.dropTarget;
         while(_loc2_ != null)
         {
            if(_loc2_ is EMClamp && (_loc2_ as EMClamp).isOpen)
            {
               _loc3_ = _loc2_ as EMClamp;
               break;
            }
            _loc2_ = _loc2_.parent;
         }
         _currentCircuit.rolloverClamp(_loc3_);
      }
      
      public function lockHopperTray(param1:Boolean = true) : void
      {
         _hopperTray.lockHoppers(param1);
      }
      
      private function getHints() : void
      {
         var _loc1_:Object = Managers.stateManager.getStateData(StateType.EVOGAME);
         var _loc2_:EvoData = DataManager.getInstance().getEvoManager().getEvoData(int(_loc1_.evolutionId));
         _hints = _loc2_.getPalette();
         _slots = _loc2_.getSlotCount();
      }
      
      private function clearCircuits() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Circuit = null;
         if(_circuits != null)
         {
            _loc1_ = 0;
            while(_loc1_ < _circuits.length)
            {
               _loc2_ = _circuits[_loc1_];
               removeChild(_loc2_);
               _loc2_ = null;
               _loc1_++;
            }
         }
      }
      
      public function makeHopperTray() : void
      {
         if(_hopperTray == null)
         {
            _hopperTray = new HopperTray(this);
            _hopperTray.x = HOPPERTRAY_X;
            _hopperTray.y = HOPPERTRAY_Y_OUT;
         }
         addChild(_hopperTray);
         _hopperTray.setEMs(_hints);
      }
      
      public function makeHeader() : void
      {
         if(_header == null)
         {
            _header = new EvoGameHeader();
         }
         addChild(_header);
      }
      
      public function addMegaViewer(param1:NanovorMegaViewer) : void
      {
         _nanovorMegaViewer = param1;
         if(null != _nanovorMegaViewer)
         {
            addChild(_nanovorMegaViewer);
         }
      }
      
      public function getQuickTipsButton() : EvoGameQuickTipsButton
      {
         return _quickTipsButton;
      }
      
      public function addHopper(param1:Hopper) : void
      {
         addChild(param1);
         if(null != _nanovorMegaViewer)
         {
            addChild(_nanovorMegaViewer);
         }
      }
      
      public function getCircuit(param1:int) : Circuit
      {
         return _circuits[param1];
      }
      
      public function makeDoors() : void
      {
         if(_doors == null)
         {
            _doors = new EvoGameDoors();
         }
         addChild(_doors);
      }
      
      public function setCircuit(param1:int) : void
      {
         _currentCircuit = getCircuit(param1);
      }
      
      public function resetHopperTray() : void
      {
         _hopperTray.reset();
      }
      
      public function burnHeader() : void
      {
         _header.showDamage();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoGameStateUI>>\t" + param1);
      }
      
      public function makeCircuits() : void
      {
         var _loc2_:Circuit = null;
         clearCircuits();
         _circuits = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < NUM_CIRCUITS)
         {
            _loc2_ = new Circuit(this,_slots,_loc1_);
            addChild(_loc2_);
            _loc2_.x = CIRCUIT_X;
            _loc2_.y = CIRCUIT_Y_START + _loc1_ * CIRCUIT_Y_SPACING;
            _circuits.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function onDialogOpened(param1:Event) : void
      {
         stage.removeEventListener(Event.ENTER_FRAME,checkHover);
         stage.removeEventListener(MouseEvent.MOUSE_UP,onEMLetGo);
         EventManager.getInstance().removeEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened);
         _draggingEM.stopDrag();
         _currentCircuit.rolloverClamp(null);
         _hopperTray.onEMLetGo(_draggingEM);
         removeChild(_draggingEM);
         _draggingEM = null;
      }
      
      private function onEMLetGo(param1:MouseEvent) : void
      {
         var _loc3_:EMClamp = null;
         stage.removeEventListener(Event.ENTER_FRAME,checkHover);
         stage.removeEventListener(MouseEvent.MOUSE_UP,onEMLetGo);
         EventManager.getInstance().removeEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened);
         _hoveringClamp = null;
         var _loc2_:DisplayObject = _draggingEM.dropTarget;
         _draggingEM.stopDrag();
         removeChild(_draggingEM);
         while(_loc2_ != null)
         {
            if(_loc2_ is EMClamp && (_loc2_ as EMClamp).isOpen)
            {
               _loc3_ = _loc2_ as EMClamp;
               break;
            }
            _loc2_ = _loc2_.parent;
         }
         if(Boolean(_loc3_))
         {
            _loc3_.setEM(_draggingEM);
         }
         _hopperTray.onEMLetGo(_loc3_ == null ? _draggingEM : null);
         _draggingEM = null;
      }
      
      private function doorsClosed() : void
      {
         clearCircuits();
         log("doorsClosed() - Doors closed.");
      }
      
      public function makeBurst() : void
      {
         if(_burst == null)
         {
            _burst = new EvoGameBurst();
            _burst.x = 510;
            _burst.y = 300;
            Tweener.addTween(_burst,{
               "time":3,
               "_autoAlpha":0,
               "onComplete":removeBurst
            });
         }
         addChild(_burst);
         addChild(_header);
         if(null != _nanovorMegaViewer)
         {
            addChild(_nanovorMegaViewer);
         }
      }
      
      public function makeFooter() : void
      {
         if(_footer == null)
         {
            _footer = new EvoGameFooter();
            _footer.y = 570;
         }
         addChild(_footer);
      }
      
      public function onEMPress(param1:GenericEM) : void
      {
         _draggingEM = new GenericEM(param1.getID());
         _draggingEM.assetId = param1.assetId;
         var _loc2_:Point = param1.localToGlobal(new Point(0,0));
         _draggingEM.x = _loc2_.x;
         _draggingEM.y = _loc2_.y;
         _draggingEM.mouseEnabled = false;
         _draggingEM.mouseChildren = false;
         addChild(_draggingEM);
         _draggingEM.startDrag();
         stage.addEventListener(MouseEvent.MOUSE_UP,onEMLetGo,false,0,true);
         stage.addEventListener(Event.ENTER_FRAME,checkHover,false,0,true);
         EventManager.getInstance().addEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened,false,0,true);
      }
      
      public function closeDoors() : void
      {
         _doors.close(doorsClosed);
         addChild(_header);
         if(null != _nanovorMegaViewer)
         {
            addChild(_nanovorMegaViewer);
         }
      }
      
      public function getBackButton() : EvoGameQuitButton
      {
         return _backButton;
      }
      
      public function destroy() : void
      {
         EventManager.getInstance().removeEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened);
         _header.destroy();
      }
      
      public function openHopperTray() : void
      {
         Tweener.addTween(_hopperTray,{
            "time":1,
            "y":HOPPERTRAY_Y_IN
         });
      }
      
      private function removeBurst() : void
      {
         if(null != _burst && null != _burst.parent)
         {
            _burst.parent.removeChild(_burst);
            _burst = null;
         }
      }
      
      public function hideBurst() : void
      {
         removeChild(_burst);
      }
   }
}

