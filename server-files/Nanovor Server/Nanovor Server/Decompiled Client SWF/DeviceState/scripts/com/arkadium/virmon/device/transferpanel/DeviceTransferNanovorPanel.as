package com.arkadium.virmon.device.transferpanel
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.device.DevicePanelBase;
   import com.arkadium.virmon.device.DevicePanelType;
   import com.arkadium.virmon.device.IDeviceNanovorWriter;
   import com.arkadium.virmon.device.ILoadProgressMonitor;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class DeviceTransferNanovorPanel extends DevicePanelBase implements ILoadProgressMonitor, IDeviceUIInstructionsConsumer
   {
      
      private var _deviceNanovorWriter:IDeviceNanovorWriter;
      
      private var _uiInstructions:DeviceTransferNanovorPanelUIInstructions;
      
      private var _transferDeviceNanovors:Array;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _previousIndex:int;
      
      private var _animationLoader:AnimationLoader;
      
      public function DeviceTransferNanovorPanel(param1:IDeviceNanovorWriter, param2:ICharacterAssetTypeCache)
      {
         super();
         _deviceNanovorWriter = param1;
         _characterAssetTypeCache = param2;
      }
      
      override public function setPanel() : void
      {
         log("setPanel()");
         _uiInstructions = new DeviceTransferNanovorPanelUIInstructions(_deviceUIController,IDeviceUIInstructionsConsumer(this));
         _deviceUIController.nextUIInstructions(_uiInstructions);
      }
      
      public function setUIFinished() : void
      {
         log("setUIFinished()");
         preloadNanovorAnimations();
      }
      
      private function finishedWriting() : void
      {
         _deviceUIController.getDeviceContents().resetNanovors();
         _deviceUIController.getSpinner().toggleTimer(false);
         _devicePanelController.nextPanel(DevicePanelType.DEVICE_PANEL_HOME);
      }
      
      private function showNanovors() : void
      {
         var _loc2_:INanovor = null;
         var _loc1_:int = 0;
         while(_loc1_ < _transferDeviceNanovors.length)
         {
            _loc2_ = _transferDeviceNanovors[_loc1_] as INanovor;
            _deviceUIController.getDeviceContents().addNanovor(_loc2_);
            _loc1_++;
         }
         _deviceUIController.getDeviceContents().show();
         Tweener.addCaller(this,{
            "time":0,
            "count":1,
            "delay":2,
            "onComplete":writeToDevice
         });
      }
      
      private function writeToDevice() : void
      {
         log("writeToDevice()");
         _uiInstructions.consoleAddText("ADDING...\n");
         _deviceUIController.getCenterStripe().show();
         updateProgress(0);
         _deviceNanovorWriter.writeDeviceNanovorList(_transferDeviceNanovors,ILoadProgressMonitor(this),finishedWriting);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceTransferNanovorPanel>>\t" + param1);
      }
      
      public function addStatusTextLine(param1:String) : void
      {
      }
      
      public function updateProgress(param1:Number) : void
      {
         var _loc4_:INanovor = null;
         var _loc5_:MovieClip = null;
         _deviceUIController.getDeviceContents().updateProgress(param1);
         log("File transfer percentage complete: " + Number(param1 * 100).toFixed(2) + "%");
         var _loc2_:int = int(param1 * _transferDeviceNanovors.length);
         if(_previousIndex == _loc2_)
         {
            return;
         }
         var _loc3_:Sprite = _deviceUIController.getNanoscope().getContents();
         if(_loc2_ < _transferDeviceNanovors.length)
         {
            _loc4_ = _transferDeviceNanovors[_loc2_];
            if("" == _loc4_.nickName)
            {
               _deviceUIController.getCenterStripe().setText(_loc4_.name.toUpperCase(),"");
            }
            else
            {
               _deviceUIController.getCenterStripe().setText(_loc4_.nickName,_loc4_.name.toUpperCase());
            }
            _uiInstructions.consoleAddText(-1 == _previousIndex ? "" : "DONE\n");
            _uiInstructions.consoleAddText(_loc4_.name + "...");
            while(_loc3_.numChildren > 0)
            {
               _loc3_.removeChildAt(0);
            }
            _loc5_ = _animationLoader.getNanovorAnimation(_loc4_);
            _loc5_.scaleX = _loc5_.scaleY = 0.75;
            _loc5_.x = 147;
            _loc5_.y = 40;
            _loc3_.addChild(_loc5_);
         }
         else
         {
            while(_loc3_.numChildren > 0)
            {
               _loc3_.removeChildAt(0);
            }
            _uiInstructions.consoleAddText("ACTIVATING CONTAINMENT FIELD");
         }
         _deviceUIController.getSpinner().setTimer(param1,1);
         _previousIndex = _loc2_;
      }
      
      public function replaceLastStatusTextLine(param1:String) : void
      {
      }
      
      private function preloadNanovorAnimations() : void
      {
         log("preloadNanovorAnimations()");
         _animationLoader = new AnimationLoader(_transferDeviceNanovors,showNanovors,_characterAssetTypeCache);
      }
      
      override public function destroy() : void
      {
         var _loc1_:MovieClip = null;
         super.destroy();
         if(_deviceUIController != null && _deviceUIController.getDeviceContents() != null)
         {
            _deviceUIController.getDeviceContents().clearNanovors();
         }
         if(_deviceUIController != null && _deviceUIController.getNanoscope() != null && _deviceUIController.getNanoscope().getContents() != null)
         {
            while(_deviceUIController.getNanoscope().getContents().numChildren > 0)
            {
               _loc1_ = _deviceUIController.getNanoscope().getContents().getChildAt(0) as MovieClip;
               _loc1_.stop();
               _deviceUIController.getNanoscope().getContents().removeChild(_loc1_);
            }
         }
      }
      
      public function setTransferNanovors(param1:Array) : void
      {
         log("setTransferNanovors()");
         _transferDeviceNanovors = param1;
         _previousIndex = -1;
      }
   }
}

