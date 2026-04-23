//
//  gradientColors.swift
//  hiking
//
//  Created by muhammad aqil zaki on 23/04/26.
//

import SwiftUI

func gradientColors(_ grade: Grade) -> [Color] {
    switch grade {
    case .i:   return [.green.opacity(0.85), .teal]
    case .ii:  return [.blue.opacity(0.85), .cyan.opacity(0.7)]
    case .iii: return [Color(red: 0.73, green: 0.46, blue: 0.09), .orange.opacity(0.75)]
    case .iv:  return [.red.opacity(0.85), .orange.opacity(0.7)]
    case .v:   return [.purple, .indigo]
    }
}
