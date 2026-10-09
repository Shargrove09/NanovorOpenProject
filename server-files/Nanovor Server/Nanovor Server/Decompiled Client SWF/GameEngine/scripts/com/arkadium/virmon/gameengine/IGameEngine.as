package com.arkadium.virmon.gameengine
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.WebClientManager;
   import com.arkadium.virmon.home.IHomeBreadcrumbUIManager;
   import com.arkadium.virmon.musicmanager.IMusicManager;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.ui.ISprite;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.arkadium.virmon.wrapper.statepackagestatusupdater.IStatePackageStatusUpdater;
   import flash.events.IEventDispatcher;
   
   public interface IGameEngine extends ISprite
   {
      
      function init(param1:IDownloader, param2:IEventDispatcher, param3:IUserProfile, param4:IMusicManager, param5:IMDMManager, param6:IServiceRequestBrokerManager, param7:WebClientManager, param8:IHomeBreadcrumbUIManager, param9:IApplicationExiter, param10:IStatePackageStatusUpdater, param11:IGameEngineInitializedHandler) : void;
   }
}

