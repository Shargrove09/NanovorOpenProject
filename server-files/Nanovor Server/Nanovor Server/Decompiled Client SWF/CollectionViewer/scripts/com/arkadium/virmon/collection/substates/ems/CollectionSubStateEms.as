package com.arkadium.virmon.collection.substates.ems
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.virmon.collection.CollectionSubStateFactory;
   import com.arkadium.virmon.collection.substates.ems.components.EMNanovorStageComponent;
   import com.arkadium.virmon.collection.substates.ems.components.EMTileComponent;
   import com.arkadium.virmon.collection.substates.ems.elements.EvolveBGElement;
   import com.arkadium.virmon.collection.substates.nanovor.CollectionPreSelectData;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.EvoData;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.shared.utils.substate.ISubStateChanger;
   import com.arkadium.virmon.shared.utils.substate.ISubStateChangerConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class CollectionSubStateEms extends AbstractSubState implements ISubStateChangerConsumer
   {
      
      private static const STAGE_POSITION:Point = new Point(0,510);
      
      private static const EVOLVE_POSITION:Point = new Point(250,320);
      
      private var _emsUIContainer:Sprite;
      
      private var _treeMenu:EMTreeMenu;
      
      private var _subStateChanger:ISubStateChanger;
      
      private var _preOpenFirstTimeTimer:Timer;
      
      private var _evolveBG:EvolveBGElement;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _nanovorView:EMNanovorStageComponent;
      
      private var _openedFirstTime:Boolean = false;
      
      private var _parentUIContainer:Sprite;
      
      public function CollectionSubStateEms(param1:Sprite, param2:IAnalyticsManager, param3:ISubStateChanger, param4:ICharacterAssetTypeCache)
      {
         super();
         _parentUIContainer = param1;
         _subStateChanger = param3;
         _analyticsManager = param2;
         _emsUIContainer = new Sprite();
         _emsUIContainer.visible = false;
         _emsUIContainer.alpha = 0;
         _characterAssetTypeCache = param4;
         _evolveBG = new EvolveBGElement();
         _emsUIContainer.addChild(_evolveBG);
         _evolveBG.x = EVOLVE_POSITION.x;
         _evolveBG.y = EVOLVE_POSITION.y;
         _evolveBG.alpha = 0;
         _evolveBG.visible = false;
         _nanovorView = new EMNanovorStageComponent();
         _emsUIContainer.addChild(_nanovorView);
         _nanovorView.x = STAGE_POSITION.x;
         _nanovorView.y = STAGE_POSITION.y;
         _nanovorView.alpha = 0;
         _nanovorView.addEventListener(EMNanovorStageEvent.NANOVOR_CLICKED,onEMNanovorClick,false,0,true);
         _treeMenu = new EMTreeMenu(DataManager.getInstance().getEMManager().getEMMasterDataList());
         _treeMenu.addEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEMSelect,false,0,true);
         _emsUIContainer.addChild(_treeMenu);
         _preOpenFirstTimeTimer = new Timer(4000,1);
         _preOpenFirstTimeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onPreOpenFirstTimeTimerComplete,false,0,true);
         _preOpenFirstTimeTimer.start();
      }
      
      public function handleSubStateChangeRequest(param1:String) : void
      {
         unsetState();
         _subStateController.changeSubState(param1);
         _subStateChanger.onSubStateChange(param1);
      }
      
      private function isIn2dArray(param1:*, param2:Array, param3:int) : *
      {
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_][param3] == param1)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function onEMNanovorClick(param1:EMNanovorStageEvent) : void
      {
         unsetState();
         var _loc2_:CollectionPreSelectData = new CollectionPreSelectData();
         _loc2_.setPreSelectAssetTypeId(param1.assetTypeId);
         _subStateController.changeSubState(CollectionSubStateFactory.COLLECTION_SUBSTATE_NANOVOR,_loc2_);
         _subStateChanger.onSubStateChange(CollectionSubStateFactory.COLLECTION_SUBSTATE_NANOVOR);
      }
      
      private function onPreOpenFirstTimeTimerComplete(param1:TimerEvent) : void
      {
         if(_openedFirstTime)
         {
            return;
         }
         _openedFirstTime = true;
         killPreOpenFirstTimeTimer();
         _treeMenu.openFirst();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** CollectionSubStateEms: " + param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CollectionSubStateEms: " + param1);
      }
      
      private function killPreOpenFirstTimeTimer() : void
      {
         if(_preOpenFirstTimeTimer != null)
         {
            _preOpenFirstTimeTimer.stop();
            _preOpenFirstTimeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onPreOpenFirstTimeTimerComplete);
            _preOpenFirstTimeTimer = null;
         }
      }
      
      private function sorter(param1:*, param2:*) : Number
      {
         var _loc3_:* = Number(param1[2]);
         var _loc4_:* = Number(param2[2]);
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public function destroy() : void
      {
         if(null != _treeMenu)
         {
            _treeMenu.destroy();
            _treeMenu.removeEventListener(EMTreeMenuEvent.EMTILE_CLICK,onEMSelect);
         }
         if(null != _nanovorView)
         {
            _nanovorView.destroy();
            _nanovorView.removeEventListener(EMNanovorStageEvent.NANOVOR_CLICKED,onEMNanovorClick);
         }
         killPreOpenFirstTimeTimer();
      }
      
      private function onEMSelect(param1:EMTreeMenuEvent) : void
      {
         var e:EMTreeMenuEvent = param1;
         _nanovorView.clear();
         Tweener.addTween(_evolveBG,{
            "_autoAlpha":0,
            "time":_evolveBG.alpha * 0.25,
            "onComplete":function():*
            {
               try
               {
                  _evolveBG._field.text = "NANOVOR EVOLVED WITH " + _treeMenu.getCurrentTile().data.getShortName();
                  Tweener.addTween(_evolveBG,{
                     "_autoAlpha":1,
                     "time":0.5
                  });
               }
               catch(e:Error)
               {
               }
            }
         });
         Tweener.addTween(_nanovorView,{
            "alpha":0,
            "time":_nanovorView.alpha * 0.25,
            "onComplete":loadNanovors
         });
      }
      
      private function unsetState() : void
      {
         _subStateChanger.removeSubStateChangerConsumer(this);
         Tweener.removeTweens(_emsUIContainer);
         Tweener.addTween(_emsUIContainer,{
            "_autoAlpha":0,
            "time":0.5,
            "transition":"easeOutExpo",
            "onComplete":removePanelAfterFade
         });
      }
      
      private function loadNanovors() : void
      {
         var _loc4_:int = 0;
         var _loc5_:EvoData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:EMTileComponent = _treeMenu.getCurrentTile();
         var _loc2_:Array = DataManager.getInstance().getEvoManager().getEvoList();
         var _loc3_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.getPalette().indexOf(_loc1_.data.getAssetTypeID()) > -1)
            {
               if(!isIn2dArray(_loc5_.getSourceTypeID(),_loc3_,0))
               {
                  if(DataManager.getInstance().getVirmonManager().getVirmonDataByAssetTypeId(_loc5_.getSourceTypeID()) != null)
                  {
                     _loc3_.push([_loc5_.getSourceTypeID(),0,_loc5_.getSourceYPos()]);
                  }
                  else if(_loc5_.getIsDiscovered())
                  {
                     _loc3_.push([_loc5_.getSourceTypeID(),1,_loc5_.getSourceYPos()]);
                  }
                  else
                  {
                     _loc3_.push([_loc5_.getSourceTypeID(),2,_loc5_.getSourceYPos()]);
                  }
               }
            }
            _loc4_++;
         }
         _loc3_.sort(sorter);
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc6_ = int(_loc3_[_loc4_][0]);
            _loc7_ = int(_loc3_[_loc4_][1]);
            _nanovorView.addNanovor(new EMNanovorView(_loc6_,_loc7_,_characterAssetTypeCache));
            _loc4_++;
         }
         if(_loc3_.length == 0)
         {
            _nanovorView.showNoNanovor();
         }
         Tweener.addTween(_nanovorView,{
            "_autoAlpha":1,
            "time":0.5
         });
      }
      
      override public function setSubState() : void
      {
         _subStateChanger.addSubStateChangerConsumer(this);
         _parentUIContainer.addChild(_emsUIContainer);
         Tweener.removeTweens(_emsUIContainer);
         Tweener.addTween(_emsUIContainer,{
            "_autoAlpha":1,
            "time":0.5,
            "transition":"easeInExpo"
         });
         if(!_openedFirstTime)
         {
            _openedFirstTime = true;
            killPreOpenFirstTimeTimer();
            _treeMenu.openFirst();
         }
         _analyticsManager.trackView(View.COLLECTION_EMS);
      }
      
      private function removePanelAfterFade() : void
      {
         if(null != _emsUIContainer.parent)
         {
            _emsUIContainer.parent.removeChild(_emsUIContainer);
         }
      }
   }
}

