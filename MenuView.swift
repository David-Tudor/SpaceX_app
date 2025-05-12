////
////  File.swift
////  SpaceXNetwork
////
////  Created by David Tudor on 12/05/2025.
////
//
//import Foundation
//import SwiftUI
//
//
//struct MenuView: View {
//    
//    var body: some View {
//        Menu {
//            
//            Button("Refresh") {
//                pullData()
//            }
//            Divider()
//            
//            Toggle("Successful rockets only", isOn: $should_only_show_successes)
//            Divider()
//            
//            VStack {
//                Text("Number of launches shown:")
//                HStack {
//                    Slider( // XXX Why does this look weird?
//                        value: $numLaunchesShown,
//                        in:    1...20,
//                        step: 1,
//                    )
//                    Text("\(Int(numLaunchesShown))")
//                }
//                
//                
//            }
//            
//        } label: {
//            Image(systemName: "gear")
//                .font(.system(size: 24))
//        }
//    }
//}
