import 'package:flutter/material.dart';
import 'package:project/Animations/FadeAnimation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/ui/login_page.dart';

class AnimationFirstPage extends StatefulWidget {
  @override
  _AnimationFirstPageState createState() => _AnimationFirstPageState();
}

class _AnimationFirstPageState extends State<AnimationFirstPage>
    with TickerProviderStateMixin {
  AnimationController scaleController;
  AnimationController scale2Controller;
  AnimationController widtButtonController;
  AnimationController positionController;

  Animation<double> scaleAnimation;
  Animation<double> scale2Animation;
  Animation<double> widtButtonhAnimation;
  Animation<double> positionAnimation;
  bool hideIcon = false;
  @override
  void initState() {
    super.initState();

    scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widtButtonController.forward();
            }
          });
    widtButtonController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    widtButtonhAnimation =
        Tween<double>(begin: 80.0, end: 300.0).animate(widtButtonController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              positionController.forward();
            }
          });

    positionController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    positionAnimation =
        Tween<double>(begin: 00.0, end: 215.0).animate(positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                hideIcon = true;
              });
              scale2Controller.forward();
            }
          });

    scale2Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    scale2Animation =
        Tween<double>(begin: 1.0, end: 31.0).animate(scale2Controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: LoginPage()));
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -60,
                left: 0,
                child: FadeAnimation(
                    1,
                    Container(
                      width: width,
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/one1.png'),
                              fit: BoxFit.cover)),
                    )),
              ),
              Positioned(
                top: -110,
                left: 0,
                child: FadeAnimation(
                    1.3,
                    Container(
                      width: width,
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/one1.png'),
                              fit: BoxFit.cover)),
                    )),
              ),
              Positioned(
                top: -160,
                left: 0,
                child: FadeAnimation(
                    1.6,
                    Container(
                      width: width,
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/one1.png'),
                              fit: BoxFit.cover)),
                    )),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "Welcome",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Manage your schedul in\n The way to West",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.7),
                              height: 1.4,
                              fontSize: 20),
                        )),
                    SizedBox(
                      height: 180,
                    ),
                    FadeAnimation(
                      1.7,
                      Container(
                        child: Image.asset(
                          'assets/images/full.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        1.9,
                        AnimatedBuilder(
                            animation: scaleController,
                            builder: (context, child) => Transform.scale(
                                scale: scaleAnimation.value,
                                child: Center(
                                  child: AnimatedBuilder(
                                    animation: widtButtonhAnimation,
                                    builder: (context, child) => Container(
                                      padding: EdgeInsets.all(10),
                                      width: widtButtonhAnimation.value,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.orangeAccent
                                              .withOpacity(.6)),
                                      child: InkWell(
                                        onTap: () {
                                          scaleController.forward();
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            AnimatedBuilder(
                                              animation: positionAnimation,
                                              builder: (context, child) =>
                                                  Positioned(
                                                left: positionAnimation.value,
                                                child: AnimatedBuilder(
                                                    animation: scale2Animation,
                                                    builder: (context, child) =>
                                                        Transform.scale(
                                                          scale: scale2Animation
                                                              .value,
                                                          child: Container(
                                                              width: 60,
                                                              height: 60,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .orangeAccent),
                                                              child: hideIcon ==
                                                                      false
                                                                  ? Icon(
                                                                      Icons
                                                                          .arrow_forward,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Container()),
                                                        )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ))))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
