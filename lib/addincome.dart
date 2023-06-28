
import 'package:flutter/material.dart';
import 'package:moneyhelper/userstate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(AddIncomePage()
  );
}

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({Key? key}) : super(key: key);

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  TextEditingController _income = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String loginUserName = Provider.of<UserState>(context).username;
    return Scaffold(

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
                    child: Text('Income', style: TextStyle(fontSize: 24,color:  Colors.blue,fontWeight: FontWeight.bold),)
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _income,
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                        labelText: 'Enter Your Income'),
                  ),
                ),

                ElevatedButton(
                    onPressed: () {
                      if (_income.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Income is required.'),
                            );
                          },
                        );
                      }
                      else {
                        addIncome(loginUserName);


                      }
                    },
                    child: Text('Add Income')),

              ],
            )));
  }


  void addIncome(String loginUserName) async {
    bool isadded = await addIncomeLogic(loginUserName);

    if (isadded) {
      final snackBar = SnackBar(
          content: Text("Income successfully added"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _income.clear();
    } else {
      final snackBar = SnackBar(
          content: Text("Something wrong.please contact admin or try after sometime"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _income.clear();
    }
  }

  Future<bool> addIncomeLogic(String loginUserName) async {

    Directory directory = await getApplicationSupportDirectory();
    String filePath = '${directory.path}/moneyheplerdb/' + loginUserName + '.json';
    File file = File(filePath);
    print(filePath);
    if (await file.exists()) {
      String jsonString = file.readAsStringSync();
      Map<String, dynamic> data = json.decode(jsonString);
      print(_income.text.toString());
      data['budget'] = _income.text.toString();
      data['netincome'] = _income.text.toString();
      data['expenses'] =[];
      String updatedJsonString = json.encode(data);
      print(updatedJsonString);
      file.writeAsStringSync(updatedJsonString, flush: true);
      return true;
    }
    return false;
  }
}



