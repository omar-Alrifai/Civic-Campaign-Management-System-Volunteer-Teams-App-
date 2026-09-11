import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final Color textColor;
  final List<Color> shaderMaskColors;
  final Color spinKitChasingDots;

  const LoadingWidget({
    super.key,
    required this.textColor,
    required this.shaderMaskColors,
    required this.spinKitChasingDots,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: shaderMaskColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: SpinKitChasingDots(color: spinKitChasingDots, size: 40.0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جارٍ التحميل...',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
