//
//  EventCode.swift
//  ALPS
//
//  Created by Jun Tanaka on 2017/06/03.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import Foundation

struct Custom1Event {
    enum EventCode: UInt8 {
        case dataPacket1 = 0xF2
        case dataPacket2 = 0xF3
        case dataPacket3 = 0xE0
    }

    enum DataPacketError: Error {
        case invalidEventCode
    }

    struct DataPacket1 {
        var magneticField: MagneticField
        var acceleration: Acceleration

        init(bytes: [UInt8]) throws {
            guard EventCode(rawValue: bytes[0]) == .dataPacket1 else {
                throw DataPacketError.invalidEventCode
            }

            magneticField = MagneticField(bytes: Array(bytes[2...7]))
            acceleration = Acceleration(bytes: Array(bytes[8...13]))
        }
    }

    struct DataPacket2 {
        var pressure: Pressure
        var humidity: Humidity
        var temperature: Temperature
        var uv: UV
        var ambientLight: AmbientLight

        init(bytes: [UInt8]) throws {
            guard EventCode(rawValue: bytes[0]) == .dataPacket2 else {
                throw DataPacketError.invalidEventCode
            }

            pressure = Pressure(bytes: Array(bytes[2...3]))
            humidity = Humidity(bytes: Array(bytes[4...5]))
            temperature = Temperature(bytes: Array(bytes[6...7]))
            uv = UV(bytes: Array(bytes[8...9]))
            ambientLight = AmbientLight(bytes: Array(bytes[10...11]))
        }
    }

    struct DataPacket3 {
        var stError: UInt8
        var rssi: Int8
        var battery: UInt16
        var memFull: Bool
        var response: Response

        enum Response: UInt8 {
            case auto = 0
            case ack = 1
            case nack = 2
        }

        init(bytes: [UInt8]) throws {
            guard EventCode(rawValue: bytes[0]) == .dataPacket3 else {
                throw DataPacketError.invalidEventCode
            }

            stError = bytes[3]
            rssi = Int8(bitPattern: bytes[6])
            battery = UnsafePointer([bytes[7], bytes[8]])
                .withMemoryRebound(to: UInt16.self, capacity: 1) { $0.pointee }
            memFull = bytes[9] != 0
            response = Response(rawValue: bytes[10])!
        }
    }
}
