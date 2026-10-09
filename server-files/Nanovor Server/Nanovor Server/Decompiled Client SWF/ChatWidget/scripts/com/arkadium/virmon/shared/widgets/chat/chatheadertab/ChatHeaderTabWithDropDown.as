package com.arkadium.virmon.shared.widgets.chat.chatheadertab
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.widgets.chat.PanelScrollBar;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol56")]
   public class ChatHeaderTabWithDropDown extends MovieClip
   {
      
      private static const DROP_DOWN_BASE_LINE_X:int = 28;
      
      private static const DROP_DOWN_HEIGHT:int = 482;
      
      public var tfTitle:TextField;
      
      private var _scrollBar:PanelScrollBar;
      
      public var locked:Boolean;
      
      private var entries:Array;
      
      public var mcScrollBarContainer:MovieClip;
      
      public var mcEntriesContainer:Sprite;
      
      public var mcBG:MovieClip;
      
      public var mcDropDown:Sprite;
      
      public var mcDropDownMask:MovieClip;
      
      public function ChatHeaderTabWithDropDown()
      {
         super();
         this.tfTitle.text = "SCIENCE ROOM ";
         this.tfTitle.mouseEnabled = false;
         this.hitArea = this.mcBG;
         this.buttonMode = true;
         this.useHandCursor = true;
         this.entries = new Array();
         this.mcDropDown.mouseEnabled = false;
         this.mcDropDown.height = DROP_DOWN_HEIGHT + 3;
         this.mcDropDown.y = DROP_DOWN_BASE_LINE_X - 20 - 10;
         this.mcBG.addEventListener(MouseEvent.CLICK,this.onDropDownClick);
         this._scrollBar = new PanelScrollBar(this.mcEntriesContainer,this.mcDropDownMask);
         this._scrollBar.height = DROP_DOWN_HEIGHT - 1;
         this._scrollBar.x = 192;
         this.mcScrollBarContainer.addChild(this._scrollBar);
         this.mcDropDownMask.height = 0;
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<ChatHeaderTabWithDropDown>>:\t" + param1);
      }
      
      private function closeDropDown(... rest) : void
      {
         if(this._scrollBar.isScrolling)
         {
            return;
         }
         Tweener.addTween(this.mcDropDown,{
            "y":DROP_DOWN_BASE_LINE_X - DROP_DOWN_HEIGHT,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(this.mcEntriesContainer,{
            "y":DROP_DOWN_BASE_LINE_X - DROP_DOWN_HEIGHT,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(this.mcScrollBarContainer,{
            "y":DROP_DOWN_BASE_LINE_X - DROP_DOWN_HEIGHT,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(this.mcDropDownMask,{
            "height":0,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
      }
      
      public function isDropDownClosed() : Boolean
      {
         return Boolean(this.mcDropDownMask.height == 0);
      }
      
      public function eventCloseDropDown(param1:MouseEvent) : void
      {
         this.log("eventCloseDropDown()");
         this.closeDropDown();
      }
      
      private function handleStageMouseDown(param1:MouseEvent) : void
      {
         if(DROP_DOWN_HEIGHT != this.mcDropDownMask.height)
         {
            return;
         }
         if(this.mcEntriesContainer.hitTestPoint(param1.stageX,param1.stageY))
         {
            return;
         }
         if(this.mcBG.hitTestPoint(param1.stageX,param1.stageY))
         {
            return;
         }
         if(this.mcScrollBarContainer.hitTestPoint(param1.stageX,param1.stageY))
         {
            return;
         }
         this.closeDropDown();
      }
      
      public function set text(param1:String) : void
      {
         this.tfTitle.text = param1;
      }
      
      public function clearAllEntries() : void
      {
         while(this.mcEntriesContainer.numChildren > 0)
         {
            this.mcEntriesContainer.removeChildAt(0);
         }
         this.entries = new Array();
      }
      
      private function toggleDropDown() : void
      {
         this.log("toggleDropDown(): mcDropDownMask.height: " + this.mcDropDownMask.height);
         switch(this.mcDropDownMask.height)
         {
            case 0:
               this.openDropDown();
               break;
            case DROP_DOWN_HEIGHT:
               this.closeDropDown();
         }
      }
      
      private function openDropDown(... rest) : void
      {
         if(this._scrollBar.isScrolling)
         {
            return;
         }
         Tweener.addTween(this.mcDropDown,{
            "y":DROP_DOWN_BASE_LINE_X,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(this.mcEntriesContainer,{
            "y":DROP_DOWN_BASE_LINE_X,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(this.mcScrollBarContainer,{
            "y":DROP_DOWN_BASE_LINE_X,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(this.mcDropDownMask,{
            "height":DROP_DOWN_HEIGHT,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
      }
      
      public function refreshScrollBar() : void
      {
         this._scrollBar.refresh();
      }
      
      public function addDropDownEntry(param1:String, param2:IChatHeaderTabDropDownEntryClickHandler) : void
      {
         var _loc3_:ChatHeaderTabDropDownEntry = new ChatHeaderTabDropDownEntry(param1,param2,this);
         _loc3_.y = this.entries.length * ChatHeaderTabDropDownEntry.HEIGHT;
         this.mcEntriesContainer.addChild(_loc3_);
         this.entries.push(_loc3_);
         this.mcEntriesContainer.y = DROP_DOWN_BASE_LINE_X - this.mcEntriesContainer.height - 10;
         this.mcDropDown.y = this.mcEntriesContainer.y;
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.log("handleAddedToStage()");
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleStageMouseDown);
      }
      
      private function onDropDownClick(param1:MouseEvent) : void
      {
         if(!this.locked)
         {
            this.toggleDropDown();
         }
      }
   }
}

