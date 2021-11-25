import 'constants.dart';

class VersionControl {

  //VersionControl._();

  static VersionControl? _instance;

  late String _serverUrl;
  late String _flagPath;

  late Environment _environment;


  static VersionControl? get instance => _instance;


  Environment get getEnvironment => _environment;
  String get getServerUrl => _serverUrl;
  String get getFlagPath => _flagPath;


  factory VersionControl(options) {
    //var opt ={'environment':Environment.IND.name};

    if (_instance == null) {
      assert(options is Map);
      if (options is Map) {
        String envi = options['environment'];
        Environment environment = getSelectedEnvironment(envi);
        _instance = VersionControl.private(environment);
        _instance!.setEnvironment(environment);
      }
    }
    return _instance!;
  }

  @visibleForTesting
  VersionControl.private(
    this._environment,
    /* { this.mapOptions}*/
  );

  void setEnvironment(Environment env) {
    this._environment = env;
    this._serverUrl = env.url;
    this._flagPath = env.flag;
  }

  bool isIndia(){
   return this._environment.name == 'IND';
  }

  /*setServerUrlWithIndex(int index) {
    switch (index) {
      case 0:
        _serverUrl = Environment.IND.url;
        break;
      case 1:
        _serverUrl = Environment.COL.url;
        break;
      case 2:
        _serverUrl = Environment.USA.url;
        break;
      default:
        _serverUrl = Environment.IND.url;
        break;
    }
  }

  setServerUrlWithEnv(Environment environment) {
    switch (environment) {
      case Environment.IND:
        _serverUrl = Environment.IND.url;
        break;
      case Environment.COL:
        _serverUrl = Environment.COL.url;
        break;
      case Environment.USA:
        _serverUrl = Environment.USA.url;
        break;
      default:
        _serverUrl = Environment.IND.url;
        break;
    }
  }

  setFlagUrlWithIndex(int index) {
    switch (index) {
      case 0:
        _flagPath = Environment.IND.url;
        break;
      case 1:
        _flagPath = Environment.COL.url;
        break;
      case 2:
        _flagPath = Environment.USA.url;
        break;
      default:
        _flagPath = Environment.IND.url;
        break;
    }
  }

  setFlagUrlWithEnv(Environment environment) {
    switch (environment) {
      case Environment.IND:
        _flagPath = Environment.IND.url;
        break;
      case Environment.COL:
        _flagPath = Environment.COL.url;
        break;
      case Environment.USA:
        _flagPath = Environment.USA.url;
        break;
      default:
        _flagPath = Environment.IND.url;
        break;
    }
  }*/

// static VersionControl _versionControl;

/*VersionControl() {

  }
*/
/*static VersionControl getVersionControls() {
    //isUpdated ||
    if (_versionControl == null)
      _versionControl = new VersionControl();
   // setUrls(context);
    return _versionControl;
  }*/

//String Url = ServerExtension.QA.getURL();
/*String Url = ServerUrl.IND.name;

  String getUrl() {
    return Url;
  }

  void setUrl(String url) {
    Url = url;
    Environment.IND.url;
  }*/

// String Url = Environment.IND.index;
}

Environment getSelectedEnvironment(String env) {
  late Environment environ;
  switch (env) {
    case 'IND':
      environ = Environment.IND;
      break;
    case 'COL':
      environ = Environment.COL;
      break;
    case 'USA':
      environ = Environment.USA;
      break;
    default:
      environ = Environment.IND;
      break;
  }
  return environ;
}

enum Environment { IND, COL, USA }
/*enum ServerUrl {IND, COL, USA }
enum FlagPath {IND, COL, USA}*/

// its enum extensions
extension EnvironmentExtension on Environment {
  String get name {return ["IND", "COL", "USA"][this.index];
  }
}

extension ServerExtension on Environment {
  /* static String _url ='';

https://contecdemoapi.docty.ai/

  setUrl(int index){
    _url = this.url[index];
  }
*/
  String get url {return ["https://apidevice.docty.mobi/api/", "https://contecdemoapi.docty.ai/api/", "https://apidevice.docty.mobi/api/"][this.index];
  }
}


extension FlagExtension on Environment {
  String get flag {return ["images/old/india_flag.png", "images/old/co_flag.png", "images/old/us_flag.png"][this.index];
  }
}
