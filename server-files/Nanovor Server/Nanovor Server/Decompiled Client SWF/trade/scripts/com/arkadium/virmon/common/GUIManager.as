package com.arkadium.virmon.common
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class GUIManager extends MovieClip
   {
      
      public var _aGUIPanels:Array;
      
      public var _smcScrim:MovieClip;
      
      private var _aVisiblePanels:Array;
      
      public function GUIManager()
      {
         super();
         if(_smcScrim != null)
         {
            _smcScrim.stop();
            if(contains(_smcScrim))
            {
               removeChild(_smcScrim);
            }
         }
         _aVisiblePanels = new Array();
      }
      
      public function registerPanel(param1:GUIPanel, param2:String) : Boolean
      {
         if(_aGUIPanels == null)
         {
            _aGUIPanels = new Array();
         }
         if(Boolean(param2))
         {
            if(!getPanelInstance(param2))
            {
               param1.visible = false;
               _aGUIPanels.push(param1);
               return true;
            }
            trace("GUIManager: registerPanel() - GUI Panel \"" + param2 + "\" already exists and was not registered.");
         }
         return false;
      }
      
      public function hidePanel(param1:String) : *
      {
         var _loc2_:GUIPanel = null;
         if(Boolean(param1))
         {
            _loc2_ = removeVisiblePanel(param1);
            if(Boolean(_loc2_))
            {
               reorderVisiblePanels();
               _loc2_.hidePanel();
               removeChild(_loc2_);
            }
            return;
         }
         return undefined;
      }
      
      public function getPanelInstance(param1:String) : GUIPanel
      {
         var _loc2_:uint = 0;
         while(_loc2_ < _aGUIPanels.length)
         {
            if(param1 == _aGUIPanels[_loc2_].getPanelName())
            {
               return _aGUIPanels[_loc2_];
            }
            _loc2_++;
         }
         return undefined;
      }
      
      public function scrimFunction(param1:MouseEvent) : void
      {
      }
      
      private function reorderVisiblePanels() : *
      {
         var _loc1_:Number = NaN;
         if(_aVisiblePanels.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < _aVisiblePanels.length - 1)
            {
               addChild(_aVisiblePanels[_loc1_]);
               _loc1_++;
            }
         }
      }
      
      public function showPanel(param1:String) : GUIPanel
      {
         var _loc2_:GUIPanel = null;
         if(_aVisiblePanels == null)
         {
            _aVisiblePanels = new Array();
         }
         if(Boolean(param1))
         {
            _loc2_ = removeVisiblePanel(param1);
            if(!_loc2_)
            {
               _loc2_ = getPanelInstance(param1);
               if(!_loc2_)
               {
                  return undefined;
               }
            }
            _aVisiblePanels.push(_loc2_);
            reorderVisiblePanels();
            _loc2_.showPanel();
            if(!this.contains(_loc2_))
            {
               addChild(_loc2_);
            }
            else
            {
               _loc2_.visible = true;
            }
            return _loc2_;
         }
         return undefined;
      }
      
      public function hideAllPanels() : *
      {
         var _loc1_:GUIPanel = null;
         while(Boolean(_aVisiblePanels.length))
         {
            _loc1_ = GUIPanel(_aVisiblePanels.shift());
            _loc1_.hidePanel();
            removeChild(_loc1_);
         }
      }
      
      public function onInitialize() : *
      {
         DebugLog.instance.log("GUIManager::onInitialize()  initializing internal panels");
         var _loc1_:Number = 0;
         while(_loc1_ < _aGUIPanels.length)
         {
            _aGUIPanels[_loc1_].onInitialize();
            _loc1_++;
         }
      }
      
      public function clearAll() : void
      {
         _aGUIPanels = null;
         _aVisiblePanels = null;
      }
      
      private function removeVisiblePanel(param1:String) : GUIPanel
      {
         var _loc2_:Number = _aVisiblePanels.length - 1;
         while(_loc2_ >= 0)
         {
            if(param1 == _aVisiblePanels[_loc2_].getPanelName())
            {
               return _aVisiblePanels.splice(_loc2_,1)[0];
            }
            _loc2_--;
         }
         return null;
      }
      
      public function unRegisterPanel(param1:GUIPanel, param2:String) : *
      {
         var _loc3_:uint = 0;
         if(Boolean(param1))
         {
            removeVisiblePanel(param2);
            removeChild(param1);
            _loc3_ = 0;
            while(_loc3_ < _aGUIPanels.length)
            {
               if(_aGUIPanels[_loc3_] == param1)
               {
                  _aGUIPanels.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
         }
      }
   }
}

