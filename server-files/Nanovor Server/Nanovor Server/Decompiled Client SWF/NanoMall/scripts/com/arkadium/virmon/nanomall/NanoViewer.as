package com.arkadium.virmon.nanomall
{
   import com.arkadium.virmon.framework.EMMasterData;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   
   public class NanoViewer extends MovieClip
   {
      
      private var _viewerLoader:Loader;
      
      private var mcViewer:MovieClip;
      
      private var tempNanovorName:String;
      
      public function NanoViewer()
      {
         super();
         _viewerLoader = new Loader();
         _viewerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onNanoViewerLoadSuccess,false,0,true);
         var _loc1_:URLRequest = new URLRequest("elements\\NanovorMegaViewer.swf");
         _viewerLoader.load(_loc1_);
         addChild(_viewerLoader);
      }
      
      public function showEM(param1:EMMasterData) : void
      {
         mcViewer.ShowEM(param1);
      }
      
      public function showVirmon(param1:IVirmon) : void
      {
         mcViewer.ShowVirmon(param1);
      }
      
      public function setNanovorName(param1:String) : void
      {
         if(param1 == null || mcViewer == null)
         {
            tempNanovorName = param1 == null ? null : param1;
            return;
         }
         mcViewer.setNanovorName(param1);
      }
      
      public function reset() : void
      {
         mcViewer.Reset();
      }
      
      private function onNanoViewerLoadSuccess(param1:Event) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,onNanoViewerLoadSuccess);
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         mcViewer = MovieClip(_loc2_.content);
         if(tempNanovorName != null && tempNanovorName != "")
         {
            mcViewer.setNanovorName(tempNanovorName);
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(mcViewer))
         {
            mcViewer.destroy();
         }
         _viewerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanoViewerLoadSuccess);
         _viewerLoader.unload();
      }
   }
}

