//
//  SavedController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 28.11.24.
//
import UIKit

class SavedController: UIViewController {
    
    var isOutFits = true {
        didSet {
            update()
        }
    }
    
    var outFits: [OutFit] = []
    var groupedOutfits: [(sectionTitle: String, items: [OutFit])] = []
    var savedOutFits: [OutFit] = []
    
    var hairstyles: [Hairstyle] = []
    var groupedHairstyles: [(sectionTitle: String, items: [Hairstyle])] = []
    var savedHairstyles: [Hairstyle] = []
    
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var outFitsButton: UIButton!
    @IBOutlet weak var hairstylesButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateOutFits),
            name: OutFit.allUpdatedNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateHairstyles),
            name: Hairstyle.allUpdatedNotification,
            object: nil
        )
        
        update()
        updateOutFits()
        updateHairstyles()
        tittleLabel.attributedText = Constants.Saved.saved.styled(as: .Medium19)
        outFitsButton.layer.cornerRadius = 5
        hairstylesButton.layer.cornerRadius = 5
        
        
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        collectionView.reloadData()
    }
    
    func update() {
        if isOutFits {
            outFitsButton.setAttributedTitle(Constants.Saved.outFits.styled(as: .Regular16), for: .normal)
            outFitsButton.backgroundColor = .genLabel
            outFitsButton.setTitleColor(.background, for: .normal)
            
            hairstylesButton.setAttributedTitle(Constants.Saved.hairstyles.styled(as: .Regular16), for: .normal)
            hairstylesButton.backgroundColor = .collectionBackground
            hairstylesButton.setTitleColor(.greyCollection, for: .normal)
        } else {
            outFitsButton.setAttributedTitle(Constants.Saved.outFits.styled(as: .Regular16), for: .normal)
            outFitsButton.backgroundColor = .collectionBackground
            outFitsButton.setTitleColor(.greyCollection, for: .normal)
            
            hairstylesButton.setAttributedTitle(Constants.Saved.hairstyles.styled(as: .Regular16), for: .normal)
            hairstylesButton.backgroundColor = .genLabel
            hairstylesButton.setTitleColor(.background, for: .normal)
        }
        collectionView.reloadData()
    }
    
    func groupOutfitsByDate(outfits: [OutFit]) -> [(sectionTitle: String, items: [OutFit])] {
        var grouped: [String: [OutFit]] = [:]
        let calendar = Calendar.current
        
        for outfit in outfits {
            let creationDate = outfit.creationDate
            
            let sectionTitle: String
            if calendar.isDateInToday(creationDate) {
                sectionTitle = Constants.History.today
            } else if calendar.isDateInYesterday(creationDate) {
                sectionTitle = Constants.History.yesterday
            } else {
                let daysAgo = calendar.dateComponents([.day], from: creationDate, to: Date()).day ?? 0
                sectionTitle = "\(daysAgo) \(Constants.History.daysAgo)"
            }
            
            grouped[sectionTitle, default: []].append(outfit)
        }
        
        let sectionOrder: [String] = [
            Constants.History.today,
            Constants.History.yesterday
        ]
        
        let sortedSections = grouped.sorted { lhs, rhs in
            if let lhsIndex = sectionOrder.firstIndex(of: lhs.key), let rhsIndex = sectionOrder.firstIndex(of: rhs.key) {
                return lhsIndex < rhsIndex
            }
            return lhs.key > rhs.key
        }
        
        return sortedSections.map { (sectionTitle: $0.key, items: $0.value.sorted { $0.creationDate > $1.creationDate }) }
    }
    
    func groupHairstylesByDate(hairstyles: [Hairstyle]) -> [(sectionTitle: String, items: [Hairstyle])] {
        var grouped: [String: [Hairstyle]] = [:]
        let calendar = Calendar.current
        
        for hairstyle in hairstyles {
            let creationDate = hairstyle.creationDate
            
            let sectionTitle: String
            if calendar.isDateInToday(creationDate) {
                sectionTitle = Constants.History.today
            } else if calendar.isDateInYesterday(creationDate) {
                sectionTitle = Constants.History.yesterday
            } else {
                let daysAgo = calendar.dateComponents([.day], from: creationDate, to: Date()).day ?? 0
                sectionTitle = "\(daysAgo) \(Constants.History.daysAgo)"
            }
            grouped[sectionTitle, default: []].append(hairstyle)
        }
        
        let sectionOrder: [String] = [
            Constants.History.today,
            Constants.History.yesterday
        ]
        
        let sortedSections = grouped.sorted { lhs, rhs in
            if let lhsIndex = sectionOrder.firstIndex(of: lhs.key), let rhsIndex = sectionOrder.firstIndex(of: rhs.key) {
                return lhsIndex < rhsIndex
            }
            return lhs.key > rhs.key
        }
        
        return sortedSections.map { (sectionTitle: $0.key, items: $0.value.sorted { $0.creationDate > $1.creationDate }) }
    }
    
    @objc func updateOutFits() {
        outFits = OutFit.all.values.sorted(by: { $0.creationDate > $1.creationDate })
        savedOutFits = outFits.filter { $0.isLike }
        groupedOutfits = groupOutfitsByDate(outfits: savedOutFits)
        collectionView.reloadData()
    }
    
    @objc func updateHairstyles() {
        hairstyles = Hairstyle.all.values.sorted(by: { $0.creationDate > $1.creationDate })
        savedHairstyles = hairstyles.filter { $0.isLike }
        groupedHairstyles = groupHairstylesByDate(hairstyles: savedHairstyles)
        collectionView.reloadData()
    }
    
    @IBAction func outFitsButtonTapped(_ sender: Any) {
        isOutFits = true
    }
    
    @IBAction func hairstyleButtonTapped(_ sender: Any) {
        isOutFits = false
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SavedController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isOutFits {
            return groupedOutfits.count
        } else {
            return groupedHairstyles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOutFits {
            return groupedOutfits[section].items.count
        } else {
            return groupedHairstyles[section].items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(of: SavedCell.self, for: indexPath)
        
        if isOutFits {
            let object = groupedOutfits[indexPath.section].items[indexPath.item]
            
            cell.imageView.image = object.image
            cell.nameLabel.attributedText = object.name.styled(as: .Regular16)
            cell.repeatButton.layer.cornerRadius = 4
            cell.repeatButton.setAttributedTitle(Constants.Saved.repeatButton.styled(as: .SemiBold18), for: .normal)
            cell.repeatButtonTapped = {
                guard AppDelegate.isPremium || OutFit.hasFreeOutFits else {
                    PaywallController.present(in: self, placementIdentifierId: .main)
                    return
                }
                let controller = OneResultController.instantiate()
                controller.originalImage = object.originalImage
                controller.patternImage = object.patternImage
                controller.category = object.category
                controller.isMen = object.isMan
                controller.isOutFit = true
                controller.name = object.name
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            let object = groupedHairstyles[indexPath.section].items[indexPath.item]
            
            cell.imageView.image = object.image
            cell.nameLabel.attributedText = object.name.styled(as: .Regular16)
            cell.repeatButton.layer.cornerRadius = 4
            cell.repeatButton.setAttributedTitle(Constants.Saved.repeatButton.styled(as: .SemiBold18), for: .normal)
            cell.repeatButtonTapped = {
                guard AppDelegate.isPremium || Hairstyle.hasFreeHairstyles else {
                    PaywallController.present(in: self, placementIdentifierId: .main)
                    return
                }
                
                let controller = OneResultController.instantiate()
                controller.originalImage = object.originalImage
                controller.isMen = object.isMan
                controller.isOutFit = false
                controller.hairstyle = object.rootText
                controller.name = object.name
               
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        return cell
    }
}

extension SavedController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = EnlargedPhotoController.instantiate()
        if isOutFits {
            controller.outFit = groupedOutfits[indexPath.section].items[indexPath.item]
        } else {
            controller.hairstyle = groupedHairstyles[indexPath.section].items[indexPath.item]
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension SavedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfColumns: CGFloat = 2
        let totalSpacing = layout.sectionInset.left + (numberOfColumns - 1) * layout.minimumInteritemSpacing + layout.sectionInset.right
        let width = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        let height = width / 173 * 316
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CustomHeaderView
        
        let sectionTitle: String
        if isOutFits {
            sectionTitle = groupedOutfits[indexPath.section].sectionTitle
        } else {
            sectionTitle = groupedHairstyles[indexPath.section].sectionTitle
        }
        
        headerView.label.attributedText = sectionTitle.styled(as: .Regular16)
        headerView.label.textColor = .secLabel
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 54)
    }
}
