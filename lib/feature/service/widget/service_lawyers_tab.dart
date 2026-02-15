import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ServiceLawyersTab extends StatelessWidget {
  const ServiceLawyersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WebShadowWrap(
        child: Container(
          width: Dimensions.webMaxWidth,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          color: ResponsiveHelper.isMobile(context)
              ? Theme.of(context).cardColor
              : Colors.transparent,
          child: GetBuilder<ServiceDetailsController>(
            builder: (serviceDetailsController) {
              final lawyers = serviceDetailsController.subscribedLawyers ?? [];

              if (serviceDetailsController.isSubscribedLawyersLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (lawyers.isEmpty) {
                return Center(
                  child: Text(
                    'لا يوجد محامين مقدمين لهذه الخدمة حالياً',
                    style: robotoRegular.copyWith(
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: lawyers.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                itemBuilder: (context, index) {
                  final lawyer = lawyers[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radiusDefault,
                    ),
                    onTap: () {
                      final providerId = lawyer.id;
                      if (providerId != null && providerId.isNotEmpty) {
                        Get.toNamed(RouteHelper.getProviderDetails(providerId));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(
                        Dimensions.paddingSizeSmall,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).hintColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusDefault,
                            ),
                            child: CustomImage(
                              image: lawyer.logoFullPath ?? '',
                              height: 52,
                              width: 52,
                              fit: BoxFit.cover,
                              placeholder: Images.userPlaceHolder,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lawyer.companyName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lawyer.companyPhone ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lawyer.companyAddress ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
