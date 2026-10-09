package mdm
{
   public final class Browser
   {
      
      private var resolver:mdm_Browser = null;
      
      public function Browser(x:Number, y:Number, width:Number, height:Number, url:String, showBorder:Boolean = false)
      {
         super();
         resolver = new mdm_Browser(this,x,y,width,height,url,showBorder);
      }
      
      public function get y() : Number
      {
         return internal_resolver().y;
      }
      
      public function hide(syncFlag:Boolean = true) : void
      {
         internal_resolver().hide();
      }
      
      public function get isBusy() : Boolean
      {
         return internal_resolver().isBusy;
      }
      
      public function forward(syncFlag:Boolean = true) : void
      {
         internal_resolver().forward();
      }
      
      public function internal_resolver() : mdm_Browser
      {
         return resolver;
      }
      
      public function stop(syncFlag:Boolean = true) : void
      {
         internal_resolver().stop();
      }
      
      public function set y(y:Number) : void
      {
         internal_resolver().y = y;
      }
      
      public function get width() : Number
      {
         return internal_resolver().width;
      }
      
      public function get favorities() : Array
      {
         return internal_resolver().favourites;
      }
      
      public function setSourceInTarget(content:String, target:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().setSourceInTarget(content,target);
      }
      
      public function printHTMLHeader(htmlText:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().printHTMLHeader(htmlText);
      }
      
      public function set height(height:Number) : void
      {
         internal_resolver().height = height;
      }
      
      public function printMargins(left:Number = 1, right:Number = 1, top:Number = 1, bottom:Number = 1, syncFlag:Boolean = true) : void
      {
         internal_resolver().printMargins(left,right,top,bottom);
      }
      
      public function printHeader(headerText:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().printHeader(headerText);
      }
      
      public function gotoTarget(urlString:String, targetId:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().gotoTarget(urlString,targetId);
      }
      
      public function addFavorite(url:String, description:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().addFavorite(url,description);
      }
      
      public function set url(url:String) : void
      {
         internal_resolver().url = url;
      }
      
      public function get title() : String
      {
         return internal_resolver().title;
      }
      
      public function printCopies(numberOfCopies:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().printCopies(numberOfCopies);
      }
      
      public function refresh(syncFlag:Boolean = true) : void
      {
         internal_resolver().refresh();
      }
      
      public function printPreview(syncFlag:Boolean = true) : void
      {
         internal_resolver().printPreview();
      }
      
      public function goto(url:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().goto(url);
      }
      
      public function set visible(visible:Boolean) : void
      {
         internal_resolver().visible = visible;
      }
      
      public function set onDocumentComplete(callback:Function) : void
      {
         internal_resolver().onDocumentComplete = callback;
      }
      
      public function back(syncFlag:Boolean = true) : void
      {
         internal_resolver().back();
      }
      
      public function printFooter(footerText:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().printCopies(footerText);
      }
      
      public function printOrientation(orientation:String = "portrait", syncFlag:Boolean = true) : void
      {
         internal_resolver().printfOrientation(orientation);
      }
      
      public function print(showPrintDialog:Boolean = false, syncFlag:Boolean = true) : void
      {
         internal_resolver().print(showPrintDialog);
      }
      
      public function get height() : Number
      {
         return internal_resolver().height;
      }
      
      public function get source() : String
      {
         return internal_resolver().source;
      }
      
      public function set x(x:Number) : void
      {
         internal_resolver().x = x;
      }
      
      public function get visible() : Boolean
      {
         return internal_resolver().visible;
      }
      
      public function set userAgent(userAgentData:String) : void
      {
         internal_resolver().userAgent = userAgentData;
      }
      
      public function set source(source:String) : void
      {
         internal_resolver().source = source;
      }
      
      public function close(syncFlag:Boolean = true) : void
      {
         internal_resolver().close();
      }
      
      public function set width(width:Number) : void
      {
         internal_resolver().width = width;
      }
      
      public function show(syncFlag:Boolean = true) : void
      {
         internal_resolver().show();
      }
      
      public function get url() : String
      {
         return internal_resolver().url;
      }
      
      public function get x() : Number
      {
         return internal_resolver().x;
      }
   }
}

import flash.utils.Proxy;

dynamic class mdm_Browser extends mdm_resolver
{
   
   private var m_parent:Browser = null;
   
   public function mdm_Browser(browser:Browser, x:Number, y:Number, width:Number, height:Number, object:String, border:Boolean)
   {
      var arr:Array = null;
      var id:int = 0;
      m_parent = null;
      super();
      SetClassName("mdm.Browser");
      AddEvents();
      arr = new Array();
      arr.push(-1,x,y,width,height,object,border);
      SetDynamic(CallSync("create",arr));
      id = int(m_dynamicID);
      m_dynBrowsers[id] = browser;
   }
   
   private function AddEvents() : void
   {
      AddDynamicEvent("onDocumentComplete",true);
   }
}
