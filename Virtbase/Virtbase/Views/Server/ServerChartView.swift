//
//  ServerChartView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 18.02.26.
//

/*
 *   Copyright (c) 2026 Karl Ehrlich
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import SwiftUI
import Charts

struct ChartSample {
    var time: Date
    var metric: ChartFeatures
    var value: Double
}

enum ChartFeatures: CaseIterable {
    case processor
    case memory
    case networkIncoming
    case networkOutgoing
    case diskWrite
    case diskRead
}

struct ServerChartView: View {
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @StateObject private
    var viewModel: ServerGraphViewModel = .init()
    
    var server: Server
    var features: [ChartFeatures]
    
    private func label(for feature: ChartFeatures) -> String {
        switch feature {
        case .processor:       return "CPU"
        case .memory:          return "RAM"
        case .networkIncoming: return "Eingehend"
        case .networkOutgoing: return "Ausgehend"
        case .diskWrite:       return "Schreiben"
        case .diskRead:        return "Lesen"
        }
    }
    
    private func color(for feature: ChartFeatures) -> Color {
        switch feature {
        case .processor:       return .blue
        case .memory:          return .green
        case .networkIncoming: return .purple
        case .networkOutgoing: return .cyan
        case .diskWrite:       return .orange
        case .diskRead:        return .red
        }
    }
    
    private func values(for feature: ChartFeatures, from samples: [ServerGraph]) -> [Double] {
        switch feature {
        case .processor:       return samples.map(\.processor)
        case .memory:          return samples.map { $0.memory / max($0.maximumMemory, 1) }
        case .networkIncoming: return samples.map(\.networkIncoming)
        case .networkOutgoing: return samples.map(\.networkOutgoing)
        case .diskWrite:       return samples.map(\.diskWrite)
        case .diskRead:        return samples.map(\.diskRead)
        }
    }
    
    private func normalize(_ values: [Double]) -> [Double] {
        let m = values.max() ?? 1
        guard m > 0 else { return values.map { _ in 0 } }
        return values.map { $0 / m }
    }
    
    private func chartData(from samples: [ServerGraph]) -> [ChartSample] {
        var result: [ChartSample] = []
        for feature in features {
            let raw = values(for: feature, from: samples)
            let vals = feature == .memory ? raw : normalize(raw)
            for (i, s) in samples.enumerated() {
                result.append(.init(time: s.time, metric: feature, value: vals[i]))
            }
        }
        return result
    }
    
    var body: some View {
        ZStack {
            if viewModel.status == .succeeded, let samples = viewModel.samples {
                let data = chartData(from: samples)
                Chart {
                    ForEach(data, id: \.time) { point in
                        LineMark(
                            x: .value("Zeit", point.time),
                            y: .value("Wert", point.value)
                        )
                        .foregroundStyle(by: .value("Metrik", label(for: point.metric)))
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 1.5))
                    }
                }
                .chartYScale(domain: 0...1)
                .chartYAxis(.hidden)
                .chartXAxis(.visible)
                .chartForegroundStyleScale(
                    domain: features.map { label(for: $0) },
                    range: features.map { color(for: $0) }
                )
            }  else {
                HandlerView(status: viewModel.status)
            }
        }
        .task {
            await viewModel.fetch(
                session: authentication.session,
                server: server
            )
        }
        .onReceive(Upstream.refreshed) { _ in
            Task {
                await viewModel.fetch(
                    session: authentication.session,
                    server: server
                )
            }
        }
    }
}
