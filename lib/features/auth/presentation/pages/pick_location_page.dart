import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:latlong2/latlong.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({Key? key}) : super(key: key);

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  final MapController mapController = MapController();
  LatLng? pickedPoint;
  bool canSelectPoint = true;

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (!canSelectPoint) return;

    setState(() {
      pickedPoint = point;
      canSelectPoint = false;
    });
  }

  void _clearSelection() {
    setState(() {
      pickedPoint = null;
      canSelectPoint = true;
    });
  }

  void _confirmLocation() {
    if (pickedPoint != null) {
      Navigator.of(context).pop(pickedPoint);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك اختر موقعاً بالنقر على الخريطة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تحديد موقع الحملة',
          style: TextStyle(color: Colors.white),
        ),
        shadowColor: Colors.transparent,
        elevation: 0,
        backgroundColor: AppColors.OceanBlue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _confirmLocation,
            tooltip: 'حفظ الموقع',
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(
                33.5138,
                36.2765,
              ), // إحداثيات افتراضية
              initialZoom: 12.0,
              minZoom: 3.0,
              maxZoom: 19.0,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.graduationregistration',
              ),
              if (pickedPoint != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: pickedPoint!,
                      width: 64,
                      height: 64,
                      child: const Icon(
                        Icons.location_pin,
                        size: 64,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'save_btn',
                  onPressed: _confirmLocation,
                  tooltip: 'حفظ الموقع الحالي',
                  backgroundColor: pickedPoint != null
                      ? AppColors.CharcoalGrey
                      : AppColors.OceanBlue,
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'clear_btn',
                  onPressed: pickedPoint != null ? _clearSelection : null,
                  tooltip: 'مسح النقطة المحددة',
                  backgroundColor: pickedPoint != null
                      ? AppColors.CharcoalGrey
                      : AppColors.OceanBlue,
                  child: const Icon(
                    Icons.delete_sweep_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
