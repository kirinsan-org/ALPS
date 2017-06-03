//
//  Data.swift
//  ALPS
//
//  Created by Jun Tanaka on 2017/06/03.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import Foundation

protocol BytesConvertible {
    init(bytes: [UInt8])
}

struct MagneticField: BytesConvertible {
    var x: Int16
    var y: Int16
    var z: Int16

    init(bytes: [UInt8]) {
        x = UnsafePointer(Array(bytes[0...1]))
            .withMemoryRebound(to: Int16.self, capacity: 1) { $0.pointee }
        y = UnsafePointer(Array(bytes[2...3]))
            .withMemoryRebound(to: Int16.self, capacity: 1) { $0.pointee }
        z = UnsafePointer(Array(bytes[4...5]))
            .withMemoryRebound(to: Int16.self, capacity: 1) { $0.pointee }
    }
}

struct Acceleration: BytesConvertible {
    var x: Int16
    var y: Int16
    var z: Int16

    init(bytes: [UInt8]) {
        x = UnsafePointer(Array(bytes[0...1]))
            .withMemoryRebound(to: Int16.self, capacity: 1) { $0.pointee }
        y = UnsafePointer(Array(bytes[2...3]))
            .withMemoryRebound(to: Int16.self, capacity: 1) { $0.pointee }
        z = UnsafePointer(Array(bytes[4...5]))
            .withMemoryRebound(to: Int16.self, capacity: 1) { $0.pointee }
    }
}

struct Pressure: BytesConvertible {
    var hPa: Float {
        return Float(rawValue) * 860 / 65535 + 250
    }

    var rawValue: UInt16

    init(bytes: [UInt8]) {
        rawValue = UnsafePointer(Array(bytes[0...1]))
            .withMemoryRebound(to: UInt16.self, capacity: 1) { $0.pointee }
    }
}

struct Humidity: BytesConvertible {
    var pRH: Float {
        return (Float(rawValue) - 896) / 64
    }

    var rawValue: UInt16

    init(bytes: [UInt8]) {
        rawValue = UnsafePointer(Array(bytes[0...1]))
            .withMemoryRebound(to: UInt16.self, capacity: 1) { $0.pointee }
    }
}

struct Temperature: BytesConvertible {
    var degC: Float {
        return (Float(rawValue) - 2096) / 50
    }

    var rawValue: UInt16

    init(bytes: [UInt8]) {
        rawValue = UnsafePointer(Array(bytes[0...1]))
            .withMemoryRebound(to: UInt16.self, capacity: 1) { $0.pointee }
    }
}

struct UV: BytesConvertible {
    var mW: Float {
        return Float(rawValue) / (100 * 0.388)
    }

    var rawValue: UInt16

    init(bytes: [UInt8]) {
        rawValue = UnsafePointer(Array(bytes[0...1]))
            .withMemoryRebound(to: UInt16.self, capacity: 1) { $0.pointee }
    }
}

struct AmbientLight: BytesConvertible {
    enum LightSource {
        case sun
        case led
        case fluorescent
    }

    func lx(with lightSource: LightSource) -> Float {
        switch lightSource {
        case .sun:
            return Float(rawValue) / (0.05 * 0.928)
        case .led:
            return Float(rawValue) / (0.05 * 0.928 * 0.58)
        case .fluorescent:
            return Float(rawValue) / (0.05 * 0.928 * 0.44)
        }
    }

    var rawValue: UInt16

    init(bytes: [UInt8]) {
        rawValue = UnsafePointer(Array(bytes[0...1]))
            .withMemoryRebound(to: UInt16.self, capacity: 1) { $0.pointee }
    }
}
