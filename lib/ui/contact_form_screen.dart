import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wizard_test/models/contact_model.dart';

class ContactFormScreen extends StatefulWidget {
  final ContactModel? selectedContact;
  const ContactFormScreen({
    super.key,
    this.selectedContact,
  });

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final TextEditingController _firstNameTec = TextEditingController();
  final TextEditingController _lastNameTec = TextEditingController();
  final TextEditingController _emailTec = TextEditingController();

  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();

  DateTime? birthdate;

  @override
  void initState() {
    super.initState();

    if (widget.selectedContact != null) {
      _firstNameTec.text = widget.selectedContact?.firstName ?? '';
      _lastNameTec.text = widget.selectedContact?.lastName ?? '';
      _emailTec.text = widget.selectedContact?.email ?? '';
      birthdate = widget.selectedContact?.birthDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leadingWidth: 75,
        leading: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 8,
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.orange.shade600,
                fontSize: 16,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child: InkWell(
              onTap: () {
                if (_firstNameTec.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("First Name cannot be empty"),
                  ));
                } else if (_lastNameTec.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Last Name cannot be empty"),
                  ));
                } else{
                  Navigator.of(context).pop(ContactModel(
                    firstName: _firstNameTec.text,
                    lastName: _lastNameTec.text,
                    email: _emailTec.text,
                    dob: DateFormat('d/M/yyyy').format(birthdate!),
                  ));
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.orange.shade600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black26),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade600,
                    radius: 50,
                  ),
                ),
                _buildSectionTitle('Main Information'),
                _buildTextField(
                  labelText: 'First Name',
                  textEditingController: _firstNameTec,
                  focusNode: _firstNameNode,
                ),
                _buildTextField(
                  labelText: 'Last Name',
                  textEditingController: _lastNameTec,
                  focusNode: _lastNameNode,
                  isLast: true,
                ),
                _buildSectionTitle('Sub Information'),
                _buildTextField(
                  labelText: 'Email',
                  textEditingController: _emailTec,
                  textInputType: TextInputType.emailAddress,
                  focusNode: _emailNode,
                ),
                _buildTextField(
                  labelText: 'DOB',
                  textEditingController: _lastNameTec,
                  isDob: true,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String titleText) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: const Border(
            bottom: BorderSide(color: Colors.black26),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 18,
        ),
        child: Text(
          titleText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );

  Widget _buildTextField({
    required String labelText,
    TextEditingController? textEditingController,
    FocusNode? focusNode,
    TextInputType? textInputType,
    bool isDob = false,
    bool isLast = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: isLast ? 4 : 8,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    labelText,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: isDob
                      ? InkWell(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: birthdate ?? DateTime.now(),
                              lastDate: DateTime.now(),
                              firstDate: DateTime.parse('1900-01-01'),
                            );

                            setState(() {
                              birthdate = selectedDate;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  birthdate == null
                                      ? 'Click to choose date'
                                      : DateFormat('dd MMMM yyyy').format(birthdate!),
                                  style: TextStyle(
                                    color: birthdate == null ? Colors.grey : Colors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.edit_calendar,
                                  color: Colors.grey.shade700,
                                )
                              ],
                            ),
                          ),
                        )
                      : TextField(
                          textInputAction: TextInputAction.next,
                          controller: textEditingController,
                          focusNode: focusNode,
                          cursorColor: Colors.orange.shade600,
                          keyboardType: textInputType,
                          decoration: InputDecoration(
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
                )
              ],
            ),
            const Divider(),
          ],
        ),
      );
}
