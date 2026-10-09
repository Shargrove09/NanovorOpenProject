package com.arkadium.virmon.state.initializer
{
   import com.arkadium.virmon.battle.control.AttackStatement;
   import com.arkadium.virmon.battle.control.AttackStatementFactory;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.data.AttackPreviewGenerator;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.NanovorFactory;
   import com.arkadium.virmon.shared.data.PlayerFactory;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.state.IState;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import flash.display.MovieClip;
   
   public class StateInitializer extends MovieClip implements IStateInitializer
   {
      
      private var _downloader:IDownloader;
      
      private var _applicationExiter:IApplicationExiter;
      
      public function StateInitializer()
      {
         super();
      }
      
      public function init(param1:IDownloader, param2:IApplicationExiter) : void
      {
         this._downloader = param1;
         this._applicationExiter = param2;
         AttackStatement.initialize(new AttackStatementFactory(DataManager.getInstance().getVirmonManager()));
         var _loc3_:INanovorFactory = new NanovorFactory(DataManager.getInstance().getVirmonManager());
         AttackPreviewGenerator.initialize(_loc3_,new PlayerFactory(_loc3_,UserProfile.getInstance()));
         Spotlight.initialize(Managers.soundManager);
      }
      
      public function initializeState(param1:StateType, param2:IState, param3:Object = null) : void
      {
         switch(param1)
         {
            case StateType.BATTLE:
               new BattleStateInitializer(param2).initialize();
               return;
            case StateType.COLLECTION:
               new CollectionStateInitializer(param2).initialize(param3);
               return;
            case StateType.DEVICEMANAGER:
               new DeviceStateInitializer(param2).initialize(this._downloader);
               return;
            case StateType.EVOTREE:
               new EvoTreeStateInitializer(param2).initialize();
               return;
            case StateType.HOME:
               new HomeStateInitializer(param2).initialize(this._applicationExiter);
               return;
            case StateType.NANOMALL:
               new NanomallStateInitializer(param2).initialize();
               return;
            case StateType.NEWUSER:
               new NewUserStateInitializer(param2).initialize();
               return;
            case StateType.SENSEI_BATTLE:
               new SenseiBattleStateInitializer(param2).initialize(param3);
               return;
            case StateType.TRADEGAME:
               new TradeStateInitializer(param2).initialize();
               return;
            default:
               param2.init(param3);
               return;
         }
      }
   }
}

