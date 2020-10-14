//
//  BaseViewController.swift
//  SmartHome
//
//  Created by Joao Batista on 14/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
import MBProgressHUD


class BaseViewController: UIViewController {

    func showAddedLoading(view: UIView) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }

    func hideLoading(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }

    func showPassword(button: UIButton, input: UITextField){
        if input.isSecureTextEntry {
            input.isSecureTextEntry = false
            button.setImage(UIImage(named: "icVisibilityOff"), for: UIControl.State.normal)
        } else {
            input.isSecureTextEntry = true
            button.setImage(UIImage(named: "icVisibility"), for: UIControl.State.normal)
        }
    }
}
