//
//  BluetoothManager.swift
//  Music Maniac
//
//  Created by Brandon Howard on 4/24/16.
//  Copyright © 2016 Ticklin' The Ivories. All rights reserved.
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate  {

	private var centralManager: CBCentralManager?
	private var discoveredPeripheral: CBPeripheral?
	private let data = NSMutableData()
	var delegate: BluetoothManagerDelegate!

	override init() {
	}

	func setup() {
		centralManager = CBCentralManager(delegate: self, queue: nil)
	}

	func centralManagerDidUpdateState(central: CBCentralManager) {
		print("\(#line) \(#function)")
		guard central.state  == .PoweredOn else { return }
		scan()
	}

	func scan() {
		centralManager?.scanForPeripheralsWithServices([transferServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(bool: true)])
		print("Scanning started")
	}

	func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {

		print("Discovered \(peripheral.name) at \(RSSI)")

		if discoveredPeripheral != peripheral {
			discoveredPeripheral = peripheral
			print("Connecting to peripheral \(peripheral)")
			centralManager?.connectPeripheral(peripheral, options: nil)
		}
	}

	func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
		print("Failed to connect to \(peripheral). (\(error!.localizedDescription))")
		cleanup()
	}

	func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
		print("Peripheral Connected")
		centralManager?.stopScan()
		print("Scanning stopped")
		data.length = 0
		peripheral.delegate = self
		peripheral.discoverServices([transferServiceUUID])
	}

	func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
		guard error == nil else {
			print("Error discovering services: \(error!.localizedDescription)")
			cleanup()
			return
		}

		guard let services = peripheral.services else {
			return
		}

		for service in services {
			peripheral.discoverCharacteristics([transferCharacteristicUUID], forService: service)
		}
	}

	func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
		guard error == nil else {
			print("Error discovering services: \(error!.localizedDescription)")
			cleanup()
			return
		}


		guard let characteristics = service.characteristics else {
			return
		}

		for characteristic in characteristics {
			if characteristic.UUID.isEqual(transferCharacteristicUUID) {
				peripheral.setNotifyValue(true, forCharacteristic: characteristic)
			}
		}
	}

	func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
		guard error == nil else {
			print("Error discovering services: \(error!.localizedDescription)")
			return
		}

		guard let stringFromData = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding) else {
			print("Invalid data")
			return
		}

		if stringFromData.isEqualToString("EOM") {
			peripheral.setNotifyValue(false, forCharacteristic: characteristic)
			centralManager?.cancelPeripheralConnection(peripheral)
		} else {
			data.appendData(characteristic.value!)
			self.delegate.keyWasPressed(stringFromData as String)
		}

	}

	func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
		print("Error changing notification state: \(error?.localizedDescription)")

		guard characteristic.UUID.isEqual(transferCharacteristicUUID) else {
			return
		}
		if (characteristic.isNotifying) {
			print("Notification began on \(characteristic)")
		} else { // Notification has stopped
			print("Notification stopped on (\(characteristic))  Disconnecting")
			centralManager?.cancelPeripheralConnection(peripheral)
		}
	}

	func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
		print("Peripheral Disconnected")
		discoveredPeripheral = nil
		scan()
	}

	private func cleanup() {
		guard discoveredPeripheral?.state == .Connected else {
			return
		}

		guard let services = discoveredPeripheral?.services else {
			cancelPeripheralConnection()
			return
		}

		for service in services {
			guard let characteristics = service.characteristics else {
				continue
			}

			for characteristic in characteristics {
				if characteristic.UUID.isEqual(transferCharacteristicUUID) && characteristic.isNotifying {
					discoveredPeripheral?.setNotifyValue(false, forCharacteristic: characteristic)
					return
				}
			}
		}
	}

	private func cancelPeripheralConnection() {
		centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
	}


}

protocol BluetoothManagerDelegate {
	func keyWasPressed(key: String);
}
