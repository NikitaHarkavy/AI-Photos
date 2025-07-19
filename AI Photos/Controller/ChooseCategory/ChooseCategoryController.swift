//
//  ChooseCategory.swift
//  AI Photos
//
//  Created by Никита Горьковой on 27.11.24.
//

import UIKit

class ChooseCategoryController: UIViewController {
    
    var selectedIndex: IndexPath = IndexPath(item: 9, section: 0) {
        didSet {
            updateContinueButton()
        }
    }
    var originalImage: UIImage!
    var patternImage: UIImage!
    var isOutFit: Bool!
    var defaultOptions = [
        Category(key: "Party",       title: Constants.ChooseCategoryScreen.party),
        Category(key: "Formal",       title: Constants.ChooseCategoryScreen.formal),
        Category(key: "Elegant",      title: Constants.ChooseCategoryScreen.travel),
        Category(key: "Special",        title: Constants.ChooseCategoryScreen.special),
        Category(key: "Casual",    title: Constants.ChooseCategoryScreen.casual),
        Category(key: "Work",      title: Constants.ChooseCategoryScreen.work),
        Category(key: "Romantic",      title: Constants.ChooseCategoryScreen.daily),
        Category(key: "Sport",       title: Constants.ChooseCategoryScreen.sport),
        Category(key: "Date",        title: Constants.ChooseCategoryScreen.date)
    ]
    var isMen: Bool?
    var category: Category?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var outFitImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateContinueButton()
        
        tittleLabel.attributedText = Constants.ChooseCategoryScreen.lastStep.styled(as: .SemiBold20)
        chooseLabel.attributedText = Constants.ChooseCategoryScreen.chooseCategory.styled(as: .SemiBold20)
        continueButton.setAttributedTitle(Constants.ChooseCategoryScreen.continueButton.styled(as: .SemiBold18), for: .normal)
        continueButton.layer.cornerRadius = 4
        continueButton.titleLabel?.adjustsFontSizeToFitWidth = true
        continueButton.titleLabel?.minimumScaleFactor = 0.5
        outFitImageView.image = originalImage
    }
    
    func updateContinueButton() {
        if selectedIndex == IndexPath(item: 9, section: 0) {
            continueButton.isEnabled = false
            continueButton.backgroundColor = .secondAccent
           
        } else {
            continueButton.isEnabled = true
            continueButton.backgroundColor = .accent
           
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let controller = ResultController.instantiate()
        controller.originalImage = originalImage
        controller.patternImage = patternImage
        controller.category = category
        controller.isMen = isMen
        controller.isOutFit = isOutFit
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChooseCategoryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(of: CategoryCell.self, for: indexPath)
        
        cell.backgroundColoredView.layer.cornerRadius = 5
        let category = defaultOptions[indexPath.item]
        if indexPath == selectedIndex {
            cell.backgroundColoredView.backgroundColor = UIColor.genLabel
            cell.nameLabel.textColor = .background
        } else {
            cell.backgroundColoredView.backgroundColor = UIColor.collectionBackground
            cell.nameLabel.textColor = .greyCollection
        }
        cell.nameLabel.attributedText = category.title.styled(as: .Regular16)
        
        return cell
    }
}

extension ChooseCategoryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex.item < 9 {
            let oldSelectedIndex = selectedIndex
            selectedIndex = indexPath
            collectionView.reloadItems(at: [selectedIndex, oldSelectedIndex])
        } else {
            selectedIndex = indexPath
            collectionView.reloadItems(at: [selectedIndex])
        }
    }
}

extension ChooseCategoryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfColumns: CGFloat = 3
        let collectionViewWidth = UIScreen.main.bounds.width - (33 * 2)
        let totalSpacing = (numberOfColumns - 1) * layout.minimumInteritemSpacing
        let width = (collectionViewWidth - totalSpacing) / numberOfColumns
        return CGSize(width: width, height: 46)
    }
}
