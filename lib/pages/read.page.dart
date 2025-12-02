import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diario_aventuras/pages/get_information.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//acessa todos os documentos do banco adventures pelo id
//chama o get information que acessa os detalhes


class ReadPage extends StatefulWidget {
  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  List<String> docIDs = [];

  @override
  void initState() {
    super.initState();
    getDocId(); // carrega os IDs uma vez
  }

//aqui percorre os ids da colecao adventures
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('adventures')
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach((document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    //chamamos o getinformation para acessar detalhes do id
                    title: GetInformation(documentId: docIDs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
