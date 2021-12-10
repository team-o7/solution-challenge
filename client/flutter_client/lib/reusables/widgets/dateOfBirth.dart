import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../sizeConfig.dart';

class DobPicker extends StatefulWidget {
  final Function dob;

  const DobPicker({Key key, this.dob}) : super(key: key);

  @override
  _DobPickerState createState() => _DobPickerState();
}

class _DobPickerState extends State<DobPicker> {
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
                primary: kPrimaryColor0,
                background: Colors.black,
                surface: Colors.black),
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
        border: Border.all(color: kPrimaryColor1),
        borderRadius: BorderRadius.circular(SizeConfig.screenWidth * 5 / 360),
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
