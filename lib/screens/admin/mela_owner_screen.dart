import 'package:alakh_car/models/admin/melaowner.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/mela_owner_controller.dart';
import 'package:random_string/random_string.dart';

class MelaOwnerScreen extends StatefulWidget {
  @override
  _MelaOwnerScreenState createState() => _MelaOwnerScreenState();
}

class _MelaOwnerScreenState extends State<MelaOwnerScreen> {
  final MelaOwnerController _melaOwnerController = MelaOwnerController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? selectedLocation;

  String? selectedMelaOwnerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MelaOwner List'),
      ),
      body: StreamBuilder<List<MelaOwnerModel>>(
        stream: _melaOwnerController.getMelaOwner(),
        builder: (context, AsyncSnapshot<List<MelaOwnerModel>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          List<MelaOwnerModel> melaOwners = snapshot.data!;
          // List<MelaOwnerModel> melaOwners = snapshot.requireData;
          return ListView.builder(
            itemCount: melaOwners.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${melaOwners[index].name}'),
                        Text('Phone: ${melaOwners[index].phone}'),
                        Text('Address: ${melaOwners[index].address}'),
                        Text('Location: ${melaOwners[index].location}'),
                      ],
                    ),
                  ),
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
    _addressController.text = '';
    _nameController.text = '';
    _phoneController.text = '';
    selectedLocation = "A";

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add MelaOwner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              DropdownButtonFormField<String>(
                value: selectedLocation,
                items: [
                  DropdownUtils.buildDropdownItem('A'),
                  DropdownUtils.buildDropdownItem('A1'),
                  DropdownUtils.buildDropdownItem('A2'),
                ],
                onChanged: (String? value) {
                  setState(() {
                    selectedLocation = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Location'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _addMelaOwner();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addMelaOwner() async {
    String id = randomAlphaNumeric(10);
    MelaOwnerModel newMelaOwner = MelaOwnerModel(
      id: id,
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      location: selectedLocation!,
    );

    await _melaOwnerController.addMelaOwner(newMelaOwner, id);
  }
}

class DropdownUtils {
  static DropdownMenuItem<String> buildDropdownItem(String text) {
    return DropdownMenuItem<String>(
      value: text,
      child: Text(text),
    );
  }
}
