import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaign_management_bloc/campaign_management_bloc.dart';

class CreateCampaignHeader extends StatelessWidget {
  const CreateCampaignHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              context.read<CampaignManagementBloc>().add(
                const ResetCampaignManagementStateEvent(),
              );
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 16),
          const Text(
            'إنشاء حملة جديدة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
