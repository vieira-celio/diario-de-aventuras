import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//esse widget serve pra receber o id das aventuras e acessar todos os detalhes das aventuras

class GetInformation extends StatelessWidget {
  final String documentId;

  GetInformation({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference adventures = FirebaseFirestore.instance.collection(
      'adventures',
    );

    return FutureBuilder<DocumentSnapshot>(
      future: adventures.doc(documentId).get(),
      builder: ((context, snapshot) {
        //transforma o documento do Firestore em um Map<String, dynamic>, 
        //permitindo acessar os campos por chave (data['title'], data['description']).
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          // transforma o campo timestamp em DateTime
          Timestamp ts = data['timestamp'];
          DateTime date = ts.toDate();

          // converte a hora de criaçao
          DateTime? createdAt;
          if (data['createdAt'] != null) {
            createdAt = (data['createdAt'] as Timestamp).toDate();
          }

          //converte o location
          GeoPoint? location;
          if (data['location'] != null) {
            location = data['location'] as GeoPoint;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Título: ${data['title'] ?? ''}'),
              Text('Descrição: ${data['description'] ?? ''}'),
              Text('Data: ${date.day}/${date.month}/${date.year}'),
              Text(
                createdAt != null
                    ? 'Criado em: ${createdAt.day}/${createdAt.month}/${createdAt.year}'
                    : 'Criado em: não informado',
              ),
              Text(
                location != null
                    ? 'Localização: ${location.latitude}, ${location.longitude}'
                    : 'Localização: não informada',
              ),
            ],
          );
        }
        return Text('loading...');
      }),
    );
  }
}
