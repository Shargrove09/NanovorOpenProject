package com.arkadium.virmon.senseiselect
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.senseibattle.ai.ISenseiAIDirectoryConsumer;
   import com.arkadium.virmon.senseibattle.ai.SenseiAIDirectory;
   import com.arkadium.virmon.senseiselect.ui.SenseiSelectionButton;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.NanovorFactory;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconLightning;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.IStateChanger;
   import com.arkadium.virmon.state.StateType;
   import fl.motion.AdjustColor;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Dictionary;
   
   public class SenseiSelectState extends AbstractState implements ISenseiAIDirectoryConsumer
   {
      
      private static var SENSEI_FILTERS:Dictionary;
      
      private static const EXPECTED_SENSEI_NAMES:Array = ["Easy","Medium","Hard"];
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _currentSelectedButton:SenseiSelectionButton;
      
      public var mcLaunchLabel:Sprite;
      
      private var _selectedSenseiName:String;
      
      private var _stateChanger:IStateChanger;
      
      private var _chatWidget:IWidget;
      
      private var _launchButton:SpinningButtonComponent;
      
      private var _cancelButton:SpinningButtonComponent;
      
      private var _senseiDirectory:SenseiAIDirectory;
      
      public function SenseiSelectState()
      {
         super();
         stateName = StateType.SENSEI_SELECT.name;
         _quicktipsURL = "";
         mcLaunchLabel.alpha = 0;
         SENSEI_FILTERS = new Dictionary();
         var _loc1_:AdjustColor = new AdjustColor();
         _loc1_.brightness = 0;
         _loc1_.contrast = 0;
         _loc1_.saturation = 0;
         _loc1_.hue = -138;
         var _loc2_:AdjustColor = new AdjustColor();
         _loc2_.brightness = 0;
         _loc2_.contrast = 0;
         _loc2_.saturation = 28;
         _loc2_.hue = -169;
         var _loc3_:AdjustColor = new AdjustColor();
         _loc3_.brightness = -78;
         _loc3_.contrast = 0;
         _loc3_.saturation = 0;
         _loc3_.hue = 0;
         SENSEI_FILTERS["Easy"] = new ColorMatrixFilter(_loc1_.CalculateFinalFlatArray());
         SENSEI_FILTERS["Medium"] = new ColorMatrixFilter(_loc2_.CalculateFinalFlatArray());
         SENSEI_FILTERS["Hard"] = new ColorMatrixFilter(_loc3_.CalculateFinalFlatArray());
      }
      
      public function handleSenseiAILoadComplete() : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:SenseiSelectionButton = null;
         createButtons();
         var _loc1_:Array = _senseiDirectory.getSenseiAINames();
         var _loc2_:int = 0;
         while(_loc2_ < EXPECTED_SENSEI_NAMES.length)
         {
            _loc3_ = false;
            _loc4_ = EXPECTED_SENSEI_NAMES[_loc2_];
            _loc5_ = new SenseiSelectionButton(_loc4_,_senseiDirectory.getSenseiIdByName(_loc4_));
            _loc5_.y = 85 * _loc2_ + 150 + 20;
            _loc5_.x = 380;
            _loc5_.mouseChildren = false;
            _loc5_.mouseEnabled = false;
            this.addChild(_loc5_);
            if(-1 != _loc1_.indexOf(_loc4_))
            {
               _loc5_.mouseEnabled = true;
               _loc5_.addEventListener(MouseEvent.CLICK,handleSenseiOptionClick);
               _loc3_ = true;
            }
            Tweener.addCaller(this,{
               "time":0,
               "count":1,
               "delay":1 + 0.1 * _loc2_,
               "onComplete":_loc5_.open,
               "onCompleteParams":[_loc3_,SENSEI_FILTERS[_loc4_]]
            });
            _loc2_++;
         }
      }
      
      override public function onSetState() : void
      {
         _chatWidget.setMode(WidgetType.MODE_HOME);
         _senseiDirectory = new SenseiAIDirectory(_nanovorFactory,ISenseiAIDirectoryConsumer(this),Managers.assetRetrieverManager.masterDataAssetRetriever);
      }
      
      public function handleSenseiAILoadFailure() : void
      {
         CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Error Loading Sensei AIs","There was an error loading Sensei AIs",0,exitSenseiSelect,exitSenseiSelect,null,exitSenseiSelect);
      }
      
      private function exitSenseiSelect(param1:Object = null) : void
      {
         _stateChanger.setState(StateType.HOME);
      }
      
      override public function init(param1:Object = null) : void
      {
         _nanovorFactory = new NanovorFactory(DataManager.getInstance().getVirmonManager());
         _stateChanger = Managers.stateManager as IStateChanger;
         _chatWidget = Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name) as IWidget;
         isInitialized = true;
      }
      
      private function createButtons() : void
      {
         _launchButton = new SpinningButtonComponent(new SpinnerIconLightning());
         _launchButton.scaleX = _launchButton.scaleY = 3.185;
         _launchButton.x = 816;
         _launchButton.y = 212;
         _launchButton.color = SpinningButtonComponent.COLOR_RED;
         this.addChild(_launchButton);
         _cancelButton = new SpinningButtonComponent(new SpinnerIconX());
         _cancelButton.x = 730;
         _cancelButton.y = 670;
         _cancelButton.color = SpinningButtonComponent.COLOR_RED;
         this.addChild(_cancelButton);
         _cancelButton.addEventListener(MouseEvent.CLICK,exitSenseiSelect);
         _cancelButton.open();
      }
      
      override public function onUnsetState() : void
      {
         if(null != _launchButton)
         {
            if(null != _launchButton.parent)
            {
               _launchButton.parent.removeChild(_launchButton);
            }
            _launchButton.removeEventListener(MouseEvent.CLICK,handleLaunchButtonClick);
            _launchButton.destroy();
         }
         if(null != _cancelButton)
         {
            if(null != _cancelButton.parent)
            {
               _cancelButton.parent.removeChild(_cancelButton);
            }
            _cancelButton.removeEventListener(MouseEvent.CLICK,exitSenseiSelect);
            _cancelButton.destroy();
         }
      }
      
      private function handleSenseiOptionClick(param1:MouseEvent) : void
      {
         if(null != _currentSelectedButton)
         {
            _currentSelectedButton.deselect();
         }
         var _loc2_:SenseiSelectionButton = SenseiSelectionButton(param1.target);
         if(!_launchButton.hasEventListener(MouseEvent.CLICK))
         {
            _launchButton.open();
            Tweener.addTween(mcLaunchLabel,{
               "_autoAlpha":1,
               "time":1
            });
            _launchButton.addEventListener(MouseEvent.CLICK,handleLaunchButtonClick);
         }
         _loc2_.select();
         _selectedSenseiName = _loc2_.senseiName;
         _currentSelectedButton = _loc2_;
      }
      
      private function handleLaunchButtonClick(param1:MouseEvent) : void
      {
         Managers.stateManager.setState(StateType.SENSEI_BATTLE,{
            "senseiName":_selectedSenseiName,
            "senseiId":_senseiDirectory.getSenseiIdByName(_selectedSenseiName)
         },true);
      }
   }
}

