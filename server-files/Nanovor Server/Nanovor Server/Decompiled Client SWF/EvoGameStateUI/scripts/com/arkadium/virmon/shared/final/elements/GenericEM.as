package com.arkadium.virmon.shared.final.elements
{
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.EMData;
   import com.arkadium.virmon.framework.EMMasterData;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   
   public class GenericEM extends MovieClip
   {
      
      private static const STONE_FILTER_1:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0,0,0,0,0,0,0,0,1,0,150,0,0,0,1,0]);
      
      private static const STONE_FILTER_2:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,-120,0,1,0,0,30,0,0,1,0,255,0,0,0,1,0]);
      
      private static const STONE_FILTER_3:ColorMatrixFilter = new ColorMatrixFilter([0,0,0,0,0,0,1,0,0,70,0,0,0,0,0,0,0,0,2,0]);
      
      private static const STONE_FILTER_4:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,100,0,1,0,0,70,0,0,0,0,0,0,0,0,2,0]);
      
      private static const STONE_FILTER_5:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,70,0,1,0,0,-20,0,0,0,0,0,0,0,0,1,0]);
      
      private static const STONE_FILTER_6:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,40,0,1,0,0,-120,0,0,0,0,0,0,0,0,1,0]);
      
      public var tfLabel:TextField;
      
      public var stone:MovieClip;
      
      private var _data:EMData;
      
      private var _masterData:EMMasterData;
      
      public var assetId:String;
      
      private var _id:int;
      
      public var housing:MovieClip;
      
      public function GenericEM(param1:int = -1)
      {
         super();
         if(param1 > -1)
         {
            setId(param1);
         }
      }
      
      public function getData() : EMMasterData
      {
         return _masterData;
      }
      
      public function startCrystal() : void
      {
         try
         {
            MovieClip(stone.getChildAt(0)).play();
         }
         catch(e:Error)
         {
            logError("startCrystal: " + e.message);
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** GenericEM: " + param1);
      }
      
      private function getCrystal(param1:String) : MovieClip
      {
         var _loc2_:* = undefined;
         switch(param1)
         {
            case "7":
               _loc2_ = new GenericEMCrystalFoilElement();
               break;
            case "6":
            case "5":
               _loc2_ = new GenericEMCrystalRareElement();
               break;
            case "4":
            case "3":
               _loc2_ = new GenericEMCrystalUncommonElement();
               break;
            case "2":
            case "1":
            default:
               _loc2_ = new GenericEMCrystalCommonElement();
         }
         return _loc2_ as MovieClip;
      }
      
      public function setId(param1:int) : void
      {
         var _loc2_:GlowFilter = null;
         _id = param1;
         _masterData = DataManager.getInstance().getEMManager().getEMMasterData(param1);
         tfLabel.text = _masterData.getShortName();
         stone.addChild(getCrystal(_masterData.getShortName().charAt(2)));
         addStoneColorFilter(_masterData.getShortName().charAt(2));
         if(_masterData.getShortName().charAt(2) == "7")
         {
            _loc2_ = new GlowFilter(16293481,1,8,8,1.5);
            tfLabel.filters = [_loc2_];
            housing.gotoAndStop("foil_" + _masterData.getFaction().toLowerCase());
         }
         else
         {
            housing.gotoAndStop(_masterData.getFaction().toLowerCase());
         }
      }
      
      public function getID() : int
      {
         return _id;
      }
      
      private function addStoneColorFilter(param1:String) : void
      {
         var _loc2_:ColorMatrixFilter = GenericEM["STONE_FILTER_" + param1];
         if(_loc2_ == null)
         {
            return;
         }
         stone.filters = [_loc2_];
      }
      
      public function stopCrystal() : void
      {
         try
         {
            MovieClip(stone.getChildAt(0)).stop();
         }
         catch(e:Error)
         {
            logError("stopCrystal: " + e.message);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> GenericEM: " + param1);
      }
   }
}

