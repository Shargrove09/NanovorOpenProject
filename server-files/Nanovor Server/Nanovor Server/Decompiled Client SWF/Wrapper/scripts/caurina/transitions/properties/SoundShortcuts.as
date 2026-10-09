package caurina.transitions.properties
{
   import caurina.transitions.Tweener;
   import flash.media.SoundTransform;
   
   public class SoundShortcuts
   {
      
      public function SoundShortcuts()
      {
         super();
         trace("This is an static class and should not be instantiated.");
      }
      
      public static function init() : void
      {
         Tweener.registerSpecialProperty("_sound_volume",_sound_volume_get,_sound_volume_set);
         Tweener.registerSpecialProperty("_sound_pan",_sound_pan_get,_sound_pan_set);
      }
      
      public static function _sound_pan_set(param1:Object, param2:Number, param3:Array, param4:Object = null) : void
      {
         var _loc5_:SoundTransform = param1.soundTransform;
         _loc5_.pan = param2;
         param1.soundTransform = _loc5_;
      }
      
      public static function _sound_volume_set(param1:Object, param2:Number, param3:Array, param4:Object = null) : void
      {
         var _loc5_:SoundTransform = param1.soundTransform;
         _loc5_.volume = param2;
         param1.soundTransform = _loc5_;
      }
      
      public static function _sound_pan_get(param1:Object, param2:Array, param3:Object = null) : Number
      {
         return param1.soundTransform.pan;
      }
      
      public static function _sound_volume_get(param1:Object, param2:Array, param3:Object = null) : Number
      {
         return param1.soundTransform.volume;
      }
   }
}

