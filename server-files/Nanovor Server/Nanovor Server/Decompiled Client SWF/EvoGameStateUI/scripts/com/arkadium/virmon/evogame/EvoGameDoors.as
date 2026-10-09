package com.arkadium.virmon.evogame
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol510")]
   public class EvoGameDoors extends MovieClip
   {
      
      private static const TWEEN_TIME:Number = 1;
      
      private static const TWEEN_BASE:Object = {
         "time":1,
         "transition":Equations.easeOutQuad
      };
      
      private static const DOOR_TOP_END:int = 0;
      
      private static const DOOR_BOTTOM_END:int = 356;
      
      public var mcDoorTop:Sprite;
      
      public var mcDoorBottom:Sprite;
      
      public function EvoGameDoors()
      {
         super();
         this.cacheAsBitmap = true;
         this.removeChild(mcDoorTop);
         this.removeChild(mcDoorBottom);
      }
      
      public function close(param1:Function) : void
      {
         this.addChild(mcDoorTop);
         this.addChild(mcDoorBottom);
         Tweener.addTween(mcDoorTop,{
            "y":DOOR_TOP_END,
            "base":TWEEN_BASE
         });
         Tweener.addTween(mcDoorBottom,{
            "y":DOOR_BOTTOM_END,
            "base":TWEEN_BASE,
            "onComplete":param1
         });
      }
   }
}

