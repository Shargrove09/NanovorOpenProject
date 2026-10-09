package com.arkadium.virmon.shared.widgets.chat.chatheadertab
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol58")]
   public class ChatHeaderTab extends MovieClip
   {
      
      public var mcBG:MovieClip;
      
      public var tfTitle:TextField;
      
      public function ChatHeaderTab()
      {
         super();
         this.tfTitle.text = "PRIVATE";
         this.tfTitle.mouseEnabled = false;
         this.mouseChildren = false;
         this.hitArea = this.mcBG;
         this.buttonMode = true;
      }
      
      public function open() : void
      {
         this.mouseEnabled = true;
         this.mouseChildren = true;
         this.buttonMode = true;
         this.useHandCursor = true;
         Tweener.addTween(this,{
            "alpha":1,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
      }
      
      public function close() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.buttonMode = false;
         this.useHandCursor = false;
         Tweener.addTween(this,{
            "alpha":0,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
      }
      
      public function set text(param1:String) : void
      {
         this.tfTitle.text = param1;
      }
   }
}

