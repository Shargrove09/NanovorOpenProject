package com.arkadium.virmon.shared.utils
{
   import caurina.transitions.Tweener;
   import flash.display.*;
   import flash.events.*;
   import flash.net.LocalConnection;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class Utils
   {
      
      private static var ba:ByteArray = new ByteArray();
      
      public function Utils()
      {
         super();
      }
      
      private static function removeByChild(param1:*) : void
      {
         var pattern:RegExp = null;
         var methods:XMLList = null;
         var evtMethod:Array = null;
         var i:int = 0;
         var parameter:XMLList = null;
         var j:int = 0;
         var child:* = undefined;
         var ClassReference:Class = null;
         var names:XMLList = null;
         var k:int = 0;
         var sName:String = null;
         var fName:Function = null;
         var _parent:* = param1;
         try
         {
            pattern = /::/gi;
            methods = describeType(_parent).method;
            evtMethod = [];
            i = 0;
            while(i < methods.length())
            {
               parameter = methods[i].parameter;
               j = 0;
               while(j < parameter.length())
               {
                  evtMethod.push({
                     "type":String(parameter[j].@type).replace(pattern,"."),
                     "name":String(methods[i].@name)
                  });
                  j++;
               }
               i++;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            i = 0;
            while(i < _parent.numChildren)
            {
               child = _parent.getChildAt(i);
               j = 0;
               while(j < evtMethod.length)
               {
                  ClassReference = Class(getDefinitionByName(evtMethod[j].type));
                  names = describeType(ClassReference).constant;
                  k = 0;
                  while(k < names.length())
                  {
                     sName = String(names[k].@name).toLowerCase();
                     if(Boolean(child.hasEventListener(sName)))
                     {
                        fName = _parent[evtMethod[j].name];
                        child.removeEventListener(sName,fName);
                     }
                     k++;
                  }
                  j++;
               }
               if(!(child is Shape || child is Bitmap || child is SimpleButton || child is TextField))
               {
                  removeByChild(child);
               }
               i++;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public static function generateBitmap(param1:DisplayObject) : Bitmap
      {
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,true);
         _loc2_.draw(param1);
         return new Bitmap(_loc2_);
      }
      
      public static function traceObjectSize(param1:*) : void
      {
         var _loc2_:int = int(ba.length);
         ba.writeObject(param1);
      }
      
      public static function generateRandomString(param1:int = 32) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_ += String.fromCharCode(97 + Math.round(Math.random() * 25));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function ObjectToString(param1:*, param2:int = 1, param3:int = 4) : String
      {
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc4_:String = typeof param1;
         var _loc5_:String = "";
         var _loc6_:int = 0;
         while(_loc6_ < param2)
         {
            _loc5_ += ".";
            _loc9_ = 0;
            while(_loc9_ < param3)
            {
               _loc5_ += " ";
               _loc9_++;
            }
            _loc6_++;
         }
         var _loc7_:String = "[" + (_loc4_ == "object" ? "object|array" : _loc4_) + "] ";
         if(_loc4_ == "string" || _loc4_ == "number" || _loc4_ == "boolean")
         {
            return _loc7_ + String(param1);
         }
         if(_loc4_ == "function")
         {
            return _loc7_;
         }
         if(_loc4_ == "xml")
         {
            return _loc7_ + XML(param1).toXMLString();
         }
         if(_loc4_ != "object")
         {
            return _loc7_ + "?? unknown ??";
         }
         for(_loc8_ in param1)
         {
            _loc7_ += "\n" + _loc5_ + _loc8_ + " : " + ObjectToString(param1[_loc8_],param2 + 1);
         }
         return _loc7_;
      }
      
      public static function cutText(param1:TextField) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(param1.textWidth > param1.width - 10)
         {
            param1.appendText("...");
            _loc2_ = param1.textWidth;
            _loc3_ = _loc2_;
            while(_loc3_ >= param1.width)
            {
               if(param1.textWidth <= param1.width - 10)
               {
                  break;
               }
               param1.text = param1.text.substring(param1.text.length - 4,0) + "...";
               _loc3_--;
            }
         }
      }
      
      public static function removeAllListener(param1:*) : void
      {
         removeByChild(param1);
      }
      
      public static function ChildrenToString(param1:*, param2:int = 1, param3:int = 4, param4:int = 1000) : String
      {
         var _loc10_:int = 0;
         var _loc5_:String = getQualifiedClassName(param1);
         var _loc6_:String = "";
         var _loc7_:int = 0;
         while(_loc7_ < param2)
         {
            _loc6_ += ".";
            _loc10_ = 0;
            while(_loc10_ < param3)
            {
               _loc6_ += " ";
               _loc10_++;
            }
            _loc7_++;
         }
         var _loc8_:String = "[" + _loc5_ + "] ";
         if(Boolean(param1 as DisplayObject))
         {
            _loc8_ += "{vis=" + param1.visible + " | " + param1.x + "," + param1.y + "} - " + param1.name + " ";
         }
         if(!(param1 as DisplayObjectContainer))
         {
            return _loc8_;
         }
         _loc8_ += "(" + param1.numChildren + ") ";
         if(param2 >= param4)
         {
            return _loc8_;
         }
         _loc8_ += "{";
         var _loc9_:int = 0;
         while(_loc9_ < param1.numChildren)
         {
            _loc8_ += "\n" + _loc6_ + _loc9_ + " : " + ChildrenToString(param1.getChildAt(_loc9_),param2 + 1,param3,param4);
            _loc9_++;
         }
         return _loc8_ + "\n" + _loc6_ + "}";
      }
      
      public static function clearAllChildren(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         if(Boolean(param1 as Bitmap))
         {
            if(param1.bitmapData != null)
            {
               param1.bitmapData.dispose();
               param1 = null;
            }
         }
         if(Boolean(param1 as Shape))
         {
            if(param1.graphics != null)
            {
               param1.graphics.clear();
               param1 = null;
            }
         }
         if(Boolean(param1 as TextField))
         {
            param1 = null;
         }
         if(Boolean(param1 as SimpleButton))
         {
            param1 = null;
         }
         if(Boolean(param1 as DisplayObjectContainer))
         {
            _loc3_ = int(param1.numChildren);
            while(Boolean(_loc3_--))
            {
               _loc2_ = param1.getChildAt(_loc3_);
               if(_loc2_ is MovieClip)
               {
                  _loc2_.stop();
               }
               clearAllChildren(_loc2_);
               if(Boolean(param1 as Loader))
               {
                  clearAllChildren(Loader(param1).content);
                  param1.unload();
               }
               else if(_loc2_ !== null)
               {
                  if(Boolean(param1 as ArkMc))
                  {
                     param1.removeMe();
                  }
                  param1.removeChild(_loc2_);
               }
            }
            param1 = null;
         }
      }
      
      public static function copyObject(param1:*) : *
      {
         return new param1.constructor();
      }
      
      public static function zeroPreFill(param1:*, param2:int) : String
      {
         var _loc3_:int = 0;
         if(param1 is int)
         {
            _loc3_ = param1;
         }
         else if(param1 is String)
         {
            _loc3_ = parseInt(param1);
         }
         else
         {
            _loc3_ = 0;
         }
         var _loc4_:String = _loc3_.toString();
         while(_loc4_.length < param2)
         {
            _loc4_ = "0" + _loc4_;
         }
         return _loc4_;
      }
      
      public static function RemoveChildrenTweens(param1:DisplayObjectContainer) : int
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc4_);
            if(Boolean(_loc3_ as DisplayObjectContainer))
            {
               _loc2_ += RemoveChildrenTweens(_loc3_);
            }
            if(Boolean(_loc3_ as DisplayObject))
            {
               if(Tweener.removeTweens(_loc3_))
               {
                  _loc2_++;
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function gc() : void
      {
         try
         {
            new LocalConnection().connect("atthecopa");
            new LocalConnection().connect("atthecopa");
         }
         catch(e:*)
         {
         }
      }
      
      public static function stopAllChildren(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         if(Boolean(param1 as DisplayObjectContainer))
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numChildren)
            {
               _loc2_ = param1.getChildAt(_loc3_);
               if(Boolean(_loc2_ as ArkMc))
               {
                  _loc2_.stopAnimation();
               }
               else if(Boolean(_loc2_ as MovieClip))
               {
                  _loc2_.stop();
               }
               stopAllChildren(_loc2_);
               _loc3_++;
            }
         }
      }
   }
}

