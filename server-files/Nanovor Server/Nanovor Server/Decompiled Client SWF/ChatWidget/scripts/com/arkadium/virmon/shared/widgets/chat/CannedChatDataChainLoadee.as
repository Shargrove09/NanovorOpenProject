package com.arkadium.virmon.shared.widgets.chat
{
   import com.arkadium.virmon.framework.asset.enum.MasterDataAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.common.utils.FastCipher;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.Dictionary;
   
   public class CannedChatDataChainLoadee implements IChainLoadee
   {
      
      public static const NAME:String = "CannedChatDataChainLoadee";
      
      private var _chatDataLoader:URLLoader;
      
      private var _chainLoader:IChainLoader;
      
      public function CannedChatDataChainLoadee()
      {
         super();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<CannedChatDataChainLoadee>> " + param1);
      }
      
      public function load() : void
      {
         this._chatDataLoader = new URLLoader();
         this._chatDataLoader.addEventListener(Event.COMPLETE,this.handleCannedChatDataLoadComplete);
         this._chatDataLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleCannedChatDataLoadError);
         this._chatDataLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this._chatDataLoader.load(new URLRequest(Managers.assetRetrieverManager.masterDataAssetRetriever.getMasterDataURL(MasterDataAssetType.CHAT).url));
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         this._chainLoader = param1;
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      private function handleCannedChatDataLoadError(param1:IOErrorEvent) : void
      {
         this.log("handleCannedChatDataLoadError(): " + param1.text);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,this.handleCannedChatDataLoadComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.handleCannedChatDataLoadError);
         this._chainLoader.handleChainLoadeeError();
      }
      
      private function handleCannedChatDataLoadComplete(param1:Event) : void
      {
         var _loc3_:Dictionary = null;
         var _loc4_:Array = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         this.log("handleCannedChatDataLoadComplete()");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,this.handleCannedChatDataLoadComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.handleCannedChatDataLoadError);
         var _loc2_:Dictionary = new Dictionary();
         var _loc5_:XML = new XML(String(param1.target.data));
         if(0 == _loc5_.children().length())
         {
            _loc5_ = new XML(FastCipher.decode(String(param1.target.data)));
            if(0 == _loc5_.children().length())
            {
               this.log("handleCannedChatDataLoadComplete(): Error in XML.");
               return;
            }
         }
         for each(_loc6_ in _loc5_.cat)
         {
            _loc3_ = new Dictionary();
            for each(_loc7_ in _loc6_.group)
            {
               _loc4_ = new Array();
               for each(_loc8_ in _loc7_.phrase)
               {
                  _loc4_.push(_loc8_.@txt);
               }
               _loc3_[String(_loc7_.@txt)] = _loc4_;
            }
            _loc2_[String(_loc6_.@txt)] = _loc3_;
         }
         this._chainLoader.handleChainLoadeeComplete(_loc2_);
      }
   }
}

