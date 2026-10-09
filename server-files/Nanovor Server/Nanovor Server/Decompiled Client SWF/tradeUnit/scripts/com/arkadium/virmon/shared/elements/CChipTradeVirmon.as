package com.arkadium.virmon.shared.elements
{
   import com.arkadium.virmon.framework.*;
   import com.arkadium.virmon.framework.asset.enum.CharacterChipAssetType;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.shared.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.URLRequest;
   import flash.text.*;
   
   public class CChipTradeVirmon extends MovieClip implements IChipDrawable
   {
      
      public static var DESTROY:String = "destroy";
      
      public var _mcHolder:MovieClip;
      
      public var _mcRollOverLights:MovieClip;
      
      private var _sOutParam:String;
      
      private var _param:Array = [{
         "name":"SV",
         "color":16711680
      },{
         "name":"ARM",
         "color":65280
      },{
         "name":"STR",
         "color":255
      },{
         "name":"HP",
         "color":16711935
      },{
         "name":"SPD",
         "color":65535
      }];
      
      private var _cVirmon:IVirmon;
      
      public var _smcUnitBg:MovieClip;
      
      public var _mcRollOvWithCont:MovieClip;
      
      private var _virmonLoader:Loader;
      
      public var _sbtUnit:SimpleButton;
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      private var _id:String;
      
      public var _mcCellBack:MovieClip;
      
      public function CChipTradeVirmon(param1:ICharacterAssetRetriever)
      {
         super();
         addFrameScript(0,frame1);
         stop();
         _characterAssetRetriever = param1;
         _smcUnitBg.stop();
         _mcRollOverLights.stop();
         _mcRollOvWithCont.stop();
         _sbtUnit.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler,false,0,true);
      }
      
      private function paramOut(param1:int, param2:int) : String
      {
         var _loc3_:TextFormat = _smcUnitBg._stfParams.getTextFormat();
         _loc3_.color = _param[param1].color;
         _smcUnitBg._stfParams.defaultTextFormat = _loc3_;
         return _param[param1].name + ": " + String(param2);
      }
      
      public function update() : void
      {
         initTextField();
         setData(_cVirmon,_sOutParam);
      }
      
      public function getVirmon() : IVirmon
      {
         return _cVirmon;
      }
      
      public function destroy() : void
      {
         _smcUnitBg.stop();
         _mcRollOvWithCont.stop();
         _mcRollOverLights.stop();
         try
         {
            _virmonLoader.close();
            _virmonLoader.unload();
            _mcRollOvWithCont._spContent.removeChild(_virmonLoader);
            _virmonLoader = null;
         }
         catch(e:*)
         {
         }
         Utils.clearAllChildren(this);
         dispatchEvent(new Event(DESTROY));
      }
      
      public function clearImage() : void
      {
         try
         {
            _virmonLoader.close();
            _virmonLoader.unload();
         }
         catch(e:*)
         {
         }
         _virmonLoader = null;
      }
      
      public function getId() : String
      {
         return _id;
      }
      
      private function initTextField() : void
      {
         var _loc1_:String = "";
         _smcUnitBg._stfName.text = Boolean(_cVirmon.getName()) ? _cVirmon.getName() : "";
         _smcUnitBg._stfNick.text = Boolean(_cVirmon.getNickName()) ? _cVirmon.getNickName() : "";
         _smcUnitBg.gotoAndStop(_cVirmon.getFaction());
         switch(_sOutParam.toUpperCase())
         {
            case "ARMOR":
               _loc1_ = paramOut(1,_cVirmon.getArmor());
               break;
            case "STRENGTH":
               _loc1_ = paramOut(2,_cVirmon.getStrength());
               break;
            case "HEALTH":
               _loc1_ = paramOut(3,_cVirmon.getHealth());
               break;
            case "SPEED":
               _loc1_ = paramOut(4,_cVirmon.getSpeed());
               break;
            default:
               _loc1_ = paramOut(0,_cVirmon.getSV());
         }
         _smcUnitBg._stfParams.text = _loc1_;
         _smcUnitBg._stfMarketValue.text = "MV: $" + String(_cVirmon.getMarketValue());
      }
      
      private function mouseOutHandler(param1:MouseEvent) : *
      {
         _mcRollOverLights.gotoAndStop(1);
         _sbtUnit.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
         _sbtUnit.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler,false,0,true);
      }
      
      private function onLoadErrorAvatar(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onLoadErrorAvatar);
         trace(" :: VIRMON AVATAR :: image not found! :: (" + param1 + ")");
      }
      
      public function clone() : MovieClip
      {
         return MovieClip(this);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      public function setData(param1:*, ... rest) : void
      {
         var _loc3_:String = null;
         _cVirmon = IVirmon(param1);
         _id = _cVirmon.getID();
         _sOutParam = rest[0] != undefined ? String(rest[0]) : "";
         initTextField();
         if(!_virmonLoader && _cVirmon.getMasterId() > 0)
         {
            _loc3_ = _characterAssetRetriever.getCharacterChipURL(CharacterChipAssetType.IDLE,_cVirmon.getMasterId()).url;
            while(_mcRollOvWithCont._spContent.numChildren != 0)
            {
               _mcRollOvWithCont._spContent.removeChildAt(0);
            }
            _virmonLoader = new Loader();
            _virmonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadErrorAvatar,false,0,true);
            _virmonLoader.load(new URLRequest(_loc3_));
            _mcRollOvWithCont._spContent.addChild(_virmonLoader);
         }
      }
      
      private function mouseOverHandler(param1:MouseEvent) : *
      {
         _mcRollOverLights.gotoAndPlay(2);
         _sbtUnit.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         _sbtUnit.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler,false,0,true);
      }
   }
}

