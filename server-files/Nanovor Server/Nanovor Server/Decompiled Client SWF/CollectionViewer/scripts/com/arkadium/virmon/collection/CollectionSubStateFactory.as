package com.arkadium.virmon.collection
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.collection.shared.ICollectionViewerDataHandler;
   import com.arkadium.virmon.collection.substates.ems.CollectionSubStateEms;
   import com.arkadium.virmon.collection.substates.nanovor.CollectionSubStateNanovor;
   import com.arkadium.virmon.collection.substates.nanovor.ICollectionPreSelectData;
   import com.arkadium.virmon.collection.substates.nanovor.INanovorBuffController;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.CharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.utils.substate.ISubState;
   import com.arkadium.virmon.shared.utils.substate.ISubStateChanger;
   import com.arkadium.virmon.shared.utils.substate.ISubStateFactory;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import flash.display.Sprite;
   
   public class CollectionSubStateFactory implements ISubStateFactory
   {
      
      public static const COLLECTION_SUBSTATE_NANOVOR:String = "collectionSubstateNanovor";
      
      public static const COLLECTION_SUBSTATE_EMS:String = "collectionSubstateEms";
      
      private var _characterAssetTypeCache:CharacterAssetTypeCache;
      
      private var _subStateNanovor:CollectionSubStateNanovor;
      
      private var _subStateEms:CollectionSubStateEms;
      
      public function CollectionSubStateFactory(param1:ISoundManager, param2:IPlayer, param3:INanovorFactory, param4:Sprite, param5:IUserProfile, param6:IServiceRequestBrokerManager, param7:IAnalyticsManager, param8:ICollectionViewerDataHandler, param9:ISubStateChanger, param10:ICharacterAssetRetriever)
      {
         super();
         _characterAssetTypeCache = new CharacterAssetTypeCache(param10);
         _subStateNanovor = new CollectionSubStateNanovor(param1,param2,param3,param4,param5,param6,param7,param8,param9,_characterAssetTypeCache);
         _subStateEms = new CollectionSubStateEms(param4,param7,param9,_characterAssetTypeCache);
      }
      
      public function destroy() : void
      {
         if(null != _subStateEms)
         {
            _subStateEms.destroy();
            _subStateEms = null;
         }
         if(null != _subStateNanovor)
         {
            _subStateNanovor.destroy();
            _subStateNanovor = null;
         }
      }
      
      public function get nanovorBuffController() : INanovorBuffController
      {
         if(_subStateNanovor == null)
         {
            return null;
         }
         return _subStateNanovor.nanovorBuffController;
      }
      
      public function createSubState(param1:String, param2:Object = null) : ISubState
      {
         switch(param1)
         {
            case COLLECTION_SUBSTATE_EMS:
               return _subStateEms;
            case COLLECTION_SUBSTATE_NANOVOR:
               _subStateNanovor.preSelectNanovor(param2 as ICollectionPreSelectData);
               return _subStateNanovor;
            default:
               throw new Error("Could not find subStateType: " + param1);
         }
      }
   }
}

