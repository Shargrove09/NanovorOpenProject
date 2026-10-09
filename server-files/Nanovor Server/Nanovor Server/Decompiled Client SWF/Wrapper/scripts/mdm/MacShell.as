package mdm
{
   public final class MacShell
   {
      
      private static var resolver:mdm_MacShell = null;
      
      public function MacShell()
      {
         super();
         resolver.SetClassName("mdm.MacShell");
      }
      
      public static function get output() : String
      {
         return internal_resolver().output;
      }
      
      public static function exec(commandString:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().exec(commandString);
      }
      
      public static function get isRunning() : Boolean
      {
         return internal_resolver().isRunning;
      }
      
      private static function internal_resolver() : mdm_MacShell
      {
         if(resolver == null)
         {
            resolver = new mdm_MacShell();
         }
         return resolver;
      }
      
      public static function get exitCode() : String
      {
         return internal_resolver().exitCode;
      }
      
      public static function close(syncFlag:Boolean = true) : void
      {
         internal_resolver().close();
      }
   }
}

import flash.utils.Proxy;

dynamic class mdm_MacShell extends mdm_resolver
{
   
   public function mdm_MacShell()
   {
      super();
      SetClassName("mdm.MacShell");
   }
}
