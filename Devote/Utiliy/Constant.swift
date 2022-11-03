//
//  Constant.swift
//  Devote
//
//  Created by Ege Aydemir on 29.10.2022.
//

import SwiftUI

// MARK: - Formatter
let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// MARK: - UI

var backgroundGradient: LinearGradient {
    return LinearGradient(colors: [Color.pink, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
}

// MARK: - UX 
