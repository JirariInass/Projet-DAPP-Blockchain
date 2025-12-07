// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Utilise l'import de package pour plus de robustesse
import 'package:hello_dapp/contract_linking.dart'; 

class HelloUI extends StatelessWidget {
  // Ajout de const au constructeur pour optimiser les performances
  const HelloUI(); 

  @override
  Widget build(BuildContext context) {
    // Récupère l'objet ContractLinking. Ce widget sera reconstruit 
    var contractLink = Provider.of<ContractLinking>(context);

    TextEditingController yourNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        // Ajout de const et style
        title: const Text("Hello World !"), 
        centerTitle: true,
        // Utilisation de la couleur primaire du thème défini dans main.dart
        backgroundColor: Theme.of(context).primaryColor, 
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: contractLink.isLoading
              ? const CircularProgressIndicator() // Ajout de const
              : SingleChildScrollView(
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text( // Ajout de const
                              "Hello ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 52),
                            ),
                            Text(
                              contractLink.deployedName,
                              style: const TextStyle( // Ajout de const
                                  fontWeight: FontWeight.bold,
                                  fontSize: 52,
                                  color: Colors.tealAccent),
                            ),
                          ],
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 29), // Ajout de const
                          child: TextFormField(
                            controller: yourNameController,
                            decoration: const InputDecoration( // Ajout de const
                                border: OutlineInputBorder(),
                                labelText: "Your Name",
                                hintText: "What is your name ?",
                                icon: Icon(Icons.drive_file_rename_outline)),
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 30), // Ajout de const
                          child: ElevatedButton(
                            child: const Text( // Ajout de const
                              'Set Name',
                              style: TextStyle(fontSize: 30),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              if (yourNameController.text.isNotEmpty) {
                                // Appelle la fonction de transaction setName
                                contractLink.setName(yourNameController.text);
                                yourNameController.clear();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}