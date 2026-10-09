package com.arkadium.virmon.shared.final
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   
   public class FinalExportsReference
   {
      
      private static var _dictLoadees:Dictionary = new Dictionary();
      
      public function FinalExportsReference()
      {
         super();
      }
      
      public static function addLoadeeReference(param1:DisplayObject) : void
      {
         _dictLoadees[param1] = param1;
      }
   }
}

