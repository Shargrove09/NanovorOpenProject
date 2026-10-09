package com.arkadium.virmon.shared.final.components.actionslot
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.final.elements.CondensedTextLeft;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   
   public class ActionSlotWithRollout extends ActionSlotComponent
   {
      
      private static const CONSEQUENCE_ICON_X_TWEEN_TIME:Number = 0.5;
      
      private var _consequenceSlots:Dictionary;
      
      private var _attackDescription:CondensedTextLeft = null;
      
      private var _consequenceContainer:Sprite;
      
      private var _stayOpen:Boolean = false;
      
      private var _consequenceOpen:Boolean = false;
      
      private var _rollout:RolloutComponent;
      
      public function ActionSlotWithRollout(param1:ISoundManager, param2:IAttack = null, param3:Number = 1000)
      {
         var _loc4_:TextFormat = null;
         _consequenceContainer = new Sprite();
         super(param2);
         mcLine.visible = false;
         this.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
         _rollout = new RolloutComponent(ActionSlotComponent.WIDTH,param3);
         this.addChildAt(_rollout,0);
         this.addChild(_consequenceContainer);
         if(param2 != null)
         {
            _attackDescription = new CondensedTextLeft(param2.pcDescription);
            _loc4_ = new TextFormat();
            _loc4_.size = 13;
            _attackDescription.textfield.setTextFormat(_loc4_);
         }
         else
         {
            _attackDescription = new CondensedTextLeft("");
         }
         _attackDescription.x = 190;
         _attackDescription.y = -2;
         _attackDescription.visible = false;
         _attackDescription.alpha = 0;
         _attackDescription.cacheAsBitmap = true;
         this.addChild(_attackDescription);
      }
      
      override public function set backgroundState(param1:int) : void
      {
         if(_stayOpen)
         {
            param1 = BACKGROUND_STATE_SOLID;
         }
         super.backgroundState = param1;
      }
      
      override public function set disabled(param1:Boolean) : void
      {
         super.disabled = param1;
         if(param1)
         {
         }
      }
      
      public function open(param1:Boolean = false) : void
      {
         var _loc2_:ActionSlotStatIconComponent = null;
         _rollout.open(param1);
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Attack_AttackChoice1",true,SoundManagerConst.soundApplicationDomain));
         for each(_loc2_ in icons)
         {
            if(_loc2_.selfAttack)
            {
               _loc2_.showSelfAttackChaser = true;
            }
         }
      }
      
      override public function set color(param1:uint) : void
      {
         super.color = param1;
         _rollout.color = param1;
      }
      
      public function hideDescription() : void
      {
         Tweener.removeTweens(_attackDescription,"alpha");
         Tweener.addTween(_attackDescription,{
            "alpha":0,
            "time":0.3,
            "transition":"easeOutQuad",
            "onComplete":function():*
            {
               _attackDescription.visible = false;
            }
         });
      }
      
      public function set stayOpen(param1:Boolean) : void
      {
         _stayOpen = param1;
      }
      
      public function openConsequencesForTarget(param1:INanovor, param2:Array, param3:int) : void
      {
         var enemy:Object = null;
         var numSelfAttackIcons:int = 0;
         var iconIndex:String = null;
         var aAttackPreviews:Array = null;
         var nanovor:INanovor = param1;
         var enemyPositions:Array = param2;
         var iPlayerId:int = param3;
         if(_consequenceOpen)
         {
            return;
         }
         _consequenceOpen = true;
         _attackDescription.visible = true;
         Tweener.removeTweens(_attackDescription,"alpha");
         Tweener.addTween(_attackDescription,{
            "alpha":1,
            "time":0.3,
            "transition":"easeOutQuad"
         });
         if(_consequenceSlots == null)
         {
            _consequenceSlots = new Dictionary();
            for each(enemy in enemyPositions)
            {
               _consequenceSlots[enemy] = new ConsequenceSlot(attack);
               _consequenceContainer.addChild(_consequenceSlots[enemy]);
            }
         }
         for each(enemy in enemyPositions)
         {
            _consequenceSlots[enemy].visible = Boolean(enemy.player.userRefId == iPlayerId);
         }
         numSelfAttackIcons = 0;
         for(iconIndex in icons)
         {
            if(!icons[iconIndex].selfAttack)
            {
               Tweener.removeTweens(icons[iconIndex]);
               Tweener.addTween(icons[iconIndex],{
                  "alpha":0,
                  "time":0.5,
                  "transition":"easeOutQuad"
               });
            }
            else
            {
               numSelfAttackIcons++;
            }
         }
         try
         {
            aAttackPreviews = nanovor.owner.attackPreviews[String(attack.attackID)].players;
         }
         catch(err:Error)
         {
            DebugLog.instance.error("** ActionSlotWithRollout: (rsk) caught error, which I think occurs when the swap picker is still opening up as the attack chooser is being brought out of view:\n" + err.getStackTrace());
            return;
         }
         for each(enemy in enemyPositions)
         {
            (_consequenceSlots[enemy] as ConsequenceSlot).setInfo(aAttackPreviews[enemy.player.userRefId],numSelfAttackIcons);
            (_consequenceSlots[enemy] as ConsequenceSlot).open(CONSEQUENCE_ICON_X_TWEEN_TIME);
            Tweener.removeTweens(_consequenceSlots[enemy],x);
            Tweener.addTween(_consequenceSlots[enemy],{
               "x":enemy.xPosition,
               "time":CONSEQUENCE_ICON_X_TWEEN_TIME,
               "transition":"easeOutQuad",
               "rounded":true
            });
         }
      }
      
      public function closeConsequences(param1:Array) : void
      {
         var iEnd:int;
         var nTime:Number;
         var i:int = 0;
         var enemyPositions:Array = param1;
         if(_stayOpen || !_consequenceOpen)
         {
            return;
         }
         _consequenceOpen = false;
         Tweener.removeTweens(_attackDescription,"alpha");
         Tweener.addTween(_attackDescription,{
            "alpha":0,
            "time":0.3,
            "transition":"easeOutQuad",
            "onComplete":function():*
            {
               _attackDescription.visible = false;
            }
         });
         iEnd = _consequenceContainer.numChildren;
         nTime = iEnd == 0 ? CONSEQUENCE_ICON_X_TWEEN_TIME : CONSEQUENCE_ICON_X_TWEEN_TIME * (_consequenceContainer.getChildAt(0).x / enemyPositions[0].xPosition);
         i = 0;
         while(i < iEnd)
         {
            (_consequenceContainer.getChildAt(i) as ConsequenceSlot).close(nTime,nTime);
            Tweener.removeTweens(_consequenceContainer.getChildAt(i),"x");
            if(i < iEnd - 1)
            {
               Tweener.addTween(_consequenceContainer.getChildAt(i),{
                  "x":0,
                  "time":nTime,
                  "transition":"easeOutQuad"
               });
            }
            else
            {
               Tweener.addTween(_consequenceContainer.getChildAt(i),{
                  "x":0,
                  "time":nTime,
                  "transition":"easeOutQuad",
                  "onComplete":restoreIcons
               });
            }
            i++;
         }
      }
      
      public function startArrowChaser() : void
      {
         _rollout.startArrowChaser();
      }
      
      private function restoreIcons() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in icons)
         {
            Tweener.addTween(icons[_loc1_],{
               "alpha":1,
               "time":0.3,
               "transition":"easeOutQuad"
            });
         }
      }
      
      public function set consequenceSlotsColor(param1:uint) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in _consequenceSlots)
         {
            (_consequenceSlots[_loc2_] as ConsequenceSlot).color = param1;
         }
      }
      
      public function close(param1:Boolean = false) : void
      {
         var _loc2_:ActionSlotStatIconComponent = null;
         if(!_stayOpen)
         {
            _rollout.close(param1);
            Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Attack_AttackChoice2",true,SoundManagerConst.soundApplicationDomain));
         }
         for each(_loc2_ in icons)
         {
            if(_loc2_.selfAttack)
            {
               _loc2_.showSelfAttackChaser = false;
            }
         }
      }
      
      public function openConsequences(param1:INanovor, param2:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         if(_consequenceOpen)
         {
            return;
         }
         _consequenceOpen = true;
         _attackDescription.visible = true;
         Tweener.removeTweens(_attackDescription,"alpha");
         Tweener.addTween(_attackDescription,{
            "alpha":1,
            "time":0.3,
            "transition":"easeOutQuad"
         });
         if(_consequenceSlots == null)
         {
            _consequenceSlots = new Dictionary();
            for each(_loc3_ in param2)
            {
               _consequenceSlots[_loc3_] = new ConsequenceSlot(attack);
               _consequenceContainer.addChild(_consequenceSlots[_loc3_]);
            }
         }
         for each(_loc3_ in param2)
         {
            _consequenceSlots[_loc3_].visible = !(Boolean(_loc3_.player.isDead) || Boolean(_loc3_.player.leftGame));
         }
         _loc4_ = 0;
         for(_loc5_ in icons)
         {
            if(!icons[_loc5_].selfAttack)
            {
               Tweener.removeTweens(icons[_loc5_]);
               Tweener.addTween(icons[_loc5_],{
                  "alpha":0,
                  "time":0.5,
                  "transition":"easeOutQuad"
               });
            }
            else
            {
               _loc4_++;
            }
         }
         _loc6_ = param1.owner.attackPreviews[String(attack.attackID)].players;
         for each(_loc3_ in param2)
         {
            (_consequenceSlots[_loc3_] as ConsequenceSlot).setInfo(_loc6_[_loc3_.player.userRefId],_loc4_);
            (_consequenceSlots[_loc3_] as ConsequenceSlot).open(CONSEQUENCE_ICON_X_TWEEN_TIME);
            Tweener.removeTweens(_consequenceSlots[_loc3_],x);
            Tweener.addTween(_consequenceSlots[_loc3_],{
               "x":_loc3_.xPosition,
               "time":CONSEQUENCE_ICON_X_TWEEN_TIME,
               "transition":"easeOutQuad"
            });
         }
      }
      
      public function set direction(param1:String) : void
      {
         if(param1 != "right")
         {
            _rollout.scaleX = -1;
            _rollout.x = ActionSlotComponent.WIDTH;
         }
         else
         {
            _rollout.scaleX = 1;
            _rollout.x = 0;
         }
      }
      
      public function showDescription() : void
      {
         _attackDescription.visible = true;
         Tweener.removeTweens(_attackDescription,"alpha");
         Tweener.addTween(_attackDescription,{
            "alpha":1,
            "time":0.3,
            "transition":"easeOutQuad"
         });
      }
   }
}

