package com.arkadium.virmon.evogame.substates
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.evogame.Hopper;
   import com.arkadium.virmon.evogame.IEvoGameStateUI;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.final.elements.IdentifyingNanovorElement;
   import com.arkadium.virmon.shared.utils.CVirmon;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import com.smithandtinker.nanovor.nanovormegaviewerui.NanovorMegaViewer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   public class EvoGameSubStateVictory extends AbstractSubState
   {
      
      private var _evoGameUI:IEvoGameStateUI;
      
      private const PAUSE_BEFORE_DOORS_CLOSE:int = 7000;
      
      private var _identifyingGraphic:IdentifyingNanovorElement;
      
      private var _solution:Array;
      
      private var _destinationCharacterIsSuperseded:Boolean = false;
      
      private var _nanovorMegaViewerLoader:Loader;
      
      private var _delayTimer:Timer;
      
      private var _nanovorMegaViewer:NanovorMegaViewer;
      
      public function EvoGameSubStateVictory(param1:IEvoGameStateUI, param2:Array)
      {
         super();
         _evoGameUI = param1;
         _solution = param2;
      }
      
      private function windUp(param1:TimerEvent) : void
      {
         _delayTimer.removeEventListener(TimerEvent.TIMER,windUp);
         _nanovorMegaViewer.ChipsetClip.PlayCoilAnimation();
         _delayTimer = new Timer(PAUSE_BEFORE_DOORS_CLOSE / 2);
         _delayTimer.addEventListener(TimerEvent.TIMER,closeDoors);
         _delayTimer.start();
      }
      
      private function evoOutAnimLoadedHandler(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,evoOutAnimLoadedHandler);
      }
      
      private function onQuickTipsClick(param1:MouseEvent) : void
      {
         Managers.stateManager.handleQuickTips();
      }
      
      private function destroyIdentifyingGraphic() : void
      {
         if(_identifyingGraphic == null)
         {
            return;
         }
         Tweener.removeTweens(_identifyingGraphic);
         _identifyingGraphic.stop();
         if(_nanovorMegaViewer.NanovorAnimClip.contains(_identifyingGraphic))
         {
            _nanovorMegaViewer.NanovorAnimClip.removeChild(_identifyingGraphic);
         }
         _identifyingGraphic = null;
      }
      
      public function quit(param1:Object = null) : void
      {
         destroyListeners();
         destroyIdentifyingGraphic();
         var _loc2_:String = Managers.stateManager.getStateData(StateType.EVOGAME).sourceVirmonId as String;
         Managers.stateManager.setStateData(StateType.EVOTREE,_loc2_);
         Managers.stateManager.setState(StateType.EVOTREE);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoGameSubStateVictory>>\t" + param1);
      }
      
      private function slideInEMs() : void
      {
         var _loc2_:Hopper = null;
         var _loc1_:int = 0;
         while(_loc1_ < _solution.length)
         {
            _loc2_ = new Hopper(null,_solution[_loc1_]);
            _loc2_.x = 550;
            _loc2_.y = 200 + _loc1_ * 66;
            _loc2_.clearQuantity();
            _evoGameUI.addHopper(_loc2_);
            Tweener.addTween(_loc2_,{
               "delay":0.3 + _loc1_ * 0.1,
               "time":0.3,
               "x":688
            });
            _loc1_++;
         }
      }
      
      private function queueIdentifyingGraphic() : void
      {
         _identifyingGraphic = new IdentifyingNanovorElement(true);
         _identifyingGraphic.y = -20;
         _identifyingGraphic.x = -92;
         _identifyingGraphic.alpha = 0;
         _identifyingGraphic.play();
         _nanovorMegaViewer.NanovorAnimClip.addChild(_identifyingGraphic);
         Tweener.removeTweens(_identifyingGraphic);
         Tweener.addTween(_identifyingGraphic,{
            "_autoAlpha":1,
            "delay":2.2,
            "time":0.8,
            "transition":"easeInOutQuad"
         });
      }
      
      private function onVirmonViewerLoadError(param1:IOErrorEvent) : void
      {
         _nanovorMegaViewerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onVirmonViewerLoaded);
         _nanovorMegaViewerLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onVirmonViewerLoadError);
         log("ERROR: Failed to load Viewer from elements/NanovorMegaViewer.swf");
      }
      
      private function endMove1() : void
      {
         _nanovorMegaViewer.HideArm();
         Tweener.addTween(_nanovorMegaViewer,{
            "time":0.3,
            "x":335,
            "y":320,
            "transition":"easeInOutQuad",
            "onComplete":endMove2
         });
      }
      
      private function endMove2() : void
      {
         Tweener.addTween(_nanovorMegaViewer,{
            "time":0.4,
            "x":335,
            "y":-30,
            "transition":"easeInOutQuad",
            "onComplete":endMove3
         });
      }
      
      private function endMove3() : void
      {
         _nanovorMegaViewer.OpenDrawer(false,true);
         _nanovorMegaViewer.Sequencer.Play();
         if(_destinationCharacterIsSuperseded)
         {
            queueIdentifyingGraphic();
         }
         _delayTimer = new Timer(1300);
         _delayTimer.addEventListener(TimerEvent.TIMER,endMove4);
         _delayTimer.start();
      }
      
      private function endMove4(param1:TimerEvent) : void
      {
         _delayTimer.removeEventListener(TimerEvent.TIMER,endMove4);
         _evoGameUI.burnHeader();
         slideInEMs();
      }
      
      private function viewerMoviesLoaded(param1:Event) : void
      {
         _nanovorMegaViewer.Sequencer.removeEventListener(Event.COMPLETE,viewerMoviesLoaded);
         _evoGameUI.addMegaViewer(_nanovorMegaViewer);
      }
      
      private function destroyListeners() : void
      {
         if(_delayTimer != null)
         {
            _delayTimer.stop();
            _delayTimer.removeEventListener(TimerEvent.TIMER,windUp);
            _delayTimer.removeEventListener(TimerEvent.TIMER,closeDoors);
            _delayTimer.removeEventListener(TimerEvent.TIMER,endMove4);
         }
      }
      
      private function closeDoors(param1:TimerEvent) : void
      {
         _delayTimer.removeEventListener(TimerEvent.TIMER,closeDoors);
         _delayTimer = null;
         _evoGameUI.closeDoors();
         Tweener.addTween(_nanovorMegaViewer,{
            "time":0.3,
            "x":655,
            "y":320,
            "transition":"easeInOutQuad",
            "onComplete":endMove1
         });
      }
      
      private function evoInCompleteHandler() : void
      {
         _nanovorMegaViewer.LowerClip.enableShockButton();
      }
      
      private function showVirmon() : void
      {
         var _loc1_:String = Managers.stateManager.getStateData(StateType.EVOGAME).sourceVirmonId;
         var _loc2_:IVirmon = new CVirmon();
         _loc2_.create(_loc1_,DataManager.getInstance().getVirmonManager().getVirmonData(_loc1_));
         _nanovorMegaViewer.ShowVirmon(_loc2_);
      }
      
      private function loadVirmonViewer() : void
      {
         _nanovorMegaViewerLoader = new Loader();
         _nanovorMegaViewerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onVirmonViewerLoaded,false,0,true);
         _nanovorMegaViewerLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onVirmonViewerLoadError,false,0,true);
         _nanovorMegaViewerLoader.load(new URLRequest("elements/NanovorMegaViewer.swf"));
      }
      
      override public function setSubState() : void
      {
         loadVirmonViewer();
         _delayTimer = new Timer(PAUSE_BEFORE_DOORS_CLOSE / 2);
         _delayTimer.addEventListener(TimerEvent.TIMER,windUp);
         _delayTimer.start();
         _evoGameUI.destroy();
         _evoGameUI.getBackButton().addEventListener(MouseEvent.CLICK,quit);
         _evoGameUI.getQuickTipsButton().getButton().addEventListener(MouseEvent.CLICK,onQuickTipsClick);
      }
      
      private function evoOutCompleteHandler() : void
      {
         showVirmon();
         _evoGameUI.makeBurst();
      }
      
      private function onVirmonViewerLoaded(param1:Event) : void
      {
         _nanovorMegaViewerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onVirmonViewerLoaded);
         _nanovorMegaViewerLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onVirmonViewerLoadError);
         _nanovorMegaViewer = param1.target.content as NanovorMegaViewer;
         _nanovorMegaViewer.x = 655;
         _nanovorMegaViewer.y = 510;
         var _loc2_:Object = Managers.stateManager.getStateData(StateType.EVOGAME);
         var _loc3_:IVirmonData = DataManager.getInstance().getVirmonManager().getVirmonData(_loc2_.sourceVirmonId);
         var _loc4_:ICharacterAssetRetriever = Managers.assetRetrieverManager.characterAssetRetriever;
         var _loc5_:IAssetURL = _loc4_.getCharacterAnimationURL(CharacterAnimationAssetType.ENTER,_loc3_.getAssetTypeID());
         var _loc6_:AssetURLType = _loc5_.assetURLType == AssetURLType.FALLBACK_SUPERSEDED ? AssetURLType.FALLBACK_SUPERSEDED : AssetURLType.ACTUAL;
         var _loc7_:IAssetURL = _loc4_.getCharacterAnimationURL(CharacterAnimationAssetType.EVOLVE_OUT,_loc3_.getAssetTypeID(),"1",_loc6_);
         var _loc8_:IAssetURL = _loc4_.getCharacterAnimationURL(CharacterAnimationAssetType.EVOLVE_IN,int(_loc2_.targetMasterVirmonId));
         var _loc9_:AssetURLType = _loc8_.assetURLType == AssetURLType.FALLBACK_SUPERSEDED ? AssetURLType.FALLBACK_SUPERSEDED : AssetURLType.ACTUAL;
         var _loc10_:IAssetURL = _loc4_.getCharacterAnimationURL(CharacterAnimationAssetType.IDLE,int(_loc2_.targetMasterVirmonId),"1",_loc9_);
         if(_loc9_ == AssetURLType.FALLBACK_SUPERSEDED)
         {
            _destinationCharacterIsSuperseded = true;
         }
         var _loc11_:String = _loc5_.url;
         var _loc12_:String = _loc7_.url;
         var _loc13_:String = _loc8_.url;
         var _loc14_:String = _loc10_.url;
         _nanovorMegaViewer.Sequencer.addEventListener(Event.COMPLETE,viewerMoviesLoaded,false,0,true);
         _nanovorMegaViewer.Sequencer.LoadAndQueueClip(_loc11_,enterAnimLoadedHandler);
         _nanovorMegaViewer.Sequencer.LoadAndQueueClip(_loc12_,evoOutAnimLoadedHandler,evoOutCompleteHandler);
         _nanovorMegaViewer.Sequencer.LoadAndQueueClip(_loc13_,null,evoInCompleteHandler);
         _nanovorMegaViewer.Sequencer.LoadAndQueueClip(_loc14_);
         showVirmon();
      }
      
      private function enterAnimLoadedHandler(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,enterAnimLoadedHandler);
      }
   }
}

