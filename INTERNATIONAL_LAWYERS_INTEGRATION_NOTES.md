# توثيق تعديل International Lawyers - Endpoint Integration

## 📋 الملخص
تم تحديث نظام جلب بيانات المحامين الدوليين للتواصل مع الـ Remote API بدلاً من الاعتماد كلياً على البيانات المحلية.

---

## 🔄 التغييرات التي تمت

### 1️⃣ **إنشاء Remote DataSource الجديد**
- **الملف:** `international_lawyers_remote_datasource.dart`
- **المسار:** `lib/feature/tt_club_landing/data/datasources/`
- **الوظيفة:** 
  - التواصل مع الـ API عبر `ApiClient`
  - معالجة الـ Response بمرونة (String, List, Map)
  - إرجاع قائمة `InternationalLawyerVisual`

**الـ Endpoint المستخدم:**
```
GET /api/v1/international-lawyers
```

**صيغة الـ Response المتوقعة:**
```json
// Option 1: Direct Array
[
  {
    "id": "intl_001",
    "name": "...",
    "countryName": "...",
    "photoAsset": "...",
    ...
  },
  ...
]

// Option 2: Object with data array
{
  "data": [
    {...},
    ...
  ]
}
```

### 2️⃣ **تحديث Repository Implementation**
- **الملف:** `international_lawyers_repository_impl.dart`
- **التغييرات:**
  - إضافة `InternationalLawyersRemoteDataSource`
  - تطبيق **Smart Fallback Strategy**:
    - 🌐 أولاً: محاولة جلب البيانات من Remote API
    - 📱 عند الفشل: الرجوع للبيانات المحلية (Local Cache)

**الكود:**
```dart
@override
Future<List<InternationalLawyerVisual>> getInternationalLawyers() async {
  try {
    // Try to fetch from remote API first
    return await _remote.getInternationalLawyers();
  } catch (e) {
    // Fallback to local data if remote fails
    return await _local.load();
  }
}
```

### 3️⃣ **تحديث Riverpod Providers**
- **الملف:** `international_lawyers_providers.dart`
- **التغييرات:**
  - إضافة `_internationalLawyersRemoteDataSourceProvider`
  - ربط `ApiClient` من GetX
  - تحديث `_internationalLawyersRepositoryProvider` لاستخدام كلا الـ DataSources

---

## 🚀 كيفية الاستخدام

لا توجد تغييرات في طريقة الاستخدام! النظام يعمل تلقائياً:

```dart
// في الـ UI (مثل InternationalLawyersPage)
final lawyers = ref.watch(internationalLawyersProvider);

lawyers.when(
  data: (list) => YourWidget(items: list),
  loading: () => LoadingWidget(),
  error: (err, stack) => ErrorWidget(error: err),
);
```

---

## 🔧 التعديلات المستقبلية المطلوبة (إذا لزم الأمر)

### تغيير الـ Endpoint
إذا كان الـ Endpoint مختلفاً عن `/api/v1/international-lawyers`:

1. افتح `international_lawyers_remote_datasource.dart`
2. غير السطر:
```dart
final response = await _apiClient.getData('/api/v1/international-lawyers');
```

### تغيير معالجة الـ Response
إذا كانت صيغة الـ Response مختلفة:
- عدّل الكود في `getInternationalLawyers()` في ملف Remote DataSource

### إضافة Caching
إذا أردت تخزين البيانات مؤقتاً:
- يمكن إضافة Cache Layer بين Repository و DataSource

---

## 📊 البنية الكاملة الآن

```
Domain Layer (Business Logic)
├── InternationalLawyersRepository (Abstract)
└── GetInternationalLawyersUseCase

Data Layer (Data Management)
├── InternationalLawyersRepositoryImpl (Concrete)
│   ├── Remote DataSource ← 🌐 API
│   └── Local DataSource ← 📱 JSON Assets
└── InternationalLawyerVisual (Entity/Model)

Presentation Layer (UI)
├── Riverpod Providers
├── InternationalLawyersPage (Consumer Widget)
└── InternationalLawyersMarquee (Widget)
```

---

## ✅ الفوائد

| الميزة | الفائدة |
|-------|--------|
| **Separation of Concerns** | كل DataSource له مسؤولية واحدة |
| **Flexibility** | سهل التبديل بين Remote و Local |
| **Offline Support** | البيانات المحلية تعمل عند قطع الإنترنت |
| **Testability** | سهل كتابة Unit Tests |
| **Maintainability** | كود نظيف وسهل الصيانة |

---

## 🎯 التالي

- ✅ تم ربط الـ Endpoint
- ⏳ اختبار الـ API بالبيانات الحقيقية
- ⏳ التعديل على البيانات حسب الحاجة
- ⏳ إضافة Loading States و Error Handling إذا لزم

---


