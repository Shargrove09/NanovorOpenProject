package com.arkadium.virmon.shared.widgets
{
   import com.arkadium.virmon.state.StateType;
   
   public class WidgetType
   {
      
      public static const MODE_HOME:String = "modeHome";
      
      public static const MODE_BATTLE:String = "modeBattle";
      
      public static const MODE_CLOSED:String = "modeClosed";
      
      public static const MODE_HIDDEN:String = "modeHidden";
      
      public static const MODE_MINIMIZED:String = "modeMinimized";
      
      public static const WIDGET_HEADER:WidgetType = new WidgetType("HeaderWidget","HeaderWidget.swf");
      
      public static const WIDGET_CHAT:WidgetType = new WidgetType("ChatWidget","ChatWidget.swf");
      
      public static const WIDGET_MEGA_WIDGET:WidgetType = new WidgetType("MegaWidget","MegaWidget.swf");
      
      public static const WIDGET_AVATAR:WidgetType = new WidgetType("AvatarWidget","AvatarWidget.swf");
      
      public static const WIDGET_AUTO_BATTLE:WidgetType = new WidgetType("AutoBattleWidget","AutoBattleWidget.swf");
      
      private static const WIDGET_TYPES:Array = [WIDGET_CHAT,WIDGET_HEADER,WIDGET_MEGA_WIDGET,WIDGET_AVATAR,WIDGET_AUTO_BATTLE];
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _url:String;
      
      private var _name:String;
      
      public function WidgetType(param1:String, param2:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instsantiate enum type \'WidgetType\'.");
         }
         this._name = param1;
         this._url = param2;
      }
      
      public static function getWidgetsByState(param1:StateType) : Array
      {
         switch(param1)
         {
            case StateType.NEWUSER:
               return [WIDGET_HEADER];
            default:
               return WIDGET_TYPES;
         }
      }
      
      public static function getWidgetTypeByName(param1:String) : WidgetType
      {
         var _loc2_:* = undefined;
         for(_loc2_ in WIDGET_TYPES)
         {
            if(WIDGET_TYPES[_loc2_].name == param1)
            {
               return WIDGET_TYPES[_loc2_];
            }
         }
         return null;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get url() : String
      {
         return this._url;
      }
   }
}

