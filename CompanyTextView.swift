//
//  File.swift
//  SpaceXNetwork
//
//  Created by David Tudor on 12/05/2025.
//

import Foundation
import SwiftUI


struct CompanyTextView: View {
    // Make company info string view
    let companyData: Company?
    
    init(_ companyData: Company?) {
        self.companyData = companyData
    }
    
    var body: some View {
        HStack {
            if let c = companyData {
                Text("\(c.name) was founded by \(c.founder) in \(String(c.founded)). It has now \(c.employees) employees, \(c.launch_sites) launch sites, and is valued at \(c.valuation) USD.")
            } else {
                Text("companyData not found.")
            }
        }
    }
}

