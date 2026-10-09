package com.arkadium.communications
{
   public interface IVersionDataProvider
   {
      
      function getBuildVersion() : String;
      
      function getMinorVersion() : String;
      
      function getRevision() : String;
      
      function getMajorVersion() : String;
   }
}

