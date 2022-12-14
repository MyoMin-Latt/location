import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

Future<void> locationPermissionAndService() async {
  Location location = Location();
  bool? serviceEnabled;
  late PermissionStatus? permissionGranted;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}

Future<LocationData?> getLocationData() async {
  Location location1 = Location();
  LocationData? locationData;
  bool? serviceEnabled;
  late PermissionStatus? permissionGranted;
  serviceEnabled = await location1.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location1.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location1.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location1.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  locationData = await location1.getLocation();
  // print(locationData);
  return locationData;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationData? locationData;
  String latitude = '';
  String longitude = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitude : $latitude', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            Text('Longitude : $longitude',
                style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // locationPermissionAndService();
                await getLocationData();
              },
              child: const Text('Request Location'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                locationData = await getLocationData();
                latitude = locationData!.latitude.toString();
                longitude = locationData!.longitude.toString();
                setState(() {});
              },
              child: const Text('Get Location'),
            ),
            ElevatedButton(
              onPressed: () {
                latitude = '';
                longitude = '';
                setState(() {});
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.skip_next),
      ),
    );
  }
}
