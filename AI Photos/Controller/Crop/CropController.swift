//
//  CropController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 27.11.24.
//
import UIKit

class CropController: UIViewController {
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLeftCorner: UIView!
    @IBOutlet weak var topRightCorner: UIView!
    @IBOutlet weak var bottomRightCorner: UIView!
    @IBOutlet weak var bottomLeftCorner: UIView!
    
    var cropPanGesture: UIPanGestureRecognizer!
    var topLeftPanGesture: UIPanGestureRecognizer!
    var topRightPanGesture: UIPanGestureRecognizer!
    var bottomLeftPanGesture: UIPanGestureRecognizer!
    var bottomRightPanGesture: UIPanGestureRecognizer!
    
    var patternImage: UIImage?
    var originalImage: UIImage!
    var isOutFit: Bool!
    var isMen: Bool?
    var category: Category?
    var hairstyle: String?
    var name: String!
    
    var imageFrame: CGRect {
        guard let image = imageView.image else { return .zero }
        
        let imageViewSize = imageView.bounds.size
        let imageSize = image.size
        
        let imageAspectRatio = imageSize.width / imageSize.height
        let imageViewAspectRatio = imageViewSize.width / imageViewSize.height
        
        var frame = CGRect.zero
        
        if imageAspectRatio > imageViewAspectRatio {
            // Картинка ограничена по ширине
            let width = imageViewSize.width
            let height = width / imageAspectRatio
            let y = (imageViewSize.height - height) / 2
            frame = CGRect(x: 0, y: y, width: width, height: height)
        } else {
            // Картинка ограничена по высоте
            let height = imageViewSize.height
            let width = height * imageAspectRatio
            let x = (imageViewSize.width - width) / 2
            frame = CGRect(x: x, y: 0, width: width, height: height)
        }
        
        return imageView.convert(frame, to: self.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = originalImage
        imageView.contentMode = .scaleAspectFit
        addGestures()
        
        goButton.setAttributedTitle(Constants.CropScreen.letsGo.styled(as: .SemiBold18), for: .normal)
        goButton.layer.cornerRadius = 4
        goButton.titleLabel?.adjustsFontSizeToFitWidth = true
        goButton.titleLabel?.minimumScaleFactor = 0.5
        
        view.bringSubviewToFront(topLeftCorner)
        view.bringSubviewToFront(topRightCorner)
        view.bringSubviewToFront(bottomLeftCorner)
        view.bringSubviewToFront(bottomRightCorner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        placeCornersOnImageFrame()
    }
    
    private func placeCornersOnImageFrame() {
        let frame = imageFrame
        
        topLeftCorner.center = CGPoint(x: frame.minX + 22.5, y: frame.minY + 22.5)
        topRightCorner.center = CGPoint(x: frame.maxX - 22.5, y: frame.minY + 22.5)
        bottomLeftCorner.center = CGPoint(x: frame.minX + 22.5, y: frame.maxY - 22.5)
        bottomRightCorner.center = CGPoint(x: frame.maxX - 22.5, y: frame.maxY - 22.5)
    }
    
    private func addGestures() {
        topLeftPanGesture = addResizeGesture(to: topLeftCorner, selector: #selector(resizeFromTopLeft(_:)))
        topRightPanGesture = addResizeGesture(to: topRightCorner, selector: #selector(resizeFromTopRight(_:)))
        bottomLeftPanGesture = addResizeGesture(to: bottomLeftCorner, selector: #selector(resizeFromBottomLeft(_:)))
        bottomRightPanGesture = addResizeGesture(to: bottomRightCorner, selector: #selector(resizeFromBottomRight(_:)))
    }
    
    private func addResizeGesture(to corner: UIView, selector: Selector) -> UIPanGestureRecognizer {
        let panGesture = UIPanGestureRecognizer(target: self, action: selector)
        corner.addGestureRecognizer(panGesture)
        return panGesture
    }
    
    @objc private func resizeFromTopLeft(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        var newCenter = CGPoint(
            x: topLeftCorner.center.x + translation.x,
            y: topLeftCorner.center.y + translation.y
        )
        
        let frame = imageFrame
        
        // Ограничения относительно картинки
        if newCenter.x < frame.minX + 22.5 {
            newCenter.x = frame.minX + 22.5
        }
        if newCenter.y < frame.minY + 22.5 {
            newCenter.y = frame.minY + 22.5
        }
        
        // Ограничения относительно других углов
        if newCenter.x > bottomRightCorner.center.x - 45 {
            newCenter.x = bottomRightCorner.center.x - 45
        }
        if newCenter.y > bottomRightCorner.center.y - 45 {
            newCenter.y = bottomRightCorner.center.y - 45
        }
        
        topLeftCorner.center = newCenter
        topRightCorner.center.y = newCenter.y
        bottomLeftCorner.center.x = newCenter.x
        
        gesture.setTranslation(.zero, in: self.view)
    }
    
    @objc private func resizeFromTopRight(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        var newCenter = CGPoint(
            x: topRightCorner.center.x + translation.x,
            y: topRightCorner.center.y + translation.y
        )
        
        let frame = imageFrame
        
        // Ограничения относительно картинки
        if newCenter.x > frame.maxX - 22.5 {
            newCenter.x = frame.maxX - 22.5
        }
        if newCenter.y < frame.minY + 22.5 {
            newCenter.y = frame.minY + 22.5
        }
        
        // Ограничения относительно других углов
        if newCenter.x < bottomLeftCorner.center.x + 45 {
            newCenter.x = bottomLeftCorner.center.x + 45
        }
        if newCenter.y > bottomLeftCorner.center.y - 45 {
            newCenter.y = bottomLeftCorner.center.y - 45
        }
        
        topRightCorner.center = newCenter
        topLeftCorner.center.y = newCenter.y
        bottomRightCorner.center.x = newCenter.x
        
        gesture.setTranslation(.zero, in: self.view)
    }
    
    @objc private func resizeFromBottomLeft(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        var newCenter = CGPoint(
            x: bottomLeftCorner.center.x + translation.x,
            y: bottomLeftCorner.center.y + translation.y
        )
        
        let frame = imageFrame
        
        // Ограничения относительно картинки
        if newCenter.x < frame.minX + 22.5 {
            newCenter.x = frame.minX + 22.5
        }
        if newCenter.y > frame.maxY - 22.5 {
            newCenter.y = frame.maxY - 22.5
        }
        
        // Ограничения относительно других углов
        if newCenter.x > topRightCorner.center.x - 45 {
            newCenter.x = topRightCorner.center.x - 45
        }
        if newCenter.y < topRightCorner.center.y + 45 {
            newCenter.y = topRightCorner.center.y + 45
        }
        
        bottomLeftCorner.center = newCenter
        bottomRightCorner.center.y = newCenter.y
        topLeftCorner.center.x = newCenter.x
        
        gesture.setTranslation(.zero, in: self.view)
    }
    
    @objc private func resizeFromBottomRight(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        var newCenter = CGPoint(
            x: bottomRightCorner.center.x + translation.x,
            y: bottomRightCorner.center.y + translation.y
        )
        
        let frame = imageFrame
        
        // Ограничения относительно картинки
        if newCenter.x > frame.maxX - 22.5 {
            newCenter.x = frame.maxX - 22.5
        }
        if newCenter.y > frame.maxY - 22.5 {
            newCenter.y = frame.maxY - 22.5
        }
        
        // Ограничения относительно других углов
        if newCenter.x < topLeftCorner.center.x + 45 {
            newCenter.x = topLeftCorner.center.x + 45
        }
        if newCenter.y < topLeftCorner.center.y + 45 {
            newCenter.y = topLeftCorner.center.y + 45
        }
        
        bottomRightCorner.center = newCenter
        bottomLeftCorner.center.y = newCenter.y
        topRightCorner.center.x = newCenter.x
        
        gesture.setTranslation(.zero, in: self.view)
    }
    
    private func cropImage() -> UIImage? {
        guard let image = imageView.image else { return nil }
        
        // Исправляем ориентацию изображения
        let fixedImage = fixImageOrientation(image: image)
        let frame = imageFrame
        
        let topLeft = CGPoint(
            x: topLeftCorner.center.x - frame.origin.x,
            y: topLeftCorner.center.y - frame.origin.y
        )
        let topRight = CGPoint(
            x: topRightCorner.center.x - frame.origin.x,
            y: topRightCorner.center.y - frame.origin.y
        )
        let bottomLeft = CGPoint(
            x: bottomLeftCorner.center.x - frame.origin.x,
            y: bottomLeftCorner.center.y - frame.origin.y
        )
        let bottomRight = CGPoint(
            x: bottomRightCorner.center.x - frame.origin.x,
            y: bottomRightCorner.center.y - frame.origin.y
        )
        
        let minX = min(topLeft.x, bottomLeft.x)
        let maxX = max(topRight.x, bottomRight.x)
        let minY = min(topLeft.y, topRight.y)
        let maxY = max(bottomLeft.y, bottomRight.y)
        
        let cropFrame = CGRect(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
        
        let imageScaleX = fixedImage.size.width / frame.size.width
        let imageScaleY = fixedImage.size.height / frame.size.height
        
        let scaledCropFrame = CGRect(
            x: cropFrame.origin.x * imageScaleX,
            y: cropFrame.origin.y * imageScaleY,
            width: cropFrame.width * imageScaleX,
            height: cropFrame.height * imageScaleY
        )
        
        guard let croppedCGImage = fixedImage.cgImage?.cropping(to: scaledCropFrame) else { return nil }
        return UIImage(cgImage: croppedCGImage)
    }
    
    // Метод исправления ориентации
    private func fixImageOrientation(image: UIImage) -> UIImage {
        guard image.imageOrientation != .up else { return image }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? image
    }
    
    @IBAction func cropButtonTapped(_ sender: UIButton) {
        guard let croppedImage = cropImage() else { return }
        
        let controller = OneResultController.instantiate()
        controller.originalImage = croppedImage
        controller.patternImage = patternImage
        controller.category = category
        controller.isMen = isMen
        controller.isOutFit = isOutFit
        controller.hairstyle = hairstyle
        controller.name = name
        
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

