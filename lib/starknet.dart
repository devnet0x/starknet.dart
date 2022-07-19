/// The Starknet Dart SDK ✨
///
/// It aims at supporting the same API as the official Starknet API, but in Dart.
library starknet;

export 'src/provider.dart' show JsonRpcProvider, Provider;

export 'src/keccak.dart'
    show starknetKeccak, getSelectorByName, getStringSelectorByName;

export 'src/convert.dart'
    show bigIntToHexString, hexStringToBigInt, bigIntToString, stringToBigInt;

export 'src/model/block_number.dart';
export 'src/model/call.dart';
export 'src/model/get_block_with_tx_hashes.dart';
