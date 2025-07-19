//
//  EnlargedPhotoController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 29.11.24.
//
import UIKit

class EnlargedPhotoController: UIViewController {
    
    @IBOutlet weak var holdLabel: UILabel!
    @IBOutlet weak var checkbox: CheckboxView!
    @IBOutlet weak var imageView: UIImageView!
    
    var outFit: OutFit? = nil {
        didSet {
            outFit?.update()
        }
    }
    var hairstyle: Hairstyle? = nil {
        didSet {
            hairstyle?.update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        holdLabel.attributedText = Constants.EnlargedPhoto.holdToSeeOriginal.styled(as: .Medium18)
        checkbox.checkedImage = .heartOn
        checkbox.uncheckedImage = .heartOff
        if outFit != nil {
            checkbox.isChecked = outFit!.isLike
            imageView.image = outFit!.image
        } else {
            checkbox.isChecked = hairstyle!.isLike
            imageView.image = hairstyle!.image
        }
        
        imageView.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        imageView.addGestureRecognizer(longPressGesture)
        
        checkbox.onCheckboxTapped = {
            if self.outFit != nil {
                self.outFit!.isLike = self.checkbox.isChecked
            } else {
                self.hairstyle!.isLike = self.checkbox.isChecked
            }
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let imageView = gesture.view as? UIImageView else { return }
        
        if gesture.state == .began {
            // При начале нажатия меняем изображение
            if self.outFit != nil {
                imageView.image = self.outFit!.originalImage
            } else {
                imageView.image = self.hairstyle!.originalImage
            }
            
        } else if gesture.state == .ended || gesture.state == .cancelled {
            // При отпускании возвращаем исходное изображение
            if self.outFit != nil {
                imageView.image = self.outFit!.image
            } else {
                imageView.image = self.hairstyle!.image
            }
            
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
