// lib/contract_linking.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart'; 
import 'package:web3dart/web3dart.dart';
import 'dart:async'; 

class ContractLinking extends ChangeNotifier {
  // Adresse RPC Ganache (correcte pour le navigateur Web)
  final String _rpcUrl = "http://localhost:7545"; 
  
  // Clé privée du compte Ganache (doit être le même que celui qui a déployé)
  final String _privateKey =
      "d826b4a78f7347c97537ad953402d7a6e356e10d58a1aa1f6d9e69c7a91f4a99"; 

  late Web3Client _client;
  bool isLoading = true;

  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;

  late ContractFunction _yourName;
  late ContractFunction _setName;

  String deployedName = "";

  ContractLinking() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    _client = Web3Client(_rpcUrl, Client());
    await _getAbi();
    await _getCredentials();
    await _getDeployedContract();
  }

  Future<void> _getAbi() async {
    String abiStringFile = await rootBundle.loadString(
      "src/artifacts/HelloWorld.json",
    );
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    // Lecture de l'ID de réseau (devrait être 5777)
    final network = jsonAbi["networks"].keys.first; 
    final addressHex = jsonAbi["networks"][network]["address"] as String;
    _contractAddress = EthereumAddress.fromHex(addressHex);

    // 🔑 DEBUG PRINT: Vérifiez ces valeurs dans la console !
    debugPrint("ABI lu : $_abiCode");
    debugPrint("Network ID lu : $network");
    debugPrint("Adresse du contrat lue : $addressHex");
  }

  Future<void> _getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> _getDeployedContract() async {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "HelloWorld"),
      _contractAddress,
    );

    _yourName = _contract.function("yourName");
    _setName = _contract.function("setName");

    await getName();
  }

  Future<void> getName() async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _yourName,
        params: [],
      );
      deployedName = result[0] as String;
      // 🔑 DEBUG PRINT: Vérifiez cette valeur dans la console !
      debugPrint("Nom récupéré du contrat : $deployedName");

    } catch (e) {
      deployedName = "Erreur de lecture de Contrat (Nom/Fonction)"; 
      debugPrint("getName error (Contract call failed): $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> setName(String nameToSet) async {
    isLoading = true;
    notifyListeners();

    try {
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _setName,
          parameters: [nameToSet],
        ),
        chainId: 5777,
      );

      await Future.delayed(const Duration(seconds: 3)); 
      await getName(); 

    } catch (e) {
      debugPrint("setName transaction error: $e");
      isLoading = false;
      notifyListeners();
    }
  }
}