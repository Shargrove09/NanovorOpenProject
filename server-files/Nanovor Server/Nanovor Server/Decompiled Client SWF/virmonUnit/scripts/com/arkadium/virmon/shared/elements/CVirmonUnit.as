package com.arkadium.virmon.shared.elements
{
   import com.arkadium.virmon.shared.utils.CLoader;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public class CVirmonUnit extends MovieClip
   {
      
      public var _stfSpeed:TextField;
      
      public var _stfStrength:TextField;
      
      private var _cVirmon:IVirmon;
      
      private var _virmonLoader:CLoader;
      
      public var _stfName:TextField;
      
      public var _stfHealth:TextField;
      
      public var _sbtUnit:SimpleButton;
      
      public var _stfPV:TextField;
      
      public var _stfNick:TextField;
      
      public var _stfArmor:TextField;
      
      private var _id:String;
      
      public function CVirmonUnit()
      {
         super();
         addFrameScript(0,frame1);
         this._stfName.text = this._stfNick.text = this._stfHealth.text = this._stfStrength.text = this._stfSpeed.text = this._stfArmor.text = this._stfPV.text = "";
      }
      
      public function getVirmon() : IVirmon
      {
         return _cVirmon;
      }
      
      private function loadVirmonImage() : void
      {
         if(_virmonLoader != null && _virmonLoader.content != null)
         {
            _virmonLoader.unload();
         }
         _virmonLoader = CLoader.loadFile("tempImages/virmon.png");
         _virmonLoader.x = 240;
         _virmonLoader.y = 30;
         _virmonLoader.scaleX = _virmonLoader.scaleY = 0.5;
         if(!this.contains(_virmonLoader))
         {
            this.addChild(_virmonLoader);
         }
      }
      
      public function getId() : String
      {
         return _id;
      }
      
      private function initTextField() : void
      {
         this._stfName.text = String(_cVirmon.getName()).toUpperCase();
         this._stfNick.text = String(_cVirmon.getNickName()).toUpperCase();
         this._stfHealth.text = _cVirmon.getCurrentHealth().toString() + "/" + _cVirmon.getHealth().toString();
         this._stfStrength.text = _cVirmon.getStrength().toString();
         this._stfSpeed.text = _cVirmon.getSpeed().toString();
         this._stfArmor.text = _cVirmon.getArmor().toString();
         this._stfPV.text = _cVirmon.getPV().toString() + " SV";
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      public function setData(param1:IVirmon) : void
      {
         trace("::setData::");
         _cVirmon = param1;
         _id = _cVirmon.getID();
         initTextField();
         loadVirmonImage();
      }
   }
}

