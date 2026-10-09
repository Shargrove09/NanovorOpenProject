package com.arkadium.virmon.framework
{
   import com.adobe.utils.StringUtil;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.NullChainLoader;
   import com.arkadium.virmon.shared.utils.URLAssetChainLoadee;
   import com.smithandtinker.nanovor.common.utils.FastCipher;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.net.URLLoader;
   
   public class FileEncryptorChainLoadee implements IChainLoaderConsumer, IChainLoadee
   {
      
      private static const NAME:String = "FileEncryptorChainLoadee";
      
      private var _urlLoader:URLLoader;
      
      private var _myChainLoader:IChainLoader;
      
      private var _chainLoader:IChainLoader;
      
      private var _file:String;
      
      public function FileEncryptorChainLoadee(param1:String)
      {
         super();
         _chainLoader = new NullChainLoader();
         _file = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<FileEncryptorChainLoadee>> " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var _loc2_:String = String(param1.getLoadedAsset(_file));
         if(false == encryptFile(_file,_loc2_))
         {
            _chainLoader.handleChainLoadeeError();
         }
         log("Successfully encrypted files.");
         _chainLoader.handleChainLoadeeComplete();
      }
      
      private function encryptFile(param1:String, param2:String) : Boolean
      {
         var encodedText:String;
         var fileName:String = param1;
         var fileContent:String = param2;
         if(isFileEncoded(fileContent))
         {
            log("Skipping file (already encrypted): " + fileName);
            return true;
         }
         encodedText = null;
         try
         {
            encodedText = FastCipher.encode(fileContent);
         }
         catch(error:Error)
         {
            log("Failed to encode xml: " + fileName);
            return false;
         }
         Managers.mdmManager.mdmFilesystem.saveFile(Managers.mdmManager.mdmApplication.path + fileName.replace(/\//g,"\\"),encodedText);
         return true;
      }
      
      public function load() : void
      {
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         _loc1_.add(new URLAssetChainLoadee(_file));
         _myChainLoader = new ChainLoader(_loc1_,IChainLoaderConsumer(this));
         _myChainLoader.load();
      }
      
      private function isFileEncoded(param1:String) : Boolean
      {
         if(0 == StringUtil.trim(param1).length)
         {
            return true;
         }
         if(0 < new XML(param1).children().length())
         {
            return false;
         }
         return true;
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function get name() : String
      {
         return NAME;
      }
   }
}

