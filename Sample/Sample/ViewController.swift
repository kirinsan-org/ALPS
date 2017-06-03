//
//  ViewController.swift
//  Sample
//
//  Created by Jun Tanaka on 2017/06/04.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import UIKit
import ALPS

class ViewController: UIViewController {
    let manager = Manager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        start()
    }

    func start() {
        manager.delegate = self
        manager.startScan()
    }

    func stop() {
        manager.stopScan()
    }
}

extension ViewController: ManagerDelegate {
    func manager(_ manager: Manager, didDiscover peripheral: Peripheral) {
        print("discovered \(peripheral.uuid)")

        guard peripheral.uuid.uuidString == "65EDEF7D-E622-4C77-B9AB-C4D6170DA116" else {
            return
        }

        manager.connect(peripheral)
    }

    func manager(_ manager: Manager, didConnect peripheral: Peripheral) {
        print("connected \(peripheral)")

        peripheral.delegate = self
    }

    func manager(_ manager: Manager, didDisconnect peripheral: Peripheral) {
        print("disconnected \(peripheral)")
    }
}

extension ViewController: PeripheralDelegate {
    func peripheral(_ peripheral: Peripheral, didUpdateSensor parameters: [SensorParameter]) {
        print("updated sensor parameters:")

        parameters.forEach {
            print("\($0.key.rawValue)=\($0.value)")
        }
    }
}
