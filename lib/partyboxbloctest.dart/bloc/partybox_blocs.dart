import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinxproject/partyboxbloctest.dart/bloc/partybox_events.dart';

// import '../../test/bloc/app_events.dart';
// import '../../test/bloc/app_states.dart';
import '../../test/productrepo.dart';
import 'partybox_states.dart';

class PartyboxBloc extends Bloc<PartyboxBlocEvent, PartyboxState> {
  final ProductRepository productRepository;
  PartyboxBloc({required this.productRepository}) : super(InitialState()) {
    on<Create>((event, emit) async {
      emit(PartyboxAdding());
      await Future.delayed(const Duration(seconds: 1));
      try {
        await productRepository.create(name: event.name, price: event.price);
        emit(PartyboxAdded());
      } catch (e) {
        emit(PartyboxError(e.toString()));
      }
    });

    on<GetData>((event, emit) async {
      emit(PartyboxLoading());
      await Future.delayed(const Duration(seconds: 1));
      try {
        final data = await productRepository.getParty();
        emit(PartyboxLoaded(data));
      } catch (e) {
        emit(PartyboxError(e.toString()));
      }
    });
    on<Delete>((event, emit) async {
      try {
        emit(PartyboxDeleting());
        await productRepository.delete(event.id);
        emit(PartyboxDeleted());
      } catch (e) {
        emit(PartyboxError(e.toString()));
      }
    });
    on<Edit>((event, emit) async {
      emit(PartyboxEditing());
      await Future.delayed(const Duration(seconds: 1));
      try {
        await productRepository.edit(
            name: event.name, price: event.price, id: event.id);
        emit(PartyboxEdited());
      } catch (e) {
        emit(PartyboxError(e.toString()));
      }
    });
  }
}
