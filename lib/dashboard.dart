
import 'package:flutter/material.dart';
import 'package:moneyhelper/userstate.dart';
import 'package:provider/provider.dart';
import 'addincome.dart';
import 'main.dart';


void main() {
  runApp(MyDashboardPage());
}

class MyDashboardPage extends StatefulWidget {
  @override
  _MyDashboardPageState createState() => _MyDashboardPageState();
}

class _MyDashboardPageState extends State<MyDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AddIncomePage(),
    AddIncomePage(),
    AddIncomePage(),
    AddIncomePage(),

  ];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the argument value when the widget is first built
    final value   = ModalRoute.of(context)?.settings.arguments ;
    if (value != null) {
      _selectedIndex = value as int;

    }

  }

  void _onTabTapped(int index) {
    if (index == 4) {
      Provider.of<UserState>(context, listen: false).setUsername("");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyLoginPage()),
      );
    } else {
      setState(() {


        _selectedIndex = index;
      });
    }


  }

  @override
  Widget build(BuildContext context) {


    // final value = ModalRoute.of(context)?.settings.arguments;
    // if (value != null) {
    //   _selectedIndex = value as int;
    //   ModalRoute.of(context)?.settings?.arguments = null;
    // }
    // else
    //   {
    //     _selectedIndex = 0;
    //   }
    // print("arguments  $value");
    print("_selectedIndex  $_selectedIndex");
    return Scaffold(
      appBar: AppBar(
        title: Text('MoneyHelper'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue, // Set the color for selected item
        unselectedItemColor: Colors.black,
        showSelectedLabels: true, // Ensure labels are shown
        showUnselectedLabels: true, // Ensure labels are shown
        selectedLabelStyle: TextStyle(color: Colors.blue), // Set selected label text color
        unselectedLabelStyle: TextStyle(color: Colors.black),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: 'View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}





