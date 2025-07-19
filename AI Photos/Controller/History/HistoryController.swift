//
//  HistoryController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 28.11.24.
//
import UIKit

class HistoryController: UIViewController {
    
    var outFits: [OutFit] = []
    var groupedOutfits: [(sectionTitle: String, items: [OutFit])] = []
    
    var hairstyles: [Hairstyle] = []
    var groupedHairstyles: [(sectionTitle: String, items: [Hairstyle])] = []
    
    var isOutFits: Bool!
    var isDeleteMode = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    
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
        
        updateHairstyles()
        updateOutFits()
        
        deleteButton.setAttributedTitle(Constants.Collection.delete.styled(as: .Medium16), for: .normal)
        deleteButton.layer.cornerRadius = 4
        deleteButton.layer.cornerRadius = 3
        deleteButton.layer.shadowRadius = 10
        deleteButton.layer.shadowColor = UIColor.blure.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        deleteButton.layer.shadowOpacity = 1
        deleteButton.isHidden = true
        trashButton.isHidden = true
        deleteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deleteButton.titleLabel?.minimumScaleFactor = 0.5
        tittleLabel.attributedText = Constants.History.history.styled(as: .SemiBold22)
        
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        collectionView.reloadData()
    }
    
    private func updateVisibleCells() {
        let visibleCells = collectionView.visibleCells.compactMap { $0 as? OutFitCell }
        
        for cell in visibleCells {
            if isDeleteMode {
                cell.makeNotHidden()
            } else {
                cell.makeHidden()
            }
        }
        
        if isDeleteMode {
            UIView.animate(withDuration: 0.3) {
                self.trashButton.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.trashButton.isHidden = true
            }
        }
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
        groupedOutfits = groupOutfitsByDate(outfits: outFits)
        collectionView.reloadData()
    }
    
    @objc func updateHairstyles() {
        hairstyles = Hairstyle.all.values.sorted(by: { $0.creationDate > $1.creationDate })
        groupedHairstyles = groupHairstylesByDate(hairstyles: hairstyles)
        collectionView.reloadData()
    }
    
    @IBAction func dotsButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.deleteButton.isHidden.toggle()
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        isDeleteMode.toggle()
        updateVisibleCells()
        UIView.animate(withDuration: 0.3) {
            self.deleteButton.isHidden.toggle()
        }
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        if isOutFits {
            for outFit in outFits {
                if outFit.isSelectedForDelete {
                    OutFit.deleteOutFitAndFromCollections(at: outFit.id)
                }
            }
            updateOutFits()
        } else {
            for hairstyle in hairstyles {
                if hairstyle.isSelectedForDelete {
                    Hairstyle.deleteHairstyleAndFromCollections(at: hairstyle.id)
                }
            }
            updateHairstyles()
        }
        isDeleteMode = false
        updateVisibleCells()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        for outFit in outFits {
            var updatedOutFit = outFit
            updatedOutFit.isSelectedForDelete = false
            updatedOutFit.update()
        }
        for hairstyle in hairstyles {
            var updatedHairstyle = hairstyle
            updatedHairstyle.isSelectedForDelete = false
            updatedHairstyle.update()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension HistoryController: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(of: OutFitCell.self, for: indexPath)
        
        if isOutFits {
            var outfit = groupedOutfits[indexPath.section].items[indexPath.item]
            cell.configure(outFit: outfit, hairstyle: nil, isDeleteMode: isDeleteMode, isCombineMode: nil)
            cell.onCheckboxTapped = { [weak self] in
                guard let self = self else { return }
                outfit.isSelectedForDelete.toggle()
                outfit.update()
            }
        } else {
            var hairstyle = groupedHairstyles[indexPath.section].items[indexPath.item]
            cell.configure(outFit: nil, hairstyle: hairstyle, isDeleteMode: isDeleteMode, isCombineMode: nil)
            cell.onCheckboxTapped = { [weak self] in
                guard let self = self else { return }
                hairstyle.isSelectedForDelete.toggle()
                hairstyle.update()
            }
        }
        return cell
    }
}

extension HistoryController: UICollectionViewDelegate {
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

extension HistoryController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfColumns: CGFloat = 2
        let totalSpacing = layout.sectionInset.left + (numberOfColumns - 1) * layout.minimumInteritemSpacing + layout.sectionInset.right
        let width = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        let height = width / 173 * 251
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CustomHeaderView
        let sectionTitle = groupedOutfits[indexPath.section].sectionTitle
        headerView.label.attributedText = sectionTitle.styled(as: .Regular16)
        headerView.label.textColor = .secLabel
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 54)
    }
}
