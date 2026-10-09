package it.gotoandplay.smartfoxserver.http
{
   public interface IHttpProtocolCodec
   {
      
      function decode(param1:String) : String;
      
      function encode(param1:String, param2:String) : String;
   }
}

