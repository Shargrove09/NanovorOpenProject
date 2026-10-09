package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class NanovorAnimationLoader implements IChainLoadee
   {
      
      public static const NAME:String = "NanovorAnimationLoader";
      
      private var _animationAssetType:CharacterAnimationAssetType;
      
      private var _targetURL:String;
      
      private var _nanovorId:int;
      
      private var _hash:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _loader:Loader;
      
      private var _content:MovieClip;
      
      public function NanovorAnimationLoader(param1:int, param2:CharacterAnimationAssetType, param3:ICharacterAssetTypeCache, param4:String = "")
      {
         super();
         _nanovorId = param1;
         _animationAssetType = param2;
         _hash = param4;
         _targetURL = param3.getCharacterAnimationURL(param2,_nanovorId).url;
      }
      
      public function get content() : MovieClip
      {
         return _content;
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<NanovorAnimationLoader>>\t" + param1);
      }
      
      private function destroy() : void
      {
         if(_loader != null)
         {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadFailure);
            try
            {
               _loader.close();
            }
            catch(e:Error)
            {
            }
            _loader.unload();
            _loader = null;
         }
         _chainLoader = null;
         _content = null;
      }
      
      public function get name() : String
      {
         return NAME + _nanovorId + _animationAssetType.name + _hash;
      }
      
      private function onLoadFailure(param1:IOErrorEvent) : void
      {
         _chainLoader.handleChainLoadeeError();
         destroy();
      }
      
      public function load() : void
      {
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadFailure);
         _loader.load(new URLRequest(_targetURL));
      }
      
      private function onLoadComplete(param1:Event) : void
      {
         _content = _loader.contentLoaderInfo.content as MovieClip;
         _chainLoader.handleChainLoadeeComplete(_content);
         destroy();
      }
   }
}

