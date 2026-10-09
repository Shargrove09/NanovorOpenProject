package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.events.VirmonDataEvent;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import flash.events.Event;
   
   public class NanovorBadgeLoadee implements IChainLoadee
   {
      
      public static const NAME:String = "nanovorBadgeLoadee";
      
      private var _virmonManager:IVirmonManager;
      
      private var _nanovorAssetId:String;
      
      private var _chainLoader:IChainLoader;
      
      public function NanovorBadgeLoadee(param1:IVirmonManager, param2:String)
      {
         super();
         _virmonManager = param1;
         _nanovorAssetId = param2;
      }
      
      private function handleNanovorBadgeLoaded(param1:Event) : void
      {
         (param1.target as IVirmonData).removeEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,handleNanovorBadgeLoaded);
         (param1.target as IVirmonData).removeEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,handleNanovorBadgeError);
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function load() : void
      {
         var _loc1_:IVirmonData = _virmonManager.getVirmonData(_nanovorAssetId);
         if(_loc1_ == null)
         {
            return _chainLoader.handleChainLoadeeError();
         }
         _loc1_.addEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,handleNanovorBadgeLoaded,false,0,true);
         _loc1_.addEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,handleNanovorBadgeError,false,0,true);
         _loc1_.loadBadges();
      }
      
      private function handleNanovorBadgeError(param1:Event) : void
      {
         (param1.target as IVirmonData).removeEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,handleNanovorBadgeLoaded);
         (param1.target as IVirmonData).removeEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,handleNanovorBadgeError);
         _chainLoader.handleChainLoadeeError();
      }
      
      public function get name() : String
      {
         return NAME + _nanovorAssetId;
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

