package com.arkadium.virmon.shared.widgets.chat
{
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class CannedChatPanelView implements IChainLoaderConsumer, ISendMessageHandler, IChatMessageProvider
   {
      
      private static const DEFAULT_CATEGORY:String = "Battle";
      
      private static const NUM_MESSAGE_SLOTS:int = 3;
      
      private var _currentPhraseIndex:int;
      
      private var _currentSelectedMessageController:CannedMessageController;
      
      private var _currentCategoryController:CategoryButtonController;
      
      private var _cannedCategories:Dictionary;
      
      private var _cannedChatPanel:ICannedChatPanel;
      
      private var _handlers:Dictionary;
      
      private var _cannedMessageControllers:Array;
      
      private var _cannedMessages:Array;
      
      private var _categoryButtons:Array;
      
      private var _categoryButtonControllers:Array;
      
      private var _chainLoader:ChainLoader;
      
      public function CannedChatPanelView(param1:ICannedChatPanel)
      {
         super();
         this._cannedChatPanel = param1;
         this.createHandlersDictionary();
         this.initializeStartState();
         this.initializeButtons();
         this.loadCannedChatData();
         param1.addSendMessageHandler(ISendMessageHandler(this));
      }
      
      public function clearMessage() : void
      {
      }
      
      private function onMoreButtonClick(param1:MouseEvent) : void
      {
         this._currentPhraseIndex += NUM_MESSAGE_SLOTS;
         if(this._currentPhraseIndex >= this._currentCategoryController.categoryPhrases.length)
         {
            this._currentPhraseIndex = 0;
         }
         this.populateMessages();
      }
      
      public function addTextChangedHandler(param1:ITextChangedHandler) : void
      {
         this._handlers[ITextChangedHandler][param1] = param1;
      }
      
      private function loadCannedChatData() : void
      {
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         _loc1_.add(new CannedChatDataChainLoadee());
         this._chainLoader = new ChainLoader(_loc1_,IChainLoaderConsumer(this));
         this._chainLoader.load();
      }
      
      public function get message() : String
      {
         return this._currentSelectedMessageController == null ? "" : this._currentSelectedMessageController.message;
      }
      
      public function removeSendMessageHandler(param1:ISendMessageHandler) : void
      {
         delete this._handlers[ISendMessageHandler][param1];
      }
      
      public function handleSendMessage() : void
      {
         var _loc1_:ISendMessageHandler = null;
         for each(_loc1_ in this._handlers[ISendMessageHandler])
         {
            _loc1_.handleSendMessage();
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** CannedChatPanelView: " + param1);
      }
      
      public function removeTextChangedHandler(param1:ITextChangedHandler) : void
      {
         delete this._handlers[ITextChangedHandler][param1];
      }
      
      private function onCategoryButtonClick(param1:MouseEvent) : void
      {
         this._currentCategoryController.active = false;
         var _loc2_:CategoryButtonController = param1.target.controller as CategoryButtonController;
         this._currentPhraseIndex = 0;
         this._currentCategoryController = _loc2_;
         this._currentCategoryController.active = true;
         this.populateMessages();
      }
      
      private function onMessageClick(param1:MouseEvent) : void
      {
         var _loc3_:ITextChangedHandler = null;
         var _loc2_:CannedMessageController = param1.target.controller as CannedMessageController;
         for each(_loc3_ in this._handlers[ITextChangedHandler])
         {
            _loc3_.handleTextChanged(_loc2_.messageText);
         }
         if(this._currentSelectedMessageController != null)
         {
            this._currentSelectedMessageController.active = false;
         }
         this._currentSelectedMessageController = _loc2_;
         this._currentSelectedMessageController.active = true;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CannedChatPanelView: " + param1);
      }
      
      private function initializeButtons() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         this._cannedChatPanel.more.buttonMode = true;
         this._cannedChatPanel.more.hitArea = this._cannedChatPanel.more.mcHitArea;
         this._cannedChatPanel.more.mcHitArea.visible = false;
         this._categoryButtons = [this._cannedChatPanel.category1,this._cannedChatPanel.category2,this._cannedChatPanel.category3,this._cannedChatPanel.category4,this._cannedChatPanel.category5,this._cannedChatPanel.category6];
         this._cannedMessages = [this._cannedChatPanel.cannedMessage1,this._cannedChatPanel.cannedMessage2,this._cannedChatPanel.cannedMessage3];
         this._categoryButtonControllers = new Array();
         for each(_loc1_ in this._categoryButtons)
         {
            this._categoryButtonControllers.push(new CategoryButtonController(_loc1_));
            _loc1_.addEventListener(MouseEvent.CLICK,this.onCategoryButtonClick);
         }
         this._cannedMessageControllers = new Array();
         for each(_loc2_ in this._cannedMessages)
         {
            this._cannedMessageControllers.push(new CannedMessageController(_loc2_));
            _loc2_.addEventListener(MouseEvent.CLICK,this.onMessageClick);
         }
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         this._cannedCategories = Dictionary(param1.getLoadedAsset(CannedChatDataChainLoadee.NAME));
         this.setCannedChatCategory(DEFAULT_CATEGORY);
         this._cannedChatPanel.more.addEventListener(MouseEvent.CLICK,this.onMoreButtonClick);
         this._chainLoader.destroy();
         this._chainLoader = null;
      }
      
      private function setCannedChatCategory(param1:String) : void
      {
         var _loc4_:* = undefined;
         if(this._cannedCategories[param1] == null)
         {
            this.log("Canned chat category: " + param1 + " not found.");
            return;
         }
         this.hideAllCategoriesAndMessages();
         var _loc2_:Dictionary = this._cannedCategories[param1];
         var _loc3_:int = 0;
         for(_loc4_ in _loc2_)
         {
            this._categoryButtonControllers[_loc3_].categoryText = String(_loc4_);
            this._categoryButtonControllers[_loc3_].categoryPhrases = _loc2_[_loc4_];
            this._categoryButtonControllers[_loc3_].title = String(_loc4_);
            if(_loc3_ == 0)
            {
               this._currentCategoryController = this._categoryButtonControllers[0];
               this._currentCategoryController.active = true;
            }
            this._categoryButtonControllers[_loc3_].show();
            _loc3_++;
         }
         this._currentPhraseIndex = 0;
         this.populateMessages();
      }
      
      private function populateMessages() : void
      {
         var _loc1_:CannedMessageController = null;
         if(this._currentSelectedMessageController != null)
         {
            this._currentSelectedMessageController.active = false;
         }
         this._currentSelectedMessageController = null;
         var _loc2_:int = 0;
         while(_loc2_ < NUM_MESSAGE_SLOTS)
         {
            _loc1_ = this._cannedMessageControllers[_loc2_];
            if(_loc2_ + this._currentPhraseIndex >= this._currentCategoryController.categoryPhrases.length)
            {
               _loc1_.hide();
            }
            else
            {
               _loc1_.show();
               _loc1_.messageText = this._currentCategoryController.categoryPhrases[_loc2_ + this._currentPhraseIndex];
               _loc1_.title = this._currentCategoryController.categoryPhrases[_loc2_ + this._currentPhraseIndex];
            }
            _loc2_++;
         }
      }
      
      private function hideAllCategoriesAndMessages() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         for each(_loc1_ in this._categoryButtons)
         {
            _loc1_.visible = false;
         }
         for each(_loc2_ in this._cannedMessages)
         {
            _loc2_.visible = false;
         }
      }
      
      private function onCannedChatDataError(param1:IOErrorEvent) : void
      {
         this.logError("onCannedChatDataError(): " + param1.text);
      }
      
      public function addSendMessageHandler(param1:ISendMessageHandler) : void
      {
         this._handlers[ISendMessageHandler][param1] = param1;
      }
      
      private function createHandlersDictionary() : void
      {
         this._handlers = new Dictionary();
         this._handlers[ITextChangedHandler] = new Dictionary(true);
         this._handlers[ISendMessageHandler] = new Dictionary(true);
      }
      
      private function initializeStartState() : void
      {
         this.hideAllCategoriesAndMessages();
      }
   }
}

