package com.arkadium.virmon.help.swarmchooser.nanovorselect
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.help.common.HelpAlertSpinner;
   import com.arkadium.virmon.help.common.HelpTreeTileOutline;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenu;
   import com.arkadium.virmon.shared.final.elements.EuroStileBoldExtended2Text;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   public class HelpSwarmChooserNanovorSelect extends MovieClip
   {
      
      private static const ACTION_TEXT:String = "Click on a Nanovor to add it to your swarm.";
      
      private static const COLLECTION_SLOTS:int = 12;
      
      private var _treeViewMenu:TreeViewMenu;
      
      private var _roTimer:Timer;
      
      private var _collectionTiles:Array;
      
      private var _alertSpinner:HelpAlertSpinner;
      
      private var _activeTileCount:int;
      
      private var _tileOutlines:Array;
      
      private var _actionText:EuroStileBoldExtended2Text;
      
      private var _bg:HelpSwarmChooserNanovorSelectBG;
      
      private var _tileROCount:int;
      
      private var _startTimer:Timer;
      
      public function HelpSwarmChooserNanovorSelect(param1:TreeViewMenu)
      {
         super();
         _treeViewMenu = param1;
         setCollectionTileData();
         setBG();
         setAlertSpinner();
         setActionText();
         setTileOutlines();
      }
      
      private function endTileOutlines(param1:Number) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < _tileOutlines.length)
         {
            Tweener.addTween(_tileOutlines[_loc2_],{
               "alpha":0,
               "time":1,
               "delay":param1,
               "transition":"easeOutQuad"
            });
            _loc2_++;
         }
      }
      
      private function startHelp(param1:TimerEvent) : void
      {
         _startTimer.removeEventListener(TimerEvent.TIMER,startHelp);
         Tweener.addTween(_bg,{
            "alpha":0.8,
            "time":1,
            "transition":"linear",
            "onComplete":startActionText
         });
         startTileOutlines();
         _alertSpinner.start(100);
      }
      
      private function setActionText() : void
      {
         _actionText = new EuroStileBoldExtended2Text(ACTION_TEXT,18,16777215);
         addChild(_actionText);
         var _loc1_:Array = new Array();
         _loc1_.push(new GlowFilter(52223,1,10,10,2,3));
         _actionText.filters = _loc1_;
         _actionText.x = 512 - _actionText.width / 2;
         _actionText.y = _treeViewMenu.y + TreeViewMenu.COLLECTIONSCROLLER_Y + _collectionTiles[0].height;
         _actionText.alpha = 0;
      }
      
      private function startActionText() : void
      {
         Tweener.addTween(_actionText,{
            "alpha":1,
            "delay":0.5,
            "time":0.5,
            "transition":"linear"
         });
         startTileRollOvers();
      }
      
      private function setTileOutlines() : void
      {
         var _loc2_:HelpTreeTileOutline = null;
         _tileOutlines = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < _activeTileCount)
         {
            _loc2_ = new HelpTreeTileOutline();
            addChild(_loc2_);
            _loc2_.width = _bg["mcCutOut" + (_loc1_ + 1)].width;
            _loc2_.height = _bg["mcCutOut" + (_loc1_ + 1)].height;
            _loc2_.x = _bg["mcCutOut" + (_loc1_ + 1)].x;
            _loc2_.y = _bg["mcCutOut" + (_loc1_ + 1)].y;
            _loc2_.alpha = 0;
            _tileOutlines.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function setAlertSpinner() : void
      {
         _alertSpinner = new HelpAlertSpinner();
         addChild(_alertSpinner);
         _alertSpinner.x = _treeViewMenu.x + TreeViewMenu.COLLECTIONSCROLLER_X + _collectionTiles[0].width / 2;
         _alertSpinner.y = _treeViewMenu.y + TreeViewMenu.COLLECTIONSCROLLER_Y + _collectionTiles[0].height / 2;
      }
      
      private function startTileRollOvers() : void
      {
         _tileROCount = 0;
         rollOverNextTile(null);
         _roTimer = new Timer(500,_activeTileCount);
         _roTimer.addEventListener(TimerEvent.TIMER,rollOverNextTile);
         _roTimer.start();
      }
      
      private function startTileOutlines() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < _tileOutlines.length)
         {
            Tweener.addTween(_tileOutlines[_loc1_],{
               "alpha":1,
               "time":1,
               "transition":"easeOutQuad"
            });
            _loc1_++;
         }
      }
      
      private function setBG() : void
      {
         _bg = new HelpSwarmChooserNanovorSelectBG();
         addChild(_bg);
         _bg.alpha = 0;
         _bg.setCutOuts(_collectionTiles);
      }
      
      private function rollOverNextTile(param1:TimerEvent) : void
      {
         if(_tileROCount < _activeTileCount)
         {
            _collectionTiles[_tileROCount].startTimedRollOver(500);
         }
         else
         {
            _roTimer.removeEventListener(TimerEvent.TIMER,rollOverNextTile);
            endHelp();
         }
         ++_tileROCount;
      }
      
      public function start(param1:int = 0) : void
      {
         _startTimer = new Timer(param1,1);
         _startTimer.addEventListener(TimerEvent.TIMER,startHelp);
         _startTimer.start();
      }
      
      private function endHelp() : void
      {
         endTileOutlines(3);
         endActionText(3);
         Tweener.addTween(_bg,{
            "alpha":0,
            "time":1,
            "delay":3,
            "transition":"linear"
         });
      }
      
      private function setCollectionTileData() : void
      {
         var _loc4_:* = undefined;
         _collectionTiles = new Array();
         var _loc1_:int = _treeViewMenu.getCurrectTreeId();
         var _loc2_:Array = _treeViewMenu.getCollectionTiles(_loc1_);
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_[_loc3_].length)
            {
               _collectionTiles.push(_loc2_[_loc3_][_loc4_]);
               _loc4_++;
            }
            _loc3_++;
         }
         _activeTileCount = COLLECTION_SLOTS;
         if(_collectionTiles.length < COLLECTION_SLOTS)
         {
            _activeTileCount = _collectionTiles.length;
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(_alertSpinner))
         {
            _alertSpinner.destroy();
         }
         if(Boolean(_startTimer))
         {
            _startTimer.stop();
            _startTimer.removeEventListener(TimerEvent.TIMER,startHelp);
            _startTimer = null;
         }
         if(Boolean(_roTimer))
         {
            _roTimer.stop();
            _roTimer.removeEventListener(TimerEvent.TIMER,rollOverNextTile);
            _roTimer = null;
         }
      }
      
      private function endActionText(param1:Number) : void
      {
         Tweener.addTween(_actionText,{
            "alpha":0,
            "delay":param1,
            "time":0.5,
            "transition":"linear"
         });
      }
   }
}

