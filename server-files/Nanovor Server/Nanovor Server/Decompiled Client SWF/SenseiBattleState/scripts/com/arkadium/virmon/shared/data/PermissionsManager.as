package com.arkadium.virmon.shared.data
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class PermissionsManager implements IPermissionsManager, IChainLoadee
   {
      
      private static var _instance:PermissionsManager;
      
      private var _canSell:Boolean = false;
      
      private var _canChat:Boolean = false;
      
      private var _canTrade:Boolean = false;
      
      private var _chainLoader:IChainLoader;
      
      private var _canBuy:Boolean = false;
      
      private var _userProfile:IUserProfile;
      
      public function PermissionsManager(param1:Function = null)
      {
         super();
         if(param1 != PermissionsManager.getInstance)
         {
            throw new Error("PermissionsManager singleton exception: cannot instantiate outside of this class");
         }
         if(null != PermissionsManager._instance)
         {
            throw new Error("Only one PermissionsManager instance should be instantiated");
         }
      }
      
      public static function getInstance() : PermissionsManager
      {
         if(null == _instance)
         {
            _instance = new PermissionsManager(arguments.callee);
         }
         return PermissionsManager._instance;
      }
      
      public function get canChat() : Boolean
      {
         return _canChat;
      }
      
      public function setUserProfile(param1:IUserProfile) : void
      {
         _userProfile = param1;
      }
      
      public function load() : void
      {
         var _loc1_:XML = _userProfile.accountInfoXML;
         _canChat = _loc1_.child("can-chat")[0] == "false" ? false : true;
         _canTrade = _loc1_.child("can-trade")[0] == "false" ? false : true;
         _canBuy = _loc1_.child("can-buy")[0] == "false" ? false : true;
         _canSell = _loc1_.child("can-sell")[0] == "false" ? false : true;
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function get canTrade() : Boolean
      {
         return _canTrade;
      }
      
      public function get name() : String
      {
         return "PermissionsManager";
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<PermissionsManager>>\t" + param1);
      }
   }
}

