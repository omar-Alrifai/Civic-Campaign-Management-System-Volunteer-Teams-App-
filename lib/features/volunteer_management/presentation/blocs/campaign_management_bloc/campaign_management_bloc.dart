import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/strings/error.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/change_campaign_status_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/create_project_or_campaign_usecase.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

part 'campaign_management_event.dart';
part 'campaign_management_state.dart';

class CampaignManagementBloc
    extends Bloc<CampaignManagementEvent, CampaignManagementState> {
  final CreateProjectOrCampaignUsecase createProjectOrCampaignUsecase;
  final ChangeCampaignStatusUsecase changeCampaignStatusUsecase;

  CreateCampaignFormData _formData = const CreateCampaignFormData();

  CampaignManagementBloc({
    required this.createProjectOrCampaignUsecase,
    required this.changeCampaignStatusUsecase,
  }) : super(const CampaignManagementInitial()) {
    on<ChangeCampaignStatusEvent>(_onChangeCampaignStatus);
    on<ResetCampaignManagementStateEvent>(_onResetState);
    on<UpdateCreateCampaignForm>(_onUpdateCreateCampaignForm);
    on<SubmitCreateCampaignForm>(_onSubmitCreateCampaignForm);
  }

  void _onResetState(
    ResetCampaignManagementStateEvent event,
    Emitter<CampaignManagementState> emit,
  ) {
    _formData = const CreateCampaignFormData();
    emit(const CampaignManagementInitial());
  }

  void _onUpdateCreateCampaignForm(
    UpdateCreateCampaignForm event,
    Emitter<CampaignManagementState> emit,
  ) {
    _formData = _formData.copyWith(
      title: event.title,
      description: event.description,
      requiredAmount: event.requiredAmount,
      area: event.area,
      longitude: event.longitude,
      latitude: event.latitude,
      selectedCategoryName: event.selectedCategoryName,
      categoryId:
          event.selectedCategoryName != null &&
              event.selectedCategoryName!.isNotEmpty
          ? _getCategoryIdByName(event.selectedCategoryName!)
          : null,
      imagePath: event.imagePath,
      numberOfParticipants: event.numberOfParticipants,
      executionDate: event.executionDate,
      selectedLocation: event.selectedLocation,
    );
    emit(CampaignFormUpdated(formData: _formData));
  }

  int? _getCategoryIdByName(String categoryName) {
    final List<Map<String, dynamic>> categories = [
      {'id': 1, 'name': 'إنارة الشوارع بالطاقة الشمسية'},
      {'id': 2, 'name': 'تنظيف وتزيين الأماكن العامة'},
      {'id': 3, 'name': 'يوم خيري'},
      {'id': 4, 'name': 'حملات تشجير'},
      {'id': 5, 'name': 'ترميم أضرار (كوارث , عدوان)'},
    ];
    return categories.firstWhere(
      (cat) => cat['name'] == categoryName,
      orElse: () => {},
    )['id'];
  }

  Future<void> _onSubmitCreateCampaignForm(
    SubmitCreateCampaignForm event,
    Emitter<CampaignManagementState> emit,
  ) async {
    if (_formData.title.isEmpty ||
        _formData.description.isEmpty ||
        _formData.requiredAmount == null ||
        _formData.area == null ||
        _formData.selectedLocation == null ||
        _formData.categoryId == null ||
        _formData.imagePath == null ||
        _formData.numberOfParticipants == null ||
        _formData.executionDate == null) {
      emit(
        CampaignManagementError(
          message: 'الرجاء ملء جميع الحقول المطلوبة.',
          formData: _formData,
        ),
      );
      return;
    }

    emit(CampaignManagementLoading(formData: _formData));
    final failureOrSuccess = await createProjectOrCampaignUsecase(
      title: _formData.title,
      description: _formData.description,
      requiredAmount: _formData.requiredAmount!,
      area: _formData.area!,
      longitude: _formData.selectedLocation!.longitude,
      latitude: _formData.selectedLocation!.latitude,
      categoryId: _formData.categoryId!,
      image: _formData.imagePath!,
      numberOfParticipants: _formData.numberOfParticipants!,
      executionDate: DateFormat('yyyy-MM-dd').format(_formData.executionDate!),
    );
    failureOrSuccess.fold(
      (failure) => emit(
        CampaignManagementError(
          message: _mapFailureToMessage(failure),
          formData: _formData,
        ),
      ),
      (_) {
        _formData = const CreateCampaignFormData();
        emit(const CampaignCreatedSuccess(message: "تم إنشاء الحملة بنجاح!"));
      },
    );
  }

  Future<void> _onChangeCampaignStatus(
    ChangeCampaignStatusEvent event,
    Emitter<CampaignManagementState> emit,
  ) async {
    emit(CampaignManagementLoading(formData: _formData));
    final failureOrSuccess = await changeCampaignStatusUsecase(
      projectId: event.projectId,
    );
    failureOrSuccess.fold(
      (failure) => emit(
        CampaignManagementError(
          message: _mapFailureToMessage(failure),
          formData: _formData,
        ),
      ),
      (_) => emit(
        const CampaignStatusUpdatedSuccess(
          message: "تم تحديث حالة الحملة بنجاح!",
        ),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return NO_INTERNET_ERROR_MESSAGE;
      default:
        return "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.";
    }
  }
}
