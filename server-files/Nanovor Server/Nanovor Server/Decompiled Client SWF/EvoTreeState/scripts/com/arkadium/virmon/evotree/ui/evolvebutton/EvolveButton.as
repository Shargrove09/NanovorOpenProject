package com.arkadium.virmon.evotree.ui.evolvebutton
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.evotree.IEvoTreeCanEvolveResponse;
   import com.arkadium.virmon.evotree.evolver.IEvoTreeEvolver;
   import com.arkadium.virmon.evotree.ui.evolvebutton.checkmarks.EvoCheckMarkCanEvolve;
   import com.arkadium.virmon.evotree.ui.evolvebutton.checkmarks.EvoCheckMarkCantEvolve;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol41")]
   public class EvolveButton extends Sprite
   {
      
      private static const REQUIREMENTS_SPACE:Rectangle = new Rectangle(-130,-110,210,84);
      
      private static const REQUIREMENTS_PADDING:int = 4;
      
      private static const PARTIAL_REQUIREMENT:RegExp = /\s\([1-9]+\/[0-9]+\)/;
      
      private static const CHECKMARK_OFFSET:Point = new Point(-18,-2);
      
      public var mcEvolve:Sprite;
      
      public var mcRequirements:EvolveButtonRequirements;
      
      public var tfRequirements1:TextField;
      
      public var tfRequirements2:TextField;
      
      public var tfRequirements3:TextField;
      
      public var tfRequirements4:TextField;
      
      private var _evolver:IEvoTreeEvolver;
      
      private var _requirementFields:Array;
      
      public var mcRedDot:Sprite;
      
      public var mcCantEvolve:Sprite;
      
      private var _checkMarks:Dictionary;
      
      public var mcYellowDot:Sprite;
      
      public function EvolveButton(param1:IEvoTreeCanEvolveResponse, param2:IEvoTreeEvolver, param3:Boolean = true)
      {
         var _loc5_:TextField = null;
         super();
         _evolver = param2;
         _requirementFields = [tfRequirements1,tfRequirements2,tfRequirements3,tfRequirements4];
         _checkMarks = new Dictionary();
         var _loc4_:Boolean = Boolean(null != _evolver);
         for each(_loc5_ in _requirementFields)
         {
            initializeRequirementField(_loc5_);
         }
         initializeEvolver(_loc4_);
         setRequirements(_loc4_,param1,param3);
         mcEvolve.addEventListener(MouseEvent.ROLL_OVER,handleRollOver);
         mcEvolve.addEventListener(MouseEvent.ROLL_OUT,handleRollOut);
         mcCantEvolve.addEventListener(MouseEvent.ROLL_OVER,handleRollOver);
         mcCantEvolve.addEventListener(MouseEvent.ROLL_OUT,handleRollOut);
         this.mouseEnabled = false;
         mcRedDot.mouseEnabled = false;
         mcYellowDot.mouseEnabled = false;
         mcRequirements.mouseEnabled = false;
         mcRequirements.mouseChildren = false;
      }
      
      private function handleClick(param1:MouseEvent) : void
      {
         _evolver.evolveNanovor();
      }
      
      private function handleRollOut(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:Sprite = null;
         mcRequirements.close();
         for each(_loc2_ in _requirementFields)
         {
            Tweener.addTween(_loc2_,{
               "alpha":0,
               "time":0.5
            });
         }
         for each(_loc3_ in _checkMarks)
         {
            Tweener.addTween(_loc3_,{
               "alpha":0,
               "time":0.5
            });
         }
      }
      
      private function positionRequirementFields(param1:int, param2:Dictionary) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TextField = null;
         var _loc9_:Sprite = null;
         param1 = Math.min(_requirementFields.length,param1);
         var _loc3_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param1)
         {
            _loc5_ = _requirementFields[_loc4_];
            _loc3_ += _loc5_.height;
            _loc4_++;
         }
         var _loc6_:int = (REQUIREMENTS_SPACE.height - _loc3_) / (_requirementFields.length - 1);
         var _loc7_:int = Math.min(REQUIREMENTS_PADDING,_loc6_);
         var _loc8_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param1)
         {
            _loc5_ = _requirementFields[_loc4_];
            _loc5_.y = _loc8_ + REQUIREMENTS_SPACE.y;
            _loc8_ += _loc5_.height + _loc7_;
            _loc9_ = param2[_loc5_];
            if(null != _loc9_)
            {
               _loc9_.x = _loc5_.x + CHECKMARK_OFFSET.x;
               _loc9_.y = _loc5_.y + CHECKMARK_OFFSET.y;
               _loc9_.alpha = 0;
               this.addChild(_loc9_);
            }
            _loc4_++;
         }
      }
      
      private function condenseRequirements(param1:Array, param2:Array, param3:Array) : Array
      {
         var _loc4_:Array = new Array();
         if(0 < param1.length)
         {
            _loc4_.push(param1.join(", ") + " EMs needed.");
         }
         _loc4_ = _loc4_.concat(param2);
         return _loc4_.concat(param3);
      }
      
      private function checkForPartialRequirements(param1:Array) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            if(PARTIAL_REQUIREMENT.test(_loc2_))
            {
               return true;
            }
         }
         return false;
      }
      
      private function appendPrefixToAllElements(param1:String, param2:Array) : Array
      {
         var _loc4_:String = null;
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = param2[_loc3_];
            param2[_loc3_] = param1 + _loc4_;
            _loc3_++;
         }
         return param2;
      }
      
      private function setRequirements(param1:Boolean, param2:IEvoTreeCanEvolveResponse, param3:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc13_:Sprite = null;
         var _loc4_:Boolean = false;
         mcRequirements.setCanEvolve(param1);
         mcRequirements.scaleY = param3 ? 1 : -1;
         var _loc6_:Array = appendPrefixToAllElements("Player: ",param2.aquiredAccountBadges);
         var _loc7_:Array = appendPrefixToAllElements("Player: ",param2.requiredAccountBadges);
         var _loc8_:Array = appendPrefixToAllElements("Nanovor: ",param2.aquiredAssetBadges);
         var _loc9_:Array = appendPrefixToAllElements("Nanovor: ",param2.requiredAssetBadges);
         var _loc10_:Array = condenseRequirements(param2.aquiredEMs,_loc6_,_loc8_);
         var _loc11_:Array = condenseRequirements(param2.requiredEMs,_loc7_,_loc9_);
         if(0 < _loc10_.length)
         {
            _loc4_ = true;
         }
         var _loc12_:Array = _requirementFields.slice();
         addRequirements(true,_loc10_,_loc12_,_checkMarks);
         addRequirements(false,_loc11_,_loc12_,_checkMarks);
         _loc4_ = checkForPartialRequirements(_loc11_) ? true : _loc4_;
         positionRequirementFields(_requirementFields.length - _loc12_.length,_checkMarks);
         if(!param1)
         {
            _loc13_ = _loc4_ ? mcRedDot : mcYellowDot;
            if(null != _loc13_.parent)
            {
               _loc13_.parent.removeChild(_loc13_);
            }
         }
      }
      
      private function initializeEvolver(param1:Boolean) : void
      {
         if(param1)
         {
            mcEvolve.buttonMode = true;
            mcEvolve.addEventListener(MouseEvent.CLICK,handleClick);
         }
         else
         {
            this.removeChild(mcEvolve);
         }
      }
      
      private function initializeRequirementField(param1:TextField) : void
      {
         param1.text = "";
         param1.autoSize = TextFieldAutoSize.LEFT;
         param1.wordWrap = true;
         param1.width = REQUIREMENTS_SPACE.width;
         param1.alpha = 0;
         param1.mouseEnabled = false;
      }
      
      private function addRequirements(param1:Boolean, param2:Array, param3:Array, param4:Dictionary) : void
      {
         var _loc5_:String = null;
         for each(_loc5_ in param2)
         {
            addRequirement(param1,_loc5_,param3,param4);
         }
      }
      
      private function addRequirement(param1:Boolean, param2:String, param3:Array, param4:Dictionary) : void
      {
         var _loc6_:Sprite = null;
         if(0 == param3.length)
         {
            return;
         }
         var _loc5_:TextField = param3.shift();
         _loc5_.text = param2;
         _loc6_ = param1 ? new EvoCheckMarkCanEvolve() : new EvoCheckMarkCantEvolve();
         _loc6_.mouseEnabled = false;
         _loc6_.alpha = 0;
         _checkMarks[_loc5_] = _loc6_;
      }
      
      private function handleRollOver(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:Sprite = null;
         mcRequirements.open();
         for each(_loc2_ in _requirementFields)
         {
            Tweener.addTween(_loc2_,{
               "alpha":1,
               "time":0.5,
               "delay":0.25
            });
         }
         for each(_loc3_ in _checkMarks)
         {
            Tweener.addTween(_loc3_,{
               "alpha":1,
               "time":0.5,
               "delay":0.25
            });
         }
      }
   }
}

