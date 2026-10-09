package com.arkadium.virmon.shared.final.components.viewbuttons
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ViewButtons extends MovieClip
   {
      
      public var mcViewBG:MovieClip;
      
      private var _pedigreeHandler:Function;
      
      public var mcStats:MovieClip;
      
      private var _statsHandler:Function;
      
      public var mcAttacks:MovieClip;
      
      public var mcPedigrees:MovieClip;
      
      private var _attacksHandler:Function;
      
      public function ViewButtons()
      {
         super();
      }
      
      public function addEventListenerToMC(param1:MovieClip, param2:Function) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,param2);
         switch(param1)
         {
            case mcPedigrees:
               _pedigreeHandler = param2;
               break;
            case mcAttacks:
               _attacksHandler = param2;
               break;
            case mcStats:
               _statsHandler = param2;
         }
      }
      
      public function destroy() : void
      {
         if(mcStats != null)
         {
            while(mcStats.numChildren > 0)
            {
               mcStats.removeChildAt(0);
            }
            if(_statsHandler != null)
            {
               mcStats.removeEventListener(MouseEvent.CLICK,_statsHandler);
            }
         }
         if(mcAttacks != null)
         {
            while(mcAttacks.numChildren > 0)
            {
               mcAttacks.removeChildAt(0);
            }
            if(_attacksHandler != null)
            {
               mcAttacks.removeEventListener(MouseEvent.CLICK,_attacksHandler);
            }
         }
         if(mcPedigrees != null)
         {
            while(mcPedigrees.numChildren > 0)
            {
               mcPedigrees.removeChildAt(0);
            }
            if(_pedigreeHandler != null)
            {
               mcPedigrees.removeEventListener(MouseEvent.CLICK,_pedigreeHandler);
            }
         }
      }
   }
}

