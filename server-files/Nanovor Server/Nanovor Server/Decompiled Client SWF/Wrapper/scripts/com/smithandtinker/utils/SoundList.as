package com.smithandtinker.utils
{
   import com.arkadium.virmon.soundmanager.SoundClip;
   
   public class SoundList
   {
      
      private var _aCollection:Array;
      
      private var _iTotalItems:int;
      
      public function SoundList(param1:int)
      {
         super();
         _aCollection = new Array();
         _iTotalItems = param1;
      }
      
      public function get size() : int
      {
         return _iTotalItems;
      }
      
      public function set size(param1:int) : void
      {
         _iTotalItems = param1;
      }
      
      public function getNextSound() : SoundClip
      {
         if(_aCollection.length == 0)
         {
            return null;
         }
         return _aCollection.shift();
      }
      
      public function totalSounds() : int
      {
         return _aCollection.length;
      }
      
      public function getSoundByName(param1:String) : SoundClip
      {
         var _loc2_:int = 0;
         while(_loc2_ < _aCollection.length)
         {
            trace("Sound name: " + _aCollection[_loc2_].getSoundName());
            if(_aCollection[_loc2_].getSoundName() == param1)
            {
               return _aCollection[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeSound(param1:SoundClip) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < _aCollection.length)
         {
            if(_aCollection[_loc2_] == param1)
            {
               trace("removing sound");
               _aCollection.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function getCurrentSound() : SoundClip
      {
         return _aCollection[0];
      }
      
      public function resetList(param1:int = 0) : void
      {
         _aCollection = new Array();
         _iTotalItems = param1;
      }
      
      public function getSound(param1:int) : SoundClip
      {
         return _aCollection[param1];
      }
      
      public function getSoundIndexByName(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < _aCollection.length)
         {
            if(_aCollection[_loc2_].getSoundName() == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function addSoundClip(param1:SoundClip) : void
      {
         if(_aCollection.length >= _iTotalItems)
         {
            _aCollection.shift();
         }
         _aCollection.push(param1);
         trace("Sound name: " + param1.getSoundName());
      }
   }
}

