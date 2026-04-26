//
//  AccentView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 22.04.26.
//

import SwiftUI

struct AccentListView: View {
    
    var label: LocalizedStringResource
    var color: Color
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10)
                .foregroundStyle(color)
                .padding(.horizontal, 5)
            
            Text(label)
        }
    }
}

struct AccentView: View {
    
    // 2 default for indigo
    @AppStorage("application.accent")
    private var accent: Int = 2
    
    var body: some View {
        NavigationStack {
            List {
                Section("Farben") {
                    Picker("Akzentfarbe", selection: $accent) {
                        AccentListView(label: "Standard", color: .gray) .tag(0)
                        AccentListView(label: "Rot", color: .red) .tag(1)
                        AccentListView(label: "Orange", color: .orange) .tag(2)
                        AccentListView(label: "Blau", color: .blue) .tag(3)
                        AccentListView(label: "Grün", color: .green) .tag(4)
                        AccentListView(label: "Minze", color: .mint) .tag(5)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle("Akzent")
        }
    }
}

#Preview {
    AccentView()
}
