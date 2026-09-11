import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';

class StatusChipsBar extends StatelessWidget {
  final int selectedStatusIndex;
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final ValueChanged<int> onStatusSelected;

  const StatusChipsBar({
    Key? key,
    required this.selectedStatusIndex,
    required this.animationController,
    required this.scaleAnimation,
    required this.onStatusSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> statuses = ['الكل', 'نشطة', 'منجزة'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final isSmallScreen = availableWidth < 400;
          final chipWidth = (availableWidth - 40) / statuses.length;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(statuses.length, (int index) {
              return SizedBox(
                width: chipWidth,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: selectedStatusIndex == index
                          ? scaleAnimation.value
                          : 1.0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: isSmallScreen ? 70 : 80,
                          maxWidth: isSmallScreen ? 90 : 110,
                        ),
                        child: ChoiceChip(
                          color: WidgetStateProperty.resolveWith<Color?>((
                            Set<WidgetState> states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.OceanBlue;
                            }
                            if (states.contains(WidgetState.hovered)) {
                              return AppColors.OceanBlue.withOpacity(0.05);
                            }
                            if (states.contains(WidgetState.pressed)) {
                              return AppColors.OceanBlue.withOpacity(0.1);
                            }
                            return Colors.white;
                          }),
                          checkmarkColor: Colors.white,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.OceanBlue,
                              width: selectedStatusIndex == index ? 2.0 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          backgroundColor: selectedStatusIndex == index
                              ? AppColors.OceanBlue.withOpacity(0.1)
                              : Colors.white,
                          selectedColor: AppColors.OceanBlue,
                          label: Text(
                            statuses[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 15,
                              color: selectedStatusIndex == index
                                  ? AppColors.WhisperWhite
                                  : Colors.black87,
                              fontWeight: selectedStatusIndex == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          selected: selectedStatusIndex == index,
                          onSelected: (bool selected) {
                            onStatusSelected(index);
                            if (selected) {
                              animationController.forward();
                            } else {
                              animationController.reverse();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
