//
//  TemperatureSelectiongView.swift
//  SymptomTracker
//
//  Created by Tim Yoon on 2/16/22.
//

import SwiftUI

struct TemperatureSelectiongView: View {
    @State var temperature : Double = 97.6
    @State var isShowingSlider : Bool = false
    var body: some View {
        VStack{
            Toggle("show fever", isOn: $isShowingSlider)
            if isShowingSlider {
                HStack{
                    Text("\(temperature)")
                    Slider(value: $temperature, in: 95.0...105) {
                        Text("Temperature")
                    }
                }
            }
        }
    }
}

struct TemperatureSelectiongView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureSelectiongView()
    }
}
