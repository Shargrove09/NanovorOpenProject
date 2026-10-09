package com.arkadium.virmon.newuserexperience.substates.introvideo
{
   import com.arkadium.virmon.newuserexperience.substates.NewUserSubStates;
   import com.arkadium.virmon.newuserexperience.substates.introvideo.video.INewUserIntroVideo;
   import com.arkadium.virmon.newuserexperience.substates.introvideo.video.INewUserIntroVideoConsumer;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class NewUserSubStateIntro extends AbstractSubState implements IChainLoaderConsumer, INewUserIntroVideoConsumer
   {
      
      private static const INTRO_VIDEO_PATH:String = "NewUserIntroVideo.swf";
      
      private var _widgetManager:IWidgetManager;
      
      private var _introVideo:INewUserIntroVideo;
      
      private var _chainLoader:ChainLoader;
      
      private var _uiContainer:Sprite;
      
      public function NewUserSubStateIntro(param1:Sprite, param2:IWidgetManager)
      {
         super();
         _uiContainer = param1;
         _widgetManager = param2;
         log("NewUserSubStateIntro()");
      }
      
      override public function setSubState() : void
      {
         _widgetManager.removeWidget(WidgetType.WIDGET_HEADER);
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new SWFLoadee(INTRO_VIDEO_PATH,_loc1_));
         _chainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<NewUserSubStateIntro>>\t" + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         _introVideo = param1.getLoadedAsset(SWFLoadee.NAME + INTRO_VIDEO_PATH) as INewUserIntroVideo;
         log("handleChainLoaderComplete() - IntroVideo null? " + Boolean(null == param1.getLoadedAsset(SWFLoadee.NAME + INTRO_VIDEO_PATH)));
         _chainLoader.destroy();
         _chainLoader = null;
         if(null == _introVideo)
         {
            log("handleChainLoaderComplete() - Failed to load video");
            handleIntroVideoComplete();
            return;
         }
         _uiContainer.addChild(_introVideo.sprite);
         _introVideo.init(INewUserIntroVideoConsumer(this));
      }
      
      public function handleIntroVideoComplete() : void
      {
         var _loc1_:Sprite = null;
         if(null != _introVideo)
         {
            _loc1_ = _introVideo.sprite;
            if(null != _loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            _introVideo = null;
         }
         _widgetManager.addWidget(WidgetType.WIDGET_HEADER);
         _subStateController.changeSubState(NewUserSubStates.NEWUSER_SUBSTATE_BATTLE);
      }
   }
}

