package com.arkadium.virmon.shared.elements.viewer.opponentattackaccordion
{
   import fl.transitions.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol44")]
   public class ItemAccordion extends MovieClip
   {
      
      public var _mcField:MovieClip;
      
      public var _tfTitle:TextField;
      
      private var _sFaction:String;
      
      private var _nStartY:Number = 0;
      
      public var _sbtInfo:SimpleButton;
      
      private var _uiMidFrame:uint = 1;
      
      private var _nDelay:Number = 1;
      
      private var _uiID:uint;
      
      public var _smcIcon:MovieClip;
      
      protected var FACTION_TYPE:Array = ["VELOCITRON","MAGNAMOD","HEXITE"];
      
      public var _mcBase:MovieClip;
      
      public var _mcFaction:MovieClip;
      
      public var _mcOffset:MovieClip;
      
      private var _bDirection:Boolean = false;
      
      private var _tween:Tween;
      
      public var _tfEnergy:TextField;
      
      public function ItemAccordion()
      {
         super();
         _nStartY = _mcField.y;
      }
      
      public function set icon(param1:String) : void
      {
         if(param1.toLowerCase() == "mod")
         {
            param1 = "attack";
         }
         _smcIcon.gotoAndStop(param1.toLowerCase());
      }
      
      public function get delay() : Number
      {
         return _nDelay;
      }
      
      public function open() : void
      {
         var _loc1_:Number = Number(_mcField.holder.height);
         var _loc2_:Number = _nStartY;
         var _loc3_:Number = 0;
         if(Boolean(_tween))
         {
            _tween.stop();
            _loc2_ = _tween.position;
         }
         if(!_bDirection)
         {
            _loc3_ = Math.abs(_nDelay * (_loc1_ - _loc2_ + _nStartY) / _loc1_);
            _tween = new Tween(_mcField,"y",null,_loc2_,_nStartY + _loc1_,_loc3_,true);
            _bDirection = true;
         }
         else
         {
            _loc3_ = Math.abs(_nDelay * (_loc2_ - _nStartY) / _loc1_);
            _tween = new Tween(_mcField,"y",null,_loc2_,_nStartY,_loc3_,true);
            _bDirection = false;
         }
      }
      
      public function set title(param1:String) : void
      {
         _tfTitle.text = param1;
      }
      
      public function get fieldHeight() : Number
      {
         return _mcField.holder.height;
      }
      
      public function get offset() : Number
      {
         return _mcOffset.height;
      }
      
      public function set delay(param1:Number) : void
      {
         _nDelay = param1;
      }
      
      public function get id() : uint
      {
         return _uiID;
      }
      
      public function set detail(param1:String) : void
      {
         _mcField.tfDetail.text = param1;
      }
      
      override public function get height() : Number
      {
         return _mcBase.height;
      }
      
      public function get faction() : String
      {
         return _sFaction;
      }
      
      public function set id(param1:uint) : void
      {
         _uiID = param1;
      }
      
      public function set energy(param1:String) : void
      {
         _tfEnergy.text = param1;
      }
      
      protected function updateDisplayList() : void
      {
         _mcFaction.gotoAndStop(1);
         _mcFaction.gotoAndStop(_sFaction);
         _mcField.gotoAndStop(_sFaction);
      }
      
      public function set faction(param1:String) : void
      {
         _sFaction = param1.toUpperCase();
         updateDisplayList();
      }
   }
}

