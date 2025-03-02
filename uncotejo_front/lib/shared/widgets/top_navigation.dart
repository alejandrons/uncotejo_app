import 'package:flutter/material.dart';
import 'package:uncotejo_front/features/Oauth/services/auth_services.dart';
import 'package:uncotejo_front/features/login/presentation/login_screen.dart';

import '../utils/token_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.leadingIcon,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      centerTitle: true,
      leading: leadingIcon != null
          ? IconButton(
              icon: Icon(leadingIcon),
              onPressed: onLeadingPressed ?? () {},
            )
          : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notificaciones')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () async {
            await TokenService.removeToken();
            
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
