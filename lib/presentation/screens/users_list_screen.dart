import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersListScreen extends ConsumerWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserDoc = ref.watch(userDocProvider);

    return asyncUserDoc.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const AccessDeniedScreen(),
      data: (userDoc) {
        if (userDoc?['role'] != 'admin') {
          return const AccessDeniedScreen();
        }
        return const _UsersListView();
      },
    );
  }
}

class _UsersListView extends StatelessWidget {
  const _UsersListView({super.key});

  Widget _styledBox(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: ' Lista de usuarios'),
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (_, index) {
              final data = users[index].data() as Map<String, dynamic>;
              final uid = users[index].id;

              // Eliminamos password si existiera
              data.remove('password');

              return _styledBox(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👤 Usuario',
                      style: textStyle.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _infoRow('UID', uid),

                    ...data.entries.map((entry) {
                      final key = entry.key;
                      final value = entry.value.toString();

                      return _infoRow(
                        key[0].toUpperCase() + key.substring(1),
                        value,
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// -------------------------------------------------------------------

// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
// import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class UsersListScreen extends ConsumerWidget {
//   const UsersListScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final asyncUserDoc = ref.watch(userDocProvider);

//     return asyncUserDoc.when(
//       loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
//       error: (_, __) => const AccessDeniedScreen(),
//       data: (userDoc) {
//         if (userDoc?['role'] != 'admin') {
//           return const AccessDeniedScreen();
//         }
//         return const _UsersListView();
//       },
//     );
//   }
// }

// class _UsersListView extends StatelessWidget {
//   const _UsersListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Car Rent'),

//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (_, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text('No hay usuarios registrados'),
//             );
//           }

//           final users = snapshot.data!.docs;

//           return ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: users.length,
//             separatorBuilder: (_, __) => const Divider(),
//             itemBuilder: (_, index) {
//               final data = users[index].data() as Map<String, dynamic>;
//               final userEmail = data['userEmail'] ?? 'Sin email';
//               final role = data['role'] ?? 'user';
//               final uid = users[index].id;

//               return ListTile(
//                 leading: const CircleAvatar(child: Icon(Icons.person)),
//                 title: Text(userEmail),
//                 subtitle: Text("Rol: $role\nUID: $uid"),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
