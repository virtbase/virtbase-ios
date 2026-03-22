//
//  ServerStateUpdate.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 20.02.26.
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

import AppIntents

enum ServerStateUpdate: String, CaseIterable, AppEnum {

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Server Action"

    static var caseDisplayRepresentations: [ServerStateUpdate: DisplayRepresentation] = [
        .start: "Start",
        .stop: "Stop",
        .pause: "Pause",
        .resume: "Resume",
        .suspend: "Suspend",
        .reset: "Reset",
        .reboot: "Reboot",
        .shutdown: "Shutdown"
    ]
    case start = "start"
    case stop = "stop"
    case pause = "pause"
    case resume = "resume"
    case suspend = "suspend"
    case reset = "reset"
    case reboot = "reboot"
    case shutdown = "shutdown"
}
