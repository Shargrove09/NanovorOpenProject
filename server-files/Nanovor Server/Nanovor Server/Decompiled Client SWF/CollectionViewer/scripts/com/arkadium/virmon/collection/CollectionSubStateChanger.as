package com.arkadium.virmon.collection
{
   import com.arkadium.virmon.shared.utils.substate.ISubStateChanger;
   import com.arkadium.virmon.shared.utils.substate.ISubStateChangerConsumer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class CollectionSubStateChanger implements ISubStateChanger
   {
      
      private var _btnNanovor:SimpleButton;
      
      private var _selectedNanovor:MovieClip;
      
      private var _btnEms:SimpleButton;
      
      private var _selectedEms:MovieClip;
      
      private var _consumer:ISubStateChangerConsumer;
      
      private var _currentStateType:String;
      
      public function CollectionSubStateChanger(param1:SimpleButton, param2:SimpleButton, param3:MovieClip, param4:MovieClip)
      {
         super();
         _btnNanovor = param1;
         _btnEms = param2;
         _selectedNanovor = param3;
         _selectedEms = param4;
         _btnNanovor.addEventListener(MouseEvent.CLICK,onBtnNanovorClick,false,0,true);
         _btnEms.addEventListener(MouseEvent.CLICK,onBtnEmsClick,false,0,true);
      }
      
      public function onSubStateChange(param1:String) : void
      {
         if(param1 == _currentStateType)
         {
            return;
         }
         _currentStateType = param1;
         switch(param1)
         {
            case CollectionSubStateFactory.COLLECTION_SUBSTATE_NANOVOR:
               _btnNanovor.visible = false;
               _selectedEms.visible = false;
               _btnEms.visible = true;
               _selectedNanovor.visible = true;
               break;
            case CollectionSubStateFactory.COLLECTION_SUBSTATE_EMS:
               _btnNanovor.visible = true;
               _selectedEms.visible = true;
               _btnEms.visible = false;
               _selectedNanovor.visible = false;
         }
      }
      
      private function onBtnEmsClick(param1:MouseEvent) : void
      {
         _consumer.handleSubStateChangeRequest(CollectionSubStateFactory.COLLECTION_SUBSTATE_EMS);
      }
      
      public function removeSubStateChangerConsumer(param1:ISubStateChangerConsumer) : void
      {
         if(_consumer == param1)
         {
            _consumer = null;
         }
      }
      
      public function addSubStateChangerConsumer(param1:ISubStateChangerConsumer) : void
      {
         _consumer = param1;
      }
      
      private function onBtnNanovorClick(param1:MouseEvent) : void
      {
         _consumer.handleSubStateChangeRequest(CollectionSubStateFactory.COLLECTION_SUBSTATE_NANOVOR);
      }
      
      public function destroy() : void
      {
         _btnNanovor.removeEventListener(MouseEvent.CLICK,onBtnNanovorClick);
         _btnEms.removeEventListener(MouseEvent.CLICK,onBtnEmsClick);
         _selectedNanovor = null;
         _selectedEms = null;
         _consumer = null;
         _btnNanovor = null;
         _btnEms = null;
      }
      
      public function show(param1:Boolean = true) : void
      {
         if(param1)
         {
         }
      }
   }
}

