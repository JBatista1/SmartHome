//
//  HomeViewController.swift
//  SmartHome
//
//  Created by Joao Batista on 13/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController {
    @IBOutlet weak var devicesCollection: UICollectionView!
    var devices: [Device] = []
    private var peripheral: CBPeripheral!
    private var centralManager: CBCentralManager!
    private var myCharacteristic: CBCharacteristic?
    let serviceUUID = CBUUID(string: "ab0828b1-198e-4351-b779-901fa0e0371e")
    let periphealUUID = CBUUID(string: "3196C4BD-BF2E-E749-95CE-8A1A9A541F2A")
    var power: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitial()
        // Do any additional setup after loading the view.
    }
    private func setupNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "title") ?? UIColor.systemTeal]
    }
    private func setupInitial() {
        devicesCollection.registerWithNib(DevicesHomeCollectionViewCell.self)
        devicesCollection.delegate = self
        devicesCollection.dataSource = self
        setupNavigation()
    }
    @IBAction func newDevice(_ sender: Any) {
        if let searchVC = UIViewController.createViewControllerIn(storyBoardName: "Main", withIndentifier: "SecondViewController", typeViewController: SearchViewController.self) {
            searchVC.delegate = self
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    func sendText(text: String) {
        if (peripheral != nil && myCharacteristic != nil) {
            let data = text.data(using: .utf8)
            peripheral!.writeValue(data!,  for: myCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }
    }
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DevicesHomeCollectionViewCell.self, for: indexPath)
        cell.prepareCell(device: devices[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DevicesHomeCollectionViewCell {
            cell.chnageStatus()

            if centralManager != nil {
                if peripheral.state == .connected {
                    if power {
                         sendText(text: "Desligar")
                    }else {
                        sendText(text: "Ligar")
                    }
                    power.toggle()

                }else {
                    if centralManager.state != .poweredOn {
                        centralManager = CBCentralManager(delegate: self, queue: nil)
                    }else {
                        centralManager.scanForPeripherals(withServices:[serviceUUID], options: nil)
                    }
                }

            }else {
                centralManager = CBCentralManager(delegate: self, queue: nil)
            }


        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 16, height: collectionView.frame.width/2 + 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
extension HomeViewController: SearchDelegate {
    func get(device: Device, manager: CBCentralManager) {
        devices.append(device)
        devicesCollection.reloadData()
    }
}

extension HomeViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Bluetooth is switched off")
        case .poweredOn:
            print("Bluetooth is switched on")
            centralManager.scanForPeripherals(withServices:[serviceUUID], options: nil)
        case .unsupported:
            print("Bluetooth is not supported")
        default:
            print("Unknown state")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.identifier.uuidString == periphealUUID.uuidString {
            self.peripheral = peripheral
            self.peripheral.delegate = self
            centralManager.connect(self.peripheral, options: nil)
            centralManager.stopScan()
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to " +  peripheral.name!)
        peripheral.discoverServices([serviceUUID])
        sendText(text: "teste")
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        myCharacteristic = characteristics[0]

    }
}
