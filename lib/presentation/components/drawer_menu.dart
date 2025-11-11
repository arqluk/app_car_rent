import 'package:app_car_rental/menu/menu_item.dart';
import 'package:app_car_rental/presentation/providers/auth_provider.dart';
import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DrawerMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawerMenu({super.key, required this.scaffoldKey});

  @override
  ConsumerState<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends ConsumerState<DrawerMenu> {
  int selectedIndex = -1;

  bool _needsAdmin(String route) {
    return route == '/admin_screen' || route == '/add_car_screen';
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Seguro deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );

    if (result == true) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/home_screen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncUserDoc = ref.watch(userDocProvider);

    return asyncUserDoc.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error cargando usuario")),
      data: (userDoc) {
        final user = ref.watch(authStateProvider).asData?.value;
        final bool isLogged = user != null;
        final colorScheme = Theme.of(context).colorScheme;
        final role = userDoc?['role'];

        return Drawer(
          child: Column(
            children: [
              _DrawerHeader(userDoc: userDoc),

              const Divider(),

              Expanded(
                child: ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];

                    final isLogout = item.title == 'Logout';
                    final requiresAdmin = _needsAdmin(item.link);
                    final isDisabled =
                        (isLogout && !isLogged) || // logout sin login
                        (requiresAdmin &&
                            role != 'admin'); // administrador sin rol

                    return ListTile(
                      leading: Icon(
                        item.icon,
                        color: isDisabled ? colorScheme.outlineVariant : null,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: isDisabled ? colorScheme.outlineVariant : null,
                        ),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: TextStyle(
                          color: isDisabled
                              ? colorScheme.outlineVariant
                              : colorScheme.secondary,
                        ),
                      ),
                      enabled: !isDisabled,
                      selected: selectedIndex == index,
                      onTap: isDisabled
                          ? null
                          : () async {
                              Navigator.pop(context);

                              if (isLogout) {
                                await _confirmLogout(context);
                                return;
                              }

                              setState(() => selectedIndex = index);

                              if (requiresAdmin) {
                                if (role == 'admin') {
                                  context.push(item.link);
                                } else {
                                  context.push('/access_denied_screen');
                                }
                                return;
                              }
                              context.push(item.link);
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// HEADER con subtítulo + clic para Perfil/Login
class _DrawerHeader extends ConsumerWidget {
  final Map<String, dynamic>? userDoc;

  const _DrawerHeader({required this.userDoc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authStateProvider).asData?.value;
    final bool isLogged = user != null;

    return InkWell(
      onTap: () {
        isLogged
            ? context.push('/profile_screen')
            : context.push('/login_screen');
      },
      child: Container(
        color: colorScheme.primaryContainer,
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.primary,
              child: Icon(Icons.person, size: 32, color: colorScheme.onPrimary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLogged
                        ? (userDoc?['email'] ?? user.email ?? 'Usuario')
                        : 'Invitado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLogged
                        ? (userDoc?['role'] ?? 'user')
                        : 'Iniciá sesión para más opciones',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onPrimaryContainer.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
