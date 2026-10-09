package com.arkadium.virmon.evogame
{
   import com.arkadium.analytics.enum.View;
   import com.arkadium.virmon.evogame.substates.EvoGameSubStateFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoaderRetry;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IChainLoaderErrorConsumer;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.shared.utils.substate.ISubStateController;
   import com.arkadium.virmon.shared.utils.substate.SubStateController;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class EvoGameState extends AbstractState implements IChainLoaderConsumer, IChainLoaderErrorConsumer
   {
      
      private static const EVOGAME_UI_URL:String = "EvoGameStateUI.swf";
      
      private var _subStateFactory:EvoGameSubStateFactory;
      
      private var _evoGameUI:IEvoGameStateUI;
      
      private var _isInitialized:Boolean = false;
      
      private var _subStateController:ISubStateController;
      
      private var _chainLoaderRetry:ChainLoaderRetry;
      
      public function EvoGameState()
      {
         super();
         stateName = StateType.EVOGAME.name;
      }
      
      public function handleChainLoaderError() : void
      {
         DebugLog.instance.error("EvoGameState.handleChainLoaderError(): CHAIN LOADER ERROR!!!");
      }
      
      override public function onUnsetState() : void
      {
         destroy();
      }
      
      override public function destroy() : void
      {
         if(_chainLoaderRetry != null)
         {
            _chainLoaderRetry.destroy();
         }
         if(_subStateController != null)
         {
            _subStateController.destroy();
         }
         if(_evoGameUI != null)
         {
            _evoGameUI.destroy();
         }
      }
      
      override public function onSetState() : void
      {
         if(null != Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name))
         {
            Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name).setMode(WidgetType.MODE_HIDDEN);
         }
         if(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name) != null)
         {
            IAutoBattleWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name)).hide();
         }
      }
      
      override public function init(param1:Object = null) : void
      {
         if(_isInitialized)
         {
            return;
         }
         _isInitialized = true;
         Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name).setMode(WidgetType.MODE_HIDDEN);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new SWFLoadee(EVOGAME_UI_URL,new LoaderContext(false,ApplicationDomain.currentDomain)));
         _chainLoaderRetry = new ChainLoaderRetry(_loc2_,IChainLoaderConsumer(this),IChainLoaderErrorConsumer(this));
         _chainLoaderRetry.load();
         Managers.analyticsManager.trackView(View.EVOLVE_GAME);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         DebugLog.instance.log("EvoGameState.handleChainLoaderComplete()");
         _chainLoaderRetry = null;
         _evoGameUI = IEvoGameStateUI(param1.getLoadedAsset(SWFLoadee.NAME + EVOGAME_UI_URL));
         _subStateFactory = new EvoGameSubStateFactory(_evoGameUI);
         _subStateController = new SubStateController(_subStateFactory);
         _subStateController.changeSubState(EvoGameSubStateFactory.EVOGAME_SUBSTATE_INIT);
         addChild(_evoGameUI as DisplayObject);
      }
   }
}

