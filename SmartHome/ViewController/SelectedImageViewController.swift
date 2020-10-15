//
//  SelectedImageViewController.swift
//  SmartHome
//
//  Created by Joao Batista on 13/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit
protocol SelectedImageDelegate: AnyObject {
    func choose(theImage image: UIImage)
}
class SelectedImageViewController: UIViewController {
    weak var delegate: SelectedImageDelegate?
    private var image: UIImage? = UIImage()

    let images = UIImage.getDevicesImage()
    @IBOutlet weak var imagesTypeCollection: UICollectionView!
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.makeRoundBorder(withCornerRadius: 5)
        }
    }
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.makeRoundBorder(withCornerRadius: 20)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imagesTypeCollection.delegate = self
        imagesTypeCollection.dataSource = self
    }
    
    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension SelectedImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageDevice", for: indexPath) as? ImageCollectionViewCell
        cell?.imageDevice.image = images[indexPath.row]
        cell?.makeRoundBorder(withCornerRadius: 10)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = (collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell) {
            if let imageselected = cell.imageDevice.image {
                delegate?.choose(theImage: imageselected)
                self.dismiss(animated: true, completion: nil)
            }

        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 16, height: collectionView.frame.width/2 - 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
