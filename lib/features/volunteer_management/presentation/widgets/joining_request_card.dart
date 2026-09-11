import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/joining_requests_entity.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/joining_requests_bloc/joining_requests_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/campaign_details_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/get_user_profile_by_userid_page.dart';
import 'package:flutter/scheduler.dart';

class JoiningRequestCard extends StatefulWidget {
  final JoiningRequestsEntity request;

  const JoiningRequestCard({Key? key, required this.request}) : super(key: key);

  @override
  State<JoiningRequestCard> createState() => _JoiningRequestCardState();
}

class _JoiningRequestCardState extends State<JoiningRequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _navigateToUserProfile() {
    if (widget.request.userId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GetUserProfileByUserIdPage(
            userId: widget.request.userId!,
            userName: widget.request.userName ?? 'بروفايل المستخدم',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.OceanBlue.withOpacity(0.7), Colors.white],
                stops: const [0.0, 1.5],
              ),
            ),
            child: Column(
              children: [
                // Header Section
                InkWell(
                  onTap: _toggleExpand,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // User Avatar with animation
                        InkWell(
                          onTap: _navigateToUserProfile,
                          child: Hero(
                            tag: 'user_avatar_${widget.request.userId}',
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: _navigateToUserProfile,
                                child: Text(
                                  widget.request.userName ?? 'غير معروف',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.request.projectTitle ?? 'غير معروف',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Animated expand icon
                        RotationTransition(
                          turns: _isExpanded
                              ? Tween(begin: 0.0, end: 0.5).animate(
                                  CurvedAnimation(
                                    parent: _controller,
                                    curve: Curves.easeInOut,
                                  ),
                                )
                              : Tween(begin: 0.5, end: 0.0).animate(
                                  CurvedAnimation(
                                    parent: _controller,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                          child: Icon(
                            Icons.expand_more,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Status Chip
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getStatusColor(
                                widget.request.status,
                              ).withOpacity(0.1),
                              _getStatusColor(
                                widget.request.status,
                              ).withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(
                              widget.request.status,
                            ).withOpacity(0.8),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // أيقونة متحركة للحالة
                            ScaleTransition(
                              scale: Tween(begin: 0.8, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.elasticOut,
                                ),
                              ),
                              child: Icon(
                                _getStatusIcon(widget.request.status),
                                size: 20,
                                color: _getStatusColor(widget.request.status),
                              ),
                            ),
                            const SizedBox(width: 6),
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    _getStatusColor(widget.request.status),
                                    _getStatusColor(
                                      widget.request.status,
                                    ).withOpacity(0.7),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds);
                              },
                              child: Text(
                                widget.request.status ?? 'غير معروف',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 3,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Expandable Content
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    height: _isExpanded ? null : 0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Divider(color: Colors.black12, thickness: 2),
                          const SizedBox(height: 10),

                          // Action Buttons
                          Wrap(
                            spacing: 8,
                            runSpacing: 10,
                            alignment: WrapAlignment.spaceEvenly,
                            children: [
                              // Campaign Details Button
                              if (widget.request.projectId != null)
                                _buildAnimatedButton(
                                  context,
                                  icon: Icons.info_outline,
                                  label: 'تفاصيل الحملة',
                                  color: Colors.white,
                                  iconColor: AppColors.OceanBlue.withOpacity(
                                    0.8,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CampaignDetailsPage(
                                              campaignId:
                                                  widget.request.projectId!,
                                            ),
                                      ),
                                    );
                                  },
                                ),

                              // Accept Button
                              if (widget.request.status != 'تمت الموافقة')
                                _buildAnimatedButton(
                                  context,
                                  icon: Icons.check,
                                  label: 'قبول',
                                  color: Colors.white,
                                  iconColor: AppColors.MidGreen,
                                  onPressed: () {
                                    _showConfirmationDialog(
                                      context,
                                      'قبول طلب الانضمام',
                                      'هل أنت متأكد من أنك تريد قبول طلب الانضمام هذا؟',
                                      () {
                                        context.read<JoiningRequestsBloc>().add(
                                          AcceptJoiningRequestEvent(
                                            participantId: widget.request.id!,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),

                              // Reject Button
                              if (widget.request.status != 'تم الرفض')
                                _buildAnimatedButton(
                                  context,
                                  icon: Icons.close,
                                  label: 'رفض',
                                  color: Colors.white,
                                  iconColor: Colors.red,
                                  onPressed: () {
                                    _showConfirmationDialog(
                                      context,
                                      'رفض طلب الانضمام',
                                      'هل أنت متأكد من أنك تريد رفض طلب الانضمام هذا؟',
                                      () {
                                        context.read<JoiningRequestsBloc>().add(
                                          RefuseJoiningRequestEvent(
                                            participantId: widget.request.id!,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required Color iconColor,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: iconColor),
        label: Text(label, style: TextStyle(fontSize: 12)),
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.OceanBlue,
          backgroundColor: Colors.white.withOpacity(0.9),
          side: BorderSide(color: AppColors.OceanBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.OceanBlue,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.OceanBlue,
                      ),
                      child: const Text(
                        'تأكيد',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'انتظار':
        return Colors.orange[800]!; // برتقالي داكن
      case 'تمت الموافقة':
        return Colors.green[700]!; // أخضر داكن
      case 'تم الرفض':
        return Colors.red[700]!; // أحمر داكن
      default:
        return Colors.grey[700]!; // رمادي داكن
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'انتظار':
        return Icons.access_time;
      case 'تمت الموافقة':
        return Icons.check_circle;
      case 'تم الرفض':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
