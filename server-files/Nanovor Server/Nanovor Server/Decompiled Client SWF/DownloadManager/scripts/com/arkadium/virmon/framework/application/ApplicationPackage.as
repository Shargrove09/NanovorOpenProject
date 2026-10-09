package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class ApplicationPackage implements IApplicationPackage
   {
      
      private var _priority:int;
      
      private var _type:PackageType;
      
      private var _applicationManifest:IApplicationManifest;
      
      private var _dependencyList:DependencyList;
      
      public function ApplicationPackage(param1:IApplicationManifest, param2:String, param3:int)
      {
         super();
         _type = parseType(param2);
         _priority = param3;
         _dependencyList = new DependencyList();
         _applicationManifest = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationPackage: " + param1);
      }
      
      public function get type() : PackageType
      {
         return _type;
      }
      
      public function addDependency(param1:IDependency) : void
      {
         _dependencyList.addDependency(param1);
      }
      
      private function parseType(param1:String) : PackageType
      {
         return PackageType.parse(param1);
      }
      
      public function hasFileDependency(param1:String) : Boolean
      {
         var _loc3_:IDependency = null;
         var _loc4_:IApplicationPackage = null;
         var _loc2_:IApplicationFile = _applicationManifest.fileList.getFile(param1);
         for each(_loc3_ in _dependencyList.dependencies)
         {
            _loc4_ = _loc3_ as IApplicationPackage;
            if(null != _loc4_ && Boolean(_loc4_.hasFileDependency(param1)))
            {
               return true;
            }
         }
         return _dependencyList.hasDependency(_loc2_);
      }
      
      public function get priority() : int
      {
         return _priority;
      }
      
      public function toString() : String
      {
         return "[ApplicationPackage:IDependency | type=" + type.name + " | priority=" + priority + "]";
      }
      
      public function get isOutdated() : Boolean
      {
         return _dependencyList.hasOutdatedDependency;
      }
      
      public function hasPackageDependency(param1:PackageType) : Boolean
      {
         var _loc2_:IApplicationPackage = _applicationManifest.packageList.getPackage(param1);
         return _dependencyList.hasDependency(_loc2_);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationPackage: " + param1);
      }
   }
}

