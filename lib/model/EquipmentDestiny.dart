class EquipmentDestiny {
  int idEquipment;
  String equipName;
  int idDestiny;
  String destinyName;
  int equipmentQuantity;

  EquipmentDestiny(
      {this.equipName,
      this.destinyName,
      this.idEquipment,
      this.idDestiny,
      this.equipmentQuantity});

  Map<String, dynamic> toJson() {
    return {
      'idEquipment': idEquipment,
      'idDestiny': idDestiny,
      'equipmentQuantity': equipmentQuantity
    };
  }
}
