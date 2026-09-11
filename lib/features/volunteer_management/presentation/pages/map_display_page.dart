import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapDisplayPage extends StatefulWidget {
  final LatLng location;
  final String title;

  const MapDisplayPage({
    super.key,
    required this.location,
    required this.title,
  });

  @override
  State<MapDisplayPage> createState() => _MapDisplayPageState();
}

class _MapDisplayPageState extends State<MapDisplayPage> {
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: widget.location,
          initialZoom: 15.0,
          minZoom: 3.0,
          maxZoom: 19.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.graduationregistration',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: widget.location,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 56,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
