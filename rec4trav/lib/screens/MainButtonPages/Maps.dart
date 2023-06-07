// ignore_for_file: unused_import, unnecessary_import

import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec4trav/MapsProvider/search_places.dart';
import 'package:rec4trav/models/Palette.dart';
import 'package:rec4trav/resources/firestore_methods.dart';

import 'dart:ui' as ui;

import '../../MapServices/map_services.dart';
import '../../MapsModel/auto_complete_result.dart';
import '../../Utils/utils.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

//Debounce to throttle async calls during search
  Timer? _debounce;

//Toggling UI as we need;
  bool searchToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  bool getDirections = false;

//Markers set
  Set<Marker> _markers = Set<Marker>();
  // ignore: unused_field
  Set<Marker> _markersDupe = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  int markerIdCounter = 1;
  int polylineIdCounter = 1;

  var radiusValue = 3000.0;

  var tappedPoint;

  List travelerPlaces = [];
  List favPlaces = [];
  List allFavoritePlaces = [];
  List myPlaces = [];
  String tokenKey = '';

  //Page controller for the nice pageview
  late PageController _pageController;
  int prevPage = 0;
  var tappedPlaceDetail;
  String placeImg = '';
  var photoGalleryIndex = 0;
  bool showBlankCard = false;
  bool isReviews = true;
  bool isPhotos = false;

  final key = 'APIKEY';

  var selectedPlaceDetails;

  late Position currentPosition;

  var geolocator = Geolocator();
  late GoogleMapController newGoogleMapController;
//Circle
  Set<Circle> _circles = Set<Circle>();

//Text Editing Controllers
  TextEditingController searchController = TextEditingController();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

//Cankaya University position : 39.819375, 32.563672

