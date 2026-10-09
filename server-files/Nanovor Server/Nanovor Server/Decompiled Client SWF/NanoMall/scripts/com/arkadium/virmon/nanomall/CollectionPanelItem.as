package com.arkadium.virmon.nanomall
{
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.EMMasterData;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.shared.elements.CChipTradeEm;
   import com.arkadium.virmon.shared.elements.CCollectionVirmonUnit;
   import com.arkadium.virmon.shared.utils.CEm;
   import com.arkadium.virmon.shared.utils.CVirmon;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   
   public class CollectionPanelItem extends MovieClip
   {
      
      public static const VIRMON_LOAD_COMPLETE:String = "VIRMON_COMPLETE";
      
      public static const EM_LOAD_COMPLETE:String = "emLoadComplete";
      
      public static const ITEM_DOWN:String = "COLLECTIONPANEL_ITEM_DOWN";
      
      public static const TYPE_VIRMON:String = "virmon";
      
      public static const TYPE_EM:String = "em";
      
      private var iID:String;
      
      private var _bShowBG:Boolean;
      
      private var _oChipVirmon:CCollectionVirmonUnit;
      
      private var _oChipEM:CChipTradeEm;
      
      private var sType:String;
      
      private var aEMDataList:Array;
      
      private const ITEM_HEIGHT:int = 100;
      
      private var _emAssetRetriever:IEMAssetRetriever;
      
      private var mcHA:MovieClip;
      
      private var _emManager:IEMManager;
      
      private var oHA:Shape;
      
      private var _virmonManager:IVirmonManager;
      
      private var curVirmonData:IVirmon;
      
      private const ITEM_WIDTH:int = 100;
      
      private var curEMMasterData:EMMasterData;
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      public function CollectionPanelItem(param1:IVirmonManager, param2:ICharacterAssetRetriever, param3:IEMManager, param4:IEMAssetRetriever, param5:String, param6:String, param7:Boolean = true)
      {
         super();
         _virmonManager = param1;
         _characterAssetRetriever = param2;
         _emManager = param3;
         _emAssetRetriever = param4;
         sType = param5;
         iID = param6;
         _bShowBG = param7;
         makeHitArea();
         mcHA.useHandCursor = true;
         mcHA.buttonMode = true;
         mcHA.mouseChildren = false;
         mcHA.addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
      }
      
      public function destroy() : void
      {
         if(_oChipVirmon != null)
         {
            _oChipVirmon.destroy();
         }
         if(_oChipEM != null)
         {
            _oChipEM.destroy();
         }
         mcHA.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
      }
      
      public function get emMasterData() : EMMasterData
      {
         return curEMMasterData;
      }
      
      private function loadVirmonItem() : void
      {
         curVirmonData = new CVirmon();
         curVirmonData.create(iID,DataManager.getInstance().getVirmonManager().getVirmonData(id));
         _oChipVirmon = new CCollectionVirmonUnit(_characterAssetRetriever);
         if(_bShowBG)
         {
            _oChipVirmon.showHolder();
         }
         _oChipVirmon.gotoAndStop("normal");
         _oChipVirmon.setData(curVirmonData);
         addChild(_oChipVirmon);
         dispatchEvent(new Event(VIRMON_LOAD_COMPLETE));
      }
      
      public function get virmonData() : IVirmon
      {
         return curVirmonData;
      }
      
      private function loadEMItem() : void
      {
         curEMMasterData = DataManager.getInstance().getEMManager().getEMData(iID).getEMMasterData();
         var _loc1_:CEm = new CEm();
         _loc1_.createFromMaster(curEMMasterData);
         _loc1_.count = 1;
         _oChipEM = new CChipTradeEm(_emAssetRetriever,_emManager);
         if(!_bShowBG)
         {
            _oChipEM.hideBG();
         }
         _oChipEM.setData(_loc1_);
         addChild(_oChipEM);
         dispatchEvent(new Event(EM_LOAD_COMPLETE));
      }
      
      public function get id() : String
      {
         return iID;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CollectionPanelItem: " + param1);
      }
      
      public function showBgPlate() : void
      {
         if(sType == TYPE_VIRMON)
         {
            _oChipVirmon.showHolder();
         }
         if(sType == TYPE_EM)
         {
            _oChipEM.showBG();
         }
      }
      
      public function getBitmap(param1:Boolean = false) : Bitmap
      {
         if(!param1)
         {
            hideBgPlate();
         }
         var _loc2_:BitmapData = new BitmapData(ITEM_WIDTH,ITEM_HEIGHT,true,0);
         _loc2_.draw(this);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         if(!param1 && _bShowBG)
         {
            showBgPlate();
         }
         return _loc3_;
      }
      
      private function makeHitArea() : void
      {
         mcHA = new MovieClip();
         var _loc1_:* = new Shape();
         _loc1_.graphics.beginFill(65535);
         _loc1_.graphics.drawRect(0,0,ITEM_WIDTH,ITEM_HEIGHT);
         _loc1_.graphics.endFill();
         mcHA.addChild(_loc1_);
         mcHA.alpha = 0;
      }
      
      public function load() : void
      {
         log("load");
         switch(sType)
         {
            case TYPE_VIRMON:
               loadVirmonItem();
               break;
            case TYPE_EM:
               log("load TYPE_EM");
               loadEMItem();
         }
         addChild(mcHA);
      }
      
      public function hideBgPlate() : void
      {
         if(sType == TYPE_VIRMON)
         {
            _oChipVirmon.hideHolder();
         }
         if(sType == TYPE_EM)
         {
            _oChipEM.hideBG();
         }
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.sType = sType;
         _loc2_.iID = iID;
         _loc2_.mouseX = this.mouseX;
         _loc2_.mouseY = this.mouseY;
         dispatchEvent(new CustomEvent(ITEM_DOWN,_loc2_,true));
      }
      
      public function get chipType() : String
      {
         return sType;
      }
   }
}

