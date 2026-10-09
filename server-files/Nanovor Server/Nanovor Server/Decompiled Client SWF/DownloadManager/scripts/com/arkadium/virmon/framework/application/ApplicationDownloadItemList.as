package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.framework.application.enum.PackagePriority;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class ApplicationDownloadItemList implements IApplicationDownloadItemList
   {
      
      private var _list:Array;
      
      public function ApplicationDownloadItemList()
      {
         super();
         _list = [];
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationDownloadItemList: " + param1);
      }
      
      public function hasDownloadItemsWithPriority(param1:PackagePriority) : Boolean
      {
         var _loc2_:IApplicationDownloadItem = null;
         for each(_loc2_ in _list)
         {
            if(_loc2_.priority <= param1.priority)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getItem(param1:int) : IApplicationDownloadItem
      {
         if(param1 > _list.length || param1 < 0)
         {
            return null;
         }
         return _list[param1] as IApplicationDownloadItem;
      }
      
      private function sorter(param1:IApplicationDownloadItem, param2:IApplicationDownloadItem) : Number
      {
         if(param1.priority > param2.priority)
         {
            return -1;
         }
         if(param1.priority < param2.priority)
         {
            return 1;
         }
         return 0;
      }
      
      public function getItemsByPriority(param1:PackagePriority) : IApplicationDownloadItemList
      {
         var _loc3_:IApplicationDownloadItem = null;
         var _loc2_:IApplicationDownloadItemList = new ApplicationDownloadItemList();
         for each(_loc3_ in _list)
         {
            if(_loc3_.priority <= param1.priority)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function pop() : IApplicationDownloadItem
      {
         if(_list.length == 0)
         {
            return null;
         }
         return _list.pop() as IApplicationDownloadItem;
      }
      
      public function concat(param1:IApplicationDownloadItemList) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            push(param1.getItem(_loc2_));
            _loc2_++;
         }
      }
      
      public function getItemByFile(param1:IApplicationFile) : IApplicationDownloadItem
      {
         var _loc2_:IApplicationDownloadItem = null;
         for each(_loc2_ in _list)
         {
            if(_loc2_.file == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function sort() : Array
      {
         return _list.sort(sorter);
      }
      
      public function push(param1:IApplicationDownloadItem) : void
      {
         if(false == param1 is IApplicationDownloadItem)
         {
            throw new Error("Parameter \'item\' must be of type IApplicationDownloadItem but was \'" + param1 + "\'");
         }
         _list.push(param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationDownloadItemList: " + param1);
      }
      
      public function get length() : uint
      {
         return _list.length;
      }
      
      public function removeItem(param1:IApplicationDownloadItem) : void
      {
         if(-1 == _list.indexOf(param1))
         {
            return;
         }
         _list.splice(_list.indexOf(param1),1);
      }
   }
}

