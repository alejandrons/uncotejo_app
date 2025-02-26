import 'package:flutter/material.dart';
import '../../aplication/match_provider.dart';
import '../../domain/possible_dates.dart';
import 'package:provider/provider.dart';
import 'date_picker.dart';
import 'time_picker.dart';
import '../../../../shared/widgets/primary_button.dart';

class MatchForm extends StatefulWidget {
  const MatchForm({super.key});

  @override
  _MatchFormState createState() => _MatchFormState();
}

class _MatchFormState extends State<MatchForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;
  List<String> selectedDays = [];
  TimeOfDay? selectedTime;

  // Variables para mensajes de error
  String? dateError;
  String? timeError;

  // Claves para forzar la reconstrucción de los widgets
  Key _datePickerKey = UniqueKey();
  Key _timePickerKey = UniqueKey();

  void _handleDateSelection(DateTime? start, DateTime? end, List<String> days) {
    setState(() {
      startDate = start;
      endDate = end;
      selectedDays = days;
      dateError = null;
    });
  }

  void _handleTimeSelection(TimeOfDay? time) {
    setState(() {
      selectedTime = time;
      timeError = null;
    });
  }

  void _resetForm() {
    setState(() {
      startDate = null;
      endDate = null;
      selectedDays.clear();
      selectedTime = null;
      dateError = null;
      timeError = null;

      _datePickerKey = UniqueKey();
      _timePickerKey = UniqueKey();
    });

    _formKey.currentState?.reset();
  }

  Future<void> _submitForm() async {
    setState(() {
      dateError = (startDate == null && selectedDays.isEmpty)
          ? "Seleccione una fecha válida"
          : null;
      timeError = (selectedTime == null) ? "Seleccione una hora válida" : null;
    });

    if (dateError != null || timeError != null) {
      return;
    }

    PossibleDates possibleDates = selectedDays.isNotEmpty
        ? PossibleDates.days(selectedDays)
        : PossibleDates.range(startDate!, endDate!);

    final matchProvider = Provider.of<MatchProvider>(context, listen: false);

    await matchProvider.createMatch(context, possibleDates, selectedTime!);

    if (matchProvider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Partido creado exitosamente")),
      );
      _resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DatePickerWidget(
            key: _datePickerKey,
            onDateSelected: _handleDateSelection,
          ),
          if (dateError != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text(dateError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(height: 10),
          TimePickerWidget(
            key: _timePickerKey,
            onTimeSelected: _handleTimeSelection,
          ),
          if (timeError != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text(timeError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                PrimaryButton(
                  label: "Finalizar",
                  color: Colors.red,
                  rightIcon: Icons.check,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
