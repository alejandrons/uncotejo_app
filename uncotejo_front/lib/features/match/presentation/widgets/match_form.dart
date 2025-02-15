import 'package:flutter/material.dart';
import '../../aplication/provider/match_provider.dart';
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

  void _handleDateSelection(DateTime? start, DateTime? end, List<String> days) {
    setState(() {
      startDate = start;
      endDate = end;
      selectedDays = days;
    });
  }

  void _handleTimeSelection(TimeOfDay? time) {
    setState(() {
      selectedTime = time;
    });
  }

  Future<void> _submitForm() async {
    if (selectedTime == null || (startDate == null && selectedDays.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe seleccionar fecha y hora")),
      );
      return;
    }

    PossibleDates possibleDates;
    if (selectedDays.isNotEmpty) {
      possibleDates = PossibleDates.days(selectedDays);
    } else {
      possibleDates = PossibleDates.range(startDate!, endDate!);
    }

    final matchProvider = Provider.of<MatchProvider>(context, listen: false);

    try {
      await matchProvider.createMatch(possibleDates, selectedTime!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Partido creado exitosamente")),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al crear partido")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DatePickerWidget(onDateSelected: _handleDateSelection),
          const SizedBox(height: 10),
          TimePickerWidget(onTimeSelected: _handleTimeSelection),
          const SizedBox(height: 30),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  label: "Generar Link",
                  color: Colors.blue,
                  leftIcon: Icons.copy,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                PrimaryButton(
                  label: "Finalizar",
                  color: Colors.red,
                  rightIcon: Icons.check,
                  onPressed: _submitForm, // Llama a la función para enviar los datos
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
