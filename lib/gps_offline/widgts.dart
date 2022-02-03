// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WidgetsTest extends StatefulWidget {
  const WidgetsTest({Key? key}) : super(key: key);

  @override
  State<WidgetsTest> createState() {
    return _WidgetsTest();
  }
}

class _WidgetsTest extends State<WidgetsTest> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  Position? currentLocation;

  double? latitude;
  double? longitude;
  double? altitude;
  late final DateTime? timestamp;
  final _controllerlatitude = TextEditingController();
  final _longitudelatitude = TextEditingController();
  final _altitudelatitude = TextEditingController();


  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePositionList(
      _PositionItemType.position,
      position.toString(),
    );
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    setState(() {});
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      latitude = currentLocation!.latitude;
      longitude = currentLocation!.longitude;
      altitude = currentLocation!.altitude;
      timestamp = currentLocation!.timestamp;
    });
    print('latutide $latitude');
    print('longitude $longitude');
    print('longitude $altitude');
    print('longitude $timestamp');
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) {
            _toggleListening();
          }
          serviceStatusValue = 'enabled';
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              _updatePositionList(
                  _PositionItemType.log, 'Position Stream has been canceled');
            });
          }
          serviceStatusValue = 'disabled';
        }
        _updatePositionList(
          _PositionItemType.log,
          'Location service has been $serviceStatusValue',
        );
      });
    }
  }

  _getLastKnownPosition() async {
    final position = await _geolocatorPlatform.getLastKnownPosition();
    if (position != null) {
      _updatePositionList(
        _PositionItemType.position,
        position.toString(),
      );
    } else {
      _updatePositionList(
        _PositionItemType.log,
        'No last known position available',
      );
    }
    print(position);
    return position;
  }

  void _getLocationAccuracy() async {
    final status = await _geolocatorPlatform.getLocationAccuracy();
    _handleLocationAccuracyStatus(status);
  }

  void _requestTemporaryFullAccuracy() async {
    final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
      purposeKey: "TemporaryPreciseAccuracy",
    );
    _handleLocationAccuracyStatus(status);
  }

  void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
    String locationAccuracyStatusValue;
    if (status == LocationAccuracyStatus.precise) {
      locationAccuracyStatusValue = 'Precise';
    } else if (status == LocationAccuracyStatus.reduced) {
      locationAccuracyStatusValue = 'Reduced';
    } else {
      locationAccuracyStatusValue = 'Unknown';
    }
    _updatePositionList(
      _PositionItemType.log,
      '$locationAccuracyStatusValue location accuracy granted.',
    );
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => _updatePositionList(
            _PositionItemType.position,
            position.toString(),
          ));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getUserLocation();
      _toggleServiceStatusStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 10,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("RNA Test"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  enabled: false,
                  controller: _controllerlatitude,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  obscureText: false,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      labelText: "Latitude : $latitude",
                      labelStyle: const TextStyle(fontSize: 12),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0.1),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 0.1))),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "euijkbidiijeiocs";
                    }
                  },
                  onSaved: (String? newValue) {
                    latitude = double.parse(newValue!);
                  },
                ),
                sizedBox,
                TextFormField(
                  enabled: false,
                  controller: _longitudelatitude,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  obscureText: false,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      labelText: "Longitude : $longitude",
                      labelStyle: const TextStyle(fontSize: 12),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0.1),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 0.1))),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                  },
                  onSaved: (String? newValue) {
                    longitude = double.parse(newValue!);
                  },
                ),
                sizedBox,
                TextFormField(
                  enabled: false,
                  controller: _altitudelatitude,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  obscureText: false,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      labelText: " Altitude : $altitude",
                      labelStyle: const TextStyle(fontSize: 12),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0.1),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 0.1))),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Désolé, Vous devez remplir ce champ";
                    }
                  },
                  onSaved: (String? newValue) {
                    altitude = double.parse(newValue!);
                  },
                ),
                sizedBox,
                FloatingActionButton(
                    child: const Icon(Icons.location_on_sharp),
                    onPressed: () {
                      if (!_key.currentState!.validate()) {
                        return;
                      } else {
                        _key.currentState!.save();
                        // ignore: avoid_print
                        print('$latitude');
                        print('$longitude');
                        print('$altitude');
                        print('$timestamp');
                      }
                    })
              ],
            ),
          )),
    );
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
