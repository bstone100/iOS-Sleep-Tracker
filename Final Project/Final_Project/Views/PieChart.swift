//
//  PieChart.swift
//  MyPieChart
//
//  Created by BLCKBIRDS on 07.06.21.
//

import SwiftUI

struct PieChart: View {
    
    var title: String
    var data: [ChartDatas]
    var separatorColor: Color
    var accentColors: [Color]
    
    @State  private var currentValue = ""
    @State  private var currentLabel = ""
    @State  private var touchLocation: CGPoint = .init(x: -1, y: -1)
    
    //Uncomment the following initializer to use fully generate random colors instead of using a custom color set
//    init(title: String, data: [ChartData], separatorColor: Color) {
//        self.title = title
//        self.data = data
//        self.separatorColor = separatorColor
//
//        accentColors    =   [Color]()
//        for _  in 0..<data.count  {
//           accentColors.append(Color.init(red: Double.random(in: 0.2...0.9), green: Double.random(in: 0.2...0.9), blue: Double.random(in: 0.2...0.9)))
//        }
//      }
    
    var pieSlices: [PieSlice] {
        var slices = [PieSlice]()
        data.enumerated().forEach {(index, data) in
            let value = normalizedValue(index: index, data: self.data)
            if slices.isEmpty    {
                slices.append((.init(startDegree: 0, endDegree: value * 360)))
            } else {
                slices.append(.init(startDegree: slices.last!.endDegree,    endDegree: (value * 360 + slices.last!.endDegree)))
            }
        }
        return slices
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20,style:.continuous)
                .fill(.white)
                .shadow(radius:10)
            VStack {
                VStack {
                    Text(title)
                        .bold()
                        .font(.largeTitle)
                    ZStack {
                        GeometryReader { geometry in
                            ZStack  {
                                ForEach(0..<self.data.count){ i in
                                    PieChartSlice(center: CGPoint(x: geometry.frame(in: .local).midX, y: geometry.frame(in:  .local).midY), radius: geometry.frame(in: .local).width/2, startDegree: pieSlices[i].startDegree, endDegree: pieSlices[i].endDegree, isTouched: sliceIsTouched(index: i, inPie: geometry.frame(in:  .local)), accentColor: accentColors[i], separatorColor: separatorColor)
                                }
                            }
                                .gesture(DragGesture(minimumDistance: 0)
                                        .onChanged({ position in
                                            let pieSize = geometry.frame(in: .local)
                                            touchLocation   =   position.location
                                            updateCurrentValue(inPie: pieSize)
                                        })
                                        .onEnded({ _ in
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                withAnimation(Animation.easeOut) {
                                                    resetValues()
                                                }
                                            }
                                        })
                                )
                        }
                        .frame(width:250,height: 250)
                            .aspectRatio(contentMode: .fit)
                        VStack  {
                            if !currentLabel.isEmpty   {
                                Text(currentLabel)
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                            }
                            
                            if !currentValue.isEmpty {
                                Text("\(currentValue)")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                            }
                        }
                        .padding()
                    }
                    VStack(alignment:   .leading)  {
                        ForEach(0..<data.count)   {    i in
                            HStack {
                                accentColors[i]
                                    .frame(width:20,height:20)
                                    .aspectRatio(contentMode: .fit)
                                    .padding(5)
                                Text(data[i].label)
                                    .font(.caption)
                                    .bold()
                            }
                        }
                    }
                    
                }
            }
        }
        .frame(width:360,height: 500)
        .padding()
        
    }
    
    
    func updateCurrentValue(inPie   pieSize:    CGRect)  {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation)    else    {return}
        let currentIndex = pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) ?? -1
        
        currentLabel = data[currentIndex].label
        currentValue = "\(data[currentIndex].value)"
    }
    
    func resetValues() {
        currentValue = ""
        currentLabel = ""
        touchLocation = .init(x: -1, y: -1)
    }
    
    func sliceIsTouched(index: Int, inPie pieSize: CGRect) -> Bool {
        guard let angle =   angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return false }
        return pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) == index
    }
    
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart(title: "Habit Pie", data: chartDataSet, separatorColor: Color(UIColor.systemBackground), accentColors: pieColors)
    }
}
