//
//  FilterViewController.swift
//  tbtApp
//
//  Created by Selin Ersev on 31.07.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit
import Gallery
import Photos
import CoreImage

class FilterViewController: UIViewController,UIDocumentInteractionControllerDelegate {

    fileprivate let context = CIContext(options: nil)
    fileprivate var filterIndex = 0
    var filteredImages = [UIImage]()
    var ratio = Ratio.small
    
    fileprivate let filterNameList = [
        "CIColorClamp",
        "CIColorControls",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear"
    ]
    
    
    @IBOutlet weak var editedPhotoView: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var smallRatio: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var largeRatio: NSLayoutConstraint!
    @IBOutlet weak var mediumRatio: NSLayoutConstraint!
    var documentController: UIDocumentInteractionController!
    var selectedImage : UIImage?
    var instaxImage : UIImage?
    var editedDate : String?
    @IBAction func saveCameraRoll(_ sender: Any) {
        guard let instaxImage = photo.toImage() else { return }
        UIImageWriteToSavedPhotosAlbum(instaxImage, nil, nil, nil)
    }
    
    @IBAction func instagramShare(_ sender: Any) {
        shareToInstagram()
    }
    
    @IBAction func whatsappShare(_ sender: Any) {
        shareToWhatsapp()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scaledImage = self.resizeImage(image: selectedImage!)
        photo.image = selectedImage
        photo.clipsToBounds = true
        dateLabel.text = editedDate

        DispatchQueue.global(qos: .background).async {
            self.filterNameList.forEach{ filterName in
                self.filteredImages.append(self.filter(with: scaledImage, with: filterName))
            }
            DispatchQueue.main.sync {
                self.collectionView.reloadData()
            }
        }
    
    }

    override func viewWillLayoutSubviews() {
         updateRatio()
        super.viewWillLayoutSubviews()
    }

    func updateRatio(){
        [smallRatio,mediumRatio,largeRatio].forEach{$0?.isActive = false}
        switch ratio {
        case .small:
            smallRatio.isActive = true
        case .medium:
            mediumRatio.isActive = true
        case .large:
            largeRatio.isActive = true
        }
        self.view.layoutIfNeeded()
        bottomConstraint.constant = editedPhotoView.frame.height * CGFloat(0.21)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let ratio: CGFloat = 0.3
        let resizedSize = CGSize(width: Int(image.size.width * ratio), height: Int(image.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func shareToInstagram() {
        guard let instaImage = editedPhotoView.toImage() else{ return }
        guard let instagramURL = URL(string: "instagram://app") else {return}
        guard UIApplication.shared.canOpenURL(instagramURL) else {
            print(" Instagram isn't installed ")
            return
        }
        guard let imageData = UIImageJPEGRepresentation(instaImage, 100) else {return}
        let writePath = NSString(string: NSTemporaryDirectory()).appendingPathComponent("instagram.igo")
        let url = URL(fileURLWithPath: writePath)
        
        do {
            try imageData.write(to: url, options: .atomic)
            UIPasteboard.general.string = "#tb \(dateLabel.text!)"
            self.documentController = UIDocumentInteractionController(url: url)
            self.documentController.uti = "com.instagram.exlusivegram"
            self.documentController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
        }catch {
            print(error)
        }
    }
    
    func shareToWhatsapp(){
        guard let instaImage = editedPhotoView.toImage() else{ return }
        guard let whatsappURL = URL(string: "whatsapp://app" ) else { return }
        guard UIApplication.shared.canOpenURL(whatsappURL) else {
            print(" WhatsApp isn't installed ")
            return
        }
        guard let imageData = UIImageJPEGRepresentation(instaImage, 100) else {return}
        guard let tempFile = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai") else { return }
        do {
            try imageData.write(to: tempFile, options: .atomic)
            
            self.documentController = UIDocumentInteractionController(url: tempFile)
            self.documentController.uti = "net.whatsapp.image"
            self.documentController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
        }
        catch {
            print(error)
        }
        
    }
    
    

    
    func filter(with selectedImage: UIImage, with filterName: String) -> UIImage{
        let sourceImage = CIImage(image: selectedImage)
        // 2 - create filter using name
        let filter = CIFilter(name: filterName)
        filter?.setDefaults()
        // 3 - set source image
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        // 4 - output filtered image as cgImage with dimension.
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        // 5 - convert filtered CGImage to UIImage
        return  UIImage(cgImage: outputCGImage!)
    }



}
extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)  as! CustomCollectionViewCell
        cell.filteredImage.image = filteredImages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterName = filterNameList[indexPath.item]
        if let image = self.selectedImage {
            let filteredImage = filter(with: image, with: filterName)
            photo?.image = filteredImage
        }
        
    }
    
}
