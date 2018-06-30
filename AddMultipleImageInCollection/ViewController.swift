//
//  ViewController.swift
//  AddMultipleImageInCollection
//
//  Created by Echo Innovate IT on 30/06/18.
//  Copyright © 2018 Echo Innovate IT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Variable Declaration
    
    /* Collection View */
    @IBOutlet weak var collectionGallaryOne: UICollectionView!
    @IBOutlet weak var collectionGallaryTwo: UICollectionView!
    
    /* Local Variable */
    var objVehicleRegImg = [Any]()
    var objVehiclePermitImg = [Any]()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionGallaryOne.reloadData()
        collectionGallaryTwo.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - ImagePickerView Delegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if (picker.view.tag == 1) {
            
            objVehicleRegImg.append(info["UIImagePickerControllerOriginalImage"]!)
            
            collectionGallaryOne.reloadData()
        }
        else if (picker.view.tag == 2)  {
            
            objVehiclePermitImg.append(info["UIImagePickerControllerOriginalImage"]!)
            
            collectionGallaryTwo.reloadData()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CollectionView Delegate

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  (collectionView == collectionGallaryOne) ?  objVehicleRegImg.count + 1 : objVehiclePermitImg.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == collectionGallaryOne {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indexPath.row == objVehicleRegImg.count ? "VehicleRegCellAdd" : "VehicleRegCell", for: indexPath) as? PhotoCell
            
            if indexPath.row == objVehicleRegImg.count {
                return cell!
            }
            cell?.imgProfile.image = (objVehicleRegImg[indexPath.row] as! UIImage)
            
            cell?.btnCancel.tag = indexPath.row
            cell?.btnCancel.addTarget(self, action: #selector(ViewController.didTapRemoveVehicleReg(_:)), for: UIControlEvents.touchUpInside)
            
            return cell!
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indexPath.row == objVehiclePermitImg.count ? "VehiclePermitCellAdd" : "VehiclePermitCell", for: indexPath) as? PhotoCell
            
            if indexPath.row == objVehiclePermitImg.count {
                return cell!
            }
            cell?.imgProfile.image = (objVehiclePermitImg[indexPath.row] as! UIImage)
            
            cell?.btnCancel.tag = indexPath.row
            cell?.btnCancel.addTarget(self, action: #selector(ViewController.didTapRemoveVehiclePermit(_:)), for: UIControlEvents.touchUpInside)
            
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionGallaryOne && indexPath.row == objVehicleRegImg.count {
            self.uploadCustomPicture(1)
        }
        else if collectionView == collectionGallaryTwo && indexPath.row == objVehiclePermitImg.count {
            self.uploadCustomPicture(2)
        }
    }
}

// MARK: Private Helper Method

extension ViewController {
    
    func openCameraFor(_ tag: Int) {
        
        if UIImagePickerController.isCameraDeviceAvailable(.front) || UIImagePickerController.isCameraDeviceAvailable(.rear) {
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.view.tag = tag;
            
            self.present(picker, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func openGalleryFor(_ tag: Int) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary;
        picker.delegate = self
        picker.view.tag = tag;
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func didTapRemoveVehicleReg(_ sender: UIButton) {
        
        objVehicleRegImg.remove(at: sender.tag)
        
        collectionGallaryOne.reloadData()
    }
    
    @objc func didTapRemoveVehiclePermit(_ sender: UIButton) {
        
        objVehiclePermitImg.remove(at: sender.tag)
        
        collectionGallaryTwo.reloadData()
    }
    
    func uploadCustomPicture(_ tag: Int) {
        
        let optionMenu = UIAlertController(title: nil, message: "Select Photo", preferredStyle: .actionSheet)
        
        optionMenu.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.openCameraFor(tag)
        }))
        
        optionMenu.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.openGalleryFor(tag)
        }))
        
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        }))
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}
