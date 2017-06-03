//
//  Service.swift
//  ALPS
//
//  Created by Jun Tanaka on 2017/06/03.
//  Copyright © 2017 kirinsan.org. All rights reserved.
//

import CoreBluetooth

enum Service: String {
    case service1 = "47FE55D8-447F-43ef-9AD9-FE6325E17C47"

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
