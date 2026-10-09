package com.arkadium.virmon.shared.components.avatar
{
   import com.arkadium.virmon.shared.components.ISwarmometer;
   
   public interface IAvatar
   {
      
      function setStatusText(param1:String, param2:uint = 16777216) : void;
      
      function set nmp(param1:int) : void;
      
      function set status(param1:String) : void;
      
      function set playerName(param1:String) : void;
      
      function set mode(param1:String) : void;
      
      function set playerID(param1:int) : void;
      
      function get playerName() : String;
      
      function set color(param1:uint) : void;
      
      function setOverride(param1:*) : void;
      
      function set energy(param1:int) : void;
      
      function get swarmometer() : ISwarmometer;
      
      function set nanocash(param1:int) : void;
      
      function set override(param1:Boolean) : void;
      
      function set glow(param1:Boolean) : void;
      
      function get playerID() : int;
      
      function loadAvatarPicture(param1:int) : void;
   }
}

