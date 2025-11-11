import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/cars_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddCarScreenView extends ConsumerStatefulWidget {
  const AddCarScreenView({super.key});

  @override
  ConsumerState<AddCarScreenView> createState() => _AddCarScreenViewState();
}

class _AddCarScreenViewState extends ConsumerState<AddCarScreenView> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _groupCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
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
      appBar: const CustomAppBar(title: 'Agregar autos'),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _idCtrl,
                  decoration: InputDecoration(
                    hintText: 'Código',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese el código' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _groupCtrl,
                  decoration: InputDecoration(
                    hintText: 'Grupo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese el grupo' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _brandCtrl,
                  decoration: InputDecoration(
                    hintText: 'Marca',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese la marca' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _modelCtrl,
                  decoration: InputDecoration(
                    hintText: 'Modelo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese el modelo' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _colorCtrl,
                  decoration: InputDecoration(
                    hintText: 'Color',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese el color' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _capacityCtrl,
                  decoration: InputDecoration(
                    hintText: 'Capacidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese la capacidad' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _luggageCtrl,
                  decoration: InputDecoration(
                    hintText: 'Equipaje',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese el equipaje' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _automaticCtrl,
                  decoration: InputDecoration(
                    hintText: 'Transmisión',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese la transmisión' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _airCtrl,
                  decoration: InputDecoration(
                    hintText: 'Aire Acondicionado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Ingrese el aire acondicionado'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _priceCtrl,
                  decoration: InputDecoration(
                    hintText: 'Precio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese el precio' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _imageUrlCtrl,
                  decoration: InputDecoration(
                    hintText: 'URL de la Imagen',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Ingrese la URL de la imagen'
                      : null,
                ),
              ),

              const SizedBox(height: 20),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              const SizedBox(height: 12),

              FilledButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() {
                          _loading = true;
                          _error = null;
                        });

                        final notifier = ref.read(
                          CarsNotifierProvider.notifier,
                        );

                        final newCar = Car(
                          id: '',
                          grupo: _brandCtrl.text.trim(),
                          marca: _brandCtrl.text.trim(),
                          modelo: _modelCtrl.text.trim(),
                          color: _colorCtrl.text.trim(),
                          capacidad:
                              int.tryParse(_capacityCtrl.text.trim()) ?? 0,
                          equipaje: int.tryParse(_luggageCtrl.text.trim()) ?? 0,
                          automatico:
                              _automaticCtrl.text.trim().toLowerCase() ==
                              'true',
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
                                content: Text('Auto agregado con éxito'),
                              ),
                            );
                            context.go('/home_screen');
                          }
                        } else {
                          setState(() => _error = err);
                        }
                      },
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
                child: _loading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Agregar auto',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
