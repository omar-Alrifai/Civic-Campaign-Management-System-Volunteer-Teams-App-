import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/notifications/presentation/page/notification_page.dart';

class TeamCampaignsHeaderBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onFilterPressed;

  const TeamCampaignsHeaderBar({
    Key? key,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.onFilterPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.WhisperWhite,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.OceanBlue.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.WhisperWhite,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.LightGrey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'البحث عن حملة...',
                prefixIcon: const Icon(
                  Icons.search_outlined,
                  color: Colors.grey,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () => searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
              ),
              onSubmitted: onSearchSubmitted,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.WhisperWhite,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.OceanBlue.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_list, size: 22),
            onPressed: onFilterPressed,
          ),
        ),
      ],
    );
  }
}
