import 'package:flutter/material.dart';
import '../../../../shared/widgets/home_screen.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../team/services/team_repository.dart';

class TeamCard extends StatelessWidget {
  final String teamName;
  final String shieldForm;
  final String teamLink;
  final VoidCallback onJoined;

  const TeamCard({
    super.key,
    required this.teamName,
    required this.shieldForm,
    required this.teamLink,
    required this.onJoined,
  });

  Future<void> _joinTeam(BuildContext context) async {
    try {
      await TeamRepository.joinTeam(teamLink);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te has unido al equipo con éxito!')),
      );

      // Navega a HomeScreen después de unirse
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

      onJoined(); // Callback para actualizar la UI
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al unirse al equipo: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.grey[300],
        elevation: 4,
        child: Container(
          width: double.infinity, 
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/shields/$shieldForm',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                teamName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Unirse al equipo',
                  leftIcon: Icons.group_add,
                  onPressed: () => _joinTeam(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
