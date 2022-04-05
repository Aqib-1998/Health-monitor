import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/asset_paths.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/modules/models/device_model.dart';
import 'package:heatlth_monitor/app/modules/pages/views/add_device.dart';
import 'package:heatlth_monitor/app/modules/pages/views/landing_view.dart';
import 'package:heatlth_monitor/app/services/auth.dart';
import 'package:heatlth_monitor/app/widgets/custom_elevated_button.dart';
import 'package:heatlth_monitor/app/widgets/safe_area.dart';
import 'package:heatlth_monitor/app/widgets/select_device_widget.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SelectDevice extends StatefulWidget {
  final String uid;
  final AuthBase auth;
  const SelectDevice({Key? key, required this.uid, required this.auth})
      : super(key: key);

  @override
  State<SelectDevice> createState() => _SelectDeviceState();
}

List<DeviceModel> devicesList = [];
RoundedLoadingButtonController controller = RoundedLoadingButtonController();

class _SelectDeviceState extends State<SelectDevice> {
  @override
  Widget build(BuildContext context) {
    return SafeAreaWrapper(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: kAppCornerPadding,
              child: LargeText(text: "Manage Devices", textColor: kMainColor),
            ),
            SizedBox(
              height: 25.h,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.uid)
                    .collection('Connected Devices')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kMainColor,
                      ),
                    );
                  }
                  devicesList.clear();
                  return snapshot.data!.docs.isNotEmpty
                      ? ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map<dynamic, dynamic> devicesListMap =
                                snapshot.data!.docs[index].data()
                                    as Map<dynamic, dynamic>;
                            DeviceModel device = DeviceModel(
                              name: devicesListMap['Device Name'],
                              deviceId: devicesListMap['Device Id'],
                              devicePassword: devicesListMap['Device Password'],
                            );
                            devicesList.add(device);

                            return SelectDeviceWidget(
                                deviceId: devicesList[index].deviceId,
                                deviceName: devicesList[index].name,
                                ontap: () => Get.to(() => LandingView(
                                    uid: widget.uid,
                                    auth: widget.auth,
                                    deviceId: devicesList[index].deviceId)),
                                onLongPress: () => Get.defaultDialog(
                                    title: "Alert!",
                                    content: const Text(
                                        "Do you want to delete this device?"),
                                    cancel: TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('Cancel')),
                                    confirm: TextButton(
                                        onPressed: () async {
                                          try {
                                            Get.back();

                                            await FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(widget.uid)
                                                .collection("Connected Devices")
                                                .doc(
                                                    devicesList[index].deviceId)
                                                .delete()
                                                .then((value) {
                                              Get.snackbar("Alert",
                                                  "Selected device has been removed!",
                                                  backgroundColor:
                                                      Colors.white);
                                            });
                                          } on FirebaseException catch (e) {
                                            Get.snackbar('Error', e.message!,
                                                backgroundColor: Colors.white);
                                          }
                                        },
                                        child: Text(
                                          'Confrim',
                                          style: TextStyle(
                                              color: Colors.red.shade600),
                                        )),
                                    barrierDismissible: false));
                          },
                        )
                      : Center(
                          child: MediumText(
                              text: "No Device Added", textColor: kBlack),
                        );
                }),
            SizedBox(
              height: 25.h,
            ),
            CustomElevatedButton(
                icon: kAddWhiteSvg,
                text: "Add Device",
                ontap: () {
                  controller.reset();
                  Get.to(() => AddDevice(
                        uid: widget.uid,
                        auth: widget.auth,
                      ));
                },
                controller: controller),
            SizedBox(
              height: 25.h,
            )
          ],
        ),
      ),
    ));
  }
}
