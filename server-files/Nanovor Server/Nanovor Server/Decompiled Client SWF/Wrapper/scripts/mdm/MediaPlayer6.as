package mdm
{
   public final class MediaPlayer6
   {
      
      private var resolver:mdm_MediaPlayer6 = null;
      
      public function MediaPlayer6(x:Number, y:Number, width:Number, height:Number, file:String)
      {
         super();
         resolver = new mdm_MediaPlayer6(this,x,y,width,height,file);
      }
      
      public function noMenu(syncFlag:Boolean = true) : void
      {
         resolver.noMenu();
      }
      
      public function hide(syncFlag:Boolean = true) : void
      {
         resolver.hide();
      }
      
      public function set volume(volumeValue:Number) : void
      {
         resolver.volume = volumeValue;
      }
      
      public function internal_resolver() : mdm_MediaPlayer6
      {
         return resolver;
      }
      
      public function fastForward(syncFlag:Boolean = true) : void
      {
         resolver.fastForward();
      }
      
      public function set y(y:Number) : void
      {
         resolver.y = y;
      }
      
      public function get width() : Number
      {
         return resolver.width;
      }
      
      public function set height(height:Number) : void
      {
         resolver.height = height;
      }
      
      public function get x() : Number
      {
         return resolver.x;
      }
      
      public function stop(syncFlag:Boolean = true) : void
      {
         resolver.stop();
      }
      
      public function set position(position:Number) : void
      {
         resolver.position = position;
      }
      
      public function set width(width:Number) : void
      {
         resolver.width = width;
      }
      
      public function get duration() : Number
      {
         return resolver.duration;
      }
      
      public function mute(muteFlag:Boolean, syncFlag:Boolean = true) : void
      {
         resolver.mute(muteFlag);
      }
      
      public function get volume() : Number
      {
         return resolver.volume;
      }
      
      public function get balance() : Number
      {
         return resolver.balance;
      }
      
      public function set visible(visible:Boolean) : void
      {
         resolver.visible = visible;
      }
      
      public function fastReverse(syncFlag:Boolean = true) : void
      {
         resolver.fastReverse();
      }
      
      public function get height() : Number
      {
         return resolver.height;
      }
      
      public function get canSeek() : Boolean
      {
         return resolver.canSeek;
      }
      
      public function get position() : Number
      {
         return resolver.position;
      }
      
      public function get canScan() : Boolean
      {
         return resolver.canScan;
      }
      
      public function get isInstalled() : Boolean
      {
         return resolver.isInstalled;
      }
      
      public function get visible() : Boolean
      {
         return resolver.visible;
      }
      
      public function play(syncFlag:Boolean = true) : void
      {
         resolver.play();
      }
      
      public function pause(syncFlag:Boolean = true) : void
      {
         resolver.pause();
      }
      
      public function set x(x:Number) : void
      {
         resolver.x = x;
      }
      
      public function close(syncFlag:Boolean = true) : void
      {
         resolver.close();
      }
      
      public function get y() : Number
      {
         return resolver.y;
      }
      
      public function fullscreen(syncFlag:Boolean = true) : void
      {
         resolver.fullscreen();
      }
      
      public function show(syncFlag:Boolean = true) : void
      {
         resolver.show();
      }
      
      public function set onMPChangeState(callback:Function) : void
      {
         resolver.onMPChangeState = callback;
      }
      
      public function set balance(balanceValue:Number) : void
      {
         resolver.balance = balanceValue;
      }
   }
}

import flash.utils.Proxy;

dynamic class mdm_MediaPlayer6 extends mdm_resolver
{
   
   public function mdm_MediaPlayer6(mp6:MediaPlayer6, x:Number, y:Number, width:Number, height:Number, file:String)
   {
      var arr:Array = null;
      var id:int = 0;
      super();
      SetClassName("mdm.MediaPlayer6");
      AddEvents();
      arr = new Array();
      arr.push(-1,x,y,width,height,file);
      SetDynamic(CallSync("create",arr));
      id = int(m_dynamicID);
      m_dynMP6[id] = mp6;
   }
   
   private function AddEvents() : void
   {
      AddDynamicEvent("onMPChangeState",true);
   }
}
