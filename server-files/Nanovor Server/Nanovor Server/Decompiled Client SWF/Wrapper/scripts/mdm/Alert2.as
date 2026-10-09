package mdm
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public final class Alert2
   {
      
      private static var stage:Stage;
      
      private static var btnWidth:int = 45;
      
      private static var btnHeight:int = 21;
      
      public function Alert2()
      {
         super();
      }
      
      private static function createBtn(Colour:int) : SimpleButton
      {
         var colors:Array = null;
         var alphas:Array = null;
         var ratios:Array = null;
         var gradientMatrix:Matrix = null;
         var btnUpState:Sprite = null;
         var btnOverState:Sprite = null;
         var btnDownState:Sprite = null;
         var myButton:SimpleButton = null;
         colors = new Array();
         alphas = new Array(1,1,1);
         ratios = new Array(0,128,255);
         gradientMatrix = new Matrix();
         gradientMatrix.createGradientBox(btnWidth,btnHeight,Math.PI / 2,0,0);
         btnUpState = new Sprite();
         colors = [16777215,Colour,16777215];
         btnUpState.graphics.lineStyle(1);
         btnUpState.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,gradientMatrix);
         btnUpState.graphics.drawRect(0,0,btnWidth,btnHeight);
         btnUpState.addChild(getTextField("OK",true));
         btnOverState = new Sprite();
         colors = [16777215,brightenColour(Colour,50),16777215];
         btnOverState.graphics.lineStyle(1);
         btnOverState.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,gradientMatrix);
         btnOverState.graphics.drawRect(0,0,btnWidth,btnHeight);
         btnOverState.addChild(getTextField("OK",true));
         btnDownState = new Sprite();
         colors = [0,brightenColour(Colour,50),0];
         btnDownState.graphics.lineStyle(1);
         btnDownState.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,gradientMatrix);
         btnDownState.graphics.drawRect(0,0,btnWidth,btnHeight);
         btnDownState.addChild(getTextField("OK",true));
         return new SimpleButton(btnUpState,btnOverState,btnDownState,btnOverState);
      }
      
      private static function doStopDrag(event:MouseEvent) : void
      {
         if(event.target.name != "textfield")
         {
            if(event.target.name == "alert")
            {
               event.target.stopDrag();
            }
         }
      }
      
      private static function closeAlert(event:MouseEvent) : void
      {
         var OKbutton:Object = null;
         var BG:DisplayObject = null;
         var myAlert:Sprite = null;
         OKbutton = event.target;
         OKbutton.removeEventListener(MouseEvent.CLICK,closeAlert);
         BG = event.target.parent;
         BG.removeEventListener(MouseEvent.CLICK,doStartDrag);
         BG.removeEventListener(MouseEvent.CLICK,doStopDrag);
         myAlert = event.target.parent.parent.parent;
         removeBlockingListeners(myAlert);
         myAlert.parent.removeChild(myAlert);
      }
      
      private static function createPrompt(Text:String, Colour:int) : Sprite
      {
         var holder:Sprite = null;
         holder = new Sprite();
         holder.addEventListener(MouseEvent.MOUSE_DOWN,doStartDrag);
         holder.addEventListener(MouseEvent.MOUSE_UP,doStopDrag);
         holder.addChild(getPrompt(Text,Colour));
         holder.x = stage.stageWidth / 2 - holder.width / 2;
         holder.y = stage.stageHeight / 2 - holder.height / 2;
         holder.filters = [getFilter(Colour),getBlurFilter(Colour)];
         return holder;
      }
      
      private static function brightenColour(colour:int, modifier:int) : int
      {
         var hex:Array = null;
         var red:int = 0;
         var green:int = 0;
         var blue:int = 0;
         hex = hexToRGB(colour);
         red = keepInBounds(hex[0] + modifier);
         green = keepInBounds(hex[1] + modifier);
         blue = keepInBounds(hex[2] + modifier);
         return RGBToHex(red,green,blue);
      }
      
      public static function init(stageReference:Stage) : void
      {
         stage = stageReference;
      }
      
      private static function createBackground(Colour:int) : Sprite
      {
         var BackgroundBD:BitmapData = null;
         var bitmap:Bitmap = null;
         var Background:Sprite = null;
         BackgroundBD = new BitmapData(stage.stageWidth,stage.stageHeight,true,4278190080 + Colour);
         bitmap = new Bitmap(BackgroundBD);
         Background = new Sprite();
         Background.addChild(bitmap);
         Background.alpha = 0.3;
         return Background;
      }
      
      private static function assignListeners(myAlert:Sprite, callback:Function, blockMouse:Boolean) : void
      {
         var Background:Sprite = null;
         var Prompt:Sprite = null;
         var OKbutton:Sprite = null;
         var myFunction:Function = null;
         Background = myAlert.getChildAt(1) as Sprite;
         Prompt = Background.getChildAt(0) as Sprite;
         OKbutton = Prompt.getChildAt(2) as Sprite;
         if(callback != null)
         {
            myFunction = function(myEvent:MouseEvent):void
            {
               OKbutton.removeEventListener(MouseEvent.CLICK,myFunction);
               closeAlert(myEvent);
               callback();
            };
            OKbutton.addEventListener(MouseEvent.CLICK,myFunction);
         }
         else
         {
            OKbutton.addEventListener(MouseEvent.CLICK,closeAlert);
         }
         if(blockMouse)
         {
            myAlert.addEventListener(MouseEvent.CLICK,stopEvents);
            myAlert.doubleClickEnabled = true;
            myAlert.addEventListener(MouseEvent.DOUBLE_CLICK,stopEvents);
            myAlert.addEventListener(MouseEvent.MOUSE_MOVE,stopEvents);
            myAlert.addEventListener(MouseEvent.MOUSE_DOWN,stopEvents);
            myAlert.addEventListener(MouseEvent.MOUSE_OUT,stopEvents);
            myAlert.addEventListener(MouseEvent.MOUSE_OVER,stopEvents);
            myAlert.addEventListener(MouseEvent.MOUSE_UP,stopEvents);
            myAlert.addEventListener(MouseEvent.MOUSE_WHEEL,stopEvents);
            myAlert.addEventListener(MouseEvent.ROLL_OUT,stopEvents);
            myAlert.addEventListener(MouseEvent.ROLL_OVER,stopEvents);
         }
      }
      
      private static function getPrompt(Text:String, Colour:int) : Sprite
      {
         var BG:Sprite = null;
         var textField:TextField = null;
         var myWidth:Number = NaN;
         var myHeight:Number = NaN;
         var BackgroundBD:BitmapData = null;
         var bitmap:Bitmap = null;
         var OKbutton:SimpleButton = null;
         BG = new Sprite();
         BG.addEventListener(MouseEvent.MOUSE_DOWN,doStartDrag);
         BG.addEventListener(MouseEvent.MOUSE_UP,doStopDrag);
         BG.name = "alert";
         textField = getTextField(Text);
         myWidth = textField.width + 10;
         myHeight = textField.height + 55;
         if(myWidth < 150)
         {
            myWidth = 150;
         }
         if(myHeight < 100)
         {
            myHeight = 100;
         }
         if(myHeight > stage.stageHeight)
         {
            myHeight = stage.stageHeight - 20;
            textField.autoSize = TextFieldAutoSize.NONE;
            textField.height = stage.stageHeight - 40;
         }
         BackgroundBD = new BitmapData(myWidth,myHeight,true,4278190080 + Colour);
         bitmap = new Bitmap(BackgroundBD);
         BG.addChild(bitmap);
         textField.x = BG.width / 2 - textField.width / 2;
         textField.y = BG.height / 2 - textField.height / 2 - 10;
         BG.addChild(textField);
         OKbutton = createBtn(Colour);
         OKbutton.x = BG.width / 2 - OKbutton.width / 2;
         OKbutton.y = BG.height - 35;
         BG.addChild(OKbutton);
         return BG;
      }
      
      private static function getTextField(Text:String, bold:Boolean = false) : TextField
      {
         var myTextField:TextField = null;
         myTextField = new TextField();
         myTextField.name = "textfield";
         myTextField.multiline = true;
         myTextField.selectable = false;
         myTextField.autoSize = TextFieldAutoSize.CENTER;
         if(bold)
         {
            Text = "<b>" + Text + "</b>";
         }
         myTextField.htmlText = "<font face=\"Verdana\">" + Text + "</font>";
         myTextField.x = btnWidth / 2 - myTextField.width / 2;
         myTextField.y = btnHeight / 2 - myTextField.height / 2;
         return myTextField;
      }
      
      private static function keepInBounds(number:int) : int
      {
         if(number < 0)
         {
            number = 0;
         }
         if(number > 255)
         {
            number = 255;
         }
         return number;
      }
      
      private static function removeBlockingListeners(object:Sprite) : void
      {
         object.removeEventListener(MouseEvent.CLICK,stopEvents);
         object.removeEventListener(MouseEvent.DOUBLE_CLICK,stopEvents);
         object.removeEventListener(MouseEvent.MOUSE_MOVE,stopEvents);
         object.removeEventListener(MouseEvent.MOUSE_DOWN,stopEvents);
         object.removeEventListener(MouseEvent.MOUSE_OUT,stopEvents);
         object.removeEventListener(MouseEvent.MOUSE_OVER,stopEvents);
         object.removeEventListener(MouseEvent.MOUSE_UP,stopEvents);
         object.removeEventListener(MouseEvent.MOUSE_WHEEL,stopEvents);
         object.removeEventListener(MouseEvent.ROLL_OUT,stopEvents);
         object.removeEventListener(MouseEvent.ROLL_OVER,stopEvents);
      }
      
      private static function doStartDrag(event:MouseEvent) : void
      {
         if(event.target.name != "textfield")
         {
            if(event.target.name == "alert")
            {
               event.target.startDrag();
            }
         }
      }
      
      private static function getFilter(Colour:int) : *
      {
         var color:Number = NaN;
         var alpha:Number = NaN;
         var blurX:Number = NaN;
         var blurY:Number = NaN;
         var strength:Number = NaN;
         var inner:Boolean = false;
         var knockout:Boolean = false;
         var quality:Number = NaN;
         color = 16777215;
         alpha = 0.8;
         blurX = 15;
         blurY = 15;
         strength = 0.7;
         inner = true;
         knockout = false;
         quality = BitmapFilterQuality.HIGH;
         return new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout);
      }
      
      private static function RGBToHex(uR:int, uG:int, uB:int) : int
      {
         var uColor:uint = 0;
         uColor = uint((uR & 0xFF) << 16);
         uColor += (uG & 0xFF) << 8;
         return uint(uColor + (uB & 0xFF));
      }
      
      private static function getBlurFilter(Colour:int) : *
      {
         var color:Number = NaN;
         var angle:Number = NaN;
         var alpha:Number = NaN;
         var blurX:Number = NaN;
         var blurY:Number = NaN;
         var distance:Number = NaN;
         var strength:Number = NaN;
         var inner:Boolean = false;
         var knockout:Boolean = false;
         var quality:Number = NaN;
         color = 0;
         angle = 45;
         alpha = 0.6;
         blurX = 8;
         blurY = 8;
         distance = 4;
         strength = 1.3;
         inner = false;
         knockout = false;
         quality = BitmapFilterQuality.LOW;
         return new DropShadowFilter(distance,angle,color,alpha,blurX,blurY,strength,quality,inner,knockout);
      }
      
      public static function hexToRGB(hex:uint) : Array
      {
         var Colours:Array = null;
         var temp:uint = 0;
         Colours = new Array();
         Colours.push(hex >> 16);
         temp = uint(hex ^ Colours[0] << 16);
         Colours.push(temp >> 8);
         Colours.push(temp ^ Colours[1] << 8);
         return Colours;
      }
      
      private static function stopEvents(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
      }
      
      public static function show(Text:* = "Made by Dark Vyper", callback:Function = null, Colour:int = 10380027, blockMouse:Boolean = true) : void
      {
         var myAlert:Sprite = null;
         if(stage == null)
         {
            return;
         }
         myAlert = new Sprite();
         myAlert.addChild(createBackground(Colour));
         myAlert.addChild(createPrompt(Text.toString(),Colour));
         assignListeners(myAlert,callback,blockMouse);
         stage.addChild(myAlert);
      }
   }
}

