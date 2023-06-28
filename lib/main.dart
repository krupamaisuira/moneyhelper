import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moneyhelper/register.dart';
import 'package:moneyhelper/userstate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'dashboard.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserState(),
      child: MyLoginPage(),
    ),
  );
  //runApp(MyLoginPage());
}

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MoneyHelper',

        home: Loginpage());
  }
}

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar( title: Text('MoneyHelper')),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Image.asset('assets/images/logo.png'),
                  width: 200,  // Set the desired width
                  height: 150, // Replace 'assets/logo.png' with the path to your logo image
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Sign in', style: TextStyle(fontSize: 24,color:  Colors.blue,fontWeight: FontWeight.bold),)
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _username,
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                        labelText: 'Enter User Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _pwd,
                    decoration: InputDecoration(
                      //   border: OutlineInputBorder(),
                      labelText: 'Enter Password',
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_username.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('User name is required.'),
                            );
                          },
                        );
                      } else if (_pwd.text.isEmpty ||
                          (_pwd.text.length < 6 || _pwd.text.length > 8)) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'Password is invalid. password must be greater than 6 char and less than or equal to 8 char'),
                            );
                          },
                        );
                      } else {
                        validateUser();
                      }
                    },
                    child: Text('Sign in')),
                Text("OR"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyRegisterPage()),
                    );
                  },
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            )));
  }
  void validateUser() async {
    bool isValidate = await loginUser();

    if (isValidate) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyDashboardPage(),
        ),
      );


    } else {
      _pwd.clear();

      final snackBar = SnackBar(
          content: Text("User name or password invalid."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<bool> loginUser() async {
    Directory directory = await getApplicationSupportDirectory();
    String filePath =
        '${directory.path}/moneyheplerdb/' + _username.text + '.json';
    File file = File(filePath);

    if (await file.exists()) {

      String fileContents = await file.readAsString();
      dynamic jsonData = json.decode(fileContents);
      dynamic password = jsonData['password'];

      if (password == _pwd.text) {
        print("find equal");
        Provider.of<UserState>(context, listen: false).setUsername(_username.text);

        return true;
      }
    }
    return false;
  }
}
