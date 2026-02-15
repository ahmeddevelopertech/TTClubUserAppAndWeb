# ØªÙˆØ«ÙŠÙ‚ Admin APIs - International Lawyers

## ðŸ“‹ Ù†Ø¸Ø±Ø© Ø¹Ø§Ù…Ø©

ØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ù†Ø¸Ø§Ù… Ø´Ø§Ù…Ù„ Ù„Ù„ØªÙˆØ§ØµÙ„ Ù…Ø¹ Admin APIs Ø§Ù„Ø®Ø§ØµØ© Ø¨Ø§Ù„Ù…Ø­Ø§Ù…ÙŠÙ† Ø§Ù„Ø¯ÙˆÙ„ÙŠÙŠÙ†ØŒ ÙŠØ´Ù…Ù„:

âœ… Ø¬Ù„Ø¨ Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ù…Ø­Ø§Ù…ÙŠÙ† Ø§Ù„Ø¯ÙˆÙ„ÙŠÙŠÙ†  
âœ… Ø¬Ù„Ø¨ ØªÙØ§ØµÙŠÙ„ Ù…Ø­Ø§Ù…ÙŠ ÙˆØ§Ø­Ø¯  
âœ… Ù…Ø¹Ø§Ù„Ø¬Ø© Ø§Ù„Ø£Ø®Ø·Ø§Ø¡ ÙˆØ§Ù„Ù€ Fallback  
âœ… Ø¯Ø¹Ù… Pagination ÙˆØ§Ù„ØªØµÙÙŠØ©

---

## ðŸ—ï¸ Ø§Ù„Ø¨Ù†ÙŠØ© Ø§Ù„Ù…Ø¹Ù…Ø§Ø±ÙŠØ©

### Ø§Ù„Ù…Ù„ÙØ§Øª Ø§Ù„Ù…Ù†Ø´Ø£Ø©

#### 1. **Models/Entities** ðŸ“¦
```
lib/feature/tt_club_landing/domain/entities/
â”œâ”€â”€ international_lawyer_provider.dart
â”‚   â”œâ”€â”€ InternationalLawyerProvider
â”‚   â”œâ”€â”€ ProviderOwner
â”‚   â”œâ”€â”€ Account
â”‚   â””â”€â”€ ProviderZone
â”œâ”€â”€ international_lawyers_list_response.dart
â”‚   â””â”€â”€ InternationalLawyersListResponse
â””â”€â”€ international_lawyer_details_response.dart
    â”œâ”€â”€ InternationalLawyerDetailsResponse
    â””â”€â”€ BookingOverview
```

#### 2. **Data Layer** ðŸ“¡
```
lib/feature/tt_club_landing/data/
â”œâ”€â”€ datasources/
â”‚   â””â”€â”€ international_lawyers_admin_remote_datasource.dart
â”‚       â””â”€â”€ InternationalLawyersAdminRemoteDataSource
â”‚           â”œâ”€â”€ getInternationalLawyersList()
â”‚           â””â”€â”€ getInternationalLawyerDetails()
â””â”€â”€ repositories/
    â””â”€â”€ international_lawyers_admin_repository_impl.dart
        â””â”€â”€ InternationalLawyersAdminRepositoryImpl
```

#### 3. **Domain Layer** ðŸŽ¯
```
lib/feature/tt_club_landing/domain/
â”œâ”€â”€ repositories/
â”‚   â””â”€â”€ international_lawyers_admin_repository.dart
â”‚       â””â”€â”€ InternationalLawyersAdminRepository (Abstract)
â””â”€â”€ usecases/
    â”œâ”€â”€ get_international_lawyers_list_usecase.dart
    â”‚   â””â”€â”€ GetInternationalLawyersListUseCase
    â””â”€â”€ get_international_lawyer_details_usecase.dart
        â””â”€â”€ GetInternationalLawyerDetailsUseCase
```

#### 4. **Presentation Layer** ðŸŽ¨
```
lib/feature/tt_club_landing/presentation/providers/
â””â”€â”€ international_lawyers_admin_providers.dart
    â”œâ”€â”€ internationalLawyersListProvider
    â””â”€â”€ internationalLawyerDetailsProvider
```

---

## ðŸ”Œ Ø§Ù„Ù€ Endpoints

### 1. Ø¬Ù„Ø¨ Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ù…Ø­Ø§Ù…ÙŠÙ† Ø§Ù„Ø¯ÙˆÙ„ÙŠÙŠÙ†

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
| `limit` | number | âœ… | Ø¹Ø¯Ø¯ Ø§Ù„Ø¹Ù†Ø§ØµØ± ÙÙŠ Ø§Ù„ØµÙØ­Ø© |
| `offset` | number | âœ… | Ø±Ù‚Ù… Ø§Ù„ØµÙØ­Ø© |
| `request_status` | string | âœ… | `pending`, `denied`, `all` |

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
              "first_name": "Ø£Ø­Ù…Ø¯",
              "last_name": "Ø¹Ù„ÙŠ",
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

### 2. Ø¬Ù„Ø¨ ØªÙØ§ØµÙŠÙ„ Ù…Ø­Ø§Ù…ÙŠ ÙˆØ§Ø­Ø¯

**Endpoint:**
```
GET /api/v1/admin/provider/data/overview/{user_id}
```

