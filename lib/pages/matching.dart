import 'package:flutter/material.dart';
import 'package:sidekick/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MatchingAnimation extends StatefulWidget {
  const MatchingAnimation({Key? key}) : super(key: key);

  @override
  _MatchingAnimationState createState() => _MatchingAnimationState();
}

class _MatchingAnimationState extends State<MatchingAnimation>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, -0.5),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  setVisible() {
    setState(() {
      _visible = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: _offsetAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LeftToRight(),
                RightToLeft(parentController: _controller, visible: setVisible),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Column(
              children: [
                Text(
                  'Tu as matché avec ${Provider.of<UserProvider>(context).partner.name},',
                ),
                Text(
                  'qui a ${Provider.of<UserProvider>(context).partner.age} ans et fait du sport',
                ),
                Text(
                  '${Provider.of<UserProvider>(context).partner.frequence.toString()} fois par semaine.',
                ),
                Text('On vous souhaite bon courage !'),
                Text('L\'équipe Sidekick'),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).secondaryHeaderColor,
                    onPrimary: const Color(0xFFd2a6ff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .findPartner();
                  },
                  child: const Text(
                    'Commencer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeftToRight extends StatefulWidget {
  const LeftToRight({Key? key}) : super(key: key);

  @override
  _LeftToRightState createState() => _LeftToRightState();
}

class _LeftToRightState extends State<LeftToRight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.9, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  @override
  void initState() {
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: const CircleAvatar(
          radius: 50, backgroundImage: AssetImage("assets/avatar.png")),
    );
  }
}

class RightToLeft extends StatefulWidget {
  const RightToLeft(
      {Key? key, required this.parentController, required this.visible})
      : super(key: key);

  final AnimationController parentController;
  final Function visible;
  @override
  _RightToLeftState createState() => _RightToLeftState();
}

class _RightToLeftState extends State<RightToLeft>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-0.9, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ))
    ..addStatusListener((status) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.parentController.forward();
        if (this.mounted) {
          widget.visible();
        }
        // Provider.of<UserProvider>(context, listen: false).findPartner();
      });
    });

  late final Match match;

  @override
  void initState() {
    match = Provider.of<UserProvider>(context, listen: false).partner;
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage(match.photo!),
      ),
    );
  }
}
