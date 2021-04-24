import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'remove_ads_controller.dart';

class RemoveAds extends StatefulWidget {
  @override
  _RemoveAdsState createState() => _RemoveAdsState();
}

class _RemoveAdsState extends State<RemoveAds> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Remove Ads"),
      ),
      body: FutureBuilder<RemoveAdsState>(
        future: RemoveAdsController.init(),
        builder: (context, snap) {
          if (snap.hasData) {
            var state = snap.data;
            if (state.isState == CommonState.Success) {
              if (state.products.isEmpty) {
                return Center(
                  child: Text(
                    'Unable to make payment!',
                  ),
                );
              }
              var product = state.products.first;
              return Center(
                child: Container(
                  height: 200,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0),
                          ),
                          Text(
                            product.description,
                            style: TextStyle(color: Colors.teal),
                          ),
                          SizedBox(height: 10.0),
                          Center(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () async {
                                final PurchaseParam purchaseParam =
                                    PurchaseParam(productDetails: product);
                                await InAppPurchaseConnection.instance
                                    .buyNonConsumable(
                                  purchaseParam: purchaseParam,
                                );
                              },
                              minWidth: 200,
                              color: Colors.teal,
                              child: Text(
                                product.price,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (state.isState == CommonState.Error) {
              return Center(
                child: Text(
                  'Please try again later!',
                ),
              );
            }
            return Text("data");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
