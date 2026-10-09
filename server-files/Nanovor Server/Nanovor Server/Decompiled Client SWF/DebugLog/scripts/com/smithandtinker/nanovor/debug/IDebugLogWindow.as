package com.smithandtinker.nanovor.debug
{
   public interface IDebugLogWindow
   {
      
      function removeFilterSender(param1:DebugFilterSender) : void;
      
      function handleFilterSenderError(param1:String) : void;
      
      function handleFilterSenderLog(param1:String) : void;
   }
}

