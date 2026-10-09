package com.arkadium.virmon.shared.final.components.infowindow
{
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionHexite;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionMagnamod;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionVelocitron;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol386")]
   public class InfoWindowTitle extends MovieClip
   {
      
      public static const COLOR_SCHEME_BLUE:String = "blue";
      
      public static const COLOR_SCHEME_GREEN:String = "green";
      
      public static const BG_COLOR_BLUE:uint = 1268106;
      
      public static const BG_COLOR_GREEN:uint = 9288235;
      
      public static const LABEL_COLOR_BLUE:uint = 7716598;
      
      public static const LABEL_COLOR_GREEN:uint = 11200521;
      
      public var tfNickName:TextField;
      
      public var mcSvBG:Sprite;
      
      public var mcFaction:MovieClip;
      
      public var tfName:TextField;
      
      public var tfSVNumber:TextField;
      
      public var tfSVLabel:TextField;
      
      public function InfoWindowTitle()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function showSV() : void
      {
         this.tfSVLabel.visible = this.tfSVNumber.visible = this.mcSvBG.visible = true;
      }
      
      public function set nanovorNickName(param1:String) : void
      {
         this.tfNickName.text = param1;
      }
      
      public function set nanovorName(param1:String) : void
      {
         this.tfName.text = param1;
      }
      
      public function set colorScheme(param1:String) : void
      {
         var _loc2_:ColorTransform = new ColorTransform();
         switch(param1)
         {
            case COLOR_SCHEME_BLUE:
               _loc2_.color = BG_COLOR_BLUE;
               this.tfSVLabel.textColor = LABEL_COLOR_BLUE;
               break;
            case COLOR_SCHEME_GREEN:
               _loc2_.color = BG_COLOR_GREEN;
               this.tfSVLabel.textColor = LABEL_COLOR_GREEN;
         }
         this.mcSvBG.transform.colorTransform = _loc2_;
      }
      
      public function hideSV() : void
      {
         this.tfSVLabel.visible = this.tfSVNumber.visible = this.mcSvBG.visible = false;
      }
      
      public function set sv(param1:int) : void
      {
         this.tfSVNumber.text = param1.toString();
         this.tfSVNumber.autoSize = TextFieldAutoSize.LEFT;
         this.tfSVLabel.x = this.tfSVNumber.getBounds(this).width + this.tfSVNumber.x;
      }
      
      public function set faction(param1:String) : void
      {
         var _loc2_:Sprite = null;
         while(this.mcFaction.numChildren > 0)
         {
            this.mcFaction.removeChildAt(0);
         }
         switch(param1)
         {
            case Icon.FACTION_MAGNAMOD:
               _loc2_ = new FactionMagnamod();
               break;
            case Icon.FACTION_VELOCITRON:
               _loc2_ = new FactionVelocitron();
               break;
            case Icon.FACTION_HEXITE:
               _loc2_ = new FactionHexite();
               break;
            default:
               _loc2_ = new MovieClip();
         }
         this.mcFaction.addChild(_loc2_);
      }
   }
}

