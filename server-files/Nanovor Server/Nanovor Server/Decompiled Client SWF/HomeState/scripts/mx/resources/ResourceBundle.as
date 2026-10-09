package mx.resources
{
   import flash.system.ApplicationDomain;
   import mx.core.mx_internal;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class ResourceBundle implements IResourceBundle
   {
      
      mx_internal static var backupApplicationDomain:ApplicationDomain;
      
      mx_internal static var locale:String;
      
      mx_internal static const VERSION:String = "3.3.0.4852";
      
      mx_internal var _locale:String;
      
      private var _content:Object = {};
      
      mx_internal var _bundleName:String;
      
      public function ResourceBundle(locale:String = null, bundleName:String = null)
      {
         super();
         mx_internal::_locale = locale;
         mx_internal::_bundleName = bundleName;
         _content = getContent();
      }
      
      private static function getClassByName(name:String, domain:ApplicationDomain) : Class
      {
         var c:Class = null;
         if(domain.hasDefinition(name))
         {
            c = domain.getDefinition(name) as Class;
         }
         return c;
      }
      
      [Deprecated(replacement="ResourceManager.getInstance().getResourceBundle()",since="3.0")]
      public static function getResourceBundle(baseName:String, currentDomain:ApplicationDomain = null) : ResourceBundle
      {
         var className:String = null;
         var bundleClass:Class = null;
         var bundleObj:Object = null;
         var bundle:ResourceBundle = null;
         if(!currentDomain)
         {
            currentDomain = ApplicationDomain.currentDomain;
         }
         className = mx_internal::locale + "$" + baseName + "_properties";
         bundleClass = getClassByName(className,currentDomain);
         if(!bundleClass)
         {
            className = baseName + "_properties";
            bundleClass = getClassByName(className,currentDomain);
         }
         if(!bundleClass)
         {
            className = baseName;
            bundleClass = getClassByName(className,currentDomain);
         }
         if(!bundleClass && Boolean(mx_internal::backupApplicationDomain))
         {
            className = baseName + "_properties";
            bundleClass = getClassByName(className,mx_internal::backupApplicationDomain);
            if(!bundleClass)
            {
               className = baseName;
               bundleClass = getClassByName(className,mx_internal::backupApplicationDomain);
            }
         }
         if(Boolean(bundleClass))
         {
            bundleObj = new bundleClass();
            if(bundleObj is ResourceBundle)
            {
               return ResourceBundle(bundleObj);
            }
         }
         throw new Error("Could not find resource bundle " + baseName);
      }
      
      protected function getContent() : Object
      {
         return {};
      }
      
      [Deprecated(replacement="ResourceManager.getInstance().getString()",since="3.0")]
      public function getString(key:String) : String
      {
         return String(_getObject(key));
      }
      
      public function get content() : Object
      {
         return _content;
      }
      
      [Deprecated(replacement="ResourceManager.getInstance().getBoolean()",since="3.0")]
      public function getBoolean(key:String, defaultValue:Boolean = true) : Boolean
      {
         var temp:String = _getObject(key).toLowerCase();
         if(temp == "false")
         {
            return false;
         }
         if(temp == "true")
         {
            return true;
         }
         return defaultValue;
      }
      
      [Deprecated(replacement="ResourceManager.getInstance().getStringArray()",since="3.0")]
      public function getStringArray(key:String) : Array
      {
         var array:Array = _getObject(key).split(",");
         var n:int = int(array.length);
         for(var i:int = 0; i < n; i++)
         {
            array[i] = StringUtil.trim(array[i]);
         }
         return array;
      }
      
      [Deprecated(replacement="ResourceManager.getInstance().getObject()",since="3.0")]
      public function getObject(key:String) : Object
      {
         return _getObject(key);
      }
      
      private function _getObject(key:String) : Object
      {
         var value:Object = content[key];
         if(!value)
         {
            throw new Error("Key " + key + " was not found in resource bundle " + bundleName);
         }
         return value;
      }
      
      public function get locale() : String
      {
         return mx_internal::_locale;
      }
      
      public function get bundleName() : String
      {
         return mx_internal::_bundleName;
      }
      
      [Deprecated(replacement="ResourceManager.getInstance().getNumber()",since="3.0")]
      public function getNumber(key:String) : Number
      {
         return Number(_getObject(key));
      }
   }
}

