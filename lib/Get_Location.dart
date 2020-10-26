/*
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import 'get_location.dart';

import 'get_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class Get_Location extends StatefulWidget {
  @override
  _Get_LocationState createState() => _Get_LocationState();
}

class _Get_LocationState extends State<Get_Location> {



  Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;

  static double latitude_current = 31.9414246;
  static double longitude_current = 35.8880857;

  void _GetDeviceLocation() async {
    var location = new Location();
    location.changeSettings(
      accuracy: LocationAccuracy.HIGH,
      distanceFilter: 0,
      interval: 100,
    );
    location.onLocationChanged().listen((LocationData currentLocation) {
      latitude_current = currentLocation.latitude;
      longitude_current = currentLocation.longitude;
      _goToTheLake();
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kLake = CameraPosition(
      bearing: 60.8334901395799,
      target: LatLng(latitude_current, longitude_current),
      tilt: 80.440717697143555,
      zoom: 18.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
        actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: _GetDeviceLocation)],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude_current, longitude_current),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) async {
          _GetDeviceLocation();
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        polylines: Set<Polyline>.of(_mapPolylines.values),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Drive Mode'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    _GetDeviceLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

  }

 */
/* final Location location = Location();

  Future<void> _showInfoDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Demo Application'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Created by Guillaume Bernos'),
                InkWell(
                  child: Text(
                    'https://github.com/Lyokone/flutterlocation',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () =>
                      launch('https://github.com/Lyokone/flutterlocation'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: const <Widget>[
           // PermissionStatusWidget(),
            Divider(height: 32),
           // ServiceEnabledWidget(),
            Divider(height: 32),
            //GetLocationWidget(),
            Divider(height: 32),
            //ListenLocationWidget()
          ],
        ),
      ),
    );
  }
*/
/*

  */
/*Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/
/*

}
*/
import 'package:fakahany/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fakahany/global/Colors.dart' as myColors;
import 'package:url_launcher/url_launcher.dart';

// Your api key storage.

class Get_Location extends StatelessWidget {
  // Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.green,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.yellow,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PickResult selectedPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map Place Picer Demo"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Load Google Map"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Stack(
                          children: <Widget>[
                            PlacePicker(
                              apiKey: 'AIzaSyAg7UnAF9QXjwrkwUG219dlVRwb05k7tjA',
                              initialPosition: HomePage.kInitialPosition,
                              useCurrentLocation: true,
                              selectInitialPosition: true,

                              //usePlaceDetailSearch: true,
                              onPlacePicked: (result) {
                                selectedPlace = result;
                                Navigator.of(context).pop();
                                setState(() {
                                  print('moh');
                                });
                              },
                              forceSearchOnZoomChanged: true,
                              automaticallyImplyAppBarLeading: false,
                              autocompleteLanguage: "ar",
                              region: 'eg',
                              //selectInitialPosition: true,
                              // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                              //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                              //   return isSearchBarFocused
                              //       ? Container()
                              //       : FloatingCard(
                              //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                              //           leftPosition: 0.0,
                              //           rightPosition: 0.0,
                              //           width: 500,
                              //           borderRadius: BorderRadius.circular(12.0),
                              //           child: state == SearchingState.Searching
                              //               ? Center(child: CircularProgressIndicator())
                              //               : RaisedButton(
                              //                   child: Text("Pick Here"),
                              //                   onPressed: () {
                              //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                              //                     //            this will override default 'Select here' Button.
                              //                     print("do something with [selectedPlace] data");
                              //                     Navigator.of(context).pop();
                              //                   },
                              //                 ),
                              //         );
                              // },
                              // pinBuilder: (context, state) {
                              //   if (state == PinState.Idle) {
                              //     return Icon(Icons.favorite_border);
                              //   } else {
                              //     return Icon(Icons.favorite);
                              //   }
                              // },
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      'Confirm Current location',
                                      style: TextStyle(
                                        fontFamily: 'SemiBold',
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      getAndSaveCurrentLocation();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
              selectedPlace == null
                  ? Container()
                  : Text(selectedPlace.formattedAddress ?? ""),
            ],
          ),
        ));
  }

  var Lat;
  var Long;
  getAndSaveCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    Lat = position.latitude;
    Long = position.longitude;
    /* Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ServiceDetails(
          Lat: Lat,
          Long: Long,
          serviceTypeList: service_type_name,
          service_type_refernce: spl,
          splizatian_name: splizatian_name,
          splizatin_refernce: splizatin_refernce),
    ));*/
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }
}
