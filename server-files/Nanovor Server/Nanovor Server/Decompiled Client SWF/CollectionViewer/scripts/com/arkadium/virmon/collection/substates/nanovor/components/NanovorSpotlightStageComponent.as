package com.arkadium.virmon.collection.substates.nanovor.components
{
   import com.arkadium.virmon.collection.substates.nanovor.NanovorSpotlightView;
   import flash.display.Sprite;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol100")]
   public class NanovorSpotlightStageComponent extends Sprite
   {
      
      private var _view:NanovorSpotlightView;
      
      public var spContainer:Sprite;
      
      public function NanovorSpotlightStageComponent()
      {
         super();
      }
      
      public function setContent(param1:NanovorSpotlightView) : void
      {
         spContainer.addChild(param1);
         _view = param1;
      }
   }
}

