//
//  OneResultController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 17.01.25.
//

import UIKit
import Photos

class OneResultController: UIViewController {
    
    var timer: Timer?
    var progress: Float = 0
    var estimatedTime: Float = 90.0
    var originalImage: UIImage!
    var patternImage: UIImage?
    var category: Category?
    var isRepeat: Bool = false
    var isOutFit: Bool!
    var isMen: Bool?
    var hairstyle: String?
    var name: String!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var ideasLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var blureView: UIVisualEffectView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isOutFit {
            estimatedTime = 90.0
        } else {
            estimatedTime = 10.0
        }
        
        resultLabel.attributedText = Constants.ResultScreen.result.styled(as: .SemiBold20)
        ideasLabel.attributedText = Constants.ResultScreen.stylingIdeas.styled(as: .SemiBold16)
        saveButton.layer.cornerRadius = 4
        saveButton.setAttributedTitle(Constants.ResultScreen.saveToGallery.styled(as: .SemiBold18), for: .normal)
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.secondAccent
        containerView.layer.cornerRadius = 6
        
        progressLabel.attributedText = "0%".styled(as: .SemiBold54)
        startFakeProgress()
        imageView.image = originalImage
        
        if isOutFit {
            OutFit.getImage(initImage: originalImage, clothImage: patternImage ?? originalImage, category: category ?? .init(key: "", title: "") ) { [weak self] newImage in
                guard let self, let newImage else { return }
                blureView.isHidden = true
                progressLabel.attributedText = "100%".styled(as: .SemiBold54)
                progressLabel.isHidden = true
                saveButton.isEnabled = true
                imageView.image = newImage
                saveButton.backgroundColor = UIColor.accent
                
                let newOutFit = OutFit(originalImage: originalImage, image: newImage, patternImage: patternImage ?? newImage, isMan: isMen ?? true, name: name ?? "test", category: category, rootText: "")
                newOutFit.update()
                
                if isMen ?? true {
                    var mansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Man's Collection"})
                    if mansCollections.isNil {
                        let newCollection = Collection.init(image: newImage, name: "Man's Collection", outFits: [newOutFit], hairstyles: [])
                        newCollection.update()
                    } else {
                        mansCollections?.outFits.append(newOutFit)
                        mansCollections?.update()
                    }
                } else {
                    var womansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Woman's Collection"})
                    if womansCollections.isNil {
                        let newCollection = Collection.init(image: newImage, name: "Woman's Collection", outFits: [newOutFit], hairstyles: [])
                        newCollection.update()
                    } else {
                        womansCollections?.outFits.append(newOutFit)
                        womansCollections?.update()
                    }
                }
            }
        } else {
            Hairstyle.getImage(initImage: originalImage, isMen: isMen ?? true, hairStyle: hairstyle ?? "BuzzCut") { [weak self] newImage in
                guard let self, let newImage else { return }
                blureView.isHidden = true
                progressLabel.attributedText = "100%".styled(as: .SemiBold54)
                progressLabel.isHidden = true
                saveButton.isEnabled = true
                imageView.image = newImage
                saveButton.backgroundColor = UIColor.accent
                
                let newHairstyle = Hairstyle(originalImage: originalImage, image: newImage, isMan: isMen ?? true, name: name ?? "test", rootText: hairstyle ?? "BuzzCut")
                newHairstyle.update()
                
                if isMen ?? true {
                    var mansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Man's Collection"})
                    if mansCollections.isNil {
                        let newCollection = Collection.init(image: newImage, name: "Man's Collection", outFits: [], hairstyles: [newHairstyle])
                        newCollection.update()
                    } else {
                        mansCollections?.hairstyles.append(newHairstyle)
                        mansCollections?.update()
                    }
                } else {
                    var womansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Woman's Collection"})
                    if womansCollections.isNil {
                        let newCollection = Collection.init(image: newImage, name: "Woman's Collection", outFits: [], hairstyles: [newHairstyle])
                        newCollection.update()
                    } else {
                        womansCollections?.hairstyles.append(newHairstyle)
                        womansCollections?.update()
                    }
                }
            }
        }
    }
    
    func startFakeProgress() {
        progress = 0
        progressLabel.isHidden = false
        
        let totalSteps = estimatedTime / 0.2 // Количество обновлений
        let step = 95.0 / totalSteps // Доля увеличения за один шаг
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if self.progress < 95 {
                    self.progress += step
                    self.progressLabel.attributedText = "\(Int(self.progress))%".styled(as: .SemiBold54)
                } else {
                    timer.invalidate()
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            if let error = error {
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Успешно", message: "Изображение успешно сохранено!")
            }
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let navigationController = NavigationController(rootViewController: HomeController.instantiate())
        present(navigationController, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let image = imageView.image else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveError(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Нет доступа к фотогалерее")
                }
            }
        }
    }
    
    @IBAction func repeatButtonTapped(_ sender: Any) {
        blureView.isHidden = false
        progressLabel.attributedText = "0%".styled(as: .SemiBold54)
        progressLabel.isHidden = false
        startFakeProgress()
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.secondAccent
        imageView.image = originalImage
        
        if isOutFit {
            guard AppDelegate.isPremium || OutFit.hasFreeOutFits else {
                PaywallController.present(in: self, placementIdentifierId: .main)
                return
            }
            
            OutFit.getImage(initImage: originalImage, clothImage: patternImage ?? originalImage, category: category ?? .init(key: "", title: "") ) { [weak self] newImage in
                guard let self, let newImage else { return }
                blureView.isHidden = true
                progressLabel.attributedText = "100%".styled(as: .SemiBold54)
                progressLabel.isHidden = true
                saveButton.isEnabled = true
                imageView.image = newImage
                saveButton.backgroundColor = UIColor.accent
                
                let newOutFit = OutFit(originalImage: originalImage, image: newImage, patternImage: patternImage ?? newImage, isMan: isMen ?? true, name: "test", category: category, rootText: "")
                newOutFit.update()
                
                if isMen ?? true {
                    var mansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Man's Collection"})
                    if mansCollections.isNil {
                        let newCollection = Collection.init(image: newImage, name: "Man's Collection", outFits: [newOutFit], hairstyles: [])
                        newCollection.update()
                    } else {
                        mansCollections?.outFits.append(newOutFit)
                        mansCollections?.update()
                    }
                } else {
                    var womansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Woman's Collection"})
                    if womansCollections.isNil {
                        let newCollection = Collection.init(image: newImage, name: "Woman's Collection", outFits: [newOutFit], hairstyles: [])
                        newCollection.update()
                    } else {
                        womansCollections?.outFits.append(newOutFit)
                        womansCollections?.update()
                    }
                }
            }
        } else {
            guard AppDelegate.isPremium || Hairstyle.hasFreeHairstyles else {
                PaywallController.present(in: self, placementIdentifierId: .main)
                return
            }
            Hairstyle.getImage(initImage: originalImage, isMen: isMen ?? true, hairStyle: hairstyle ?? "BuzzCut") { [weak self] newImage in
                guard let self, let newImage else { return }
                blureView.isHidden = true
                progressLabel.attributedText = "100%".styled(as: .SemiBold54)
                progressLabel.isHidden = true
                saveButton.isEnabled = true
                imageView.image = newImage
                saveButton.backgroundColor = UIColor.accent
                
                let newHairstyle = Hairstyle(originalImage: originalImage, image: newImage, isMan: isMen ?? true, name: name ?? "test", rootText: hairstyle ?? "BuzzCut")
                newHairstyle.update()
                
                if isMen ?? true {
                    var mansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Man's Collection"})
                    if mansCollections.isNil {
                        let newCollection = Collection.init(image: newImage, name: "Man's Collection", outFits: [], hairstyles: [newHairstyle])
                        newCollection.update()
                    } else {
                        mansCollections?.hairstyles.append(newHairstyle)
                        mansCollections?.update()
                    }
                } else {
                    var womansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Woman's Collection"})
                    if womansCollections.isNil {
                        let newCollection = Collection.init(image: newImage, name: "Woman's Collection", outFits: [], hairstyles: [newHairstyle])
                        newCollection.update()
                    } else {
                        womansCollections?.hairstyles.append(newHairstyle)
                        womansCollections?.update()
                    }
                }
            }
        }
    }
}
