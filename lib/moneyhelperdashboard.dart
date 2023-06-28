import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moneyhelper/userstate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'dashboard.dart';


void main() {
  runApp(MoneyHelperDash());
}

class MoneyHelperDash extends StatefulWidget {
  const MoneyHelperDash({Key? key}) : super(key: key);

  @override
  State<MoneyHelperDash> createState() => _MoneyHelperDashState();
}

class _MoneyHelperDashState extends State<MoneyHelperDash> {
  String loginuserName = "";

  int income = 0;
  int budget = 0;

  @override
  void initState() {
    super.initState();

    UserState userState = Provider.of<UserState>(context, listen: false);
    loginuserName = userState.username;

    loadData(userState.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(18.0),
            color: Colors.blue,
            child: Text(
              'Welcome, ! ${loginuserName}',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Total Income',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '\$${income}',
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Total Budget',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '\$${budget}',
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListTile(
              leading: Icon(Icons.business),
              title: Text('Expenses'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyDashboardPage(),
                    settings: RouteSettings(
                        arguments: 2), // Pass the tab index as an argument
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Income'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyDashboardPage(),
                    settings: RouteSettings(
                        arguments: 1), // Pass the tab index as an argument
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyDashboardPage(),
                    settings: RouteSettings(
                        arguments: 3), // Pass the tab index as an argument
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadData(String loginUserName) async {
    Directory directory = await getApplicationSupportDirectory();
    String filePath =
        '${directory.path}/moneyheplerdb/' + loginUserName + '.json';
    File file = File(filePath);
    String jsonString = file.readAsStringSync();
    Map<String, dynamic> data = jsonDecode(jsonString);

    print(data);

    setState(() {
      if (data.containsKey("netincome")) {
        // Key exists in the JSON object
        var value = data["netincome"];
        if (value == null) {
          income = 0;
        } else {
          income = int.parse(data["netincome"]);
          // Value is not null
        }
      }
      if (data.containsKey("budget")) {
        // Key exists in the JSON object
        var value = data["budget"];
        if (value == null) {
          budget = 0;
        } else {
          budget = int.parse(data["budget"]);
          // Value is not null
        }
      }
    });
  }
}
