package com.arkadium.virmon.evogame
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.EMData;
   import com.arkadium.virmon.shared.final.elements.GenericEM;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class Hopper extends MovieClip
   {
      
      private var _id:int;
      
      private var _em:GenericEM;
      
      public var mcClamps:MovieClip;
      
      private var _assetIds:Array;
      
      private var _tray:HopperTray;
      
      public var tfName:TextField;
      
      private const EM_LARGE_Y:int = 19;
      
      public var tfQty:TextField;
      
      private const EM_SMALL_X:int = 50;
      
      private const EM_SMALL_Y:int = 40;
      
      private const EM_LARGE_X:int = 2;
      
      private var _locked:Boolean;
      
      private var _quantity:int;
      
      private const EM_SMALL_SCALE:Number = 0.05;
      
      public var mcFactionIcon:MovieClip;
      
      public function Hopper(param1:HopperTray, param2:int)
      {
         super();
         _id = param2;
         _tray = param1;
         tfName.text = DataManager.getInstance().getEMManager().getEMMasterData(param2).getShortName();
         _quantity = DataManager.getInstance().getEMManager().getEMQuantity(param2).length;
         tfQty.text = _quantity + "";
         _assetIds = new Array();
         var _loc3_:Array = DataManager.getInstance().getEMManager().getEMDataListByMasterID(param2);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _assetIds.push(EMData(_loc3_[_loc4_]).getAssetID());
            _loc4_++;
         }
         if(_quantity > 0 || _tray == null)
         {
            makeEM();
         }
      }
      
      public function getID() : int
      {
         return _id;
      }
      
      private function zoomEM() : void
      {
         mcClamps.gotoAndPlay("open");
         _em.visible = true;
         _em.x = EM_SMALL_X;
         _em.y = EM_SMALL_Y;
         _em.scaleX = _em.scaleY = EM_SMALL_SCALE;
         _em.alpha = 0;
         Tweener.addTween(_em,{
            "time":0.75,
            "scaleX":1,
            "scaleY":1,
            "alpha":1,
            "x":EM_LARGE_X,
            "y":EM_LARGE_Y
         });
      }
      
      private function onEMPress(param1:MouseEvent) : void
      {
         if(_locked)
         {
            return;
         }
         --_quantity;
         tfQty.text = _quantity + "";
         _em.visible = false;
         _em.assetId = _assetIds.splice(0,1)[0];
         _tray.onEMPress(_em);
         mcClamps.gotoAndPlay("reset");
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> Evolution Game >> Hopper: " + param1);
      }
      
      private function makeEM() : void
      {
         _em = new GenericEM(_id);
         _em.x = EM_LARGE_X;
         _em.y = EM_LARGE_Y;
         _em.stopCrystal();
         addChild(_em);
         if(Boolean(_tray))
         {
            _em.addEventListener(MouseEvent.MOUSE_DOWN,onEMPress,false,0,true);
         }
      }
      
      public function onEMLetGo(param1:GenericEM) : void
      {
         if(Boolean(param1) && param1.getID() > -1)
         {
            ++_quantity;
            _em.visible = true;
            tfQty.text = _quantity + "";
            _assetIds.push(param1.assetId);
            mcClamps.gotoAndPlay("reset");
         }
         else if(_quantity > 0)
         {
            zoomEM();
         }
      }
      
      public function lock(param1:Boolean) : void
      {
         _locked = param1;
      }
      
      public function clearQuantity() : void
      {
         tfQty.text = "";
      }
   }
}

