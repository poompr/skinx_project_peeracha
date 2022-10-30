import 'package:flutter_bloc/flutter_bloc.dart';

import '../productrepo.dart';
import 'app_events.dart';
import 'app_states.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  ProductBloc({required this.productRepository}) : super(InitialState()) {
    on<Create>((event, emit) async {
      emit(ProductAdding());
      await Future.delayed(const Duration(seconds: 1));
      try {
        await productRepository.create(name: event.name, price: event.price);
        emit(ProductAdded());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<GetData>((event, emit) async {
      emit(ProductLoading());
      await Future.delayed(const Duration(seconds: 1));
      try {
        final data = await productRepository.get();
        emit(ProductLoaded(data));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
    on<Delete>((event, emit) async {
      try {
        emit(ProductDeleting());
        await productRepository.delete(event.id);
        emit(ProductDeleted());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
    on<Edit>((event, emit) async {
      emit(ProductEditing());
      await Future.delayed(const Duration(seconds: 1));
      try {
        await productRepository.edit(
            name: event.name, price: event.price, id: event.id);
        emit(ProductEdited());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
