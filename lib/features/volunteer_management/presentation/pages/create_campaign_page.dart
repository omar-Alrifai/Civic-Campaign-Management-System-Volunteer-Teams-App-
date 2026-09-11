import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/auth/presentation/pages/pick_location_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaign_management_bloc/campaign_management_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaigns_bloc/campaigns_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/lookups_bloc/lookups_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/create_campaign_category_dropdown.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/create_campaign_form_field.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/create_campaign_header.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/create_campaign_image_picker.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/create_campaign_location_picker.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/create_campaign_region_dropdown.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/create_campaign_submit_button.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class CreateCampaignPage extends StatefulWidget {
  const CreateCampaignPage({Key? key}) : super(key: key);

  @override
  State<CreateCampaignPage> createState() => _CreateCampaignPageState();
}

class _CreateCampaignPageState extends State<CreateCampaignPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredAmountController =
      TextEditingController();
  final TextEditingController _numberOfParticipantsController =
      TextEditingController();
  final TextEditingController _executionDateController =
      TextEditingController();

  final int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    CreateCampaignFormData currentFormData = _getFormDataFromBlocState(
      context.read<CampaignManagementBloc>().state,
    );

    _titleController.text = currentFormData.title;
    _descriptionController.text = currentFormData.description;
    _requiredAmountController.text =
        currentFormData.requiredAmount?.toString() ?? '';
    _numberOfParticipantsController.text =
        currentFormData.numberOfParticipants?.toString() ?? '';

    if (currentFormData.executionDate != null) {
      _executionDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(currentFormData.executionDate!);
    } else {
      _executionDateController.clear();
    }

    context.read<LookupsBloc>().add(const LoadCategoriesEvent());
    context.read<LookupsBloc>().add(const LoadRegionsEvent());
  }

  CreateCampaignFormData _getFormDataFromBlocState(
    CampaignManagementState state,
  ) {
    if (state is CampaignManagementInitial) return state.formData;
    if (state is CampaignManagementLoading) return state.formData;
    if (state is CampaignFormUpdated) return state.formData;
    if (state is CampaignManagementError) return state.formData;
    return const CreateCampaignFormData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requiredAmountController.dispose();
    _numberOfParticipantsController.dispose();
    _executionDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      context.read<CampaignManagementBloc>().add(
        UpdateCreateCampaignForm(imagePath: pickedFile.path),
      );
    }
  }

  Future<void> _pickLocation(BuildContext context) async {
    final result = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(builder: (context) => const PickLocationPage()),
    );

    if (result != null) {
      context.read<CampaignManagementBloc>().add(
        UpdateCreateCampaignForm(selectedLocation: result),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final currentFormData = _getFormDataFromBlocState(
      context.read<CampaignManagementBloc>().state,
    );
    final DateTime? initialDate =
        currentFormData.executionDate ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null && pickedDate != currentFormData.executionDate) {
      context.read<CampaignManagementBloc>().add(
        UpdateCreateCampaignForm(executionDate: pickedDate),
      );
      _executionDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(pickedDate);
    }
  }

  void _createCampaign(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final currentFormData = _getFormDataFromBlocState(
        context.read<CampaignManagementBloc>().state,
      );

      if (currentFormData.imagePath == null ||
          currentFormData.imagePath!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء اختيار صورة للحملة.')),
        );
        return;
      }
      if (currentFormData.selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء تحديد موقع الحملة على الخريطة.'),
          ),
        );
        return;
      }
      if (currentFormData.selectedCategoryName == null ||
          currentFormData.selectedCategoryName!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء اختيار تصنيف للحملة.')),
        );
        return;
      }
      if (currentFormData.area == null || currentFormData.area!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء اختيار منطقة الحملة.')),
        );
        return;
      }
      if (currentFormData.executionDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء تحديد تاريخ بدء الحملة.')),
        );
        return;
      }

      context.read<CampaignManagementBloc>().add(
        const SubmitCreateCampaignForm(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CampaignManagementBloc, CampaignManagementState>(
        listener: (context, state) {
          if (state is CampaignCreatedSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            context.read<CampaignBloc>().add(
              const RefreshVolunteerAdminCampaignsEvent(),
            );
            context.read<CampaignManagementBloc>().add(
              const ResetCampaignManagementStateEvent(),
            );
            Navigator.of(context).pop();
          } else if (state is CampaignManagementError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final currentFormData = _getFormDataFromBlocState(state);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _titleController.text = currentFormData.title;
            _descriptionController.text = currentFormData.description;
            _requiredAmountController.text =
                currentFormData.requiredAmount?.toString() ?? '';
            _numberOfParticipantsController.text =
                currentFormData.numberOfParticipants?.toString() ?? '';
            if (currentFormData.executionDate != null) {
              _executionDateController.text = DateFormat(
                'yyyy-MM-dd',
              ).format(currentFormData.executionDate!);
            } else {
              _executionDateController.clear();
            }
          });

          if (state is CampaignManagementLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                      ),
                      color: AppColors.OceanBlue,
                    ),
                  ),
                  Expanded(child: Container(color: Colors.white)),
                ],
              ),
              const CreateCampaignHeader(),
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 16,
                  right: 16,
                  bottom: 32,
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'أنشئ حملة جديدة وابدأ رحلة التغيير',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.OceanBlue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'املأ النموذج التالي لإنشاء حملتك',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const Divider(
                            height: 24,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          CreateCampaignFormField(
                            controller: _titleController,
                            label: 'عنوان الحملة',
                            icon: Icons.title,
                            validator: (value) => value?.isEmpty ?? true
                                ? 'هذا الحقل مطلوب'
                                : null,
                            onChanged: (value) {
                              context.read<CampaignManagementBloc>().add(
                                UpdateCreateCampaignForm(title: value),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          CreateCampaignFormField(
                            controller: _descriptionController,
                            label: 'وصف الحملة',
                            icon: Icons.description,
                            maxLines: 3,
                            validator: (value) => value?.isEmpty ?? true
                                ? 'هذا الحقل مطلوب'
                                : null,
                            onChanged: (value) {
                              context.read<CampaignManagementBloc>().add(
                                UpdateCreateCampaignForm(description: value),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          CreateCampaignFormField(
                            controller: _requiredAmountController,
                            label: 'المبلغ المطلوب',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'هذا الحقل مطلوب';
                              }
                              if (int.tryParse(value!) == null) {
                                return 'الرجاء إدخال قيمة رقمية';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              context.read<CampaignManagementBloc>().add(
                                UpdateCreateCampaignForm(
                                  requiredAmount: int.tryParse(value),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          CreateCampaignFormField(
                            controller: _numberOfParticipantsController,
                            label: 'عدد المتطوعين المطلوبين',
                            icon: Icons.people,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'هذا الحقل مطلوب';
                              }
                              if (int.tryParse(value!) == null) {
                                return 'الرجاء إدخال قيمة رقمية';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              context.read<CampaignManagementBloc>().add(
                                UpdateCreateCampaignForm(
                                  numberOfParticipants: int.tryParse(value),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: CreateCampaignFormField(
                                controller: _executionDateController,
                                label: 'تاريخ بدء الحملة',
                                icon: Icons.calendar_today,
                                validator: (value) => value?.isEmpty ?? true
                                    ? 'هذا الحقل مطلوب'
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CreateCampaignCategoryDropdown(
                            selectedCategoryName:
                                currentFormData.selectedCategoryName,
                          ),
                          const SizedBox(height: 16),
                          CreateCampaignRegionDropdown(
                            selectedArea: currentFormData.area,
                          ),
                          const SizedBox(height: 16),
                          CreateCampaignImagePicker(
                            imagePath: currentFormData.imagePath,
                            onTap: () => _pickImage(context),
                          ),
                          const SizedBox(height: 16),
                          CreateCampaignLocationPicker(
                            selectedLocation: currentFormData.selectedLocation,
                            onPickLocation: () => _pickLocation(context),
                          ),
                          const SizedBox(height: 24),
                          CreateCampaignSubmitButton(
                            isLoading: state is CampaignManagementLoading,
                            onPressed: () => _createCampaign(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        navBarColor: AppColors.OceanBlue,
        buttonBackgroundColor: AppColors.OceanBlue,
      ),
    );
  }
}
