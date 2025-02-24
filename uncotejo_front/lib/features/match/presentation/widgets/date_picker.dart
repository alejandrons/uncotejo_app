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

  // Mapa invertido: iniciales -> nombres completos
  static const Map<String, String> dayMap = {
    "L": "Lunes",
    "M": "Martes",
    "X": "Miércoles",
    "J": "Jueves",
    "V": "Viernes",
    "S": "Sábado",
    "D": "Domingo",
  };

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

  void _toggleDaySelection(String dayInitial) {
    String fullDayName = dayMap[dayInitial]!;

    setState(() {
      if (_selectedDays.contains(fullDayName)) {
        _selectedDays.remove(fullDayName);
      } else {
        _selectedDays.add(fullDayName);
      }
    });

    _dateController.text = _selectedDays.join(', ');

    widget.onDateSelected(_startDate, _endDate, _selectedDays);
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
                  for (var dayInitial in dayMap.keys)
                    DayCircle(
                      dayInitial: dayInitial,
                      isSelected: _selectedDays.contains(dayMap[dayInitial]),
                      onTap: () => _toggleDaySelection(dayInitial),
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
