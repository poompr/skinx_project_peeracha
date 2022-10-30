import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:skinxproject/test/model.dart';

@immutable
abstract class ProductState extends Equatable {}

class InitialState extends ProductState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductAdding extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductAdded extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductError extends ProductState {
  final String error;

  ProductError(this.error);
  @override
  List<Object?> get props => [error];
}

class ProductLoading extends ProductState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class ProductLoaded extends ProductState {
  List<ProductModel> mydata;
  ProductLoaded(this.mydata);
  @override
  List<Object?> get props => [];
}

class ProductDeleting extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductDeleted extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductEditing extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductEdited extends ProductState {
  @override
  List<Object?> get props => [];
}
