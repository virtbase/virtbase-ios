//
//  ServerGraphWidget.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 03.03.26.
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

import WidgetKit
import Charts
import AppIntents
import Alamofire
import SwiftUI


struct ServerGraphSelectionIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Server auswählen"
    static var description = IntentDescription("Wähle den Server, der angezeigt werden soll.")

    @Parameter(title: "Server")
    var server: ServerGraphEntity?
}

struct ServerGraphEntity: AppEntity {
    
    var id: String
    var server: Server
    
    var samples: [ServerGraph]?
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Server")
    static var defaultQuery = ServerGraphEntityQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(server.name)")
    }
}

struct ServerGraphEntityQuery: EntityQuery {
    
    let session = Session(
        configuration: .ephemeral,
        interceptor: InterceptorModel()
    )

    func entities(for identifiers: [String]) async throws -> [ServerGraphEntity] {
        let all = try await fetchAll()
        return all.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [ServerGraphEntity] {
        try await fetchAll()
    }

    private func fetchAll() async throws -> [ServerGraphEntity] {
        let servers = try await session.request(
            "https://virtbase.com/api/v1/kvm/owned",
            method: .get
        )
        .validate()
        .serializingDecodable([Server].self)
        .value

        return servers.map { ServerGraphEntity(id: $0.id, server: $0) }
    }
}

struct ServerGraphEntry: TimelineEntry {
    let date: Date
    let samples: [ServerGraph]?
}

struct ServerGraphProvider: AppIntentTimelineProvider {
    
    let session = Session(
        configuration: .ephemeral,
        interceptor: InterceptorModel()
    )
    
    func placeholder(in context: Context) -> ServerGraphEntry {
        ServerGraphEntry(date: .now, samples: nil)
    }

    func snapshot(for configuration: ServerGraphSelectionIntent, in context: Context) async -> ServerGraphEntry {
        guard let server = configuration.server else {
            return ServerGraphEntry(date: .now, samples: nil)
        }
        
        let samples = await samples(server: server.server)
        return ServerGraphEntry(date: .now, samples: samples)
    }

    func timeline(for configuration: ServerGraphSelectionIntent, in context: Context) async -> Timeline<ServerGraphEntry> {
        guard let server = configuration.server else {
            return Timeline(entries: [], policy: .atEnd)
        }
        
        let samples = await samples(server: server.server)
        let entry = ServerGraphEntry(date: .now, samples: samples)
        let refresh = Date.now.addingTimeInterval(15 * 60)
        return Timeline(entries: [entry], policy: .after(refresh))
    }
    
    private func samples(server: Server) async -> [ServerGraph]? {
        
        let address = (
            "https://virtbase.com/api/v1"
            + "/kvm/\(server.id)/graphs"
            + "?timeframe=hour"
        )
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let samples = try? await session.request(
            address,
            method: .get
        )
        .validate()
        .serializingDecodable(
            [ServerGraph].self,
            decoder: decoder
        )
        .value
        
        return samples
    }
}

enum ChartFeatures: CaseIterable {
    case processor
    case memory
    case networkIncoming
    case networkOutgoing
    case diskWrite
    case diskRead
}
struct ServerChartWidgetView: View {
    let samples: [ServerGraph]

    private func label(for feature: ChartFeatures) -> String {
        switch feature {
        case .processor:       return "CPU"
        case .memory:          return "RAM"
        case .networkIncoming: return "Net In"
        case .networkOutgoing: return "Net Out"
        case .diskWrite:       return "Disk W"
        case .diskRead:        return "Disk R"
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

    private func values(for feature: ChartFeatures) -> [Double] {
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

    var body: some View {
        Chart {
            ForEach(ChartFeatures.allCases, id: \.self) { feature in
                let raw = values(for: feature)
                let vals = feature == .memory ? raw : normalize(raw)
                ForEach(samples.indices, id: \.self) { i in
                    LineMark(
                        x: .value("Zeit", samples[i].time),
                        y: .value("Wert", vals[i])
                    )
                    .foregroundStyle(by: .value("Metrik", label(for: feature)))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 1.5))
                }
            }
        }
        .chartYScale(domain: 0...1)
        .chartYAxis(.hidden)
        .chartXAxis(.visible)
        .chartLegend(.hidden)
        .chartForegroundStyleScale(
            domain: ChartFeatures.allCases.map { label(for: $0) },
            range: ChartFeatures.allCases.map { color(for: $0) }
        )
    }
}

struct ServerGraphWidgetView: View {
    let entry: ServerGraphEntry
    var body: some View {
        if let samples = entry.samples {
            ServerChartWidgetView(samples: samples)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            VStack(spacing: 5) {
                Image(systemName: "server.rack")
                    .foregroundStyle(.tertiary)
                    .font(.largeTitle)

                Text("Keine Daten")
                    .font(.headline)
                Text("Halte das Widget gedrückt, um einen Server auszuwählen.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            .padding(10)
        }
    }
}

struct ServerGraphWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "com.virtbase.ServerGraph",
        intent: ServerGraphSelectionIntent.self,
            provider: ServerGraphProvider()
        ) { entry in
            ServerGraphWidgetView(entry: entry)
        }
        .configurationDisplayName("Server")
        .description("Zeigt einen einzelnen Server an.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .containerBackgroundRemovable()
    }
}
