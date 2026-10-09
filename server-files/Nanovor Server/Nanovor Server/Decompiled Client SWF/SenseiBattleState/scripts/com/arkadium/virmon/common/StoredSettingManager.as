package com.arkadium.virmon.common
{
   import com.smithandtinker.nanovor.common.utils.Cipher;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.EventDispatcher;
   
   public class StoredSettingManager extends EventDispatcher
   {
      
      private static var _oInstance:StoredSettingManager;
      
      private const _USE_CIPHER:Boolean = true;
      
      private var _bLoaded:Boolean = false;
      
      private var _oStore:Object = new Object();
      
      private var _bStateFileBusy:Boolean = false;
      
      private var _szFilePath:String = null;
      
      private const _FILE_NAME:String = "NanovorPrefs";
      
      private var _oMDMFS:*;
      
      public function StoredSettingManager()
      {
         super();
      }
      
      public static function getInstance() : StoredSettingManager
      {
         if(!_oInstance)
         {
            _oInstance = new StoredSettingManager();
         }
         return _oInstance;
      }
      
      public function get isBusy() : Boolean
      {
         return _bStateFileBusy;
      }
      
      public function storeSettingAndSave(param1:String, param2:*) : void
      {
         storeSetting(param1,param2);
         _generateAndWriteFile();
      }
      
      private function _writeFile(param1:String) : void
      {
         if(_oMDMFS == null)
         {
            logError("_writeFile: _oMDMFS==null!");
            return;
         }
         if(_bStateFileBusy == true)
         {
            return;
         }
         if(param1.indexOf("<settings>") == -1)
         {
            param1 = "";
         }
         _bStateFileBusy = true;
         var _loc2_:String = _USE_CIPHER ? Cipher.encode(param1) : param1;
         _oMDMFS.saveFile(_szFilePath,_loc2_);
         _bStateFileBusy = false;
      }
      
      public function set isBusy(param1:Boolean) : *
      {
         _bStateFileBusy = param1;
      }
      
      public function deleteSettingAndSave(param1:String) : void
      {
         if(_oStore[param1] === undefined)
         {
            return;
         }
         delete _oStore[param1];
         _generateAndWriteFile();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<StoredSettingManager>>\t" + param1);
      }
      
      public function saveSettingsToDisk() : void
      {
         _generateAndWriteFile();
      }
      
      public function getSetting(param1:String) : *
      {
         if(!_bLoaded)
         {
            return null;
         }
         if(_oStore[param1] === null || _oStore[param1] === undefined)
         {
            return null;
         }
         return StoredSetting(_oStore[param1]).value;
      }
      
      private function _generateAndWriteFile() : void
      {
         var _loc1_:StoredSetting = null;
         var _loc3_:String = null;
         var _loc2_:String = "<settings>\n";
         for(_loc3_ in _oStore)
         {
            _loc1_ = StoredSetting(_oStore[_loc3_]);
            _loc2_ += "\t" + _loc1_.getXMLString() + "\n";
         }
         _loc2_ += "</settings>";
         _writeFile(_loc2_);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<StoredSettingManager>>\t" + param1);
      }
      
      public function loadSettings() : void
      {
         var _loc4_:StoredSetting = null;
         _bLoaded = true;
         if(_szFilePath === null)
         {
            DebugLog.instance.error("** StoredSettingManager: loadSettings() needs _szFilePath to be set, but it\'s null.  This is not cool!");
            return;
         }
         if(!_oMDMFS.fileExists(_szFilePath))
         {
            return;
         }
         var _loc1_:String = _oMDMFS.loadFile(_szFilePath);
         if(_loc1_ === null || _loc1_.length == 0)
         {
            return;
         }
         var _loc2_:String = getValidXML(_loc1_);
         var _loc3_:XML = new XML(_loc2_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.setting.length())
         {
            _loc4_ = new StoredSetting();
            _loc4_.parseXML(_loc3_.setting[_loc5_]);
            _oStore[_loc4_.name] = _loc4_;
            _loc5_++;
         }
      }
      
      private function getValidXML(param1:String) : String
      {
         var _loc2_:String = null;
         if(param1 === null || !param1.length)
         {
            return null;
         }
         if(param1.indexOf("<settings>") == -1)
         {
            _loc2_ = Cipher.decode(param1);
            if(!_USE_CIPHER)
            {
               _writeFile(_loc2_);
            }
         }
         else
         {
            _loc2_ = param1;
            if(_USE_CIPHER)
            {
               _writeFile(_loc2_);
            }
         }
         return _loc2_;
      }
      
      public function storeSetting(param1:String, param2:*) : void
      {
         var _loc3_:StoredSetting = new StoredSetting();
         _loc3_.name = param1;
         _loc3_.value = param2;
         _oStore[_loc3_.name] = _loc3_;
      }
      
      public function getSettingOrSetDefault(param1:String, param2:*) : *
      {
         var _loc3_:* = getSetting(param1);
         if(_loc3_ === null)
         {
            storeSettingAndSave(param1,param2);
         }
         return getSetting(param1);
      }
      
      public function setSystemPath(param1:String) : void
      {
         _szFilePath = param1 + _FILE_NAME;
      }
      
      public function setMDMRef(param1:*) : void
      {
         _oMDMFS = param1;
      }
   }
}

