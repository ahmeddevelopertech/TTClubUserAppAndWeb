import 'package:demandium/utils/core_export.dart';

/// A lightweight internal screen to show provider phone number.
///
/// NOTE:
/// We intentionally avoid adding extra packages. If your main app already
/// includes a dialing utility (e.g., via url_launcher), you can wire it here
/// without changing the Provider Details UI.
class CallScreen extends StatelessWidget {
  final String phone;
  final String? providerName;

  const CallScreen({super.key, required this.phone, this.providerName});

  @override
  Widget build(BuildContext context) {
    final String normalizedPhone = phone.trim();

    return Scaffold(
      appBar: CustomAppBar(title: 'الاتصال', showCart: false),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Dimensions.webMaxWidth),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                side: BorderSide(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((providerName ?? '').trim().isNotEmpty) ...[
                      Text(
                        providerName!.trim(),
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],

                    Text('رقم المزود', style: robotoMedium),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(
                        Dimensions.paddingSizeDefault,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                        color: Theme.of(context).hoverColor,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).hintColor.withValues(alpha: 0.15),
                        ),
                      ),
                      child: SelectableText(
                        normalizedPhone.isEmpty ? 'غير متاح' : normalizedPhone,
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonText: 'اتصال الآن',
                            backgroundColor: normalizedPhone.isEmpty
                                ? Theme.of(
                                    context,
                                  ).hintColor.withValues(alpha: 0.3)
                                : Theme.of(context).colorScheme.primary,
                            textColor: normalizedPhone.isEmpty
                                ? Theme.of(context).textTheme.bodyMedium?.color
                                      ?.withValues(alpha: 0.6)
                                : Colors.white,
                            onPressed: () async {
                              if (normalizedPhone.isEmpty) {
                                customSnackBar(
                                  'غير متاح',
                                  showDefaultSnackBar: false,
                                );
                                return;
                              }

                              final String phone = normalizedPhone.replaceAll(
                                RegExp(r'\s+'),
                                '',
                              );
                              final Uri uri = Uri(scheme: 'tel', path: phone);

                              try {
                                final bool launched = await launchUrl(uri);
                                if (!launched) {
                                  customSnackBar(
                                    'تعذر فتح الاتصال',
                                    showDefaultSnackBar: false,
                                  );
                                }
                              } catch (_) {
                                customSnackBar(
                                  'تعذر فتح الاتصال',
                                  showDefaultSnackBar: false,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Text(
                      'يمكنك الاتصال من خلال تطبيق الهاتف باستخدام الرقم أعلاه.',
                      style: robotoRegular.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
