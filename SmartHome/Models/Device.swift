//
//  Device.swift
//  SmartHome
//
//  Created by Joao Batista on 13/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
import CoreBluetooth
struct Device {
    let image: UIImage
    let name: String
    let peripheral: CBPeripheral
    let port: Int
}
