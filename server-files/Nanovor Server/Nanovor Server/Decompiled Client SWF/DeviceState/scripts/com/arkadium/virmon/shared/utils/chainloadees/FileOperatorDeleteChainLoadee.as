package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   
   public class FileOperatorDeleteChainLoadee implements IChainLoadee
   {
      
      private var _chainLoader:IChainLoader;
      
      private var _sourceFile:String;
      
      private var _fileOperator:IFileOperator;
      
      public function FileOperatorDeleteChainLoadee(param1:String, param2:IFileOperator)
      {
         super();
         _sourceFile = param1;
         _fileOperator = param2;
      }
      
      public function load() : void
      {
         _fileOperator.deleteFile(_sourceFile,_chainLoader.handleChainLoadeeComplete);
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

