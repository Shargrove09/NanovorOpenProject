package com.arkadium.virmon.shared.elements.viewer
{
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.asset.enum.CharacterWidgetAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.ArkMc;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.*;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   
   public class CVirmonViewer extends ArkMc
   {
      
      private static const DRAWER_OPEN_FRAMELABEL:String = "open";
      
      private static const DRAWER_OPENED_FRAMELABEL:String = "opened";
      
      private static const DRAWER_CLOSE_FRAMELABEL:String = "close";
      
      private static const DRAWER_CLOSED_FRAMELABEL:String = "end";
      
      public static const ATTACKS:String = TopTabsPane.ATTACKS;
      
      public static const PEDIGREE:String = TopTabsPane.PEDIGREE;
      
      public static const DRAWER_OPEN_COMPLETE:String = "drawerOpenComplete";
      
      public static const DRAWER_CLOSE_COMPLETE:String = "drawerCloseComplete";
      
      public static const ATTACKS_DRAWER_OPEN_COMPLETE:String = "attacksDrawerOpenComplete";
      
      public static const ATTACKS_DRAWER_CLOSE_COMPLETE:String = "attacksDrawerCloseComplete";
      
      public static const PEDIGREE_DRAWER_OPEN_COMPLETE:String = "pedigreeDrawerOpenComplete";
      
      public static const PEDIGREE_DRAWER_CLOSE_COMPLETE:String = "pedigreeDrawerCloseComplete";
      
      public var _sspVirmonInfo:MovieClip;
      
      public var _mcForHitWithEm:MovieClip;
      
      public var _mcMainTV:MovieClip;
      
      private var _cVirmon:IVirmon;
      
      public var _sspCont:Sprite;
      
      private const HACK_NUMBER:uint = 5;
      
      private var _cVirmonOwner:MovieClip;
      
      private var _nBeginX:Number = x;
      
      private var _nDuration:Number;
      
      private var delta:Number = 1.5;
      
      private var _szDrawerState:String = null;
      
      private var _bShowCloseAttack:Boolean;
      
      public var _smcAttacks:MovieClip;
      
      public var TopTabsClip:TopTabsPane;
      
      public var BadgesClip:BadgesPane;
      
      private const SHOW_HACK_INFO:uint = 176;
      
      private var _bOpen:Boolean = false;
      
      private const HIDE_HACK_INFO:int = 123;
      
      public var _sbtClose:SimpleButton;
      
      private var _bClose:Boolean = true;
      
      public var _smcHolder:Sprite;
      
      private var _szOpenAfterClosed:String = null;
      
      private const DELAY:Number = 0.2;
      
      private var _bmBadgePicture:Bitmap;
      
      public var _smcHolderVertical:Sprite;
      
      private var _virmonData:IVirmonData;
      
      private var _arTween:Array;
      
      public function CVirmonViewer()
      {
         super();
         stop();
         _smcHolderVertical.mouseEnabled = false;
         _smcHolderVertical.visible = false;
         _sspVirmonInfo.mouseEnabled = false;
         TopTabsClip.addEventListener(TopTabsPane.EVENT_TAB_CHANGED,onTraySelected,false,0,true);
         _arTween = [];
         _nDuration = 0.25;
         _bShowCloseAttack = true;
         if(_bShowCloseAttack)
         {
         }
         _sbtClose.addEventListener(MouseEvent.CLICK,clickOnClose,false,0,true);
         hideCloseBtn();
         init();
      }
      
      public function get DrawerState() : String
      {
         return _szDrawerState;
      }
      
      public function OpenDrawer() : void
      {
         log("OpenDrawer");
         removeEventListener(Event.ENTER_FRAME,closeDrawerFrameHandler);
         switch(_szDrawerState)
         {
            case ATTACKS:
               _smcAttacks.visible = true;
               addEventListener(Event.ENTER_FRAME,openDrawerFrameHandler);
               gotoAndPlayAnimationBeforeFrame(DRAWER_OPEN_FRAMELABEL,DRAWER_OPENED_FRAMELABEL);
               break;
            case PEDIGREE:
               BadgesClip.visible = true;
               addEventListener(Event.ENTER_FRAME,openDrawerFrameHandler);
               gotoAndPlayAnimationBeforeFrame(DRAWER_OPEN_FRAMELABEL,DRAWER_OPENED_FRAMELABEL);
               break;
            case null:
            default:
               switchTray(ATTACKS);
         }
      }
      
      private function _setVirmonInfo() : void
      {
         _sspVirmonInfo._stfName.text = _cVirmon.getName().toUpperCase();
         _sspVirmonInfo._stfNickName.text = Boolean(_cVirmon.getNickName()) ? _cVirmon.getNickName() : "";
         _sspVirmonInfo._stfPoints.text = _cVirmon.getSV().toString() + "SV";
         _sspVirmonInfo._stfHealth.text = _cVirmon.getCurrentHealth().toString() + "/" + _cVirmon.getHealth().toString();
         _sspVirmonInfo._stfStrength.text = _cVirmon.getStrength();
         if(int(_cVirmon.getDeltaStrength()) != 0)
         {
            _sspVirmonInfo._stfStrength.text += " [" + _cVirmon.getDeltaStrength() + "]";
         }
         _sspVirmonInfo._stfArmor.text = _cVirmon.getArmor();
         if(int(_cVirmon.getDeltaArmor()) != 0)
         {
            _sspVirmonInfo._stfArmor.text += " [" + _cVirmon.getDeltaArmor() + "]";
         }
         _sspVirmonInfo._stfSpeed.text = _cVirmon.getSpeed();
         if(int(_cVirmon.getDeltaSpeed()) != 0)
         {
            _sspVirmonInfo._stfSpeed.text += " [" + _cVirmon.getDeltaSpeed() + "]";
         }
         _smcAttacks._smcFaction.gotoAndStop(_cVirmon.getFaction());
         var _loc1_:int = Math.round(_cVirmon.getCurrentHealth() * 100 / _cVirmon.getHealth());
         var _loc2_:int = Math.round(_loc1_ * _sspVirmonInfo._smcHealthBar.totalFrames / 100);
         if(_loc2_ < 2 && _cVirmon.getCurrentHealth() > 0)
         {
            _loc2_ = 2;
         }
         _sspVirmonInfo._smcHealthBar.gotoAndStop(_loc2_);
      }
      
      public function hideAttackCloseBtn() : void
      {
         _bShowCloseAttack = false;
      }
      
      private function showHackInfo(param1:MouseEvent) : void
      {
         showInfoPanel(param1.currentTarget.hackId,"hack");
      }
      
      public function hideHolder() : void
      {
         _smcHolder.visible = false;
      }
      
      private function closeHackInfo() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.tw = new Tween(_smcAttacks._smcInfoPanel,"y",null,_smcAttacks._smcInfoPanel.y,HIDE_HACK_INFO,DELAY,true);
         _loc1_.tw.addEventListener(TweenEvent.MOTION_FINISH,onMotionFinish,false,0,true);
         _arTween.push(_loc1_);
      }
      
      public function setPlayerOwner(param1:MovieClip) : void
      {
         _cVirmonOwner = param1;
      }
      
      private function switchTray(param1:String) : void
      {
         log("switchTray: " + param1);
         if(_szDrawerState !== null)
         {
            _szOpenAfterClosed = param1;
            CloseDrawer();
         }
         else
         {
            _szDrawerState = param1;
            OpenDrawer();
            _szOpenAfterClosed = null;
         }
      }
      
      public function get isOpen() : Boolean
      {
         return _bOpen;
      }
      
      public function getPlayerOwner() : MovieClip
      {
         return _cVirmonOwner;
      }
      
      public function showHolderVertical() : void
      {
         _smcHolder.visible = false;
         _smcHolderVertical.visible = true;
      }
      
      public function get OpenAfterClosed() : String
      {
         return _szOpenAfterClosed;
      }
      
      private function hideCloseBtn() : void
      {
         _sbtClose.enabled = false;
         _sbtClose.visible = false;
      }
      
      public function loadDestVirmonAnim(param1:IVirmon) : *
      {
         var _loc2_:String = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterWidgetURL(CharacterWidgetAssetType.IDLE,param1.getMasterId()).url;
         _mcMainTV._smcVirmonIdle2.loadData(_loc2_);
      }
      
      public function closeAttacks(param1:MouseEvent = null) : void
      {
         parent.dispatchEvent(new Event("closeAttacks"));
         this.gotoAndPlay("close");
         addEventListener(Event.ENTER_FRAME,entrFrmForEndFrame,false,0,true);
      }
      
      private function onCloseInfo(param1:MouseEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.tw = new Tween(_smcAttacks._smcInfoPanel,"y",null,_smcAttacks._smcInfoPanel.y,HIDE_HACK_INFO,DELAY,true);
         _loc2_.tw.addEventListener(TweenEvent.MOTION_FINISH,onMotionFinish);
         _arTween.push(_loc2_);
         _smcAttacks._smcInfoPanel.closeButton.removeEventListener(MouseEvent.CLICK,onCloseInfo);
      }
      
      public function addOverride(param1:uint) : void
      {
         var _loc2_:String = "normal";
         _smcAttacks._sspOverride.visible = Boolean(param1);
         _smcAttacks._sspOverride.overrideId = param1;
         if(param1 > 0)
         {
            _loc2_ = DataManager.getInstance().getVirmonManager().getOverrideColor(param1);
            _smcAttacks._sspOverride.addEventListener(MouseEvent.CLICK,showOverrideInfo,false,0,true);
            _smcAttacks._sspOverride.gotoAndStop(_loc2_);
         }
      }
      
      public function clickOnClose(param1:MouseEvent) : void
      {
         if(_isViewingDrawerOpen())
         {
            CloseDrawer();
         }
      }
      
      private function clearHacks() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         while(_loc2_ < HACK_NUMBER)
         {
            _loc1_ = _smcAttacks["_sspHack" + _loc2_];
            _loc1_.removeEventListener(MouseEvent.CLICK,showHackInfo);
            _loc1_.visible = false;
            _loc2_++;
         }
      }
      
      private function entrFrmForStopShake(param1:Event) : void
      {
         var _loc2_:BlurFilter = null;
         if(_mcMainTV.currentLabel == "stopShake")
         {
            _mcMainTV.removeEventListener(Event.ENTER_FRAME,entrFrmForStopShake);
            x = _nBeginX;
            filters = [];
         }
         else
         {
            x += delta;
            if(delta > 0)
            {
               _loc2_ = new BlurFilter(5,0,1);
               filters = [_loc2_];
            }
            else
            {
               filters = [];
            }
            delta *= -1;
         }
      }
      
      public function get bClose() : Boolean
      {
         return _bClose;
      }
      
      private function showOverrideInfo(param1:MouseEvent) : void
      {
         showInfoPanel(param1.currentTarget.overrideId,"override");
      }
      
      private function entrFrmForEndFrame(param1:Event) : *
      {
         if(currentLabel == "end")
         {
            parent.dispatchEvent(new Event("ATTACKS_CLOSED"));
            removeEventListener(Event.ENTER_FRAME,entrFrmForEndFrame);
            _bClose = true;
            _bOpen = false;
            stop();
         }
      }
      
      public function init() : void
      {
         stop();
         stopAnimation();
         clearHacks();
         addOverride(0);
         _sspVirmonInfo._smcPedigree.visible = false;
         _smcAttacks.visible = false;
         BadgesClip.visible = false;
      }
      
      private function setAttacksInfo(param1:IVirmon) : void
      {
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         _loc2_ = param1.getAttackList();
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc5_ = Number(_loc2_[_loc6_].getDamage(_cVirmon));
            if(_loc5_ > 0)
            {
               _loc4_ = _loc2_[_loc6_].getAttackName() + " / " + _loc5_ + " DMG";
            }
            else
            {
               _loc4_ = _loc2_[_loc6_].getAttackName();
            }
            _loc3_.push({
               "title":_loc4_,
               "text":_loc2_[_loc6_].getPCDescription(),
               "energy":_loc2_[_loc6_].getCost() + "EN",
               "faction":param1.getFaction(),
               "icon":_loc2_[_loc6_].getAttackStatements()[0].type
            });
            _loc6_++;
         }
         _smcAttacks.acc.dataProvider = _loc3_;
      }
      
      public function closeMe() : void
      {
         if(_cVirmon != null)
         {
            parent.dispatchEvent(new ProjectEvent("HIDE_SELECT_VIRMON_IN_MINI_SWARM",{"id":_cVirmon.getID()}));
         }
         parent.dispatchEvent(new ProjectEvent("HIDE_VIRMON_VIEWER"));
      }
      
      private function openDrawerFrameHandler(param1:Event) : void
      {
         if(!_bPlaying)
         {
            showCloseBtn();
            TopTabsClip.EnableClicks();
            removeEventListener(Event.ENTER_FRAME,openDrawerFrameHandler);
            if(_szDrawerState == ATTACKS)
            {
               dispatchEvent(new Event(ATTACKS_DRAWER_OPEN_COMPLETE));
               parent.dispatchEvent(new Event("openAttacks"));
            }
            if(_szDrawerState == PEDIGREE)
            {
               dispatchEvent(new Event(PEDIGREE_DRAWER_OPEN_COMPLETE));
            }
            dispatchEvent(new Event(DRAWER_OPEN_COMPLETE));
         }
      }
      
      private function _isViewingDrawerOpen() : Boolean
      {
         if(_bPlaying)
         {
            return false;
         }
         if(_szDrawerState == ATTACKS)
         {
            return currentLabel == DRAWER_OPENED_FRAMELABEL;
         }
         if(_szDrawerState == PEDIGREE)
         {
            return currentLabel == DRAWER_OPENED_FRAMELABEL;
         }
         return false;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CVirmonViewer: " + param1);
      }
      
      public function set redSelect(param1:Boolean) : *
      {
         if(param1)
         {
            _mcMainTV._mcTV._mcRedSelect.alpha = 1;
         }
         else
         {
            _mcMainTV._mcTV._mcRedSelect.alpha = 0;
         }
      }
      
      public function win() : *
      {
         _mcMainTV.gotoAndPlay("transform");
         _mcMainTV._mcMask.play();
         _mcMainTV.addEventListener(Event.ENTER_FRAME,entrFrmForStopShake,false,0,true);
         _mcMainTV.addEventListener(Event.ENTER_FRAME,entrFrmForMessageWin,false,0,true);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** CVirmonViewer: " + param1);
      }
      
      private function showCloseBtn() : void
      {
         _sbtClose.enabled = true;
         _sbtClose.visible = true;
      }
      
      private function addHack(param1:uint, param2:int) : void
      {
         var _loc3_:MovieClip = _smcAttacks["_sspHack" + param2];
         _loc3_.visible = true;
         _loc3_.hackId = param1;
         _loc3_.addEventListener(MouseEvent.CLICK,showHackInfo,false,0,true);
      }
      
      private function entrFrmForMessageWin(param1:Event) : *
      {
         if(_mcMainTV.currentLabel == "end")
         {
            parent.parent.dispatchEvent(new Event("END_WIN_ANIMATION"));
            _mcMainTV.removeEventListener(Event.ENTER_FRAME,entrFrmForMessageWin);
         }
      }
      
      public function clearAll() : void
      {
         var _loc1_:uint = 0;
         stopAnimation();
         removeEventListener(Event.ENTER_FRAME,entrFrmForEndFrame);
         _mcMainTV._smcVirmonIdle.destroy();
         if(Boolean(_arTween))
         {
            _loc1_ = 0;
            while(_loc1_ < _arTween.length)
            {
               if(Boolean(_arTween[_loc1_]) && Boolean(_arTween[_loc1_].tw))
               {
                  _arTween[_loc1_].tw.removeEventListener(TweenEvent.MOTION_FINISH,onMotionFinish);
                  _arTween[_loc1_].tw.stop();
                  delete _arTween[_loc1_].tw;
               }
               _arTween[_loc1_] = null;
               _loc1_++;
            }
         }
         if(Boolean(_smcAttacks.acc))
         {
            _smcAttacks.acc.clearAll();
         }
      }
      
      public function burn() : *
      {
         _mcMainTV.gotoAndPlay("shake");
      }
      
      public function CloseDrawer(param1:Boolean = false) : void
      {
         log("CloseDrawer: bUpdateTabs==" + param1.toString());
         removeEventListener(Event.ENTER_FRAME,openDrawerFrameHandler);
         hideCloseBtn();
         switch(_szDrawerState)
         {
            case ATTACKS:
               addEventListener(Event.ENTER_FRAME,closeDrawerFrameHandler);
               gotoAndPlayAnimationBeforeFrame(DRAWER_CLOSE_FRAMELABEL,DRAWER_CLOSED_FRAMELABEL);
               if(param1)
               {
                  TopTabsClip.Activate(null,0,false);
               }
               break;
            case PEDIGREE:
               addEventListener(Event.ENTER_FRAME,closeDrawerFrameHandler);
               gotoAndPlayAnimationBeforeFrame(DRAWER_CLOSE_FRAMELABEL,DRAWER_CLOSED_FRAMELABEL);
               if(param1)
               {
                  TopTabsClip.Activate(null,0,false);
               }
         }
      }
      
      private function loadIdAnimation(param1:IVirmon) : void
      {
         var _loc2_:CharacterWidgetAssetType = CharacterWidgetAssetType.IDLE;
         var _loc3_:String = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterWidgetURL(_loc2_,param1.getMasterId()).url;
         _mcMainTV._smcVirmonIdle.loadData(_loc3_);
      }
      
      private function setPedigreeInfo(param1:IVirmon) : void
      {
         _sspVirmonInfo._smcPedigree._stfSerialNumber.text = "SN: " + param1.getProductionNumber();
         _sspVirmonInfo._smcPedigree._stfDateBirthday.text = "DOB: " + param1.getBirthDate();
         _sspVirmonInfo._smcPedigree._stfEvoMeta.text = "LAST EVO/META : " + param1.getEvolveDate();
         _sspVirmonInfo._smcPedigree._stfTotalBattles.text = "TOTAL BATTLES: " + param1.getBattleCount();
         _sspVirmonInfo._smcPedigree._stfTotalKills.text = "TOTAL KILLS: " + param1.getKillCount();
      }
      
      private function onMotionFinish(param1:TweenEvent) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < _arTween.length)
         {
            if(_arTween[_loc2_].tw == param1.currentTarget)
            {
               _arTween[_loc2_].tw.removeEventListener(TweenEvent.MOTION_FINISH,onMotionFinish);
               _arTween[_loc2_].tw.stop();
               delete _arTween[_loc2_].tw;
               _arTween[_loc2_] = null;
               _arTween.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function showVirmon(param1:IVirmon, param2:uint = 0, param3:Boolean = false, param4:String = "attacks") : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         log("showVirmon: " + param1.getName() + " [" + param1.getID() + "]");
         closeHackInfo();
         _bClose = false;
         if(_cVirmon != param1)
         {
            _sspVirmonInfo._mcRefresh.gotoAndPlay(1);
         }
         if(Boolean(_cVirmon))
         {
            parent.dispatchEvent(new ProjectEvent("HIDE_SELECT_VIRMON_IN_MINI_SWARM",{"id":_cVirmon.getID()}));
         }
         parent.dispatchEvent(new ProjectEvent("SHOW_SELECT_VIRMON_IN_MINI_SWARM",{"id":param1.getID()}));
         _cVirmon = param1;
         loadIdAnimation(param1);
         _setVirmonInfo();
         setAttacksInfo(_cVirmon);
         setPedigreeInfo(_cVirmon);
         if(param3)
         {
            BadgesClip.init(_cVirmon,_cVirmon.getBadgesList(),param2);
         }
         else
         {
            BadgesClip.init(_cVirmon);
         }
         if(!_isViewingDrawerOpen())
         {
            TopTabsClip.Activate(param4);
            if(param4 !== null)
            {
               switchTray(param4);
            }
         }
         else if(param4 == null)
         {
            TopTabsClip.Activate(null);
            switchTray(null);
         }
         trace("_cVirmonOwner = " + _cVirmonOwner);
         if(Boolean(_cVirmonOwner))
         {
            addOverride(_cVirmonOwner["getOverrideId"]());
            trace("_cVirmonOwner[\'getOverrideId\']()" + _cVirmonOwner["getOverrideId"]());
            clearHacks();
            if(_cVirmon == _cVirmonOwner["getCurrentVirmon"]())
            {
               _loc5_ = _cVirmonOwner["getSelectedNanovorHacks"]();
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  addHack(_loc5_[_loc6_].attackId,_loc6_);
                  _loc6_++;
               }
            }
         }
      }
      
      private function onTraySelected(param1:CustomEvent) : void
      {
         var _loc2_:String = "onTraySelected: " + param1.data.tabName;
         TopTabsClip.DisableClicks();
         if(_bPlaying)
         {
            log(_loc2_ + "\n           ... : _bPlaying is TRUE... return;");
            return;
         }
         var _loc3_:String = param1.data.tabName;
         if(_loc3_ == _szDrawerState)
         {
            log(_loc2_ + "\n           ... : szTabName == _szDrawerState ... return;");
            return;
         }
         log(_loc2_ + "\n           ... : calling switchTray()");
         switchTray(_loc3_);
      }
      
      public function showInfoPanel(param1:int, param2:String) : void
      {
         var _loc3_:Object = new Object();
         _loc3_.tw = new Tween(_smcAttacks._smcInfoPanel,"y",null,_smcAttacks._smcInfoPanel.y,SHOW_HACK_INFO,DELAY,true);
         _loc3_.tw.addEventListener(TweenEvent.MOTION_FINISH,onMotionFinish,false,0,true);
         _arTween.push(_loc3_);
         if(param2 == "hack")
         {
            _smcAttacks._smcInfoPanel._tfInfo.text = DataManager.getInstance().getVirmonManager().getHackDescriptionByAttackId(param1);
         }
         if(param2 == "override")
         {
            _smcAttacks._smcInfoPanel._tfInfo.text = DataManager.getInstance().getVirmonManager().getOverrideDescriptionByAttackId(param1);
         }
         _smcAttacks._smcInfoPanel.closeButton.addEventListener(MouseEvent.CLICK,onCloseInfo,false,0,true);
      }
      
      private function closeDrawerFrameHandler(param1:Event) : void
      {
         log("closeDrawerFrameHandler()");
         if(!_bPlaying)
         {
            log("closeDrawerFrameHandler()  is not playing");
            removeEventListener(Event.ENTER_FRAME,closeDrawerFrameHandler);
            _smcAttacks.visible = false;
            BadgesClip.visible = false;
            if(_szDrawerState == ATTACKS)
            {
               dispatchEvent(new Event(ATTACKS_DRAWER_CLOSE_COMPLETE));
            }
            else if(_szDrawerState == PEDIGREE)
            {
               dispatchEvent(new Event(PEDIGREE_DRAWER_CLOSE_COMPLETE));
            }
            dispatchEvent(new Event(DRAWER_CLOSE_COMPLETE));
            _szDrawerState = null;
            if(_szOpenAfterClosed !== null)
            {
               switchTray(_szOpenAfterClosed);
            }
            else
            {
               TopTabsClip.EnableClicks();
            }
         }
      }
   }
}

