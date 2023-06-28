import 'package:flutter/material.dart';
import 'package:moneyhelper/userstate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(ViewExpensePage());
}



class ViewExpensePage extends StatefulWidget {
  const ViewExpensePage({super.key});

  @override
  State<ViewExpensePage> createState() => _ViewExpensePageState();
}

class _ViewExpensePageState extends State<ViewExpensePage> {
  List<ExpensesList> items = [];
  String loginuserName = "";

  @override
  void initState() {
    super.initState();

    UserState userState = Provider.of<UserState>(context, listen: false);
    loginuserName =  userState.username;
    print(userState.username);
    loadListData(userState.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final expense = items[index];

          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.attach_money),
              ),
              title: Text("${expense.name} - \$${expense.amount}"),
              subtitle: Text(
                "${expense.notes}",
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    items.remove(expense);
                    loadRemoveExpense(index);
                    final snackBar = SnackBar(
                        content: Text("Expense successfully deleted"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
              ),
              onTap: () {
                // Handle tap on expense item
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> loadListData(String loginUserName) async {
    Directory directory = await getApplicationSupportDirectory();
    String filePath =
        '${directory.path}/moneyheplerdb/' + loginUserName + '.json';
    File file = File(filePath);
    String jsonString = file.readAsStringSync();
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    List<dynamic> jsonList = jsonMap['expenses'];
    print(jsonList);
    setState(() {
      for (var item in jsonList) {
        dynamic expdata = json.decode(item);
        items.add(ExpensesList(
            expenseid : expdata['expenseid'],
            name: expdata['name'],
            amount: expdata['amount'],
            notes: expdata['notes']));
      }
    });

  }

  Future<void> loadRemoveExpense(int expenseindex) async
  {
    Directory directory = await getApplicationSupportDirectory();
    String filePath =
        '${directory.path}/moneyheplerdb/' + loginuserName + '.json';
    File file = File(filePath);
    String jsonString = file.readAsStringSync();
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    List<dynamic> expenses = jsonMap['expenses'];

    if (expenseindex >= 0 && expenseindex < expenses.length) {
      expenses.removeAt(expenseindex);
    }
    String updatedJsonString = json.encode(jsonMap);
    file.writeAsStringSync(updatedJsonString);

  }
}
class ExpensesList {
  final String expenseid;
  final String name;
  final String amount;
  final String notes;

  ExpensesList({required this.expenseid,required this.name, required this.amount, required this.notes});

  factory ExpensesList.fromJson(Map<String, dynamic> json) {
    return ExpensesList(
      expenseid : json['expenseid'],
      name: json['name'],
      amount: json['amount'],
      notes: json['notes'],
    );
  }
}
