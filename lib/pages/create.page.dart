import 'package:diario_aventuras/auth/login.page.dart';
import 'package:diario_aventuras/pages/read.page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
//variavel booleana pra detectar aonde esta rodando... true quando esta em web e false pra android...
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  //controllers de texto aonde armazena o que foi digitado pelo usuario nestes campos de textos, textfield
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  //pra armazenar a data escolhida
  final TextEditingController dateController = TextEditingController();
  //instanciando a funçao imagepicker e armazenando ela numa variavel
  final imagePicker = ImagePicker();
  File? imageFile;
  //variaveis pra receber latitude e longitude e depois imprimir como texto
  double? latitude;
  double? longitude;
  Uint8List? webImageBytes;
  //variaveis manipulaveis de data, hora e localizaçao.
  DateTime selectedDate = DateTime.now();
  //variavel geoPoint vem do pacote clod firestore pra armazenar localizaçao
  GeoPoint? currentLocation;
  TimeOfDay _timeOfDay = TimeOfDay.now();

  //funçao imageSource do pacote imagePicker padrao para acessar imagem de armazenamento ou camera do usuario
  _selectedImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    //se a vier arquivo, vai pro pickedFile
    //do picked file vai pra variavel imageFile, acho que armazena daonde veio a foto
    if (pickedFile != null) {
      if (kIsWeb) {
        //se for web...
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          webImageBytes = bytes;
        });
      } else {
        setState(() {
          //e o que for armazenado no imageFile, vai pro backgroud image daquele circulo que criamos...CircleAvatar
          imageFile = File(pickedFile.path);
        });
      }
    }
  }

  //funçao pra limpar o que foi armazenado nos conntroller de texto
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  //funçao de nome showImageOptions
  void _showImageOptions() {
    //bottomSheet padrao do flutter
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              //pra nao ter so texto, um icone de foto do pacote padrao do fluter
              leading: Icon(Icons.photo),
              title: Text(
                'Galeria',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              //quando clicar neste texto de galeria, ele abre a funçao do image picker imageSource
              //que foi programada aqui com o .gallery do pacote tambem pra obviamente abrir a galeria
              onTap: () {
                Navigator.of(context).pop();
                _selectedImage(ImageSource.gallery);
              },
            ),

            ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text(
                'Câmera',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _selectedImage(ImageSource.camera);
              },
            ),

            ListTile(
              leading: Icon(Icons.delete_outline_rounded),
              title: Text('Excluir'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  imageFile = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _getLocation() async {
    //await por que o usuario precisa dar a permissao de localização...
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    print(position);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  //funçao de foto
  Future<String?> _uploadPhoto(File imageFile, String uid) async {
    final storageRef = FirebaseStorage.instance.ref();
    final photoRef = storageRef.child(
      'adventures/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    if (kIsWeb && webImageBytes != null) {
      await photoRef.putData(webImageBytes!);
    } else if (imageFile != null)
      await photoRef.putFile(imageFile!);
    else {
      return null;
    }
    return await photoRef.getDownloadURL();
  }

  //-----parei aqui------
  Future<void> _createAdventure() async {
    final idUsuario = FirebaseAuth.instance.currentUser;
    //nao tem sentido validar se o usuario ta logado, pois ele so acessa o crud se estiver logado...
    //mas precisamos importar o currentUser pra saber o id do usuario, e com isso passar ele no mapa, eu acho..

    //unindo o datePicker e timePicker
    final dataCompleta = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      _timeOfDay.hour,
      _timeOfDay.minute,
    );

    final photoUrl = await _uploadPhoto(imageFile!, idUsuario!.uid);

    final adventure2 = {
      //a esquerda vem o nome do campo, a direita da onde ele vem...
      'title': titleController.text,
      'description': descriptionController.text,
      'uid': idUsuario?.uid,
      'timestamp': Timestamp.fromDate(dataCompleta),
      'location': GeoPoint(latitude!, longitude!),
      'createdAt': Timestamp.now(),
      'photoUrl': photoUrl,
    };

    //instancia do metodo do firebase pra adicionar colecao
    await FirebaseFirestore.instance.collection('adventures').add(adventure2);
  }
  //--------

  Future<void> _selectDate() async {
    //showDatePicker, metodo do pacote pra abrir o calendario
    //o resultado armazena na variavel tipo DateTime de nome picked
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    //eu estava em duvida deste if, mas o picked != selectedDate é pra nao atualizar a data escolhida se o que foi selecionado for igual ao que ja estava
    //funciona sem esta parte, é so uma otimização...
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        //aqui atualizamos o dateController com o valor recebido
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? _picked = await showTimePicker(
      initialTime: _timeOfDay,
      context: context,
    );

    if (_picked != null) {
      setState(() {
        _timeOfDay = _picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Aventura')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),

            //data
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Data',
                prefix: Icon(Icons.calendar_today),
              ),
              //readOnly pra nao editar o texto do textfield de calendario com conteudo "data"
              readOnly: true,
              //ao clicar no textfield de data "on tap", chama a funçao para abrir o seletor de calendario.
              onTap: () {
                _selectDate();
              },
            ),

            ElevatedButton(
              child: const Text("Buscar localização atual"),
              onPressed: _getLocation,
            ),

            Text(
              latitude != null && longitude != null
                  ? 'Localização: $latitude, $longitude'
                  : 'Localização ainda não capturada',
            ),

            Text(
              _timeOfDay.hour.toString().padLeft(2, '0') +
                  ':' +
                  _timeOfDay.minute.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              child: const Text("Selecione o horário"),
              onPressed: () {
                _selectTime();
              },
            ),

            // botões de localização
            GestureDetector(
              onTap: _showImageOptions,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  //aqui define o background do circulo com a imagem
                  backgroundImage:
                      imageFile != null ? FileImage(imageFile!) : null,
                ),
              ),
            ),

            MaterialButton(
              onPressed: _createAdventure,
              child: const Text('Salvar Aventura'),
            ),

            MaterialButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: const Text('Sair'),
            ),

            //redirecionar pra read page
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ReadPage()),
                );
              },
              child: const Text('Clique para ver as aventuras'),
            ),
          ],
        ),
      ),
    );
  }
}
