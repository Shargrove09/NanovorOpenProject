package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.components.GlowArrow;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TileScroller extends MovieClip
   {
      
      private static const TILE_ALPHA_ANI:Number = 0.1;
      
      private static const PAGE_SCROLL_ANI:Number = 0.25;
      
      private var tilesContainer:Sprite;
      
      private var tiles:Array = new Array();
      
      private var _handler:ITreeViewMenu;
      
      private var maskOffset:int;
      
      private const TILE_PADDING_H:int = 8;
      
      private var scrollSpan:Number = 0;
      
      private var tileWidth:int;
      
      private const TILE_BG_COLOR:uint = 8177150;
      
      private var maskWidth:int;
      
      private var scrollerMask:Shape;
      
      private var curScrollX:Number = 0;
      
      private var maskHeight:int;
      
      private var nextArrow:GlowArrow;
      
      private var previousArrow:GlowArrow;
      
      private var totalPages:int;
      
      private var curTile_X:Number;
      
      private var _arrowClosedAlpha:Number;
      
      private var curPage:int = 1;
      
      private var isScrollable:Boolean = false;
      
      private var tileHeight:int;
      
      public function TileScroller(param1:ITreeViewMenu, param2:int, param3:int, param4:int, param5:int, param6:int = 0, param7:Number = 0)
      {
         super();
         _handler = param1;
         _arrowClosedAlpha = param7;
         tileWidth = param2;
         tileHeight = param3;
         maskWidth = param4;
         maskHeight = param5;
         maskOffset = param6;
         makeMask();
         makeScrollArrows();
      }
      
      private function makeMask() : void
      {
         scrollerMask = new Shape();
         scrollerMask.graphics.beginFill(16777215);
         scrollerMask.graphics.drawRect(0,0,maskWidth,maskHeight);
         addChild(scrollerMask);
         scrollerMask.x = maskOffset;
         scrollerMask.visible = false;
      }
      
      public function openFirst() : CollectionTile
      {
         var _loc1_:CollectionTile = null;
         if(tiles[0] != null)
         {
            _loc1_ = tiles[0].tile;
            _loc1_.select();
            return _loc1_;
         }
         return null;
      }
      
      private function onNextArrowClick(param1:MouseEvent = null, param2:Boolean = false) : void
      {
         var _loc3_:Number = curScrollX - scrollSpan;
         if(!param2)
         {
            Tweener.addTween(tilesContainer,{
               "x":_loc3_,
               "time":PAGE_SCROLL_ANI,
               "transition":"easeOutQuad",
               "rounded":true
            });
         }
         else
         {
            tilesContainer.x = _loc3_;
         }
         curScrollX = _loc3_;
         ++curPage;
         if(Boolean(_handler))
         {
            _handler.handleTileScrollerPaging(curPage);
         }
         setScrollArrows();
      }
      
      private function onPreviousArrowClick(param1:MouseEvent = null, param2:Boolean = false) : void
      {
         var _loc3_:Number = curScrollX + scrollSpan;
         if(!param2)
         {
            Tweener.addTween(tilesContainer,{
               "x":_loc3_,
               "time":PAGE_SCROLL_ANI,
               "transition":"easeOutQuad",
               "rounded":true
            });
         }
         else
         {
            tilesContainer.x = _loc3_;
         }
         curScrollX = _loc3_;
         --curPage;
         if(Boolean(_handler))
         {
            _handler.handleTileScrollerPaging(curPage);
         }
         setScrollArrows();
      }
      
      private function resetScrollArrows() : void
      {
         previousArrow.close();
         nextArrow.close();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** TileScroller: " + param1);
      }
      
      private function setScrollArrows() : void
      {
         if(curPage > 1)
         {
            previousArrow.open();
         }
         else
         {
            previousArrow.close();
         }
         if(curPage < totalPages)
         {
            nextArrow.open();
         }
         else
         {
            nextArrow.close();
         }
      }
      
      public function hide() : void
      {
         visible = false;
         resetScrollArrows();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> TileScroller: " + param1);
      }
      
      private function makeScrollArrows() : void
      {
         previousArrow = new GlowArrow(_arrowClosedAlpha);
         addChild(previousArrow);
         previousArrow.x = -(GlowArrow.WIDTH + 10);
         previousArrow.y = tileHeight - GlowArrow.HEIGHT;
         previousArrow.addEventListener(MouseEvent.CLICK,onPreviousArrowClick,false,0,true);
         nextArrow = new GlowArrow(_arrowClosedAlpha);
         addChild(nextArrow);
         nextArrow.scaleX = -1;
         nextArrow.x = maskWidth + GlowArrow.WIDTH + 10;
         nextArrow.y = tileHeight - GlowArrow.HEIGHT;
         nextArrow.addEventListener(MouseEvent.CLICK,onNextArrowClick,false,0,true);
      }
      
      public function reveal(param1:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:DisplayObject = null;
         visible = true;
         resetScroll();
         var _loc2_:Function = null;
         _loc3_ = 0;
         while(_loc3_ < tiles.length)
         {
            _loc4_ = tiles[_loc3_].tile;
            _loc4_.alpha = 0;
            _loc4_.visible = true;
            if(_loc3_ == tiles.length - 1 && isScrollable)
            {
               _loc2_ = setScrollArrows;
            }
            if(!param1)
            {
               Tweener.addTween(_loc4_,{
                  "alpha":1,
                  "time":TILE_ALPHA_ANI,
                  "delay":_loc3_ * (TILE_ALPHA_ANI / 2),
                  "transition":"easeOutQuad",
                  "onComplete":_loc2_
               });
            }
            else
            {
               _loc4_.alpha = 1;
            }
            _loc3_++;
         }
      }
      
      public function addTiles(param1:Array) : void
      {
         if(Boolean(tilesContainer))
         {
            removeChild(tilesContainer);
         }
         tilesContainer = new Sprite();
         addChild(tilesContainer);
         tiles = new Array();
         curTile_X = 0;
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            addTile(param1[_loc2_]);
            if(curTile_X + tileWidth > maskWidth && !scrollSpan)
            {
               scrollSpan = curTile_X;
            }
            _loc2_++;
         }
         totalPages = int(Math.ceil(tilesContainer.width / scrollSpan));
         if(tilesContainer.width > scrollerMask.width)
         {
            scrollerMask.visible = true;
            tilesContainer.mask = scrollerMask;
            isScrollable = true;
         }
         resetScroll();
         setScrollArrows();
      }
      
      private function addTile(param1:DisplayObject) : void
      {
         param1.x = curTile_X;
         curTile_X += tileWidth + TILE_PADDING_H;
         tilesContainer.addChild(param1);
         param1.visible = false;
         param1.alpha = 0;
         var _loc2_:Object = new Object();
         _loc2_.tile = param1;
         _loc2_.originX = curTile_X;
         tiles.push(_loc2_);
      }
      
      public function autoScrollTo(param1:int) : void
      {
         var _loc2_:int = param1 / scrollerMask.width;
         var _loc3_:Number = scrollerMask.x - _loc2_ * scrollerMask.width;
         Tweener.addTween(tilesContainer,{
            "x":_loc3_,
            "time":PAGE_SCROLL_ANI,
            "transition":"easeOutQuad",
            "rounded":true
         });
         curPage = _loc2_ + 1;
         curScrollX = _loc3_;
         setScrollArrows();
      }
      
      public function destroy() : void
      {
         var mc:Object = null;
         while(tilesContainer.numChildren > 0)
         {
            mc = tilesContainer.removeChildAt(0);
            try
            {
               mc.destroy();
            }
            catch(e:Error)
            {
               log("tile didnt have a destroy method");
            }
         }
         previousArrow.removeEventListener(MouseEvent.CLICK,onPreviousArrowClick);
         nextArrow.removeEventListener(MouseEvent.CLICK,onNextArrowClick);
      }
      
      private function resetScroll() : void
      {
         curScrollX = 0;
         curPage = 1;
         if(Boolean(_handler))
         {
            _handler.handleTileScrollerPaging(curPage);
         }
         tilesContainer.x = curScrollX;
      }
   }
}

