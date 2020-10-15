//
//  DevicesHomeCollectionViewCell.swift
//  SmartHome
//
//  Created by Joao Batista on 14/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

class DevicesHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageDevice: UIImageView!
    @IBOutlet weak var nameDevice: UILabel!
    @IBOutlet weak var status: UILabel!
    private var statusDevice: Bool = false

    @IBOutlet weak var content: UIView! {
        didSet {
            content.makeRoundBorder(withCornerRadius: 10)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func prepareCell(device: Device) {
        imageDevice.image = device.image
        nameDevice.text = device.name
        status.text = "Desligado"
        status.textColor = .red
    }
    func chnageStatus() {
        if statusDevice {
            status.text = "Desligado"
            status.textColor = .red
        } else {
            status.text = "Ligado"
            status.textColor = .systemGreen
        }
        statusDevice.toggle()
    }

}
