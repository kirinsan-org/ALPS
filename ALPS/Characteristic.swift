//
//  Characteristic.swift
//  ALPS
//
//  Created by Jun Tanaka on 2017/06/03.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import CoreBluetooth

enum Characteristic: String {
    // 計測センサデータやモジュール内部ステータスを
    // 対向機に通知するための Charactaristic です。
    // Notification プロトコルにて対向機に通知されます。
    case custom1 = "686A9A3B-4C2C-4231-B871-9CFE92CC6B1E"

    // コマンド (Event Code) Read 応答、Bluetooth® 接続パラメータ更新状況、
    // シーケンサエラーの通知に使用される Charactaristic です。
    // Notification プロトコルにて対向機に通知されます。
    case custom2 = "078FF5D6-3C93-47F5-A30C-05563B8D831E"

    // コマンド制御用のCharactatisticです。
    // Write もしくは WriteWithoutResponse Protocol にて
    // コマンドをモジュールに送信します。
    case custom3 = "B962BDD1-5A77-4797-93A1-EDE8D0FF74BD"

    var uuid: UUID {
        return UUID(uuidString: rawValue)!
    }

    var uuidString: String {
        return rawValue
    }

    var cbUUID: CBUUID {
        return CBUUID(nsuuid: uuid)
    }
}
