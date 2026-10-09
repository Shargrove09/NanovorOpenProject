package com.arkadium.virmon.shared.renders
{
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.shared.elements.CChipTradeVirmon;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol86")]
   public class TradeVirmonRender extends CCellRenderer implements ICellRenderer
   {
      
      private static var _characterAssetRetriever:ICharacterAssetRetriever;
      
      private var _vUnit:CChipTradeVirmon;
      
      public function TradeVirmonRender()
      {
         super();
         _data = new Object();
         _data.state = 1;
         _vUnit = new CChipTradeVirmon(_characterAssetRetriever);
         _vUnit.gotoAndStop("normal");
         addChild(_vUnit);
      }
      
      public static function initializeStaticMembers(param1:ICharacterAssetRetriever) : void
      {
         _characterAssetRetriever = param1;
      }
      
      private function onDestroy(param1:Event) : void
      {
         param1.target.removeEventListener(CChipTradeVirmon.DESTROY,onDestroy);
         _data = {};
      }
      
      override public function set data(param1:Object) : void
      {
         _data = param1;
         _data.content = _vUnit;
         _vUnit.setData(_data.virmon,String(_data.param));
         _data.id = _data.virmon.getID();
         switch(_data.state)
         {
            case 1:
            default:
               _vUnit.gotoAndStop("normal");
               break;
            case 2:
               _vUnit.gotoAndStop("selected");
               break;
            case 3:
               _vUnit.gotoAndStop("disable");
         }
      }
   }
}

