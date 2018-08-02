//
//  PhotoPickerViewController.swift
//  tbtApp
//
//  Created by Selin Ersev on 25.07.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit
import Gallery

class PhotoPickerViewController: UIViewController, GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        
    }
    

    

    var gallery : GalleryController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Config.Permission.image = UIImage(named: ImageList.Gallery.cameraIcon)
        Config.Font.Text.bold = UIFont(name: FontList.OpenSans.bold, size: 14)!
        Config.Camera.recordLocation = true
        Config.tabsToShow = [.imageTab, .cameraTab]
        
        
        let gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
