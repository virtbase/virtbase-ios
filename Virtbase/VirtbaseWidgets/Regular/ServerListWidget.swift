//
//  ServerListWidget.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 02.03.26.
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
import Alamofire
import SwiftUI

struct WidgetServer: Identifiable {
    var id: UUID = .init()
    
    let server: Server
    let status: ServerStatus?
}

struct ServerListEntry: TimelineEntry {
    let date: Date
    let servers: [WidgetServer]?
}

struct ServerListaProvider: TimelineProvider {
    
    let session = Session(
        configuration: .ephemeral,
        interceptor: InterceptorModel()
    )
    
    
    func placeholder(in context: Context) -> ServerListEntry {
        return ServerListEntry(date: .now, servers: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (ServerListEntry) -> Void) {
        Task {
            let servers = await servers()
            let entry = ServerListEntry(date: .now, servers: servers)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ServerListEntry>) -> Void) {
        Task {
            let servers = await servers()
            let entry = ServerListEntry(date: .now, servers: servers)
            let refresh = Date.now.addingTimeInterval(15 * 60)
            completion(Timeline(entries: [entry], policy: .after(refresh)))
        }
    }
    
    private func status(server: Server) async -> ServerStatus? {
        let address = (
            "https://virtbase.com/api/v1"
            + "/kvm/\(server.id)/status"
        )
        
        let state = try? await session.request(
            address,
            method: .get
        )
        .validate()
        .serializingDecodable(ServerState.self)
        .value.status
        
        return state
    }
    
    private func servers() async -> [WidgetServer]? {
        let address = (
            "https://virtbase.com/api/v1"
            + "/kvm/owned"
        )
        
        let servers = try? await session.request(
            address,
            method: .get
        )
        .validate()
        .serializingDecodable([Server].self)
        .value
        
        guard let servers else { return nil }
        
        var temporary: [WidgetServer] = []
        
        for server in servers {
            let status = await status(server: server)
            temporary.append(WidgetServer(server: server, status: status))
        }
        
        return temporary
    }
}

struct ServerListWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.virtbase.ServerList", provider: ServerListaProvider()) { entry in
            if let servers = entry.servers {
                if !servers.isEmpty {
                    VStack {
                        ForEach(servers.prefix(4)) { server in
                            HStack {
                                Text(server.server.name)
                                    .monospaced()
                                    .padding(.trailing, 5)
                                
                                switch server.status {
                                case .running:
                                    Image(systemName: "play.fill")
                                        .foregroundStyle(.green)
                                        .font(.caption)
                                    
                                    Text("Läuft")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                case .none, .unknown:
                                    Image(systemName: "questionmark")
                                        .foregroundStyle(.gray)
                                        .font(.caption)
                                    
                                    Text("Unbekannt")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                case .stopped:
                                    Image(systemName: "stop.fill")
                                        .foregroundStyle(.red)
                                        .font(.caption)
                                    
                                    Text("Gestoppt")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                case .paused:
                                    Image(systemName: "pause.fill")
                                        .foregroundStyle(.yellow)
                                        .font(.caption)
                                    
                                    Text("Pausiert")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                case .suspended:
                                    Image(systemName: "moon.fill")
                                        .foregroundStyle(.yellow)
                                        .font(.caption)
                                    
                                    Text("Suspendiert")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                }
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                } else {
                    VStack(spacing: 5) {
                        Image(systemName: "square.stack.3d.up.slash")
                            .foregroundStyle(.tertiary)
                            .font(.largeTitle)
                        
                        Text("Keine Server")
                            .font(.headline)
                        Text("Du hast noch keine Server in deinem Account hinzugefügt. Öffne Virtbase, um deinen ersten Server einzurichten.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                }
            } else {
                VStack(spacing: 5) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.tertiary)
                        .font(.largeTitle)
                    
                    Text("Nicht angemeldet")
                        .font(.headline)
                    Text("Deine Server konnten nicht geladen werden. Überprüfe deine Internetverbindung, oder ob du angemeldet bist.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            }
        }
        .configurationDisplayName("Meine Server")
        .description("Mit diesem Widget kannst du dir deine Server als Übersicht hinzufügen.")
        .supportedFamilies([.systemMedium])
        .containerBackgroundRemovable()
    }
}
