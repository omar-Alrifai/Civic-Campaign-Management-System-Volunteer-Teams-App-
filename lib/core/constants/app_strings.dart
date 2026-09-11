class AppStrings {
  // Registration steps
  static const String personalInfo = 'المعلومات الشخصية';
  static const String accountInfo = 'معلومات الحساب';
  static const String locationInfo = 'معلومات الموقع';
  static const String skillsInfo = 'المهارات والمجالات';

  // Fields
  static const String name = 'الاسم';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String phone = 'الهاتف';
  static const String age = 'العمر';
  static const String gender = 'الجنس';
  static const String bio = 'نبذة عنك';
  static const String area = 'المنطقة';
  static const String skills = 'المهارات';
  static const String volunteerFields = 'مجالات التطوع';
  static const String image = 'الصورة الشخصية';

  // Validation messages
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String invalidEmail = 'بريد إلكتروني غير صالح';
  static const String shortPassword = 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
  static const String passwordMismatch = 'كلمات المرور غير متطابقة';
  static const String invalidPhone = 'رقم هاتف غير صالح';
  static const String invalidAge = 'عمر غير صالح';

  // Genders
  static const String male = 'ذكر';
  static const String female = 'أنثى';

  // Buttons
  static const String next = 'التالي';
  static const String back = 'السابق';
  static const String submit = 'تسجيل';
  static const String skip = 'تخطي';

  // Areas
  static const List<String> areas = [
    'دمشق القديمة',
    'ساروجة',
    'القنوات',
    'جوبر',
    'الميدان',
    'الشاغور',
    'القدم',
    'كفر سوسة',
    'المزة',
    'دمر',
    'برزة',
    'القابون',
    'ركن الدين',
    'الصالحية',
    'المهاجرين',
    'اليرموك'
  ];

  // Skills
  static const List<String> skillsList = [
    'تمريض',
    'طبخ',
    'جمع تبرعات',
    'تصوير',
    'مهنية'
  ];

  // Volunteer fields
  static const List<String> volunteerFieldsList = [
    'ترميم بيوت',
    'توزيع مساعدات',
    'تنظيم فعالية',
    'إغاثة الكوارث',
    'مساعدات الطريق',
    'تنظيف البيئة'
  ];
}