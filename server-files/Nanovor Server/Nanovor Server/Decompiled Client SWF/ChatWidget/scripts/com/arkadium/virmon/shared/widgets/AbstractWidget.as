package com.arkadium.virmon.shared.widgets
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   
   public class AbstractWidget extends MovieClip implements IWidget
   {
      
      private var _widgetName:String;
      
      public function AbstractWidget(param1:WidgetType)
      {
         super();
         this._widgetName = param1.name;
         this.tabEnabled = false;
         this.tabChildren = false;
      }
      
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this)
         {
            this[_loc1_] = null;
         }
         delete global[this];
      }
      
      public function log(param1:*) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = param1 is Array ? "[Array]\n" : "";
         if(param1 is String)
         {
            param1 = [param1];
         }
         if(param1.length == 1)
         {
            _loc2_ = param1[0];
         }
         else
         {
            for(_loc3_ in param1)
            {
               _loc2_ += "\n\t[" + _loc3_ + "] " + param1[_loc3_];
            }
         }
         trace("<<" + this._widgetName + ">>\t" + _loc2_);
         DebugLog.instance.log("<<" + this._widgetName + ">>\t" + _loc2_);
      }
      
      public function logError(param1:String) : void
      {
         trace("<<" + this._widgetName + ">>ERROR: -->\t" + param1);
         DebugLog.instance.error("<<" + this._widgetName + ">>ERROR: -->\t" + param1);
      }
      
      public function setMode(param1:String) : void
      {
      }
      
      public function init(param1:Object = null) : void
      {
         throw new Error("IWidget subclass must implement init().");
      }
      
      public function get widgetName() : String
      {
         return this._widgetName;
      }
   }
}

