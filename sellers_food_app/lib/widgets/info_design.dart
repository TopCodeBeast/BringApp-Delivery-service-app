import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_food_app/global/global.dart';
import 'package:sellers_food_app/models/menus.dart';

import '../screens/items_screen.dart';

// ignore: must_be_immutable
class InfoDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  InfoDesignWidget({Key? key, this.context, this.model}) : super(key: key);

  @override
  _InfoDesignWidgetState createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  deleteMenu(String menuID) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(menuID)
        .delete();

    Fluttertoast.showToast(msg: "Menu Deleted");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: InkWell(
        splashColor: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: SizedBox(
            height: 280,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Image.network(
                  widget.model!.thumbnailUrl!,
                  height: 210,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.model!.menuTitle!,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                        fontFamily: "Acme",
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        //delete menu
                        deleteMenu(widget.model!.menuID!);
                      },
                      icon: const Icon(
                        Icons.delete_sweep,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
                Text(
                  widget.model!.menuInfo!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: "Acme",
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => ItemsScreen(model: widget.model),
            ),
          );
        },
      ),
    );
  }
}
