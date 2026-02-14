# توثيق Admin APIs - International Lawyers

## 📋 نظرة عامة

تم إنشاء نظام شامل للتواصل مع Admin APIs الخاصة بالمحامين الدوليين، يشمل:

✅ جلب قائمة المحامين الدوليين  
✅ جلب تفاصيل محامي واحد  
✅ معالجة الأخطاء والـ Fallback  
✅ دعم Pagination والتصفية

---

## 🏗️ البنية المعمارية

### الملفات المنشأة

#### 1. **Models/Entities** 📦
```
lib/feature/tt_club_landing/domain/entities/
├── international_lawyer_provider.dart
│   ├── InternationalLawyerProvider
│   ├── ProviderOwner
│   ├── Account
│   └── ProviderZone
├── international_lawyers_list_response.dart
│   └── InternationalLawyersListResponse
└── international_lawyer_details_response.dart
    ├── InternationalLawyerDetailsResponse
    └── BookingOverview
```

#### 2. **Data Layer** 📡
```
lib/feature/tt_club_landing/data/
├── datasources/
│   └── international_lawyers_admin_remote_datasource.dart
│       └── InternationalLawyersAdminRemoteDataSource
│           ├── getInternationalLawyersList()
│           └── getInternationalLawyerDetails()
└── repositories/
    └── international_lawyers_admin_repository_impl.dart
        └── InternationalLawyersAdminRepositoryImpl
```

#### 3. **Domain Layer** 🎯
```
lib/feature/tt_club_landing/domain/
├── repositories/
│   └── international_lawyers_admin_repository.dart
│       └── InternationalLawyersAdminRepository (Abstract)
└── usecases/
    ├── get_international_lawyers_list_usecase.dart
    │   └── GetInternationalLawyersListUseCase
    └── get_international_lawyer_details_usecase.dart
        └── GetInternationalLawyerDetailsUseCase
```

#### 4. **Presentation Layer** 🎨
```
lib/feature/tt_club_landing/presentation/providers/
└── international_lawyers_admin_providers.dart
    ├── internationalLawyersListProvider
    └── internationalLawyerDetailsProvider
```

---

## 🔌 الـ Endpoints

### 1. جلب قائمة المحامين الدوليين

**Endpoint:**
```
GET /api/v1/admin/provider/data/international-requests
```

**Authentication:**
```
Bearer <admin_token>
Middleware: auth:api
```

**Query Parameters:**
| Parameter | Type | Required | Values |
|-----------|------|----------|--------|
| `limit` | number | ✅ | عدد العناصر في الصفحة |
| `offset` | number | ✅ | رقم الصفحة |
| `request_status` | string | ✅ | `pending`, `denied`, `all` |

**Example:**
```
/api/v1/admin/provider/data/international-requests?limit=10&offset=1&request_status=all
```

**Success Response (200):**
```json
{
  "response_code": "default_200",
  "message": "successfully data fetched",
  "content": {
    "providers": {
      "current_page": 1,
      "data": [
        {
          "id": "provider-uuid",
          "provider_category": "international",
          "is_approved": 2,
          "owner": {
            "id": "user-uuid",
            "account": {
              "id": "...",
              "first_name": "أحمد",
              "last_name": "علي",
              "email": "example@example.com",
              "phone": "+201234567890"
            }
          },
          "zone": {
            "id": "zone-uuid",
            "name": "Cairo",
            "country_code": "EG"
          }
        }
      ]
    },
    "onboarding_count": 5,
    "denied_count": 2
  },
  "errors": []
}
```

**Error Response (400):**
```json
{
  "response_code": "default_400",
  "message": "invalid or missing information",
  "content": null,
  "errors": [
    {
      "error_code": "request_status",
      "message": "The request status field is required."
    }
  ]
}
```

---

### 2. جلب تفاصيل محامي واحد

**Endpoint:**
```
GET /api/v1/admin/provider/data/overview/{user_id}
```

**Note:** اسم الـ path parameter هو `user_id` لكن القيمة الفعلية هي `provider_id`

**Authentication:**
```
Bearer <admin_token>
```

**Path Parameters:**
| Parameter | Type | Required |
|-----------|------|----------|
| `user_id` | string | ✅ |

**Example:**
```
/api/v1/admin/provider/data/overview/PROVIDER_UUID
```

**Success Response (200):**
```json
{
  "response_code": "default_200",
  "message": "successfully data fetched",
  "content": {
    "provider_info": {
      "id": "provider-uuid",
      "provider_category": "international",
      "is_approved": 1,
      "owner": {
        "id": "user-uuid",
        "account": {
          "id": "...",
          "first_name": "محمد",
          "last_name": "حسن",
          "email": "lawyer@example.com",
          "phone": "+201234567890"
        }
      },
      "zone": {
        "id": "zone-uuid",
        "name": "Alexandria",
        "country_code": "EG"
      }
    },
    "booking_overview": [
      {
        "booking_status": "pending",
        "total": 3
      },
      {
        "booking_status": "completed",
        "total": 10
      },
      {
        "booking_status": "cancelled",
        "total": 1
      }
    ]
  },
  "errors": []
}
```

