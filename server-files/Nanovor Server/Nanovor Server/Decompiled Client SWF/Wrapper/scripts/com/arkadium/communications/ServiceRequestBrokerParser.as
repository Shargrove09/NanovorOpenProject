package com.arkadium.communications
{
   import com.arkadium.virmon.shared.utils.Environment;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class ServiceRequestBrokerParser
   {
      
      private var _gameServicePort:int;
      
      private var _systemSettingsAttributes:Array;
      
      private var _shardListURL:String;
      
      private var _SRBResponseNames:Array;
      
      private var _SRBResponseValues:Array;
      
      private var _srbURL:String;
      
      private var _srbPostData:XML;
      
      private var _isCheckForNanocashEnabled:Boolean;
      
      private var _versionDataProvider:IVersionDataProvider;
      
      public function ServiceRequestBrokerParser(param1:IVersionDataProvider)
      {
         super();
         _versionDataProvider = param1;
         _srbPostData = <methodCall>
						       <methodName>srb.Connect</methodName>
							   <params>
							   </params>
						   </methodCall>;
      }
      
      public function get gameServicePort() : int
      {
         return _gameServicePort;
      }
      
      public function get srbURL() : String
      {
         return _srbURL;
      }
      
      public function getActionType() : ActionType
      {
         DebugLog.instance.log("<<ServiceRequestBrokerParser>> getActionType(): " + getServiceRequestBrokerValue(ServiceRequestBrokerValueType.ACTION));
         switch(getServiceRequestBrokerValue(ServiceRequestBrokerValueType.ACTION))
         {
            case ActionType.CONNECT.toString():
               return ActionType.CONNECT;
            case ActionType.MAINTENANCE.toString():
               return ActionType.MAINTENANCE;
            case ActionType.REFRESH.toString():
               return ActionType.REFRESH;
            default:
               return ActionType.NULL;
         }
      }
      
      public function parseSRBResponse(param1:XML) : void
      {
         var totalValues:int;
         var value:int;
         var xData:XML = null;
         var curValue:XML = null;
         var curValueString:String = null;
         var aTempPair:Array = null;
         var xml:XML = param1;
         DebugLog.instance.log("ServiceRequestBrokerParser.parseSRBResponse()");
         try
         {
            xData = xml.child("params")[0].child("param")[0].child("value")[0].child("array")[0].child("data")[0];
         }
         catch(e:Error)
         {
            xData = new XML();
         }
         totalValues = int(xData.child("value").length());
         _SRBResponseNames = new Array();
         _SRBResponseValues = new Array();
         value = 0;
         while(value < totalValues)
         {
            curValue = xData.child("value")[value];
            curValueString = curValue.toString();
            aTempPair = curValueString.split(":");
            aTempPair[0] = trim(aTempPair[0]," ");
            aTempPair[1] = trim(aTempPair[1]," ");
            _SRBResponseNames[value] = aTempPair[0];
            _SRBResponseValues[value] = aTempPair[1];
            if(aTempPair[2] != null && aTempPair[0] != ServiceRequestBrokerValueType.GAME_SERVICE_IP.name)
            {
               aTempPair[2] = trim(aTempPair[2]," ");
               _SRBResponseValues[value] += ":" + aTempPair[2];
            }
            if(aTempPair[0] == ServiceRequestBrokerValueType.GAME_SERVICE_IP.name)
            {
               _gameServicePort = int(aTempPair[2]);
            }
            value++;
         }
      }
      
      public function setLoginCredentials(param1:String, param2:String) : void
      {
         DebugLog.instance.log("ServiceRequestBrokerParser.setLoginCredentials()");
         _srbPostData.params.param[_systemSettingsAttributes.indexOf("playername")].value.string = param1;
         _srbPostData.params.param[_systemSettingsAttributes.indexOf("playerpassword")].value.string = param2;
      }
      
      public function parseSystemSettingsXml(param1:XML) : void
      {
         DebugLog.instance.log("ServiceRequestBrokerParser.parseSystemSettingsXml()");
         var _loc2_:XMLList = param1.connect.@*;
         _systemSettingsAttributes = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length())
         {
            _srbPostData.params.appendChild(<param><value><string></string></value></param>);
            _srbPostData.params.param[_loc3_].value.string = String(_loc2_[_loc3_]);
            _systemSettingsAttributes.push(String(_loc2_[_loc3_].name()));
            _loc3_++;
         }
         _srbPostData.params.param[_systemSettingsAttributes.indexOf("osname")].value.string = Environment.osName;
         _srbPostData.params.param[_systemSettingsAttributes.indexOf("osversion")].value.string = Environment.osVersion;
         _srbPostData.params.param[_systemSettingsAttributes.indexOf("locale")].value.string = "en-US";
         _srbPostData.params.param[_systemSettingsAttributes.indexOf("majorversion")].value.string = _versionDataProvider.getMajorVersion();
         _srbPostData.params.param[_systemSettingsAttributes.indexOf("minorversion")].value.string = _versionDataProvider.getMinorVersion();
         _srbPostData.params.param[_systemSettingsAttributes.indexOf("buildversion")].value.string = _versionDataProvider.getBuildVersion();
         _srbPostData.params.param[_systemSettingsAttributes.indexOf("ostype")].value.string = Environment.osBitType;
      }
      
      public function get debugSrbPostData() : XML
      {
         var _loc1_:XML = new XML(_srbPostData.toXMLString());
         _loc1_.params.param[_systemSettingsAttributes.indexOf("playerpassword")].value.string = "**********";
         return _loc1_;
      }
      
      private function stringToCharacter(param1:String) : String
      {
         if(param1.length == 1)
         {
            return param1;
         }
         return param1.slice(0,1);
      }
      
      private function trim(param1:String, param2:String) : String
      {
         return trimBack(trimFront(param1,param2),param2);
      }
      
      public function getServiceRequestBrokerValue(param1:ServiceRequestBrokerValueType) : String
      {
         var _loc2_:int = _SRBResponseNames.indexOf(param1.name);
         return _loc2_ > -1 ? _SRBResponseValues[_loc2_] : null;
      }
      
      private function trimBack(param1:String, param2:String) : String
      {
         param2 = stringToCharacter(param2);
         if(param1.charAt(param1.length - 1) == param2)
         {
            param1 = trimBack(param1.substring(0,param1.length - 1),param2);
         }
         return param1;
      }
      
      public function get srbPostData() : XML
      {
         return _srbPostData;
      }
      
      public function get isCheckForNanocashEnabled() : Boolean
      {
         return _isCheckForNanocashEnabled;
      }
      
      public function updateLoginToken(param1:String) : void
      {
         DebugLog.instance.log("ServiceRequestBrokerParser::updateLoginToken(): updating login token: " + param1);
         _SRBResponseValues[_SRBResponseNames.indexOf(ServiceRequestBrokerValueType.LOGIN_TOKEN.name)] = param1;
      }
      
      public function get shardListURL() : String
      {
         return _shardListURL;
      }
      
      public function parseConnectionSettings(param1:XML) : void
      {
         _srbURL = param1.srb;
         _shardListURL = param1.shardlist;
         _isCheckForNanocashEnabled = param1.checkForNanocash.@value == "true";
      }
      
      private function trimFront(param1:String, param2:String) : String
      {
         param2 = stringToCharacter(param2);
         if(param1.charAt(0) == param2)
         {
            param1 = trimFront(param1.substring(1),param2);
         }
         return param1;
      }
   }
}

