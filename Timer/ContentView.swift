//
//  ContentView.swift
//  Timer
//
//  Created by 陈世彦 on 2/5/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerModel: TimerModel
    var body: some View {
        Home()
            .environmentObject(timerModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerModel())
    }
}