import com.arkadium.virmon.battle.control.INanovor;
import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
import com.arkadium.virmon.shared.utils.ChainLoadeeList;
import com.arkadium.virmon.shared.utils.ChainLoader;
import com.arkadium.virmon.shared.utils.IAssetCache;
import com.arkadium.virmon.shared.utils.IChainLoader;
import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
import com.arkadium.virmon.shared.utils.chainloadees.NanovorAnimationLoader;
import flash.display.MovieClip;
import flash.utils.Dictionary;

class AnimationLoader implements IChainLoaderConsumer
{
   
   private var _loadFinishHandler:Function;
   
   private var _animations:Dictionary;
   
   private var _chainLoader:IChainLoader;
   
   private var _transferDeviceNanovors:Array;
   
   public function AnimationLoader(param1:Array, param2:Function, param3:ICharacterAssetTypeCache)
   {
      var _loc5_:INanovor = null;
      super();
      _transferDeviceNanovors = param1;
      _loadFinishHandler = param2;
      _animations = new Dictionary();
      var _loc4_:ChainLoadeeList = new ChainLoadeeList();
      for each(_loc5_ in _transferDeviceNanovors)
      {
         _loc4_.add(new NanovorAnimationLoader(_loc5_.assetTypeId,CharacterAnimationAssetType.IDLE,param3));
      }
      _chainLoader = new ChainLoader(_loc4_,IChainLoaderConsumer(this));
      _chainLoader.load();
   }
   
   public function getNanovorAnimation(param1:INanovor) : MovieClip
   {
      return _animations[param1];
   }
   
   public function handleChainLoaderComplete(param1:IAssetCache) : void
   {
      var _loc2_:INanovor = null;
      for each(_loc2_ in _transferDeviceNanovors)
      {
         _animations[_loc2_] = param1.getLoadedAsset(NanovorAnimationLoader.NAME + _loc2_.assetTypeId.toString() + CharacterAnimationAssetType.IDLE.name) as MovieClip;
      }
      _loadFinishHandler();
   }
}
