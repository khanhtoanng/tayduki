import 'package:flutter/material.dart';
import 'package:project/Animations/FadeAnimation.dart';
import 'package:project/bloc/AccountBloc.dart';
import 'package:project/ui/actor/actor_home_page.dart';
import 'package:project/ui/admin/admin_home_page.dart';
import 'package:project/utils/dialog_customize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController userEditController = TextEditingController();
  TextEditingController passwordEditController = TextEditingController();

  AccountBloc bloc = AccountBloc();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String token;
  @override
  void initState() {
    super.initState();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        await Dialogs.showMessageDialog(context, 'You got new role in destiny');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    firebaseMessaging.getToken().then((String tok) {
      print("Tokennnnnnn: " + tok);
      setState(() {
        token = tok;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                // header login page
                headerLoginPage(context),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: <Widget>[
                      // login form
                      bodyLoginPage(),
                      SizedBox(height: 30),
                      // login button
                      buttonLogin()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerLoginPage(context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        FadeAnimation(
          1,
          Container(
            margin: EdgeInsets.only(bottom: 50),
            padding: EdgeInsets.only(bottom: 20),
            height: size.height * .45,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(100),
                  bottomRight: const Radius.circular(100)),
              gradient: LinearGradient(
                  colors: [Color(0xFFf12711), Color(0xFFf5af19)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: FadeAnimation(
              1.2,
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Welcome back",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 60,
          width: 80,
          height: 200,
          child: FadeAnimation(
            1.4,
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/tnk2.jpg'))),
            ),
          ),
        ),
        Positioned(
          right: 60,
          width: 80,
          height: 200,
          child: FadeAnimation(
            1.5,
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/cbg.jpg'))),
            ),
          ),
        ),
        Positioned(
          right: 140,
          top: 100,
          width: 80,
          height: 150,
          child: FadeAnimation(
            1.6,
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/st.jpg'))),
            ),
          ),
        ),
      ],
    );
  }

  Widget bodyLoginPage() {
    return FadeAnimation(
      2,
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, blurRadius: 20, offset: Offset(0, 10))
            ]),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))),
              child: StreamBuilder(
                stream: bloc.usernameStream,
                builder: (context, snapshot) {
                  return TextField(
                    controller: userEditController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.people),
                        border: InputBorder.none,
                        hintText: "Username",
                        hintStyle: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold),
                        errorText: snapshot.hasError ? snapshot.error : null,
                        errorStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))),
              child: StreamBuilder(
                stream: bloc.passwordStream,
                builder: (context, snapshot) {
                  return TextField(
                    obscureText: true,
                    controller: passwordEditController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold),
                        errorText: snapshot.hasError ? snapshot.error : null,
                        errorStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonLogin() {
    return FadeAnimation(
      2.2,
      Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: [Color(0xFFfc4a1a), Color(0xFFf7b733)])),
              child: SizedBox.expand(
                  child: FlatButton(
                onPressed: () {
                  login();
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              )),
            ),
            loading()
          ],
        ),
      ),
    );
  }

  Widget loading() {
    return isLoading &&
            userEditController.text.length != 0 &&
            passwordEditController.text.length != 0
        ? Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xffb744b8)))),
          )
        : Text('');
  }

  /**
   * Login success then navigator to screen
   */
  login() async {
    setState(() {
      isLoading = true;
    });
    print(token);
    var role = await bloc.login(
        userEditController.text, passwordEditController.text, token);
    if (role.length == 0) {
      setState(() {
        isLoading = false;
      });
    }
    switch (role) {
      case 'admin':
        setUsernameToSharePreferences('admin');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminHomePage()));
        break;
      case 'actor':
        setUsernameToSharePreferences('actor');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ActorHomePage()));
        break;
      default:
        break;
    }
  }

  setUsernameToSharePreferences(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', userEditController.text.trim());
    await prefs.setString('role', role);
  }
}
