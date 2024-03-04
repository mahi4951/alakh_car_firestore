import 'package:alakh_car/controller/admin/fuel_controller.dart';
import 'package:alakh_car/models/admin/fuel.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class FuelScreen extends StatefulWidget {
  @override
  _FuelScreenState createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  final FuelController _fualController = FuelController();
  final TextEditingController _fuelNameController = TextEditingController();
  String? selectedFuelId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fuel To List'),
      ),
      // body: Container(),
      body: StreamBuilder<List<FuelModel>>(
        stream: _fualController.getFuels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<FuelModel> colors = snapshot.data!;

          return ListView.builder(
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  shape: const Border(
                      bottom: BorderSide(width: 1, color: Colors.lightBlue)),
                  trailing: const Icon(Icons.edit),
                  title: Text(colors[index].name),
                  onTap: () {
                    _showUpdateDeleteDialog(colors[index]);
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
    _fuelNameController.text = '';
    final focusNode = FocusNode();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Fuel'),
          content: TextField(
            controller: _fuelNameController,
            focusNode: focusNode,
            decoration: const InputDecoration(labelText: 'Fuel Name'),
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
                if (_fuelNameController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  _addFuel();
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

  Future<void> _showUpdateDeleteDialog(FuelModel color) async {
    _fuelNameController.text = color.name;
    selectedFuelId = color.id;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update or Delete Fuel'),
          content: TextField(
            controller: _fuelNameController,
            decoration: const InputDecoration(labelText: 'Fuel Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateFuel();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFuel();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addFuel() {
    String Id = randomAlphaNumeric(10);
    FuelModel newFuel = FuelModel(
      id: Id,
      name: _fuelNameController.text,
    );
    _fualController.addFuel(newFuel, Id);
  }

  void _updateFuel() {
    if (selectedFuelId != null) {
      FuelModel updatedFuel = FuelModel(
        id: selectedFuelId!,
        name: _fuelNameController.text,
      );
      _fualController.updateFuel(updatedFuel, selectedFuelId);
    }
  }

  void _deleteFuel() {
    if (selectedFuelId != null) {
      _fualController.deleteFuel(selectedFuelId!);
    }
  }
}
