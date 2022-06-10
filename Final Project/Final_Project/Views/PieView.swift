//
//  PieView.swift
//  Final_Project
//
//  Created by Ben Stone on 6/2/22.
//

import SwiftUI
import SwiftUICharts

struct PieView: View {
    @EnvironmentObject var sleepRecordVM: SleepRecordViewModel
    
    @State var data: PieChartData = PieChartData(dataSets: PieDataSet(dataPoints: [], legendTitle: "legend"), metadata: ChartMetadata())
    
    
    func makeSet(sleepRecords: [SleepRecord]) -> [(SleepQuality, Double)] {
        var set: [(SleepQuality, Double)] = []
        var greatCount: Double = 0
        var goodCount: Double = 0
        var okCount: Double = 0
        var badCount: Double = 0
        for record in sleepRecords {
            if record.sleepQuality == .great {
                greatCount += 1
            } else if record.sleepQuality == .good {
                goodCount += 1
            } else if record.sleepQuality == .ok {
                okCount += 1
            } else if record.sleepQuality == .bad {
                badCount += 1
            }
        }
        set.append((.great ,greatCount))
        set.append((.good ,goodCount))
        set.append((.ok ,okCount))
        set.append((.bad, badCount))
        return set
    }
    
    func getData(qualityRecords: [(SleepQuality, Double)]) async -> PieChartData {
        var data = PieDataSet(
            dataPoints: [
                PieChartDataPoint(value: qualityRecords[0].1, description: qualityRecords[0].0.text,   colour: .blue  , label: .label(text: qualityRecords[0].0.emoji, font: .system(size: 40))),
                PieChartDataPoint(value: qualityRecords[1].1, description: qualityRecords[1].0.text,   colour: .red   , label: .label(text: qualityRecords[1].0.emoji, font: .system(size: 40))),
                PieChartDataPoint(value: qualityRecords[2].1, description: qualityRecords[2].0.text, colour: .purple, label: .label(text: qualityRecords[2].0.emoji, font: .system(size: 40))),
                PieChartDataPoint(value: qualityRecords[3].1, description: qualityRecords[3].0.text,  colour: .green , label: .label(text: qualityRecords[3].0.emoji, font: .system(size: 40)))
            ],
            legendTitle: "Data")
        
        data.dataPoints = data.dataPoints.filter({$0.value != 0})
        
        return PieChartData(dataSets: data,
                            metadata: ChartMetadata(title: "Sleep Quality", subtitle: "All time"),
                            chartStyle: PieChartStyle(infoBoxPlacement: .header), noDataText: Text("No data entered!"))
    }
    
    var pie: some View {
        VStack {
            PieChart(chartData: data)
                .touchOverlay(chartData: data)
                .headerBox(chartData: data)
                .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
                .id(data.id)
                .padding(.horizontal)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow()
            pie
                .task {
                    await data = getData(qualityRecords: makeSet(sleepRecords: sleepRecordVM.sleepRecords))
                }
                .padding()
        }
        .frame(height: 400)
    }
}

struct PieView_Previews: PreviewProvider {
    @ObservedObject static var sleepRecordVM = SleepRecordViewModel()
    static var previews: some View {
        PieView().environmentObject(sleepRecordVM)
    }
}
