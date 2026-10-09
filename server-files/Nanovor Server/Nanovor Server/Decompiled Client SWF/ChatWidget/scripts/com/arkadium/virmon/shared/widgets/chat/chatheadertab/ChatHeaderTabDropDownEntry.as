package com.arkadium.virmon.shared.widgets.chat.chatheadertab
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol47")]
   public class ChatHeaderTabDropDownEntry extends MovieClip
   {
      
      public static const HEIGHT:int = 20;
      
      private var _parentDropDown:ChatHeaderTabWithDropDown;
      
      private var _handler:IChatHeaderTabDropDownEntryClickHandler;
      
      public var mcBG:MovieClip;
      
      public var tfText:TextField;
      
      public function ChatHeaderTabDropDownEntry(param1:String, param2:IChatHeaderTabDropDownEntryClickHandler, param3:ChatHeaderTabWithDropDown)
      {
         super();
         DebugLog.instance.log("<<ChatHeaderTabDropDownEntry::ctor(): title: " + param1);
         this.tfText.text = param1;
         this._handler = param2;
         this._parentDropDown = param3;
         this.hitArea = this.mcBG;
         this.tfText.mouseEnabled = false;
         this.mcBG.buttonMode = true;
         this.buttonMode = true;
         this.useHandCursor = true;
         this.mcBG.alpha = 0;
         this.addEventListener(MouseEvent.ROLL_OVER,this.onThisRollOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onThisRollOut);
         this.addEventListener(MouseEvent.CLICK,this.onThisClick);
      }
      
      private function onThisRollOut(param1:MouseEvent) : void
      {
         Tweener.addTween(this.mcBG,{
            "alpha":0,
            "time":0.2,
            "transition":Equations.easeInOutQuad
         });
      }
      
      private function onThisRollOver(param1:MouseEvent) : void
      {
         Tweener.addTween(this.mcBG,{
            "alpha":0.5,
            "time":0,
            "transition":Equations.easeInOutQuad
         });
      }
      
      private function onThisClick(param1:MouseEvent) : void
      {
         this._parentDropDown.eventCloseDropDown(null);
         if(this._handler != null)
         {
            DebugLog.instance.log("<<ChatHeaderTabDropDownEntry>> joining chat room: " + this.tfText.text.replace(/\s\([0-9]+\)/,""));
            this._handler.handleChatHeaderDropDownEntryClick(this.tfText.text.replace(/\s\([0-9]+\)/,""));
         }
      }
      
      public function set text(param1:String) : void
      {
         this.tfText.text = param1;
      }
   }
}

