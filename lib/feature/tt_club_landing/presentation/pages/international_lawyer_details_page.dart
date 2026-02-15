import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/international_lawyer_visual.dart';
import '../providers/international_lawyers_admin_providers.dart';
import '../widgets/lawyer_network_image.dart';

class InternationalLawyerDetailsPage extends ConsumerWidget {
  final InternationalLawyerVisual lawyer;

  const InternationalLawyerDetailsPage({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(internationalLawyerDetailsProvider(lawyer.id));

    final country = lawyer.countryName.trim().isNotEmpty
        ? lawyer.countryName.trim()
        : (lawyer.countryCode?.trim().isNotEmpty ?? false)
            ? lawyer.countryCode!.trim()
            : '-';
    final fallbackName =
        lawyer.name.trim().isNotEmpty ? lawyer.name.trim() : 'محامي دولي';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('بيانات المحامي')),
        body: detailsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              'تعذر تحميل البيانات\n$e',
              textAlign: TextAlign.center,
            ),
          ),
          data: (details) {
            final provider = details.providerInfo;
            final fullName = [
              provider.owner?.account?.firstName ?? '',
              provider.owner?.account?.lastName ?? '',
            ].where((e) => e.trim().isNotEmpty).join(' ').trim();
            final name = (provider.companyName?.trim().isNotEmpty ?? false)
                ? provider.companyName!.trim()
                : (fullName.isNotEmpty ? fullName : fallbackName);
            final detailsPhone = (provider.phone?.trim().isNotEmpty ?? false)
                ? provider.phone!.trim()
                : (provider.owner?.account?.phone?.trim().isNotEmpty ?? false)
                    ? provider.owner!.account!.phone!.trim()
                    : (lawyer.phone?.trim() ?? '');
            final detailsAddress = (provider.address?.trim().isNotEmpty ?? false)
                ? provider.address!.trim()
                : (provider.owner?.account?.address?.trim().isNotEmpty ?? false)
                    ? provider.owner!.account!.address!.trim()
                    : (lawyer.address?.trim() ?? '');
            final detailsPhoto = (provider.logo?.trim().isNotEmpty ?? false)
                ? provider.logo!.trim()
                : (provider.owner?.account?.profileImage?.trim().isNotEmpty ?? false)
                    ? provider.owner!.account!.profileImage!.trim()
                    : lawyer.photoAsset;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: ClipOval(
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: LawyerNetworkImage(
                        path: detailsPhoto,
                        fit: BoxFit.cover,
                        fallback: const Icon(Icons.person, size: 60),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _InfoTile(title: 'الاسم', value: name),
                _InfoTile(title: 'البلد', value: country),
                if (detailsAddress.isNotEmpty)
                  _InfoTile(title: 'العنوان', value: detailsAddress),
                if ((lawyer.specialty?.trim().isNotEmpty ?? false))
                  _InfoTile(title: 'النوع', value: lawyer.specialty!.trim()),
                if (detailsPhone.isNotEmpty)
                  _InfoTile(title: 'الموبايل', value: detailsPhone),
                if ((lawyer.email?.trim().isNotEmpty ?? false))
                  _InfoTile(title: 'البريد', value: lawyer.email!.trim()),
                if (details.bookingOverview.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'ملخص الحجوزات',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  ...details.bookingOverview.map(
                    (item) => _InfoTile(
                      title: item.bookingStatus,
                      value: item.total.toString(),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6B36A), width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
