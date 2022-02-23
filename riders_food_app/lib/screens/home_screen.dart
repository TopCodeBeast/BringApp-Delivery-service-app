import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riders_food_app/assistantMethods/get_current_location.dart';
import 'package:riders_food_app/screens/earnings_screen.dart';
import 'package:riders_food_app/screens/history_screen.dart';
import 'package:riders_food_app/screens/new_orders_screen.dart';
import 'package:riders_food_app/screens/not_yet_delivered_screen.dart';
import 'package:riders_food_app/screens/parcel_in_progress_screen.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(3.0, -1.0),
                  colors: [
                    Color(0xFF004B8D),
                    Color(0xFFffffff),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3,
                    offset: Offset(4, 3),
                  )
                ],
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(3.0, -1.0),
                  colors: [
                    Colors.cyan,
                    Colors.amber,
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3,
                    offset: Offset(4, 3),
                  )
                ],
              ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //new orders
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => NewOrdersScreen())));
            }
            if (index == 1) {
              //Parcels in progress
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ParcelInProgressScreen()));
            }
            if (index == 2) {
              //not yet delivered
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotYetDeliveredScreen()));
            }
            if (index == 3) {
              //history
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()));
            }
            if (index == 4) {
              //total earnings
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EarningsScreen()));
            }
            if (index == 5) {
              //logout
              firebaseAuth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const AuthScreen())));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrenLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousEarnings();
  }

  getRiderPreviousEarnings() {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  //method to calculate amount per delivery
  getPerParcelDeliveryAmount() {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("taydinadnan")
        .get()
        .then((snap) {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(3.0, -1.0),
              colors: [
                Color(0xFF004B8D),
                Color(0xFFffffff),
              ],
            ),
          ),
        ),
        title: Text(
          "Welcome " + sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontFamily: "Signatra",
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("New Available", Icons.assignment, 0),
            makeDashboardItem("Parcels in Progress", Icons.airport_shuttle, 1),
            makeDashboardItem("Not Yet Delivered", Icons.location_history, 2),
            makeDashboardItem("History", Icons.done_all, 3),
            makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
            makeDashboardItem("Logout", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
