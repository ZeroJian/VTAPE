import 'package:flutter/material.dart';

import 'package:ovprogresshud/progresshud.dart';


class LoginModel {
  String userName = "";
  String password = "";
  String rePassword = "";
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  LoginModel loginModel = LoginModel();

  bool isLogining = false;

  bool isLoginWidget = true;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildLoginWidget()
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoginWidget() {

    if (isLoginWidget) {
      return [_buildTitle(title: "账号登录"),
      _buildTextField(
        hintText: "请输入用户名", 
        autofocus: true,
        onChanged: (value) {
          this.loginModel.userName = value;
        }
      ),
      _buildTextField(
        hintText: "请输入密码", 
        autofocus: false,
        isLast: true,
        onChanged: (value) {
          this.loginModel.password = value;
        }
      ),
      _buildButtonTitle("注册"),

      _buildButton(title: "登录")];
    
    } else {
      return [_buildTitle(title: "注册"),
      _buildTextField( 
        hintText: "请输入用户名", 
        autofocus: true,
        onChanged: (value) {
          this.loginModel.userName = value;
        }
      ),
      _buildTextField(
        hintText: "请输入密码", 
        autofocus: false,
        onChanged: (value) {
          this.loginModel.password = value;
        }
      ),
      _buildTextField(
        hintText: "请再次输入密码", 
        autofocus: false,
        onChanged: (value) {
          this.loginModel.rePassword = value;
        }
      ),
      _buildButtonTitle("账号密码登录"),
      _buildButton(title: "注册登录")];
    }
  }

  Widget _buildTitle({String title}) {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 30),
      child:  Row(
        children: <Widget>[
          Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.title.color,
            fontSize: 26,
            fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({String hintText, bool autofocus, bool isLast = false,  ValueChanged<String> onChanged}) {
    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 10 : 20),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          counterStyle: TextStyle(color: Colors.white),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).textTheme.subtitle.color),
          filled: true,
          fillColor: Theme.of(context).unselectedWidgetColor,
          border: InputBorder.none
        ),
        keyboardType: TextInputType.text,
        autofocus: autofocus,
        onChanged: onChanged,
        style: TextStyle(color: Theme.of(context).textTheme.title.color),
      ),
    );
  }

  Widget _buildButtonTitle(String title) {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textTheme.title.color,
                fontSize: 18,
                decoration: TextDecoration.underline
              ),
              textAlign: TextAlign.left,
            ),
            highlightColor: Colors.transparent,
            onPressed: () {
              this.isLoginWidget = !this.isLoginWidget;
              setState(() {
              });
            },
        ),
      ),
    );
  }

  Widget _buildButton({String title}) {
    return Container(
      height: 45,
      width: double.infinity,
      child: FlatButton(
        color: Theme.of(context).highlightColor,
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.title.color,
            fontSize: 18
            ),
          ),
        onPressed: () => _buttonAction(),
      ),
    );
  }

  void _buttonAction() {

    if (isLogining) {
      return;
    }

    if (loginModel.userName.length < 6) {
      Progresshud.showErrorWithStatus("用户名至少需要 6 个 字符");
      return;
    }
    if (loginModel.password.length < 6) {
      Progresshud.showErrorWithStatus("密码至少需要 6 个 字符");
      return;
    }

    if (isLoginWidget && loginModel.rePassword.length < 6) {
      Progresshud.showErrorWithStatus("确认密码至少需要 6 个 字符");
      return;
    }

    if (isLoginWidget && loginModel.password != loginModel.rePassword) {
      Progresshud.showErrorWithStatus("密码和确认密码必须相同");
      return;
    }

    // isLogining = true;
    // Progresshud.showInfoWithStatus("登录中...");

  }
}
