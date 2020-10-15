//
//  UIImageExtension.swift
//  SmartHome
//
//  Created by Joao Batista on 14/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

extension UIImage {
    static func getDevicesImage() -> [UIImage] {
        let names = ["computer", "fan", "garage", "light", "sound", "television"]
        var devices: [UIImage] = []
        for name in names {
            if let image = UIImage(named: name) {
                devices.append(image)
            }
        }
        return devices
    }
}
