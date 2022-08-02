import 'dart:convert';

import 'package:starknet/starknet.dart';

void main() async {
  final blockNumber = await JsonRpcReadProvider.devnet.blockNumber();
  print(blockNumber);
}

prettyPrintJson(Map<String, dynamic> json) {
  var encoder = JsonEncoder.withIndent("  ");
  print(encoder.convert(json));
}
