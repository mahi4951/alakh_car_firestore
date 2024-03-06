import 'package:alakh_car/car_images_page.dart';
import 'package:alakh_car/models/admin/car.dart';
import 'package:alakh_car/car_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/car_controller.dart';

class CarScreen extends StatefulWidget {
  final String filterKey;
  CarScreen({super.key, required this.filterKey});
  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  final CarController _carController = CarController();
  late List<CarModel> _filteredData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(15, 103, 180, 1),
        title: const Text(
          "Cars",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onSearch: (value) async {},
      ),
      body: StreamBuilder<List<CarModel>>(
        stream: _carController.getFiltredCars(widget.filterKey),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          List<CarModel> cars = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: cars.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailPage(
                            id: cars[index].id,
                            title: cars[index].name,
                            imageUrls: cars[index].imagesUrls!,
                          ),
                        ),
                      );
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(13),
                                  //   border: Border.all(
                                  //     color: Color.fromRGBO(0, 0, 0, 0.1),
                                  //   ),
                                  // ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(13),
                                    child: SizedBox(
                                      height: 105,
                                      width: 150,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            cars[index].imagesUrls!.isNotEmpty
                                                ? cars[index].imagesUrls![0]
                                                : '',
                                        maxHeightDiskCache: 330,
                                        maxWidthDiskCache: 540,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: Icon(
                                            Icons.car_crash_sharp,
                                            size: 80,
                                            fill: 1.0,
                                            color: Colors.black38,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: (() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CarImagesPage(
                                                  id: cars[index].id,
                                                  title: cars[index].name,
                                                ),
                                              ),
                                            );
                                          }),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  15, 103, 180, 1),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              // border: Border.all(
                                              //   color: const Color.fromRGBO(
                                              //       0, 0, 0, 0.1),
                                              // ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Icon(
                                                Icons.share,
                                                size: 16,
                                                color: Colors
                                                    .white, // Change the color as per your requirement
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cars[index].name,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                                height: 1,
                                                color: Color.fromRGBO(
                                                    51, 51, 51, 1)),
                                          ),

                                          Row(
                                            children: [
                                              // const Icon(
                                              //   Icons.pin_outlined,
                                              //   size: 16,
                                              //   color: Color.fromRGBO(
                                              //       51,
                                              //       51,
                                              //       51,
                                              //       1), // Change the color as per your requirement
                                              // ),
                                              // const SizedBox(
                                              //     width:
                                              //         7), // Add some space between icon and text
                                              Text(
                                                cars[index].regNo!,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        153, 153, 153, 1)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 05,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.currency_rupee,
                                                size: 16,
                                                color: Color.fromRGBO(
                                                    15,
                                                    103,
                                                    180,
                                                    1), // Change the color as per your requirement
                                              ),
                                              const SizedBox(
                                                  width:
                                                      7), // Add some space between icon and text
                                              Text(
                                                cars[index].carPrice!,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromRGBO(
                                                        15, 103, 180, 1)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                size: 16,
                                                color: Color.fromRGBO(
                                                    51,
                                                    51,
                                                    51,
                                                    1), // Change the color as per your requirement
                                              ),
                                              const SizedBox(
                                                  width:
                                                      7), // Add some space between icon and text
                                              Text(
                                                cars[index].year!,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        51, 51, 51, 1)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.speed,
                                                size: 16,
                                                color: Color.fromRGBO(
                                                    51,
                                                    51,
                                                    51,
                                                    1), // Change the color as per your requirement
                                              ),
                                              const SizedBox(
                                                  width:
                                                      7), // Add some space between icon and text
                                              Text(
                                                cars[index].km!,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        51, 51, 51, 1)),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 5,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.local_gas_station,
                                        size: 20,
                                        color: Color.fromRGBO(153, 153, 153,
                                            1), // Change the color as per your requirement
                                      ),
                                      const SizedBox(
                                          width:
                                              4), // Add some space between icon and text
                                      Text(
                                        cars[index].fuelName!,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                153, 153, 153, 1)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 7.0,
                                        width: 7.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                217, 217, 217, 1),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.group,
                                        size: 20,
                                        color: Color.fromRGBO(153, 153, 153,
                                            1), // Change the color as per your requirement
                                      ),
                                      const SizedBox(
                                          width:
                                              4), // Add some space between icon and text
                                      Text(
                                        '${cars[index].owners!} Owner',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                153, 153, 153, 1)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 7.0,
                                        width: 7.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                217, 217, 217, 1),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.description,
                                        size: 20,
                                        color: Color.fromRGBO(153, 153, 153,
                                            1), // Change the color as per your requirement
                                      ),
                                      const SizedBox(
                                          width:
                                              4), // Add some space between icon and text
                                      Text(
                                        'Policy ${cars[index].insurance!}',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                153, 153, 153, 1)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  //border: Border.all(width: 1.0)),
                                  border: Border.all(
                                      width: 0.5,
                                      color: const Color.fromRGBO(
                                          217, 217, 217, 1))),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width),
                            ),
                          ]),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
