package com.arkadium.virmon.help.attackchooser
{
   import com.arkadium.virmon.battle.substates.combatgame.attackchooser.IActionPickerAutomation;
   import com.arkadium.virmon.help.attackchooser.attackselect.HelpAttackChooserAttackSelect;
   import com.arkadium.virmon.help.attackchooser.nanovorselect.HelpAttackChooserNanovorSelect;
   import com.arkadium.virmon.help.attackchooser.swap.HelpAttackChooserSwap;
   import com.arkadium.virmon.help.attackchooser.targetconfirm.HelpAttackChooserTargetConfirm;
   import com.arkadium.virmon.help.attackchooser.targetselect.HelpAttackChooserTargetSelect;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   
   public class HelpAttackChooser extends MovieClip implements IHelpAttackChooser
   {
      
      private var _nanovorSelectHelp:HelpAttackChooserNanovorSelect;
      
      private var _attackSelectHelp:HelpAttackChooserAttackSelect;
      
      private var _targetConfirmHelp:HelpAttackChooserTargetConfirm;
      
      private var _swapHelp:HelpAttackChooserSwap;
      
      private var _targetSelectHelp:HelpAttackChooserTargetSelect;
      
      public function HelpAttackChooser()
      {
         super();
      }
      
      public function showSwapHelp(param1:int = 0) : void
      {
         if(Boolean(_targetSelectHelp))
         {
            _targetSelectHelp.destroy();
            removeChild(_targetSelectHelp);
            _targetSelectHelp = null;
         }
         _swapHelp = new HelpAttackChooserSwap();
         addChild(_swapHelp);
         _swapHelp.start(param1);
      }
      
      public function destroy() : void
      {
         if(Boolean(_nanovorSelectHelp))
         {
            _nanovorSelectHelp.destroy();
            removeChild(_nanovorSelectHelp);
            _nanovorSelectHelp = null;
         }
         if(Boolean(_attackSelectHelp))
         {
            _attackSelectHelp.destroy();
            removeChild(_attackSelectHelp);
            _attackSelectHelp = null;
         }
         if(Boolean(_targetSelectHelp))
         {
            _targetSelectHelp.destroy();
            removeChild(_targetSelectHelp);
            _targetSelectHelp = null;
         }
         if(Boolean(_swapHelp))
         {
            _swapHelp.destroy();
            removeChild(_swapHelp);
            _swapHelp = null;
         }
         if(Boolean(_targetConfirmHelp))
         {
            _targetConfirmHelp.destroy();
            removeChild(_targetConfirmHelp);
            _targetConfirmHelp = null;
         }
      }
      
      public function showNanovorSelectHelp(param1:int = 0) : void
      {
         _nanovorSelectHelp = new HelpAttackChooserNanovorSelect();
         addChild(_nanovorSelectHelp);
         _nanovorSelectHelp.start(param1);
      }
      
      public function showAttackSelectHelp(param1:IActionPickerAutomation, param2:int = 0) : void
      {
         if(Boolean(_nanovorSelectHelp))
         {
            _nanovorSelectHelp.destroy();
            removeChild(_nanovorSelectHelp);
            _nanovorSelectHelp = null;
         }
         _attackSelectHelp = new HelpAttackChooserAttackSelect(param1);
         addChild(_attackSelectHelp);
         _attackSelectHelp.start(param2);
      }
      
      public function showTargetSelectHelp(param1:Array, param2:Boolean, param3:int = 0) : void
      {
         if(Boolean(_attackSelectHelp))
         {
            _attackSelectHelp.destroy();
            removeChild(_attackSelectHelp);
            _attackSelectHelp = null;
         }
         _targetSelectHelp = new HelpAttackChooserTargetSelect(param1,param2);
         addChild(_targetSelectHelp);
         _targetSelectHelp.start(param3);
      }
      
      public function showTargetConfirmHelp(param1:Array, param2:int, param3:Boolean, param4:int = 0) : void
      {
         if(Boolean(_swapHelp))
         {
            _swapHelp.destroy();
            removeChild(_swapHelp);
            _swapHelp = null;
         }
         _targetConfirmHelp = new HelpAttackChooserTargetConfirm(param1,param2,param3);
         addChild(_targetConfirmHelp);
         _targetConfirmHelp.start(param4);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("HelpAttackChooser>> " + param1);
      }
   }
}

