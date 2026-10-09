package com.arkadium.virmon.collection.substates.nanovor
{
   import com.arkadium.virmon.collection.substates.nanovor.components.NanovorBadgesSliderComponent;
   import com.arkadium.virmon.collection.substates.nanovor.components.NanovorInfoPanelComponent;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.events.VirmonDataEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   
   public class NanovorBadgesPanel extends NanovorInfoPanelComponent
   {
      
      private var _slider:NanovorBadgesSliderComponent;
      
      public function NanovorBadgesPanel()
      {
         super();
         init();
      }
      
      private function addBadges() : void
      {
         var _loc1_:Array = _virmonData.getBadgeList();
         log("addBadges() nano has " + _loc1_.length + " badges. Creating now");
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _slider.addBadge(new NanovorBadge(_loc1_[_loc2_]));
            _loc2_++;
         }
         _slider.refresh();
      }
      
      override public function setNanovor(param1:IVirmonData, param2:String) : void
      {
         super.setNanovor(param1,param2);
         _virmonData.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,onBadgesLoaded);
         _virmonData.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,onBadgesError);
         _virmonData.addEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,onBadgesLoaded,false,0,true);
         _virmonData.addEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,onBadgesError,false,0,true);
         _virmonData.loadBadges();
      }
      
      private function onBadgesLoaded(param1:Event) : void
      {
         _virmonData.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,onBadgesLoaded);
         _virmonData.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,onBadgesError);
         _slider.clearBadges();
         addBadges();
         _slider.open();
      }
      
      private function init() : void
      {
         viewField.text = "BADGES";
         _slider = new NanovorBadgesSliderComponent();
         _slider.width = 9;
         _slider.y = _startY;
         addChild(_slider);
         mcMask.visible = true;
         _slider.mask = mcMask;
      }
      
      private function onBadgesError(param1:Event) : void
      {
         log("onBadgesError() Error loading badges");
         _virmonData.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,onBadgesLoaded);
         _virmonData.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,onBadgesError);
      }
      
      override public function destroy() : void
      {
         _slider.destroy();
         super.destroy();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorOverBadge: " + param1);
      }
      
      public function clearBadges() : void
      {
         _slider.clearBadges();
      }
   }
}

