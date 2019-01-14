import 'package:flutter_qq/flutter_qq.dart';
import 'package:flutter/material.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/been/login_been.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_mini_app/home/main_page.dart';

class TestLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginView();
  }
}

class LoginView extends StatefulWidget {
  final String appId = "tencent1106940064";
  final String name = "登录页面";

  @override
  _LoginState createState() {
    FlutterQq.registerQQ('1106940064');
    return _LoginState();
  }
}

class _LoginState extends State<LoginView> {
  String hasQQ = "yes";

  @override
  void initState() {
    super.initState();
    judgeHasLogin();
  }

  void judgeHasLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLogin = preferences.getBool("isLogin");
    if (isLogin) {
      //跳转home page
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new MainPage()),
      );
    }
  }

  Future<Null> _handleisQQInstalled() async {
    var result = await FlutterQq.isQQInstalled();
    var output;
    if (result) {
      output = "QQ已安装";
    } else {
      output = "QQ未安装";
    }
    setState(() {
      hasQQ = output;
    });
  }

  Future<Null> _handleLogin() async {
    try {
      var qqResult = await FlutterQq.login();
      var output;
      if (qqResult.code == 0) {
        ToastUtil.showToast("登陆成功");
        print("json data is: ${qqResult.response["accessToken"].toString()}");
        //发送openid到服务器
        var loginMap = await ApiUtil.getInstance().netFetch(
            "/user/login",
            RequestMethod.POST,
            {
              "access_token": qqResult.response["accessToken"],
              "openid": qqResult.response["openid"]
            },
            null);
        LoginBeen loginBeen = new LoginBeen.fromJson(loginMap);
        _saveDataToSharedPref(loginBeen);
        print('hello this is data: ${loginBeen.username}');
        //登陆成功，跳转activity
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new MainPage()),
        );
//        Navigator.pop(context);
      } else if (qqResult.code == 1) {
        ToastUtil.showToast("登录失败 ${qqResult.message}");
      } else {
        ToastUtil.showToast("用户取消");
      }
      setState(() {
        hasQQ = output;
      });
    } catch (error) {
      print("flutter_plugin_qq_example:" + error.toString());
    }
  }

  void _saveDataToSharedPref(LoginBeen loginBeen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("openid", loginBeen.openid);
    await prefs.setString("username", loginBeen.username);
    await prefs.setString("headUrl", loginBeen.headUrl);
    await prefs.setBool("sex", loginBeen.sex);
    await prefs.setBool("isLogin", true);
    print("saveDataToSharedPref savedata is success");
  }

  //return a map
  void netFetch() async {
    try {
      //{"id": 3}
      var loginMap = await ApiUtil.getInstance()
          .netFetch("/user/selectUserById", RequestMethod.GET, {"id": 3}, null);
      LoginBeen loginBeen = new LoginBeen.fromJson(loginMap);
      print('hello this is data: ${loginBeen.username}');
    } catch (error) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 51, 51, 52),
//      appBar: AppBar(
//        title: Text(widget.name)
//      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                "image/ic_logo.png",
                width: 150.0,
                height: 150.0,
              ),
              SizedBox(
                height: 250.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 120.0,
                    height: 1.0,
                    color: Colors.white,
                  ),
                  //点击QQ图标登陆
                  GestureDetector(
                    onTap: () {
//                      _handleLogin();
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new MainPage()),
                      );
//                      ToastUtil.showToast("登陆成功啦");
//                      netFetch();
                    },
                    child: Image.asset(
                      "image/ic_qq.png",
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                  Container(
                    width: 120.0,
                    height: 1.0,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "QQ号快捷登录",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ));
  }
}