// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:map_track_app/config/theme/app_theme.dart';
import 'package:map_track_app/domain/entities/accions.dart';
import 'package:map_track_app/domain/entities/custom_location.dart';
import 'package:map_track_app/domain/entities/zones.dart';
import 'package:map_track_app/presentation/widgets/widget_to_marker.dart';
import 'package:map_track_app/services/position_service_impl.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class MapProvider extends ChangeNotifier {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  String? _darkMapStyle;

  bool isDarkMode = false;

  final MarkerId _userMarkerId = const MarkerId('user_marker');

  Marker? _userMarker;

  final PositionServiceImpl _positionService = PositionServiceImpl();

  StreamSubscription<CustomLocation>? positionStreamSubscription;

  CustomLocation? _customLocation;

  String? imagePath;

  final Box<Accions> _accionsBox = Hive.box('accions');
  final Box<Zones> _zonesBox = Hive.box('zones');

  void saveToHistoryAccion(Accions item) {
    _accionsBox.add(item);
    notifyListeners();
  }

  void saveToHistoryZone(Zones item) {
    _zonesBox.add(item);
    notifyListeners();
  }

  void clearActions() {
    _accionsBox.clear();
    markers.removeWhere((marker) => marker.markerId != _userMarkerId);
    notifyListeners();
  }

  Future<void> loadDataFromHive() async {
  for (final action in _accionsBox.values) {
    final marker = Marker(
      markerId: MarkerId(action.title),
      position: LatLng(action.latitude, action.longitude),
      icon:  await WidgetToMarker(icon: AppTheme.markerIcons[action.markerIcon!]).toBitmapDescriptor(
        logicalSize: const Size(150, 150),
        imageSize: const Size(150, 150),
      ),
      infoWindow: InfoWindow(
        title: action.title,
        snippet: action.description,
      ),
    );
    markers.add(marker);
  }

  for (final zone in _zonesBox.values) {
    final circle = Circle(
      circleId: CircleId(zone.name),
      center: LatLng(zone.latitude, zone.longitude),
      radius: zone.radius.toDouble(),
      fillColor: AppTheme.colorList[zone.color].withOpacity(0.3), // Color semitransparente
      strokeColor: AppTheme.colorList[zone.color],
      strokeWidth: 2,
    );
    circles.add(circle);
  }
  notifyListeners();
}


  void addImagePath(String newImagePath) {
    imagePath = newImagePath;
    notifyListeners();
  }

  void deleteImagePath() {
    imagePath = null;
    notifyListeners();
  }


  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> markers = {};

  Set<Circle> circles = {};

  final Set<String> _notifiedCircles = {};

  Completer<GoogleMapController> get controller => _controller;

  String? _error;
  String? get error => _error;
  int selectedColor = 0; 
  int selectedMarker = 0; 
  CustomLocation? get customLocation => _customLocation; 

  MapProvider() {
    initializeNotifications();
    loadDarkStyle().then((_) {
      loadDataFromHive();
      getPosition();
    });
  }

  void changeDarkMode() async {
    isDarkMode = !isDarkMode;
    final controller = await _controller.future;
    if (isDarkMode) {
      await controller.setMapStyle(_darkMapStyle);
    } else {
      await controller.setMapStyle(null);
    }
    notifyListeners();
  }

  Future<void> loadDarkStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/json/dark_mode.json');
    notifyListeners();
  }

  Future<void> initializateMarkers(CustomLocation customLocation) async {
    _userMarker = Marker(
      markerId: _userMarkerId,
      position: LatLng(customLocation.position.latitude, customLocation.position.longitude),
      icon: await const WidgetToMarker().toBitmapDescriptor(
        logicalSize: const Size(150, 150),
        imageSize: const Size(150, 150),
      ),
      infoWindow: const InfoWindow(title: 'Tu Ubicación'),
    );
    markers.add(_userMarker!);
    notifyListeners();
  }

  void changeColorIndex(int colorIndex){
    selectedColor = colorIndex;
    notifyListeners();
  }

  void changeIconIndex(int markerIndex){
    selectedMarker = markerIndex;
    notifyListeners();
  }

  static const CameraPosition kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  Future<void> getPosition() async {
    try {
      CustomLocation location = await _positionService.getPosition();
      _customLocation = location;
      notifyListeners();

      await initializateMarkers(_customLocation!);

      positionStreamSubscription = _positionService.positionStream.listen(
        (CustomLocation location) {
          _customLocation = location;
          _updateUserMarker(location);
          checkUserLocation(LatLng(location.position.latitude, location.position.longitude));
          notifyListeners();
        },
        onError: (error) {
          _error = error.toString();
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void checkUserLocation(LatLng userLocation) {
    for (final circle in circles) {
      final distance = _positionService.haversineDistance(userLocation, circle.center);
      if (distance <= circle.radius) {
        if (!_notifiedCircles.contains(circle.circleId.value)) {
          _sendNotification(
            '¡Estás en una zona!',
            'Has ingresado a la zona ${circle.circleId.value}',
          );
          _notifiedCircles.add(circle.circleId.value);
        }
      } else {
        _notifiedCircles.remove(circle.circleId.value);
      }
    }
  }

  Future<void> _updateUserMarker(CustomLocation location) async {
    final GoogleMapController mapController = await _controller.future;
    final LatLng newPosition = LatLng(location.position.latitude, location.position.longitude);
    final Marker updatedMarker = _userMarker!.copyWith(
      positionParam: newPosition,
      infoWindowParam: const InfoWindow(title: 'Tu Ubicación'),
    );

    markers.remove(_userMarker);
    markers.add(updatedMarker);
    _userMarker = updatedMarker;
    mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
  }

  void stopListening() {
    positionStreamSubscription?.cancel();
    notifyListeners();
  }

  void addCircle(LatLng location, double radius, String circleId) {
    final String id = circleId;
    final Circle circle = Circle(
      circleId: CircleId(id),
      center: location,
      radius: radius,
      strokeColor: AppTheme.colorList[selectedColor],
      strokeWidth: 4,
    );

    circles.add(circle);
    notifyListeners();
  }

  void removeCircle(String id) {
    circles.removeWhere((circle) => circle.circleId.value == id);
    notifyListeners();
  }

  void clearCircles() {
    circles.clear();
    _zonesBox.clear();
    notifyListeners();
  }

  void onMapCreated(GoogleMapController mapController) async {
    _controller.complete(mapController);
    if (isDarkMode && _darkMapStyle != null) {
      await mapController.setMapStyle(_darkMapStyle);
    }
    if (_customLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_customLocation!.position.latitude, _customLocation!.position.longitude),
            zoom: 16,
          ),
        ),
      );
    }
  }

  void createAndAddNewMarker(String name) async {
    final newMarker = Marker(
      markerId: MarkerId(AppTheme.markerIcons[selectedMarker].codePoint.toString()),
      position: LatLng(customLocation!.position.latitude, customLocation!.position.longitude),
      icon: await WidgetToMarker(icon: AppTheme.markerIcons[selectedMarker]).toBitmapDescriptor(
        logicalSize: const Size(150, 150),
        imageSize: const Size(150, 150),
      ),
      infoWindow: InfoWindow(title: name),
    );
    markers.add(newMarker);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
