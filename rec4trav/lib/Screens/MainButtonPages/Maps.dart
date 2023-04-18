import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec4trav/MapsProvider/search_places.dart';

import 'dart:ui' as ui;

import '../../MapServices/map_services.dart';
import '../../MapsModel/auto_complete_result.dart';

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
  Set<Marker> _markersDupe = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  int markerIdCounter = 1;
  int polylineIdCounter = 1;

  var radiusValue = 3000.0;

  var tappedPoint;

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
          circleId: CircleId('raj'),
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
    final Uint8List markerIcon;
    print("types: " + types.toString());
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
    // TODO: implement initState
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: _markers,
                    polylines: _polylines,
                    circles: _circles,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
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
                                _debounce = Timer(Duration(milliseconds: 700),
                                    () async {
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
                          height: 50.0,
                          color: Colors.black.withOpacity(0.2),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Slider(
                                      max: 4500.0,
                                      min: 1000.0,
                                      value: radiusValue,
                                      onChanged: (newVal) {
                                        radiusValue = newVal;
                                        pressedNear = false;
                                        _setCircle(tappedPoint);
                                      })),
                              !pressedNear
                                  ? IconButton(
                                      //NEARBY PLACES BUTTON
                                      onPressed: () {
                                        if (_debounce?.isActive ?? false)
                                          _debounce?.cancel();
                                        _debounce = Timer(
                                          Duration(seconds: 2),
                                          () async {
                                            var placesResult =
                                                await MapServices()
                                                    .getPlaceDetails(
                                                        tappedPoint,
                                                        radiusValue.toInt());
                                            List libraryPlaces = [];
                                            List<dynamic> placesWithin =
                                                placesResult['results'] as List;

                                            allFavoritePlaces = placesWithin;

                                            tokenKey = placesResult[
                                                    'next_page_token'] ??
                                                'none';

                                            var resultsForMuseum =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'museum',
                                                    key);
                                            if (resultsForMuseum != null) {
                                              for (var result
                                                  in resultsForMuseum) {
                                                libraryPlaces.add(result);
                                              }
                                            }
                                            var resultsForMosque =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'museum',
                                                    key);
                                            if (resultsForMosque != null) {
                                              for (var result
                                                  in resultsForMosque) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForAmusement_park =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'amusement_park',
                                                    key);
                                            if (resultsForAmusement_park !=
                                                null) {
                                              for (var result
                                                  in resultsForAmusement_park) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForAquarium =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'aquarium',
                                                    key);
                                            if (resultsForAquarium != null) {
                                              for (var result
                                                  in resultsForAquarium) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForArt_gallery =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'art_gallery',
                                                    key);
                                            if (resultsForArt_gallery != null) {
                                              for (var result
                                                  in resultsForArt_gallery) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForCampground =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'campground',
                                                    key);
                                            if (resultsForCampground != null) {
                                              for (var result
                                                  in resultsForCampground) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForCasino =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'casino',
                                                    key);
                                            if (resultsForCasino != null) {
                                              for (var result
                                                  in resultsForCasino) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForCemetery =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'cemetery',
                                                    key);
                                            if (resultsForCemetery != null) {
                                              for (var result
                                                  in resultsForCemetery) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForChurch =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'church',
                                                    key);
                                            if (resultsForChurch != null) {
                                              for (var result
                                                  in resultsForChurch) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForHindu_temple =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'hindu_temple',
                                                    key);
                                            if (resultsForHindu_temple !=
                                                null) {
                                              for (var result
                                                  in resultsForHindu_temple) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForPark =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'park',
                                                    key);
                                            if (resultsForPark != null) {
                                              for (var result
                                                  in resultsForPark) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForRv_park =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'rv_park',
                                                    key);
                                            if (resultsForRv_park != null) {
                                              for (var result
                                                  in resultsForRv_park) {
                                                libraryPlaces.add(result);
                                              }
                                            }
                                            var resultsForSynagogue =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'synagogue',
                                                    key);
                                            if (resultsForSynagogue != null) {
                                              for (var result
                                                  in resultsForSynagogue) {
                                                libraryPlaces.add(result);
                                              }
                                            }
                                            var resultsForTourist_attraction =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'tourist_attraction',
                                                    key);
                                            if (resultsForTourist_attraction !=
                                                null) {
                                              for (var result
                                                  in resultsForTourist_attraction) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            var resultsForZoo =
                                                await getNearbyPlaces(
                                                    tappedPoint.latitude,
                                                    tappedPoint.longitude,
                                                    radiusValue.toInt(),
                                                    'zoo',
                                                    key);
                                            if (resultsForZoo != null) {
                                              for (var result
                                                  in resultsForZoo) {
                                                libraryPlaces.add(result);
                                              }
                                            }

                                            _markers = {};

                                            // allFavoritePlaces
                                            //     .forEach((element) {
                                            //   element.removeWhere((key,
                                            //           value) =>
                                            //       key == 'business_status' &&
                                            //       value == 'operational');

                                            //   print("types: " +
                                            //       element['types'].toString());
                                            //   if (element['types']
                                            //           .toString()
                                            //           .contains(
                                            //               'amusement_park') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('aquarium') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains(
                                            //               'art_gallery') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('campground') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('casino') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('cemetery') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('church') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains(
                                            //               'hindu_temple') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('mosque') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('museum') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('park') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('rv_park') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('synagogue') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains(
                                            //               'tourist_attraction') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('zoo')) {
                                            //     libraryPlaces.add(element);
                                            //   }
                                            // });
                                            allFavoritePlaces = libraryPlaces;

                                            allFavoritePlaces
                                                .forEach((element) {
                                              print(libraryPlaces.length);
                                              _setNearMarker(
                                                LatLng(
                                                    element['geometry']
                                                        ['location']['lat'],
                                                    element['geometry']
                                                        ['location']['lng']),
                                                element['name'],
                                                element['types'],
                                              );
                                            });
                                            _markersDupe = _markers;
                                            pressedNear = true;

                                            // allFavoritePlaces
                                            //     .forEach((element) {
                                            //   if (element['types']
                                            //           .toString()
                                            //           .contains(
                                            //               'amusement_park') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('aquarium') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains(
                                            //               'art_gallery') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('campground') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('casino') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('cemetery') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('church') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains(
                                            //               'hindu_temple') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('mosque') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('museum') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('park') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('rv_park') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('synagogue') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains(
                                            //               'tourist_attraction') ||
                                            //       element['types']
                                            //           .toString()
                                            //           .contains('zoo')) {
                                            //     print('element' + element);
                                            //     libraryPlaces.add(element);
                                            //   }
                                            // });
                                            // print('sad: ' +
                                            //     libraryPlaces.toString());
                                            // allFavoritePlaces = libraryPlaces;

                                            // allFavoritePlaces.forEach(
                                            //   (element) {
                                            //     _setNearMarker(
                                            //       LatLng(
                                            //           element['geometry']
                                            //               ['location']['lat'],
                                            //           element['geometry']
                                            //               ['location']['lng']),
                                            //       element['name'],
                                            //       element['types'],
                                            //     );
                                            //   },
                                            // );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.near_me,
                                        color: Colors.blue,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        if (_debounce?.isActive ?? false)
                                          _debounce?.cancel();
                                        _debounce = Timer(Duration(seconds: 2),
                                            () async {
                                          if (tokenKey != 'none') {
                                            var placesResult =
                                                await MapServices()
                                                    .getMorePlaceDetails(
                                                        tokenKey);

                                            List<dynamic> placesWithin =
                                                placesResult['results'] as List;

                                            allFavoritePlaces
                                                .addAll(placesWithin);

                                            tokenKey = placesResult[
                                                    'next_page_token'] ??
                                                'none';

                                            placesWithin.forEach(
                                              (element) {
                                                _setNearMarker(
                                                    LatLng(
                                                        element['geometry']
                                                            ['location']['lat'],
                                                        element['geometry']
                                                                ['location']
                                                            ['lng']),
                                                    element['name'],
                                                    element['types']);
                                              },
                                            );
                                          } else {
                                            print('Thats all folks!!');
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.more_time,
                                          color: Colors.blue),
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
                              child: Column(children: [
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
                                          ))
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
                              ]),
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
                height: 125.0,
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
                            valueLabelMargin: const EdgeInsets.only(right: 8),
                            starOffColor: const Color(0xffe7e8ea),
                            starColor: Colors.yellow,
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

// // ignore_for_file: file_names

// import 'dart:async';

// import 'package:fab_circular_menu/fab_circular_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:rec4trav/MapServices/map_services.dart';
// import 'package:rec4trav/MapsModel/auto_complete_result.dart';
// import 'package:rec4trav/MapsProvider/search_places.dart';
// import 'package:rec4trav/Models/Palette.dart';

// class MapPage extends ConsumerStatefulWidget {
//   const MapPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MapPageState createState() => _MapPageState();
// }

// class _MapPageState extends ConsumerState<MapPage> {
//   Completer<GoogleMapController> _controller = Completer();

//   //Debounce to throttle async calls during search
//   Timer? debounce;

// //Toggling UI as we need;
//   bool searcToggle = true;
//   bool radiusSlider = false;
//   bool pressedNear = false;
//   bool cardTapped = false;
//   bool getDirections = false;

// //Markers set
//   Set<Marker> _markers = Set<Marker>();
//   Set<Marker> _markersDupe = Set<Marker>();

//   Set<Polyline> _polylines = Set<Polyline>();
//   int markerIdCounter = 1;
//   int polylineIdCounter = 1;

//   //Text editing controllers
//   TextEditingController searchController = TextEditingController();
//   TextEditingController originController = TextEditingController();
//   TextEditingController destinationController = TextEditingController();

// //Initial map position on load
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   void _setMarker(point) {
//     var counter = markerIdCounter++;
//     final Marker marker = Marker(
//       markerId: MarkerId('marker_$counter'),
//       position: point,
//       onTap: () {},
//       icon: BitmapDescriptor.defaultMarker,
//     );
//     setState(() {
//       _markers.add(marker);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     //providers
//     final allSearcResults = ref.watch(placeResultsProvider);
//     final searchFlag = ref.watch(searchToggleProvider);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Palette.appBarColor,
//         title: const Text("Maps"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: screenHeight,
//                   width: screenWidth,
//                   child: GoogleMap(
//                     mapType: MapType.normal,
//                     markers: _markers,
//                     initialCameraPosition: _kGooglePlex,
//                     onMapCreated: (GoogleMapController controller) {
//                       _controller.complete(controller);
//                     },
//                   ),
//                 ),
//                 searcToggle
//                     ? Padding(
//                         padding: const EdgeInsets.fromLTRB(15, 40, 15, 5),
//                         child: Column(
//                           children: [
//                             Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.white,
//                               ),
//                               child: TextFormField(
//                                 controller: searchController,
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 15),
//                                   border: InputBorder.none,
//                                   hintText: 'Search',
//                                   suffixIcon: IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         searcToggle = false;
//                                         searchController.text = '';
//                                         _markers = {};
//                                         searchFlag.toggleSearch();
//                                       });
//                                     },
//                                     icon: const Icon(Icons.close),
//                                   ),
//                                 ),
//                                 onChanged: (value) {
//                                   if (debounce?.isActive ?? false) {
//                                     debounce?.cancel();
//                                     debounce = Timer(
//                                         Duration(milliseconds: 700), () async {
//                                       if (value.length > 2) {
//                                         if (!searchFlag.searchToggle) {
//                                           searchFlag.toggleSearch();
//                                           _markers = {};
//                                         }
//                                         List<AutoCompleteResult> searchResults =
//                                             await MapServices()
//                                                 .searchPlaces(value);

//                                         allSearcResults
//                                             .setResults(searchResults);
//                                       } else {
//                                         List<AutoCompleteResult> emplyList = [];
//                                         allSearcResults.setResults(emplyList);
//                                       }
//                                     });
//                                   }
//                                 },
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     : Container(),
//                 searchFlag.searchToggle
//                     ? allSearcResults.allReturnedResults.length != 0
//                         ? Positioned(
//                             top: 100.0,
//                             left: 15.0,
//                             child: Container(
//                               height: 200.0,
//                               width: screenWidth - 30.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.white.withOpacity(0.7),
//                               ),
//                               child: ListView(
//                                 children: [
//                                   ...allSearcResults.allReturnedResults
//                                       .map((e) => buildListItem(e, searchFlag))
//                                 ],
//                               ),
//                             ),
//                           )
//                         : Positioned(
//                             top: 100.0,
//                             left: 15.0,
//                             child: Container(
//                               height: 200.0,
//                               width: screenWidth - 30.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.white.withOpacity(0.7),
//                               ),
//                               child: Center(
//                                   child: Column(
//                                 children: [
//                                   Text(
//                                     'No result to show',
//                                     style: TextStyle(
//                                         fontFamily: 'WorkSans',
//                                         fontWeight: FontWeight.w200),
//                                   ),
//                                   SizedBox(
//                                     height: 5.0,
//                                   ),
//                                   Container(
//                                     width: 125.0,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         searchFlag.toggleSearch();
//                                       },
//                                       child: Center(
//                                           child: Text(
//                                         'Close this ',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w300),
//                                       )),
//                                     ),
//                                   )
//                                 ],
//                               )),
//                             ),
//                           )
//                     : Container(),
//                 getDirections
//                     ? Padding(
//                         padding: EdgeInsets.fromLTRB(15, 40, 15, 5),
//                         child: Column(
//                           children: [
//                             Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.white,
//                               ),
//                               child: TextFormField(
//                                 controller: originController,
//                                 decoration: InputDecoration(
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 15),
//                                   border: InputBorder.none,
//                                   hintText: 'Origin',
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 3,
//                             ),
//                             Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.white,
//                               ),
//                               child: TextFormField(
//                                 controller: destinationController,
//                                 decoration: InputDecoration(
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 15),
//                                   border: InputBorder.none,
//                                   hintText: 'Destination',
//                                   suffixIcon: Container(
//                                     width: 96,
//                                     child: Row(
//                                       children: [
//                                         IconButton(
//                                           onPressed: () async {
//                                             var directions = await MapServices()
//                                                 .getDirections(
//                                                     originController.text,
//                                                     destinationController.text);
//                                             _markers = {};
//                                             _polylines = {};
//                                             gotoPlace(directions['start_location']['lat'],directions['start_location']['lng'],directions['end_location']['lat'],directions['end_location']['lng'],directions['bounds_ne'],directions['bounds_sw']);
//                                             _setPolyline(
//                                                 directions['polyline_decoded']);
//                                           },
//                                           icon: Icon(Icons.search),
//                                         ),
//                                         IconButton(
//                                           onPressed: () async {
//                                             setState(() {
//                                               getDirections = false;
//                                               originController.text = '';
//                                               destinationController.text = '';
//                                             });
//                                           },
//                                           icon: Icon(Icons.close),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : Container()
//               ],
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FabCircularMenu(
//         alignment: Alignment.bottomLeft,
//         fabColor: Colors.blue.shade50,
//         fabOpenColor: Colors.red.shade100,
//         ringDiameter: 250.0,
//         ringWidth: 60.0,
//         ringColor: Colors.blue.shade50,
//         fabSize: 60.0,
//         children: [
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 searcToggle = true;
//                 radiusSlider = false;
//                 pressedNear = false;
//                 cardTapped = false;
//                 getDirections = false;
//               });
//             },
//             icon: Icon(Icons.search),
//           ),
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 searcToggle = false;
//                 radiusSlider = false;
//                 pressedNear = false;
//                 cardTapped = false;
//                 getDirections = true;
//               });
//             },
//             icon: Icon(Icons.navigation),
//           ),
//         ],
//       ),
//     );
//   }
//   Future<void> goToTappedPlace() async {
//     final GoogleMapController controller = await _controller.future;

//     _markers = {};

//     var selectedPlace = allFavoritePlaces[_pageController.page!.toInt()];

//     _setNearMarker(
//         LatLng(selectedPlace['geometry']['location']['lat'],
//             selectedPlace['geometry']['location']['lng']),
//         selectedPlace['name'] ?? 'no name',
//         selectedPlace['types'],
//         selectedPlace['business_status'] ?? 'none');

//     controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: LatLng(selectedPlace['geometry']['location']['lat'],
//             selectedPlace['geometry']['location']['lng']),
//         zoom: 14.0,
//         bearing: 45.0,
//         tilt: 45.0)));
//   }
//   Future<void> gotoSearchedPlace(double lat, double lng) async {
//     final GoogleMapController controller = await _controller.future;

//     controller.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(lat, lng), zoom: 12)));
//   }

//   Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
//     return Padding(
//       padding: EdgeInsets.all(5.0),
//       child: GestureDetector(
//         onTapDown: (_) {
//           FocusManager.instance.primaryFocus?.unfocus();
//         },
//         onTap: () async {
//           var place = await MapServices().getPlace(placeItem.placeId);
//           gotoSearchedPlace(place['geometry']['location']['lat'],
//               place['geometry']['location']['lng']);
//           searchFlag.toggleSearch();
//         },
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.location_on,
//               color: Colors.green,
//               size: 25.0,
//             ),
//             SizedBox(
//               width: 4.0,
//             ),
//             Container(
//               height: 40.0,
//               width: MediaQuery.of(context).size.width - 75.0,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(placeItem.description ?? ''),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//     gotoPlace(double lat, double lng, double endLat, double endLng,
//       Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {
//     final GoogleMapController controller = await _controller.future;

//     controller.animateCamera(CameraUpdate.newLatLngBounds(
//         LatLngBounds(
//             southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
//             northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
//         25));

//     _setMarker(LatLng(lat, lng));
//     _setMarker(LatLng(endLat, endLng));
//   }

//   Future<void> moveCameraSlightly() async {
//     final GoogleMapController controller = await _controller.future;

//     controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: LatLng(
//             allFavoritePlaces[_pageController.page!.toInt()]['geometry']
//                     ['location']['lat'] +
//                 0.0125,
//             allFavoritePlaces[_pageController.page!.toInt()]['geometry']
//                     ['location']['lng'] +
//                 0.005),
//         zoom: 14.0,
//         bearing: 45.0,
//         tilt: 45.0)));
//   }
//    _nearbyPlacesList(index) {
//     return AnimatedBuilder(
//       animation: _pageController,
//       builder: (BuildContext context, Widget? widget) {
//         double value = 1;
//         if (_pageController.position.haveDimensions) {
//           value = (_pageController.page! - index);
//           value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
//         }
//         return Center(
//           child: SizedBox(
//             height: Curves.easeInOut.transform(value) * 125.0,
//             width: Curves.easeInOut.transform(value) * 350.0,
//             child: widget,
//           ),
//         );
//       },
//       child: InkWell(
//         onTap: () async {
//           cardTapped = !cardTapped;
//           if (cardTapped) {
//             tappedPlaceDetail = await MapServices()
//                 .getPlace(allFavoritePlaces[index]['place_id']);
//             setState(() {});
//           }
//           moveCameraSlightly();
//         },
//         child: Stack(
//           children: [
//             Center(
//               child: Container(
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 10.0,
//                   vertical: 20.0,
//                 ),
//                 height: 125.0,
//                 width: 275.0,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black54,
//                           offset: Offset(0.0, 4.0),
//                           blurRadius: 10.0)
//                     ]),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.white),
//                   child: Row(
//                     children: [
//                       _pageController.position.haveDimensions
//                           ? _pageController.page!.toInt() == index
//                               ? Container(
//                                   height: 90.0,
//                                   width: 90.0,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                         bottomLeft: Radius.circular(10.0),
//                                         topLeft: Radius.circular(10.0),
//                                       ),
//                                       image: DecorationImage(
//                                           image: NetworkImage(placeImg != ''
//                                               ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
//                                               : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
//                                           fit: BoxFit.cover)),
//                                 )
//                               : Container(
//                                   height: 90.0,
//                                   width: 20.0,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                         bottomLeft: Radius.circular(10.0),
//                                         topLeft: Radius.circular(10.0),
//                                       ),
//                                       color: Colors.blue),
//                                 )
//                           : Container(),
//                       SizedBox(width: 5.0),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 170.0,
//                             child: Text(allFavoritePlaces[index]['name'],
//                                 style: TextStyle(
//                                     fontSize: 12.5,
//                                     fontFamily: 'WorkSans',
//                                     fontWeight: FontWeight.bold)),
//                           ),
//                           RatingStars(
//                             value: allFavoritePlaces[index]['rating']
//                                         .runtimeType ==
//                                     int
//                                 ? allFavoritePlaces[index]['rating'] * 1.0
//                                 : allFavoritePlaces[index]['rating'] ?? 0.0,
//                             starCount: 5,
//                             starSize: 10,
//                             valueLabelColor: const Color(0xff9b9b9b),
//                             valueLabelTextStyle: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: 'WorkSans',
//                                 fontWeight: FontWeight.w400,
//                                 fontStyle: FontStyle.normal,
//                                 fontSize: 12.0),
//                             valueLabelRadius: 10,
//                             maxValue: 5,
//                             starSpacing: 2,
//                             maxValueVisibility: false,
//                             valueLabelVisibility: true,
//                             animationDuration: Duration(milliseconds: 1000),
//                             valueLabelPadding: const EdgeInsets.symmetric(
//                                 vertical: 1, horizontal: 8),
//                             valueLabelMargin: const EdgeInsets.only(right: 8),
//                             starOffColor: const Color(0xffe7e8ea),
//                             starColor: Colors.yellow,
//                           ),
//                           Container(
//                             width: 170.0,
//                             child: Text(
//                               allFavoritePlaces[index]['business_status'] ??
//                                   'none',
//                               style: TextStyle(
//                                   color: allFavoritePlaces[index]
//                                               ['business_status'] ==
//                                           'OPERATIONAL'
//                                       ? Colors.green
//                                       : Colors.red,
//                                   fontSize: 11.0,
//                                   fontWeight: FontWeight.w700),
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }