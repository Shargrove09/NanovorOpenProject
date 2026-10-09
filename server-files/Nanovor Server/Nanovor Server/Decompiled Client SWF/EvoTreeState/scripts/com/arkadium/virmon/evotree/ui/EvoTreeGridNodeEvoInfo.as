package com.arkadium.virmon.evotree.ui
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.evotree.IEvoTreeCanEvolveResponse;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol120")]
   public class EvoTreeGridNodeEvoInfo extends Sprite
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.4,
         "transition":Equations.easeInOutQuad
      };
      
      private static const TITLE_X:int = -132;
      
      private static const TITLE_X_OFFSET:int = 40;
      
      private var _titleField:TextField;
      
      public var mcMask:Sprite;
      
      public var mcTitleCantEvolve:Sprite;
      
      private var _reasonsField:TextField;
      
      public var mcTitleCanEvolve:Sprite;
      
      public var mcPane:MovieClip;
      
      public function EvoTreeGridNodeEvoInfo()
      {
         super();
         mcPane.mask = mcMask;
         mcTitleCanEvolve.alpha = 0;
         mcTitleCantEvolve.alpha = 0;
         removePane();
         _reasonsField = mcPane.tfReasons;
         _titleField = mcPane.tfTitle;
      }
      
      public function showPane() : void
      {
         Tweener.addTween(mcPane,{
            "x":0,
            "base":TWEEN_BASE
         });
      }
      
      public function setCantEvolveReasons(param1:IEvoTreeCanEvolveResponse) : void
      {
         _titleField.text = param1.destinationName;
         var _loc2_:String = "";
         _loc2_ += param1.requiredAccountBadges.join("\n");
         _loc2_ += param1.requiredAssetBadges.join("\n");
         _loc2_ += param1.requiredEMs.join("\n");
         _reasonsField.text = _loc2_;
      }
      
      public function hide() : void
      {
         Tweener.addTween(mcTitleCanEvolve,{
            "_autoAlpha":0,
            "x":TITLE_X + TITLE_X_OFFSET,
            "base":TWEEN_BASE
         });
         Tweener.addTween(mcTitleCantEvolve,{
            "_autoAlpha":0,
            "x":TITLE_X + TITLE_X_OFFSET,
            "base":TWEEN_BASE
         });
      }
      
      public function hidePane() : void
      {
         Tweener.addTween(mcPane,{
            "x":-200,
            "base":TWEEN_BASE
         });
      }
      
      private function removePane() : void
      {
         if(null != mcPane.parent)
         {
            mcPane.parent.removeChild(mcPane);
         }
      }
      
      public function show(param1:Boolean) : void
      {
         hide();
         if(param1)
         {
            removePane();
         }
         else
         {
            mcPane.x = -200;
            this.addChild(mcPane);
         }
      }
   }
}

