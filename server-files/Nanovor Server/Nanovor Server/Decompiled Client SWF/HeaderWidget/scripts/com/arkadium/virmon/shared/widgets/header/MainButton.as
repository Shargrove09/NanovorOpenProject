package com.arkadium.virmon.shared.widgets.header
{
   import com.arkadium.virmon.state.StateType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol83")]
   public class MainButton extends MovieClip
   {
      
      public static const PLAIN_LABEL:String = "plain";
      
      public static const ORANGE_LABEL:String = "orange";
      
      public static const PADDING:Number = 26.7;
      
      public var tfLabel:TextField;
      
      public var mcDivider:Sprite;
      
      public var stateType:StateType;
      
      public var uniqueId:String;
      
      public var mcBGButton:Sprite;
      
      public var mcDisabled:Sprite;
      
      public function MainButton(param1:Object)
      {
         super();
         addFrameScript(0,frame1,1,frame2);
         this.mouseEnabled = false;
         var _loc2_:Boolean = param1 is String ? false : true;
         if(!_loc2_)
         {
            return;
         }
         uniqueId = param1.buttonText;
         stateType = param1.stateType;
         this.buttonMode = true;
         this.mouseChildren = false;
         tfLabel.text = param1.buttonText;
         tfLabel.wordWrap = false;
         tfLabel.autoSize = TextFieldAutoSize.LEFT;
         mcDivider.x = tfLabel.width + PADDING;
         mcBGButton.width = tfLabel.width + 2 * PADDING;
         mcDisabled.width = mcBGButton.width - 9;
         if(null != param1.frameLabel)
         {
            gotoAndStop(String(param1.frameLabel));
            tfLabel.textColor = 16777215;
            mcDivider.visible = false;
         }
         mcBGButton.alpha = 0;
         this.hitArea = mcBGButton;
         tfLabel.filters = null;
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      public function hide() : void
      {
         this.visible = false;
         this.mouseEnabled = false;
      }
      
      override public function toString() : String
      {
         return "[object MainButton] uniqueId: " + uniqueId + ", stateType: " + stateType;
      }
      
      public function toggleDisabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.addChild(mcDisabled);
            this.mouseEnabled = false;
         }
         else
         {
            if(null != mcDisabled.parent)
            {
               mcDisabled.parent.removeChild(mcDisabled);
            }
            this.mouseEnabled = true;
         }
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      public function show() : void
      {
         this.visible = true;
         this.mouseEnabled = true;
      }
   }
}

