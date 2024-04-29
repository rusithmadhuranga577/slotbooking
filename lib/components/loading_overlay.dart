import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({super.key});

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>with TickerProviderStateMixin  {
  late final AnimationController _lottie_controller;

  @override
  void initState() {
    super.initState();
    _lottie_controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottie_controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Center(
        child: SizedBox(
          width: size.width/4,
          child: Lottie.asset(
            'assets/loading2.json',
            frameRate: FrameRate(60), 
              controller: _lottie_controller,
              repeat: false,
              onLoaded: (composition) {
                _lottie_controller
                ..duration = composition.duration
                ..repeat();
              },
          ),
        ),
      ),
    );
  }
}