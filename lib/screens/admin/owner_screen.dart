import 'package:alakh_car/controller/admin/owner_controller.dart';
import 'package:alakh_car/models/admin/owner.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class OwnerScreen extends StatefulWidget {
  @override
  _OwnerScreenState createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  final OwnerController _ownerController = OwnerController();
  final TextEditingController _ownerNameController = TextEditingController();
  String? selectedOwnerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Owner To List'),
      ),
      // body: Container(),
      body: StreamBuilder<List<OwnerModel>>(
        stream: _ownerController.getOwners(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<OwnerModel> owners = snapshot.data!;

          return ListView.builder(
            itemCount: owners.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  shape: const Border(
                      bottom: BorderSide(width: 1, color: Colors.lightBlue)),
                  trailing: const Icon(Icons.edit),
                  title: Text(owners[index].name),
                  onTap: () {
                    _showUpdateDeleteDialog(owners[index]);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    _ownerNameController.text = '';

    final focusNode = FocusNode();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Owner'),
          content: TextField(
            controller: _ownerNameController,
            focusNode: focusNode,
            decoration: const InputDecoration(labelText: 'Owners'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_ownerNameController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  _addOwner();
                } else {
                  FocusScope.of(context).requestFocus(focusNode);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUpdateDeleteDialog(OwnerModel owner) async {
    _ownerNameController.text = owner.name;
    selectedOwnerId = owner.id;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update or Delete Owner'),
          content: TextField(
            controller: _ownerNameController,
            decoration: const InputDecoration(labelText: 'Owner Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateOwner();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteOwner();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addOwner() {
    String Id = randomAlphaNumeric(10);
    OwnerModel newOwner = OwnerModel(
      id: Id,
      name: _ownerNameController.text,
    );
    _ownerController.addOwner(newOwner, Id);
  }

  void _updateOwner() {
    if (selectedOwnerId != null) {
      OwnerModel updatedOwner = OwnerModel(
        id: selectedOwnerId!,
        name: _ownerNameController.text,
      );
      _ownerController.updateOwner(updatedOwner, selectedOwnerId);
    }
  }

  void _deleteOwner() {
    if (selectedOwnerId != null) {
      _ownerController.deleteOwner(selectedOwnerId!);
    }
  }
}
