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

class MainViewController: UIViewController {
    
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
        print("aaaa")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImage"{
            let controller = segue.destination as! ImageViewController
            guard let selected = sender as? Image else{return}
            controller.selectedImage = selected

        }
    }
    
}
extension MainViewController: GalleryControllerDelegate {

    public func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: false, completion: nil)
        gallery = nil
        
        self.performSegue(withIdentifier: "ShowImage", sender: images[0])
        
    }
    
    public func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    public func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    public func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }


    
}

