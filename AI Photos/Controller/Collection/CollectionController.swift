//
//  CollectionController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 26.11.24.
//

import UIKit

class CollectionController: UIViewController {
    
    var collection: Collection!
    var isDeleteMode = false
    
    private var combinedItems: [CollectionItem] = []
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCollection),
            name: Collection.allUpdatedNotification,
            object: nil
        )

        
        nameLabel.attributedText = collection.name.styled(as: .Medium19)
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
        
        refreshCombinedItems()
  
    }
    
    @objc func updateCollection() {
        if !Collection.all[collection.id].isNil {
            collection = Collection.all[collection.id]
            refreshCombinedItems()
            collectionView.reloadData()
        }
    }
    
    private func refreshCombinedItems() {
            // Объединяем аутфиты и прически в единый массив
            let outfits = collection.outFits.map { CollectionItem.outfit($0) }
            let hairstyles = collection.hairstyles.map { CollectionItem.hairstyle($0) }
            
            // Сортируем по creationDate
            combinedItems = (outfits + hairstyles).sorted { $0.creationDate < $1.creationDate }
        }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        for item in combinedItems {
            var newItem = item
            newItem.isSelectedForDelete = false
            newItem.update()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dotsButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.deleteButton.isHidden.toggle()
        }
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        isDeleteMode.toggle()
                
                // Обновляем только видимые ячейки
                updateVisibleCells()
        UIView.animate(withDuration: 0.3) {
            self.deleteButton.isHidden.toggle()
        }
        
    }
    @IBAction func pluseButtonTapped(_ sender: Any) {
        let root = HomeController.instantiate()
        root.isNeedToOutFit = true
        
        let navigationController = NavigationController(rootViewController: root)
        present(navigationController, animated: true)
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        for item in combinedItems {
            switch item {
            case .outfit(let outfit):
                if outfit.isSelectedForDelete {
                    Collection.deleteOutFitFromCollection(collectionId: collection.id, outFitId: outfit.id)
                }
            case .hairstyle(let hairstyle):
                if hairstyle.isSelectedForDelete {
                    Collection.deleteHairstyleFromCollection(collectionId: collection.id, hairstyleId: hairstyle.id)
                }
            }
        }
        isDeleteMode = false
        updateVisibleCells()
        // После удаления обновляем коллекцию
        updateCollection()
        
    }
    private func updateVisibleCells() {
           // Получаем только видимые ячейки
           let visibleCells = collectionView.visibleCells.compactMap { $0 as? OutFitCell }
           
           for cell in visibleCells {
               if isDeleteMode {
                   cell.makeNotHidden() // Показываем чекбоксы
               } else {
                   cell.makeHidden() // Скрываем чекбоксы
               }
           }
        
        if isDeleteMode {
            UIView.animate(withDuration: 0.3) {
                self.trashButton.isHidden = false
                self.plusButton.isHidden = true
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.trashButton.isHidden = true
                self.plusButton.isHidden = false
            }
        }
        
       }
}

extension CollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return combinedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(of: OutFitCell.self, for: indexPath)
                let item = combinedItems[indexPath.item]
        
//
        
        switch item {
                case .outfit(var outfit):
                    cell.configure(outFit: outfit, hairstyle: nil, isDeleteMode: isDeleteMode, isCombineMode: nil)
                    cell.onCheckboxTapped = { [weak self] in
                        guard let self = self else { return }
                        outfit.isSelectedForDelete.toggle()
                        // Обновим в combinedItems состояние (лучше иметь словарь или обновить сразу исходный массив)
                        if let i = self.combinedItems.firstIndex(where: { $0.id == outfit.id }) {
                            self.combinedItems[i] = .outfit(outfit)
                        }
                    }
                case .hairstyle(var hairstyle):
                    cell.configure(outFit: nil, hairstyle: hairstyle, isDeleteMode: isDeleteMode, isCombineMode: nil)
                    cell.onCheckboxTapped = { [weak self] in
                        guard let self = self else { return }
                        hairstyle.isSelectedForDelete.toggle()
                        if let i = self.combinedItems.firstIndex(where: { $0.id == hairstyle.id }) {
                            self.combinedItems[i] = .hairstyle(hairstyle)
                        }
                    }
                }
        
        return cell
    }
    
    
}

extension CollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = EnlargedPhotoController.instantiate()
        let item = combinedItems[indexPath.item]
        switch item {
        case .outfit(let outfit):
            controller.outFit = outfit
        case .hairstyle(let hairstyle):
            controller.hairstyle = hairstyle
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfColumns: CGFloat = 2
        let totalSpacing = layout.sectionInset.left + (numberOfColumns - 1) * layout.minimumInteritemSpacing + layout.sectionInset.right
        let width = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        let height = width / 173 * 251
        return CGSize(width: width, height: height)
    }
}
