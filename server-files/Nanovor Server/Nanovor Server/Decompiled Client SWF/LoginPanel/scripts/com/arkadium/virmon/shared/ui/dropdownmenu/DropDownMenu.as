package com.arkadium.virmon.shared.ui.dropdownmenu
{
   import caurina.transitions.Tweener;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol38")]
   public class DropDownMenu extends MovieClip implements IDropDownMenuHeaderBoxHandler
   {
      
      private var _items:Array;
      
      public var mcMask:MovieClip;
      
      private var _listBoxUp_Y:int;
      
      private var _listBoxDown_Y:int;
      
      private var _handler:IDropDownMenuHandler;
      
      public var listBox:DropDownMenuListBox;
      
      private var _listBoxOpen:Boolean = false;
      
      public var headerBox:DropDownMenuHeaderBox;
      
      public function DropDownMenu()
      {
         super();
      }
      
      public function selectItem(param1:int) : void
      {
         this.closeListBox();
         this.headerBox.updateLabel(this._items[param1].name);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("DropDownMenu >> " + param1);
      }
      
      public function openListBox() : void
      {
         var _loc1_:int = this._listBoxDown_Y;
         this.listBox.resetScroll();
         this._listBoxOpen = true;
         Tweener.addTween(this.listBox,{
            "y":_loc1_,
            "time":0.25,
            "transition":"easeOutQuad"
         });
      }
      
      public function closeListBox() : void
      {
         var _loc1_:int = this._listBoxUp_Y;
         this._listBoxOpen = false;
         Tweener.addTween(this.listBox,{
            "y":_loc1_,
            "time":0.25,
            "transition":"easeOutQuad"
         });
      }
      
      public function init(param1:IDropDownMenuHandler, param2:Array) : void
      {
         this._handler = param1;
         this._items = param2;
         this._listBoxDown_Y = this.listBox.y;
         this._listBoxUp_Y = this.mcMask.y - this.listBox.height;
         this.listBox.y = this._listBoxUp_Y;
         this.listBox.mask = this.mcMask;
         this.headerBox.init(IDropDownMenuHeaderBoxHandler(this));
         this.listBox.init(param1,this._items);
      }
      
      public function toggleListBox() : void
      {
         if(this._listBoxOpen)
         {
            this.closeListBox();
         }
         else
         {
            this.openListBox();
         }
      }
   }
}

