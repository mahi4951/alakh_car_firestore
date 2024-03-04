// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:alakh_car/controller/admin/banner_controller.dart';
import 'package:alakh_car/controller/admin/brand_controller.dart';
import 'package:alakh_car/controller/admin/car_controller.dart';
import 'package:alakh_car/controller/admin/fuel_controller.dart';
import 'package:alakh_car/controller/admin/mela_owner_controller.dart';
import 'package:alakh_car/controller/admin/social_controller.dart';
import 'package:alakh_car/models/admin/banner.dart';
import 'package:alakh_car/models/admin/brand.dart';
import 'package:alakh_car/models/admin/car.dart';
import 'package:alakh_car/models/admin/fuel.dart';
import 'package:alakh_car/models/admin/melaowner.dart';
import 'package:alakh_car/models/admin/social.dart';
import 'package:alakh_car/screens/car_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../car_detail_page.dart';
import '../car_model_screen.dart';
import '../side_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = false;
  final BannerController _bannerController = BannerController();
  final BrandController _brandController = BrandController();
  final CarController _carController = CarController();
  final FuelController _fuelController = FuelController();
  final SocialController _socialController = SocialController();
  final MelaOwnerController _melaOwnerController = MelaOwnerController();
  FocusNode focusNode = FocusNode();
  List<CarModel> _allCarData = [];
  List<BannerModel> _bannerData = [];
  List<SocialModel> _socialData = [];
  List<MelaOwnerModel> _melaOwnerData = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showSuggestions = false;
  @override
  void initState() {
    super.initState();
    getBanners();
    getDatacar();
    getSocial();
    getMeleOwner();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading =
          true; // Set isLoading to true to indicate data loading is in progress
    });

    // Simulate data loading delay
    await Future.delayed(
        const Duration(seconds: 1)); // For example, a 1-second delay

    // Retrieve banners
    await getBanners();

    // Set isLoading to false to indicate data loading is complete
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getBanners() async {
    _bannerController.getBanners().listen((banners) {
      setState(() {
        _bannerData = banners;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDatacar() async {
    _carController.getCars().listen((cars) {
      setState(() {
        _allCarData = cars;
      });
    });
  }

  void getSocial() async {
    _socialController.getSocials().listen((social) {
      setState(() {
        _socialData = social;
      });
    });
  }

  void getMeleOwner() async {
    _melaOwnerController.getMelaOwner().listen((melaowner) {
      setState(() {
        _melaOwnerData = melaowner;
      });
    });
  }

  String callNo = '';
  String socialLink = '';
  String wNo = '';
  Future<void> _launchUrl(callNo) async {
    if (!await launch('tel:+91$callNo')) {
      throw Exception('Could not launch $callNo');
    }
  }

  Future<void> _whatsappUrl(wNo) async {
    if (!await launch('https://wa.me/+91$wNo')) {
      throw Exception('Could not launch $wNo');
    }
  }

  Future<void> _socialLink(socialLink) async {
    if (!await launch(socialLink)) {
      throw Exception('Could not launch $socialLink');
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
    });
    getBanners();
    // getDatacar();
    setState(() {
      _loading = false;
    });
  }

  void navigateToCarDetail(CarModel selectedCar) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarDetailPage(
          id: selectedCar.id.toString(),
          title:
              '${selectedCar.name.toString()}, ${selectedCar.regNo.toString()}',
          imageUrls: selectedCar.imagesUrls!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String appCastURL = 'https://alakhcar.com/api/testappcast.xml';
    final cfg =
        AppcastConfiguration(url: appCastURL, supportedOS: ['android', 'ios']);

    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          // appBarHeight: 170,
          // isFloating: false,
          leading: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Center(
                child: Image.asset(
                  'assets/images/menu.png',
                  height: 21.92,
                  width: 31,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              )),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(15, 103, 180, 1),
          title: const Text(
            "Wellcoms to Alakhcar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            SizedBox(
              height: 45,
              width: 45,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  // borderRadius:
                ),
                child: IconButton(
                  onPressed: () {
                    // Add your onPressed logic for the call icon here
                  },
                  icon: const Icon(Icons.people_alt_outlined),
                  color: const Color.fromRGBO(15, 103, 180, 1),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        drawer: const SideDrawer(),
        body: UpgradeAlert(
          upgrader: Upgrader(
            appcastConfig: cfg,
            dialogStyle: UpgradeDialogStyle.material,
            canDismissDialog: true,
            shouldPopScope: () => true,
          ),
          child: Stack(children: [
            GestureDetector(
              onTap: () {
                // Tapped inside the search TextFormField, keep showSuggestions true
                setState(() {
                  showSuggestions = false;
                });
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                color: const Color.fromRGBO(15, 103, 180, 1),
                              ),
                            ],
                          ),
                          Stack(children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              color: const Color.fromRGBO(15, 103, 180, 1),
                            ),
                            CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 16 / 6.55,
                                viewportFraction: 0.92,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 4),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                pageSnapping: true,
                                scrollDirection: Axis.horizontal,
                                pauseAutoPlayOnTouch: true,
                                pauseAutoPlayOnManualNavigate: true,
                                pauseAutoPlayInFiniteScroll: false,
                                enlargeFactor: 0.5,
                                enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                                // disableCenter: true,
                              ),
                              items: _bannerData.map((banner) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5),
                                      child: ClipRRect(
                                        // ClipRRect to apply border radius
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: banner.imageUrl ?? '',
                                          maxWidthDiskCache: 480,
                                          maxHeightDiskCache: 202,
                                          filterQuality: FilterQuality.low,
                                          placeholder: (context, url) =>
                                              FadeInImage(
                                            placeholder: const AssetImage(
                                                'assets/images/placeholder_image.jpg'), // Placeholder image
                                            image: NetworkImage(
                                                banner.imageUrl ??
                                                    ''), // Actual image
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            //   StreamBuilder<List<BannerModel>>(
                            //     stream: _bannerController.getBanners(),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.hasError) {
                            //         return Text('Error: ${snapshot.error}');
                            //       }
                            //       if (!snapshot.hasData) {
                            //         return const Center(
                            //             child: SizedBox(
                            //                 height: 40,
                            //                 width: 40,
                            //                 child:
                            //                     CircularProgressIndicator()));
                            //       }
                            //       List<BannerModel> banners = _bannerData;
                            //       return CarouselSlider(
                            //         options: CarouselOptions(
                            //           aspectRatio: 16 / 6.55,
                            //           viewportFraction: 0.92,
                            //           initialPage: 0,
                            //           enableInfiniteScroll: true,
                            //           reverse: false,
                            //           autoPlay: true,
                            //           autoPlayInterval:
                            //               const Duration(seconds: 4),
                            //           autoPlayAnimationDuration:
                            //               const Duration(milliseconds: 800),
                            //           autoPlayCurve: Curves.fastOutSlowIn,
                            //           enlargeCenterPage: true,
                            //           pageSnapping: true,
                            //           scrollDirection: Axis.horizontal,
                            //           pauseAutoPlayOnTouch: true,
                            //           pauseAutoPlayOnManualNavigate: true,
                            //           pauseAutoPlayInFiniteScroll: false,
                            //           enlargeFactor: 0.5,
                            //           enlargeStrategy:
                            //               CenterPageEnlargeStrategy.zoom,
                            //           // disableCenter: true,
                            //         ),
                            //         items: banners.map((banner) {
                            //           return Builder(
                            //             builder: (BuildContext context) {
                            //               return Container(
                            //                 margin:
                            //                     const EdgeInsets.symmetric(
                            //                         vertical: 5.0,
                            //                         horizontal: 5),
                            //                 child: ClipRRect(
                            //                   // ClipRRect to apply border radius
                            //                   borderRadius:
                            //                       BorderRadius.circular(20),
                            //                   child: CachedNetworkImage(
                            //                     imageUrl:
                            //                         banner.imageUrl ?? '',
                            //                     maxWidthDiskCache: 780,
                            //                     maxHeightDiskCache: 329,
                            //                     filterQuality:
                            //                         FilterQuality.low,
                            //                     placeholder:
                            //                         (context, url) =>
                            //                             const Center(
                            //                       child: SizedBox(
                            //                         height: 20,
                            //                         width: 20,
                            //                         child:
                            //                             CircularProgressIndicator(),
                            //                       ),
                            //                     ),
                            //                     errorWidget: (context, url,
                            //                             error) =>
                            //                         const Icon(Icons.error),
                            //                   ),
                            //                 ),
                            //               );
                            //             },
                            //           );
                            //         }).toList(),
                            //       );
                            //     },
                            //   ),
                            //
                          ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: const Color.fromRGBO(16, 103, 180, 0.1),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      "Transmission Type",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Color.fromRGBO(51, 51, 51, 1),
                                            letterSpacing: .5),
                                      ),
                                    ),
                                  ),
                                  GridView.count(
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.all(10),
                                    crossAxisSpacing: 10,
                                    crossAxisCount: 4,
                                    childAspectRatio: 1,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CarScreen(
                                                filterKey: 'Ready',
                                              ),
                                            ),
                                          );
                                        },
                                        child: StreamBuilder<List<CarModel>>(
                                          stream: _carController
                                              .getFiltredCars('Ready'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final allcars = snapshot.data!
                                                  .where((car) =>
                                                      car.status == 'Ready')
                                                  .toList();
                                              final totalCars = allcars.length;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,

                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // borderRadius:
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 6.0),
                                                      child: Image.asset(
                                                          'assets/images/all.png'),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        'All ($totalCars)',
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    153,
                                                                    153,
                                                                    153,
                                                                    1),
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  'Failed to load Cars');
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CarScreen(
                                                filterKey: 'Auto',
                                              ),
                                            ),
                                          );
                                        },
                                        child: StreamBuilder<List<CarModel>>(
                                          stream: _carController
                                              .getFiltredCars("Auto"),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final autoCars =
                                                  snapshot.data!.toList();
                                              final totalAutoCars =
                                                  autoCars.length;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,

                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // borderRadius:
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 6.0),
                                                      child: Image.asset(
                                                          'assets/images/auto.png'),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        'Auto ($totalAutoCars)',
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    153,
                                                                    153,
                                                                    153,
                                                                    1),
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  'Failed to load Cars');
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CarScreen(
                                                filterKey: 'Manual',
                                              ),
                                            ),
                                          );
                                        },
                                        child: StreamBuilder<List<CarModel>>(
                                          stream: _carController
                                              .getFiltredCars('Manual'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final statsCars =
                                                  snapshot.data!.toList();
                                              final totalManualCars =
                                                  statsCars.length;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,

                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // borderRadius:
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 6.0),
                                                      child: Image.asset(
                                                          'assets/images/manual.png'),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        'Manual ($totalManualCars)',
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    153,
                                                                    153,
                                                                    153,
                                                                    1),
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  'Failed to load Cars');
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CarScreen(
                                                filterKey: 'Coming Soon',
                                              ),
                                            ),
                                          );
                                        },
                                        child: StreamBuilder<List<CarModel>>(
                                          stream: _carController
                                              .getFiltredCars('Coming Soon'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final statsCars =
                                                  snapshot.data!.toList();
                                              final totalStatusCars =
                                                  statsCars.length;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,

                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // borderRadius:
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 6.0),
                                                      child: Image.asset(
                                                          'assets/images/soon.png'),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        'Coming Soon ($totalStatusCars)',
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    153,
                                                                    153,
                                                                    153,
                                                                    1),
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  'Failed to load Cars');
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: FutureBuilder<List<FuelModel>>(
                                      future: _fuelController.loadFuels(),
                                      builder: (context, fuelSnapshot) {
                                        if (fuelSnapshot.hasData) {
                                          return GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 4 / 1.5,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              crossAxisCount: 4,
                                            ),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                fuelSnapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              final fuel =
                                                  fuelSnapshot.data![index];
                                              return FutureBuilder<
                                                      List<CarModel>>(
                                                  future: _carController
                                                      .getFeaturedFilteredCars(
                                                          fuel.name),
                                                  builder:
                                                      (context, carSnapshot) {
                                                    if (carSnapshot.hasError) {
                                                      return Text(
                                                          '${carSnapshot.error}');
                                                    } else if (!carSnapshot
                                                        .hasData) {
                                                      return const Text(
                                                          "No cars available");
                                                    }

                                                    final totalCarsInFuel =
                                                        carSnapshot
                                                            .data!.length;
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    CarScreen(
                                                              filterKey:
                                                                  fuel.name,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 2,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromRGBO(
                                                              207, 225, 240, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                              color: const Color
                                                                  .fromRGBO(148,
                                                                  195, 235, 1)),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      fuel.name,
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              15,
                                                                              103,
                                                                              180,
                                                                              1),
                                                                          fontSize:
                                                                              12.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      " ($totalCarsInFuel)",
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              15,
                                                                              103,
                                                                              180,
                                                                              1),
                                                                          fontSize:
                                                                              12.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                          );
                                        } else if (fuelSnapshot.hasError) {
                                          return Text(
                                              'Failed to load Fuels: ${fuelSnapshot.error}');
                                        } else {
                                          return const Center(
                                            child:
                                                Text('Failed to load Fuels: '),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "Latest Cars",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                    letterSpacing: .5),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 165,
                            // height: MediaQuery.of(context).size.height * 0.25,
                            child: StreamBuilder<List<CarModel>>(
                                stream: _carController.getCars(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  List<CarModel> cars = snapshot.data!;
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: cars.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: InkWell(
                                            onTap: (() {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CarDetailPage(
                                                    id: cars[index].id,
                                                    title: cars[index].name,
                                                    imageUrls:
                                                        cars[index].imagesUrls!,
                                                  ),
                                                ),
                                              );
                                            }),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 110,
                                                      width: 180,
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              16,
                                                              103,
                                                              180,
                                                              0.1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          13)),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(13),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: cars[
                                                                        index]
                                                                    .imagesUrls!
                                                                    .isNotEmpty
                                                                ? cars[index]
                                                                    .imagesUrls![0]
                                                                : '',
                                                            maxHeightDiskCache:
                                                                330,
                                                            maxWidthDiskCache:
                                                                540,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    const Center(
                                                              child: Icon(
                                                                Icons
                                                                    .car_crash_sharp,
                                                                size: 80,
                                                                fill: 1.0,
                                                                color: Colors
                                                                    .black38,
                                                              ),
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '${cars[index].name.toString()}, ${cars[index].year.toString()}',
                                                      style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                                height: 1.2,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        51,
                                                                        51,
                                                                        51,
                                                                        1),
                                                                letterSpacing:
                                                                    .5),
                                                      ),
                                                    ),
                                                    Text(
                                                      '₹ ${cars[index].carPrice.toString()}',
                                                      style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        51,
                                                                        51,
                                                                        51,
                                                                        1),
                                                                letterSpacing:
                                                                    .5),
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        );
                                      });
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: InkWell(
                              onTap: (() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CarScreen(filterKey: "Ready"),
                                  ),
                                );
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(207, 225, 240, 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: Text('View All Cars'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "Popular Brands",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                    letterSpacing: .5),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: FutureBuilder(
                              future: _brandController.loadBrands(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && !_loading) {
                                  return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1 / 1.35,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      crossAxisCount:
                                          Orientation.portrait == orientation
                                              ? 4
                                              : 6,
                                    ),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final itemlist = snapshot.data![index];
                                      BrandModel brand = snapshot.data![index];
                                      String imageUrl = brand.imageUrl ?? '';

                                      if (snapshot.hasData && !_loading) {
                                        return FutureBuilder<List<CarModel>>(
                                          future: _carController
                                              .getFeaturedFilteredCars(
                                                  brand.name),
                                          builder: (context, carSnapshot) {
                                            if (carSnapshot.hasError) {
                                              return Text(
                                                  '${carSnapshot.error}');
                                            } else if (!carSnapshot.hasData) {
                                              return const Text(
                                                  "No cars available");
                                            }

                                            final totalCarsInBrand =
                                                carSnapshot.data!.length;

                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CarModelScreen(
                                                      brand: brand.name,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 80,
                                                    width: 80,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromRGBO(
                                                            207, 225, 240, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: const Color
                                                              .fromRGBO(
                                                              148, 195, 235, 1),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: imageUrl,
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Icon(Icons
                                                                  .car_repair_sharp),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${itemlist.name.toString()} ($totalCarsInBrand)',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 11.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Text(
                              "Cars By Budget",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                    letterSpacing: .5),
                              ),
                            ),
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            primary: false,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            crossAxisSpacing: 10,
                            crossAxisCount: 3,
                            childAspectRatio: 3 / 1,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarScreen(
                                        filterKey: '200000',
                                      ),
                                    ),
                                  );
                                },
                                child: StreamBuilder<List<CarModel>>(
                                  stream:
                                      _carController.getFiltredCars('200000'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final allCars = snapshot.data!
                                          .where((car) =>
                                              (int.tryParse(car.carPrice
                                                          ?.replaceAll(
                                                              ',', '') ??
                                                      '0') ??
                                                  0) <
                                              200000)
                                          .toList();
                                      final totalCars = allCars.length;
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              207, 225, 240, 1),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                148, 195, 235, 1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),

                                          // borderRadius:
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Up to 2lakh ($totalCars)',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    15, 103, 180, 1),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text('Failed to load Cars');
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarScreen(
                                        filterKey: '200001',
                                      ),
                                    ),
                                  );
                                },
                                child: StreamBuilder<List<CarModel>>(
                                  stream:
                                      _carController.getFiltredCars('200001'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final allCars = snapshot.data!
                                          .where((car) =>
                                              (int.tryParse(car.carPrice
                                                              ?.replaceAll(
                                                                  ',', '') ??
                                                          '0') ??
                                                      0) <
                                                  300001 &&
                                              (int.tryParse(car.carPrice
                                                              ?.replaceAll(
                                                                  ',', '') ??
                                                          '0') ??
                                                      0) >
                                                  200000)
                                          .toList();
                                      final totalCars = allCars.length;
                                      return SizedBox(
                                        height: 20,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 8),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                207, 225, 240, 1),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  148, 195, 235, 1),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            // borderRadius:
                                          ),
                                          child: Center(
                                            child: Text(
                                              '2lakh to 3lakh ($totalCars)',
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      15, 103, 180, 1),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text('Failed to load Cars');
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarScreen(
                                        filterKey: '300001',
                                      ),
                                    ),
                                  );
                                },
                                child: StreamBuilder<List<CarModel>>(
                                  stream:
                                      _carController.getFiltredCars("300001"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final allCars = snapshot.data!
                                          .where((car) =>
                                              (int.tryParse(car.carPrice
                                                              ?.replaceAll(
                                                                  ',', '') ??
                                                          '0') ??
                                                      0) <
                                                  400001 &&
                                              (int.tryParse(car.carPrice
                                                              ?.replaceAll(
                                                                  ',', '') ??
                                                          '0') ??
                                                      0) >
                                                  300001)
                                          .toList();
                                      final totalCars = allCars.length;
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              207, 225, 240, 1),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                148, 195, 235, 1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // borderRadius:
                                        ),
                                        child: Center(
                                          child: Text(
                                            '3lakh to 4lakh ($totalCars)',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    15, 103, 180, 1),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text('Failed to load Cars');
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarScreen(
                                        filterKey: '400001',
                                      ),
                                    ),
                                  );
                                },
                                child: StreamBuilder<List<CarModel>>(
                                  stream:
                                      _carController.getFiltredCars("400001"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final allCars = snapshot.data!
                                          .where((car) =>
                                              (int.tryParse(car.carPrice
                                                          ?.replaceAll(
                                                              ',', '') ??
                                                      '0') ??
                                                  0) >
                                              400001)
                                          .toList();
                                      final totalCars = allCars.length;
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              207, 225, 240, 1),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                148, 195, 235, 1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // borderRadius:
                                        ),
                                        child: Center(
                                          child: Text(
                                            '4lakh to Above ($totalCars)',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    15, 103, 180, 1),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text('Failed to load Cars');
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: FutureBuilder<List<FuelModel>>(
                          //     future: _fuelController.loadFuels(),
                          //     builder: (context, fuelSnapshot) {
                          //       if (fuelSnapshot.hasData) {
                          //         return GridView.builder(
                          //           gridDelegate:
                          //               const SliverGridDelegateWithFixedCrossAxisCount(
                          //             childAspectRatio: 4 / 1,
                          //             mainAxisSpacing: 10,
                          //             crossAxisSpacing: 10,
                          //             crossAxisCount: 3,
                          //           ),
                          //           physics: const NeverScrollableScrollPhysics(),
                          //           shrinkWrap: true,
                          //           itemCount: fuelSnapshot.data!.length,
                          //           itemBuilder: (context, index) {
                          //             final fuel = fuelSnapshot.data![index];
                          //             return StreamBuilder<List<CarModel>>(
                          //                 stream: _carController
                          //                     .getFiltredCars(fuel.name),
                          //                 builder: (context, carSnapshot) {
                          //                   if (carSnapshot.connectionState ==
                          //                       ConnectionState.waiting) {
                          //                     return const Icon(
                          //                         Icons.propane_tank);
                          //                   } else if (carSnapshot.hasError) {
                          //                     return Text('${carSnapshot.error}');
                          //                   } else if (!carSnapshot.hasData) {
                          //                     return const Text(
                          //                         "No cars available");
                          //                   }

                          //                   final totalCarsInFuel =
                          //                       carSnapshot.data!.length;
                          //                   return InkWell(
                          //                     onTap: () {
                          //                       Navigator.push(
                          //                         context,
                          //                         MaterialPageRoute(
                          //                           builder: (context) =>
                          //                               CarScreen(
                          //                             filterKey: fuel.name,
                          //                           ),
                          //                         ),
                          //                       );
                          //                     },
                          //                     child: Container(
                          //                       padding:
                          //                           const EdgeInsets.symmetric(
                          //                         vertical: 3,
                          //                       ),
                          //                       decoration: BoxDecoration(
                          //                         color: const Color.fromRGBO(
                          //                             207, 225, 240, 1),
                          //                         borderRadius:
                          //                             BorderRadius.circular(15),
                          //                         border: Border.all(
                          //                             color: const Color.fromRGBO(
                          //                                 148, 195, 235, 1)),
                          //                       ),
                          //                       child: Column(
                          //                         children: [
                          //                           Center(
                          //                             child: Row(
                          //                               crossAxisAlignment:
                          //                                   CrossAxisAlignment
                          //                                       .center,
                          //                               mainAxisAlignment:
                          //                                   MainAxisAlignment
                          //                                       .center,
                          //                               children: [
                          //                                 Text(
                          //                                   fuel.name,
                          //                                   style: GoogleFonts
                          //                                       .roboto(
                          //                                     textStyle:
                          //                                         const TextStyle(
                          //                                       color: Color
                          //                                           .fromRGBO(
                          //                                               15,
                          //                                               103,
                          //                                               180,
                          //                                               1),
                          //                                       fontSize: 12.0,
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                                 Text(
                          //                                   " ($totalCarsInFuel)",
                          //                                   style: GoogleFonts
                          //                                       .roboto(
                          //                                     textStyle:
                          //                                         const TextStyle(
                          //                                       color: Color
                          //                                           .fromRGBO(
                          //                                               15,
                          //                                               103,
                          //                                               180,
                          //                                               1),
                          //                                       fontSize: 12.0,
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               ],
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   );
                          //                 });
                          //           },
                          //         );
                          //       } else if (fuelSnapshot.hasError) {
                          //         return Text(
                          //             'Failed to load Fuels: ${fuelSnapshot.error}');
                          //       } else {
                          //         return const Center(
                          //           child: Text('Failed to load Fuels: '),
                          //         );
                          //       }
                          //     },
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(15, 103, 180, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: GestureDetector(
                      onTap: () {
                        // Tapped inside the search TextFormField, keep showSuggestions true
                        setState(() {
                          showSuggestions = true;
                        });
                      },
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _searchController,
                        onTap: () {
                          setState(() {
                            showSuggestions = true;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            showSuggestions = true;
                          });
                          // Filter suggestions based on the entered value
                          // You can use this to update the suggestions list dynamically
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5),
                          hintText: 'Search your car',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color.fromRGBO(15, 103, 180, 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(15, 103, 180, 1),
                            ), // Border color when focused
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors
                                    .transparent), // Transparent border color when not focused
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                height: 204,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color:
                            Color.fromRGBO(0, 0, 0, 0.1), // Color of the shadow
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Changes position of shadow
                      ),
                    ],
                  ),
                  child: showSuggestions
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: _allCarData.length,
                          itemBuilder: (context, index) {
                            final car = _allCarData[index];

                            // Filter the car based on the search box text
                            final searchText = _searchController.text
                                .toLowerCase(); // Assuming _searchController is the TextEditingController for the search box
                            final isMatched = car.name
                                    .toLowerCase()
                                    .contains(searchText) ||
                                car.regNo!.toLowerCase().contains(searchText);

                            // Display the car only if it matches the search box text
                            if (isMatched) {
                              return InkWell(
                                onTap: () {
                                  _searchController.text =
                                      '${car.name}, ${car.regNo}';

                                  final selectedCar =
                                      _allCarData.firstWhere((element) {
                                    return element.name.toString().trim() ==
                                            car.name &&
                                        element.regNo.toString().trim() ==
                                            car.regNo;
                                  });
                                  navigateToCarDetail(selectedCar);
                                  setState(() {
                                    showSuggestions = false;
                                  });
                                  _searchController.text = '';
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 8),
                                      child: Text(
                                        '${car.name}, ${car.regNo}',
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox
                                  .shrink(); // If the car doesn't match the search box text, return an empty SizedBox to hide it
                            }
                          },
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ]),
        ),
        bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(15, 103, 180, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    child: GestureDetector(
                      onTap: () {
                        socialLink =
                            _socialData.elementAt(0).facebookUrl.toString();
                        _socialLink(socialLink);
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.squareFacebook,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    child: GestureDetector(
                      onTap: () {
                        socialLink =
                            _socialData.elementAt(0).instagramUrl.toString();
                        _socialLink(socialLink);
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    child: GestureDetector(
                      onTap: () {
                        socialLink =
                            _socialData.elementAt(0).youtubeUrl.toString();
                        _socialLink(socialLink);
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.youtube,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 16,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: SizedBox(
                                    height: 300, // Adjust the height as needed
                                    child: ListView.builder(
                                      itemCount: _melaOwnerData.length,
                                      itemBuilder: (context, index) {
                                        MelaOwnerModel melaOwner =
                                            _melaOwnerData[index];
                                        return Column(
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                String wNo =
                                                    melaOwner.phone.toString();
                                                _whatsappUrl(wNo);
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop('dialog');
                                              },
                                              icon: const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.whatsapp,
                                                    size: 22,
                                                  )),
                                              label: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(
                                                        text: melaOwner.name,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        children: <InlineSpan>[
                                                          TextSpan(
                                                            text: melaOwner
                                                                .address, // Use index to access the first address
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              color: Color.fromARGB(
                                                  255, 213, 219, 253),
                                              thickness: 1,
                                            ),
                                          ],
                                        );
                                      },
                                    )),
                              ),
                            );
                          },
                        );
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 16,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: SizedBox(
                                    height: 300, // Adjust the height as needed
                                    child: ListView.builder(
                                      itemCount: _melaOwnerData.length,
                                      itemBuilder: (context, index) {
                                        MelaOwnerModel melaOwner =
                                            _melaOwnerData[index];
                                        return Column(
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                String callNo =
                                                    melaOwner.phone.toString();
                                                _launchUrl(callNo);
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop('dialog');
                                              },
                                              icon: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Icon(
                                                  Icons.call,
                                                  size: 24.0,
                                                ),
                                              ),
                                              label: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(
                                                        text: melaOwner.name,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        children: <InlineSpan>[
                                                          TextSpan(
                                                            text: melaOwner
                                                                .address, // Use index to access the first address
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              color: Color.fromARGB(
                                                  255, 213, 219, 253),
                                              thickness: 1,
                                            ),
                                          ],
                                        );
                                      },
                                    )),
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      );
      // : Scaffold(
      //     body: Container(
      //         width: MediaQuery.of(context).size.width,
      //         color: Colors.amber,
      //         child: Image.asset(
      //           'assets/images/splash_screen.jpg',
      //           fit: BoxFit.fill,
      //         )),
      //   );
    });
  }
}
