package com.smithandtinker.nanovor.debug
{
   import caurina.transitions.Tweener;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol10")]
   public class ClientListItemElement extends Sprite
   {
      
      private var _key:String;
      
      public var txtCurrentFilter:TextField;
      
      private var _displayName:String;
      
      public var btnHit:SimpleButton;
      
      public var txtDisplayName:TextField;
      
      public function ClientListItemElement(param1:String, param2:String, param3:String = "")
      {
         super();
         _key = param1;
         displayName = param2;
         currentFilter = param3;
      }
      
      public function showFilter() : void
      {
         if(txtCurrentFilter.text == "")
         {
            return;
         }
         Tweener.addTween(txtCurrentFilter,{
            "x":0 - txtCurrentFilter.width - 5,
            "time":0.3,
            "transition":"easeOutQuad"
         });
      }
      
      public function set displayName(param1:String) : void
      {
         _displayName = param1;
         txtDisplayName.text = param1;
         txtDisplayName.cacheAsBitmap = true;
         cacheAsBitmap = true;
         btnHit.tabEnabled = false;
      }
      
      public function get displayName() : String
      {
         return _displayName;
      }
      
      public function set currentFilter(param1:String) : void
      {
         txtCurrentFilter.autoSize = TextFieldAutoSize.LEFT;
         txtCurrentFilter.text = param1;
      }
      
      public function hideHilter() : void
      {
         Tweener.addTween(txtCurrentFilter,{
            "x":0,
            "time":0.3,
            "transition":"easeInQuad"
         });
      }
      
      public function get key() : String
      {
         return _key;
      }
   }
}

