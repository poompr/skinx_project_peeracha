import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../partybox_model.dart';

@immutable
abstract class PartyboxState extends Equatable {}

class InitialState extends PartyboxState {
  @override
  // ignore: todo
  // TODO: implement props
  List<Object?> get props => [];
}

class PartyboxAdding extends PartyboxState {
  @override
  List<Object?> get props => [];
}

class PartyboxAdded extends PartyboxState {
  @override
  List<Object?> get props => [];
}

class PartyboxError extends PartyboxState {
  final String error;

  PartyboxError(this.error);
  @override
  List<Object?> get props => [error];
}

class PartyboxLoading extends PartyboxState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class PartyboxLoaded extends PartyboxState {
  List<PartyboxModel> mydata;
  PartyboxLoaded(this.mydata);
  @override
  List<Object?> get props => [];
}

class PartyboxDeleting extends PartyboxState {
  @override
  List<Object?> get props => [];
}

class PartyboxDeleted extends PartyboxState {
  @override
  List<Object?> get props => [];
}

class PartyboxEditing extends PartyboxState {
  @override
  List<Object?> get props => [];
}

class PartyboxEdited extends PartyboxState {
  @override
  List<Object?> get props => [];
}
