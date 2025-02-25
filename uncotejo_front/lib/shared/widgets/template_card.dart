import 'package:flutter/material.dart';

class TemplateCard extends StatelessWidget {
  final String title;
  final String? imageUrl; // Nueva propiedad para la imagen del escudo
  final List<Map<String, dynamic>> attributes;
  final List<Widget> buttons;

  const TemplateCard({
    Key? key,
    required this.title,
    this.imageUrl, // Parámetro opcional para la imagen
    required this.attributes,
    required this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.grey[300],
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, // Centrar todo el contenido
            children: [
              // Imagen del escudo centrada
              ClipOval(
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[400], // Color de fondo
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.image, size: 30, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 10),

              // Título centrado
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Atributos con ícono opcional (Centrados)
              ...attributes.map((attr) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (attr['icon'] != null) ...[
                        Icon(attr['icon'], size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        attr['text'],
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 10),

              // Botones en columna centrada
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buttons.map((button) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: button,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
