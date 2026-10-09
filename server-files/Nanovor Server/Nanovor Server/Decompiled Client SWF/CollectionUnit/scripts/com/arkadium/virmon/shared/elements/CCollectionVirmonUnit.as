package com.arkadium.virmon.shared.elements
{
   import com.arkadium.virmon.framework.asset.enum.CharacterChipAssetType;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.shared.utils.*;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.text.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol38")]
   public class CCollectionVirmonUnit extends MovieClip
   {
      
      public var _mcRollOverLights:MovieClip;
      
      public var _mcText:MovieClip;
      
      private var _cVirmon:IVirmon;
      
      public var _smcUnitBg:MovieClip;
      
      public var _mcRollOvWithCont:MovieClip;
      
      public var _smcHealthBar:MovieClip;
      
      private var _bIsSVShow:Boolean;
      
      public var _mcMask:MovieClip;
      
      private var _iType:int;
      
      public var _mcCellBack:Sprite;
      
      private var _id:String;
      
      private var _virmonLoader:Loader;
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      public var _sbtUnit:SimpleButton;
      
      private var _spAvatar:Bitmap;
      
      public function CCollectionVirmonUnit(param1:ICharacterAssetRetriever)
      {
         super();
         addFrameScript(0,frame1);
         _characterAssetRetriever = param1;
         _bIsSVShow = false;
         _smcUnitBg.stop();
         _mcRollOvWithCont.stop();
         _mcRollOverLights.stop();
         _spAvatar = new Bitmap();
         _mcRollOvWithCont._sspCont.addChild(_spAvatar);
         _mcCellBack.visible = false;
         _sbtUnit.useHandCursor = false;
         _smcHealthBar.visible = false;
      }
      
      public function showSortStatsSmart(param1:String) : void
      {
         _mcText._stfStats.htmlText = "<font color =\"" + _getStatColor(param1) + "\">" + _getStatLabel(param1) + _getStatValue(param1) + "</font>";
      }
      
      public function getVirmon() : IVirmon
      {
         return _cVirmon;
      }
      
      public function hideHolder() : void
      {
         _mcCellBack.visible = false;
      }
      
      private function loadVirmonImage(param1:String) : void
      {
         var sURL:String = param1;
         if(Boolean(_virmonLoader))
         {
            try
            {
               _virmonLoader.close();
            }
            catch(e:*)
            {
            }
         }
         _virmonLoader = new Loader();
         _virmonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete,false,0,true);
         _virmonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError,false,0,true);
         _virmonLoader.load(new URLRequest(sURL));
      }
      
      public function showHolder() : void
      {
         _mcCellBack.visible = true;
      }
      
      public function clearImage() : void
      {
         if(Boolean(_virmonLoader))
         {
            _virmonLoader.unload();
         }
         try
         {
            _virmonLoader.close();
         }
         catch(e:*)
         {
         }
         if(Boolean(_spAvatar) && Boolean(_spAvatar.bitmapData))
         {
            _spAvatar.bitmapData.dispose();
         }
         _spAvatar = new Bitmap();
      }
      
      private function showHealthBar() : void
      {
         _smcHealthBar.visible = true;
      }
      
      private function initTextField() : void
      {
         if(_cVirmon != null)
         {
            _mcText._stfName.text = _cVirmon.getName() != null ? _cVirmon.getName().toUpperCase() : "";
            _mcText._stfNick.text = _cVirmon.getNickName() != null && _cVirmon.getNickName() != "null" ? _cVirmon.getNickName().toUpperCase() : "";
            initHealthBar();
            if(!_bIsSVShow)
            {
               _mcText._stfStats.htmlText = Boolean(_cVirmon) ? _cVirmon.getCurrentHealth().toString() + "/" + _cVirmon.getHealth().toString() : "";
            }
            else
            {
               _mcText._stfStats.htmlText = Boolean(_cVirmon) ? "SV:" + _cVirmon.getSV().toString() : "";
               _mcText._stfStats.textColor = _getStatHexColor("sv");
               hideHealthBar();
            }
            this._smcUnitBg.gotoAndStop(_cVirmon.getFaction());
            _sbtUnit.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler,false,0,true);
         }
      }
      
      private function _getStatColor(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case "armor":
               _loc2_ = "#9c00ff";
               break;
            case "strength":
               _loc2_ = "#ff0000";
               break;
            case "speed":
            case "health":
            case "pv":
            case "sv":
               _loc2_ = "#ffffff";
               break;
            default:
               _loc2_ = "#14f001";
         }
         return _loc2_;
      }
      
      public function getId() : String
      {
         return _id;
      }
      
      private function mouseOutHandler(param1:MouseEvent) : *
      {
         _mcRollOvWithCont.gotoAndStop(1);
         _mcRollOverLights.gotoAndStop(1);
         _sbtUnit.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
         _sbtUnit.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler,false,0,true);
      }
      
      public function toggleHealthBar(param1:Boolean = true) : void
      {
         _smcHealthBar.visible = param1;
      }
      
      public function showSortStats(param1:String, param2:String, param3:String) : void
      {
         _mcText._stfStats.htmlText = "<font color = \"" + param3 + "\">" + param1 + param2 + "</font>";
      }
      
      private function onLoadError(param1:IOErrorEvent) : void
      {
         _virmonLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
         _virmonLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadError);
         DebugLog.instance.error("** CCollectionVirmonUnit: Load Error -- " + param1.text);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> CCollectionVirmonUnit: ** " + param1 + " **");
      }
      
      public function setData(param1:IVirmon) : void
      {
         var _loc2_:IVirmon = null;
         if(param1 != null)
         {
            _loc2_ = _cVirmon;
            _cVirmon = param1;
            _id = _cVirmon.getID();
            initTextField();
            if(_cVirmon.getMasterId() > 0)
            {
               loadVirmonURLImage();
            }
         }
      }
      
      private function _getStatLabel(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case "armor":
               _loc2_ = "ARM: ";
               break;
            case "speed":
               _loc2_ = "SPD: ";
               break;
            case "strength":
               _loc2_ = "STR: ";
               break;
            case "health":
               _loc2_ = "";
               break;
            case "pv":
            case "sv":
            default:
               _loc2_ = "SV: ";
         }
         return _loc2_;
      }
      
      private function _getStatHexColor(param1:String) : uint
      {
         var _loc2_:uint = 16711680;
         switch(param1)
         {
            case "armor":
               _loc2_ = 10223871;
               break;
            case "strength":
               _loc2_ = 16711680;
               break;
            case "speed":
            case "health":
            case "pv":
            case "sv":
               _loc2_ = 16777215;
               break;
            default:
               _loc2_ = 1372161;
         }
         return _loc2_;
      }
      
      private function _getStatValue(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case "armor":
               _loc2_ = _cVirmon.getArmor().toString();
               break;
            case "strength":
               _loc2_ = _cVirmon.getStrength().toString();
               break;
            case "speed":
               _loc2_ = _cVirmon.getSpeed().toString();
               break;
            case "health":
               _loc2_ = _cVirmon.getCurrentHealth().toString() + "/" + _cVirmon.getHealth().toString();
               break;
            case "pv":
            case "sv":
            default:
               _loc2_ = _cVirmon.getSV().toString();
         }
         return _loc2_;
      }
      
      private function onComplete(param1:Event) : void
      {
         var _loc3_:* = undefined;
         _virmonLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
         _virmonLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadError);
         var _loc2_:* = param1.target.content;
         if(_loc2_)
         {
            if(Boolean(_spAvatar) && Boolean(_mcRollOvWithCont._sspCont.contains(_spAvatar)))
            {
               _mcRollOvWithCont._sspCont.removeChild(_spAvatar);
               if(Boolean(_spAvatar) && Boolean(_spAvatar.bitmapData))
               {
                  _spAvatar.bitmapData.dispose();
               }
            }
            _loc3_ = new BitmapData(_loc2_.width + 50,_loc2_.height + 50,true,0);
            _loc3_.draw(_loc2_,null);
            _spAvatar = new Bitmap(_loc3_);
            _mcRollOvWithCont._sspCont.addChild(_spAvatar);
            _virmonLoader.unload();
            _virmonLoader = null;
         }
      }
      
      public function showSv() : void
      {
         _bIsSVShow = true;
      }
      
      private function enterFrm(param1:Event) : *
      {
         if(_mcRollOvWithCont.currentLabel == "end")
         {
            _mcRollOvWithCont.stop();
            _mcRollOverLights.stop();
            _mcRollOvWithCont.removeEventListener(Event.ENTER_FRAME,enterFrm);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CCollectionVirmonUnit: " + param1);
      }
      
      public function showPv() : void
      {
         _bIsSVShow = true;
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      private function loadVirmonURLImage() : void
      {
         _iType = _cVirmon.getMasterId();
         if(_cVirmon.getCurrentHealth() > 0)
         {
            loadVirmonImage(_characterAssetRetriever.getCharacterChipURL(CharacterChipAssetType.IDLE,_cVirmon.getMasterId()).url);
         }
         if(_cVirmon.getCurrentHealth() <= 0)
         {
            loadVirmonImage(_characterAssetRetriever.getCharacterChipURL(CharacterChipAssetType.DEATHS,_cVirmon.getMasterId()).url);
         }
      }
      
      private function initHealthBar() : void
      {
         var _loc1_:int = Math.round(_cVirmon.getCurrentHealth() * 100 / _cVirmon.getHealth());
         var _loc2_:int = Math.round(_loc1_ * _smcHealthBar.totalFrames / 100);
         if(_loc2_ < 2 && _cVirmon.getCurrentHealth() > 0)
         {
            _loc2_ = 2;
         }
         _smcHealthBar.gotoAndStop(_loc2_);
         showHealthBar();
      }
      
      private function mouseOverHandler(param1:MouseEvent) : *
      {
         _mcRollOvWithCont.play();
         _mcRollOverLights.play();
         _mcRollOvWithCont.addEventListener(Event.ENTER_FRAME,enterFrm,false,0,true);
         _sbtUnit.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler,false,0,true);
         _sbtUnit.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
      }
      
      private function hideHealthBar() : void
      {
         _smcHealthBar.visible = false;
      }
      
      public function destroy() : void
      {
         _sbtUnit.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         _sbtUnit.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
         _smcUnitBg.stop();
         _mcRollOvWithCont.stop();
         _mcRollOverLights.stop();
         _mcRollOvWithCont.removeEventListener(Event.ENTER_FRAME,enterFrm);
         if(Boolean(_spAvatar) && Boolean(_mcRollOvWithCont._sspCont.contains(_spAvatar)))
         {
            _mcRollOvWithCont._sspCont.removeChild(_spAvatar);
         }
         clearImage();
         if(Boolean(_spAvatar) && Boolean(_spAvatar.bitmapData))
         {
            _spAvatar.bitmapData.dispose();
         }
         _spAvatar = null;
         Utils.clearAllChildren(this);
         _virmonLoader = null;
      }
   }
}

