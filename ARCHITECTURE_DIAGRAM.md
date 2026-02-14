# 🏗️ Architecture Diagram - Admin International Lawyers APIs

## الهيكل المعماري الكامل

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                                  │
│                         (Flutter UI & Widgets)                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌─────────────────────────┬────────────────────────────────────────────┐   │
│  │   InternationalLawyers  │   InternationalLawyer                      │   │
│  │   ListScreen            │   DetailsScreen                            │   │
│  └────────────┬────────────┴────────────────┬─────────────────────────┘   │
│               │                             │                               │
│               └─────────────────┬───────────┘                               │
│                                 │                                           │
│                    Riverpod ref.watch()                                     │
│                                 │                                           │
└─────────────────────────────────┼───────────────────────────────────────────┘
                                  │
┌─────────────────────────────────▼───────────────────────────────────────────┐
│                        PROVIDERS LAYER                                       │
│              (Riverpod Providers + State Management)                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌──────────────────────────────┬──────────────────────────────────────┐   │
│  │  internationalLawyersListProvider          │  internationalLawyerDetailsProvider   │   │
│  │  (FutureProvider)                          │  (FutureProvider)                    │   │
│  └──────────┬───────────────────┴──────────────┬────────────────────┘   │
│             │                                  │                        │
│             └──────────────┬───────────────────┘                        │
│                            │                                            │
└────────────────────────────┼──────────────────────────────────────────┘
                             │
┌────────────────────────────▼──────────────────────────────────────────────┐
│                        DOMAIN LAYER                                        │
│                 (Business Logic & Use Cases)                              │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌─────────────────────────────┬──────────────────────────────────────┐  │
│  │ GetInternationalLawyers     │ GetInternationalLawyer               │  │
│  │ ListUseCase                 │ DetailsUseCase                       │  │
│  │                             │                                      │  │
│  │ call(limit, offset, status) │ call(providerId)                     │  │
│  └──────────────┬──────────────┴──────────────┬─────────────────────┘  │
│                 │                             │                        │
│                 └─────────────┬───────────────┘                        │
│                               │                                        │
│           InternationalLawyersAdminRepository                          │
│                 (Abstract Interface)                                   │
│                               │                                        │
└───────────────────────────────┼────────────────────────────────────────┘
                                │
┌───────────────────────────────▼────────────────────────────────────────────┐
│                        DATA LAYER                                          │
│                 (Repositories & Data Sources)                             │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │  InternationalLawyersAdminRepositoryImpl                            │  │
│  │  (Concrete Repository Implementation)                              │  │
│  │                                                                     │  │
│  │  • getInternationalLawyersList()                                   │  │
│  │  • getInternationalLawyerDetails()                                 │  │
│  └────────────────────┬────────────────────────────────────────────┘  │
│                       │                                              │
│          ┌────────────▼────────────────────┐                        │
│          │  Remote Data Source             │                        │
│          │ (InternationalLawyers           │                        │
│          │  AdminRemoteDataSource)         │                        │
│          │                                 │                        │
│          │ • _parseResponse()              │                        │
│          │ • Error handling                │                        │
│          └────────────┬────────────────────┘                        │
│                       │                                              │
└───────────────────────┼──────────────────────────────────────────────┘
                        │
┌───────────────────────▼──────────────────────────────────────────────────┐
│                    API CLIENT LAYER                                      │
│               (HTTP Communication & Headers)                            │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  ApiClient (GetX Service)                                        │   │
│  │  • getData(uri)                                                  │   │
│  │  • Headers Management                                           │   │
│  │  • Token Handling                                               │   │
│  │  • Response Parsing                                             │   │
│  └──────────────────┬───────────────────────────────────────────┘   │
│                     │                                              │
└─────────────────────┼──────────────────────────────────────────────┘
                      │
┌─────────────────────▼────────────────────────────────────────────────────┐
│                      NETWORK LAYER                                       │
│                  (HTTP Requests to API)                                 │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  GET /api/v1/admin/provider/data/international-requests                   │
│  GET /api/v1/admin/provider/data/overview/{provider_id}                   │
│                                                                            │
│  Headers:                                                                 │
│  • Authorization: Bearer {admin_token}                                    │
│  • Content-Type: application/json                                        │
│  • Custom Headers (zone_id, language, guest_id)                          │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
                            │
                            │ HTTP
                            │
