import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/regions_entity.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaign_management_bloc/campaign_management_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/lookups_bloc/lookups_bloc.dart';

class CreateCampaignRegionDropdown extends StatelessWidget {
  final String? selectedArea;

  const CreateCampaignRegionDropdown({Key? key, required this.selectedArea})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LookupsBloc, LookupsState>(
      builder: (context, lookupsState) {
        List<RegionEntity> regions = [];

        if (lookupsState is RegionsLoaded) {
          regions = lookupsState.regions;
        } else if (lookupsState is LookupsDataLoaded) {
          regions = lookupsState.regions;
        }

        final regionItems = [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('اختر منطقة الحملة'),
          ),
          ...regions.map((region) {
            return DropdownMenuItem<String>(
              value: region.name,
              child: Text(region.name),
            );
          }),
        ];

        return DropdownButtonFormField<String?>(
          decoration: const InputDecoration(
            labelText: 'منطقة الحملة',
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            prefixIcon: Icon(Icons.location_city, color: AppColors.OceanBlue),
            border: OutlineInputBorder(),
          ),
          value: selectedArea,
          onChanged: (String? newValue) {
            context.read<CampaignManagementBloc>().add(
              UpdateCreateCampaignForm(area: newValue),
            );
          },
          items: regionItems,
          validator: (value) => value == null ? 'الرجاء اختيار منطقة' : null,
        );
      },
    );
  }
}
