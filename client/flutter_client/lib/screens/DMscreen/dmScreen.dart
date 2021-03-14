import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

class DmScreen extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  const DmScreen({Key key, this.innerDrawerKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: MainAppBar(
              innerDrawerKey: innerDrawerKey,
              title: 'DMs',
            )),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //12,12,16
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
                child: RoundedTextField(
                  hintText: 'search',
                  suffixIcon: Icon(
                    Icons.search_outlined,
                    color: kPrimaryColor0,
                  ),
                ),
              ),
              Provider.of<UiNotifier>(context, listen: true).dmTiles.length == 0
                  ? Column(children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.4,
                      ),
                      Text('Add friends to start chats with them'),
                    ])
                  : Column(
                      children: Provider.of<UiNotifier>(context, listen: true)
                          .dmTiles,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
