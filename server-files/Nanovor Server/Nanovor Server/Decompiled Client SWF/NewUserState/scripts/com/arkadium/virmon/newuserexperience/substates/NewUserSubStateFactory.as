package com.arkadium.virmon.newuserexperience.substates
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.CharacterAssetTypeCache;
   import com.arkadium.virmon.newuserexperience.INewUserStateCompleteHandler;
   import com.arkadium.virmon.newuserexperience.substates.complete.NewUserSubStateComplete;
   import com.arkadium.virmon.newuserexperience.substates.error.NewUserSubStateError;
   import com.arkadium.virmon.newuserexperience.substates.introvideo.NewUserSubStateIntro;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.NewUserSubStateBattle;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.substate.ISubState;
   import com.arkadium.virmon.shared.utils.substate.ISubStateFactory;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import flash.display.Sprite;
   
   public class NewUserSubStateFactory implements ISubStateFactory
   {
      
      private var _subStateError:NewUserSubStateError;
      
      private var _subStateComplete:NewUserSubStateComplete;
      
      private var _subStateIntro:NewUserSubStateIntro;
      
      private var _subStateBattle:NewUserSubStateBattle;
      
      public function NewUserSubStateFactory(param1:ISoundManager, param2:IPlayerFactory, param3:INanovorFactory, param4:Sprite, param5:IUserProfile, param6:IMasterDataAssetRetriever, param7:IOverlayAssetRetriever, param8:ICharacterAssetRetriever, param9:IHeaderWidget, param10:IWidgetManager, param11:Array, param12:INewUserStateCompleteHandler)
      {
         super();
         var _loc13_:CharacterAssetTypeCache = new CharacterAssetTypeCache(param8);
         _subStateIntro = new NewUserSubStateIntro(param4,param10);
         _subStateBattle = new NewUserSubStateBattle(param1,param2,param3,param4,param5,param6,param7,_loc13_,param9,param11);
         _subStateComplete = new NewUserSubStateComplete(param12);
         _subStateError = new NewUserSubStateError(param12);
      }
      
      public function createSubState(param1:String, param2:Object = null) : ISubState
      {
         switch(param1)
         {
            case NewUserSubStates.NEWUSER_SUBSTATE_INTRO:
               return _subStateIntro;
            case NewUserSubStates.NEWUSER_SUBSTATE_BATTLE:
               return _subStateBattle;
            case NewUserSubStates.NEWUSER_SUBSTATE_COMPLETE:
               return _subStateComplete;
            case NewUserSubStates.NEWUSER_SUBSTATE_ERROR:
               _subStateError.setErrorMessage(param2 as String);
               break;
            default:
               _subStateError.setErrorMessage("Attempted to go to unknown subStateType: " + param1);
         }
         return _subStateError;
      }
      
      public function destroy() : void
      {
         _subStateBattle.destroy();
      }
   }
}