---

## 💻 كيفية الاستخدام

### مثال 1: جلب قائمة المحامين

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demandium/feature/tt_club_landing/presentation/providers/international_lawyers_admin_providers.dart';

class InternationalLawyersListScreen extends ConsumerWidget {
  const InternationalLawyersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lawyersAsync = ref.watch(
      internationalLawyersListProvider(
        (limit: 10, offset: 1, requestStatus: 'all'),
      ),
    );

    return lawyersAsync.when(
      data: (response) {
        return ListView.builder(
          itemCount: response.providers.length,
          itemBuilder: (context, index) {
            final lawyer = response.providers[index];
            return ListTile(
              title: Text(lawyer.owner?.account?.firstName ?? 'Unknown'),
              subtitle: Text(lawyer.owner?.account?.email ?? ''),
              trailing: Text(_getApprovalStatus(lawyer.isApproved)),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  String _getApprovalStatus(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Approved';
      case 2:
        return 'Denied';
      default:
        return 'Unknown';
    }
  }
}
```

### مثال 2: جلب تفاصيل محامي واحد

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demandium/feature/tt_club_landing/presentation/providers/international_lawyers_admin_providers.dart';

class InternationalLawyerDetailsScreen extends ConsumerWidget {
  final String providerId;

  const InternationalLawyerDetailsScreen({
    Key? key,
    required this.providerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(
      internationalLawyerDetailsProvider(providerId),
    );

    return detailsAsync.when(
      data: (response) {
        final provider = response.providerInfo;
        final bookings = response.bookingOverview;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Provider Information
              ListTile(
                title: Text(
                  '${provider.owner?.account?.firstName} ${provider.owner?.account?.lastName}',
                ),
                subtitle: Text(provider.owner?.account?.email ?? ''),
              ),

              // Booking Overview
              const SizedBox(height: 16),
              const Text('Booking Overview'),
              ...bookings.map((booking) => ListTile(
                title: Text(booking.bookingStatus),
                trailing: Text('${booking.total}'),
              )),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
```

### مثال 3: مع Pagination

```dart
class PaginatedLawyersScreen extends ConsumerStatefulWidget {
  const PaginatedLawyersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PaginatedLawyersScreen> createState() =>
      _PaginatedLawyersScreenState();
}

class _PaginatedLawyersScreenState extends ConsumerState<PaginatedLawyersScreen> {
  int currentPage = 1;
  final int pageSize = 10;
  String requestStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final lawyersAsync = ref.watch(
      internationalLawyersListProvider(
        (limit: pageSize, offset: currentPage, requestStatus: requestStatus),
      ),
    );

    return lawyersAsync.when(
      data: (response) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: response.providers.length,
                itemBuilder: (context, index) {
                  final lawyer = response.providers[index];
                  return LawyerTile(lawyer: lawyer);
                },
              ),
            ),
            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                  child: const Text('Previous'),
                ),
                Text('Page $currentPage'),
                ElevatedButton(
                  onPressed: () => setState(() => currentPage++),
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
```

---

## 🎯 Status Codes شرح

| Code | معنى |
|------|------|
| `0` | Pending (قيد المراجعة) |
| `1` | Approved (موافق عليه) |
| `2` | Denied (مرفوض) |

---

## ⚠️ معالجة الأخطاء

### المحاولة الأولى: جلب من API
```dart
try {
  final response = await _apiClient.getData(uri);
  if (response.statusCode == 200) {
    // معالجة البيانات
  } else {
    throw Exception('API Error: ${response.statusText}');
  }
} catch (e) {
  rethrow; // إرسال الخطأ للـ UI
}
```

### في الـ UI:
```dart
lawyersAsync.when(
  data: (data) => showData(data),
  loading: () => showLoading(),
  error: (error, stack) => showError(error),
);
```

---

## 🔐 الأمان

⚠️ **تأكد من:**
- ✅ توفر الـ Admin Token في الـ ApiClient
- ✅ إرسال requests من محسابات authorized فقط
- ✅ التعامل مع الأخطاء بحذر

---

## 📊 Request Status Filters

```dart
// جميع الطلبات
requestStatus = 'all'

// الطلبات المعلقة فقط
requestStatus = 'pending'

// الطلبات المرفوضة فقط
requestStatus = 'denied'
```

---

## 🚀 الخطوات التالية

1. ✅ ربط الـ Endpoints بنجاح
2. ⏳ اختبار الـ APIs بالبيانات الحقيقية
3. ⏳ إنشاء UI Screens لعرض البيانات
4. ⏳ إضافة Loading States و Error Handling
5. ⏳ إضافة Caching إذا لزم الأمر

---

## 📞 للمساعدة

- تحقق من الـ Endpoint URL بدقة
- تأكد من توفر Admin Token
- فعّل Logging لرؤية API Calls


