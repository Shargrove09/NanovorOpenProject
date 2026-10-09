package com.arkadium.virmon.device.ui
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.framework.memorywatcher.MemoryWatcher;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   
   public class DeviceContents extends Sprite implements IDeviceContents
   {
      
      private static const TWEEN_BASE:Object = {
         "time":1,
         "transition":Equations.easeInOutQuad
      };
      
      public static const WIDTH:Number = 1024;
      
      private static const NANOVOR_SPACING:Number = 94;
      
      private var _swarmItems:Array;
      
      private var _swarmContainer:Sprite;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _currentDeviceContentItem:DeviceContentNanovor;
      
      private var _contentContainer:Sprite;
      
      public function DeviceContents(param1:ICharacterAssetTypeCache, param2:Sprite = null)
      {
         super();
         _characterAssetTypeCache = param1;
         _contentContainer = param2;
      }
      
      public function hide() : void
      {
         toggleThisAlpha(0);
      }
      
      public function addNanovor(param1:INanovor, param2:String = "stateNormal") : void
      {
         var _loc3_:DeviceContentNanovor = new DeviceContentNanovor(param1,_contentContainer,_characterAssetTypeCache);
         _loc3_.setState(param2);
         _loc3_.x = _swarmContainer.numChildren * NANOVOR_SPACING;
         _swarmContainer.addChild(_loc3_);
         _swarmContainer.x = 512 - (_swarmContainer.numChildren - 1) * NANOVOR_SPACING / 2;
         _swarmItems.push(_loc3_);
         MemoryWatcher.registerObject(_loc3_,"nanovor" + int(Math.random() * 1000));
      }
      
      public function init() : void
      {
         _swarmContainer = new Sprite();
         this.addChild(_swarmContainer);
         _swarmItems = new Array();
         _currentDeviceContentItem = new DeviceContentNanovor(null);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceContents>>\t" + param1);
      }
      
      public function resetNanovors() : void
      {
         var _loc2_:DeviceContentNanovor = null;
         log("resetNanovors()");
         var _loc1_:int = 0;
         while(_loc1_ < _swarmItems.length)
         {
            _loc2_ = _swarmItems[_loc1_] as DeviceContentNanovor;
            _loc2_.setState(DeviceContentNanovor.STATE_DEVICE);
            _loc1_++;
         }
      }
      
      public function updateProgress(param1:Number) : void
      {
         var _loc2_:int = param1 * _swarmItems.length;
         if(_swarmItems[_loc2_] === _currentDeviceContentItem)
         {
            return;
         }
         _currentDeviceContentItem.setState(DeviceContentNanovor.STATE_DEVICE);
         if(_loc2_ < _swarmItems.length)
         {
            _currentDeviceContentItem = _swarmItems[_loc2_];
            _currentDeviceContentItem.setState(DeviceContentNanovor.STATE_ADDING);
         }
      }
      
      public function clearNanovors() : void
      {
         var _loc1_:DeviceContentNanovor = null;
         log("clearNanovors() clearing nanovors from memory");
         _swarmItems = new Array();
         while(_swarmContainer.numChildren > 0)
         {
            _loc1_ = _swarmContainer.removeChildAt(0) as DeviceContentNanovor;
            _loc1_.destroy();
         }
      }
      
      private function toggleThisAlpha(param1:Number) : void
      {
         Tweener.addTween(this,{
            "_autoAlpha":param1,
            "base":TWEEN_BASE
         });
      }
      
      public function destroy() : void
      {
         clearNanovors();
         if(_currentDeviceContentItem != null)
         {
            _currentDeviceContentItem.destroy();
         }
      }
      
      public function show() : void
      {
         toggleThisAlpha(1);
      }
   }
}

