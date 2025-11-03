import 'package:app_car_rental/core/router/app_router.dart';
import 'package:app_car_rental/core/theme/app_theme.dart';
import 'package:app_car_rental/presentation/providers/theme_provider.dart';
import 'package:app_car_rental/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necesario antes de usar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // 👇 Test simple para confirmar la conexión
  print("✅ Firebase inicializado correctamente!");

  // runApp(const MainApp());
  runApp(
    ProviderScope(
    child: MainApp()
    )
  );

}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
     final appTheme = ref.watch(themeNotifierProvider); 
    
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      // theme: appTheme.getTheme(),
      // theme: ThemeData(
      //   colorSchemeSeed: Colors.red,
      // ),
      theme: appTheme.getTheme(),
      // home: const HomeScreen(),
    );

    
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: Scaffold(
  //       body: Center(
  //         child: Text('Welcome to Car Rent'),
  //       ),
  //     ),
  //   );
  // }
}






// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }
// }


