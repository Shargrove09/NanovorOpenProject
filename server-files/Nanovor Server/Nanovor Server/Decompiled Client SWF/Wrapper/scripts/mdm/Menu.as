package mdm
{
   public final class Menu
   {
      
      private static var resolver:mdm_Menu = null;
      
      public function Menu()
      {
         super();
      }
      
      private static function internal_resolver() : mdm_Menu
      {
         if(resolver == null)
         {
            resolver = new mdm_Menu();
         }
         return resolver;
      }
      
      public static function get Main() : mdm_resolver
      {
         return internal_resolver().Main;
      }
      
      public static function get Tray() : mdm_resolver
      {
         return internal_resolver().Tray;
      }
      
      public static function get Context() : mdm_resolver
      {
         return internal_resolver().Context;
      }
      
      public function mdm_Menu() : void
      {
      }
   }
}

import flash.utils.Proxy;

dynamic class mdm_MenuContext extends mdm_resolver
{
   
   public function mdm_MenuContext()
   {
      super();
      SetClassName("mdm.Menu.Context");
   }
}

dynamic class mdm_MenuTray extends mdm_resolver
{
   
   public function mdm_MenuTray()
   {
      super();
      SetClassName("mdm.Menu.Tray");
   }
}

dynamic class mdm_MenuMain extends mdm_resolver
{
   
   public function mdm_MenuMain()
   {
      super();
      SetClassName("mdm.Menu.Main");
   }
}

dynamic class mdm_Menu extends mdm_resolver
{
   
   public function mdm_Menu()
   {
      super();
      SetClassName("mdm.Menu");
      AddObject("Context",new mdm_MenuContext());
      AddObject("Main",new mdm_MenuMain());
      AddObject("Tray",new mdm_MenuTray());
   }
}
