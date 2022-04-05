class ChartModel {
  int chartData;
  int num;
  ChartModel({
    required this.chartData,
    required this.num,
  });
}

final List<ChartModel> chartData = [
  ChartModel(chartData: 86, num: 1),
  ChartModel(chartData: 90, num: 2),
  ChartModel(chartData: 80, num: 3),
  ChartModel(chartData: 75, num: 4),
];

class TemperatureChartModel {
  double chartData;
  int num;
  TemperatureChartModel({
    required this.chartData,
    required this.num,
  });
}
