import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uncotejo_front/features/team/services/team_repository.dart';
import 'package:uncotejo_front/shared/utils/shield_list.dart';
import 'package:uncotejo_front/shared/utils/token_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../../../../shared/widgets/home_screen.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sloganController = TextEditingController();
  String? _selectedShield;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sloganController.dispose();
    super.dispose();
  }

  Future<void> _createTeam() async {
    try {
      final String? token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      final String userRole = decodedToken["role"];

      if (userRole == 'team_leader') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No puedes crear un equipo porque ya eres líder de otro equipo.')),
        );
        return;
      }

      if (_nameController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _sloganController.text.isEmpty ||
          _selectedShield == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, completa todos los campos.')),
        );
        return;
      }

      String? _shield = shieldFormMap[_selectedShield];

      final teamData = {
        "name": _nameController.text.trim(),
        "description": _descriptionController.text.trim(),
        "slogan": _sloganController.text.trim(),
        "shieldForm": _shield ?? "default.png",
        "teamType": "futsal"
      };

      await TeamRepository.createTeam(teamData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Equipo creado exitosamente")),
      );

      // Redirigir a HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al crear equipo: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Crea tu equipo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Permite deslizar en caso de sobreflujo
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTeamInfoCard(),
              const SizedBox(height: 20),
              _buildShieldSelectionCard(),
              const SizedBox(height: 20),
              _buildCreateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nuevo Equipo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTextField(_nameController, 'Nombre de equipo'),
            const SizedBox(height: 16),
            _buildTextField(_descriptionController, 'Descripción'),
            const SizedBox(height: 16),
            _buildTextField(_sloganController, 'Eslogan'),
          ],
        ),
      ),
    );
  }

  Widget _buildShieldSelectionCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona un Escudo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CarouselSlider(
              options: CarouselOptions(
                height: 180, // Altura fija para evitar sobreflujo
                autoPlay: false, // No auto-play para mejor UX
                enlargeCenterPage: true,
                viewportFraction: 0.5,
                onPageChanged: (index, reason) {
                  setState(() {
                    _selectedShield = shieldList[index];
                  });
                },
              ),
              items: shieldList.map((shield) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: 150, // Tamaño fijo del escudo
                      height: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(shield),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _createTeam,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Finalizar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}