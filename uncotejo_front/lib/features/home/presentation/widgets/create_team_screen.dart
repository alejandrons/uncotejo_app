import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uncotejo_front/features/team/services/team_repository.dart';
import 'package:uncotejo_front/shared/utils/shield_list.dart'; // Import the shield list

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _sloganController = TextEditingController();

  String? _selectedShield; // Almacena la ruta de la imagen seleccionada

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sloganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Crea tu equipo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // First Box: Nuevo Equipo
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nuevo Equipo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de equipo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripcion',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _sloganController,
                      decoration: const InputDecoration(
                        labelText: 'Eslogan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacing between boxes
            // Second Box: Crear Escudo
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Crear Escudo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 150,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.5,
                        onPageChanged: (index, reason) {
                          // Actualizar el escudo seleccionado
                          setState(() {
                            _selectedShield = shieldList[index];
                          });
                        },
                      ),
                      items: shieldList.map((shield) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
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
            ),
            const SizedBox(height: 20), // Spacing between boxes and button
            // Finalize Button
            SizedBox(
              width: double.infinity, // Make the button full width
              child: ElevatedButton(
                onPressed: () {
                  _createTeam(); // Lógica para crear el equipo
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue, // Customize button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Finalizar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createTeam() async {
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

    // print(teamData);

    try {
      final response = await TeamRepository.createTeam(teamData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Partido creado exitosamente")),
      );
      _resetForm();
      return response;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al crear partido: $error")),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _sloganController.clear();
      _selectedShield = null;
    });
  }
}
