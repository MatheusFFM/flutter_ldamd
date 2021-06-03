import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  late Position _currentPosition;

  _MyAppState() {
    Geolocator.getPositionStream(intervalDuration: Duration(seconds: 10)).listen((position) {
      _determinePosition()
          .then((val) => setState(() => {_currentPosition = val}));
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
                target: LatLng(
                    _currentPosition.latitude, _currentPosition.longitude),
                zoom: 17.0),
            mapType: MapType.normal,
            myLocationEnabled: true,
            markers: _createMarkers(),
            circles: Set.from([
              Circle(
                circleId: CircleId('Radio'),
                center: LatLng(
                    _currentPosition.latitude, _currentPosition.longitude),
                radius: 50,
                fillColor: Colors.cyan.withOpacity(0.15),
                strokeColor: Colors.cyan.withOpacity(0.3),
                strokeWidth: 2,
              )
            ]),
          ),
        ));
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

  Set<Marker> _createMarkers() {
    return {
      Marker(
          markerId: MarkerId("Contagem"),
          infoWindow: InfoWindow(title: 'PUC Contagem'),
          position: LatLng(-19.939009215295368, -44.07606860247624)),
      Marker(
        markerId: MarkerId("Poço de caldas"),
        infoWindow: InfoWindow(title: 'PUC Poço de caldas'),
        position: LatLng(-21.799077076240344, -46.5985474603033),
      ),
      Marker(
        markerId: MarkerId("São Gabriel"),
        infoWindow: InfoWindow(title: 'PUC São Gabriel'),
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
        markerId: MarkerId("Coração Eucarístico"),
        infoWindow: InfoWindow(title: 'PUC Coração Eucarístico'),
        position: LatLng(-19.922690711945393, -43.99258427383518),
      ),
      Marker(
        markerId: MarkerId("Uberlandia"),
        infoWindow: InfoWindow(title: 'PUC Uberlandia'),
        position: LatLng(-18.92394435311863, -48.29538344501943),
      ),
      Marker(
        markerId: MarkerId("Praça da Liberdade"),
        infoWindow: InfoWindow(title: 'PUC Praça da Liberdade'),
        position: LatLng(-19.933127295410294, -43.93710548732594),
      ),
    };
  }
}
