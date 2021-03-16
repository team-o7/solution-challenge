import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/screens/leftDrawer/leftDrawer.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

import 'DMscreen/dmScreen.dart';
import 'home/home.dart';

class DrawerHolder extends StatefulWidget {
  @override
  _DrawerHolderState createState() => _DrawerHolderState();
}

class _DrawerHolderState extends State<DrawerHolder> {
  GlobalKey<InnerDrawerState> _innerDrawerKey;

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print(0);
        FirebaseFunctions _functions =
            FirebaseFunctions.instanceFor(region: 'us-central1');
        //todo: circularprogressindicator
        String id = deepLink.queryParameters['id'];
        if (id != null) {
          print(1);
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          DocumentSnapshot s =
              await firestore.collection('topics').doc(id).get();
          Map<String, dynamic> data = s.data();
          bool isPrivate = data['private'];
          Map<String, dynamic> params = {'id': id};
          isPrivate
              ? _functions
                  .httpsCallable('onPrivateTopicJoinRequest')
                  .call(params)
                  .then((value) {
                  print(2);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value.data)));
                })
              : _functions
                  .httpsCallable('onPublicTopicJoinRequest')
                  .call(params)
                  .then((value) {
                  print(2);
                  Provider.of<UiNotifier>(context, listen: true)
                      .setLeftNavIndex(data);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value.data)));
                });
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('a');
      FirebaseFunctions _functions =
          FirebaseFunctions.instanceFor(region: 'us-central1');
      //todo: circularprogressindicator
      String id = deepLink.queryParameters['id'];
      if (id != null) {
        print('b');
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentSnapshot s = await firestore.collection('topics').doc(id).get();
        Map<String, dynamic> data = s.data();
        bool isPrivate = data['private'];
        Map<String, dynamic> params = {'id': id};
        isPrivate
            ? _functions
                .httpsCallable('onPrivateTopicJoinRequest')
                .call(params)
                .then((value) {
                print('c');
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(value.data)));
              })
            : _functions
                .httpsCallable('onPublicTopicJoinRequest')
                .call(params)
                .then((value) {
                print('c');
                Provider.of<UiNotifier>(context, listen: true)
                    .setLeftNavIndex(data);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(value.data)));
              });
      }
    }
  }

  @override
  void initState() {
    initDynamicLinks();
    _innerDrawerKey = new GlobalKey<InnerDrawerState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: InnerDrawer(
        scaffold: Home(
          innerDrawerKey: _innerDrawerKey,
        ),
        leftChild: LeftDrawer(),
        rightChild: DmScreen(innerDrawerKey: _innerDrawerKey),
        key: _innerDrawerKey,
        offset: IDOffset.only(left: 0.7, right: 1.0),
        swipeChild: true,
        onTapClose: true,
      ),
    );
  }
}
