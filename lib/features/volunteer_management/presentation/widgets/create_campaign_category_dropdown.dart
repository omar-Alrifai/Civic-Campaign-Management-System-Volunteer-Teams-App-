import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/category.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaign_management_bloc/campaign_management_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/lookups_bloc/lookups_bloc.dart';

class CreateCampaignCategoryDropdown extends StatelessWidget {
  final String? selectedCategoryName;

  const CreateCampaignCategoryDropdown({
    Key? key,
    required this.selectedCategoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LookupsBloc, LookupsState>(
      builder: (context, lookupsState) {
        List<MyCategory> categories = [];

        if (lookupsState is CategoriesLoaded) {
          categories = lookupsState.categories;
        } else if (lookupsState is LookupsDataLoaded) {
          categories = lookupsState.categories;
        }

        final categoryItems = [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('اختر تصنيف للحملة'),
          ),
          ...categories.map((category) {
            return DropdownMenuItem<String>(
              value: category.name,
              child: Text(category.name),
            );
          }),
        ];

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'تصنيف الحملة',
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            prefixIcon: Icon(Icons.category, color: AppColors.OceanBlue),
            border: OutlineInputBorder(),
          ),
          value: selectedCategoryName,
          onChanged: (String? newValue) {
            context.read<CampaignManagementBloc>().add(
              UpdateCreateCampaignForm(selectedCategoryName: newValue),
            );
          },
          items: categoryItems,
          validator: (value) => value == null ? 'الرجاء اختيار تصنيف' : null,
        );
      },
    );
  }
}
