import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/location/location_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationInfo?>(
      future: LocationService().getLocation(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final title = info != null ? 'Cerca de ti' : 'Ubicación';
        final subtitle =
            info != null ? info.label : 'Habilita la ubicación';

        return Row(
          children: [
            const Icon(Icons.my_location_outlined, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            const SizedBox(width: 4),
            const _Avatar(),
          ],
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      tooltip: 'Perfil',
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (action) async {
        if (action == _MenuAction.logout) {
          await FirebaseAuth.instance.signOut();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<_MenuAction>(
          value: _MenuAction.logout,
          child: Text('Logout'),
        ),
      ],
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

enum _MenuAction { logout }
