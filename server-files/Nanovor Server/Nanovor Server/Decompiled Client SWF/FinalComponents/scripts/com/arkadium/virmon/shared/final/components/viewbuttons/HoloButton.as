package com.arkadium.virmon.shared.final.components.viewbuttons
{
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol421")]
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
            this.tfLabel.visible = false;
         }
         else
         {
            this.tfLabel.text = param2;
         }
         this.iconHolder = new Sprite();
         this.addChild(this.iconHolder);
         this.iconHolder.mouseEnabled = false;
         this.iconHolder.mouseChildren = false;
         this.icon = param1;
      }
      
      private function removeIcons() : void
      {
         while(this.iconHolder.numChildren > 0)
         {
            this.iconHolder.removeChildAt(0);
         }
      }
      
      public function set icon(param1:String) : void
      {
         this.removeIcons();
         switch(param1)
         {
            case ICON_A:
               this.iconHolder.addChild(new HoloButtonIconA());
               break;
            case ICON_S:
               this.iconHolder.addChild(new HoloButtonIconS());
               break;
            case ICON_PEDIGREE:
               this.iconHolder.addChild(new HoloButtonIconPedigree());
               break;
            case ICON_PLUS:
               this.iconHolder.addChild(new HoloButtonIconPlus());
         }
      }
   }
}

