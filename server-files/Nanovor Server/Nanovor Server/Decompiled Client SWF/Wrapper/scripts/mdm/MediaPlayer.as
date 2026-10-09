package mdm
{
   public final class MediaPlayer
   {
      
      private var resolver:mdm_MediaPlayer9 = null;
      
      public function MediaPlayer(x:Number, y:Number, width:Number, height:Number, uiMode:String, contextMenu:Boolean, stretch:Boolean, file:String)
      {
         super();
         resolver = new mdm_MediaPlayer9(this,x,y,width,height,uiMode,contextMenu,stretch,file);
      }
      
      public function hide(syncFlag:Boolean = true) : void
      {
         resolver.hide();
      }
      
      public function set source(sourcePath:String) : void
      {
         resolver.source = sourcePath;
      }
      
      public function internal_resolver() : mdm_MediaPlayer9
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
      
      public function get currentMarker() : Number
      {
         return resolver.currentMarker;
      }
      
      public function get duration() : Number
      {
         return resolver.duration;
      }
      
      public function set onWMPBuffering(callback:Function) : void
      {
         resolver.onWMPBuffering = callback;
      }
      
      public function get mediaName() : String
      {
         return resolver.mediaName;
      }
      
      public function mute(muteFlag:Boolean, syncFlag:Boolean = true) : void
      {
         resolver.mute(muteFlag);
      }
      
      public function get mediaWidth() : Number
      {
         return resolver.mediaWidth;
      }
      
      public function get source() : String
      {
         return resolver.source;
      }
      
      public function get balance() : Number
      {
         return resolver.balance;
      }
      
      public function set onWMPError(callback:Function) : void
      {
         resolver.onWMPError = callback;
      }
      
      public function set onWMPChangeState(callback:Function) : void
      {
         resolver.onWMPChangeState = callback;
      }
      
      public function get volume() : Number
      {
         return resolver.volume;
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
      
      public function get mediaHeight() : Number
      {
         return resolver.mediaHeight;
      }
      
      public function get canScan() : Boolean
      {
         return resolver.canScan;
      }
      
      public function set width(width:Number) : void
      {
         resolver.width = width;
      }
      
      public function set onWMPPositionChanged(callback:Function) : void
      {
         resolver.onWMPPositionChanged = callback;
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
      
      public function set currentMarker(markerValue:Number) : void
      {
         resolver.currentMarker = markerValue;
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
      
      public function featureAvailable(featureName:String) : Boolean
      {
         return resolver.featureAvailable(featureName);
      }
      
      public function set volume(volumeValue:Number) : void
      {
         resolver.volume = volumeValue;
      }
      
      public function get markerCount() : Number
      {
         return resolver.markerCount;
      }
      
      public function show(syncFlag:Boolean = true) : void
      {
         resolver.show();
      }
      
      public function set balance(balanceValue:Number) : void
      {
         resolver.balance = balanceValue;
      }
   }
}

import flash.utils.Proxy;

dynamic class mdm_MediaPlayer9 extends mdm_resolver
{
   
   public function mdm_MediaPlayer9(mp9:MediaPlayer, x:Number, y:Number, width:Number, height:Number, uiMode:String, contextMenu:Boolean, stretch:Boolean, file:String)
   {
      var arr:Array = null;
      var id:int = 0;
      super();
      SetClassName("mdm.MediaPlayer");
      AddEvents();
      arr = new Array();
      arr.push(-1,x,y,width,height,uiMode,contextMenu,stretch,file);
      SetDynamic(CallSync("create",arr));
      id = int(m_dynamicID);
      m_dynMP9[id] = mp9;
   }
   
   private function AddEvents() : void
   {
      AddDynamicEvent("onWMPChangeState",true);
      AddDynamicEvent("onWMPBuffering",true);
      AddDynamicEvent("onWMPError",true);
      AddDynamicEvent("onWMPPositionChanged",true);
   }
}
