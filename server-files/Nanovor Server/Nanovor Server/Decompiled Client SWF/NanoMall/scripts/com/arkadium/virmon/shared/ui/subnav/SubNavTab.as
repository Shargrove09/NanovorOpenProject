package com.arkadium.virmon.shared.ui.subnav
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol127")]
   public dynamic class SubNavTab extends MovieClip
   {
      
      public var arml:MovieClip;
      
      public var hit:SimpleButton;
      
      public var tab:MovieClip;
      
      public var armr:MovieClip;
      
      public function SubNavTab()
      {
         super();
         addFrameScript(0,frame1,7,frame8,14,frame15,24,frame25,27,frame28,29,frame30,42,frame43,43,frame44,45,frame46,53,frame54,64,frame65);
      }
      
      internal function frame1() : *
      {
         tab.gotoAndStop(1);
         stop();
      }
      
      internal function frame65() : *
      {
         gotoAndStop(1);
      }
      
      internal function frame8() : *
      {
         stop();
      }
      
      internal function frame44() : *
      {
         arml.gotoAndPlay("move");
         armr.gotoAndPlay("move");
         tab.gotoAndPlay("back");
      }
      
      internal function frame54() : *
      {
         tab.gotoAndStop(1);
      }
      
      internal function frame46() : *
      {
      }
      
      internal function frame15() : *
      {
         gotoAndStop(1);
      }
      
      internal function frame25() : *
      {
      }
      
      internal function frame30() : *
      {
         tab.gotoAndPlay("forward");
      }
      
      internal function frame28() : *
      {
         arml.gotoAndPlay("move");
         armr.gotoAndPlay("move");
      }
      
      internal function frame43() : *
      {
         stop();
      }
   }
}

