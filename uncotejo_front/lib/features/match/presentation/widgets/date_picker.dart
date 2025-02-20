import 'package:flutter/material.dart';
import '../../../../shared/widgets/toggler.dart';
import '../../../../shared/widgets/input_field.dart';
import 'day_circle.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime?, DateTime?, List<String>) onDateSelected;

  const DatePickerWidget({super.key, required this.onDateSelected});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _selectedDays = [];
  final TextEditingController _dateController = TextEditingController();

  bool _isRangeMode = false;

  Future<void> _pickDateRange() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedRange != null) {
      setState(() {
        _startDate = pickedRange.start;
        _endDate = pickedRange.end;
        _dateController.text =
            "${_startDate!.toLocal().toString().split(' ')[0]} - ${_endDate!.toLocal().toString().split(' ')[0]}";
      });
      widget.onDateSelected(_startDate, _endDate, _selectedDays);
    }
  }

  void _toggleSelectionMode(bool value) {
    setState(() {
      _isRangeMode = value;
      _startDate = null;
      _endDate = null;
      _selectedDays.clear();
      _dateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToggleSwitch(
          value: _isRangeMode,
          onChanged: _toggleSelectionMode,
          leftLabel: "Rango",
          rightLabel: "Días",
        ),
        const SizedBox(height: 10),
        CustomInputField(
          label: "Fecha del partido",
          controller: _dateController,
          icon: Icons.calendar_today,
          readOnly: _isRangeMode,
          onTap: !_isRangeMode ? () => _pickDateRange() : () {},
        ),
        const SizedBox(height: 10),
        if (_isRangeMode)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var day in ["D", "L", "M", "X", "J", "V", "S"])
                    DayCircle(
                      dayInitial: day,
                      isSelected: _selectedDays.contains(day),
                      onTap: () => _toggleDaySelection(day),
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  void _toggleDaySelection(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });

    _dateController.text =
        _selectedDays.map((d) => DayCircle.dayNames[d] ?? d).join(', ');

    widget.onDateSelected(_startDate, _endDate, _selectedDays);
  }
}
