package com.arkadium.virmon.movieplayer
{
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol157")]
   public class VersionDisplay extends Sprite
   {
      
      public var _sdtVersionHistory:TextField;
      
      public var _nComboLength:Number;
      
      public var _aCombos:Array;
      
      public var _sVersionText:String;
      
      public var _nKeyDown:Number;
      
      public var _aTriggerCombo:Array;
      
      public var _aKeyDown:Array;
      
      public function VersionDisplay()
      {
         super();
         _sdtVersionHistory.text = "";
      }
   }
}

