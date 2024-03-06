import 'package:alakh_car/controller/admin/brand_controller.dart';
import 'package:alakh_car/controller/admin/sub_brand_controller.dart';
import 'package:alakh_car/models/admin/brand.dart';
import 'package:alakh_car/models/admin/subbrand.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SubBrandScreen extends StatefulWidget {
  @override
  _SubBrandScreenState createState() => _SubBrandScreenState();
}

class _SubBrandScreenState extends State<SubBrandScreen> {
  final SubBrandController _subBrandCollection = SubBrandController();
  final BrandController _brandController = BrandController();
  final TextEditingController _subBrandNameController = TextEditingController();
  String? selectedSubBrandId;
  BrandModel? selectedBrand;
  List<BrandModel> _brands = [];
  @override
  void initState() {
    super.initState();
    _loadBrands(); // Call a function to load brands when the screen initializes
  }

  Future<void> _loadBrands() async {
    List<BrandModel> brands = await _brandController.loadBrands();
    setState(() {
      _brands = brands;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sub Brands To List'),
      ),
      body: StreamBuilder<List<SubBrandModel>>(
        stream: _subBrandCollection.getSubBrands(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<SubBrandModel> subbrands = snapshot.data!;

          return ListView.builder(
            itemCount: subbrands.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  shape: const Border(
                      bottom: BorderSide(width: 1, color: Colors.lightBlue)),
                  trailing: const Icon(Icons.edit),
                  title: Text(subbrands[index].name),
                  onTap: () {
                    _showUpdateDeleteDialog(subbrands[index]);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showAddDialog();
            },
            child: const Icon(Icons.add),
          ),
          SizedBox(
            width: 16,
          ),
          // FloatingActionButton.extended(
          //   onPressed: () {
          //     _uploadSubBrands();
          //   },
          //   label: Text("json"),
          //   icon: const Icon(Icons.add),
          // ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog() async {
    _subBrandNameController.text = '';
    selectedBrand = null;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Sub Brand'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButtonFormField<BrandModel>(
                value: selectedBrand,
                items: _brands.map((BrandModel brand) {
                  return DropdownMenuItem<BrandModel>(
                    value: brand,
                    child: Text(brand.name),
                  );
                }).toList(),
                onChanged: (BrandModel? value) {
                  setState(() {
                    selectedBrand = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Brand'),
              ),
              TextField(
                controller: _subBrandNameController,
                decoration: const InputDecoration(labelText: 'SubBrand Name'),
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
              onPressed: () {
                Navigator.of(context).pop();
                _addSubBrand();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUpdateDeleteDialog(SubBrandModel subBrand) async {
    _subBrandNameController.text = subBrand.name;
    selectedBrand = _brands.firstWhere((brand) =>
        brand.name ==
        subBrand
            .mainBrand); // Set the selectedBrand based on the mainBrand of the subBrand

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update or Delete SubBrand'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButtonFormField<BrandModel>(
                value: selectedBrand,
                items: _brands.map((BrandModel brand) {
                  return DropdownMenuItem<BrandModel>(
                    value: brand,
                    child: Text(brand.name),
                  );
                }).toList(),
                onChanged: (BrandModel? value) {
                  setState(() {
                    selectedBrand = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Brand'),
              ),
              TextField(
                controller: _subBrandNameController,
                decoration: const InputDecoration(labelText: 'SubBrand Name'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateSubBrand(subBrand.id);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSubBrand(subBrand.id);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addSubBrand() {
    String id = randomAlphaNumeric(10);
    String subBrandName = _subBrandNameController.text;

    if (selectedBrand != null) {
      String mainBrand = selectedBrand!
          .name; // Adjust this based on your actual BrandModel structure
      SubBrandModel newSubBrand = SubBrandModel(
        id: id,
        name: subBrandName,
        mainBrand: mainBrand,
      );
      _subBrandCollection.addSubBrand(newSubBrand, id);
    }
  }

  Future<void> _updateSubBrand(String id) async {
    SubBrandModel updatedSubBrand = SubBrandModel(
        id: id,
        name: _subBrandNameController.text,
        mainBrand: selectedBrand!.name);
    _subBrandCollection.updateSubBrand(updatedSubBrand, id);
  }

  void _deleteSubBrand(String id) {
    _subBrandCollection.deleteSubBrand(id);
  }

  // Future<void> _uploadSubBrands() async {
  //   // Your JSON data
  //   String jsonData = '''
  //     [
  //   {
  //       "MainBrand": "Tata",
  //       "SubBrandName": "Nexon"
  //   },
  //   {
  //       "MainBrand": "Tata",
  //       "SubBrandName": "Harrier"
  //   },
  //   {
  //       "MainBrand": "Maruti",
  //       "SubBrandName": "Swift"
  //   }
  //   ]
  //   ''';
  //   List<Map<String, dynamic>> subBrandsData =
  //       (json.decode(jsonData) as List<dynamic>).cast<Map<String, dynamic>>();

  //   // List<Map<String, dynamic>> subBrandsData = json.decode(jsonData);

  //   for (Map<String, dynamic> subBrandData in subBrandsData) {
  //     String mainBrand = subBrandData['MainBrand'];
  //     String subBrandName = subBrandData['SubBrandName'];

  //     BrandModel? brand =
  //         _brands.firstWhereOrNull((brand) => brand.name == mainBrand);

  //     if (brand != null) {
  //       String id = randomAlphaNumeric(10);
  //       // Use the brand ID as the ID for sub-brand
  //       SubBrandModel newSubBrand = SubBrandModel(
  //         id: id,
  //         name: subBrandName,
  //         mainBrand: mainBrand,
  //       );

  //       await _subBrandCollection.addSubBrand(newSubBrand, id);
  //     }
  //   }
  //   print('_brands length before loop: ${_brands.length}');
  //   for (Map<String, dynamic> subBrandData in subBrandsData) {
  //     // ...
  //   }
  //   print('_brands length after loop: ${_brands.length}');
  // }
}
