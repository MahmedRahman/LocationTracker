import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker ..'),
        centerTitle: true,
      ),
      body: Obx(() {
        return FutureBuilder(
            future: controller.FutureList.value,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data![0]);
                return ListView(
                  children: List.generate(snapshot.data!.length, (index) {
                    Position position = snapshot.data![index];
                    double distanceInMeters = 0;
                    if (index != 0) {
                      Position LastPosition = snapshot.data![index - 1];
                      distanceInMeters = Geolocator.distanceBetween(
                          LastPosition.latitude,
                          LastPosition.longitude,
                          position.latitude,
                          position.longitude);
                    }

                    return defaultMapCard(
                        latitude: position.latitude,
                        longitude: position.longitude,
                        distanceInMeters: distanceInMeters);
                  }),
                );
              } else {
                return Text('Get Your Location .... ');
              }
            });
      }),
    );
  }

  defaultMapCard({latitude, longitude, distanceInMeters}) => Card(
        child: ListTile(
          leading: Icon(Icons.map),
          title: Row(
            children: [
              Text('latitude : '),
              Text(latitude.toString()),
            ],
          ),
          subtitle: Row(
            children: [
              Text('longitude : '),
              Text(longitude.toString()),
            ],
          ),
          trailing: Text(distanceInMeters.toStringAsPrecision(3) + " M"),
        ),
      );
}
