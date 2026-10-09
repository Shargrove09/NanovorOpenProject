package com.arkadium.virmon.loginpanel.wait.view
{
   import com.arkadium.virmon.loginpanel.wait.controller.ILoginPanelWaitController;
   import com.arkadium.virmon.loginpanel.wait.model.ILoginPanelWaitModel;
   import com.arkadium.virmon.loginpanel.wait.model.handlers.IWaitProgressUpdateHandler;
   import com.arkadium.virmon.loginpanel.wait.model.handlers.IWaitStatusUpdateHandler;
   import com.arkadium.virmon.loginpanel.wait.view.components.LoginPanelWaitViewProgressBar;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol91")]
   public class LoginPanelWaitView extends Sprite implements ILoginPanelWaitView, IWaitProgressUpdateHandler, IWaitStatusUpdateHandler
   {
      
      public var mcLoadBar:LoginPanelWaitViewProgressBar;
      
      public var tfProgressInfo:TextField;
      
      public function LoginPanelWaitView(param1:ILoginPanelWaitModel, param2:ILoginPanelWaitController)
      {
         super();
         this.tfProgressInfo.text = "";
         param1.addWaitProgressUpdateHandler(IWaitProgressUpdateHandler(this));
         param1.addWaitStatusUpdateHandler(IWaitStatusUpdateHandler(this));
      }
      
      public function handleStatusUpdate(param1:String) : void
      {
         this.tfProgressInfo.text = param1;
      }
      
      public function handleUpdateProgress(param1:Number, param2:Number) : void
      {
         this.mcLoadBar.updateProgress(param1,param2);
      }
   }
}

