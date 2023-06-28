import 'package:flutter/material.dart';
import 'package:moneyhelper/userstate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';

import 'package:uuid/uuid.dart';

void main() {
  runApp(AddExpensePage()
  );
}
class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  TextEditingController _expense = TextEditingController();
  TextEditingController _amount = TextEditingController();
  TextEditingController _note = TextEditingController();
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
                    child: Text('Expenses', style: TextStyle(fontSize: 24,color:  Colors.blue,fontWeight: FontWeight.bold),)
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _expense,
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                        labelText: 'Enter Expense Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _amount,
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                        labelText: 'Enter Amount'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _note,
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                        labelText: 'Enter Notes'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_expense.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Expense name is required.'),
                            );
                          },
                        );
                      }
                      else if (_amount.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Expense amount is required.'),
                            );
                          },
                        );
                      }
                      else if (_note.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Notes is required.'),
                            );
                          },
                        );
                      }
                      else {
                        addExpense(loginUserName);

                      }
                    },
                    child: Text('Add Expense')),

              ],
            )));
  }
  void addExpense(String loginUserName) async {
    bool isadded = await addExpenseLogic(loginUserName);

    if (isadded) {
      final snackBar = SnackBar(
          content: Text("Expense successfully added"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _expense.clear();
      _amount.clear();
      _note.clear();
    } else {
      final snackBar = SnackBar(
          content: Text("Something wrong.please contact admin or try after sometime or please add income"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _expense.clear();
      _amount.clear();
      _note.clear();
    }


  }

  Future<bool> addExpenseLogic(String loginUserName) async {

    Directory directory = await getApplicationSupportDirectory();
    String filePath = '${directory.path}/moneyheplerdb/' + loginUserName + '.json';
    File file = File(filePath);

    if (await file.exists()) {
      String jsonString = file.readAsStringSync();
      Map<String, dynamic> data = json.decode(jsonString);

      if (data.containsKey("netincome")) {
        final jsonData = {
          'expenseid': Uuid().v4(),
          'name': _expense.text.toString(),
          'amount': _amount.text.toString(),
          'notes': _note.text.toString(),
        };
        var list = data['expenses'] as List<dynamic>;

        if (list.isEmpty) {
          list.add(jsonEncode(jsonData));
        } else {
          list.addAll([jsonEncode(jsonData)]);
        }
        int budget = int.parse(data['netincome']);

        for (var item in list) {
          dynamic expdata = json.decode(item);
          print(expdata['name']);
          budget = budget - int.parse(expdata['amount']);
          print('Total Budget: $budget');
        }
        data['budget'] = (budget).toString();
        String updatedJsonString = json.encode(data);
        file.writeAsStringSync(updatedJsonString, flush: true);
        return true;
      }
    }
    return false;
  }
}
