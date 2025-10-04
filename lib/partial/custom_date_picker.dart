import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoea1/constants/theme.dart';

class CustomDateTimePickerField extends StatefulWidget {
  final DateTime? initialDateTime;
  final String hint;
  final Function(DateTime) onDateTimeSelected;

  const CustomDateTimePickerField({
    Key? key,
    required this.hint,
    required this.onDateTimeSelected,
    this.initialDateTime,
  }) : super(key: key);

  @override
  _CustomDateTimePickerFieldState createState() =>
      _CustomDateTimePickerFieldState();
}

class _CustomDateTimePickerFieldState extends State<CustomDateTimePickerField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDateTime ?? DateTime.now();
    // _controller.text = _formatDateTime(selectedDate!);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(pickedDate),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _controller.text = _formatDateTime(selectedDate!);
          widget.onDateTimeSelected(selectedDate!);
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: _controller,
        readOnly: true, // This makes the field non-editable
        decoration: InputDecoration(filled: true,
          fillColor: scaffoldColor,
          hintText: "Select date and time",
          // labelText: 'Select Date and Time',
          prefixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        onTap: () => _selectDateTime(context),
      ),
    );
  }
}