**Note:** Ø§Ø³Ù… Ø§Ù„Ù€ path parameter Ù‡Ùˆ `user_id` Ù„ÙƒÙ† Ø§Ù„Ù‚ÙŠÙ…Ø© Ø§Ù„ÙØ¹Ù„ÙŠØ© Ù‡ÙŠ `provider_id`

**Authentication:**
```
Bearer <admin_token>
```

**Path Parameters:**
| Parameter | Type | Required |
|-----------|------|----------|
| `user_id` | string | âœ… |

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
          "first_name": "Ù…Ø­Ù…Ø¯",
          "last_name": "Ø­Ø³Ù†",
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

## ðŸ’» ÙƒÙŠÙÙŠØ© Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù…

### Ù…Ø«Ø§Ù„ 1: Ø¬Ù„Ø¨ Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ù…Ø­Ø§Ù…ÙŠÙ†

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:GeekXDigital/feature/tt_club_landing/presentation/providers/international_lawyers_admin_providers.dart';

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

### Ù…Ø«Ø§Ù„ 2: Ø¬Ù„Ø¨ ØªÙØ§ØµÙŠÙ„ Ù…Ø­Ø§Ù…ÙŠ ÙˆØ§Ø­Ø¯

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:GeekXDigital/feature/tt_club_landing/presentation/providers/international_lawyers_admin_providers.dart';

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

### Ù…Ø«Ø§Ù„ 3: Ù…Ø¹ Pagination

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

## ðŸŽ¯ Status Codes Ø´Ø±Ø­

| Code | Ù…Ø¹Ù†Ù‰ |
|------|------|
| `0` | Pending (Ù‚ÙŠØ¯ Ø§Ù„Ù…Ø±Ø§Ø¬Ø¹Ø©) |
| `1` | Approved (Ù…ÙˆØ§ÙÙ‚ Ø¹Ù„ÙŠÙ‡) |
| `2` | Denied (Ù…Ø±ÙÙˆØ¶) |

---

## âš ï¸ Ù…Ø¹Ø§Ù„Ø¬Ø© Ø§Ù„Ø£Ø®Ø·Ø§Ø¡

### Ø§Ù„Ù…Ø­Ø§ÙˆÙ„Ø© Ø§Ù„Ø£ÙˆÙ„Ù‰: Ø¬Ù„Ø¨ Ù…Ù† API
```dart
try {
  final response = await _apiClient.getData(uri);
  if (response.statusCode == 200) {
    // Ù…Ø¹Ø§Ù„Ø¬Ø© Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª
  } else {
    throw Exception('API Error: ${response.statusText}');
  }
} catch (e) {
  rethrow; // Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø®Ø·Ø£ Ù„Ù„Ù€ UI
}
```

### ÙÙŠ Ø§Ù„Ù€ UI:
```dart
lawyersAsync.when(
  data: (data) => showData(data),
  loading: () => showLoading(),
  error: (error, stack) => showError(error),
);
```

---

## ðŸ” Ø§Ù„Ø£Ù…Ø§Ù†

âš ï¸ **ØªØ£ÙƒØ¯ Ù…Ù†:**
- âœ… ØªÙˆÙØ± Ø§Ù„Ù€ Admin Token ÙÙŠ Ø§Ù„Ù€ ApiClient
- âœ… Ø¥Ø±Ø³Ø§Ù„ requests Ù…Ù† Ù…Ø­Ø³Ø§Ø¨Ø§Øª authorized ÙÙ‚Ø·
- âœ… Ø§Ù„ØªØ¹Ø§Ù…Ù„ Ù…Ø¹ Ø§Ù„Ø£Ø®Ø·Ø§Ø¡ Ø¨Ø­Ø°Ø±

---

## ðŸ“Š Request Status Filters

```dart
// Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø·Ù„Ø¨Ø§Øª
requestStatus = 'all'

// Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø¹Ù„Ù‚Ø© ÙÙ‚Ø·
requestStatus = 'pending'

// Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø±ÙÙˆØ¶Ø© ÙÙ‚Ø·
requestStatus = 'denied'
```

---

## ðŸš€ Ø§Ù„Ø®Ø·ÙˆØ§Øª Ø§Ù„ØªØ§Ù„ÙŠØ©

1. âœ… Ø±Ø¨Ø· Ø§Ù„Ù€ Endpoints Ø¨Ù†Ø¬Ø§Ø­
2. â³ Ø§Ø®ØªØ¨Ø§Ø± Ø§Ù„Ù€ APIs Ø¨Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø­Ù‚ÙŠÙ‚ÙŠØ©
3. â³ Ø¥Ù†Ø´Ø§Ø¡ UI Screens Ù„Ø¹Ø±Ø¶ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª
4. â³ Ø¥Ø¶Ø§ÙØ© Loading States Ùˆ Error Handling
5. â³ Ø¥Ø¶Ø§ÙØ© Caching Ø¥Ø°Ø§ Ù„Ø²Ù… Ø§Ù„Ø£Ù…Ø±

---

## ðŸ“ž Ù„Ù„Ù…Ø³Ø§Ø¹Ø¯Ø©

- ØªØ­Ù‚Ù‚ Ù…Ù† Ø§Ù„Ù€ Endpoint URL Ø¨Ø¯Ù‚Ø©
- ØªØ£ÙƒØ¯ Ù…Ù† ØªÙˆÙØ± Admin Token
- ÙØ¹Ù‘Ù„ Logging Ù„Ø±Ø¤ÙŠØ© API Calls



