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
    func showMessageError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
