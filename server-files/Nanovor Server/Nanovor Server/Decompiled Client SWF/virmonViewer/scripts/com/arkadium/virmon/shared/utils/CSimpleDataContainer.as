package com.arkadium.virmon.shared.utils
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol146")]
   public class CSimpleDataContainer extends MovieClip
   {
      
      private var _dData:*;
      
      private var _lDataLoader:Loader;
      
      private var _iCountFrames:int;
      
      private var _oSoundTransform:SoundTransform;
      
      private var _bIsDataLoadFinished:Boolean;
      
      public function CSimpleDataContainer()
      {
         super();
         _bIsDataLoadFinished = true;
         _dData = null;
         _lDataLoader = new Loader();
         _oSoundTransform = new SoundTransform();
         _oSoundTransform.volume = 0;
      }
      
      public function destroy() : void
      {
         unloadData();
         _lDataLoader = null;
         _oSoundTransform = null;
      }
      
      public function killAnimation() : MovieClip
      {
         if(_dData is MovieClip)
         {
            _dData.stop();
            _dData.removeEventListener(Event.ENTER_FRAME,playAnimation);
            _dData.gotoAndStop(1);
            return _dData;
         }
         return null;
      }
      
      public function unloadData() : void
      {
         var mc:MovieClip = null;
         if(Boolean(_lDataLoader) && !_bIsDataLoadFinished)
         {
            try
            {
               _lDataLoader.close();
               _lDataLoader.unload();
            }
            catch(e:Error)
            {
               trace("No Stream to Close.",e.message);
            }
            if(_lDataLoader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
            {
               _lDataLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,dataLoaded);
            }
            if(Boolean(_lDataLoader.content))
            {
               mc = _lDataLoader.content as MovieClip;
               if(Boolean(mc))
               {
                  mc.stop();
               }
            }
         }
         if(_dData is MovieClip)
         {
            _dData.stop();
            _dData.removeEventListener(Event.ENTER_FRAME,playAnimation);
         }
         if(_dData && contains(_dData))
         {
            removeChild(_dData);
            _dData = null;
         }
      }
      
      public function loadData(param1:String) : void
      {
         unloadData();
         var _loc2_:URLRequest = new URLRequest(param1);
         _lDataLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,dataLoaded,false,0,true);
         _lDataLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,dataLoadError,false,0,true);
         _lDataLoader.load(_loc2_);
         _bIsDataLoadFinished = false;
      }
      
      private function dataLoaded(param1:Event) : void
      {
         _lDataLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,dataLoaded);
         _lDataLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,dataLoadError);
         _dData = param1.currentTarget.content;
         _lDataLoader.unload();
         addChild(_dData);
         if(_dData is MovieClip && _dData.totalFrames > 1)
         {
            _iCountFrames = 0;
            _dData.stop();
            _dData.addEventListener(Event.ENTER_FRAME,playAnimation,false,0,true);
            _dData.soundTransform = _oSoundTransform;
         }
         _bIsDataLoadFinished = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function playAnimation(param1:Event) : void
      {
         ++_iCountFrames;
         if(_iCountFrames % 4 == 0)
         {
            if(_dData.currentFrame < _dData.totalFrames)
            {
               _dData.nextFrame();
            }
            else
            {
               _dData.gotoAndStop(1);
            }
         }
      }
      
      private function dataLoadError(param1:IOErrorEvent) : void
      {
         _lDataLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,dataLoaded);
         _lDataLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,dataLoadError);
         dispatchEvent(param1);
      }
   }
}

