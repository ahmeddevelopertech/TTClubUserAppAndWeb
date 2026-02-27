import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  final String? route;

  const SplashScreen({super.key, required this.body, this.route});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (!firstTime) {
        bool isNotConnected =
            result.first != ConnectivityResult.wifi &&
            result.first != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            backgroundColor: isNotConnected ? Colors.red : Colors.green,
            duration: Duration(seconds: isNotConnected ? 6000 : 3),
            content: Text(
              isNotConnected ? 'no_connection'.tr : 'connected'.tr,
              textAlign: TextAlign.center,
            ),
          ),
        );
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    if (Get.find<SplashController>().getGuestId().isEmpty) {
      var uuid = const Uuid().v1();
      Get.find<SplashController>().setGuestId(uuid);
    }

    Get.find<SplashController>().initSharedData();
    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged?.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((_) async {
      if (Get.find<LocationController>().getUserAddress() != null) {
        AddressModel addressModel = Get.find<LocationController>()
            .getUserAddress()!;
        ZoneResponseModel responseModel = await Get.find<LocationController>()
            .getZone(
              addressModel.latitude.toString(),
              addressModel.longitude.toString(),
              false,
            );
        addressModel.availableServiceCountInZone =
            responseModel.totalServiceCount;
        Get.find<LocationController>().saveUserAddress(addressModel);
      }

      Timer(const Duration(seconds: 1), () {
        Get.offNamed(RouteHelper.getTtClubLandingRoute());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(
        builder: (splashController) {
          PriceConverter.getCurrency();
          return Center(
            child: splashController.hasConnection
                ? SplashLogoWidget()
                : NoInternetScreen(child: SplashScreen(body: widget.body)),
          );
        },
      ),
    );
  }
}

class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Images.logo, width: Dimensions.logoSize),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
      ),
    );
  }
}
