package com.arkadium.virmon.shared.widgets.header
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Click;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.handlers.user.IAvatarUpdatedHandler;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.framework.asset.retriever.IAvatarAssetRetriever;
   import com.arkadium.virmon.home.IHomeBreadcrumbUIManager;
   import com.arkadium.virmon.shared.breadcrumb.BreadcrumbType;
   import com.arkadium.virmon.shared.breadcrumb.IBreadcrumbProgressManager;
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.widgets.AbstractWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.wrapper.statepackagestatusupdater.IStatePackageStatusUpdater;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class HeaderWidget extends AbstractWidget implements IHeaderButtonClickHandler, IAvatarUpdatedHandler, IHeaderWidget
   {
      
      private static const GENERAL_TWEEN_SECONDS:Number = 1;
      
      private static const YELLOW_BAR_TWEEN_SECONDS:Number = 1.5;
      
      private static const YELLOW_BAR_END_X:Number = 220;
      
      private static const ALERT_BUBBLE_OFFSET:Point = new Point(0,-6);
      
      private static const ALERT_DROP_SHADOW:DropShadowFilter = new DropShadowFilter(2,90,0,0.5,6,6);
      
      private static const LOGO_HOVER:DropShadowFilter = new DropShadowFilter(4,115,16303403,0.5,6,6);
      
      private static const LOGO_DROP_SHADOW:DropShadowFilter = new DropShadowFilter(4,115,0,0.5,6,6);
      
      public var mcMainButtonContainer:MovieClip;
      
      public var tfStatus:TextField;
      
      private var _headerAvatarRenderer:IHeaderAvatarRenderer;
      
      public var mcYellowBar:MovieClip;
      
      public var mcBacker:MovieClip;
      
      private var _battleGameService:IBattleGameService;
      
      private var _leaveBattleButtonHandler:IHeaderWidgetLeaveBattleHandler;
      
      public var mcEnemyAvatarsContainer:MovieClip;
      
      public var mcDeviceOverlay:MovieClip;
      
      public var mcNanoscope:Sprite;
      
      private var _homeBreadcrumbUIManager:IHomeBreadcrumbUIManager;
      
      public var btnQuitBattle:SimpleButton;
      
      private var _lastMainButtonClicked:MainButton = null;
      
      public var mcLogo:MovieClip;
      
      public var mcWantMoreClickHere:MovieClip;
      
      public var btnSettings:SimpleButton;
      
      private var _analyticsManager:IAnalyticsManager;
      
      public var mcYellowBarChaser:MovieClip;
      
      private var _userProfile:IUserProfile;
      
      public var tfSplattered:TextField;
      
      private var _stateManager:IStateManager;
      
      private var _breadcrumbProgressManager:IBreadcrumbProgressManager;
      
      public var btnQuit:SimpleButton;
      
      public var mcQuickTips:MovieClip;
      
      public var mcBubbleContainer:MovieClip;
      
      private var _headerButtonRenderer:IHeaderButtonRenderer;
      
      public function HeaderWidget()
      {
         super(WidgetType.WIDGET_HEADER);
         this.cacheAsBitmap = true;
      }
      
      private function set showQuitGame(param1:Boolean) : void
      {
         if(param1)
         {
            btnQuit.mouseEnabled = true;
            Tweener.addTween(btnQuit,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
         }
         else
         {
            btnQuit.mouseEnabled = false;
            Tweener.addTween(btnQuit,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
         }
      }
      
      public function removeAvatar(param1:IAvatar) : void
      {
         _headerAvatarRenderer.removeEnemyAvatar(param1);
      }
      
      public function setDeviceMode() : void
      {
         setMode(WidgetType.MODE_HOME);
         minQuickTips = false;
         hideLeaveBattle();
         showButtons = false;
         showAlertBubbles = false;
         showQuitGame = false;
         showLogo = false;
         mcNanoscope.visible = true;
         _headerAvatarRenderer.removeEnemyAvatars();
         disableMenu(true);
         if(this.y != 0)
         {
            Tweener.addTween(this,{
               "y":0,
               "time":1,
               "transition":"easeOutQuad"
            });
         }
         this.addChild(mcDeviceOverlay);
         Tweener.addTween(mcDeviceOverlay,{
            "_autoAlpha":1,
            "time":1,
            "transition":"easeOutQuad"
         });
         this.setChildIndex(mcQuickTips,this.numChildren - 1);
         this.setChildIndex(mcLogo,this.numChildren - 1);
         this.setChildIndex(mcNanoscope,this.numChildren - 1);
      }
      
      public function showLeaveBattle(param1:IHeaderWidgetLeaveBattleHandler) : void
      {
         log("showLeaveBattle()");
         _leaveBattleButtonHandler = param1;
         btnQuitBattle.mouseEnabled = true;
         btnQuitBattle.visible = true;
      }
      
      override public function setMode(param1:String) : void
      {
         log("setting header widget mode: " + param1);
         switch(param1)
         {
            case WidgetType.MODE_BATTLE:
               _headerAvatarRenderer.setAvatarMode(Const.AVATAR_MODE_BATTLE);
               _headerAvatarRenderer.setAvatarStatus(Const.AVATAR_STATUS_BATTLE);
               hideLeaveBattle();
               showButtons = false;
               showAlertBubbles = false;
               showQuitGame = true;
               mcLogo.mouseEnabled = false;
               if(this.y != 0)
               {
                  Tweener.addTween(this,{
                     "y":0,
                     "time":1,
                     "transition":"easeOutQuad"
                  });
               }
               break;
            case WidgetType.MODE_HOME:
               _headerAvatarRenderer.removeEnemyAvatars();
               _headerAvatarRenderer.setAvatarMode(Const.AVATAR_MODE_DASHBOARD);
               _headerAvatarRenderer.setAvatarStatus(Const.AVATAR_STATUS_OUT_OF_BATTLE);
               minQuickTips = false;
               hideLeaveBattle();
               showButtons = true;
               showAlertBubbles = true;
               showQuitGame = true;
               mcLogo.mouseEnabled = true;
               if(this.y != 0)
               {
                  Tweener.addTween(this,{
                     "y":0,
                     "time":1,
                     "transition":"easeOutQuad"
                  });
               }
               break;
            case WidgetType.MODE_HIDDEN:
               _headerAvatarRenderer.removeEnemyAvatars();
               showQuitGame = true;
               if(this.y > -10)
               {
                  Tweener.addTween(this,{
                     "y":-200,
                     "time":0.5,
                     "transition":"easeOutQuad"
                  });
               }
               break;
            case WidgetType.MODE_MINIMIZED:
               showQuitGame = true;
               if(this.y < 300)
               {
                  Tweener.addTween(this,{
                     "y":688,
                     "time":1,
                     "transition":"easeOutQuad"
                  });
               }
         }
         mcNanoscope.visible = false;
         this.addChild(mcDeviceOverlay);
         Tweener.addTween(mcDeviceOverlay,{
            "_autoAlpha":0,
            "time":1,
            "transition":"easeOutQuad",
            "onComplete":removeDeviceOverlay
         });
         if(param1 != WidgetType.MODE_HIDDEN && this.y < 0)
         {
            Tweener.addTween(this,{
               "y":0,
               "time":0.5,
               "transition":"easeOutQuad"
            });
         }
      }
      
      public function set minQuickTips(param1:Boolean) : void
      {
         var value:Boolean = param1;
         if(value)
         {
            Tweener.addTween(mcLogo,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcQuickTips,{
               "x":980,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcQuickTips.mcStrip,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS,
               "onComplete":function():*
               {
                  mcQuickTips.mcStrip.visible = false;
               }
            });
         }
         else
         {
            mcQuickTips.mcStrip.visible = true;
            Tweener.addTween(mcLogo,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcQuickTips,{
               "x":836,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcQuickTips.mcStrip,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
         }
      }
      
      public function set playerName(param1:String) : void
      {
         _headerAvatarRenderer.setPlayerName(param1);
      }
      
      override public function init(param1:Object = null) : void
      {
         var _loc2_:IUserGameService = IUserGameService(param1.userGameService);
         _battleGameService = IBattleGameService(param1.battleGameService);
         _userProfile = IUserProfile(param1.userProfile);
         _stateManager = IStateManager(param1.stateManager);
         _analyticsManager = IAnalyticsManager(param1.analyticsManager);
         _homeBreadcrumbUIManager = IHomeBreadcrumbUIManager(param1.homeBreadcrumbUIManager);
         _breadcrumbProgressManager = IBreadcrumbProgressManager(param1.breadcrumbProgressManager);
         mcDeviceOverlay.mouseEnabled = false;
         mcDeviceOverlay.mouseChildren = false;
         mcDeviceOverlay.alpha = 0;
         removeDeviceOverlay();
         _headerButtonRenderer = new HeaderButtonRenderer(IStatePackageStatusUpdater(param1.statePackageUpdater),mcMainButtonContainer,mcYellowBarChaser,mcWantMoreClickHere);
         _headerButtonRenderer.addHeaderButtonClickHandler(IHeaderButtonClickHandler(this));
         _headerButtonRenderer.createMainButtons();
         _headerAvatarRenderer = new HeaderAvatarRenderer(IAvatarAssetRetriever(param1.avatarAssetRetriever),mcEnemyAvatarsContainer);
         _headerAvatarRenderer.createAvatar(_userProfile.id,_userProfile.avatarId,mcMainButtonContainer.y,this);
         mcLogo.filters = [LOGO_DROP_SHADOW];
         mcQuickTips.buttonMode = true;
         yellowBarRollout();
         mcNanoscope.visible = false;
         _userProfile.addEventListener("loadComplete",handleUserProfileLoadComplete);
         refreshPlayerData();
         playerStatus = "";
         mcQuickTips.addEventListener(MouseEvent.CLICK,_stateManager.handleQuickTips);
         btnSettings.addEventListener(MouseEvent.CLICK,_stateManager.handleSettings);
         btnQuit.addEventListener(MouseEvent.CLICK,_stateManager.handleQuit);
         btnQuitBattle.addEventListener(MouseEvent.CLICK,handleLeaveBattleClick);
         hideLeaveBattle();
         log(widgetName + " initialized");
         _loc2_.addAvatarUpdatedHandler(IAvatarUpdatedHandler(this));
         EventManager.getInstance().addEventListener("NANOCASH_BALANCE_UPDATED",updateNanocashBalance,false,0,true);
         mcLogo.addEventListener(MouseEvent.CLICK,handleNanovorLogoClick,false,0,true);
         mcLogo.addEventListener(MouseEvent.MOUSE_OVER,handleNanovorLogoRollOver,false,0,true);
         mcLogo.addEventListener(MouseEvent.MOUSE_OUT,handleNanovorLogoRollOut,false,0,true);
         mcLogo.buttonMode = true;
         _stateManager.setQuickTipsButton();
      }
      
      public function disableDeviceButton() : void
      {
         log("disableDeviceButton()");
         _headerButtonRenderer.disableDeviceButton();
      }
      
      public function set splattered(param1:int) : void
      {
         tfSplattered.text = param1.toString() + " NANOVOR Splattered";
      }
      
      public function disableButton(param1:StateType, param2:Boolean) : void
      {
         _headerButtonRenderer.disableButton(param1,param2);
      }
      
      public function get myAvatar() : IAvatar
      {
         return _headerAvatarRenderer.myAvatar;
      }
      
      public function resetNumberOfPlayers(param1:int) : void
      {
         log("resetNumberOfPlayers: " + param1);
         _headerAvatarRenderer.resetNumberOfPlayers(param1);
      }
      
      public function enableDeviceButton() : void
      {
         log("enableDeviceButton(): mcMainButtonContainer._autoAlpha: " + mcMainButtonContainer.alpha);
         _headerButtonRenderer.enableDeviceButton();
      }
      
      public function disableQuickTipsButton() : void
      {
         log("disableQuickTipsButton");
         mcQuickTips.visible = false;
      }
      
      public function enableQuickTipsButton() : void
      {
         log("enableQuickTipsButton");
         mcQuickTips.visible = true;
      }
      
      private function set showAlertBubbles(param1:Boolean) : void
      {
         if(param1)
         {
            mcBubbleContainer.mouseEnabled = true;
            mcBubbleContainer.mouseChildren = true;
            Tweener.addTween(mcBubbleContainer,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
         }
         else
         {
            mcBubbleContainer.mouseEnabled = false;
            mcBubbleContainer.mouseChildren = false;
            Tweener.addTween(mcBubbleContainer,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
         }
      }
      
      public function set playerStatus(param1:String) : void
      {
         tfStatus.text = "";
      }
      
      public function disableMenu(param1:Boolean) : void
      {
         mcMainButtonContainer.mouseChildren = !param1;
      }
      
      public function setStateButton(param1:StateType) : void
      {
         _headerButtonRenderer.setStateButton(param1);
      }
      
      private function refreshPlayerData() : void
      {
         playerName = _userProfile.screenname;
         playerNMP = _userProfile.nmp;
         playerNanocash = _userProfile.nanocash;
         splattered = _userProfile.totalKills;
      }
      
      public function handleHeaderButtonClick(param1:MainButton) : void
      {
         if(StateType.NANOLOG == param1.stateType)
         {
            EventManager.getInstance().dispatchEvent(new FrameWorkEvent(FrameWorkEvent.MDM_OPEN_BROWSER_HOOK,false,false,"nanolog"));
            _analyticsManager.trackClick(Click.NANOLOG);
            if(_homeBreadcrumbUIManager != null && _homeBreadcrumbUIManager.currentBreadcrumbType == BreadcrumbType.NANOLOG)
            {
               _breadcrumbProgressManager.setBreadcrumbAsComplete(BreadcrumbType.NANOLOG);
            }
            return;
         }
         _lastMainButtonClicked = param1;
         _stateManager.setState(param1.stateType,null,true);
         _battleGameService.cancelMatchMaking();
      }
      
      private function handleUserProfileLoadComplete(param1:Event) : void
      {
         refreshPlayerData();
      }
      
      private function set showButtons(param1:Boolean) : void
      {
         log("set showButtons(): value: " + param1);
         if(param1)
         {
            _headerButtonRenderer.showButtons(GENERAL_TWEEN_SECONDS);
         }
         else
         {
            _headerButtonRenderer.hideButtons(GENERAL_TWEEN_SECONDS);
         }
      }
      
      public function get enemyAvatars() : Array
      {
         return _headerAvatarRenderer.enemyAvatars;
      }
      
      public function set showLogo(param1:Boolean) : void
      {
         Tweener.removeTweens(mcLogo);
         mcLogo.visible = param1;
         mcLogo.alpha = param1 ? 1 : 0;
      }
      
      public function addEnemyAvatar(param1:IAvatar) : void
      {
         _headerAvatarRenderer.addEnemyAvatar(param1);
      }
      
      private function yellowBarRollout() : void
      {
         Tweener.addTween(mcYellowBar,{
            "x":YELLOW_BAR_END_X,
            "time":YELLOW_BAR_TWEEN_SECONDS
         });
      }
      
      public function hideLeaveBattle() : void
      {
         log("hideLeaveBattle()");
         _leaveBattleButtonHandler = null;
         btnQuitBattle.mouseEnabled = false;
         btnQuitBattle.visible = false;
      }
      
      public function loadEnemyAvatarPictureById(param1:int, param2:int, param3:int) : void
      {
         log("loadEnemyAvatarPictureById(" + param1 + ", " + param2 + ", " + param3 + ")");
         _headerAvatarRenderer.loadEnemyAvatarPictureById(param1,param2,param3);
      }
      
      private function handleNanovorLogoRollOver(param1:MouseEvent) : void
      {
         mcLogo.filters = [LOGO_DROP_SHADOW];
      }
      
      private function handleNanovorLogoClick(param1:MouseEvent) : void
      {
         _stateManager.setState(StateType.HOME);
      }
      
      private function handleLeaveBattleClick(param1:MouseEvent) : void
      {
         if(null != _leaveBattleButtonHandler)
         {
            _leaveBattleButtonHandler.handleHeaderWidgetLeaveBattle();
         }
      }
      
      public function setNumberOfPlayers(param1:int) : void
      {
         log("setNumberOfPlayers: " + param1);
         _headerAvatarRenderer.setNumberOfPlayers(param1);
      }
      
      private function handleNanovorLogoRollOut(param1:MouseEvent) : void
      {
         mcLogo.filters = [LOGO_DROP_SHADOW];
      }
      
      public function getAvatarByPlayerID(param1:int) : IAvatar
      {
         return _headerAvatarRenderer.getAvatarByPlayerID(param1);
      }
      
      public function showLastButtonClickedAsCurrent() : void
      {
         _headerButtonRenderer.showLastButtonClickedAsCurrent(_lastMainButtonClicked);
      }
      
      public function set playerNMP(param1:*) : void
      {
         _headerAvatarRenderer.setPlayerNMP(int(param1));
      }
      
      public function set playerNanocash(param1:*) : void
      {
         _headerAvatarRenderer.setPlayerNanocash(int(param1));
      }
      
      private function updateNanocashBalance(param1:Event) : void
      {
         playerNanocash = _userProfile.nanocash;
      }
      
      private function removeDeviceOverlay() : void
      {
         if(null != mcDeviceOverlay && null != mcDeviceOverlay.parent)
         {
            mcDeviceOverlay.parent.removeChild(mcDeviceOverlay);
         }
      }
      
      public function handleAvatarUpdated(param1:Object = null) : void
      {
         _headerAvatarRenderer.loadAvatarPicture(int(param1.avatarId));
      }
   }
}

