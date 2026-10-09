package com.arkadium.virmon.movieplayer
{
   import com.arkadium.virmon.shared.final.components.HealthBar;
   import flash.display.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol154")]
   public class TextEffect extends MovieClip
   {
      
      public var _mcMyVisibleMessage:*;
      
      public var _sMessage:String;
      
      public var _sType:String;
      
      public var _smcTextEffectMessage:MovieClip;
      
      public function TextEffect()
      {
         super();
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.inititiveMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.effectnameMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.hackeffectnameMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.overrideeffectnameMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.attacknameMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.fizzleMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.stunnedMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.passMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.damagehealthMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.damagespeedMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.damagestrengthMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.damagearmorMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.damageenergyMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.critMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.glitchMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.hackMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.overrideMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.textstringMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.hpchangeMc);
         _smcTextEffectMessage.removeChild(_smcTextEffectMessage.showshieldMc);
      }
      
      public function setHpChange(param1:Number, param2:Number, param3:Number) : *
      {
         _sType = "hpchange";
         _sMessage = param1 + " -> " + param2;
         if(_smcTextEffectMessage.healthBar == null)
         {
            _smcTextEffectMessage.healthBar = new HealthBar();
            _smcTextEffectMessage.healthBar.x = 138;
            _smcTextEffectMessage.healthBar.y = 27;
         }
         _mcMyVisibleMessage = _smcTextEffectMessage["healthBar"];
         _mcMyVisibleMessage["setHealthVars"](param1,param2,param3);
         _smcTextEffectMessage.addChild(_mcMyVisibleMessage);
      }
      
      public function setMessage(param1:*, param2:*) : *
      {
         _sType = param1.toLowerCase();
         _sMessage = param2;
         _mcMyVisibleMessage = _smcTextEffectMessage[_sType + "Mc"];
         _smcTextEffectMessage.addChild(_mcMyVisibleMessage);
         if(!(_sType == "hack" || _sType == "override"))
         {
            _mcMyVisibleMessage._smcText._smcText._sdtText.text = _sMessage;
         }
      }
      
      public function startAction() : *
      {
         if(_sType == "hack" || _sType == "override")
         {
            _mcMyVisibleMessage.gotoAndPlay(1);
         }
         else if(_sType == "hpchange")
         {
            _mcMyVisibleMessage["playHealthChangeAnimation"]();
         }
         else
         {
            _mcMyVisibleMessage.gotoAndPlay(1);
            _mcMyVisibleMessage._smcText.gotoAndPlay(1);
            _mcMyVisibleMessage._smcText._smcText.gotoAndPlay(1);
            _mcMyVisibleMessage._smcText._smcText._sdtText.text = _sMessage;
         }
      }
   }
}

