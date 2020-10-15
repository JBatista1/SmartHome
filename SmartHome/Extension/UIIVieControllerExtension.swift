//
//  UIIVieControllerExtension.swift
//  SmartHome
//
//  Created by Joao Batista on 14/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

extension UIViewController {
    static func createViewControllerIn<T: UIViewController>(storyBoardName name: String, withIndentifier identifier: String, typeViewController type: T.Type) -> T? {
        guard let viewController = UIStoryboard.init(name: name, bundle: Bundle.main).instantiateViewController(withIdentifier: identifier) as? T else {return nil }
         return viewController
    }
}
