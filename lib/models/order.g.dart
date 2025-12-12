
// GENERATED CODE - MANUAL ADAPTER
part of 'order.dart';

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 2;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i=0;i<numOfFields;i++){
      fields[reader.readByte()] = reader.read();
    }
    return Order(
      id: fields[0] as String,
      userId: fields[1] as String,
      items: (fields[2] as List).cast<Food>(),
      total: fields[3] as double,
      status: fields[4] as String,
      deliveryManId: fields[5] as String?,
      deliveryCharge: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.deliveryManId)
      ..writeByte(6)
      ..write(obj.deliveryCharge);
  }
}
