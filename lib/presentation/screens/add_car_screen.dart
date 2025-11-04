import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/user.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/cars_provider.dart';
import 'package:app_car_rental/presentation/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddCarScreen extends ConsumerStatefulWidget {
  const AddCarScreen({super.key});

  @override
  ConsumerState<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends ConsumerState<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _groupCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  // final _phoneCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  final _luggageCtrl = TextEditingController();
  final _automaticCtrl = TextEditingController();
  final _airCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Registro de Usuario')),
      appBar: const CustomAppBar(title: 'Car Rent'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idCtrl,
                decoration: const InputDecoration(labelText: 'ID'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el ID' : null,
              ),
              TextFormField(
                controller: _groupCtrl,
                decoration: const InputDecoration(labelText: 'Grupo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el grupo' : null,
              ),
              TextFormField(
                controller: _brandCtrl,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) =>
                     v == null || v.isEmpty ? 'Ingrese la marca' : null,
              ),
              TextFormField(
                controller: _modelCtrl,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (v) =>
                     v == null || v.isEmpty ? 'Ingrese el modelo' : null,
              ),
              TextFormField(
                controller: _colorCtrl,
                decoration: const InputDecoration(labelText: 'Color'),
                validator: (v) =>
                     v == null || v.isEmpty ? 'Ingrese el color' : null,
              ),
              TextFormField(
                controller: _capacityCtrl,
                decoration: const InputDecoration(labelText: 'Capacidad'),
                validator: (v) =>
                     v == null || v.isEmpty ? 'Ingrese la cantidad de personas' : null,
              ),
              TextFormField(
                controller: _luggageCtrl,
                decoration: const InputDecoration(labelText: 'Equipaje'),
                validator: (v) =>
                     v == null || v.isEmpty ? 'Ingrese la cantidad de equipaje' : null,
              ),
              TextFormField(
                controller: _automaticCtrl,
                decoration: const InputDecoration(labelText: 'Transmisión'),
                validator: (v) =>
                     v == null || v.isEmpty ? 'Ingrese la transmision' : null,
              ),
              TextFormField(
                controller: _airCtrl,
                decoration: const InputDecoration(labelText: 'Aire Acondicionado'),
                validator: (v) =>
                     v == null || v.isEmpty ? 'Ingrese el aire acondicionado' : null,
              ),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (v) =>
                     v == null || v.isEmpty ? 'Ingrese el precio' : null,
              ),
              TextFormField(
                controller: _imageUrlCtrl,
                decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                validator: (v) =>
                     v == null || v.isEmpty ? 'Ingrese la URL de la imagen' : null,
              ),
              // TextFormField(
              //   controller: _phoneCtrl,
              //   decoration:
              //       const InputDecoration(labelText: 'Teléfono'),
              // ),
              // TextFormField(
              //   controller: _countryCtrl,
              //   decoration: const InputDecoration(labelText: 'País'),
              // ),
              // TextFormField(
              //   controller: _docCtrl,
              //   decoration: const InputDecoration(labelText: 'Documento'),
              // ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!,
                    style: const TextStyle(color: Colors.red, fontSize: 14)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() {
                          _loading = true;
                          _error = null;
                        });

                        final notifier =
                            ref.read(CarsNotifierProvider.notifier);

                        final newCar = Car(
                          id: '',
                          grupo: _brandCtrl.text.trim(),
                          marca: _brandCtrl.text.trim(),
                          modelo: _modelCtrl.text.trim(),
                          // year: int.tryParse(_yearCtrl.text.trim()) ?? 0,
                          color: _colorCtrl.text.trim(),
                          capacidad: int.tryParse(_capacityCtrl.text.trim()) ?? 0,
                          equipaje: int.tryParse(_luggageCtrl.text.trim()) ?? 0,
                          automatico: _automaticCtrl.text.trim().toLowerCase() == 'true',
                          aire: _airCtrl.text.trim().toLowerCase() == 'true',
                          precio: int.tryParse(_priceCtrl.text.trim()) ?? 0,
                          imageUrl: _imageUrlCtrl.text.trim(),
                        );

                        final err = await notifier.addCar(newCar);

                        setState(() => _loading = false);

                        if (err == null) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Auto agregado con éxito')),
                            );
                            context.go('/home_screen');
                          }
                        } else {
                          setState(() => _error = err);
                        }
                      },
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Agregar auto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}