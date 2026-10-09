package com.arkadium.virmon.wrapper.controller
{
   import com.arkadium.virmon.wrapper.model.IDownloadManagerModel;
   
   public class DownloadManagerController implements IDownloadManagerController
   {
      
      private var _model:IDownloadManagerModel;
      
      public function DownloadManagerController(param1:IDownloadManagerModel)
      {
         super();
         _model = param1;
      }
      
      public function restartClient() : void
      {
         _model.executeUpdateFinisher();
      }
      
      public function copyAndRestartClient() : void
      {
         _model.executeUpdateFinisher();
      }
      
      public function startDownload() : void
      {
         _model.loadDownloadManager();
      }
   }
}

