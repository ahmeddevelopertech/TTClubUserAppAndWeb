import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ServiceDetailsController extends GetxController implements GetxService {
  final ServiceDetailsRepo serviceDetailsRepo;
  ServiceDetailsController({required this.serviceDetailsRepo});

  Service? _service;
  bool? _isLoading;
  bool _isSubscribedLawyersLoading = false;
  List<ProviderData>? _subscribedLawyers;
  Service? get service => _service;
  bool get isLoading => _isLoading!;
  bool get isSubscribedLawyersLoading => _isSubscribedLawyersLoading;
  List<ProviderData>? get subscribedLawyers => _subscribedLawyers;

  ///discount and discount type based on category discount and service discount
  double? _serviceDiscount = 0.0;
  double get serviceDiscount => _serviceDiscount!;

  String? _discountType;
  String get discountType => _discountType!;

  Future<void> getServiceDetails(
    String serviceID, {
    String fromPage = "",
  }) async {
    _service = null;
    _subscribedLawyers = null;
    _isSubscribedLawyersLoading = false;

    Response response = await serviceDetailsRepo.getServiceDetails(
      serviceID,
      fromPage,
    );
    if (response.body['response_code'] == 'default_200') {
      _service = Service.fromJson(response.body['content']);

      int length = _service!.faqs != null && _service!.faqs!.isNotEmpty ? 4 : 3;
      Get.find<ServiceTabController>().initTabController(length: length);

      await getServiceLawyers(_service!);
    } else {
      _service = Service();
      _subscribedLawyers = [];
      if (response.statusCode != 200) {
        ApiChecker.checkApi(response);
      }
    }
    _isLoading = false;
    update();
  }

  Future<void> getSubscribedLawyersBySubcategory(String subcategoryId) async {
    _isSubscribedLawyersLoading = true;
    update();

    Response response = await serviceDetailsRepo.getProviderBasedOnSubcategory(
      subcategoryId,
    );

    if (response.statusCode == 200) {
      _subscribedLawyers = [];
      final content = response.body['content'];
      if (content is List) {
        for (final element in content) {
          if (element is Map) {
            _subscribedLawyers!.add(
              ProviderData.fromJson(Map<String, dynamic>.from(element)),
            );
          }
        }
      }
    } else {
      _subscribedLawyers = [];
    }

    _isSubscribedLawyersLoading = false;
    update();
  }

  Future<void> getServiceLawyers(Service service) async {
    _isSubscribedLawyersLoading = true;
    update();

    final Map<String, ProviderData> providersById = {};

    final subCategoryId = (service.subCategoryId ?? '').trim();
    final categoryId = (service.categoryId ?? '').trim();

    if (subCategoryId.isNotEmpty) {
      Response response = await serviceDetailsRepo
          .getProviderBasedOnSubcategory(subCategoryId);
      if (response.statusCode == 200) {
        final content = response.body['content'];
        if (content is List) {
          for (final element in content) {
            if (element is Map) {
              final provider = ProviderData.fromJson(
                Map<String, dynamic>.from(element),
              );
              final id = (provider.id ?? '').trim();
              if (id.isNotEmpty) {
                providersById[id] = provider;
              }
            }
          }
        }
      }
    }

    if (providersById.isEmpty) {
      final body = <String, dynamic>{'sort_by': 'default', 'rating': '0'};
      if (categoryId.isNotEmpty) {
        body['category_ids'] = [categoryId];
      }

      final listResponse = await serviceDetailsRepo.getProviderList(
        offset: 1,
        limit: 100,
        body: body,
      );

      if (listResponse.statusCode == 200) {
        final data = listResponse.body['content']?['data'];
        if (data is List) {
          for (final element in data) {
            if (element is! Map) continue;
            final provider = ProviderData.fromJson(
              Map<String, dynamic>.from(element),
            );
            final id = (provider.id ?? '').trim();
            if (id.isEmpty) continue;

            if (subCategoryId.isEmpty) {
              providersById[id] = provider;
              continue;
            }

            final subscriptions = provider.subscribedServices ?? [];
            final hasMatchingSubCategory = subscriptions.any(
              (s) => (s.subCategoryId ?? '').trim() == subCategoryId,
            );
            if (hasMatchingSubCategory) {
              providersById[id] = provider;
            }
          }
        }
      }
    }

    for (final review in service.review ?? <Review>[]) {
      final provider = review.provider;
      final id = (provider?.id ?? '').trim();
      if (provider != null && id.isNotEmpty) {
        providersById.putIfAbsent(id, () => provider);
      }
    }

    _subscribedLawyers = providersById.values.toList();
    _isSubscribedLawyersLoading = false;
    update();
  }

  Future<void> getServiceDiscount() async {
    Service service = _service!;

    ///if category discount not null then calculate category discount
    if (service.campaignDiscount != null) {
      ///service based campaign discount
      _serviceDiscount = service.campaignDiscount!.isNotEmpty
          ? service.campaignDiscount!
                .elementAt(0)
                .discount!
                .discountAmount!
                .toDouble()
          : 0.0;
      _discountType = service.campaignDiscount!.isNotEmpty
          ? service.campaignDiscount!.elementAt(0).discount!.discountType!
          : 'amount';
    } else if (service.category!.campaignDiscount != null) {
      ///category based campaign discount
      _serviceDiscount = service.category!.campaignDiscount!.isNotEmpty
          ? service.category!.campaignDiscount!
                .elementAt(0)
                .discount!
                .discountAmount!
                .toDouble()
          : 0.0;
      _discountType = service.category!.campaignDiscount!.isNotEmpty
          ? service.category!.campaignDiscount!
                .elementAt(0)
                .discount!
                .discountAmountType!
          : 'amount';
    } else if (service.serviceDiscount != null) {
      ///service based service discount
      _serviceDiscount = service.serviceDiscount!.isNotEmpty
          ? service.serviceDiscount!
                .elementAt(0)
                .discount!
                .discountAmount!
                .toDouble()
          : 0.0;
      _discountType = service.serviceDiscount!.isNotEmpty
          ? service.serviceDiscount!.elementAt(0).discount!.discountType!
          : 'amount';
    } else {
      ///category based category discount
      _serviceDiscount = service.category!.categoryDiscount!.isNotEmpty
          ? service.category!.categoryDiscount!
                .elementAt(0)
                .discount!
                .discountAmount!
                .toDouble()
          : 0.0;
      _discountType = service.category!.categoryDiscount!.isNotEmpty
          ? service.category!.categoryDiscount!
                .elementAt(0)
                .discount!
                .discountAmountType!
          : 'amount';
    }
    update();
  }
}
