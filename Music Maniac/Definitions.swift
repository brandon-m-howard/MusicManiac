//
//  Definitions
//  Bluetooth Controller
//
//  Created by Brandon Howard on 4/19/16.
//  Copyright (c) 2016 Ticklin' The Ivories. All rights reserved.
//  Reference : https://github.com/0x7fffffff/Core-Bluetooth-Transfer-Demo/tree/master/Bluetooth

import CoreBluetooth

let TRANSFER_SERVICE_UUID = "E20A39F4-73F5-4BC4-A12F-17D1AD666661"
let TRANSFER_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-8757-72F6F66666D4"
let NOTIFY_MTU = 20

let transferServiceUUID = CBUUID(string: TRANSFER_SERVICE_UUID)
let transferCharacteristicUUID = CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)
