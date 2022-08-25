import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sample/Dash/DetailPersonne.dart';
import 'package:sample/Dash/Qr.dart';
import 'package:sample/Dash/qr_sample_scanning.dart';
import 'package:sample/custom_components/custom_button.dart';
import 'package:sample/custom_components/push_pop.dart';
import 'package:sample/custom_components/textfield.dart';
import 'package:sample/db/db.dart';
import 'package:sample/models/personne.dart';
import 'package:sample/short_functions/db_short_functions.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class SavePersonne extends StatefulWidget {
  const SavePersonne({Key? key}) : super(key: key);

  @override
  State<SavePersonne> createState() => _SavePersonneState();
}

class _SavePersonneState extends State<SavePersonne> {
  TextEditingController nom = TextEditingController();
  TextEditingController postnom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController prenon = TextEditingController();
  TextEditingController sexe = TextEditingController();
  List agents=[];
  var storage = FirebaseStorage.instance;
  late List<AssetImage> listOfImage;
  bool clicked = false;
  List<String?> listOfStr = [];
  String? images;
  bool isLoading = true;
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('users');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ////////////////////////////////////////////////////////
    initData();
    //////////////////////////////////////////////////////////
    getallPersonnes().then((value) {
      setState(() {});
    });
    setState(() {});
    /////////////////////////////////////////////////////////
  }

  initData() async{
   Response res=await Dio().get("https://udpscarte.vivrexrdc.com/carda/agent/list.php");
  print("Resultat $res");
   setState(() {
     isLoading=false;
     agents=res.data;

   });
   print("Res ${res.data}");
  }


  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'nom': nom.text, //
    'postnom':postnom.text,
      'prenom':prenom.text,
      'sexe':sexe.text,
      'phone':phone.text
    })
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("Failed to add user: $error"));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text("Liste des personnes"),
          actions: [
    
        IconButton(
            onPressed: () async {
              var res;
              res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));
              setState(() {
                if (res is String) {
                  print(res);
                }
              });
              Personne personne = await personneDb.getUser(res);
              DetailPersonne(pers: personne).launch(context);
            },
            icon: Icon(Icons.qr_code))
      ]),
      // body: Container(
      //   child: isLoading
      //       ?Center(child: CircularProgressIndicator(),)
      //   :ListView.builder(
      //       itemCount: agents.length,
      //       itemBuilder: (_, i) {
      //         return Card(
      //           child: ListTile(
      //             onTap: () {
      //               PersonneQr(
      //                   personne: Personne.fromMap(allPersonnes[i])
      //                       .id
      //                       .toString()).launch(context);
      //               //push(context, TestScanner());
      //             },
      //             title: Text("${agents[i]['nom']} ${agents[i]['prenom']}"),
      //             // subtitle: Text("${agents[i]['sexe']}"),
      //             trailing: Text("${agents[i]['sexe']}"),
      //           ),
      //         );
      //       }),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView(
            shrinkWrap: true,
            children:
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          onTap: () {
                            print(document.id);
                            print(data);
                            PersonneQr(
                              user: {
                                "nom":data['nom'],
                                "postnom":data['postnom'],
                                "prenom":data['prenom'],
                                "phone":data['phone'],
                                "sexe":data['sexe'],
                              },
                                personne: document.id).launch(context);
                            //push(context, TestScanner());
                          },
                          title: Text("${data['nom']} ${data['prenom']}"),
                          // subtitle: Text("${agents[i]['sexe']}"),
                          trailing: Text("${data['sexe']}"),
                        ),
                      );

            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showInDialog(context,
          title: Text("Nouvelle personne"),
            builder: (context){
            return Wrap(
              children: [
                AppTextField(
                  controller: nom, // Optional
                  textFieldType: TextFieldType.EMAIL,
                  decoration: InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
                ),
                AppTextField(
                  controller: postnom, // Optional
                  textFieldType: TextFieldType.EMAIL,
                  decoration: InputDecoration(labelText: 'Postnom', border: OutlineInputBorder()),
                ),
                AppTextField(
                  controller: prenom, // Optional
                  textFieldType: TextFieldType.EMAIL,
                  decoration: InputDecoration(labelText: 'Prénom', border: OutlineInputBorder()),
                ),
                AppTextField(
                  controller: sexe, // Optional
                  textFieldType: TextFieldType.EMAIL,
                  decoration: InputDecoration(labelText: 'Sexe', border: OutlineInputBorder()),
                ),
                AppTextField(
                  controller: phone, // Optional
                  textFieldType: TextFieldType.EMAIL,
                  decoration: InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
                ),
                MaterialButton(onPressed: ()async{
                 addUser();
                }, child: Text("Enregistré"),)
              ],
            );
            }
          );
          // create_personne(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> create_personne(
    context,
  ) async {
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            // contentPadding: EdgeInsets.only(top: 10.0),
            title: Text(
              'Nouveau motard',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
            ),
            children: [
              customtextfield("Nom", nom, Icons.abc, TextInputType.text, false),
              SizedBox(
                height: 2.0,
              ),
              customtextfield(
                  "Prénon", prenon, Icons.abc, TextInputType.text, false),
              SizedBox(
                height: 2.0,
              ),
              customtextfield(
                  "Sexe", sexe, Icons.abc, TextInputType.text, false),
              SizedBox(
                height: 2.0,
              ),
              CustomButton(
                  height: 30,
                  text: 'Save',
                  width: 30,
                  color: Colors.blue,
                  textColor: Colors.white,
                  textSize: 12,
                  onTap: () async {
                    if (nom.text.isNotEmpty &&
                        prenon.text.isNotEmpty &&
                        sexe.text.isNotEmpty) {
                      int? id = await personneDb.getCountpersonne();
                      personneDb.savepersonne(new Personne(
                          id.toString(), prenon.text, nom.text, sexe.text));
                      // clear
                      nom.text = "";
                      prenon.text = "";
                      sexe.text = "";

                      // refresh list

                      setState(() {});
                      //pop alert
                      popalert(context);
                    }
                  })
            ],
          );
        });
      },
    );
  }
}
