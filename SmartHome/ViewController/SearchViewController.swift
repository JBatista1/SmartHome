//
//  SearchViewController.swift
//  SmartHome
//
//  Created by Joao Batista on 13/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
import CoreBluetooth
protocol SearchDelegate: AnyObject {
    func get(device: Device)
}
class SearchViewController: BaseViewController {
    weak var delegate: SearchDelegate?
    // Bluetooth
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var peripherals: [CBPeripheral] = []

    //UI
    @IBOutlet weak var devicesTable: UITableView!
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.makeRoundBorder(withCornerRadius: 5)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        devicesTable.dataSource = self
        devicesTable.delegate = self
    }
    
    @IBAction func searchDevices(_ sender: Any) {
        centralManager.scanForPeripherals(withServices: nil)
        showAddedLoading(view: self.view)
        let _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stopScan), userInfo: nil, repeats: false)
    }
    @objc func stopScan() {
        hideLoading(view: self.view)
        centralManager.stopScan()
        peripherals = peripherals.uniques
        devicesTable.reloadData()
    }
}
extension SearchViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Cental state Update")
        switch central.state {
        case .poweredOn:
            print("Bluetooth Ativaco")
        case .poweredOff:
            print("Habilite o bluetooth")
        default:
            print("ocorreu um erro. Tente novamente")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals.append(peripheral)
    }
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")
        cell?.textLabel?.text = peripherals[indexPath.row].name
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
