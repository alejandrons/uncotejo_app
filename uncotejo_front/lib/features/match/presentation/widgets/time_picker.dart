import 'package:flutter/material.dart';
import '../../../../shared/widgets/input_field.dart';

class TimePickerWidget extends StatefulWidget {
  final Function(TimeOfDay?) onTimeSelected;

  const TimePickerWidget({super.key, required this.onTimeSelected});

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay? _selectedTime;
  final TextEditingController _timeController = TextEditingController();

  /// Seleccionar una hora
  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
      widget.onTimeSelected(_selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      label: "Hora del partido",
      controller: _timeController,
      icon: Icons.access_time,
      onTap: _pickTime,
    );
  }
}
