import 'package:flutter/material.dart';
import 'package:wizard_test/json_helper.dart';
import 'package:wizard_test/ui/contact_form_screen.dart';

import '../models/contact_model.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final JsonHelper jsonHelper = JsonHelper();
  List<ContactModel> contactList = [];

  @override
  void initState() {
    super.initState();

    getContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: Icon(
          Icons.search,
          color: Colors.orange,
        ),
        title: Text(
          'Contacts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 16,
            ),
            child: Icon(
              Icons.add,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black26)),
          ),
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: contactList.length,
            itemBuilder: (context, index) {
              return _buildContactItem(contactList[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(ContactModel contact) => Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange,
          radius: 30,
        ),
        Text(
          contact.fullName ?? '',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  void getContactList() async {
    final tempList = await jsonHelper.readJson();
    setState(() {
      contactList = tempList;
    });
  }
}
