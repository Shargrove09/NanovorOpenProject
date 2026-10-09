package com.arkadium.virmon.evotree.ui
{
   import com.arkadium.virmon.evotree.node.EvoTreeNodeType;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.final.elements.UnknownNanovorSpinner;
   import fl.motion.Color;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   
   public class EvoTreeGridNodePuckNanovorLoader
   {
      
      private static const NANOVOR_BASE_URL:String = "Assets/Client/Characters/";
      
      private static const MAX_nanovorIcon_WIDTH:int = 90;
      
      private static const MAX_nanovorIcon_HEIGHT:int = 90;
      
      private static const NODE_BG_SCALE:Number = 0.45;
      
      private static const NOT_OWNED_GLOW:GlowFilter = new GlowFilter(16777215,0.5,3,3);
      
      private static const MAX_SELECTED_nanovorIcon_WIDTH:int = 200;
      
      private static const MAX_SELECTED_nanovorIcon_HEIGHT:int = 200;
      
      private static const SELECTED_NODE_BG_SCALE:Number = 0.57;
      
      private var _type:String;
      
      private var _isDiscovered:Boolean;
      
      private var _nanovorIconLoader:Loader;
      
      private var _consumer:IEvoTreeGridNodePuckNanovorLoaderConsumer;
      
      private var _isFlipped:Boolean;
      
      private var _isOwned:Boolean;
      
      private var _nanovorIcon:MovieClip;
      
      public function EvoTreeGridNodePuckNanovorLoader(param1:int, param2:String, param3:Boolean, param4:Boolean, param5:Boolean, param6:IEvoTreeGridNodePuckNanovorLoaderConsumer)
      {
         super();
         _consumer = param6;
         _type = param2;
         _isOwned = param3;
         _isDiscovered = param4;
         _isFlipped = param5;
         if(param4 || param3)
         {
            loadNanovor(param1);
         }
         else
         {
            loadUnknownNanovor();
         }
      }
      
      private function onNanovorLoadError(param1:IOErrorEvent) : void
      {
         _nanovorIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         _nanovorIconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
      }
      
      private function onNanovorLoadComplete(param1:Event) : void
      {
         _nanovorIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         _nanovorIconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
         _nanovorIcon = MovieClip(param1.target.content);
         _nanovorIcon.getChildAt(0).x = 40;
         _nanovorIcon.getChildAt(0).y = 40;
         resizeNanovor();
         if(!_isOwned)
         {
            if(_type == EvoTreeNodeType.BLANK)
            {
               applyNanovorTint(ColorMap.EVOTREE_NOTOWNED);
            }
            else
            {
               applyNanovorTint(ColorMap.EVOTREE_EVOLVE_NOTOWNED);
            }
            _nanovorIcon.filters = [NOT_OWNED_GLOW];
         }
         if(null != _consumer)
         {
            _consumer.handleNanovorIconLoaded(_nanovorIcon);
         }
      }
      
      private function loadNanovor(param1:int) : void
      {
         _nanovorIconLoader = new Loader();
         _nanovorIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onNanovorLoadComplete,false,0,true);
         _nanovorIconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError,false,0,true);
         var _loc2_:String = NANOVOR_BASE_URL + param1 + "/widgetIdle.swf";
         _nanovorIconLoader.load(new URLRequest(_loc2_));
      }
      
      private function loadUnknownNanovor() : void
      {
         _nanovorIcon = new UnknownNanovorSpinner();
         resizeNanovor();
         if(null != _consumer)
         {
            _consumer.handleNanovorIconLoaded(_nanovorIcon);
         }
      }
      
      private function resizeNanovor() : void
      {
         var _loc1_:MovieClip = MovieClip(_nanovorIcon);
         if(_loc1_.width >= _loc1_.height)
         {
            if(_type == EvoTreeNodeType.SELECTED)
            {
               _loc1_.width = MAX_SELECTED_nanovorIcon_WIDTH;
            }
            else
            {
               _loc1_.width = MAX_nanovorIcon_WIDTH;
            }
            _loc1_.scaleY = _loc1_.scaleX;
         }
         else
         {
            if(_type == EvoTreeNodeType.SELECTED)
            {
               _loc1_.height = MAX_SELECTED_nanovorIcon_HEIGHT;
            }
            else
            {
               _loc1_.height = MAX_nanovorIcon_HEIGHT;
            }
            _loc1_.scaleX = _loc1_.scaleY;
         }
         _loc1_.x = -(_loc1_.width / 2);
         _loc1_.y = -(_loc1_.height / 2);
         if(_isFlipped)
         {
            _loc1_.scaleX *= -1;
            _loc1_.x = _loc1_.width / 2;
         }
      }
      
      private function applyNanovorTint(param1:uint) : void
      {
         var _loc2_:Color = new Color();
         _loc2_.setTint(param1,1);
         _nanovorIcon.transform.colorTransform = _loc2_;
      }
   }
}

