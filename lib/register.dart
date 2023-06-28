import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

void main() {
  runApp(MyRegisterPage());
}


class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({Key? key}) : super(key: key);

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  TextEditingController _phone = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _pwd = TextEditingController();
  TextEditingController _confirmpwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MoneyHelper'),
        ),
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
                  child: Text('Sign up', style: TextStyle(fontSize: 24,color:  Colors.blue,fontWeight: FontWeight.bold),)
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _confirmpwd,
                    decoration: InputDecoration(
                      //   border: OutlineInputBorder(),
                      labelText: 'Enter Confirm Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _phone,
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                        labelText: 'Enter Mobile Number'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_phone.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Mobile number is required.'),
                            );
                          },
                        );
                      } else if (_username.text.isEmpty) {
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
                      } else if (_confirmpwd.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('password is required.'),
                            );
                          },
                        );
                      } else if (_pwd.text != _confirmpwd.text) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Passwords does not match.'),
                            );
                          },
                        );
                      } else {
                        registerUser();

                        // register success page
                      }
                    },
                    child: Text('Sign up')),
                Text("OR if already have an account"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyLoginPage()),
                    );
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            )));
  }

  void registerUser() async {
    bool isregister = await createFile();

    if (isregister) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text("SuccessFully Registered"),
            actions: <Widget>[
              TextButton(
                child: Text('Sign in'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyLoginPage()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      _pwd.clear();
      _confirmpwd.clear();
      final snackBar = SnackBar(
          content: Text("User name already exists.please try another one"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> createFile() async {
    Directory directory = await getApplicationSupportDirectory();
    String filePath =
        '${directory.path}/moneyheplerdb/' + _username.text + '.json';
    File file = File(filePath);

    if (await file.exists()) {
      return false;
    } else {
      final jsonData = {
        'username': _username.text.toString(),
        'phone': _phone.text.toString(),
        'password': _pwd.text.toString(),
      };
      String jsonString = jsonEncode(jsonData);

      file.createSync(recursive: true);
      file.writeAsString(jsonString);
      print('File created: $filePath');
      return true;
    }
  }
}
