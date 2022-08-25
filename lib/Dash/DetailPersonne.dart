import 'package:flutter/material.dart';
import 'package:sample/models/personne.dart';

class DetailPersonne extends StatefulWidget {
  Personne? pers;

   DetailPersonne({@required this.pers}) ;

  @override
  State<DetailPersonne> createState() => _DetailPersonneState();
}

class _DetailPersonneState extends State<DetailPersonne> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////



    setState(() {});
    /////////////////////////////////////////////////////////
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

appBar: AppBar(),

      body: Container(
        child: Card(
          child: ListTile(
            title: Text(widget.pers!.prenom),
            subtitle: Text(widget.pers!.nom),
          ),
        ),
      ),

    );
  }
}
