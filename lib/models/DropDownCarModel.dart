// To parse this JSON data, do
//
//     final dropDownCarModel = dropDownCarModelFromJson(jsonString);

import 'dart:convert';

class DropDownCarModel {
  int index;
  List<CarDrp> car;
  List<Model> model;
  List<TypeCar> typeCar;

  DropDownCarModel(
    this.index,
    this.car,
    this.model,
    this.typeCar,
  );
}

class CarDrp {
  int carId;
  String brand;

  CarDrp(
    this.carId,
    this.brand,
  );

}

class Model {
  int modelId;
  String modelName;

  Model(
    this.modelId,
    this.modelName,
  );

}

class TypeCar {
  int typeCarId;
  String size;

  TypeCar(
    this.typeCarId,
    this.size,
  );

}
