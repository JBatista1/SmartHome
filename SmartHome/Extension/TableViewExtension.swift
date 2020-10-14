//
//  TableViewExtension.swift
//  SmartHome
//
//  Created by Joao Batista on 13/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

extension UITableView {

    func registerWithNib<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }

    func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T
            else {
                fatalError("Could not deque cell with type \(T.self)")
        }
        return cell
    }

    func footerViewEmpty() {
        self.tableFooterView = UIView(frame: .zero)
    }
}
