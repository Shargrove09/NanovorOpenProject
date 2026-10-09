package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.EMMasterData;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.elements.*;
   import com.arkadium.virmon.shared.final.components.NickNameEditor;
   import com.arkadium.virmon.shared.utils.*;
   import com.smithandtinker.nanovor.debug.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.*;
   
   public class NanovorMegaViewer extends ArkMc
   {
      
      public static const ATTACKS:String = TopTabsPane.ATTACKS;
      
      public static const PEDIGREE:String = TopTabsPane.PEDIGREE;
      
      public static const DRAWER_OPEN_COMPLETE:String = "drawerOpenComplete";
      
      public static const DRAWER_CLOSE_COMPLETE:String = "drawerCloseComplete";
      
      public static const ATTACKS_DRAWER_OPEN_COMPLETE:String = "attacksDrawerOpenComplete";
      
      public static const ATTACKS_DRAWER_CLOSE_COMPLETE:String = "attacksDrawerCloseComplete";
      
      public static const PEDIGREE_DRAWER_OPEN_COMPLETE:String = "pedigreeDrawerOpenComplete";
      
      public static const PEDIGREE_DRAWER_CLOSE_COMPLETE:String = "pedigreeDrawerCloseComplete";
      
      private static const ATTACKS_OPEN_FRAMELABEL:String = "OpenAttacks";
      
      private static const ATTACKS_CLOSE_FRAMELABEL:String = "CloseAttacks";
      
      private static const ATTACKS_CLOSED_FRAMELABEL:String = "AttacksClosed";
      
      private static const ATTACKS_OPEN_DRAWER_FRAMELABEL:String = "OpenAttacksDrawer";
      
      private static const ATTACKS_DRAWER_CLOSED_FRAMELABEL:String = "AttacksDrawerClosed";
      
      private static const ANIM_VIEWER_OPENED_FRAMELABEL:String = "AnimViewerOpened";
      
      private static const ANIM_VIEWER_CLOSE_FRAMELABEL:String = "AnimViewerClose";
      
      private static const PEDIGREE_OPEN_FRAMELABEL:String = "OpenPedigree";
      
      private static const PEDIGREE_CLOSE_FRAMELABEL:String = "ClosePedigree";
      
      private static const PEDIGREE_CLOSED_FRAMELABEL:String = "PedigreeClosed";
      
      private static const PEDIGREE_OPEN_DRAWER_FRAMELABEL:String = "OpenPedigreeDrawer";
      
      private static const PEDIGREE_DRAWER_CLOSED_FRAMELABEL:String = "PedigreeDrawerClosed";
      
      private const EM_WAVE_LABEL:String = "WV";
      
      public var AttacksClip:AttacksPane;
      
      private const CHIPSET_STATE_SHOWING_NANOVOR:String = "ChipsetStateShowingNanovor";
      
      private var _emChipClip:CChipTradeEm;
      
      private const DEFAULT_STRENGTH_LABEL:String = "STR";
      
      private const DEFAULT_HEALTH:String = "- - -/- - -";
      
      private var _szDrawerState:String = null;
      
      public var TopTabsClip:TopTabsPane;
      
      private var _em:CEm;
      
      private var _sequencer:AnimationSequencer;
      
      public var CharacterTrayBG:MovieClip;
      
      private var _virmonData:IVirmonData;
      
      private const EM_RARITY_LABEL:String = "RTY";
      
      private const DEFAULT_ARMOR:String = "- - -";
      
      private var _virmonChipClip:CCollectionVirmonUnit;
      
      private const DEFAULT_SPEED:String = "- - -";
      
      private const DEFAULT_ARMOR_LABEL:String = "ARM";
      
      public var NameClip:NamePane;
      
      private var _chipsetState:String;
      
      private const CHIPSET_STATE_EMPTY:String = "ChipsetStateEmpty";
      
      private const DEFAULT_SPEED_LABEL:String = "SPD";
      
      private const DEFAULT_STRENGTH:String = "- - -";
      
      private var nickNameEditor:NickNameEditor;
      
      public var ArmClip:MovieClip;
      
      public var NanovorAnimClip:MovieClip;
      
      private var _virmon:IVirmon;
      
      private const NICKNAME_EDITOR_X:int = 17;
      
      private const NICKNAME_EDITOR_Y:int = 57;
      
      private const CHIPSET_STATE_SHOWING_EM:String = "ChipsetStateShowingEm";
      
      public var BadgesClip:BadgesPane;
      
      private const DEFAULT_POINTS:String = "- - - - SV";
      
      private const DEFAULT_NICKNAME:String = "LOAD SIM FOR DETAILS";
      
      public var LowerClip:LowerPane;
      
      private const EM_MARKETVALUE_LABEL:String = "MV";
      
      private var _szOpenAfterClosed:String = null;
      
      public var ChipsetClip:ChipsetPane;
      
      private const DEFAULT_NAME:String = "SELECT NANOVOR";
      
      private var tempConst:String = "";
      
      public function NanovorMegaViewer()
      {
         addFrameScript(0,frame1,27,frame28,45,frame46,79,frame80,98,frame99);
         super();
         _chipsetState = CHIPSET_STATE_EMPTY;
         TopTabsClip.addEventListener(TopTabsPane.EVENT_TAB_CHANGED,onTraySelected,false,0,true);
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:Loader = new Loader();
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,chipLoadCompleteHandler);
         _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,chipLoadErrorHandler);
         _loc2_.load(new URLRequest("elements/collectionUnit.swf"),_loc1_);
         _sequencer = new AnimationSequencer(NanovorAnimClip);
         nickNameEditor = new NickNameEditor(Managers.serviceRequestBrokerManager);
         NameClip.addChild(nickNameEditor);
         nickNameEditor.x = NICKNAME_EDITOR_X;
         nickNameEditor.y = NICKNAME_EDITOR_Y;
         nickNameEditor.hide();
         nickNameEditor.addEventListener("NICKNAME_UPDATED",onNickNameUpdated,false,0,true);
         init();
      }
      
      public function get DrawerState() : String
      {
         return _szDrawerState;
      }
      
      public function setNanovorName(param1:String) : void
      {
         tempConst = param1;
      }
      
      private function _isViewingDrawerOpen() : Boolean
      {
         if(_bPlaying)
         {
            return false;
         }
         if(_szDrawerState == TopTabsPane.ATTACKS)
         {
            return currentLabel == ATTACKS_CLOSE_FRAMELABEL || currentLabel == ANIM_VIEWER_OPENED_FRAMELABEL;
         }
         if(_szDrawerState == TopTabsPane.PEDIGREE)
         {
            return currentLabel == PEDIGREE_CLOSE_FRAMELABEL;
         }
         return false;
      }
      
      public function ShowVirmon(param1:IVirmon, param2:Boolean = false) : void
      {
         _virmon = param1;
         _virmonData = DataManager.getInstance().getVirmonManager().getVirmonData(_virmon.getID());
         NameClip.NanovorNameText.text = _virmon.getName().toUpperCase();
         NameClip.NanovorNicknameText.visible = false;
         nickNameEditor.setName(DataManager.getInstance().getVirmonManager().getVirmonData(_virmon.getID()));
         nickNameEditor.show();
         NameClip.SwarmPointsText.text = String(_virmon.getSV()) + " SV";
         AttacksClip.init(_virmon);
         BadgesClip.init(_virmon);
         if(param2 && !TopTabsClip.Activated)
         {
            TopTabsClip.Activate(TopTabsPane.ATTACKS);
            TopTabsClip.DisableClicks();
         }
         LowerClip.StrengthText.text = String(_virmon.getStrength());
         if(int(_virmon.getDeltaStrength()) != 0)
         {
            LowerClip.StrengthText.appendText(" [" + _virmon.getDeltaStrength() + "]");
         }
         LowerClip.ArmorText.text = String(_virmon.getArmor());
         if(int(_virmon.getDeltaArmor()) != 0)
         {
            LowerClip.ArmorText.appendText(" [" + _virmon.getDeltaArmor() + "]");
         }
         LowerClip.SpeedText.text = String(_virmon.getSpeed());
         if(int(_virmon.getDeltaSpeed()) != 0)
         {
            LowerClip.SpeedText.appendText(" [" + _virmon.getDeltaSpeed() + "]");
         }
         LowerClip.HealthText.text = String(_virmon.getCurrentHealth()) + "/" + String(_virmon.getHealth());
         LowerClip.startHealthBar();
         _chipsetState = CHIPSET_STATE_SHOWING_NANOVOR;
         updateChipDisplay();
      }
      
      private function init() : void
      {
         NameClip.NanovorNameText.text = DEFAULT_NAME;
         NameClip.NanovorNicknameText.text = DEFAULT_NICKNAME;
         NameClip.SwarmPointsText.text = DEFAULT_POINTS;
         LowerClip.StrengthLabel.text = DEFAULT_STRENGTH_LABEL;
         LowerClip.ArmorLabel.text = DEFAULT_ARMOR_LABEL;
         LowerClip.SpeedLabel.text = DEFAULT_SPEED_LABEL;
         LowerClip.StrengthText.text = DEFAULT_STRENGTH;
         LowerClip.ArmorText.text = DEFAULT_ARMOR;
         LowerClip.SpeedText.text = DEFAULT_SPEED;
         LowerClip.HealthText.visible = true;
         LowerClip.HealthText.text = DEFAULT_HEALTH;
         LowerClip.showHealthBar();
         LowerClip.resetHealthBar();
         BadgesClip.reset();
         if(tempConst != "")
         {
            NameClip.NanovorNameText.text = tempConst;
         }
      }
      
      protected function chipLoadCompleteHandler(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,chipLoadCompleteHandler);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,chipLoadErrorHandler);
         _virmonChipClip = new CCollectionVirmonUnit(Managers.assetRetrieverManager.characterAssetRetriever);
         _virmonChipClip.visible = false;
         _virmonChipClip.gotoAndStop("normal");
         ChipsetClip.ChipHolderClip.addChild(_virmonChipClip);
         loadEMChip();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> NanovorMegaViewer: ** " + param1 + " **");
      }
      
      internal function frame80() : *
      {
         stop();
      }
      
      public function Reset() : void
      {
         _chipsetState = CHIPSET_STATE_EMPTY;
         updateChipDisplay();
         init();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorMegaViewer: " + param1);
      }
      
      private function updateChipDisplay() : void
      {
         if(_virmonChipClip != null)
         {
            _virmonChipClip.visible = false;
         }
         if(_emChipClip != null)
         {
            _emChipClip.visible = false;
         }
         ChipsetClip.GrabberClip.gotoAndStop(1);
         if(_chipsetState == CHIPSET_STATE_SHOWING_NANOVOR && _virmonChipClip != null)
         {
            _virmonChipClip.visible = true;
            _virmonChipClip.showSv();
            _virmonChipClip.setData(_virmon);
            ChipsetClip.GrabberClip.gotoAndPlay(1);
         }
         else if(_chipsetState == CHIPSET_STATE_SHOWING_EM && _emChipClip != null)
         {
            _emChipClip.visible = true;
            _emChipClip.setData(_em);
            ChipsetClip.GrabberClip.gotoAndPlay(1);
         }
         if(tempConst != "")
         {
            NameClip.NanovorNameText.text = tempConst;
         }
      }
      
      internal function frame99() : *
      {
         stop();
      }
      
      protected function emChipLoadCompleteHandler(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,emChipLoadCompleteHandler);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,emChipLoadErrorHandler);
         _emChipClip = new CChipTradeEm(Managers.assetRetrieverManager.emAssetRetriever,DataManager.getInstance().getEMManager());
         _emChipClip.hideBG();
         _emChipClip.visible = false;
         _emChipClip.gotoAndStop("normal");
         ChipsetClip.ChipHolderClip.addChild(_emChipClip);
         updateChipDisplay();
      }
      
      protected function emChipLoadErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,emChipLoadCompleteHandler);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,emChipLoadErrorHandler);
         logError("Failed to load EM chip!");
         updateChipDisplay();
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      protected function deathAnimCompleteHandler() : void
      {
         _sequencer.Stop();
      }
      
      private function onNickNameUpdated(param1:CustomEvent) : void
      {
         _virmonChipClip.setData(param1.data.virmon);
      }
      
      internal function frame28() : *
      {
         stop();
      }
      
      protected function sequencerLoadCompleteHandler(param1:Event) : void
      {
         _sequencer.removeEventListener(Event.COMPLETE,sequencerLoadCompleteHandler);
         _sequencer.Play();
      }
      
      private function onTraySelected(param1:CustomEvent) : void
      {
         var _loc2_:String = "onTraySelected: " + param1.data.tabName;
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
         TopTabsClip.DisableClicks();
      }
      
      public function ShowEM(param1:EMMasterData, param2:int = 0) : void
      {
         TopTabsClip.Deactivate();
         _em = new CEm();
         _em.masterID = param1.getAssetTypeID();
         _em.shortName = param1.getShortName();
         _em.longName = param1.getLongName();
         _em.collectorID = param1.getCollectorId();
         _em.wave = param1.getWave();
         _em.rarity = param1.getRarity();
         _em.faction = param1.getFaction();
         _em.count = param2;
         NameClip.NanovorNameText.text = _em.shortName;
         NameClip.NanovorNicknameText.text = _em.longName;
         NameClip.NanovorNicknameText.visible = true;
         nickNameEditor.hide();
         NameClip.SwarmPointsText.text = _em.collectorID;
         LowerClip.StrengthLabel.text = EM_RARITY_LABEL;
         LowerClip.ArmorLabel.text = EM_WAVE_LABEL;
         LowerClip.SpeedLabel.text = EM_MARKETVALUE_LABEL;
         LowerClip.StrengthText.text = _em.rarity;
         LowerClip.ArmorText.text = _em.wave;
         LowerClip.SpeedText.text = "$0";
         LowerClip.HealthText.visible = false;
         LowerClip.hideHealthBar();
         _chipsetState = CHIPSET_STATE_SHOWING_EM;
         updateChipDisplay();
      }
      
      public function PlayDeath() : void
      {
         var _loc1_:String = null;
         if(IsViewingDrawerOpen && _szDrawerState == ATTACKS)
         {
            if(_virmon != null && _virmonData != null)
            {
               _loc1_ = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterAnimationURL(CharacterAnimationAssetType.DEATH,_virmon.getMasterId()).url;
               _sequencer.Unload();
               _sequencer.addEventListener(Event.COMPLETE,sequencerLoadCompleteHandler);
               _sequencer.LoadAndQueueClip(_loc1_,null,deathAnimCompleteHandler);
            }
         }
      }
      
      private function switchTray(param1:String, param2:Boolean = false) : void
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
            OpenDrawer(Boolean(_szOpenAfterClosed == param1),param2);
            _szOpenAfterClosed = null;
         }
      }
      
      protected function loadEMChip() : void
      {
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:Loader = new Loader();
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,emChipLoadCompleteHandler);
         _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,emChipLoadErrorHandler);
         _loc2_.load(new URLRequest("elements/emUnit.swf"),_loc1_);
      }
      
      protected function chipLoadErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,chipLoadCompleteHandler);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,chipLoadErrorHandler);
         logError("Failed to load Virmon chip!");
         loadEMChip();
      }
      
      public function HideArm() : void
      {
         ArmClip.visible = false;
      }
      
      private function openDrawerFrameHandler(param1:Event) : void
      {
         if(!_bPlaying)
         {
            TopTabsClip.EnableClicks();
            removeEventListener(Event.ENTER_FRAME,openDrawerFrameHandler);
            if(_szDrawerState == ATTACKS)
            {
               dispatchEvent(new Event(ATTACKS_DRAWER_OPEN_COMPLETE));
            }
            if(_szDrawerState == PEDIGREE)
            {
               dispatchEvent(new Event(PEDIGREE_DRAWER_OPEN_COMPLETE));
            }
            dispatchEvent(new Event(DRAWER_OPEN_COMPLETE));
         }
      }
      
      public function get IsViewingDrawerOpen() : Boolean
      {
         return _isViewingDrawerOpen();
      }
      
      internal function frame46() : *
      {
         stop();
      }
      
      public function get Sequencer() : AnimationSequencer
      {
         return _sequencer;
      }
      
      private function closeDrawerFrameHandler(param1:Event) : void
      {
         if(!_bPlaying)
         {
            removeEventListener(Event.ENTER_FRAME,closeDrawerFrameHandler);
            if(_szDrawerState == ATTACKS)
            {
               NanovorAnimClip.visible = false;
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
         }
      }
      
      public function PlayDamage() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(IsViewingDrawerOpen && _szDrawerState == ATTACKS)
         {
            if(_virmon != null && _virmonData != null)
            {
               _loc1_ = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterAnimationURL(CharacterAnimationAssetType.IDLE,_virmon.getMasterId()).url;
               _loc2_ = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterAnimationURL(CharacterAnimationAssetType.DAMAGE,_virmon.getMasterId(),"2").url;
               _sequencer.Unload();
               _sequencer.addEventListener(Event.COMPLETE,sequencerLoadCompleteHandler);
               _sequencer.LoadAndQueueClip(_loc2_);
               _sequencer.LoadAndQueueClip(_loc1_);
            }
         }
      }
      
      public function CloseDrawer() : void
      {
         log("CloseDrawer");
         removeEventListener(Event.ENTER_FRAME,openDrawerFrameHandler);
         addEventListener(Event.ENTER_FRAME,closeDrawerFrameHandler);
         switch(_szDrawerState)
         {
            case ATTACKS:
               if(_szOpenAfterClosed !== null)
               {
                  gotoAndPlayAnimationBeforeFrame(ATTACKS_CLOSE_FRAMELABEL,ATTACKS_DRAWER_CLOSED_FRAMELABEL);
                  break;
               }
               gotoAndPlayAnimationBeforeFrame(ATTACKS_CLOSE_FRAMELABEL,ATTACKS_CLOSED_FRAMELABEL);
               break;
            case PEDIGREE:
               if(_szOpenAfterClosed !== null)
               {
                  gotoAndPlayAnimationBeforeFrame(PEDIGREE_CLOSE_FRAMELABEL,PEDIGREE_DRAWER_CLOSED_FRAMELABEL);
                  break;
               }
               gotoAndPlayAnimationBeforeFrame(PEDIGREE_CLOSE_FRAMELABEL,PEDIGREE_CLOSED_FRAMELABEL);
         }
      }
      
      public function destroy() : void
      {
         _sequencer.removeEventListener(Event.COMPLETE,sequencerLoadCompleteHandler);
         nickNameEditor.removeEventListener("NICKNAME_UPDATED",onNickNameUpdated);
         TopTabsClip.removeEventListener(TopTabsPane.EVENT_TAB_CHANGED,onTraySelected);
         removeEventListener(Event.ENTER_FRAME,closeDrawerFrameHandler);
         removeEventListener(Event.ENTER_FRAME,openDrawerFrameHandler);
         _sequencer.UnloadAll();
         try
         {
            TopTabsClip.DisableClicks();
         }
         catch(e:*)
         {
         }
         try
         {
            nickNameEditor.destroy();
         }
         catch(e:*)
         {
         }
         try
         {
            BadgesClip.clear();
         }
         catch(e:*)
         {
         }
         try
         {
            LowerClip.disableShockButton();
         }
         catch(e:*)
         {
         }
         delete global[this];
      }
      
      public function OpenDrawer(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         log("OpenDrawer");
         removeEventListener(Event.ENTER_FRAME,closeDrawerFrameHandler);
         switch(_szDrawerState)
         {
            case ATTACKS:
               addEventListener(Event.ENTER_FRAME,openDrawerFrameHandler);
               NanovorAnimClip.visible = true;
               _loc3_ = param2 ? ANIM_VIEWER_OPENED_FRAMELABEL : ATTACKS_CLOSE_FRAMELABEL;
               if(param1)
               {
                  gotoAndPlayAnimationBeforeFrame(ATTACKS_OPEN_DRAWER_FRAMELABEL,_loc3_);
                  break;
               }
               gotoAndPlayAnimationBeforeFrame(ATTACKS_OPEN_FRAMELABEL,_loc3_);
               break;
            case PEDIGREE:
               addEventListener(Event.ENTER_FRAME,openDrawerFrameHandler);
               NanovorAnimClip.visible = false;
               if(param1)
               {
                  gotoAndPlayAnimationBeforeFrame(PEDIGREE_OPEN_DRAWER_FRAMELABEL,PEDIGREE_CLOSE_FRAMELABEL);
                  break;
               }
               gotoAndPlayAnimationBeforeFrame(PEDIGREE_OPEN_FRAMELABEL,PEDIGREE_CLOSE_FRAMELABEL);
               break;
            case null:
            default:
               switchTray(ATTACKS,param2);
         }
      }
      
      public function ShowArm() : void
      {
         ArmClip.visible = true;
      }
   }
}

