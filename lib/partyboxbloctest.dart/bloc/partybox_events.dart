import 'package:equatable/equatable.dart';

abstract class PartyboxBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Create extends PartyboxBlocEvent {
  final String name;
  final String price;

  Create(this.name, this.price);
}

class GetData extends PartyboxBlocEvent {
  GetData();
}

class Delete extends PartyboxBlocEvent {
  final String id;
  Delete(this.id);
}

class Edit extends PartyboxBlocEvent {
  final String name;
  final String price;
  final String id;

  Edit(this.name, this.price, this.id);
}
