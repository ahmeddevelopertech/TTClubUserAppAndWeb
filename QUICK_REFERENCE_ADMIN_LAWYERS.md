# Quick Reference - Admin Lawyers APIs

## ðŸš€ Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„Ø³Ø±ÙŠØ¹

### Ø§Ø³ØªÙŠØ±Ø§Ø¯ Ø§Ù„Ù€ Providers
```dart
import 'package:GeekXDigital/feature/tt_club_landing/presentation/providers/international_lawyers_admin_providers.dart';
```

### 1ï¸âƒ£ Ø¬Ù„Ø¨ Ø§Ù„Ù‚Ø§Ø¦Ù…Ø© - Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„Ø£Ø³Ø§Ø³ÙŠ
```dart
class LawyersListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lawyersAsync = ref.watch(
      internationalLawyersListProvider(
        (limit: 10, offset: 1, requestStatus: 'all'),
      ),
    );

    return lawyersAsync.when(
      data: (response) => ListView.builder(
        itemCount: response.providers.length,
        itemBuilder: (_, i) => LawyerCard(response.providers[i]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
```

### 2ï¸âƒ£ Ø¬Ù„Ø¨ Ø§Ù„ØªÙØ§ØµÙŠÙ„ - Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„Ø£Ø³Ø§Ø³ÙŠ
```dart
class LawyerDetailsScreen extends ConsumerWidget {
  final String providerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(
      internationalLawyerDetailsProvider(providerId),
    );

    return detailsAsync.when(
      data: (response) => Column(
        children: [
          Text(response.providerInfo.owner?.account?.firstName ?? ''),
          ...response.bookingOverview.map(
            (b) => Text('${b.bookingStatus}: ${b.total}'),
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
```

---

## ðŸ“Š Request Status Values

```dart
'all'      // Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø·Ù„Ø¨Ø§Øª
'pending'  // Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø¹Ù„Ù‚Ø©
'denied'   // Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø±ÙÙˆØ¶Ø©
```

---

## ðŸ” Ø§Ù„ÙˆØµÙˆÙ„ Ù„Ù„Ø¨ÙŠØ§Ù†Ø§Øª

### Ù…Ù† List Response:
```dart
response.providers          // List<InternationalLawyerProvider>
response.currentPage        // int
response.onboardingCount    // int
response.deniedCount        // int
```

### Ù…Ù† Details Response:
```dart
response.providerInfo                        // InternationalLawyerProvider
response.providerInfo.id                     // String
response.providerInfo.owner?.account?.firstName  // String
response.providerInfo.owner?.account?.email     // String
response.providerInfo.zone?.name            // String
response.bookingOverview                    // List<BookingOverview>
```

---

## ðŸ“ Filter Examples

### Filter by status
```dart
// Pending only
internationalLawyersListProvider(
  (limit: 10, offset: 1, requestStatus: 'pending'),
)

// Denied only
internationalLawyersListProvider(
  (limit: 10, offset: 1, requestStatus: 'denied'),
)
```

### Pagination
```dart
// Page 1
offset: 1

// Page 2
offset: 2

// Page 5
offset: 5
```

### Change page size
```dart
// 5 items per page
limit: 5

// 20 items per page
limit: 20

// 50 items per page
limit: 50
```

---

## ðŸŽ¯ Approval Status

```dart
// In InternationalLawyerProvider
lawyer.isApproved == 0  // pending
lawyer.isApproved == 1  // approved
lawyer.isApproved == 2  // denied
```

---

## ðŸ”„ Refresh Data

```dart
// ÙÙŠ StatefulWidget
void refresh() {
  ref.refresh(internationalLawyersListProvider(
    (limit: 10, offset: 1, requestStatus: 'all'),
  ));
}

// Ø£Ùˆ ÙÙŠ ConsumerWidget
final refreshAsync = ref.watch(
  internationalLawyersListProvider(...),
);
```

---

## âš¡ Tips & Tricks

