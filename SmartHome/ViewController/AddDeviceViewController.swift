//
//  AddDeviceViewController.swift
//  SmartHome
//
//  Created by Joao Batista on 13/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
import CoreBluetooth
protocol AddDeviceProtocol: AnyObject {
    func finishRegister(device: Device)
}
class AddDeviceViewController: BaseViewController {

    weak var delegate: AddDeviceProtocol?
    let ports = [13, 14, 15, 17, 22, 15]
    var pickerView = UIPickerView()
    var peripheral: CBPeripheral!
    var port: Int = 0
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.makeRoundBorder(withCornerRadius: 5)
        }
    }
    @IBOutlet weak var imageDevice: UIImageView!
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.makeRoundBorder(withCornerRadius: 10)
        }
    }
    @IBOutlet weak var nameDevice: UITextField!
    @IBOutlet weak var portEsp: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitial()
    }

    private func setupInitial() {
        portEsp.inputView = pickerView
        portEsp.textAlignment = .center
        portEsp.placeholder = "Porta no Esp"
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    @IBAction func chooseImage(_ sender: Any) {
        if let selectorImageVC = UIViewController.createViewControllerIn(storyBoardName: "Main", withIndentifier: "SelectedImageViewController", typeViewController: SelectedImageViewController.self) {
            selectorImageVC.delegate = self
            self.present(selectorImageVC, animated: true, completion: nil)
        }
    }

    @IBAction func addDevice(_ sender: Any) {
        let validate = validInfo()
        if validate.valid == false {
            showMessageError(title: "Erro ao cadastrar", message: validate.text ?? "Ocorreu um problema interno, tente novamente mais tarde")
        } else {
            if let image = imageDevice.image {
                delegate?.finishRegister(device: Device(image: image, name: nameDevice.text!, peripheral: peripheral, port: port))
            } else {
                 delegate?.finishRegister(device: Device(image: UIImage(), name: nameDevice.text!, peripheral: peripheral, port: port))
            }
            self.navigationController?.popViewController(animated: true)
        }

    }
    func validInfo() -> (text: String?, valid: Bool) {
        var text = ""
        var isValid = true
        if portEsp.text == "" {
            text += "Escolha uma porta associada ao dispositivo \n"
            isValid = false
        }
        if nameDevice.text == "" {
            text += "Escolha um nome para o dispositivo \n"
            isValid = false
        }
        if peripheral == nil {
            text += "Ocorreu um problema interno, por favor tente mais tarde"
            isValid = false
        }
        return (text, isValid)
    }
}
extension AddDeviceViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ports.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = "Porta \(ports[row])"
        return title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        portEsp.text = "Porta \(ports[row])"
        port = ports[row]
    }
}

extension AddDeviceViewController: SelectedImageDelegate {
    func choose(theImage image: UIImage) {
        imageDevice.image = image
    }
}
