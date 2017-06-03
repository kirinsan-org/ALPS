//
//  DeviceManager.swift
//  ALPS
//
//  Created by Jun Tanaka on 2017/06/03.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import CoreBluetooth

public protocol ManagerDelegate: class {
    func manager(_ manager: Manager, didDiscover peripheral: Peripheral)
    func manager(_ manager: Manager, didConnect peripheral: Peripheral)
    func manager(_ manager: Manager, didDisconnect peripheral: Peripheral)
}

public final class Manager: NSObject {
    fileprivate var central: CBCentralManager?
    fileprivate var peripherals: [Peripheral] = []

    public weak var delegate: ManagerDelegate?

    public override init() {
        super.init()
    }

    deinit {
        central?.stopScan()
    }

    public func startScan() {
        central = CBCentralManager(delegate: self, queue: nil)
    }

    public func stopScan() {
        central?.stopScan()
    }

    public func connect(_ periphetal: Peripheral) {
        central?.connect(periphetal.cbPeripheral, options: nil)
    }
}

extension Manager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("state: \(central.state)")

        switch central.state {
        case .poweredOn:
            central.scanForPeripherals(withServices: nil, options: nil)
        default:
            break
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover cbPeripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = Peripheral(cbPeripheral: cbPeripheral, rssi: RSSI.intValue)
        peripherals.append(newPeripheral)

        delegate?.manager(self, didDiscover: newPeripheral)
    }

    public func centralManager(_ central: CBCentralManager, didConnect cbPeripheral: CBPeripheral) {
        guard let peripheral = peripherals.first(where: { $0.cbPeripheral == cbPeripheral }) else {
            return
        }

        delegate?.manager(self, didConnect: peripheral)

        cbPeripheral.discoverServices([Service.service1.cbUUID])
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral cbPeripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("disconnected \(cbPeripheral) with \(error)")
        } else {
            print("disconnected \(cbPeripheral) without errors")
        }

        if let index = peripherals.index(where: { $0.cbPeripheral == cbPeripheral }) {
            let peripheral = peripherals[index]
            peripherals.remove(at: index)
            delegate?.manager(self, didDisconnect: peripheral)
        }
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("failed to connect \(peripheral) with \(error)")
        } else {
            print("failed to connect \(peripheral) without errors")
        }
    }
}

extension CBManagerState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .resetting:
            return "resetting"
        case .unsupported:
            return "unsupported"
        case .unauthorized:
            return "unauthorized"
        case .poweredOff:
            return "poweredOff"
        case .poweredOn:
            return "poweredOn"
        }
    }
}
