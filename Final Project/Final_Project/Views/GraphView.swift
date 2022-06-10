//
//  GraphView.swift
//  Final_Project
//
//  Created by Ben Stone on 5/26/22.
//

import SwiftUI
import SwiftUICharts

struct GraphView: View {
    @EnvironmentObject var sleepRecordVM: SleepRecordViewModel
    
    // sort nights first
    @State var data: BarChartData = BarChartData(dataSets: BarDataSet(dataPoints: []))
    
    func getData(sleepRecords: [SleepRecord]) async -> BarChartData {
        var points: [BarChartDataPoint] = []
        for record in sleepRecords {
            if (record.interval.duration >= 28800) {
                points.insert(BarChartDataPoint(value: record.interval.duration / 3600, xAxisLabel: record.sleepQuality.emoji, description: record.endDateFormatted, colour: ColourStyle(colour: .green)), at: 0)
            } else if (record.interval.duration >= 21600) {
                points.insert(BarChartDataPoint(value: record.interval.duration / 3600, xAxisLabel: record.sleepQuality.emoji, description: record.endDateFormatted, colour: ColourStyle(colour: .yellow)), at: 0)
            } else {
                points.insert(BarChartDataPoint(value: record.interval.duration / 3600, xAxisLabel: record.sleepQuality.emoji, description: record.endDateFormatted, colour: ColourStyle(colour: .red)), at: 0)
            }
        }
        let data = BarDataSet(dataPoints: points, legendTitle: "Data")

        let metadata = ChartMetadata(title: "Sleep Record", subtitle: "All time")

        let gridStyle = GridStyle(numberOfLines: 7,
            lineColour: Color(.lightGray).opacity(0.5),
            lineWidth: 1)

        let barStyle = BarStyle(barWidth: 0.8, cornerRadius: CornerRadius(top: 50, bottom: 0), colourFrom: .dataPoints, colour: ColourStyle(colour: .blue))


        let chartStyle = BarChartStyle(infoBoxPlacement: .header,
                                       markerType: .bottomLeading(),
                                       xAxisGridStyle: gridStyle,
                                       xAxisLabelPosition: .bottom,
                                       xAxisLabelsFrom: .dataPoint(),
                                       xAxisTitle: "Nights",
                                       yAxisGridStyle: gridStyle,
                                       yAxisLabelPosition: .leading,
                                       yAxisNumberOfLabels: 4,
                                       yAxisTitle: "Sleep Duration (h)",
                                       baseline: .zero,
                                       topLine: .maximumValue)
        return BarChartData(dataSets: data,
                            metadata: metadata,
                            barStyle: barStyle,
                            chartStyle: chartStyle,
                            noDataText: Text("No data entered!"))
    }
    
    var graph: some View {
        BarChart(chartData: data)
            .touchOverlay(chartData: data)
            .averageLine(chartData: data,
                         strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
            .xAxisGrid(chartData: data)
            .yAxisGrid(chartData: data)
            .xAxisLabels(chartData: data)
            .yAxisLabels(chartData: data)
            .headerBox(chartData: data)
            .id(data.id)
            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
            .padding(.horizontal)
            
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow()
            graph
                .task {
                    await data = getData(sleepRecords: sleepRecordVM.sleepRecords.sorted(by: {$0.sleepEnd > $1.sleepEnd}))
                }
                .padding()
        }
        .frame(height: 400)
    }
}

struct GraphView_Previews: PreviewProvider {
    @ObservedObject static var sleepRecordVM = SleepRecordViewModel()
    static var previews: some View {
        GraphView().environmentObject(sleepRecordVM)
    }
}
