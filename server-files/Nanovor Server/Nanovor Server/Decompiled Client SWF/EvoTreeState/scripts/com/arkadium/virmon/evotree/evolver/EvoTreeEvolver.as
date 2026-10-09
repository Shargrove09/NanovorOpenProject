package com.arkadium.virmon.evotree.evolver
{
   import com.arkadium.virmon.evogame.EvoGameStateData;
   import com.arkadium.virmon.framework.EvoData;
   import com.arkadium.virmon.state.IStateChanger;
   import com.arkadium.virmon.state.StateType;
   
   public class EvoTreeEvolver implements IEvoTreeEvolver
   {
      
      private var _stateChanger:IStateChanger;
      
      private var _nanovorAssetId:String;
      
      private var _evoData:EvoData;
      
      public function EvoTreeEvolver(param1:String, param2:EvoData, param3:IStateChanger)
      {
         super();
         _nanovorAssetId = param1;
         _evoData = param2;
         _stateChanger = param3;
      }
      
      public function evolveNanovor() : void
      {
         if(null == _nanovorAssetId)
         {
            return;
         }
         if(null == _evoData)
         {
            return;
         }
         if(null == _stateChanger)
         {
            return;
         }
         var _loc1_:EvoGameStateData = new EvoGameStateData(_evoData.getID(),_nanovorAssetId,_evoData.getDestinationTypeID(),_evoData.getTreeID());
         _stateChanger.setStateData(StateType.EVOGAME,_loc1_);
         _stateChanger.setState(StateType.EVOGAME);
      }
   }
}

