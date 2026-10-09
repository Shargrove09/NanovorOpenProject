package com.arkadium.virmon.loginpanel.wait.view.components
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol89")]
   public class LoginPanelWaitViewProgressBar extends Sprite
   {
      
      private static const LOADING_TEXT:Array = ["LOADING","LOADING.","LOADING..","LOADING..."];
      
      private static const PROGRESS_X_EMPTY:int = -314;
      
      private static const PROGRESS_X_FULL:int = 128;
      
      private static const PROGRESS_X_DELTA:int = PROGRESS_X_FULL - PROGRESS_X_EMPTY;
      
      public var mcProgress:Sprite;
      
      public var tfLoading:TextField;
      
      private var _currentTextIndex:int;
      
      public function LoginPanelWaitViewProgressBar()
      {
         super();
         this._currentTextIndex = 0;
         this.mcProgress.x = PROGRESS_X_EMPTY;
      }
      
      private function updateLoadingText() : void
      {
         this.tfLoading.text = LOADING_TEXT[this._currentTextIndex % LOADING_TEXT.length];
         ++this._currentTextIndex;
      }
      
      public function updateProgress(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = 0 == param2 ? 0 : param1 / param2;
         var _loc4_:int = PROGRESS_X_EMPTY + PROGRESS_X_DELTA * _loc3_;
         Tweener.addTween(this.mcProgress,{
            "x":_loc4_,
            "time":0.25,
            "transition":Equations.easeInOutQuad
         });
         this.updateLoadingText();
      }
   }
}

