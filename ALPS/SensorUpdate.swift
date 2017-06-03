//
//  SensorUpdate.swift
//  ALPS
//
//  Created by Jun Tanaka on 2017/06/04.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import Foundation

public enum SensorKey: String {
    case acceleration   = "acceleration"
    case magneticField  = "magnetic_field"
    case pressure       = "pressure"
    case humidity       = "humidity"
    case temperature    = "temperature"
    case uv             = "uv"
    case ambientLight   = "ambient_light"
}

public enum SensorParameter {
    case acceleration(x: Float, y: Float, z: Float)
    case magneticField(x: Float, y: Float, z: Float)
    case pressure(Float)
    case humidity(Float)
    case temperature(Float)
    case uv(Float)
    case ambientLight(Float)

    public var key: SensorKey {
        switch self {
        case .acceleration:
            return .acceleration
        case .magneticField:
            return .magneticField
        case .pressure:
            return .pressure
        case .humidity:
            return .humidity
        case .temperature:
            return .temperature
        case .uv:
            return .uv
        case .ambientLight:
            return .ambientLight
        }
    }

    public var value: Any {
        switch self {
        case let .acceleration(x, y, z):
            return ["x": x, "y": y, "z": z]
        case let .magneticField(x, y, z):
            return ["x": x, "y": y, "z": z]
        case let .pressure(value):
            return value
        case let .humidity(value):
            return value
        case let .temperature(value):
            return value
        case let .uv(value):
            return value
        case let .ambientLight(value):
            return value
        }
    }
}
