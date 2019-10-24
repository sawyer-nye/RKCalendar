//
//  RKTimeView.swift
//  RKCalendar
//
//  Created by Ringo Wathelet on 2019/10/23.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKTimeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var rkManager: RKManager
    
    @Binding var date: Date
    @Binding var showTime: Bool
    @Binding var hasTime: Bool
    
    var todayRange: ClosedRange<Date> {
        let min = Calendar.current.startOfDay(for: date)
        let max = min.addingTimeInterval(60*60*24)
        return min...max
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("", selection: self.$date, in: todayRange, displayedComponents: .hourAndMinute)
            }.navigationBarTitle(Text("Time setting"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: self.onDone ) { Text("Done") })
                .onDisappear(perform: doExit)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func onDone() {
        // to go back to the previous view passing through doExit
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func doExit() {
        switch rkManager.mode {
        case 0:
            rkManager.selectedDate = date
        case 1:
            break
        case 2:
            break
        case 3:
            if let ndx = rkManager.selectedDates.firstIndex(where: {
                rkManager.calendar.isDate($0, inSameDayAs: date)}) {
                rkManager.selectedDates[ndx] = date
            }
        default:
            break
        }
        showTime = false
        hasTime.toggle()
    }
    
}


struct RKTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RKTimeView(rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), date: .constant(Date()), showTime: .constant(false), hasTime: .constant(false))
    }
}
