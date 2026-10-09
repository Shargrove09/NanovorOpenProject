package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   
   public class FileOperatorDeleteFolderChainLoadee implements IChainLoadee
   {
      
      private var _sourceFolder:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _fileOperator:IFileOperator;
      
      public function FileOperatorDeleteFolderChainLoadee(param1:String, param2:IFileOperator)
      {
         super();
         _sourceFolder = param1;
         _fileOperator = param2;
      }
      
      public function load() : void
      {
         _fileOperator.deleteFolder(_sourceFolder,_chainLoader.handleChainLoadeeComplete);
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function get name() : String
      {
         return "FileOperatorDeleteChainLoadee";
      }
   }
}