### Combine with Filters
```dart
class FilteredLawyersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = useState('all');
    
    final lawyersAsync = ref.watch(
      internationalLawyersListProvider(
        (limit: 10, offset: 1, requestStatus: status.value),
      ),
    );

    return Column(
      children: [
        // Filter buttons
        Row(
          children: [
            FilterButton('All', () => status.value = 'all'),
            FilterButton('Pending', () => status.value = 'pending'),
            FilterButton('Denied', () => status.value = 'denied'),
          ],
        ),
        // List
        Expanded(child: lawyersAsync.when(...)),
      ],
    );
  }
}
```

### With Pagination
```dart
class PaginatedLawyersScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<PaginatedLawyersScreen> createState() => 
    _PaginatedLawyersScreenState();
}

class _PaginatedLawyersScreenState 
  extends ConsumerState<PaginatedLawyersScreen> {
  
  int page = 1;

  @override
  Widget build(BuildContext context) {
    final lawyersAsync = ref.watch(
      internationalLawyersListProvider(
        (limit: 10, offset: page, requestStatus: 'all'),
      ),
    );

    return Column(
      children: [
        Expanded(child: lawyersAsync.when(...)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (page > 1)
              ElevatedButton(
                onPressed: () => setState(() => page--),
                child: Text('Previous'),
              ),
            Text('Page $page'),
            ElevatedButton(
              onPressed: () => setState(() => page++),
              child: Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## ðŸ› ï¸ Error Handling

```dart
lawyersAsync.when(
  data: (response) {
    // Display data
  },
  loading: () {
    // Show loading indicator
  },
  error: (error, stackTrace) {
    // Handle error
    print('Error: $error');
    print('Stack: $stackTrace');
    
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${error.toString()}')),
    );
  },
);
```

---

## ðŸ“± Full Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:GeekXDigital/feature/tt_club_landing/presentation/providers/international_lawyers_admin_providers.dart';

class AdminLawyersPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<AdminLawyersPage> createState() => _AdminLawyersPageState();
}

class _AdminLawyersPageState extends ConsumerState<AdminLawyersPage> {
  int currentPage = 1;
  String filterStatus = 'all';
  final pageSize = 10;

  @override
  Widget build(BuildContext context) {
    final lawyersAsync = ref.watch(
      internationalLawyersListProvider(
        (limit: pageSize, offset: currentPage, requestStatus: filterStatus),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('International Lawyers'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => ref.refresh(
              internationalLawyersListProvider(
                (limit: pageSize, offset: currentPage, requestStatus: filterStatus),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              children: ['all', 'pending', 'denied'].map((status) {
                return FilterChip(
                  label: Text(status),
                  selected: filterStatus == status,
                  onSelected: (_) {
                    setState(() {
                      filterStatus = status;
                      currentPage = 1;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          // List
          Expanded(
            child: lawyersAsync.when(
              data: (response) => ListView.builder(
                itemCount: response.providers.length,
                itemBuilder: (_, i) {
                  final lawyer = response.providers[i];
                  return ListTile(
                    title: Text(
                      lawyer.owner?.account?.firstName ?? 'Unknown',
                    ),
                    subtitle: Text(lawyer.owner?.account?.email ?? ''),
                    trailing: _buildStatusBadge(lawyer.isApproved),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LawyerDetailsScreen(
                          providerId: lawyer.id,
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ),
          // Pagination
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                  child: Text('Previous'),
                ),
                Text('Page $currentPage'),
                ElevatedButton(
                  onPressed: () => setState(() => currentPage++),
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(int status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status == 0
            ? Colors.orange
            : status == 1
                ? Colors.green
                : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status == 0 ? 'Pending' : status == 1 ? 'Approved' : 'Denied',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
```

---

## ðŸ“¦ Exports

```dart
// All models
export 'international_lawyer_provider.dart';
export 'international_lawyers_list_response.dart';
export 'international_lawyer_details_response.dart';

// All providers
export 'international_lawyers_admin_providers.dart';
```

---