//Initial map position on load
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(39.819375, 32.563672),
    zoom: 14.4746,
  );

  Future<Position> locatePosition() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error");
    });
    return await Geolocator.getCurrentPosition();
  }

  void _setMarker(point) {
    var counter = markerIdCounter++;

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$polylineIdCounter';

    polylineIdCounter++;

    _polylines.add(Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points.map((e) => LatLng(e.latitude, e.longitude)).toList()));
  }

  void _setCircle(LatLng point) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12)));
    setState(() {
      _circles.add(Circle(
          circleId: CircleId('Rec4Trav'),
          center: point,
          fillColor: Colors.blue.withOpacity(0.1),
          radius: radiusValue,
          strokeColor: Colors.blue,
          strokeWidth: 1));
      getDirections = false;
      searchToggle = false;
      radiusSlider = true;
    });
  }

  _setNearMarker(LatLng point, String label, List types) async {
    var counter = markerIdCounter++;
// amusement_park
// aquarium
// art_gallery
// campground
// casino
// cemetery
// church
// hindu_temple
// mosque
// museum
// park
// rv_park
// synagogue
// tourist_attraction
// zoo
// place_of_worship
// natural_feature
// town_square

    final Uint8List markerIcon;
    if (types.contains('amusement_park'))
      markerIcon = await getBytesFromAsset('assets/mapicons/games.png', 75);
    else if (types.contains('aquarium'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/swimming-pools.png', 75);
    else if (types.contains('art_gallery'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/photography.png', 75);
    else if (types.contains('campground'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/residential-places.png', 75);
    else if (types.contains('casino'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/entertainment.png', 75);
    else if (types.contains('cemetery'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/toys-store.png', 75);
    else if (types.contains('church'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/government.png', 75);
    else if (types.contains('hindu_temple'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/manufacturing.png', 75);
    else if (types.contains('mosque'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/photography.png', 75);
    else if (types.contains('museum'))
      markerIcon = await getBytesFromAsset('assets/mapicons/museums.png', 75);
    else if (types.contains('park'))
      markerIcon = await getBytesFromAsset('assets/mapicons/parks.png', 75);
    else if (types.contains('rv_park'))
      markerIcon = await getBytesFromAsset('assets/mapicons/community.png', 75);
    else if (types.contains('synagogue'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/photography.png', 75);
    else if (types.contains('tourist_attraction'))
      markerIcon = await getBytesFromAsset('assets/mapicons/travel.png', 75);
    else if (types.contains('zoo'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/vacant-land.png', 75);
    else
      markerIcon = await getBytesFromAsset('assets/mapicons/default.png', 75);

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.fromBytes(markerIcon));
    myPlaces.add(point);
    setState(() {
      _markers.add(marker);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85)
      ..addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      cardTapped = false;
      photoGalleryIndex = 1;
      showBlankCard = false;
      goToTappedPlace();
      fetchImage();
    }
  }

  //Fetch image to place inside the tile in the pageView
  void fetchImage() async {
    if (_pageController.page !=
        null) if (allFavoritePlaces[_pageController.page!.toInt()]
            ['photos'] !=
        null) {
      setState(() {
        placeImg = allFavoritePlaces[_pageController.page!.toInt()]['photos'][0]
            ['photo_reference'];
      });
    } else {
      placeImg = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    //Providers
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Form(
          child: TextFormField(
            style: const TextStyle(color: Palette.white, fontFamily: 'Muller'),
            cursorColor: Palette.white,
            controller: searchController,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_outlined),
                prefixIconColor: Palette.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: Palette.white),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        searchToggle = false;
                        searchController.text = '';
                        _markers = {};
                        if (searchFlag.searchToggle) searchFlag.toggleSearch();
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: Palette.white,
                    ))),
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(Duration(milliseconds: 700), () async {
                if (value.length > 2) {
                  if (!searchFlag.searchToggle) {
                    searchFlag.toggleSearch();
                    _markers = {};
                  }

                  List<AutoCompleteResult> searchResults =
                      await MapServices().searchPlaces(value);

                  allSearchResults.setResults(searchResults);
                } else {
                  List<AutoCompleteResult> emptyList = [];
                  allSearchResults.setResults(emptyList);
                }
              });
            },
          ),
        ),
        backgroundColor: Palette.normalBlue,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: screenHeight,
                width: screenWidth,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  markers: _markers,
                  polylines: _polylines,
                  circles: _circles,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    newGoogleMapController = controller;
                    locatePosition().then((value) async {
                      print("current " +
                          value.latitude.toString() +
                          " " +
                          value.longitude.toString());
                      _markers.add(
                        Marker(
                          markerId: MarkerId('1'),
                          position: LatLng(value.latitude, value.longitude),
                        ),
                      );
                      CameraPosition cameraPosition = CameraPosition(
                          zoom: 10,
                          target: LatLng(value.latitude, value.longitude));

                      final GoogleMapController cnt = await _controller.future;
                      cnt.animateCamera(
                          CameraUpdate.newCameraPosition(cameraPosition));
                      FireStoreMethods().addcurrentplace(
                          FirebaseAuth.instance.currentUser!.uid,
                          value.latitude,
                          value.longitude);
                    });
                  },
                  onTap: (point) {
                    tappedPoint = point;
                    _setCircle(point);
                  },
                ),
              ),
              searchToggle
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
                      child: Column(children: [
                        Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                border: InputBorder.none,
                                hintText: 'Search',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        searchToggle = false;

                                        searchController.text = '';
                                        _markers = {};
                                        if (searchFlag.searchToggle)
                                          searchFlag.toggleSearch();
                                      });
                                    },
                                    icon: Icon(Icons.close))),
                            onChanged: (value) {
                              if (_debounce?.isActive ?? false)
                                _debounce?.cancel();
                              _debounce =
                                  Timer(Duration(milliseconds: 700), () async {
                                if (value.length > 2) {
                                  if (!searchFlag.searchToggle) {
                                    searchFlag.toggleSearch();
                                    _markers = {};
                                  }

                                  List<AutoCompleteResult> searchResults =
                                      await MapServices().searchPlaces(value);

                                  allSearchResults.setResults(searchResults);
                                } else {
                                  List<AutoCompleteResult> emptyList = [];
                                  allSearchResults.setResults(emptyList);
                                }
                              });
                            },
                          ),
                        )
                      ]),
                    )
                  : Container(),
              searchFlag.searchToggle
                  ? allSearchResults.allReturnedResults.length != 0
                      ? Positioned(
                          top: 100.0,
                          left: 15.0,
                          child: Container(
                            height: 200.0,
                            width: screenWidth - 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: ListView(
                              children: [
                                ...allSearchResults.allReturnedResults
                                    .map((e) => buildListItem(e, searchFlag))
                              ],
                            ),
                          ))
                      : Positioned(
                          top: 100.0,
                          left: 15.0,
                          child: Container(
                            height: 200.0,
                            width: screenWidth - 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: Center(
                              child: Column(children: [
                                Text('No results to show',
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 5.0),
                                Container(
                                  width: 125.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      searchFlag.toggleSearch();
                                    },
                                    child: Center(
                                      child: Text(
                                        'Close this',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'WorkSans',
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ))
                  : Container(),
              getDirections
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5),
                      child: Column(children: [
                        Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: _originController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                border: InputBorder.none,
                                hintText: 'Origin'),
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: _destinationController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                border: InputBorder.none,
                                hintText: 'Destination',
                                suffixIcon: Container(
                                    width: 96.0,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              var directions =
                                                  await MapServices()
                                                      .getDirections(
                                                          _originController
                                                              .text,
                                                          _destinationController
                                                              .text);
                                              _markers = {};
                                              _polylines = {};
                                              gotoPlace(
                                                  directions['start_location']
                                                      ['lat'],
                                                  directions['start_location']
                                                      ['lng'],
                                                  directions['end_location']
                                                      ['lat'],
                                                  directions['end_location']
                                                      ['lng'],
                                                  directions['bounds_ne'],
                                                  directions['bounds_sw']);
                                              _setPolyline(directions[
                                                  'polyline_decoded']);
                                            },
                                            icon: Icon(Icons.search)),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                getDirections = false;
                                                _originController.text = '';
                                                _destinationController.text =
                                                    '';
                                                _markers = {};
                                                _polylines = {};
                                              });
                                            },
                                            icon: Icon(Icons.close))
                                      ],
                                    ))),
                          ),
                        )
                      ]),
                    )
                  : Container(),
              radiusSlider
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 50.0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                activeColor: Colors.blue,
                                max: 3500.0,
                                min: 500.0,
                                value: radiusValue,
                                onChanged: (newVal) {
                                  radiusValue = newVal;
                                  pressedNear = false;
                                  _setCircle(tappedPoint);
                                },
                              ),
                            ),
                            IconButton(
                              //NEARBY PLACES BUTTON
                              onPressed: () {
                                if (_debounce?.isActive ?? false)
                                  _debounce?.cancel();
                                _debounce = Timer(
                                  Duration(seconds: 2),
                                  () async {
                                    var placesResult = await MapServices()
                                        .getPlaceDetails(
                                            tappedPoint, radiusValue.toInt());

                                    List<dynamic> placesWithin =
                                        placesResult['results'] as List;

                                    allFavoritePlaces = placesWithin;

                                    tokenKey =
                                        placesResult['next_page_token'] ??
                                            'none';

                                    searchplacemodule('museum',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('amusement_park',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('aquarium',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('art_gallery',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('campground',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('casino',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('church',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('hindu_temple',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('synagogue',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('tourist_attraction',
                                        radiusValue.toInt(), tappedPoint);
                                    searchplacemodule('zoo',
                                        radiusValue.toInt(), tappedPoint);

                                    _markers = {};

                                    List uniqueList = [];

                                    for (var item in travelerPlaces) {
                                      if (!uniqueList.contains(item)) {
                                        print("uq: " +
                                            item['place_id'].toString());
                                        uniqueList.add(item);
                                      }
                                    }
                                    allFavoritePlaces = uniqueList;

                                    allFavoritePlaces.forEach((element) {
                                      _setNearMarker(
                                        LatLng(
                                            element['geometry']['location']
                                                ['lat'],
                                            element['geometry']['location']
                                                ['lng']),
                                        element['name'],
                                        element['types'],
                                      );
                                    });
                                    _markersDupe = _markers;
                                    pressedNear = true;
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.near_me,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    radiusSlider = false;
                                    pressedNear = false;
                                    cardTapped = false;
                                    radiusValue = 3000.0;
                                    _circles = {};
                                    _markers = {};
                                    allFavoritePlaces = [];
                                  });
                                },
                                icon: Icon(Icons.close, color: Colors.red))
                          ],
                        ),
                      ),
                    )
                  : Container(),
              pressedNear
                  ? Positioned(
                      bottom: 20.0,
                      child: Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: allFavoritePlaces.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _nearbyPlacesList(index);
                            }),
                      ),
                    )
                  : Container(),
              cardTapped
                  ? Positioned(
                      top: 100.0,
                      left: 15.0,
                      child: FlipCard(
                        front: Container(
                          height: 250.0,
                          width: 175.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: 150.0,
                                  width: 175.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(placeImg != ''
                                              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                              : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                                          fit: BoxFit.cover)),
                                ),
                                Container(
                                  padding: EdgeInsets.all(7.0),
                                  width: 175.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address: ',
                                        style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        width: 105.0,
                                        child: Text(
                                          tappedPlaceDetail[
                                                  'formatted_address'] ??
                                              'none given',
                                          style: TextStyle(
                                              fontFamily: 'WorkSans',
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                                  width: 175.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contact: ',
                                        style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                          width: 105.0,
                                          child: Text(
                                            tappedPlaceDetail[
                                                    'formatted_phone_number'] ??
                                                'none given',
                                            style: TextStyle(
                                                fontFamily: 'WorkSans',
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w400),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        back: Container(
                          height: 300.0,
                          width: 225.0,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isReviews = true;
                                          isPhotos = false;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 700),
                                        curve: Curves.easeIn,
                                        padding: EdgeInsets.fromLTRB(
                                            7.0, 4.0, 7.0, 4.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(11.0),
                                            color: isReviews
                                                ? Colors.green.shade300
                                                : Colors.white),
                                        child: Text(
                                          'Reviews',
                                          style: TextStyle(
                                              color: isReviews
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontFamily: 'WorkSans',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isReviews = false;
                                          isPhotos = true;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 700),
                                        curve: Curves.easeIn,
                                        padding: EdgeInsets.fromLTRB(
                                            7.0, 4.0, 7.0, 4.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(11.0),
                                            color: isPhotos
                                                ? Colors.green.shade300
                                                : Colors.white),
                                        child: Text(
                                          'Photos',
                                          style: TextStyle(
                                              color: isPhotos
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontFamily: 'WorkSans',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 250.0,
                                child: isReviews
                                    ? ListView(
                                        children: [
                                          if (isReviews &&
                                              tappedPlaceDetail['reviews'] !=
                                                  null)
                                            ...tappedPlaceDetail['reviews']!
                                                .map((e) {
                                              return _buildReviewItem(e);
                                            })
                                        ],
                                      )
                                    : _buildPhotoGallery(
                                        tappedPlaceDetail['photos'] ?? []),
                              )
                            ],
                          ),
                        ),
                      ))
                  : Container()
            ],
          )
        ],
      ),
      floatingActionButton: FabCircularMenu(
          alignment: Alignment.bottomLeft,
          fabColor: Colors.blue.shade50,
          fabOpenColor: Colors.red.shade100,
          ringDiameter: 250.0,
          ringWidth: 60.0,
          ringColor: Colors.blue.shade50,
          fabSize: 60.0,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    searchToggle = true;
                    radiusSlider = false;
                    pressedNear = false;
                    cardTapped = false;
                    getDirections = false;
                  });
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  setState(() {
                    searchToggle = false;
                    radiusSlider = false;
                    pressedNear = false;
                    cardTapped = false;
                    getDirections = true;
                  });
                },
                icon: Icon(Icons.navigation))
          ]),
    );
  }

  _buildReviewItem(review) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(review['profile_photo_url']),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: 4.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 160.0,
                  child: Text(
                    review['author_name'],
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 3.0),
                RatingStars(
                  value: review['rating'] * 1.0,
                  starCount: 5,
                  starSize: 7,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 9.0),
                  valueLabelRadius: 7,
                  maxValue: 5,
                  starSpacing: 2,
                  maxValueVisibility: false,
                  valueLabelVisibility: true,
                  animationDuration: Duration(milliseconds: 1000),
                  valueLabelPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  valueLabelMargin: const EdgeInsets.only(right: 4),
                  starOffColor: const Color(0xffe7e8ea),
                  starColor: Colors.yellow,
                )
              ])
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Text(
              review['text'],
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Divider(color: Colors.grey.shade600, height: 1.0)
      ],
    );
  }

  _buildPhotoGallery(photoElement) {
    if (photoElement == null || photoElement.length == 0) {
      showBlankCard = true;
      return Container(
        child: Center(
          child: Text(
            'No Photos',
            style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 12.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      var placeImg = photoElement[photoGalleryIndex]['photo_reference'];
      var maxWidth = photoElement[photoGalleryIndex]['width'];
      var maxHeight = photoElement[photoGalleryIndex]['height'];
      var tempDisplayIndex = photoGalleryIndex + 1;

      return Column(
        children: [
          SizedBox(height: 10.0),
          Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&maxheight=$maxHeight&photo_reference=$placeImg&key=$key'),
                      fit: BoxFit.cover))),
          SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != 0)
                    photoGalleryIndex = photoGalleryIndex - 1;
                  else
                    photoGalleryIndex = 0;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != 0
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Prev',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Text(
              '$tempDisplayIndex/' + photoElement.length.toString(),
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != photoElement.length - 1)
                    photoGalleryIndex = photoGalleryIndex + 1;
                  else
                    photoGalleryIndex = photoElement.length - 1;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != photoElement.length - 1
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ])
        ],
      );
    }
  }

  searchplacemodule(String type, int radius, var tapped) async {
    var results = await getNearbyPlaces(
        tapped.latitude, tapped.longitude, radius, type, key);
    if (results != null) {
      for (var result in results) {
        travelerPlaces.add(result);
      }
    }
  }

  gotoPlace(double lat, double lng, double endLat, double endLng,
      Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
        25));

    _setMarker(LatLng(lat, lng));
    _setMarker(LatLng(endLat, endLng));
  }

  Future<void> moveCameraSlightly() async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            allFavoritePlaces[_pageController.page!.toInt()]['geometry']
                    ['location']['lat'] +
                0.0125,
            allFavoritePlaces[_pageController.page!.toInt()]['geometry']
                    ['location']['lng'] +
                0.005),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  _nearbyPlacesList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () async {
          cardTapped = !cardTapped;
          if (cardTapped) {
            tappedPlaceDetail = await MapServices()
                .getPlace(allFavoritePlaces[index]['place_id']);

            setState(() {});
          }
          moveCameraSlightly();
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 150.0,
                width: 275.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 4.0),
                          blurRadius: 10.0)
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      _pageController.position.haveDimensions
                          ? _pageController.page!.toInt() == index
                              ? Container(
                                  height: 90.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(placeImg != ''
                                              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                              : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  height: 90.0,
                                  width: 20.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                      ),
                                      color: Colors.blue),
                                )
                          : Container(),
                      SizedBox(width: 5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 170.0,
                            child: Text(allFavoritePlaces[index]['name'],
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              RatingStars(
                                value: allFavoritePlaces[index]['rating']
                                            .runtimeType ==
                                        int
                                    ? allFavoritePlaces[index]['rating'] * 1.0
                                    : allFavoritePlaces[index]['rating'] ?? 0.0,
                                starCount: 5,
                                starSize: 10,
                                valueLabelColor: const Color(0xff9b9b9b),
                                valueLabelTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                valueLabelRadius: 10,
                                maxValue: 5,
                                starSpacing: 2,
                                maxValueVisibility: false,
                                valueLabelVisibility: true,
                                animationDuration: Duration(milliseconds: 1000),
                                valueLabelPadding: const EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 8),
                                valueLabelMargin:
                                    const EdgeInsets.only(right: 8),
                                starOffColor: const Color(0xffe7e8ea),
                                starColor: Colors.yellow,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              FavoriteButton(
                                valueChanged: (_) async {
                                  //allFavoritePlaces[index]['geometry']
                                  // print("sa1 : " +
                                  //     FirebaseAuth.instance.currentUser!.uid
                                  //         .toString());
                                  // print("sa2 : " +
                                  //     allFavoritePlaces[index]['name']
                                  //         .toString());
                                  // print("sa3 : " +
                                  //     'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key');
                                  // print("sa4 : " +
                                  //     allFavoritePlaces[index]['geometry']
                                  //             ['location']['lat']
                                  //         .toString());
                                  // print("sa5 : " +
                                  //     allFavoritePlaces[index]['geometry']
                                  //             ['location']['lng']
                                  //         .toString());
                                  try {
                                    String res = await FireStoreMethods()
                                        .addwishlist(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            allFavoritePlaces[index]['name'],
                                            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key',
                                            allFavoritePlaces[index]['geometry']
                                                ['location']['lat'],
                                            allFavoritePlaces[index]['geometry']
                                                ['location']['lng']);

                                    if (res == 'success') {
                                      print('wishlist added');
                                    } else {
                                      print('wishlist not added');
                                    }
                                  } catch (err) {
                                    showSnackBar(
                                      context,
                                      err.toString(),
                                    );
                                  }
                                },
                                iconSize: 15,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.directions,
                                  size: 15,
                                ),
                                onPressed: () async {
                                  locatePosition().then((value) async {
                                    var directions = await MapServices()
                                        .getDirectionsFromLatLng(
                                            LatLng(value.latitude,
                                                value.longitude),
                                            LatLng(
                                                allFavoritePlaces[index]
                                                        ['geometry']['location']
                                                    ['lat'],
                                                allFavoritePlaces[index]
                                                        ['geometry']['location']
                                                    ['lng']),
                                            key);
                                    _markers = {};
                                    _polylines = {};
                                    gotoPlace(
                                        directions['start_location']['lat'],
                                        directions['start_location']['lng'],
                                        directions['end_location']['lat'],
                                        directions['end_location']['lng'],
                                        directions['bounds_ne'],
                                        directions['bounds_sw']);
                                    _setPolyline(
                                        directions['polyline_decoded']);
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            width: 170.0,
                            child: Text(
                              allFavoritePlaces[index]['business_status'] ??
                                  'none',
                              style: TextStyle(
                                  color: allFavoritePlaces[index]
                                              ['business_status'] ==
                                          'OPERATIONAL'
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> goToTappedPlace() async {
    final GoogleMapController controller = await _controller.future;

    _markers = {};

    var selectedPlace = allFavoritePlaces[_pageController.page!.toInt()];

    _setNearMarker(
        LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        selectedPlace['name'] ?? 'no name',
        selectedPlace['types']);

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          gotoSearchedPlace(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.green, size: 25.0),
            SizedBox(width: 4.0),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }
}
