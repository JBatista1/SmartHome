//
//  AddDeviceViewController.swift
//  SmartHome
//
//  Created by Joao Batista on 13/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.makeRoundBorder(withCornerRadius: 5)
        }
    }
    @IBOutlet weak var imageDevice: UIImageView!
    @IBOutlet weak var nameDevice: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
