//
//  HikingTabContainerView.swift
//  hiking
//
//  Created by muhammad aqil zaki on 15/04/26.
//

import SwiftUI


struct HikingTabContainerView: View {
    let trip: Trip

    var body: some View {
        TabView {

            // TAB 1 -
            HikingTrackingView(trip: trip)
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Tracking")
                }

            // TAB 2 - Checklist
            HikingChecklistView(trip: trip)
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Checklist")
                }
            
        }
        
            }
        }
    
    
