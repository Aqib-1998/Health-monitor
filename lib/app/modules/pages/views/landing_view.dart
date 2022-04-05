import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/asset_paths.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/modules/pages/views/history.dart';
import 'package:heatlth_monitor/app/modules/pages/views/homepage.dart';
import 'package:heatlth_monitor/app/modules/pages/views/measurement_page.dart';
import 'package:heatlth_monitor/app/modules/pages/views/profile_page.dart';
import 'package:heatlth_monitor/app/widgets/safe_area.dart';

import '../../../services/auth.dart';

class LandingView extends StatefulWidget {
  final String uid;
  final AuthBase auth;
  final String deviceId;
  const LandingView(
      {Key? key, required this.uid, required this.auth, required this.deviceId})
      : super(key: key);

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  Widget build(BuildContext context) {
    final Rx<int> tabIndex = 0.obs;
    final RxList<Widget> pages = <Widget>[
      HomePage(deviceId: widget.deviceId, uid: widget.uid),
      MeasurementPage(
        deviceId: widget.deviceId,
        uid: widget.uid,
      ),
      HistoryPage(uid: widget.uid),
      ProfilePage(auth: widget.auth, uid: widget.uid),
    ].obs;
    return SafeAreaWrapper(
        child: Obx(() => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: TextButton(
                    onPressed: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: kMainColor,
                    )),
              ),
              body: pages.elementAt(tabIndex.value),
              bottomNavigationBar: Container(
                height: Get.height * 0.1,
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: kMainColor.withOpacity(0.35), width: 0.5)),
                ),
                child: BottomNavigationBar(
                  onTap: (index) {
                    tabIndex.value = index;
                  },
                  backgroundColor: kGrey,
                  elevation: 5,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: kMainColor,
                  iconSize: 30,
                  unselectedItemColor: kMainColor.withOpacity(0.35),
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  currentIndex: tabIndex.value,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        kHomeSvg,
                        color: tabIndex.value == 0
                            ? kMainColor
                            : kMainColor.withOpacity(0.35),
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(kAddSvg,
                          color: tabIndex.value == 1
                              ? kMainColor
                              : kMainColor.withOpacity(0.35)),
                      label: 'Measurement',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(kHistorySvg,
                          color: tabIndex.value == 2
                              ? kMainColor
                              : kMainColor.withOpacity(0.35)),
                      label: 'History',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(kProfileSvg,
                          color: tabIndex.value == 3
                              ? kMainColor
                              : kMainColor.withOpacity(0.35)),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            )));
  }
}
