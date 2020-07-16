import 'package:flutter/material.dart';
import 'package:project/Animations/FadeAnimation.dart';
import 'package:project/ui/appbar_widget.dart';

class AnimationFirstPage extends StatefulWidget {
  @override
  _AnimationFirstPageState createState() => _AnimationFirstPageState();
}

class _AnimationFirstPageState extends State<AnimationFirstPage>
    with TickerProviderStateMixin {
  AnimationController scaleController;
  AnimationController scale2Controller;
  AnimationController widthController;
  AnimationController positionController;

  Animation<double> scaleAnimation;
  Animation<double> scale2Animation;
  Animation<double> widthAnimation;
  Animation<double> positionAnimation;
  @override
  void initState() {
    super.initState();

    scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(scaleController);
    // ..addListener((status) {
    //   if (status == AnimationStatus.completed) {}
    // });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      appBar:
          AppBarCustomize().setAppbar(context, 'Equipment Adding Page', true),
      body: Container(
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -50,
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
                top: -100,
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
                top: -150,
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
                          style: TextStyle(color: Colors.white, fontSize: 50),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "We promis that you'll have the most \nfuss-free time with us ever.",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.7),
                              height: 1.4,
                              fontSize: 20),
                        )),
                    SizedBox(
                      height: 180,
                    ),
                    FadeAnimation(
                        1.6,
                        AnimatedBuilder(
                            animation: scaleController,
                            builder: (context, child) => Transform.scale(
                                scale: scaleAnimation.value,
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.blue.withOpacity(.6)),
                                    child: InkWell(
                                      onTap: () {
                                        scaleController.forward();
                                      },
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue.withOpacity(.6)),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
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
