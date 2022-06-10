import SwiftUI
import SwiftUICharts

struct ctView: View {
//    @Binding var nights: [DateInterval]
    @EnvironmentObject var sleepRecordVM: SleepRecordViewModel
    
    @State var timeFormatterArray: Any=[]
    @State var timediff=[]
    
    func getTimediff() -> Array<Double> {
        var durationArr:[Double]=[]
        for record in sleepRecordVM.sleepRecords {
            durationArr.append(record.interval.duration)
        }
        return durationArr
    }

    @State var dateform:DateFormatter={
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()
    
    func getDate()->Array<String>{
        var startdate:[String]=[]
        for record in sleepRecordVM.sleepRecords {
            let date = record.sleepStart
            let dating=date.formatted( .dateTime.day().month().year())
            startdate.append(dating)
        }
        return startdate
    }
    
    func getValue()->Any{
        var values:[(String,Int)]=[]
        for record in sleepRecordVM.sleepRecords {
            let date = record.sleepStart
            let dating=date.formatted( .dateTime.day().month().year())
            values.insert((dating,Int((record.interval.duration)/3600)),at:0)
        }
        return values
    }
    
    var body: some View {

        let values:[(String,Int)]=getValue() as! [(String, Int)]
        
        VStack {
            BarChartView(data: ChartData(values:  values), title: "Hours", legend: "Date", form: ChartForm.extraLarge)
            Spacer()
        }
        
    }
}

struct ctView_Previews: PreviewProvider {
    //@State var nights:[DateInterval]=[]
    @ObservedObject static var sleepRecordVM = SleepRecordViewModel(sleepRecords: TestData.generateRecords())
    static var previews: some View {
        ctView().environmentObject(sleepRecordVM)
    }
}
