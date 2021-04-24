import 'package:in_app_purchase/in_app_purchase.dart';

enum CommonState { Loading, Success, Error }

class RemoveAdsState {
  CommonState isState;
  List<ProductDetails> products = List<ProductDetails>();
  bool isAvailablePurchase;

  RemoveAdsState(
      {this.isState = CommonState.Loading,
      this.products,
      this.isAvailablePurchase = false});

  RemoveAdsState copyWith(
      {isState, List<ProductDetails> products, isAvailablePurchase}) {
    return RemoveAdsState(
        isState: isState ?? this.isState,
        products: products ?? this.products,
        isAvailablePurchase: isAvailablePurchase ?? this.isAvailablePurchase);
  }
}

class RemoveAdsController {
  static Future<RemoveAdsState> init() async {
    RemoveAdsState removeAdsState;
    try {
      final bool available =
          await InAppPurchaseConnection.instance.isAvailable();
      if (!available) {
        removeAdsState = RemoveAdsState(
            products: [],
            isState: CommonState.Success,
            isAvailablePurchase: false);
      } else {
        const Set<String> _kIds = {'app_premium_month'};
        final ProductDetailsResponse response =
            await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
        List<ProductDetails> products = response.productDetails;
        removeAdsState = RemoveAdsState(
            products: products,
            isState: CommonState.Success,
            isAvailablePurchase: true);
      }
    } catch (ex) {
      print("/// ${ex.toString()}");
      removeAdsState = RemoveAdsState(
          products: [], isState: CommonState.Error, isAvailablePurchase: false);
    }
    return removeAdsState;
  }
}
//app_premium_month
//app_premium
