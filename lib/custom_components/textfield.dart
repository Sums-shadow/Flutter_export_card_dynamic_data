import 'package:flutter/material.dart';


String phonenumber = ''; // this to take
String initialCountry = 'CD';
TextEditingController phonecontroller = TextEditingController();
Widget customtextfield(
    String hintText,
    TextEditingController textEditingController,
    IconData iconData,
    TextInputType textInputType,
    bool readonly) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.1)),
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(5.0)),
        child: TextField(
          readOnly: readonly,
          keyboardType: textInputType,
          onChanged: (va) {
            // print(textEditingController.text);
          },
          controller: textEditingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            prefixIcon: Container(
                // padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                // margin: EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    // color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Icon(
                  iconData,
                  color: Colors.blue,
                )),
            hintText: hintText,
            suffixText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
    ),
  );
}
