package com.arkadium.virmon.common
{
   public class AbstractCompositeView extends AbstractComponentView implements ICompositeView
   {
      
      private var _children:Array;
      
      public function AbstractCompositeView()
      {
         super();
         _children = new Array();
      }
      
      protected function getChildrenOfType(param1:Class) : Array
      {
         var Type:Class = param1;
         trace("getChildrenOfType(): " + Type);
         return _children.filter(function(param1:*, param2:int, param3:Array):Boolean
         {
            return param1 is Type;
         });
      }
      
      public function add(param1:IComponentView) : void
      {
         _children.push(param1);
      }
      
      override public function destroy() : void
      {
         var _loc1_:IComponentView = null;
         for each(_loc1_ in _children)
         {
            _loc1_.destroy();
         }
      }
   }
}

