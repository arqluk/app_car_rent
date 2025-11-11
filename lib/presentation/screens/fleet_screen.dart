import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/fleet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FleetScreen extends ConsumerStatefulWidget {
  FleetScreen({super.key});

  Widget build(BuildContext context) {
    return _FleetScreenView();
  }

  @override
  ConsumerState<FleetScreen> createState() {
    return _FleetScreenState();
  }
}

class _FleetScreenState extends ConsumerState<FleetScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(fleetNotifierProvider.notifier).getAllCars();
  }

  @override
  Widget build(BuildContext context) {
    return _FleetScreenView();
  }
}

class _FleetScreenView extends ConsumerWidget {
  _FleetScreenView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final fleetList = ref.watch(fleetNotifierProvider);

    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(title: ' Nuestra Flota'),

      // Cuerpo con texto arriba + lista centrada
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Elegí tu auto en nuestra flota',
                    textAlign: TextAlign.center,
                    style: textStyle.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Encontrá autos al mejor precio.',
                    textAlign: TextAlign.center,
                    style: textStyle.bodyLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Hacé clic en un modelo para ver detalles',
                    textAlign: TextAlign.center,
                    style: textStyle.bodyLarge?.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            if (fleetList.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              // ✅ Lista expandible dentro de la columna
              Expanded(
                child: _FleetListView(
                  textStyle: textStyle,
                  fleetList: ref.read(fleetNotifierProvider),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FleetListView extends StatelessWidget {
  // final carRepository = CarRepository();
  final List<Car> fleetList;

  _FleetListView({super.key, required this.textStyle, required this.fleetList});

  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fleetList.length,
      itemBuilder: (context, index) {
        return _FleetItemView(car: fleetList[index]);
      },
    );
  }
}

class _FleetItemView extends StatelessWidget {
  final Car car;
  _FleetItemView({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(car.grupo),
        subtitle: Text('${car.marca} ${car.modelo}'),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: car.imageUrl.isEmpty
              ? const Icon(Icons.movie, size: 50)
              : Image.network(car.imageUrl),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          context.push('/car_detail_screen', extra: car);
        },
      ),
    );
  }
}