┌───────────────────────────▼────────────────────────────────────────────────┐
│                      BACKEND API SERVER                                    │
│                    (Base URL: Admin.ttclub.org)                           │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Endpoint 1: GET /api/v1/admin/provider/data/international-requests       │
│  └─ Returns: InternationalLawyersListResponse                             │
│     ├─ providers (List<InternationalLawyerProvider>)                      │
│     ├─ currentPage (int)                                                  │
│     ├─ onboardingCount (int)                                             │
│     └─ deniedCount (int)                                                 │
│                                                                            │
│  Endpoint 2: GET /api/v1/admin/provider/data/overview/{provider_id}       │
│  └─ Returns: InternationalLawyerDetailsResponse                           │
│     ├─ providerInfo (InternationalLawyerProvider)                        │
│     └─ bookingOverview (List<BookingOverview>)                           │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Data Flow Diagram

```
User Interaction
        │
        ▼
┌──────────────────────────────────────┐
│  Widget calls ref.watch(provider)    │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  Riverpod Provider receives request  │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  Use Case is invoked                 │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  Repository.getInternationalLawyers()│
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  RemoteDataSource.getInternational() │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  ApiClient.getData(uri)              │
└──────────────────────────────────────┘
        │
        ▼ (HTTP GET)
┌──────────────────────────────────────┐
│  API Server Processes Request        │
└──────────────────────────────────────┘
        │
        ▼ (JSON Response)
┌──────────────────────────────────────┐
│  Parse JSON to Response               │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  Convert to Dart Models              │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  Return AsyncValue<Response>         │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  Widget receives data via ref.watch() │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  .when() matches state               │
│  ├─ data: Display results            │
│  ├─ loading: Show spinner            │
│  └─ error: Show error message        │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  UI is rebuilt with new data         │
└──────────────────────────────────────┘
```

---

## 🗂️ File Structure Tree

```
lib/feature/tt_club_landing/
│
├── domain/
│   ├── entities/
│   │   ├── international_lawyer_provider.dart
│   │   │   ├─ InternationalLawyerProvider
│   │   │   ├─ ProviderOwner
│   │   │   ├─ Account
│   │   │   └─ ProviderZone
│   │   │
│   │   ├── international_lawyers_list_response.dart
│   │   │   └─ InternationalLawyersListResponse
│   │   │
│   │   └── international_lawyer_details_response.dart
│   │       ├─ InternationalLawyerDetailsResponse
│   │       └─ BookingOverview
│   │
│   ├── repositories/
│   │   ├── international_lawyers_repository.dart (existing)
│   │   └── international_lawyers_admin_repository.dart (new)
│   │
│   ├── usecases/
│   │   ├── get_international_lawyers_usecase.dart (existing)
│   │   ├── get_international_lawyers_list_usecase.dart (new)
│   │   └── get_international_lawyer_details_usecase.dart (new)
│   │
│   └── ... (other domain files)
│
├── data/
│   ├── datasources/
│   │   ├── international_lawyers_local_datasource.dart (existing)
│   │   ├── international_lawyers_remote_datasource.dart (existing)
│   │   └── international_lawyers_admin_remote_datasource.dart (new)
│   │
│   ├── repositories/
│   │   ├── international_lawyers_repository_impl.dart (modified)
│   │   └── international_lawyers_admin_repository_impl.dart (new)
│   │
│   └── ... (other data files)
│
├── presentation/
│   ├── providers/
│   │   ├── international_lawyers_providers.dart (existing)
│   │   └── international_lawyers_admin_providers.dart (new)
│   │
│   ├── pages/
│   │   ├── international_lawyers_page.dart (existing)
│   │   └── ... (other pages)
│   │
│   ├── widgets/
│   │   └── international_lawyers_marquee.dart (existing)
│   │
│   └── ... (other presentation files)
│
└── ... (other features)

api/
└── remote/
    └── client_api.dart (used for HTTP requests)
```

---

## 🔄 Dependency Injection Flow

