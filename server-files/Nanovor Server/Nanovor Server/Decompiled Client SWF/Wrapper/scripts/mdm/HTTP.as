package mdm
{
   public final class HTTP
   {
      
      private var resolver:mdm_HTTP = null;
      
      public function HTTP()
      {
         super();
         resolver = new mdm_HTTP(this);
      }
      
      public function internal_resolver() : mdm_HTTP
      {
         return resolver;
      }
      
      public function set onTransferComplete(callback:Function) : void
      {
         resolver.onTransferComplete = callback;
      }
      
      public function getString(url:String, username:String = "", password:String = "", syncFlag:Boolean = true) : void
      {
         resolver.getString(url,username,password);
      }
      
      public function abort(syncFlag:Boolean = true) : void
      {
         resolver.abort();
      }
      
      public function getFile(url:String, username:String, password:String, localFilePath:String, syncFlag:Boolean = true) : void
      {
         resolver.getFile(url,username,password,localFilePath);
      }
      
      public function set onBinaryTransferComplete(callback:Function) : void
      {
         resolver.onBinaryTransferComplete = callback;
      }
      
      public function close(syncFlag:Boolean = true) : void
      {
         resolver.close();
      }
      
      public function set onError(callback:Function) : void
      {
         resolver.onError = callback;
      }
      
      private function AddEvents() : void
      {
         resolver.AddDynamicEvent("onBinaryTransferComplete",true);
         resolver.AddDynamicEvent("onError",false);
         resolver.AddDynamicEvent("onProgress",true);
         resolver.AddDynamicEvent("onTransferComplete",true);
      }
      
      public function set onProgress(callback:Function) : void
      {
         resolver.onProgress = callback;
      }
   }
}

import flash.utils.Proxy;

dynamic class mdm_HTTP extends mdm_resolver
{
   
   public function mdm_HTTP(http:HTTP)
   {
      var arr:Array = null;
      var id:int = 0;
      super();
      SetClassName("mdm.HTTP");
      AddEvents();
      arr = new Array();
      arr.push(-1);
      SetDynamic(CallSync("create",arr));
      id = int(m_dynamicID);
      m_dynHTTP[id] = http;
   }
   
   private function AddEvents() : void
   {
      AddDynamicEvent("onBinaryTransferComplete",true);
      AddDynamicEvent("onError",false);
      AddDynamicEvent("onProgress",true);
      AddDynamicEvent("onTransferComplete",true);
   }
}
