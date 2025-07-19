//
//  ResultController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 3.12.24.
//

import Foundation
import UIKit

class ResultController: UIViewController {
    
    var originalImage: UIImage!
    var patternImage: UIImage!
    var category: Category!
    var isRepeat: Bool = false
    var isOutFit: Bool!
    var outFits: [OutFit] = []
    var hairstyles: [Hairstyle] = []
    var isMen: Bool?
    
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var ideasLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var customView1: CustomImageView!
    @IBOutlet weak var customView2: CustomImageView!
    @IBOutlet weak var customView3: CustomImageView!
    @IBOutlet weak var customView4: CustomImageView!
    @IBOutlet weak var customView5: CustomImageView!
    @IBOutlet weak var checkbox1: CheckboxView!
    @IBOutlet weak var checkbox2: CheckboxView!
    @IBOutlet weak var checkbox3: CheckboxView!
    @IBOutlet var customViews: [CustomImageView]!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // test
//        customView1.mode = .activity
//        
//        OutFit.getImage(initImage: originalImage, clothImage: patternImage, category: category) { [weak self] newImage in
//            guard let self, let newImage else { return }
//            customView1.mode = .normal
//            customView1.setImage(newImage)
//            saveButton.isEnabled = true
//            saveButton.backgroundColor = UIColor.accent
//           // if isOutFit {
//            let newOutFit = OutFit(originalImage: originalImage, image: newImage, isMan: isMen ?? true, name: "test", category: category, rootText: "")
//                outFits.append(newOutFit)
//                newOutFit.update()
//            if isMen ?? true {
//                var mansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Man's Collection"})
//                if mansCollections.isNil {
//                    let newCollection = Collection.init(image: newImage, name: "Man's Collection", outFits: [newOutFit], hairstyles: [])
//                    newCollection.update()
//                } else {
//                    mansCollections?.outFits.append(newOutFit)
//                    mansCollections?.update()
//                }
//            } else {
//                var womansCollections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate }).first(where: {$0.name == "Woman's Collection"})
//                if womansCollections.isNil {
//                    let newCollection = Collection.init(image: newImage, name: "Woman's Collection", outFits: [newOutFit], hairstyles: [])
//                    newCollection.update()
//                } else {
//                    womansCollections?.outFits.append(newOutFit)
//                    womansCollections?.update()
//                }
//            }
//          //  } else {
//                
//           // }
//            
//            
//        }
//        
//        //        OutFit.getImage(for: originalImage, isMan: isMan, category: category, patternText: patternText) { [weak self] newImage in
//        //            guard let self, let newImage else { return }
//        //            customView1.mode = .normal
//        //            customView1.setImage(newImage)
//        //        }
//        
//        tittleLabel.attributedText = Constants.ResultScreen.result.styled(as: .SemiBold20)
//        ideasLabel.attributedText = Constants.ResultScreen.stylingIdeas.styled(as: .SemiBold16)
//        saveButton.layer.cornerRadius = 4
//        saveButton.setAttributedTitle(Constants.ResultScreen.saveToGallery.styled(as: .SemiBold18), for: .normal)
//        saveButton.isEnabled = false
//        saveButton.backgroundColor = UIColor.secondAccent
//        firstLabel.attributedText = "This look is stylish and effortlessly casual".styled(as: .SemiBold15)
//        secondLabel.attributedText = "The navy bomber jacket adds a sporty edge, while the white t-shirt keeps it fresh and clean. Pair this with dark joggers for a cohesive outfit.".styled(as: .Regular15)
//        
//        checkbox1.checkedImage = .emotion1On
//        checkbox1.uncheckedImage = .emotion1
//        checkbox2.checkedImage = .emotion2On
//        checkbox2.uncheckedImage = .emotion2
//        checkbox3.checkedImage = .emotion3On
//        checkbox3.uncheckedImage = .emotion3
//        
//        for view in customViews {
//            view.layer.cornerRadius = 3
//        }
//        
//        checkbox1.isChecked = false
//        checkbox2.isChecked = false
//        checkbox3.isChecked = false
//        
//        //test
//        customView1.setImage(originalImage)
//        customView2.setImage(originalImage)
//        customView3.setImage(originalImage)
//        customView4.setImage(originalImage)
//        customView5.setImage(originalImage)
//        customView5.mode = .hidden
//        customView3.mode = .hidden
//        customView4.mode = .hidden
//        customView2.mode = .hidden
//        
//    }
    
    func toggleSaveButton() {
        saveButton.isEnabled.toggle()
        if saveButton.isHidden {
            saveButton.backgroundColor = UIColor.secondAccent
        } else {
            saveButton.backgroundColor = .accent
        }
    }
    
    @IBAction func checkboxTapped(_ sender: CheckboxView) {
        checkbox1.isChecked = false
        checkbox2.isChecked = false
        checkbox3.isChecked = false
        
        sender.isChecked = true
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if isOutFit {
            for outFit in outFits {
                var newOutFit = outFit
                newOutFit.isLike = true
                newOutFit.update()
            }
        } else {
            for hairstyle in hairstyles {
                var newHairstyle = hairstyle
                newHairstyle.isLike = true
                newHairstyle.update()
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let navigationController = NavigationController(rootViewController: HomeController.instantiate())
        present(navigationController, animated: true)
    }
    
    @IBAction func repeatButtonTapped(_ sender: Any) {
//        customView1.mode = .activity
//        customView1.setImage(originalImage)
//        saveButton.isEnabled = false
//        saveButton.backgroundColor = UIColor.secondAccent
//        
//        OutFit.getImage(initImage: originalImage, clothImage: patternImage, category: category) { [weak self] newImage in
//            guard let self, let newImage else { return }
//            customView1.mode = .normal
//            customView1.setImage(newImage)
//            saveButton.isEnabled = true
//            saveButton.backgroundColor = UIColor.accent
//           // if isOutFit {
//            let newOutFit = OutFit(originalImage: originalImage, image: newImage, isMan: true, name: "White shirt", category: category, rootText: "")
//                outFits.append(newOutFit)
//                newOutFit.update()
//          //  } else {
//                
//           // }
//            
//            
//        }
//        
    }
}
