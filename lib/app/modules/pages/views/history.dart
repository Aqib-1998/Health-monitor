import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/modules/models/chart_model.dart';
import 'package:heatlth_monitor/app/modules/models/history_model.dart';
import 'package:heatlth_monitor/app/widgets/history_widget.dart';
import 'package:heatlth_monitor/app/widgets/text_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoryPage extends StatefulWidget {
  final String uid;
  const HistoryPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

RxBool graphView = false.obs;
late List<ChartModel> bpm = [];
late List<ChartModel> spo2 = [];
late List<TemperatureChartModel> temperature = [];

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: LargeText(text: "History", textColor: kMainColor),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: kAppCornerPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      graphView.value = !graphView.value;
                    },
                    child: MediumText(
                        text: !graphView.value ? "Graph View" : "List View",
                        textColor: kMainColor)),
                TextButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(widget.uid)
                          .collection("History")
                          .get()
                          .then((value) {
                        for (DocumentSnapshot ds in value.docs) {
                          ds.reference.delete();
                        }
                      }).whenComplete(() => Get.snackbar(
                              "Alert!", "History Cleared!",
                              backgroundColor: kWhiteColor));
                    },
                    child:
                        MediumText(text: "Clear all", textColor: Colors.red)),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          if (!graphView.value)
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(widget.uid)
                    .collection("History")
                    .orderBy("dateTime", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: kMainColor,
                      ),
                    );
                  }

                  return Expanded(
                    child: snapshot.data!.docs.isNotEmpty
                        ? ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              History history = History.fromMap(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);

                              return HistoryWidget(
                                history: history,
                                onLongPress: () {
                                  Get.defaultDialog(
                                      title: "Alert!",
                                      content: const Text(
                                          "Do you want to delete this history?"),
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
                                                  .collection("History")
                                                  .doc(history.id)
                                                  .delete();
                                            } on FirebaseException catch (e) {
                                              Get.snackbar('Error', e.message!,
                                                  backgroundColor:
                                                      Colors.white);
                                            }
                                          },
                                          child: Text(
                                            'Confrim',
                                            style: TextStyle(
                                                color: Colors.red.shade600),
                                          )),
                                      barrierDismissible: false);
                                },
                              );
                            },
                            separatorBuilder: (ctx, index) {
                              return SizedBox(
                                height: 10.h,
                              );
                            },
                            itemCount: snapshot.data!.docs.length)
                        : Center(
                            child: MediumText(
                                text: "No History yet!", textColor: kBlack),
                          ),
                  );
                })
          else
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(widget.uid)
                      .collection("History")
                      .orderBy("dateTime", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: kMainColor,
                        ),
                      );
                    }
                    bpm.clear();
                    spo2.clear();
                    temperature.clear();
                    for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      History history = History.fromMap(snapshot.data!.docs[i]
                          .data() as Map<String, dynamic>);
                      String bpmStr = history.bpm.replaceAll("BPM", '');
                      String spo2Str = history.spo2.replaceAll("%", '');
                      String tempStr = history.temperature.replaceAll("°C", '');
                      bpmStr = double.parse(bpmStr).toStringAsFixed(0);
                      spo2Str = double.parse(spo2Str).toStringAsFixed(0);
                      tempStr = double.parse(tempStr).toStringAsFixed(1);

                      ChartModel dummyChartBpm =
                          ChartModel(chartData: int.parse(bpmStr), num: i + 1);
                      ChartModel dummyChartSpo2 =
                          ChartModel(chartData: int.parse(spo2Str), num: i + 1);
                      TemperatureChartModel dummyChartTemp =
                          TemperatureChartModel(
                              chartData: double.parse(tempStr), num: i + 1);

                      bpm.add(dummyChartBpm);
                      spo2.add(dummyChartSpo2);
                      temperature.add(dummyChartTemp);
                    }

                    return snapshot.data!.docs.isNotEmpty
                        ? ListView(
                            children: [
                              Container(
                                height: 200.h,
                                margin: EdgeInsets.symmetric(vertical: 20.h),
                                child: SfCartesianChart(
                                  enableAxisAnimation: true,
                                  tooltipBehavior: TooltipBehavior(
                                      enable: true,
                                      canShowMarker: false,
                                      format: "point.y BPM",
                                      decimalPlaces: 0,
                                      header: ''),
                                  primaryXAxis: NumericAxis(isVisible: false),
                                  title: ChartTitle(text: "Heart rate"),
                                  series: <ChartSeries>[
                                    LineSeries<ChartModel, int>(
                                        dataSource: bpm,
                                        enableTooltip: true,
                                        color: Colors.red[800],
                                        xValueMapper: (ChartModel data, _) =>
                                            data.num,
                                        yValueMapper: (ChartModel data, _) =>
                                            data.chartData,
                                        markerSettings:
                                            MarkerSettings(isVisible: true))
                                  ],
                                ),
                              ),
                              Container(
                                height: 200.h,
                                margin: EdgeInsets.symmetric(vertical: 20.h),
                                child: SfCartesianChart(
                                  enableAxisAnimation: true,
                                  primaryXAxis: NumericAxis(isVisible: false),
                                  tooltipBehavior: TooltipBehavior(
                                      enable: true,
                                      canShowMarker: false,
                                      format: "point.y %",
                                      decimalPlaces: 0,
                                      header: ''),
                                  primaryYAxis: NumericAxis(
                                    isVisible: true,
                                    desiredIntervals: 3,
                                    maximum: 100.0,
                                    minimum: 94.0,
                                  ),
                                  title: ChartTitle(text: "SPO2"),
                                  series: <ChartSeries>[
                                    LineSeries<ChartModel, int>(
                                        dataSource: spo2,
                                        enableTooltip: true,
                                        color: Colors.yellow[800],
                                        xValueMapper: (ChartModel data, _) =>
                                            data.num,
                                        yValueMapper: (ChartModel data, _) =>
                                            data.chartData,
                                        markerSettings:
                                            MarkerSettings(isVisible: true))
                                  ],
                                ),
                              ),
                              Container(
                                height: 200.h,
                                margin: EdgeInsets.symmetric(vertical: 20.h),
                                child: SfCartesianChart(
                                  enableAxisAnimation: true,
                                  primaryYAxis: NumericAxis(
                                      isVisible: true,
                                      desiredIntervals: 3,
                                      maximum: 38.0,
                                      minimum: 22.0,
                                      decimalPlaces: 1),
                                  primaryXAxis: NumericAxis(
                                    isVisible: false,
                                  ),
                                  title: ChartTitle(text: "Temperature"),
                                  tooltipBehavior: TooltipBehavior(
                                      enable: true,
                                      canShowMarker: false,
                                      format: "point.y °C",
                                      decimalPlaces: 1,
                                      header: ''),
                                  series: <ChartSeries>[
                                    LineSeries<TemperatureChartModel, int>(
                                        enableTooltip: true,
                                        dataSource: temperature,
                                        color: Colors.red,
                                        xValueMapper:
                                            (TemperatureChartModel data, _) =>
                                                data.num,
                                        yValueMapper:
                                            (TemperatureChartModel data, _) =>
                                                data.chartData,
                                        markerSettings:
                                            MarkerSettings(isVisible: true))
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: MediumText(
                                text: "No History yet!", textColor: kBlack),
                          );
                  }),
            )
        ],
      );
    });
  }

  @override
  void initState() {
    bpm.clear();
    temperature.clear();
    spo2.clear();
    super.initState();
  }
}
