package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.external.*;
   import flash.net.SharedObject;
   import flash.net.XMLSocket;
   import flash.system.*;
   import flash.utils.*;
   import mdm.*;
   
   use namespace flash_proxy;
   
   public dynamic class mdm_resolver extends Proxy
   {
      
      private static var m_properties:Object;
      
      protected static var m_macSocket:XMLSocket;
      
      public static var m_spr:Sprite;
      
      private static var m_doneInit:Boolean = false;
      
      protected static var m_strFormID:String = "!}id}!";
      
      protected static var m_macPort:int = -1;
      
      protected static var m_events:Object = new Object();
      
      protected static var m_eventsCallbackType:Object = new Object();
      
      private static var m_cbID:int = 0;
      
      protected static var m_dynFTP:Object = new Object();
      
      protected static var m_dynHTTP:Object = new Object();
      
      protected static var m_dynMP6:Object = new Object();
      
      protected static var m_dynMP9:Object = new Object();
      
      protected static var m_dynBrowsers:Object = new Object();
      
      protected static var m_bSimulate:Boolean = false;
      
      private static var m_cmdCounter:int = 0;
      
      private static var m_strURL:String = null;
      
      public static var ids:int = 0;
      
      private static var m_bTestedEI:Boolean = false;
      
      private static var m_bHaveEI:Boolean = false;
      
      private var m_strClassName:String = null;
      
      private var strPropsMac:String = "Application<{!!z!!}>path<{z}>string<{z}>ppsv<{z}>Macintosh HD:<{!z!}>pathUnix<{z}>string<{z}>ppsv<{z}>/<{!z!}>openedFilename<{z}>string<{z}>get<{z}><{!z!}>openedFilenameUnix<{z}>string<{z}>get<{z}><{!z!}>filename<{z}>string<{z}>ppsv<{z}>Macintosh HD:Users:<{!z!}>filenameUnix<{z}>string<{z}>ppsv<{z}>/Users/Contents/MacOS/files<{!z!}><{!z!!}>System<{!!z!!}>screenWidth<{z}>string<{z}>ppsv<{z}>1024<{!z!}>screenHeight<{z}>string<{z}>ppsv<{z}>768<{!z!}>localTime<{z}>string<{z}>get<{z}><{!z!}>macVerString<{z}>string<{z}>ppsv<{z}>Mac OS X 10.4.7<{!z!}><{!z!!}>System.Paths<{!!z!!}>fonts<{z}>string<{z}>ppsv<{z}>Macintosh HD:System:Library:Fonts:<{!z!}>desktop<{z}>string<{z}>ppsv<{z}>Macintosh HD:Users:user:Desktop:<{!z!}>temp<{z}>string<{z}>ppsv<{z}>Macintosh HD:private:var:tmp:folders.501:TemporaryItems:<{!z!}>desktopUnix<{z}>string<{z}>ppsv<{z}>/Users/user/Desktop<{!z!}>tempUnix<{z}>string<{z}>ppsv<{z}>/private/var/tmp/folders.501/TemporaryItems<{!z!}>fontsUnix<{z}>string<{z}>ppsv<{z}>/System/Library/Fonts<{!z!}>preferences<{z}>string<{z}>ppsv<{z}>Macintosh HD:Users:user:Library:Preferences:<{!z!}>preferencesUnix<{z}>string<{z}>ppsv<{z}>/Users/user/Library/Preferences<{!z!}><{!z!!}>MacShell<{!!z!!}>exitCode<{z}>string<{z}>get<{z}> <{!z!}>output<{z}>string<{z}>get<{z}> <{!z!}>isRunning<{z}>boolean<{z}>get<{z}> <{!z!}><{!z!!}>AppleScript<{!!z!!}><{!z!!}>Application.Library<{!!z!!}><{!z!!}>Encryption<{!!z!!}><{!z!!}>Network.Mail<{!!z!!}><{!z!!}>Image<{!!z!!}><{!z!!}>Dialogs<{!!z!!}><{!z!!}>Image.ScreenCapture<{!!z!!}><{!z!!}>Database<{!!z!!}><{!z!!}>Database.MySQL<{!!z!!}><{!z!!}>Exception<{!!z!!}><{!z!!}>Input<{!!z!!}><{!z!!}>Input.Mouse<{!!z!!}><{!z!!}>Dialogs.BrowseFolder<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Dialogs.BrowseFile<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>filterList<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>creatorCode<{z}>string<{z}>getset<{z}> <{!z!}>buttonText<{z}>string<{z}>getset<{z}> <{!z!}>dialogText<{z}>string<{z}>getset<{z}> <{!z!}>allowMultiple<{z}>boolean<{z}>getset<{z}> <{!z!}><{!z!!}>Dialogs.BrowseFileToSave<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>creatorCode<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Menu.Main<{!!z!!}>menuType<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Network<{!!z!!}>IPAddress<{z}>string<{z}>getset<{z}> <{!z!}>isPresent<{z}>string<{z}>ppsv<{z}>true<{!z!}><{!z!!}>FileSystem<{!!z!!}><{!z!!}>@Browser<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>url<{z}>string<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}>source<{z}>string<{z}>getset<{z}>0<{!z!}>title<{z}>string<{z}>get<{z}>0<{!z!}>isBusy<{z}>boolean<{z}>get<{z}>false<{!z!}>favorites<{z}>array<{z}>get<{z}>[]<{!z!}>useragent<{z}>string<{z}>set<{z}>0<{!z!}><{!z!!}>@Forms<{!!z!!}>id<{z}>string<{z}>@set<{z}>0<{!z!}>type<{z}>string<{z}>@set<{z}>standard<{!z!}>isCreated<{z}>string<{z}>getset<{!z!}>x<{z}>string<{z}>getset<{!z!}>y<{z}>string<{z}>getset<{!z!}>width<{z}>string<{z}>getset<{!z!}>height<{z}>string<{z}>getset<{!z!}>title<{z}>string<{z}>getset<{!z!}>visible<{z}>boolean<{z}>getset<{!z!}><{!z!!}>@HTTP<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}><{!z!!}>";
      
      protected var m_dynEvents:Object;
      
      private var strProps:String = "Extensions<{!!z!!}><{!z!!}>Extensions.kernel32<{!!z!!}><{!z!!}>GlobalVariables<{!!z!!}><{z}>string<{z}>ppsv<{z}><{!z!}><{!z!!}>@Browser<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>url<{z}>string<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}>source<{z}>string<{z}>getset<{z}>0<{!z!}>title<{z}>string<{z}>get<{z}>0<{!z!}>isBusy<{z}>boolean<{z}>get<{z}>false<{!z!}>favorites<{z}>array<{z}>get<{z}>[]<{!z!}>useragent<{z}>string<{z}>set<{z}>0<{!z!}><{!z!!}>@ActiveX<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}><{!z!!}>@MediaPlayer6<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>balance<{z}>string<{z}>getset<{z}>0<{!z!}>volume<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>true<{!z!}>canSeek<{z}>boolean<{z}>getset<{z}>false<{!z!}>canScan<{z}>boolean<{z}>getset<{z}>false<{!z!}><{!z!!}>@MediaPlayer9<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>currentMarker<{z}>string<{z}>getset<{z}>0<{!z!}>volume<{z}>string<{z}>getset<{z}>0<{!z!}>balance<{z}>string<{z}>getset<{z}>0<{!z!}>markerCount<{z}>string<{z}>getset<{z}>0<{!z!}>source<{z}>string<{z}>getset<{z}>0<{!z!}>mediaName<{z}>string<{z}>getset<{z}>0<{!z!}>mediaWidth<{z}>string<{z}>getset<{z}>0<{!z!}>mediaHeight<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>0<{!z!}>canSeek<{z}>boolean<{z}>getset<{z}>false<{!z!}>canScan<{z}>boolean<{z}>getset<{z}>false<{!z!}><{!z!!}>@QuickTime<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>0<{!z!}><{!z!!}>@RealMedia<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>0<{!z!}><{!z!!}>@Shockwave<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>bgcolor<{z}>string<{z}>getset<{z}>0<{!z!}>currentFrame<{z}>string<{z}>getset<{z}>0<{!z!}><{!z!!}>@PDF7<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>scrollbars<{z}>string<{z}>getset<{z}>0<{!z!}>toolbar<{z}>string<{z}>getset<{z}>0<{!z!}><{!z!!}>@PDF6<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>scrollbars<{z}>string<{z}>getset<{z}>0<{!z!}>toolbar<{z}>string<{z}>getset<{z}>0<{!z!}><{!z!!}>Application<{!!z!!}>title<{z}>string<{z}>getset<{z}> <{!z!}>isMinimized<{z}>boolean<{z}>get<{z}> <{!z!}>path<{z}>string<{z}>ppsv<{z}>C:\\projects\\fsp2.0\\fsp2.0wrap_newtrans\\<{!z!}>pathUnicode<{z}>string<{z}>ppsv<{z}>C:projects\fsp2.0\fsp2.0wrap_newtrans<{!z!}>filename<{z}>string<{z}>ppsv<{z}>fwrapper.exe<{!z!}>filenameUnicode<{z}>string<{z}>ppsv<{z}>fwrapper.exe<{!z!}><{!z!!}>Application.Screensaver<{!!z!!}><{!z!!}>System<{!!z!!}>localTime<{z}>string<{z}>getset<{z}> <{!z!}>CPUSpeed<{z}>string<{z}>getset<{z}> <{!z!}>RAMSize<{z}>string<{z}>getset<{z}> <{!z!}>screenWidth<{z}>string<{z}>ppsv<{z}>1280<{!z!}>screenHeight<{z}>string<{z}>ppsv<{z}>1024<{!z!}>computerName<{z}>string<{z}>ppsv<{z}>STAV<{!z!}>computerCompany<{z}>string<{z}>ppsv<{z}><{!z!}>computerOwner<{z}>string<{z}>ppsv<{z}> <{!z!}>winVerString<{z}>string<{z}>ppsv<{z}>Windows XP<{!z!}>language<{z}>string<{z}>ppsv<{z}>English (United Kingdom)<{!z!}>winVerStringDetail<{z}>string<{z}>ppsv<{z}>Microsoft Windows XP Professional<{!z!}>osVersion<{z}>string<{z}>getset<{z}> <{!z!}>CDDrive<{z}>string<{z}>getset<{z}> <{!z!}>servicePack<{z}>string<{z}>ppsv<{z}>Service Pack 2<{!z!}>isAdmin<{z}>boolean<{z}>ppsv<{z}>true<{!z!}><{!z!!}>System.Paths<{!!z!!}>programs<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerStart MenuPrograms<{!z!}>programFiles<{z}>string<{z}>ppsv<{z}>C:Program Files<{!z!}>windows<{z}>string<{z}>ppsv<{z}>C:WINDOWS<{!z!}>system<{z}>string<{z}>ppsv<{z}>C:WINDOWSsystem32<{!z!}>temp<{z}>string<{z}>ppsv<{z}>C:DOCUME~1OwnerLOCALS~1Temp<{!z!}>desktop<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerDesktop<{!z!}>personal<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerMy Documents<{!z!}>favorites<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerFavorites<{!z!}>startup<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerStart MenuProgramsStartup<{!z!}>recent<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerRecent<{!z!}>fonts<{z}>string<{z}>ppsv<{z}>C:WINDOWSFonts<{!z!}>history<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerLocal SettingsHistory<{!z!}>cookies<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerCookies<{!z!}>network<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerNetHood<{!z!}>startMenu<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerStart Menu<{!z!}>appData<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerApplication Data<{!z!}>commonAdminTools<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuProgramsAdministrative Tools<{!z!}>commonAppData<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersApplication Data<{!z!}>commonPrograms<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuPrograms<{!z!}>commonStartMenu<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart Menu<{!z!}>commonStartup<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuProgramsStartup<{!z!}>allUsersAppData<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersApplication Data<{!z!}>allUsersPrograms<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuPrograms<{!z!}>allUsersStartMenu<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart Menu<{!z!}>allUsersStartup<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuProgramsStartup<{!z!}><{!z!!}>Dialogs.BrowseFile<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>filterList<{z}>string<{z}>getset<{z}> <{!z!}>defaultExtension<{z}>string<{z}>getset<{z}> <{!z!}>buttonText<{z}>string<{z}>getset<{z}> <{!z!}>filterText<{z}>string<{z}>getset<{z}> <{!z!}>defaultFilename<{z}>string<{z}>getset<{z}> <{!z!}>allowMultiple<{z}>boolean<{z}>getset<{z}> <{!z!}><{!z!!}>Dialogs<{!z!!}>Dialogs.BrowseFileUnicode<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>filterList<{z}>string<{z}>getset<{z}> <{!z!}>defaultExtension<{z}>string<{z}>getset<{z}> <{!z!}>defaultFilename<{z}>string<{z}>getset<{z}> <{!z!}>allowMultiple<{z}>boolean<{z}>getset<{z}> <{!z!}><{!z!!}>Menu<{!!z!!}><{!z!!}>Menu.Tray<{!!z!!}>iconHint<{z}>string<{z}>set<{z}> <{!z!}>menuType<{z}>string<{z}>set<{z}> <{!z!}><{!z!!}>Menu.Main<{!!z!!}>menuType<{z}>string<{z}>set<{z}> <{!z!}><{!z!!}>Menu.Context<{!!z!!}>menuType<{z}>string<{z}>set<{z}> <{!z!}><{!z!!}>Database.MySQL<{!!z!!}><{!z!!}>Database<{!!z!!}><{!z!!}>Database.MSAccess<{!!z!!}><{!z!!}>Database.ADO<{!!z!!}><{!z!!}>FileExplorer<{!!z!!}><{!z!!}>FileExplorer.ComboBox<{!!z!!}><{!z!!}>FileExplorer.ListView<{!!z!!}><{!z!!}>FileExplorer.TreeView<{!!z!!}><{!z!!}>Input.Mouse<{!!z!!}><{!z!!}>Input.Joystick<{!!z!!}><{!z!!}>Input.Tablet<{!!z!!}><{!z!!}>String<{!!z!!}><{!z!!}>@DLL<{!!z!!}><{!z!!}>Network<{!!z!!}>IPAddress<{z}>string<{z}>getset<{z}> <{!z!}>isPresent<{z}>string<{z}>ppsv<{z}>true<{!z!}><{!z!!}>Process<{!!z!!}>lastId<{z}>integer<{z}>get<{z}>-1<{!z!}>isOpen<{z}>boolean<{z}>get<{z}>false<{!z!}><{!z!!}>@FTP<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>initialDir<{z}>string<{z}>getset<{z}> <{!z!}>currentDir<{z}>string<{z}>getset<{z}> <{!z!}>isConnected<{z}>boolean<{z}>getset<{z}> <{!z!}>account<{z}>string<{z}>getset<{z}> <{!z!}>async<{z}>boolean<{z}>getset<{z}> <{!z!}>error<{z}>string<{z}>getset<{z}> <{!z!}>success<{z}>boolean<{z}>getset<{z}> <{!z!}>loggerData<{z}>string<{z}>getset<{z}> <{!z!}>isBusy<{z}>boolean<{z}>getset<{z}> <{!z!}>lastReply<{z}>string<{z}>getset<{z}> <{!z!}>noop<{z}>string<{z}>getset<{z}> <{!z!}>passive<{z}>string<{z}>getset<{z}> <{!z!}>serverType<{z}>string<{z}>getset<{z}> <{!z!}>supportsResume<{z}>boolean<{z}>getset<{z}> <{!z!}>timeout<{z}>string<{z}>getset<{z}> <{!z!}>transferMode<{z}>string<{z}>getset<{z}> <{!z!}>transferTime<{z}>string<{z}>getset<{z}> <{!z!}>bytesTransferred<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>@Forms<{!!z!!}>id<{z}>string<{z}>@set<{z}>0<{!z!}>type<{z}>string<{z}>@set<{z}>standard<{!z!}>title<{z}>string<{z}>@set<{!z!}>titleUnicode<{z}>string<{z}>@set<{!z!}>alpha<{z}>number<{z}>getset<{!z!}>baseURL<{z}>string<{z}>getset<{!z!}>bgColor<{z}>string<{z}>getset<{!z!}>isCreated<{z}>boolean<{z}>get<{!z!}>windowState<{z}>string<{z}>getset<{!z!}>x<{z}>string<{z}>getset<{!z!}>y<{z}>string<{z}>getset<{!z!}>width<{z}>string<{z}>getset<{!z!}>height<{z}>string<{z}>getset<{!z!}>visible<{z}>boolean<{z}>getset<{!z!}><{!z!!}>COMPort<{!!z!!}>initialDTR<{z}>string<{z}>getset<{z}>-1<{!z!}>initialRTS<{z}>string<{z}>getset<{z}> <{!z!}>txBuffer<{z}>integer<{z}>set<{z}> <{!z!}>rxBuffer<{z}>integer<{z}>set<{z}> <{!z!}>ports<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Flash<{!z!!}>FileSystem<{!z!!}>Network.UDP.Socket<{!z!!}>System.DirectX<{!z!!}>Network.Mail<{!z!!}>Dialogs.BrowseFolder<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>System.JScript<{!z!!}>System.VBScript<{!z!!}>Encryption<{!z!!}>Image<{!z!!}>Image.ScreenCapture<{!z!!}>Exception<{!z!!}>Exception.DebugWindow<{!z!!}>Network.UDP.TFTP<{!z!!}>Network.HTTPD<{!z!!}>System.Registry<{!z!!}>Network.TCP.ProxyHTTP<{!z!!}>Clipboard<{!z!!}>Input.Twain<{!z!!}>Application.Library<{!z!!}>Network.TCP.FileServer<{!z!!}>Application.Timer<{!z!!}>Application.Trial<{!!z!!}>usesLeft<{z}>integer<{z}>ppsv<{z}><{!z!}>daysLeft<{z}>integer<{z}>ppsv<{z}><{!z!}>tampered<{z}>boolean<{z}>get<{z}><{!z!}>expired<{z}>boolean<{z}>get<{z}><{!z!}><{!z!!}>FileSystem.BinaryFile<{!z!!}>@HTTP<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}><{!z!!}>";
      
      protected var m_dynamicID:int = -1;
      
      protected var m_dynEventsCallbackType:Object;
      
      private var alert:MovieClip;
      
      private var m_dynamic:Boolean = false;
      
      protected var m_objs:Object;
      
      public function mdm_resolver()
      {
         super();
         m_objs = new Object();
         m_dynEvents = new Object();
         m_dynEventsCallbackType = new Object();
      }
      
      private static function OnEvent(strEvent:String) : void
      {
         var doneInit:Boolean = false;
         var strForm:String = null;
         var strParams:String = null;
         var arr:Array = null;
         var strFunc:String = null;
         var dynamicClass:Boolean = false;
         var strCmd:String = null;
         var id:int = 0;
         var obj:Object = null;
         var ftp:FTP = null;
         var browser:Browser = null;
         var http:HTTP = null;
         var mp6:MediaPlayer6 = null;
         var mp9:MediaPlayer = null;
         var strTimer:String = null;
         var strParams2:String = null;
         var arr2:Array = null;
         var arrFiles:Array = null;
         doneInit = m_doneInit;
         strParams = strEvent;
         arr = strParams.split("!}}v{}!");
         strFunc = arr[0];
         if(Boolean(arr.length))
         {
            arr.shift();
         }
         dynamicClass = false;
         strCmd = "";
         id = 0;
         obj = new Object();
         if(strFunc.substr(0,5) == "onFTP")
         {
            dynamicClass = true;
            if(Boolean(arr.length))
            {
               id = arr.shift();
            }
            if(id >= 0)
            {
               strCmd = "on" + strFunc.slice(5);
               ftp = m_dynFTP[id];
               if(ftp != null)
               {
                  if(ftp.internal_resolver().m_dynEvents[strCmd] != null)
                  {
                     ftp.internal_resolver().m_dynEvents[strCmd]();
                  }
               }
            }
         }
         else if(strFunc.substr(0,9) == "onBrowser")
         {
            dynamicClass = true;
            if(Boolean(arr.length))
            {
               id = arr.shift();
            }
            if(id >= 0)
            {
               strCmd = "on" + strFunc.slice(9);
               browser = m_dynBrowsers[id];
               if(browser != null)
               {
                  if(browser.internal_resolver().m_dynEvents[strCmd] != null)
                  {
                     if(strCmd == "onDocumentComplete")
                     {
                        obj["url"] = arr[0];
                        browser.internal_resolver().m_dynEvents[strCmd](obj);
                     }
                  }
               }
            }
         }
         else if(strFunc.substr(0,6) == "onHTTP")
         {
            dynamicClass = true;
            if(Boolean(arr.length))
            {
               id = arr.shift();
            }
            if(id >= 0)
            {
               strCmd = "on" + strFunc.slice(6);
               http = m_dynHTTP[id];
               if(http != null)
               {
                  if(http.internal_resolver().m_dynEvents[strCmd] != null)
                  {
                     if(strCmd == "onBinaryTransferComplete")
                     {
                        obj["filename"] = arr[0];
                        http.internal_resolver().m_dynEvents[strCmd](obj);
                     }
                     else if(strCmd == "onError")
                     {
                        http.internal_resolver().m_dynEvents[strCmd]();
                     }
                     else if(strCmd == "onProgress")
                     {
                        obj["bytesTotal"] = arr[0];
                        obj["bytesTransferred"] = arr[1];
                        http.internal_resolver().m_dynEvents[strCmd](obj);
                     }
                     else if(strCmd == "onTransferComplete")
                     {
                        obj["data"] = arr[0];
                        http.internal_resolver().m_dynEvents[strCmd](obj);
                     }
                  }
               }
            }
         }
         else if(strFunc.substr(0,6) == "onWMP6")
         {
            dynamicClass = true;
            if(Boolean(arr.length))
            {
               id = arr.shift();
            }
            if(id >= 0)
            {
               strCmd = strFunc;
               mp6 = m_dynMP6[id];
               if(mp6 != null)
               {
                  if(mp6.internal_resolver().m_dynEvents[strCmd] != null)
                  {
                     if(strCmd == "onMPChangeState")
                     {
                        obj["oldState"] = arr[0];
                        obj["newState"] = arr[1];
                        mp6.internal_resolver().m_dynEvents[strCmd](obj);
                     }
                  }
               }
            }
         }
         else if(strFunc.substr(0,5) == "onWMP")
         {
            dynamicClass = true;
            if(Boolean(arr.length))
            {
               id = arr.shift();
            }
            if(id >= 0)
            {
               strCmd = strFunc;
               mp9 = m_dynMP9[id];
               if(mp9 != null)
               {
                  if(mp9.internal_resolver().m_dynEvents[strCmd] != null)
                  {
                     if(strCmd == "onWMPBuffering")
                     {
                        obj["status"] = arr[0];
                        mp9.internal_resolver().m_dynEvents[strCmd](obj);
                     }
                     else if(strCmd == "onWMPChangeState")
                     {
                        obj["newState"] = arr[0];
                        mp9.internal_resolver().m_dynEvents[strCmd](obj);
                     }
                     else if(strCmd == "onWMPError")
                     {
                        obj["error"] = arr[0];
                        mp9.internal_resolver().m_dynEvents[strCmd](obj);
                     }
                     else if(strCmd == "onWMPPositionChanged")
                     {
                        obj["newPosition"] = arr[0];
                        mp9.internal_resolver().m_dynEvents[strCmd](obj);
                     }
                  }
               }
            }
         }
         if(!dynamicClass)
         {
            strCmd = strFunc;
            if(strFunc.substr(0,11) == "onMenuClick")
            {
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd]();
               }
            }
            else if(strFunc.substr(0,18) == "onContextMenuClick")
            {
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd]();
               }
            }
            else if(strFunc.substr(0,15) == "onTrayMenuClick")
            {
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd]();
               }
            }
            if(strFunc.substr(0,6) == "onForm")
            {
               if(strCmd == "onFormChangeFocus")
               {
                  strForm = arr.shift();
                  obj["status"] = arr[0];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onFormClose")
               {
                  strForm = arr.shift();
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd]();
                  }
               }
               else if(strCmd == "onFormMaximize")
               {
                  strForm = arr.shift();
                  obj["clientWidth"] = arr[0];
                  obj["clientHeight"] = arr[1];
                  obj["width"] = arr[2];
                  obj["height"] = arr[3];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onFormMinimize")
               {
                  strForm = arr.shift();
                  obj["clientWidth"] = arr[0];
                  obj["clientHeight"] = arr[1];
                  obj["width"] = arr[2];
                  obj["height"] = arr[3];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onFormReposition")
               {
                  strForm = arr.shift();
                  obj["x"] = arr[0];
                  obj["y"] = arr[1];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onFormResize")
               {
                  strForm = arr.shift();
                  obj["clientWidth"] = arr[0];
                  obj["clientHeight"] = arr[1];
                  obj["width"] = arr[2];
                  obj["height"] = arr[3];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onFormRestore")
               {
                  strForm = arr.shift();
                  obj["clientWidth"] = arr[0];
                  obj["clientHeight"] = arr[1];
                  obj["width"] = arr[2];
                  obj["height"] = arr[3];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
            }
            else if(strCmd == "onAppExit" || strCmd == "onAppMinimize" || strCmd == "onAppRestore" || strCmd == "onBottomHit" || strCmd == "onLeftHit" || strCmd == "onRightHit" || strCmd == "onSplashClosed" || strCmd == "onTopHit")
            {
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd]();
               }
            }
            else if(strCmd.substr(0,10) == "onAppTimer")
            {
               strTimer = "onTimer" + strCmd.substr(10);
               if(m_events[strTimer] != null)
               {
                  m_events[strTimer]();
               }
            }
            else if(strCmd == "AppExit")
            {
               if(m_events["onAppExit"] != null)
               {
                  m_events["onAppExit"]();
               }
            }
            else if(strCmd == "onArrowKeyPress")
            {
               obj["status"] = arr[0];
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd](obj);
               }
            }
            else if(strCmd == "onAppChangeFocus")
            {
               obj["status"] = arr[0];
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd](obj);
               }
            }
            else if(strCmd == "onDragDrop")
            {
               strParams2 = strEvent;
               arr2 = strParams2.split("!}}v{}!");
               arrFiles = arr2[1].split("|");
               obj["files"] = arrFiles;
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd](obj);
               }
               obj["files"] = null;
            }
            else if(strCmd == "onMDMScriptException")
            {
               obj["formType"] = arr[0];
               obj["command"] = arr[1];
               obj["message"] = arr[2];
               obj["frameNumber"] = arr[3];
               obj["parameter"] = arr[4];
               obj["value"] = arr[5];
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd](obj);
               }
            }
            else if(strFunc.substr(0,5) == "onCOM")
            {
               if(strCmd == "onCOMPortCTSChanged")
               {
                  obj["timeCode"] = arr[0];
                  obj["state"] = arr[1];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onCOMPortDSRChanged")
               {
                  obj["timeCode"] = arr[0];
                  obj["state"] = arr[1];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onCOMPortData")
               {
                  obj["timeCode"] = arr[0];
                  obj["data"] = arr[1];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onCOMPortHEXData")
               {
                  obj["timeCode"] = arr[0];
                  obj["hexData"] = arr[1];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onCOMPortDataSent")
               {
                  obj["timeCode"] = arr[0];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onCOMPortError")
               {
                  obj["timeCode"] = arr[0];
                  obj["error"] = arr[1];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
               else if(strCmd == "onCOMPortSendProgress")
               {
                  obj["timeCode"] = arr[0];
                  obj["bytes"] = arr[1];
                  if(m_events[strCmd] != null)
                  {
                     m_events[strCmd](obj);
                  }
               }
            }
            else if(strCmd == "onFileListViewDblClick")
            {
               obj["type"] = arr[0];
               obj["name"] = arr[1];
               obj["association"] = arr[2];
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd](obj);
               }
            }
            else if(strCmd == "onJoystick1ButtonDown" || strCmd == "onJoystick1Move" || strCmd == "onJoystick2ButtonDown" || strCmd == "onJoystick2Move")
            {
               obj["xlevel"] = arr[0];
               obj["ylevel"] = arr[1];
               obj["b1"] = arr[2];
               obj["b2"] = arr[3];
               obj["b3"] = arr[4];
               obj["b4"] = arr[5];
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd](obj);
               }
            }
            else if(strCmd == "onTabletEvent")
            {
               obj["x"] = arr[0];
               obj["y"] = arr[1];
               obj["pressure"] = arr[2];
               obj["buttons"] = arr[3];
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd](obj);
               }
            }
            else if(strCmd == "onRequest")
            {
               obj["document"] = arr[0];
               obj["parameters"] = arr[1];
               obj["remoteIP"] = arr[2];
               if(m_events[strCmd] != null)
               {
                  m_events[strCmd](obj);
               }
            }
            else if(strFunc.substr(0,5) == "onUDP")
            {
               if(strCmd == "onUDPSocketData")
               {
                  obj["data"] = arr[0];
                  if(m_events["onData"] != null)
                  {
                     m_events["onData"](obj);
                  }
               }
            }
            else if(strFunc.substr(0,5) == "onTCP")
            {
               if(strCmd == "onTCPSocketData")
               {
                  obj["data"] = arr[0];
                  if(m_events["onSocketData"] != null)
                  {
                     m_events["onSocketData"](obj);
                  }
               }
               else if(strCmd == "onTCPSocketConnect")
               {
                  if(m_events["onSocketConnect"] != null)
                  {
                     m_events["onSocketConnect"]();
                  }
               }
               else if(strCmd == "onTCPSocketClose")
               {
                  if(m_events["onSocketClose"] != null)
                  {
                     m_events["onSocketClose"]();
                  }
               }
            }
         }
         obj = null;
      }
      
      public static function AssocURL(strURL:String) : void
      {
         m_strURL = strURL;
      }
      
      public static function InitCallbacks() : void
      {
         ExternalInterface.addCallback("MDMAS3EVENTCALLBACK",eventCallback);
      }
      
      public static function eventCallback(strEvent:String) : void
      {
         OnEvent(strEvent);
      }
      
      private function InitialiseObject(strObjDef:String) : void
      {
         var objDef:Array = null;
         var objName:String = null;
         var a:Object = null;
         var index:int = 0;
         var key:String = null;
         var objProps:Array = null;
         var i:int = 0;
         objDef = strObjDef.split("<{!!z!!}>");
         objName = objDef[0];
         a = m_properties;
         index = objName.charAt(0) == "@" ? 1 : 0;
         key = String("mdm." + objName.substring(index));
         if(objName.substring(0,11) == "Extensions.")
         {
            ExtensionsArray.push(objName.slice(11));
         }
         else
         {
            m_properties[key] = new Array();
            if(objDef[1] != null)
            {
               objProps = objDef[1].split("<{!z!}>");
               for(i = 0; i < objProps.length; i++)
               {
                  m_properties[key][i] = objProps[i].split("<{z}>");
               }
            }
         }
      }
      
      private function Deserialise(strInput:String) : *
      {
         var index:int = 0;
         var ch:String = null;
         var GetNextChar:Function = null;
         var TrimWhiteSpace:Function = null;
         var DeserialiseString:Function = null;
         var DeserialiseArray:Function = null;
         var DeserialiseObject:Function = null;
         var DeserialiseNumber:Function = null;
         var DeserialiseDate:Function = null;
         var DeserialiseXML:Function = null;
         var DeserialiseBoolean:Function = null;
         var DeserialiseValue:Function = null;
         GetNextChar = function():String
         {
            ch = strInput.charAt(index);
            index += 1;
            return ch;
         };
         TrimWhiteSpace = function():void
         {
            while(Boolean(ch))
            {
               if(ch <= " ")
               {
                  GetNextChar();
                  continue;
               }
               if(ch != "/")
               {
                  break;
               }
               switch(GetNextChar())
               {
                  case "/":
                     while(GetNextChar() && ch != "\n" && ch != "\r")
                     {
                     }
                     break;
                  case "*":
                     for(GetNextChar(); true; )
                     {
                        if(Boolean(ch))
                        {
                           if(ch == "*")
                           {
                              if(GetNextChar() == "/")
                              {
                                 GetNextChar();
                                 break;
                              }
                           }
                           else
                           {
                              GetNextChar();
                           }
                        }
                     }
               }
            }
         };
         DeserialiseString = function():String
         {
            var i:int = 0;
            var s:String = null;
            var t:int = 0;
            var u:int = 0;
            var outer:Boolean = false;
            s = "";
            outer = false;
            if(ch == "\"")
            {
               while(Boolean(GetNextChar()))
               {
                  if(index == strInput.length || ch == "\"")
                  {
                     if(ch == "\"")
                     {
                        GetNextChar();
                     }
                     return s.split("@q@").join("\"");
                  }
                  s += ch;
               }
            }
            return new String();
         };
         DeserialiseArray = function():Array
         {
            var a:Array = null;
            a = [];
            if(ch == "[")
            {
               GetNextChar();
               TrimWhiteSpace();
               if(ch == "]")
               {
                  GetNextChar();
                  return a;
               }
               while(Boolean(ch))
               {
                  a.push(DeserialiseValue());
                  TrimWhiteSpace();
                  if(ch == "]")
                  {
                     GetNextChar();
                     return a;
                  }
                  if(ch != ",")
                  {
                     break;
                  }
                  GetNextChar();
                  TrimWhiteSpace();
               }
            }
            return new Array();
         };
         DeserialiseObject = function():Object
         {
            var k:String = null;
            var o:Object = null;
            o = {};
            if(ch == "{")
            {
               GetNextChar();
               TrimWhiteSpace();
               if(ch == "}")
               {
                  GetNextChar();
                  return o;
               }
               while(Boolean(ch))
               {
                  k = DeserialiseString();
                  TrimWhiteSpace();
                  if(ch != ":")
                  {
                     break;
                  }
                  GetNextChar();
                  o[k] = DeserialiseValue();
                  TrimWhiteSpace();
                  if(ch == "}")
                  {
                     GetNextChar();
                     return o;
                  }
                  if(ch != ",")
                  {
                     break;
                  }
                  GetNextChar();
                  TrimWhiteSpace();
               }
            }
            return new Object();
         };
         DeserialiseNumber = function():Number
         {
            var n:String = null;
            var v:Number = NaN;
            n = "";
            if(ch == "-")
            {
               n = "-";
               GetNextChar();
            }
            while(ch >= "0" && ch <= "9")
            {
               n += ch;
               GetNextChar();
            }
            if(ch == ".")
            {
               n += ".";
               while(GetNextChar() && ch >= "0" && ch <= "9")
               {
                  n += ch;
               }
            }
            v = Number(n);
            if(!isFinite(v))
            {
               return Number(0);
            }
            return Number(v);
         };
         DeserialiseDate = function():Date
         {
            var d:String = null;
            d = "";
            if(ch == "#")
            {
               while(Boolean(GetNextChar()))
               {
                  if(ch == "#")
                  {
                     GetNextChar();
                     return new Date(parseInt(d));
                  }
                  d += ch;
               }
            }
            return new Date();
         };
         DeserialiseXML = function():XML
         {
            var x:String = null;
            var end:int = 0;
            x = "";
            if(ch == "<")
            {
               GetNextChar();
               GetNextChar();
               end = strInput.indexOf("</*>");
               while(Boolean(GetNextChar()))
               {
                  if(index == end - 1)
                  {
                     while(index < end + 5)
                     {
                        GetNextChar();
                     }
                     return new XML(x);
                  }
                  x += ch;
               }
            }
            return new XML();
         };
         DeserialiseBoolean = function():*
         {
            switch(ch)
            {
               case "t":
                  if(GetNextChar() == "r" && GetNextChar() == "u" && GetNextChar() == "e")
                  {
                     GetNextChar();
                     return true;
                  }
                  break;
               case "f":
                  if(GetNextChar() == "a" && GetNextChar() == "l" && GetNextChar() == "s" && GetNextChar() == "e")
                  {
                     GetNextChar();
                     return false;
                  }
                  break;
               case "n":
                  if(GetNextChar() == "u" && GetNextChar() == "l" && GetNextChar() == "l")
                  {
                     GetNextChar();
                     return null;
                  }
            }
            return "";
         };
         DeserialiseValue = function():*
         {
            TrimWhiteSpace();
            switch(ch)
            {
               case "{":
                  return DeserialiseObject();
               case "[":
                  return DeserialiseArray();
               case "\"":
                  return DeserialiseString();
               case "-":
                  return DeserialiseNumber();
               case "#":
                  return DeserialiseDate();
               case "<":
                  return DeserialiseXML();
               default:
                  return ch >= "0" && ch <= "9" ? DeserialiseNumber() : DeserialiseBoolean();
            }
         };
         index = 0;
         ch = " ";
         return DeserialiseValue();
      }
      
      protected function SetClassName(strClassName:String) : void
      {
         m_strClassName = strClassName;
      }
      
      private function SendCmdMac(strCmd:String) : void
      {
         var soName:String = null;
         var soVar:String = null;
         var currCmdCounter:int = 0;
         var outstr:String = null;
         var chunkSize:int = 0;
         var numChunks:int = 0;
         var cmdso:SharedObject = null;
         var strNumChunk:String = null;
         var i:int = 0;
         var temp:String = null;
         var s:String = null;
         if(GetHostPlatform() == "Mac")
         {
            soName = "xppcmd";
            soVar = "s000000000000";
            currCmdCounter = int(++m_cmdCounter);
            outstr = strCmd + currCmdCounter.toString();
            chunkSize = 64000;
            numChunks = Math.round(outstr.length / chunkSize) + 1;
            cmdso = SharedObject.getLocal(soName,"/",false);
            strNumChunk = numChunks.toString();
            cmdso.data.v = "\r";
            cmdso.data.v += "s000000000000";
            cmdso.data.v += "\x02";
            cmdso.data.v += "\x00";
            cmdso.data.v += "\x01";
            cmdso.data.v += numChunks.toString();
            cmdso.data.v += "\x00";
            cmdso.data.v += "\x00";
            cmdso.data.v += "\r";
            for(i = 1; i <= numChunks; i++)
            {
               temp = i.toString();
               while(temp.length < 3)
               {
                  temp = "0" + temp;
               }
               s = String(outstr.substr((i - 1) * chunkSize,chunkSize));
               cmdso.data.v += "s" + temp + "000000000";
               cmdso.data.v += "\x02";
               cmdso.data.v += "ú";
               cmdso.data.v += "\x00";
               cmdso.data.v += s;
            }
            cmdso.flush();
         }
      }
      
      protected function GetClassName() : String
      {
         return m_strClassName;
      }
      
      protected function GetHostPlatform() : String
      {
         return Capabilities.os.substring(0,3);
      }
      
      protected function IsDynamic() : Boolean
      {
         return m_dynamic;
      }
      
      protected function AddEvent(strEvent:String, hasParams:Boolean) : void
      {
         m_events[strEvent] = hasParams ? dummyCBParams : dummyCB;
         m_eventsCallbackType[strEvent] = hasParams ? dummyCBParams : dummyCB;
      }
      
      private function WorkOutFormID() : void
      {
         var strName:String = null;
         var arr:Array = null;
         var formid:int = 0;
         strName = null;
         if(m_strURL != null)
         {
            strName = m_strURL;
         }
         if(strName != null)
         {
            if(GetHostPlatform() == "Win")
            {
               arr = strName.split("~swd");
               if(arr.length == 2)
               {
                  strName = arr[1];
                  arr = strName.split(".");
                  if(arr.length == 2)
                  {
                     formid = arr[0].valueOf() - 1;
                     m_strFormID = formid.toString();
                     while(m_strFormID.length < 6)
                     {
                        m_strFormID = "0" + m_strFormID;
                     }
                  }
               }
            }
            else if(GetHostPlatform() == "Mac")
            {
               arr = strName.split("/");
               if(Boolean(arr.length))
               {
                  strName = arr[arr.length - 1];
                  arr = strName.split(".");
                  if(arr.length == 2)
                  {
                     formid = arr[0].valueOf() - 1;
                     m_strFormID = formid.toString();
                     while(m_strFormID.length < 6)
                     {
                        m_strFormID = "0" + m_strFormID;
                     }
                  }
               }
            }
         }
      }
      
      protected function SetDynamic(id:int) : void
      {
         m_dynamic = true;
         m_dynamicID = id;
      }
      
      private function SetupRealBasicSocket() : void
      {
         var onConnect:Function = null;
         var onClose:Function = null;
         var onData:Function = null;
         var onSecurityError:Function = null;
         var onIOError:Function = null;
         m_macPort = 50000 + int(m_strFormID);
         m_macSocket = new XMLSocket();
         onConnect = function(event:Event):void
         {
         };
         onClose = function(event:Event):void
         {
         };
         onData = function(event:DataEvent):void
         {
            var arr:Array = null;
            var params:Array = null;
            var strEvent:String = null;
            arr = event.data.split("!}}^{}!");
            if(arr[0] == "mdm.__callFunction")
            {
               params = arr[1].split("!}}v{}!");
               if(params[0] != "mdm.__dispatchEvent")
               {
                  strEvent = params.join("!}}v{}!");
                  OnEvent(strEvent);
               }
               if(GetHostPlatform() == "Mac")
               {
                  if(params.length > 1 && (params[0] == "mdm.__dispatchEvent" && params[1] == "AppExit"))
                  {
                     params.shift();
                     strEvent = params.join("!}}v{}!");
                     OnEvent(strEvent);
                  }
               }
            }
         };
         onSecurityError = function(event:SecurityErrorEvent):void
         {
         };
         onIOError = function(event:SecurityErrorEvent):void
         {
         };
         m_macSocket.addEventListener(Event.CONNECT,onConnect);
         m_macSocket.addEventListener(Event.CLOSE,onClose);
         m_macSocket.addEventListener(DataEvent.DATA,onData);
         m_macSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
         m_macSocket.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         m_macSocket.connect("127.0.0.1",m_macPort);
      }
      
      protected function AddObject(strName:String, resolver:mdm_resolver) : void
      {
         if(resolver == null)
         {
            m_objs[strName] = new mdm_resolver();
            m_objs[strName].m_strClassName = String(m_strClassName + "." + strName);
         }
         else
         {
            m_objs[strName] = resolver;
         }
      }
      
      public function ShowMessage(strMessage:String) : void
      {
         if(m_spr != null)
         {
            alert = new AlertBox(strMessage);
            m_spr.addChild(alert);
         }
      }
      
      private function HaveEI() : Boolean
      {
         return m_bHaveEI;
      }
      
      protected function CallAsync(strCommand:String, rest:Array) : void
      {
         var arr:Array = null;
         var params:String = null;
         var firstParam:String = null;
         var strFullCmd:String = null;
         var arrChunks:Array = null;
         var strCBName:String = null;
         arr = rest;
         firstParam = "";
         if(arr[arr.length - 1] === ASYNC)
         {
            arr.pop();
         }
         strFullCmd = m_strClassName + "." + strCommand;
         if(IsDynamic())
         {
            firstParam = m_dynamicID.toString();
         }
         arrChunks = strFullCmd.split(".");
         if(arrChunks[0] == "mdm" && arrChunks[1] == "Forms")
         {
            strFullCmd = arrChunks[0] + "." + arrChunks[1] + "." + arrChunks[3];
            firstParam = arrChunks[2];
         }
         if(firstParam != "")
         {
            arr.unshift(firstParam);
         }
         strCBName = "mdmCB" + m_cbID.toString();
         m_cbID += 1;
         ExternalInterface.addCallback(strCBName,arr[arr.length - 1]);
         arr.pop();
         arr.push(strCBName);
         arr = esc(arr);
         params = Boolean(arr.length) ? "\"" + arr.join("\",\"") + "\"" : "";
         if(GetHostPlatform() == "Win" && HaveEI())
         {
            fscommand(strFullCmd,params);
         }
         else if(GetHostPlatform() == "Mac")
         {
         }
      }
      
      protected function CallSyncNoReturn(strCommand:String, rest:Array) : void
      {
         var v:* = undefined;
         v = CallSync(strCommand,rest);
      }
      
      protected function CallSync(strCommand:String, rest:Array) : *
      {
         var arr:Array = null;
         var params:String = null;
         var firstParam:String = null;
         var unique:String = null;
         var retVal:String = null;
         var strFullCmd:String = null;
         var arrChunks:Array = null;
         var arr1:Array = null;
         var arr2:Array = null;
         var arr3:Array = null;
         var arr4:Array = null;
         arr = rest;
         firstParam = "";
         if(arr[arr.length - 1] === SYNC)
         {
            arr.pop();
         }
         strFullCmd = m_strClassName + "." + strCommand;
         if(IsDynamic())
         {
            firstParam = m_dynamicID.toString();
         }
         arrChunks = strFullCmd.split(".");
         if(arrChunks[0] == "mdm" && arrChunks[1] == "Forms")
         {
            strFullCmd = arrChunks[0] + "." + arrChunks[1] + "." + arrChunks[3];
            firstParam = arrChunks[2];
         }
         if(firstParam != "")
         {
            arr.unshift(firstParam);
         }
         if(GetHostPlatform() == "Win" || GetHostPlatform() == "Lin")
         {
            arr = esc(arr);
            params = Boolean(arr.length) ? "<{zinc}>" + ("\"" + arr.join("\",\"") + "\"") : "";
         }
         else if(GetHostPlatform() == "Mac")
         {
            if(HaveEI())
            {
               arr = esc(arr);
               params = Boolean(arr.length) ? "<{zinc}>" + ("\"" + arr.join("\",\"") + "\"") : "";
            }
            else
            {
               unique = new Date().getTime() + "<{zinc}>";
               params = Boolean(arr.length) ? "<{zinc}>" + arr.join("<{zincp}>") : "";
            }
         }
         if((GetHostPlatform() == "Win" || GetHostPlatform() == "Lin") && HaveEI())
         {
            retVal = ExternalInterface.call(strFullCmd,m_strFormID,params);
            if(retVal != null)
            {
               return Deserialise(retVal);
            }
         }
         else if(GetHostPlatform() == "Mac")
         {
            if(HaveEI())
            {
               if(params.indexOf("\\n") != -1)
               {
                  arr1 = params.split("\\n");
                  params = arr1.join("@@<{dbsn}>@@");
               }
               if(params.indexOf("\n") != -1)
               {
                  arr2 = params.split("\n");
                  params = arr2.join("@@<{sbsn}>@@");
               }
               if(params.indexOf("\\r") != -1)
               {
                  arr3 = params.split("\\r");
                  params = arr3.join("@@<{dbsr}>@@");
               }
               if(params.indexOf("\r") != -1)
               {
                  arr4 = params.split("\r");
                  params = arr4.join("@@<{sbsr}>@@");
               }
               retVal = ExternalInterface.call(strFullCmd,m_strFormID,params);
               if(retVal != null)
               {
                  return Deserialise(retVal);
               }
            }
            else
            {
               SendCmdMac(m_strFormID + "<{zinc}>" + strFullCmd + params + "<{zinc}>" + unique);
               retVal = WaitReturnMac();
               if(retVal != null)
               {
                  return Deserialise(retVal);
               }
            }
         }
         return "";
      }
      
      protected function AddDynamicEvent(strEvent:String, hasParams:Boolean) : void
      {
         m_dynEvents[strEvent] = hasParams ? dummyCBParams : dummyCB;
         m_dynEventsCallbackType[strEvent] = hasParams ? dummyCBParams : dummyCB;
      }
      
      private function InitialiseObjects(strDefs:String) : void
      {
         var objDefs:Array = null;
         var i:int = 0;
         objDefs = strDefs.split("<{!z!!}>");
         for(i = 0; i < objDefs.length; i++)
         {
            InitialiseObject(objDefs[i]);
         }
      }
      
      protected function MakeFormProperties(strClassName:String) : void
      {
         m_properties[strClassName] = new Array();
         m_properties[strClassName] = m_properties["mdm.forms"];
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         var arr:Array = null;
         var i:int = 0;
         var strGet:String = null;
         var arr2:Array = null;
         if(!m_doneInit)
         {
            return "";
         }
         if(m_objs[name] != null)
         {
            return m_objs[name];
         }
         arr = m_properties[m_strClassName];
         if(arr == null)
         {
            return "";
         }
         for(i = 0; i < arr.length; i++)
         {
            if(arr[i][0] == name)
            {
               if(arr[i][2] == "get" || arr[i][2] == "getset")
               {
                  strGet = String("get" + name);
                  arr2 = new Array();
                  return CallSync(strGet,arr2);
               }
               if(arr[i][2] != "ppsv")
               {
                  break;
               }
               if(arr[i][1] == "integer")
               {
                  return new int(arr[i][3]);
               }
               if(arr[i][1] == "string")
               {
                  return new String(arr[i][3]);
               }
               if(arr[i][1] == "boolean")
               {
                  return new Boolean(arr[i][3]);
               }
            }
         }
         return "";
      }
      
      override flash_proxy function callProperty(name:*, ... rest) : *
      {
         var arr:Array = null;
         if(!m_doneInit)
         {
            return "";
         }
         arr = rest;
         if(arr[arr.length - 1] !== ASYNC)
         {
            return CallSync(name,arr);
         }
         return CallAsync(name,arr);
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         return 0;
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         var arr:Array = null;
         var i:int = 0;
         var strSet:String = null;
         var arr2:Array = null;
         if(!m_doneInit)
         {
            return;
         }
         arr = m_properties[m_strClassName];
         if(arr != null)
         {
            for(i = 0; i < arr.length; i++)
            {
               if(arr[i][0] == name)
               {
                  if(arr[i][2] == "set" || arr[i][2] == "getset")
                  {
                     strSet = String("set" + name);
                     arr2 = new Array();
                     arr2.push(value);
                     CallSync(strSet,arr2);
                  }
                  break;
               }
            }
         }
         if(m_strClassName == "mdm.Menu.Context")
         {
            if(name != "menuType")
            {
               Menu.Context.AddEvent(name,false);
               Menu.Context.SetEvent(name,value);
            }
         }
         else if(m_strClassName == "mdm.Menu.Main")
         {
            if(name != "menuType")
            {
               Menu.Main.AddEvent(name,false);
               Menu.Main.SetEvent(name,value);
            }
         }
         else if(m_strClassName == "mdm.Menu.Tray")
         {
            if(name != "menuType" && name != "iconHint")
            {
               Menu.Tray.AddEvent(name,false);
               Menu.Tray.SetEvent(name,value);
            }
         }
         else if(IsDynamic())
         {
            if(m_dynEvents[name] != null)
            {
               SetDynamicEvent(name,value);
            }
         }
         else if(m_events[name] != null)
         {
            SetEvent(name,value);
         }
      }
      
      private function WriteSO(strName:String) : void
      {
         var so:SharedObject = null;
         if(GetHostPlatform() == "Mac")
         {
            so = SharedObject.getLocal(strName,"/");
            if(so.data.v != "<init />")
            {
               so.data.v = "<init />";
            }
            so.flush();
         }
      }
      
      private function dlm(strData:String, strToken:String) : String
      {
         return strData + "!}}^" + strToken + "^{}!";
      }
      
      protected function mdmSetup() : void
      {
         var strDefs:String = null;
         var strEI:String = null;
         var numProps:int = 0;
         var arr:Array = null;
         var myPattern:RegExp = null;
         var i:int = 0;
         if(!m_doneInit)
         {
            if(!m_bSimulate)
            {
               WorkOutFormID();
            }
            try
            {
               strEI = ExternalInterface.call("mdm.hasEI","");
               if(strEI != null)
               {
                  m_bHaveEI = true;
                  if(m_strFormID == "!}id}!")
                  {
                     if(GetHostPlatform() == "Win" || GetHostPlatform() == "Lin")
                     {
                        m_strFormID = strEI;
                     }
                  }
               }
               else if(m_strFormID == "!}id}!")
               {
                  m_strFormID = "000000";
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function WaitReturnMac() : String
      {
         var soName:String = null;
         var soVar:String = null;
         var thisresult:String = null;
         var cmdso:SharedObject = null;
         var numChunks:Number = NaN;
         var i:int = 0;
         var temp:String = null;
         if(GetHostPlatform() == "Mac")
         {
            soName = "xppres";
            soVar = "s000000000000";
            thisresult = "";
            cmdso = SharedObject.getLocal(soName + m_cmdCounter,"/",false);
            numChunks = Number(cmdso.data[soVar]) + 1;
            for(i = 1; i < numChunks; i++)
            {
               temp = i.toString();
               while(temp.length < 3)
               {
                  temp = "0" + temp;
               }
               soVar = "s" + temp + "000000000";
               thisresult += cmdso.data[soVar];
            }
            return thisresult;
         }
         return "";
      }
      
      private function InitEventsGatherer() : void
      {
         var f:Function = null;
         f = function():void
         {
            var events:String = null;
            var a:Array = null;
            var i:int = 0;
            if((GetHostPlatform() == "Mac" || GetHostPlatform() == "Lin") && HaveEI())
            {
               events = ExternalInterface.call("mdm.Application.collectEvents",m_strFormID,"");
               if(events != "")
               {
                  a = events.split("!!!{}event{{!!!");
                  if(a.length > 0)
                  {
                     for(i = 0; i < a.length; i++)
                     {
                        OnEvent(a[i]);
                     }
                  }
               }
            }
         };
         setInterval(f,1000 / 1);
      }
      
      private function esc(arr:Array) : Array
      {
         var i:int = 0;
         for(i = 0; i < arr.length; i++)
         {
            if(typeof arr[i] == "string")
            {
               arr[i] = arr[i].split(",").join("@co@").split("\"").join("@dq@").split("&").join("@amp@");
            }
         }
         return arr;
      }
      
      private function Serialise() : void
      {
      }
      
      protected function SetEvent(strEvent:String, callback:Function) : void
      {
         if(callback == null)
         {
            m_events[strEvent] = m_eventsCallbackType[strEvent];
         }
         else
         {
            m_events[strEvent] = callback;
         }
      }
      
      protected function SetDynamicEvent(strEvent:String, callback:Function) : void
      {
         if(callback == null)
         {
            m_dynEvents[strEvent] = m_dynEventsCallbackType[strEvent];
         }
         else
         {
            m_dynEvents[strEvent] = callback;
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.*;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.ByteArray;

class Base64
{
   
   private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
   
   public function Base64()
   {
      super();
      throw new Error("Base64 class is static container only");
   }
   
   public static function encode(data:String) : String
   {
      var bytes:ByteArray = null;
      bytes = new ByteArray();
      bytes.writeUTFBytes(data);
      return encodeByteArray(bytes);
   }
   
   public static function decodeToByteArray(data:String) : ByteArray
   {
      var output:ByteArray = null;
      var dataBuffer:Array = null;
      var outputBuffer:Array = null;
      var i:uint = 0;
      var j:uint = 0;
      var k:uint = 0;
      output = new ByteArray();
      dataBuffer = new Array(4);
      outputBuffer = new Array(3);
      for(i = 0; i < data.length; i += 4)
      {
         j = 0;
         while(j < 4 && i + j < data.length)
         {
            dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
            j++;
         }
         outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 0x30) >> 4);
         outputBuffer[1] = ((dataBuffer[1] & 0x0F) << 4) + ((dataBuffer[2] & 0x3C) >> 2);
         outputBuffer[2] = ((dataBuffer[2] & 3) << 6) + dataBuffer[3];
         for(k = 0; k < outputBuffer.length; k++)
         {
            if(dataBuffer[k + 1] == 64)
            {
               break;
            }
            output.writeByte(outputBuffer[k]);
         }
      }
      output.position = 0;
      return output;
   }
   
   public static function encodeByteArray(data:ByteArray) : String
   {
      var output:String = null;
      var dataBuffer:Array = null;
      var outputBuffer:Array = null;
      var i:uint = 0;
      var j:uint = 0;
      var k:uint = 0;
      output = "";
      outputBuffer = new Array(4);
      data.position = 0;
      while(data.bytesAvailable > 0)
      {
         dataBuffer = new Array();
         i = 0;
         while(i < 3 && data.bytesAvailable > 0)
         {
            dataBuffer[i] = data.readUnsignedByte();
            i++;
         }
         outputBuffer[0] = (dataBuffer[0] & 0xFC) >> 2;
         outputBuffer[1] = (dataBuffer[0] & 3) << 4 | dataBuffer[1] >> 4;
         outputBuffer[2] = (dataBuffer[1] & 0x0F) << 2 | dataBuffer[2] >> 6;
         outputBuffer[3] = dataBuffer[2] & 0x3F;
         for(j = dataBuffer.length; j < 3; j++)
         {
            outputBuffer[j + 1] = 64;
         }
         for(k = 0; k < outputBuffer.length; k++)
         {
            output += BASE64_CHARS.charAt(outputBuffer[k]);
         }
      }
      return output;
   }
   
   public static function decode(data:String) : String
   {
      var bytes:ByteArray = null;
      bytes = decodeToByteArray(data);
      return bytes.readUTFBytes(bytes.length);
   }
}

class AlertBox extends MovieClip
{
   
   public function AlertBox(strAlert:String)
   {
      var btn:SimpleButton = null;
      var txt:TextField = null;
      var downSprite:Sprite = null;
      var upSprite:Sprite = null;
      super();
      btn = new SimpleButton();
      downSprite = new Sprite();
      downSprite.graphics.lineStyle(2,2105376);
      downSprite.graphics.beginFill(16711935);
      downSprite.graphics.drawRect(10,10,300,200);
      upSprite = new Sprite();
      upSprite.graphics.lineStyle(2,2105376);
      upSprite.graphics.beginFill(16711680);
      upSprite.graphics.drawRect(10,10,300,200);
      btn.upState = upSprite;
      btn.overState = upSprite;
      btn.downState = downSprite;
      btn.useHandCursor = true;
      btn.hitTestState = upSprite;
      btn.addEventListener(MouseEvent.CLICK,closeMe);
      addChild(btn);
      txt = new TextField();
      txt.autoSize = TextFieldAutoSize.LEFT;
      txt.selectable = false;
      txt.textColor = 16777215;
      txt.text = strAlert;
      txt.x = (btn.width - txt.width) / 2;
      txt.y = (btn.height - txt.height) / 2;
      upSprite.addChild(txt);
   }
   
   private function closeMe(e:Event) : void
   {
      e.currentTarget.parent.removeChild(e.currentTarget);
   }
}

function dummyCB():void
{
}
function dummyCBParams(myObject:Object):void
{
}
