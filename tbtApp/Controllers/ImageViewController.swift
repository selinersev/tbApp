//
//  ImageViewController.swift
//  tbtApp
//
//  Created by Selin Ersev on 25.07.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit
import Gallery
import Photos
import CoreImage


class ImageViewController: UIViewController,UIScrollViewDelegate,UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var largeRatio: NSLayoutConstraint!
    @IBOutlet weak var mediumRatio: NSLayoutConstraint!
    @IBOutlet weak var smallRatio: NSLayoutConstraint!
    @IBOutlet weak var largeDimensions: UIImageView!
    @IBOutlet weak var mediumDimensions: UIImageView!
    @IBOutlet weak var smallDimensions: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var editedImageView: UIView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    @IBAction func addFilter(_ sender: Any) {
        self.performSegue(withIdentifier: "EditImage", sender: editedImageView.toImage())
    }
    
    var selectedImage : Image?
    var activeRatio = Ratio.small
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        selectedImage?.resolve(completion: { (image) in
            self.selectedImageView.image = image
        })
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        guard let date = selectedImage?.asset.creationDate else{return}
        dateLabel.text = dateFormatterGet.string(from: date)
        
        smallDimensions.isUserInteractionEnabled = true
        mediumDimensions.isUserInteractionEnabled = true
        largeDimensions.isUserInteractionEnabled = true
        
        let tapGestureSmall = UITapGestureRecognizer(target: self, action: #selector(self.changeSmallDimensions))
        smallDimensions.addGestureRecognizer(tapGestureSmall)
        
        let tapGestureMedium = UITapGestureRecognizer(target: self, action: #selector(self.changeMediumDimensions))
        mediumDimensions.addGestureRecognizer(tapGestureMedium)
        
        let tapGestureLarge = UITapGestureRecognizer(target: self, action: #selector(self.changeLargeDimensions))
        largeDimensions.addGestureRecognizer(tapGestureLarge)
    }

    @objc func changeSmallDimensions(){
        activeRatio = .small
        updateRatio()
    }
    
    @objc func changeMediumDimensions(){
        activeRatio = .medium
        updateRatio()
    }
    
    @objc func changeLargeDimensions(){
        activeRatio = .large
        updateRatio()
    }
    
    func updateRatio(){
        [smallRatio,mediumRatio,largeRatio].forEach{$0?.isActive = false}
        
        switch activeRatio {
        case .small:
            smallRatio.isActive = true
        case .medium:
            mediumRatio.isActive = true
        case .large:
            largeRatio.isActive = true
        }
        self.view.layoutIfNeeded()
        bottomHeight.constant = photoView.frame.height * CGFloat(0.21)
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.selectedImageView
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditImage"{
            let controller = segue.destination as! FilterViewController
            guard let selected = sender as? UIImage else{return}
            controller.selectedImage = selected
            controller.editedDate = dateLabel.text
            controller.ratio = activeRatio
        }
    }
    
}

enum Ratio{
    case small, medium, large
}












