import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaigns_bloc/campaigns_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/create_campaign_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/joining_requests_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/my_team_campaigns_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/volunteer_leader_home_page.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/pages/profile_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Color navBarColor;
  final Color buttonBackgroundColor;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.navBarColor,
    required this.buttonBackgroundColor,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<Widget> _navBarIcons = const [
    Icon(Icons.home_outlined, size: 30, color: Colors.white),
    Icon(Icons.folder_shared_outlined, size: 30, color: Colors.white),
    Icon(Icons.people_alt_outlined, size: 30, color: Colors.white),
    Icon(Icons.add_circle_outline, size: 30, color: Colors.white),
    Icon(Icons.person_outline, size: 30, color: Colors.white),
  ];

  void _onItemTapped(int index) {
    if (index == widget.currentIndex) return;

    final bloc = context.read<CampaignBloc>();

    switch (index) {
      case 0: // 'جميع الحملات'
        bloc.add(RefreshAllCampaignsEvent());
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const VolunteerLeaderHomePage(),
          ),
          (Route<dynamic> route) => false,
        );
        break;

      case 1: // 'حملاتي'
        bloc.add(RefreshVolunteerAdminCampaignsEvent());
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyTeamCampaignsPage()),
          (Route<dynamic> route) => false,
        );
        break;

      case 2: // 'طلباتي'
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const JoiningRequestsPage()),
          (Route<dynamic> route) => false,
        );
        break;

      case 3: // 'إنشاء حملة'
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CreateCampaignPage()),
        );
        break;

      case 4: // 'البروفايل'
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ProfilePage()),
          (Route<dynamic> route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.currentIndex,
      height: 60.0,
      items: _navBarIcons.map((iconWidget) {
        return iconWidget;
      }).toList(),
      color: widget.navBarColor,
      buttonBackgroundColor: widget.buttonBackgroundColor,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.elasticInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: _onItemTapped,
      letIndexChange: (index) => true,
    );
  }
}
