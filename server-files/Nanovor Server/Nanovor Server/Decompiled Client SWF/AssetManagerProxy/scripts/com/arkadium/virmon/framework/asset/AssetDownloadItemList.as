package com.arkadium.virmon.framework.asset
{
   public class AssetDownloadItemList implements IAssetDownloadItemList
   {
      
      private var _list:Array;
      
      public function AssetDownloadItemList()
      {
         super();
         _list = [];
      }
      
      private function isEmpty(param1:String) : Boolean
      {
         return Boolean(param1 == null || param1 == "");
      }
      
      public function removeItem(param1:IAssetDownloadItem) : void
      {
         if(-1 == _list.indexOf(param1))
         {
            return;
         }
         _list.splice(_list.indexOf(param1),1);
      }
      
      public function getItem(param1:int) : IAssetDownloadItem
      {
         if(param1 > _list.length || param1 < 0)
         {
            return null;
         }
         return _list[param1] as IAssetDownloadItem;
      }
      
      public function get supersededItemsCount() : int
      {
         var _loc2_:IAssetDownloadItem = null;
         var _loc1_:int = 0;
         for each(_loc2_ in _list)
         {
            if(!isEmpty(_loc2_.asset.superId))
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function get length() : uint
      {
         return _list.length;
      }
      
      public function pop() : IAssetDownloadItem
      {
         if(_list.length == 0)
         {
            return null;
         }
         return _list.pop() as IAssetDownloadItem;
      }
      
      public function concat(param1:IAssetDownloadItemList) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            push(param1.getItem(_loc2_));
            _loc2_++;
         }
      }
      
      public function push(param1:IAssetDownloadItem) : void
      {
         if(false == param1 is IAssetDownloadItem)
         {
            throw new Error("Parameter \'item\' must be of type IAssetDownloadItem but was \'" + param1 + "\'");
         }
         _list.push(param1);
      }
      
      public function sort(param1:Function) : Array
      {
         return _list.sort(param1);
      }
   }
}

