import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Place Picker Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GooglePlacePickerExample(),
    );
  }
}

class GooglePlacePickerExample extends StatefulWidget {
  const GooglePlacePickerExample({super.key});

  @override
  State<GooglePlacePickerExample> createState() =>
      _GooglePlacePickerExampleState();
}

class _GooglePlacePickerExampleState extends State<GooglePlacePickerExample> {
  GoogleMapController? mapController;
  bool _useFreeGeocoding = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SwitchListTile(
            title: const Text("Use Free Geocoding"),
            value: _useFreeGeocoding,
            onChanged: (value) {
              setState(() {
                _useFreeGeocoding = value;
              });
            },
          ),
          ElevatedButton(
            child: const Text("Pick Delivery location"),
            onPressed: () {
              showPlacePicker();
            },
          ),
        ],
      ),
    );
  }

  void showPlacePicker() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            googleAPIParameters: const GoogleAPIParameters(
              fields: ['geometry/location'],
              language: 'en',
              region: 'bd'
            ),
            useFreeGeocoding: _useFreeGeocoding,
            mapsBaseUrl: kIsWeb
                ? 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/'
                : "https://maps.googleapis.com/maps/api/",
            usePinPointingSearch: true,
            apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
            w3wApiKey: dotenv.env['W3W_API_KEY'],
            onPlacePicked: (LocationResult result) {
              debugPrint("Place picked: ${result.formattedAddress}");
              debugPrint("W3W address: ${result.location?.words}");
              Navigator.of(context).pop();
            },
            enableNearbyPlaces: false,
            showSearchInput: true,
            initialLocation: const LatLng(
              23.878100,
              90.397298,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              mapController = controller;
            },
            searchInputConfig: const SearchInputConfig(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              autofocus: false,
              textDirection: TextDirection.ltr,
            ),
            searchInputDecorationConfig: const SearchInputDecorationConfig(
              hintText: "Search for a building, street or ...",
            ),
            // selectedPlaceWidgetBuilder: (ctx, state, result) {
            //   return const SizedBox.shrink();
            // },
            autocompletePlacesSearchRadius: 150,
          );
        },
      ),
    );
  }
}
