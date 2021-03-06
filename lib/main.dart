// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert' show utf8;

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Position _currentPosition;
  String lastMessage = "";

  _MyAppState() {
    Geolocator.getPositionStream(intervalDuration: Duration(seconds: 10))
        .listen((position) {
      _determinePosition().then((val) => _upadtePosition(val));
    });
  }

  createAlertDialog(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('PUC Maps'),
            backgroundColor: Colors.cyan,
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: _currentPosition != null
                    ? LatLng(
                        _currentPosition.latitude, _currentPosition.longitude)
                    : LatLng(0, 0),
                zoom: 17.0),
            mapType: MapType.normal,
            myLocationEnabled: true,
            indoorViewEnabled: false,
            mapToolbarEnabled: false,
            trafficEnabled: false,
            markers: _createMarkers(),
            circles: _createCircles(),
          ),
        ));
  }

  _upadtePosition(Position val) async {
    //Update currentPosition
    setState(() => {_currentPosition = val});

    String result;
    var url =
        'https://us-central1-lunar-planet-315715.cloudfunctions.net/calcDistance?lat=' +
            _currentPosition.latitude.toString() +
            '&long=' +
            _currentPosition.longitude.toString();

    var httpClient = new HttpClient();

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var data = await response.transform(utf8.decoder).join();
        result = data;
      } else {
        result = 'Erro buscando cita????o:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Falha na invoca????o da fun????o getquotes.';
    }

    if (result != "" && result != lastMessage) {
      createAlertDialog(result);
    }
    lastMessage = result;

    // var httpclient = http.Client();

    // final response = await httpclient.post(
    //   Uri.parse(url),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, double>{
    //     'lat': _currentPosition.latitude,
    //     'long': _currentPosition.longitude
    //   }),
    // );

    // if (response.statusCode == HttpStatus.ok) {
    //   var data = response.body;
    //   result = data;
    // } else {
    //   result = 'Erro buscando cita????o:\nHttp status ${response.statusCode}';
    // }

    print("RESULT => " + result);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permantly denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Set<Circle> _createCircles() {
    double radius = 100;
    Color fillColor = Colors.cyan.withOpacity(0.15);
    Color strokeColor = Colors.cyan.withOpacity(0.3);
    const strokeWidth = 2;

    return {
      Circle(
        circleId: CircleId('Contagem'),
        center: LatLng(-19.939009215295368, -44.07606860247624),
        radius: radius,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
      Circle(
        circleId: CircleId('Po??o de caldas'),
        center: LatLng(-21.799077076240344, -46.5985474603033),
        radius: radius,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
      Circle(
        circleId: CircleId('S??o Gabriel'),
        center: LatLng(-19.859488735571382, -43.91905810753607),
        radius: radius,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
      Circle(
        circleId: CircleId('Barreiro'),
        center: LatLng(-19.976523364712037, -44.02588694432856),
        radius: radius,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
      Circle(
        circleId: CircleId('Betim'),
        center: LatLng(-19.95492031627776, -44.198411644998146),
        radius: radius,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
      Circle(
        circleId: CircleId('Cora????o Eucar??stico'),
        center: LatLng(-19.922690711945393, -43.99258427383518),
        radius: radius,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
      Circle(
        circleId: CircleId('Uberlandia'),
        center: LatLng(-18.92394435311863, -48.29538344501943),
        radius: radius,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
      Circle(
        circleId: CircleId('Pra??a da Liberdade'),
        center: LatLng(-19.933127295410294, -43.93710548732594),
        radius: radius,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
    };
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
          markerId: MarkerId("Contagem"),
          infoWindow: InfoWindow(title: 'PUC Contagem'),
          position: LatLng(-19.939009215295368, -44.07606860247624)),
      Marker(
        markerId: MarkerId("Po??o de caldas"),
        infoWindow: InfoWindow(title: 'PUC Po??o de caldas'),
        position: LatLng(-21.799077076240344, -46.5985474603033),
      ),
      Marker(
        markerId: MarkerId("S??o Gabriel"),
        infoWindow: InfoWindow(title: 'PUC S??o Gabriel'),
        position: LatLng(-19.859488735571382, -43.91905810753607),
      ),
      Marker(
        markerId: MarkerId("Barreiro"),
        infoWindow: InfoWindow(title: 'PUC Barreiro'),
        position: LatLng(-19.976523364712037, -44.02588694432856),
      ),
      Marker(
        markerId: MarkerId("Betim"),
        infoWindow: InfoWindow(title: 'PUC Betim'),
        position: LatLng(-19.95492031627776, -44.198411644998146),
      ),
      Marker(
        markerId: MarkerId("Cora????o Eucar??stico"),
        infoWindow: InfoWindow(title: 'PUC Cora????o Eucar??stico'),
        position: LatLng(-19.922690711945393, -43.99258427383518),
      ),
      Marker(
        markerId: MarkerId("Uberlandia"),
        infoWindow: InfoWindow(title: 'PUC Uberlandia'),
        position: LatLng(-18.92394435311863, -48.29538344501943),
      ),
      Marker(
        markerId: MarkerId("Pra??a da Liberdade"),
        infoWindow: InfoWindow(title: 'PUC Pra??a da Liberdade'),
        position: LatLng(-19.933127295410294, -43.93710548732594),
      ),
    };
  }
}