```
┌─────────────────────────────────────────────┐
│  Riverpod Provider                          │
│  (Final internationalLawyersListProvider)   │
└─────────────┬───────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│  _getInternationalLawyersListUseCaseProvider│
└─────────────┬───────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│  _internationalLawyersAdminRepositoryProvider
└─────────────┬───────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│  InternationalLawyersAdminRepositoryImpl     │
└─────────────┬───────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│  _internationalLawyersAdminRemoteDataSourceProvider
└─────────────┬───────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│  InternationalLawyersAdminRemoteDataSource  │
└─────────────┬───────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│  ApiClient (Get.find<ApiClient>())          │
│  (Already registered by GetX)               │
└─────────────────────────────────────────────┘
```

---

## 🔀 Request Flow Sequence

```
┌──────┐         ┌─────────┐        ┌────────────┐        ┌────────┐
│ User │         │ Provider│        │ UseCase    │        │ Repo   │
└──────┘         └─────────┘        └────────────┘        └────────┘
  │                 │                    │                    │
  │ ref.watch()     │                    │                    │
  ├────────────────>│                    │                    │
  │                 │ call()             │                    │
  │                 ├───────────────────>│                    │
  │                 │                    │ getInternational() │
  │                 │                    ├───────────────────>│
  │                 │                    │                    │
  │                 │                    │       (continues to RemoteDataSource)
  │                 │                    │       (then to ApiClient)
  │                 │                    │       (then to HTTP)
  │                 │                    │       (then to API Server)
  │                 │                    │       (API processes request)
  │                 │                    │       (API returns JSON)
  │                 │                    │       (parse response)
  │                 │                    │       (convert to models)
  │                 │                    │
  │                 │<───────────────────┤
  │                 │    Response        │
  │<────────────────┤                    │
  │  AsyncValue     │                    │
  │                 │                    │
  │ .when()         │                    │
  ├─────┬──────┬───┤                    │
  │     │      │   │                    │
  │ data│load │err│                    │
  │     │ing  │or │                    │
  └─────┴──────┴───┘                    │
```

---

## 📊 Model Relationships

```
InternationalLawyersListResponse
├─ providers[]
│  └─ InternationalLawyerProvider
│     ├─ id: String
│     ├─ providerCategory: String
│     ├─ isApproved: int (0,1,2)
│     ├─ owner: ProviderOwner
│     │  ├─ id: String
│     │  └─ account: Account
│     │     ├─ id: String
│     │     ├─ firstName: String
│     │     ├─ lastName: String
│     │     ├─ email: String
│     │     └─ phone: String
│     └─ zone: ProviderZone
│        ├─ id: String
│        ├─ name: String
│        └─ countryCode: String
├─ currentPage: int
├─ onboardingCount: int
└─ deniedCount: int

InternationalLawyerDetailsResponse
├─ providerInfo: InternationalLawyerProvider (as above)
└─ bookingOverview[]
   └─ BookingOverview
      ├─ bookingStatus: String
      └─ total: int
```

---

## 🎯 Architecture Principles Applied

```
┌────────────────────────────────────────────┐
│  Clean Architecture Layers                 │
├────────────────────────────────────────────┤
│                                            │
│  ✓ Presentation Layer: Separate UI from   │
│    business logic                         │
│                                           │
│  ✓ Domain Layer: Pure business logic,    │
│    no framework dependencies              │
│                                           │
│  ✓ Data Layer: Encapsulate API &         │
│    persistence logic                      │
│                                           │
│  ✓ Dependency Injection: Loose coupling  │
│                                           │
│  ✓ Repository Pattern: Abstract data    │
│    sources                                │
│                                           │
│  ✓ Use Cases: Single responsibility      │
│                                           │
└────────────────────────────────────────────┘
```

---

## 📈 State Management Flow

```
Initial State: AsyncValue.loading()
        │
        ▼
┌──────────────────────────────────┐
│  Making API Request              │
└──────────────────────────────────┘
        │
        ├─ Success ──────────────────┐
        │                            │
        ▼                            ▼
┌──────────────────────┐    ┌─────────────────┐
│ AsyncValue.data()    │    │ AsyncValue.error│
│ (InternationalLaw..) │    │ (Exception)     │
└──────────────────────┘    └─────────────────┘
        │                            │
        ▼                            ▼
   [Display Data]              [Show Error]
```

---

هذا الـ Diagram يوضح البنية المعمارية الكاملة للنظام! 🎉


