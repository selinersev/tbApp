//
//  ViewController.swift
//  tbtApp
//
//  Created by Selin Ersev on 24.07.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit
import Gallery
import Photos
class MainViewController: UIViewController, GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: false, completion: nil)
        gallery = nil

        self.performSegue(withIdentifier: "ShowImage", sender: images[0])

    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    var gallery : GalleryController!
    

    
    
    @IBAction func openPhotoLibrary(_ sender: Any) {
        
        let gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    

        Config.Camera.recordLocation = true
        Config.tabsToShow = [.imageTab]
        Config.Camera.imageLimit = 1
        
    }
    
    /*
    func getImages() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.fetchLimit = 1
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
        assets.enumerateObjects({ (object, count, stop) in

            let manager = PHImageManager.default()
            manager.requestImage(for: object, targetSize: CGSize.init(width: self.imageView.frame.width, height: self.imageView.frame.height), contentMode: .aspectFill, options: nil) { (resultImage, nil) in
                self.imageView.image = resultImage
            }
        })

        
        // To show photos, I have taken a UICollectionView


    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImage"{
            let controller = segue.destination as! ImageViewController
            guard let selected = sender as? Image else{return}
            controller.selectedImage = selected

        }
    }
    
}

