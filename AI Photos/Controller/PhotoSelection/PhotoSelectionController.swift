//
//  PhotoSelectionController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 27.11.24.
//
import UIKit
import PhotosUI

class PhotoSelectionController: UIViewController, UINavigationControllerDelegate {
    
    var patternImage: UIImage?
    var isOutFit: Bool!
    var isMen: Bool?
    var category: Category?
    var hairstyle: String?
    var name: String!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLabel.attributedText = Constants.PhotoSelectionScreen.takeYourPhoto.styled(as: .SemiBold20)
        secondLabel.attributedText = Constants.PhotoSelectionScreen.orImportFromTheGallery.styled(as: .Regular17)
        galleryButton.setAttributedTitle(Constants.PhotoSelectionScreen.importFromGallery.styled(as: .Medium18), for: .normal)
        takePhotoButton.setAttributedTitle(Constants.PhotoSelectionScreen.takeAPhoto.styled(as: .SemiBold18), for: .normal)
        takePhotoButton.layer.cornerRadius = 4
        galleryButton.titleLabel?.adjustsFontSizeToFitWidth = true
        galleryButton.titleLabel?.minimumScaleFactor = 0.5
        takePhotoButton.titleLabel?.adjustsFontSizeToFitWidth = true
        takePhotoButton.titleLabel?.minimumScaleFactor = 0.5
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func galleryButtonTapped(_ sender: Any) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Камера недоступна", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension PhotoSelectionController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard let result = results.first, result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            DispatchQueue.main.async { [weak self] in
                guard let self, let image = object as? UIImage else { return }
                let controller = CropController.instantiate()
                controller.originalImage = image
                controller.patternImage = patternImage
                controller.isOutFit = isOutFit
                controller.isMen = isMen
                controller.category = category
                controller.hairstyle = hairstyle
                controller.name = name
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

extension PhotoSelectionController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[.originalImage] as? UIImage {
            let controller = CropController.instantiate()
            controller.originalImage = originalImage
            controller.patternImage = patternImage
            controller.isOutFit = isOutFit
            controller.isMen = isMen
            controller.category = category
            controller.hairstyle = hairstyle
            controller.name = name
            self.navigationController?.pushViewController(controller, animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
