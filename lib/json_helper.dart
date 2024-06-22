import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wizard_test/models/contact_model.dart';

class JsonHelper {
  Future<List<ContactModel>> readJson() async {
    List<ContactModel> contactList = [];
    final String response = await rootBundle.loadString('assets/data.json');
    List<dynamic> data = await json.decode(response);

    for (var e in data) {
      contactList.add(ContactModel.fromJson(e));
    }

    return contactList;
  }
}
