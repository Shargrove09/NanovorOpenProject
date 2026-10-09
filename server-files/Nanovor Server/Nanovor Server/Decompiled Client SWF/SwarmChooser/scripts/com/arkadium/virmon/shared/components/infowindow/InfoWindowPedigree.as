package com.arkadium.virmon.shared.components.infowindow
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPedigreeBadge;
   import com.arkadium.virmon.shared.data.IPedigreeData;
   import com.arkadium.virmon.shared.data.Pedigree;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.filters.DropShadowFilter;
   
   public class InfoWindowPedigree extends MovieClip
   {
      
      private static const HEADER_TEXT:String = "EVOLUTIONS";
      
      private static const DISPLAY_WIDTH:int = 180;
      
      private static const BULLET_RADIUS:int = 4;
      
      private static const BULLET_COLOR_RED:uint = 16711680;
      
      private static const BULLET_COLOR_GREEN:uint = 65280;
      
      private static const DROPSHADOW_FILTER:DropShadowFilter = new DropShadowFilter(4,135,0,0.6,4,6);
      
      private var headerText:HeaderText;
      
      private var nanovor:INanovor;
      
      public function InfoWindowPedigree()
      {
         super();
      }
      
      public function init(param1:INanovor, param2:INanovorFactory, param3:IEvoManager, param4:IBadgeManager, param5:IEMManager, param6:IUserProfile) : void
      {
         nanovor = param1;
         createHeader();
         buildPedigreeText(param2,param3,param4,param5,param6);
      }
      
      private function buildPedigreeText(param1:INanovorFactory, param2:IEvoManager, param3:IBadgeManager, param4:IEMManager, param5:IUserProfile) : void
      {
         var _loc10_:IPedigreeData = null;
         var _loc11_:EvoText = null;
         var _loc12_:PreReqText = null;
         var _loc13_:IPedigreeBadge = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:PreReqBullet = null;
         var _loc17_:EvoText = null;
         var _loc6_:Pedigree = new Pedigree(param1,param2,param3,param4,param5,nanovor.assetId);
         var _loc7_:Array = _loc6_.getPedigree();
         var _loc8_:int = 5;
         var _loc9_:int = Math.round(headerText.y + headerText.textHeight + 10);
         DebugLog.instance.log("pedigreeDataArray.length: " + _loc7_.length);
         if(_loc7_.length > 0)
         {
            for each(_loc10_ in _loc7_)
            {
               _loc11_ = new EvoText("To " + _loc10_.destName);
               addChild(_loc11_);
               _loc11_.x = _loc8_;
               _loc11_.y = _loc9_;
               _loc11_.filters = [DROPSHADOW_FILTER];
               _loc9_ += _loc11_.textHeight + 2;
               if(_loc10_.badges.length > 0)
               {
                  for each(_loc13_ in _loc10_.badges)
                  {
                     _loc14_ = int(_loc13_.progress);
                     _loc15_ = int(_loc13_.goal);
                     if(_loc14_ < _loc15_)
                     {
                        _loc16_ = new PreReqBullet(BULLET_RADIUS,BULLET_COLOR_RED);
                     }
                     else
                     {
                        _loc14_ = _loc15_;
                        _loc16_ = new PreReqBullet(BULLET_RADIUS,BULLET_COLOR_GREEN);
                     }
                     addChild(_loc16_);
                     _loc16_.x = _loc8_ + _loc16_.width;
                     _loc16_.y = _loc9_ + _loc16_.height;
                     _loc16_.filters = [DROPSHADOW_FILTER];
                     if(_loc14_ >= 0)
                     {
                        _loc12_ = new PreReqText(_loc13_.prereqDesc + "  (" + _loc14_ + "/" + _loc15_ + ")");
                     }
                     else
                     {
                        _loc12_ = new PreReqText(_loc13_.prereqDesc);
                     }
                     addChild(_loc12_);
                     _loc12_.x = _loc8_ + _loc16_.width + 5;
                     _loc12_.y = _loc9_;
                     _loc12_.width = DISPLAY_WIDTH - (_loc12_.x + 5);
                     _loc12_.filters = [DROPSHADOW_FILTER];
                     _loc9_ += _loc12_.textHeight + 2;
                  }
                  _loc9_ += 6;
               }
               else
               {
                  _loc12_ = new PreReqText("No Requirements Needed");
                  addChild(_loc12_);
                  _loc12_.x = _loc8_;
                  _loc12_.y = _loc9_;
                  _loc9_ += _loc12_.textHeight + 8;
                  _loc12_.width = DISPLAY_WIDTH - (_loc12_.x + 5);
                  _loc12_.filters = [DROPSHADOW_FILTER];
               }
            }
         }
         else
         {
            _loc17_ = new EvoText("No Evolution At This Time");
            addChild(_loc17_);
            _loc17_.x = (DISPLAY_WIDTH - _loc17_.textWidth) / 2;
            _loc17_.y = _loc9_;
            _loc17_.filters = [DROPSHADOW_FILTER];
         }
      }
      
      private function createHeader() : void
      {
         headerText = new HeaderText(HEADER_TEXT);
         addChild(headerText);
         headerText.x = (DISPLAY_WIDTH - headerText.textWidth) / 2;
         headerText.y = 0;
         headerText.filters = [DROPSHADOW_FILTER];
      }
   }
}

