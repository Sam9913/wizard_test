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
  final TextEditingController _searchTec = TextEditingController();

  bool isLoading = false;
  bool isSearchMode = false;
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
        leading: InkWell(
          onTap: () {
            if(isSearchMode){
              _searchTec.clear();
              getContactList();
            }

            setState(() {
              isSearchMode = !isSearchMode;
            });
          },
          child: Icon(
            isSearchMode ? Icons.close : Icons.search,
            color: Colors.orange.shade600,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Contacts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child: InkWell(
              onTap: () async {
                final result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContactFormScreen(),
                ));

                setState(() {
                  contactList.add(result);
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.orange.shade600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black26)),
          ),
          child: Column(
            children: [
              Offstage(
                offstage: !isSearchMode,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                  ),
                  child: TextField(
                    controller: _searchTec,
                    cursorColor: Colors.orange.shade600,
                    onSubmitted: (value) {
                      List<ContactModel> resultList = [];

                      for (var element in contactList) {
                        if ((element.fullName ?? '').contains(_searchTec.text)) {
                          resultList.add(element);
                        }
                      }

                      setState(() {
                        contactList = resultList;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by name',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.orange.shade600,
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          getContactList();
                        },
                        child: contactList.isEmpty
                            ? const Center(child: Text('No related result'))
                            : GridView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: isSearchMode ? 16 : 24,
                                ),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                ),
                                itemCount: contactList.length,
                                itemBuilder: (context, index) {
                                  return _buildContactItem(
                                    contactList[index],
                                    (contact) {
                                      setState(() {
                                        contactList[index] = contact;
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(ContactModel contact, Function(ContactModel) onChange) => InkWell(
        onTap: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ContactFormScreen(
              selectedContact: contact,
            ),
          ));

          onChange(result);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange.shade600,
                radius: 30,
              ),
              Text(
                contact.fullName ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

  void getContactList() async {
    setState(() {
      isLoading = true;
    });
    final tempList = await jsonHelper.readJson();
    setState(() {
      contactList = tempList;
      isLoading = false;
    });
  }
}
