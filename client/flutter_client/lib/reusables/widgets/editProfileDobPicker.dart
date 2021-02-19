import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../sizeConfig.dart';

class EdDobPicker extends StatefulWidget {
  final Function dob;

  const EdDobPicker({Key key, this.dob}) : super(key: key);

  @override
  _EdDobPickerState createState() => _EdDobPickerState();
}

class _EdDobPickerState extends State<EdDobPicker> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff350D36),
              surface: Color(0xff350D36),
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        Provider.of<UiNotifier>(context, listen: false).setDob(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 15 / 360),
      padding: EdgeInsets.only(
        left: SizeConfig.screenWidth * 15 / 360,
        top: SizeConfig.screenHeight * 2 / 640,
        bottom: SizeConfig.screenHeight * 2 / 640,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kPrimaryColor1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(
                fontSize: SizeConfig.screenWidth * 16 / 360,
                fontWeight: FontWeight.w500,
                color: kPrimaryColor1,
                letterSpacing: 1.5,
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () => _selectDate(context),
            elevation: 2.0,
            fillColor: kPrimaryColor1,
            child: Icon(Icons.calendar_today_outlined,
                color: Colors.white, size: SizeConfig.screenWidth * 16 / 360),
            padding: EdgeInsets.all(SizeConfig.screenWidth * 15 / 360),
            shape: CircleBorder(),
          )
        ],
      ),
    );
  }
}
