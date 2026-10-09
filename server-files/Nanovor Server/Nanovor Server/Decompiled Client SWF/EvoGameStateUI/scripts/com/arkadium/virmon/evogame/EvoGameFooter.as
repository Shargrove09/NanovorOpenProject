package com.arkadium.virmon.evogame
{
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.state.StateType;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol737")]
   public class EvoGameFooter extends MovieClip
   {
      
      public var btnGetEMS:SimpleButton;
      
      public var tfGetEMS:TextField;
      
      public function EvoGameFooter()
      {
         super();
         tfGetEMS.text = "GET EMS";
         tfGetEMS.mouseEnabled = false;
         tfGetEMS.selectable = false;
         btnGetEMS.addEventListener(MouseEvent.CLICK,handleGetEMSClick);
      }
      
      private function handleGetEMSClick(param1:MouseEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         Managers.stateManager.setState(StateType.NANOMALL);
      }
   }
}

