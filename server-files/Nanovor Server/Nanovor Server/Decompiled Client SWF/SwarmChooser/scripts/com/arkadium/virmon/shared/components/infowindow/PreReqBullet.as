package com.arkadium.virmon.shared.components.infowindow
{
   import flash.display.Shape;
   
   internal class PreReqBullet extends Shape
   {
      
      public function PreReqBullet(param1:int, param2:uint)
      {
         super();
         this.graphics.beginFill(param2);
         this.graphics.drawCircle(0,0,param1);
         this.graphics.endFill();
      }
   }
}

