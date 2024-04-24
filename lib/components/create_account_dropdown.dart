import 'package:flutter/material.dart';

// Widget createAccountDropdownExample() {
//   TextEditingController _dropdownController = TextEditingController();
//   List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

//   return CreateAccountDropdown(
//     labelText: 'Select a program',
//     hintText: 'Choose from the list', // Hint text for the dropdown
//     controller: _dropdownController,
//     dropdownItems: dropdownItems,
//   );
// }

class CreateAccountDropdown extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final List<String> dropdownItems;
  final void Function(String?) onChanged;

  CreateAccountDropdown({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.dropdownItems,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CreateAccountDropdown> createState() => _CreateAccountDropdownState();
}

class _CreateAccountDropdownState extends State<CreateAccountDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue =
        widget.controller.text.isEmpty ? null : widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: mobilescreenHeight * 0.015),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Label Text
            Text(
              widget.labelText,
              style: TextStyle(fontSize: mobilescreenHeight * 0.021),
            ),
            // Dropdown Button
            DropdownButtonFormField<String>(
              style: TextStyle(
                  fontSize: mobilescreenHeight * 0.023, color: Colors.black),
              value: widget.controller.text.isEmpty
                  ? null
                  : widget.controller.text,
              onChanged: (newValue) {
                // Handle dropdown value change
                setState(() {
                  selectedValue = newValue;
                  if (newValue != null && newValue == widget.hintText) {
                    widget.controller.text =
                        ''; // Set to empty string if hint text is selected
                  } else {
                    widget.controller.text = newValue ?? '';
                  }
                });
                widget.onChanged(newValue);
              },
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    widget.hintText,
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: mobilescreenHeight * 0.019),
                  ), // Display hint text
                ),
                ...widget.dropdownItems.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(fontSize: mobilescreenHeight * 0.019),
                      ),
                    )),
              ],
              decoration: InputDecoration(
                isDense: true, // Reduces the vertical padding
                contentPadding: EdgeInsets.symmetric(
                    vertical: mobilescreenHeight * 0.015, horizontal: 0.0),
                fillColor: Colors.transparent,
                filled: true,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black38), // Black line when not focused
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Black line when focused
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
