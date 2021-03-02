import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

class DmScreen extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const DmScreen({Key key, this.innerDrawerKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor0,
        title: Text('DMs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            innerDrawerKey.currentState
                .close(direction: InnerDrawerDirection.end);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
        heroTag: 'hero0',
      ),
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
                ? Center(
                    child: Text('Add friends to start chats with them'),
                  )
                : Column(
                    children:
                        Provider.of<UiNotifier>(context, listen: true).dmTiles,
                  )
          ],
        ),
      ),
    );
  }
}
