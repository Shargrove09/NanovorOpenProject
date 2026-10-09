package com.arkadium.virmon.shared.renders
{
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.shared.elements.CChipTradeEm;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol85")]
   public class TradeEmsRender extends CCellRenderer implements ICellRenderer
   {
      
      private static var _emManager:IEMManager;
      
      private static var _emAssetRetriever:IEMAssetRetriever;
      
      private var _rUnit:CChipTradeEm;
      
      public function TradeEmsRender()
      {
         super();
         _rUnit = new CChipTradeEm(_emAssetRetriever,_emManager);
         _rUnit.gotoAndStop("normal");
         _rUnit.addEventListener(CChipTradeEm.DESTROY,onDestroy,false,0,true);
         addChild(_rUnit);
         _data = new Object();
         _data.state = 1;
         _data.content = _rUnit;
      }
      
      private static function logError(param1:String) : void
      {
         DebugLog.instance.error("** TradeEmsRender: " + param1);
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log(">> TradeEmsRender: " + param1);
      }
      
      public static function initializeStaticMembers(param1:IEMAssetRetriever, param2:IEMManager) : void
      {
         log("initializeStaticMembers(): emAssetRetriever=" + param1 + " emManager=" + param2);
         _emAssetRetriever = param1;
         _emManager = param2;
      }
      
      private function stopAnimation() : void
      {
         try
         {
            _rUnit.stopAnimation();
         }
         catch(e:Error)
         {
            _rUnit.addEventListener(CChipTradeEm.CHIP_LOADED,onEmChipLoadedStopAnimation,false,0,true);
         }
      }
      
      private function onEmChipLoadedStopAnimation(param1:Event) : void
      {
         var e:Event = param1;
         _rUnit.removeEventListener(CChipTradeEm.CHIP_LOADED,onEmChipLoadedStopAnimation);
         try
         {
            _rUnit.stopAnimation();
         }
         catch(err:Error)
         {
            logError("** onEmChipLoadedStopAnimation -- error: " + err.message);
         }
      }
      
      private function onDestroy(param1:Event) : void
      {
         param1.target.removeEventListener(CChipTradeEm.DESTROY,onDestroy);
         _data = {};
      }
      
      override public function set data(param1:Object) : void
      {
         _data = param1;
         _data.content = _rUnit;
         if(Boolean(_data.em))
         {
            _rUnit.setData(_data.em);
         }
         stopAnimation();
      }
   }
}

