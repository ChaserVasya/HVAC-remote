import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class DataMapper {
  String byteData2String(ByteData data) {
    final ByteBuffer buffer = data.buffer;
    final Uint8List list = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return utf8.decode(list);
  }
}
