import 'dart:convert';

import 'package:alakh_car/controller/admin/color_controller.dart';
import 'package:alakh_car/models/admin/color.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class ColorScreen extends StatefulWidget {
  @override
  _ColorScreenState createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  final ColorController _colorController = ColorController();
  final TextEditingController _colorNameController = TextEditingController();
  String? selectedColorId;

  // Future<void> _uploadColors() async {
  //   // Your JSON data
  //   String jsonData = '''
  //     [
  //         {
  //             "ColorName": "Lighting Blue"
  //         },
  //         {
  //             "ColorName": "Cherry red"
  //         },
  //         {
  //             "ColorName": "FOLIAG SOSLV"
  //         }
  //     ]
  //   ''';
  //   List<Map<String, dynamic>> colorsData =
  //       (json.decode(jsonData) as List<dynamic>).cast<Map<String, dynamic>>();

  //   // List<Map<String, dynamic>> subBrandsData = json.decode(jsonData);

  //   for (Map<String, dynamic> colorData in colorsData) {
  //     String name = colorData['ColorName'];

  //     String id = randomAlphaNumeric(10);
  //     // Use the brand ID as the ID for sub-brand
  //     ColorModel newColor = ColorModel(
  //       id: id,
  //       name: name,
  //     );

  //     await _colorController.addColor(newColor, id);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Colors To List'),
      ),
      body: StreamBuilder<List<ColorModel>>(
        stream: _colorController.getColors(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<ColorModel> colors = snapshot.data!;

          return ListView.builder(
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showAddDialog();
            },
            child: const Icon(Icons.add),
          ),
          // FloatingActionButton.extended(
          //   onPressed: () {
          //     _uploadColors();
          //   },
          //   label: Text("json"),
          //   icon: const Icon(Icons.add),
          // ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog() async {
    _colorNameController.text = '';
    final focusNode = FocusNode();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Color'),
          content: TextField(
            controller: _colorNameController,
            focusNode: focusNode,
            decoration: const InputDecoration(labelText: 'Color Name'),
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
                if (_colorNameController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  _addColor();
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

  Future<void> _showUpdateDeleteDialog(ColorModel color) async {
    _colorNameController.text = color.name;
    selectedColorId = color.id;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update or Delete Color'),
          content: TextField(
            controller: _colorNameController,
            decoration: const InputDecoration(labelText: 'Color Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateColor();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteColor();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addColor() {
    String Id = randomAlphaNumeric(10);
    ColorModel newColor = ColorModel(
      id: Id,
      name: _colorNameController.text,
    );
    _colorController.addColor(newColor, Id);
  }

  void _updateColor() {
    if (selectedColorId != null) {
      ColorModel updatedColor = ColorModel(
        id: selectedColorId!,
        name: _colorNameController.text,
      );
      _colorController.updateColor(updatedColor, selectedColorId);
    }
  }

  void _deleteColor() {
    if (selectedColorId != null) {
      _colorController.deleteColor(selectedColorId!);
    }
  }
}
