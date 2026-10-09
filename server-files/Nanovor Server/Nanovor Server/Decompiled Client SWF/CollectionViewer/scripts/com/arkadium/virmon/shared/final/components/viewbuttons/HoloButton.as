package com.arkadium.virmon.shared.final.components.viewbuttons
{
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class HoloButton extends Sprite
   {
      
      public static const WIDTH:Number = 29.5;
      
      public static const HEIGHT:Number = 28.3;
      
      public static const ICON_A:String = "a";
      
      public static const ICON_S:String = "s";
      
      public static const ICON_PEDIGREE:String = "pedigree";
      
      public static const ICON_PLUS:String = "plus";
      
      public var tfLabel:TextField;
      
      private var iconHolder:Sprite;
      
      public function HoloButton(param1:String = "", param2:String = "")
      {
         super();
         if(param2 == "")
         {
            tfLabel.visible = false;
         }
         else
         {
            tfLabel.text = param2;
         }
         iconHolder = new Sprite();
         this.addChild(iconHolder);
         iconHolder.mouseEnabled = false;
         iconHolder.mouseChildren = false;
         icon = param1;
      }
      
      private function removeIcons() : void
      {
         while(iconHolder.numChildren > 0)
         {
            iconHolder.removeChildAt(0);
         }
      }
      
      public function set icon(param1:String) : void
      {
         removeIcons();
         switch(param1)
         {
            case ICON_A:
               iconHolder.addChild(new HoloButtonIconA());
               break;
            case ICON_S:
               iconHolder.addChild(new HoloButtonIconS());
               break;
            case ICON_PEDIGREE:
               iconHolder.addChild(new HoloButtonIconPedigree());
               break;
            case ICON_PLUS:
               iconHolder.addChild(new HoloButtonIconPlus());
         }
      }
   }
}

