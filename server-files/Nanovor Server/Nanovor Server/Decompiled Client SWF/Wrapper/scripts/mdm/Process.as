package mdm
{
   public final class Process
   {
      
      private static var resolver:mdm_Process = null;
      
      public function Process()
      {
         super();
      }
      
      public static function isOpen(id:Number, syncFlag:Boolean = true) : Boolean
      {
         return internal_resolver().isOpen(id);
      }
      
      private static function internal_resolver() : mdm_Process
      {
         if(resolver == null)
         {
            resolver = new mdm_Process();
         }
         return resolver;
      }
      
      public static function create(title:String, xPos:Number, yPos:Number, width:Number, height:Number, appName:String, app:String, startInFolder:String, priority:Number, windowStatus:Number, syncFlag:Boolean = true) : Number
      {
         return internal_resolver().create(title,xPos,yPos,width,height,appName,app,startInFolder,priority,windowStatus);
      }
      
      public static function kill(id:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().kill(id);
      }
      
      public static function setParams(... args) : void
      {
         internal_resolver().setParams(args);
      }
      
      public function mdm_Process() : void
      {
         resolver.SetClassName("mdm.Process");
      }
   }
}

import flash.utils.Proxy;

dynamic class mdm_Process extends mdm_resolver
{
   
   public function mdm_Process()
   {
      super();
      SetClassName("mdm.Process");
   }
}
