import 'package:alakh_car/controller/admin/sub_brand_controller.dart';
import 'package:alakh_car/models/admin/car.dart';
import 'package:alakh_car/models/admin/subbrand.dart';
import 'package:alakh_car/screens/car_screen.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:alakh_car/controller/admin/car_controller.dart';

class CarModelScreen extends StatefulWidget {
  //final modelDetails model;
  final String brand;

  const CarModelScreen({
    super.key,
    required this.brand,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CarModelScreenState createState() => _CarModelScreenState();
}

class _CarModelScreenState extends State<CarModelScreen> {
  final CarController _carController = CarController();
  SubBrandController _subBrandController = SubBrandController();

  Stream<List<SubBrandModel>> _allSubBrands =
      Stream<List<SubBrandModel>>.empty();
  Stream<List<SubBrandModel>> _filteredSubBrands =
      Stream<List<SubBrandModel>>.empty();

  @override
  void initState() {
    _loadSubBrands();
    super.initState();
  }

  Future<void> _loadSubBrands() async {
    List<SubBrandModel> subbrands =
        await _subBrandController.loadSubBrands(widget.brand);
    setState(() {
      _allSubBrands = Stream.value(subbrands);
      _filteredSubBrands = _allSubBrands;
    });
  }

  void _filterSubBrandsByBrand() {
    _allSubBrands.listen((subBrandList) {
      setState(() {
        _filteredSubBrands = Stream.value(subBrandList
            .where((subBrand) => subBrand.mainBrand == widget.brand)
            .toList());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        iconTheme: const IconThemeData(color: Colors.white),
        // searchBackIconTheme: const IconThemeData(color: Colors.blue),
        title: Text('Search Cars in ${widget.brand}',
            style: const TextStyle(fontSize: 16.0, color: Colors.white)),
        onSearch: (value) {
          setState(() {
            // _filteredData = _apiData
            //     .where((element) =>
            //         element.name!.toLowerCase().contains(value.toLowerCase()))
            //     .toList();
          });
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<SubBrandModel>>(
              stream: _filteredSubBrands,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<List<CarModel>>(
                          stream: _carController
                              .getFiltredCars(snapshot.data![index].name),
                          builder: (context, carsnapshot) {
                            if (carsnapshot.hasError) {
                              return Text('Error: ${carsnapshot.error}');
                            }
                            if (!carsnapshot.hasData) {
                              return const SizedBox();
                            }
                            final totalinsubbrand = carsnapshot.data!.length;
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                InkWell(
                                  onTap: (() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CarScreen(
                                            filterKey:
                                                snapshot.data![index].name),
                                      ),
                                    );
                                  }),
                                  child: Card(
                                    shadowColor: Colors.white,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 4),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data![index].name),
                                          Text(
                                              '(${totalinsubbrand.toString()})')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
