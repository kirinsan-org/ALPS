//
//  Peripheral.swift
//  ALPS
//
//  Created by Jun Tanaka on 2017/06/04.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import CoreBluetooth

public protocol PeripheralDelegate: class {
    func peripheral(_ peripheral: Peripheral, didUpdateSensor parameters: [SensorParameter])
}

public final class Peripheral: NSObject {
    public var uuid: UUID {
        return cbPeripheral.identifier
    }

    public internal(set) var rssi: Int

    public weak var delegate: PeripheralDelegate?

    internal let cbPeripheral: CBPeripheral

    internal init(cbPeripheral: CBPeripheral, rssi: Int) {
        self.cbPeripheral = cbPeripheral
        self.rssi = rssi

        super.init()

        cbPeripheral.delegate = self
    }
}

extension Peripheral: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("failed to discover services with \(error)")
            return
        }

        guard let service = peripheral.services?.first else {
            print("services not found in \(peripheral)")
            return
        }

        peripheral.discoverCharacteristics([
            Characteristic.custom1.cbUUID,
            Characteristic.custom2.cbUUID,
            Characteristic.custom3.cbUUID
        ], for: service)
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("failed to discover characteristics for \(service) with \(error)")
            return
        }

        service.characteristics?.forEach { characteristic in
            switch characteristic.uuid.uuidString {
            case Characteristic.custom1.rawValue:
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)

            case Characteristic.custom3.rawValue:
                let data = Data(bytes: [0x20, 0x03, 0x01]) // 計測動作を開始
                peripheral.writeValue(data, for: characteristic, type: .withResponse)

            default:
                break
            }
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("failed to update value for \(characteristic) with error: \(error)")
            return
        }

        guard let data = characteristic.value, data.count > 0 else {
            print("\(characteristic) has no value")
            return
        }

        switch characteristic.uuid.uuidString {
        case Characteristic.custom1.uuidString:
            let bytes = [UInt8](data)

            guard let eventType = Custom1Event.EventCode(rawValue: bytes[0]) else {
                assertionFailure("unknown event code")
                return
            }

            switch eventType {
            case .dataPacket1:
                let packet = try! Custom1Event.DataPacket1(bytes: bytes)

                let parameters: [SensorParameter] = [
                    .acceleration(
                        x: Float(packet.acceleration.x),
                        y: Float(packet.acceleration.y),
                        z: Float(packet.acceleration.z)
                    ),
                    .magneticField(
                        x: Float(packet.magneticField.x),
                        y: Float(packet.magneticField.y),
                        z: Float(packet.magneticField.z)
                    )
                ]

                delegate?.peripheral(self, didUpdateSensor: parameters)

            case .dataPacket2:
                let packet = try! Custom1Event.DataPacket2(bytes: bytes)

                let parameters: [SensorParameter] = [
                    .pressure(packet.pressure.hPa),
                    .humidity(packet.humidity.pRH),
                    .temperature(packet.temperature.degC),
                    .uv(packet.uv.mW),
                    .ambientLight(packet.ambientLight.lx(with: .sun))
                ]

                delegate?.peripheral(self, didUpdateSensor: parameters)

            case .dataPacket3:
                break
            }

        default:
            break
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("failed to update notification state for \(characteristic) with \(error)")
            return
        }

        print("updated notify state=\(characteristic.isNotifying)")
    }

    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let error = error {
            print("failed to read RSSI with \(error)")
            return
        }

        print("updated rssi=\(RSSI.intValue)")
    }
}
