import 'package:starknet/starknet.dart';

ReadProvider getJsonRpcReadProvider() {
  const network =
      String.fromEnvironment('NETWORK', defaultValue: 'infuraMainnet');
  if (network == 'infuraGoerliTestnet') {
    return JsonRpcReadProvider.infuraGoerliTestnet;
  } else if (network == 'v010PathfinderGoerliTestnet') {
    return JsonRpcReadProvider.v010PathfinderGoerliTestnet;
  } else if (network == 'infuraMainnet') {
    return JsonRpcReadProvider.infuraMainnet;
  } else {
    return JsonRpcReadProvider.devnet;
  }
}

Provider getJsonRpcProvider() {
  const network =
      String.fromEnvironment('NETWORK', defaultValue: 'infuraGoerliTestnet');
  if (network == 'infuraMainnet') {
    return JsonRpcProvider.infuraGoerliTestnet;
  } else if (network == 'v010PathfinderGoerliTestnet') {
    return JsonRpcProvider.v010PathfinderGoerliTestnet;
  } else if (network == 'infuraMainnet') {
    return JsonRpcProvider.infuraMainnet;
  } else {
    return JsonRpcProvider.devnet;
  }
}
