import 'package:alakh_car/screens/admin/admin_screen.dart';
import 'package:alakh_car/screens/admin/car_screen_json.dart';
import 'package:alakh_car/screens/login.dart';
import 'package:alakh_car/screens/logout.dart';

import 'package:alakh_car/screens/home.dart';

import 'package:alakh_car/screens/registar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({
    Key? key, // Add this line to declare key
  }) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  late String? _email = "";
  late String? _displayName = "";
  late String? _avatarUrl = "";
  bool isLoggedIn = false;
  late String _role;
  bool _mounted = false; // Add this variable

  @override
  void initState() {
    super.initState();
    _email = "";
    _displayName = "";
    _avatarUrl = "";
    _role = "";
    _mounted = true; // Set _mounted to true in initState
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _mounted = false; // Set _mounted to false in dispose
    super.dispose();
  }

  _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    setState(() {
      isLoggedIn = user != null;
    });

    // If the user is logged in, fetch and set user information
    if (isLoggedIn) {
      await _getUserInfo(user!);
      await _getUserRole(user.uid);
    }
  }

  _getUserRole(String userId) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
    if (_mounted) {
      // Check if the widget is still mounted
      if (userSnapshot.exists) {
        _role = userSnapshot.get('role');
        _displayName = userSnapshot.get('displayName');
        print(_role);
        print(_displayName);
        setState(() {
          _role = _role;
        });
      } else {
        _role = '';
        setState(() {});
      }
    }
  }

  _getUserInfo(User user) async {
    setState(() {
      _email = user.email ?? "Guest";
      _displayName = user.displayName ?? "";
      // Firebase doesn't provide a last name by default
    });
    print(user);

    // Fetch and set user's avatar URL
    await _getAvatarUrl(user.uid);
  }

  Future<void> _getAvatarUrl(String userId) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
    if (userSnapshot.exists) {
      // Get the 'avatarUrl' field from the document data
      _avatarUrl = userSnapshot.get('avatarUrl');

      setState(() {
        _avatarUrl =
            _avatarUrl; // Replace 'newValue' with the actual value you want to assign
      });
    } else {
      // Handle the case where the user document does not exist
      print('User document not found for ID: $userId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child:
                      _displayName != '' ? Text(_displayName!) : const Text(""),
                ),
              ],
            ),
            accountEmail: _email != '' ? Text(_email!) : const Text(""),
            currentAccountPicture: _avatarUrl!.isEmpty
                ? const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://alakhcar.com/uploads/e775345aefb653589bcfdf85773749dc64068/1678523969640c3e412d0ec4-14758829_Group_66(4).png'),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(_avatarUrl!),
                  ),
          ),
          // Other Drawer items
          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
          ),

          ListTile(
            title: const Text("Json"),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => JsonCarScreen()));
            },
          ),
          ListTile(
            title: const Text("Sign Up"),
            leading: const Icon(Icons.contact_phone),
            onTap: () {
              Navigator.of(context).pop();

              if (!isLoggedIn) {
                // Only navigate to SignUpPage if the user is not logged in
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Registar()));
              } else {
                // You can provide a message or handle it in any way you prefer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You are already logged in!'),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: isLoggedIn ? const Text('Logout') : const Text("Login"),
            leading: const Icon(Icons.lock_open_sharp),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          isLoggedIn ? const LogoutPage() : const LoginPage()));
            },
          ),

          ListTile(
            title: _role == 'Admin' ? const Text('Admin') : null,
            leading: _role == 'Admin'
                ? const Icon(Icons.admin_panel_settings)
                : null,
            onTap: () {
              Navigator.of(context).pop();
              if (_role == 'Admin') {
                // Only navigate to Admin page if the user has the role 'Dealer'
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminPage()));
              } else {
                // You can provide a message or handle it in any way you prefer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'You do not have permission to access Admin page!'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
