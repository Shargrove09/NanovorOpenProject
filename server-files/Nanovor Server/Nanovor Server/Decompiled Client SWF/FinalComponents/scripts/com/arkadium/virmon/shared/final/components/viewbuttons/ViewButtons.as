package com.arkadium.virmon.shared.final.components.viewbuttons
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol452")]
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
            case this.mcPedigrees:
               this._pedigreeHandler = param2;
               break;
            case this.mcAttacks:
               this._attacksHandler = param2;
               break;
            case this.mcStats:
               this._statsHandler = param2;
         }
      }
      
      public function destroy() : void
      {
         if(this.mcStats != null)
         {
            while(this.mcStats.numChildren > 0)
            {
               this.mcStats.removeChildAt(0);
            }
            if(this._statsHandler != null)
            {
               this.mcStats.removeEventListener(MouseEvent.CLICK,this._statsHandler);
            }
         }
         if(this.mcAttacks != null)
         {
            while(this.mcAttacks.numChildren > 0)
            {
               this.mcAttacks.removeChildAt(0);
            }
            if(this._attacksHandler != null)
            {
               this.mcAttacks.removeEventListener(MouseEvent.CLICK,this._attacksHandler);
            }
         }
         if(this.mcPedigrees != null)
         {
            while(this.mcPedigrees.numChildren > 0)
            {
               this.mcPedigrees.removeChildAt(0);
            }
            if(this._pedigreeHandler != null)
            {
               this.mcPedigrees.removeEventListener(MouseEvent.CLICK,this._pedigreeHandler);
            }
         }
      }
   }
}

