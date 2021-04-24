import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

bool isRemoveAds = false;

class RemoveAdsConfig {
  static checkPurchased(BuildContext context) async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (available) {
      final QueryPurchaseDetailsResponse response =
          await InAppPurchaseConnection.instance.queryPastPurchases();
      if (response.error != null) {
        print("Error");
      } else {
        for (PurchaseDetails purchase in response.pastPurchases) {
          if (purchase.productID == 'app_premium' &&
              purchase.status == PurchaseStatus.purchased) {
            InAppPurchaseConnection.instance.completePurchase(purchase);
            isRemoveAds = true;
            return;
          }
        }
      }
    }
  }
}
//app_premium
