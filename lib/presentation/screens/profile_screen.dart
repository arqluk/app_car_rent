import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserDoc = ref.watch(userDocProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return asyncUserDoc.when(
      data: (userDoc) {
        final user = FirebaseAuth.instance.currentUser;

        return Scaffold(
          appBar: const CustomAppBar(title: ' Mi perfil'),

          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: colorScheme.primary,
                    child: Icon(
                      Icons.person,
                      size: 45,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userDoc?['userName'] ?? 'Sin nombre',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    userDoc?['email'] ?? user?.email ?? 'Sin email',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text("Rol: ${userDoc?['role'] ?? 'user'}"),
                  const SizedBox(height: 80),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.logout, size: 25),
                      label: Text(
                        'Cerrar sesión',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                        await FirebaseAuth.instance.signOut();
                        ref.invalidate(userDocProvider);
                        if (context.mounted) context.go('/home_screen');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text("Error cargando perfil"))),
    );
  }
}
