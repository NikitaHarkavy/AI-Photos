//
//  NewCollectionController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 4.12.24.
//
import UIKit

class NewCollectionController: UIViewController, UITextFieldDelegate {
    
    var isOutFits = true {
        didSet {
            update()
        }
    }
    
    var outFits: [OutFit] = []
    var hairstyles: [Hairstyle] = []
    var savedOutFits: [OutFit] = []
    var savedHairstyles: [Hairstyle] = []
    
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var collectionTitelLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var outFitsLabel: UIButton!
    @IBOutlet var hairstylesLabel: UIView!
    @IBOutlet weak var outFitsButton: UIButton!
    @IBOutlet weak var hairstylesButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        createButton.isHidden = true
        
        tittleLabel.attributedText = Constants.NewCollection.newCollection.styled(as: .Medium19)
        collectionTitelLabel.attributedText = Constants.NewCollection.collectionTitle.styled(as: .Regular16)
        textField.attributedPlaceholder = Constants.NewCollection.typeHere.styled(as: .Regular16Placeholder)
        textField.layer.cornerRadius = 5
        textField.textColor = .genLabel
        fromLabel.attributedText = Constants.NewCollection.fromSaved.styled(as: .Regular16)
        outFitsButton.setAttributedTitle(Constants.Saved.outFits.styled(as: .Regular16), for: .normal)
        outFitsButton.layer.cornerRadius = 5
        hairstylesButton.setAttributedTitle(Constants.Saved.hairstyles.styled(as: .Regular16), for: .normal)
        hairstylesButton.layer.cornerRadius = 5
        createButton.layer.cornerRadius = 4
        createButton.setAttributedTitle(Constants.NewCollection.createNew.styled(as: .SemiBold18), for: .normal)
        textField.delegate = self
        outFitsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        outFitsButton.titleLabel?.minimumScaleFactor = 0.5
        hairstylesButton.titleLabel?.adjustsFontSizeToFitWidth = true
        hairstylesButton.titleLabel?.minimumScaleFactor = 0.5
        createButton.titleLabel?.adjustsFontSizeToFitWidth = true
        createButton.titleLabel?.minimumScaleFactor = 0.5
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [flexibleSpace, doneButton]
        textField.inputAccessoryView = toolbar
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        collectionView.reloadData()
    }
    
    func updateButton() {
        updateOutFits()
        updateHairstyles()
        let selectedOutFitsForCombine = savedOutFits.filter { $0.isSelectedForCombine }
        let selectedHairstylesForCombine = savedHairstyles.filter { $0.isSelectedForCombine }
        let hasSelectedItems = !selectedHairstylesForCombine.isEmpty || !selectedOutFitsForCombine.isEmpty
        
        if  hasSelectedItems {
            UIView.animate(withDuration: 0.3) {
                self.createButton.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.createButton.isHidden = true
            }
        }
    }
    
    func update() {
        if isOutFits {
            outFitsButton.backgroundColor = .genLabel
            outFitsButton.setTitleColor(.background, for: .normal)
            hairstylesButton.backgroundColor = .collectionBackground
            hairstylesButton.setTitleColor(.greyCollection, for: .normal)
        } else {
            outFitsButton.backgroundColor = .collectionBackground
            outFitsButton.setTitleColor(.greyCollection, for: .normal)
            hairstylesButton.backgroundColor = .genLabel
            hairstylesButton.setTitleColor(.background, for: .normal)
        }
        collectionView.reloadData()
    }
    
    @objc func doneButtonTapped() {
        textField.resignFirstResponder()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateButton()
    }
    
    @objc func updateOutFits() {
        outFits = OutFit.all.values.sorted(by: { $0.creationDate > $1.creationDate })
        savedOutFits = outFits.filter { $0.isLike }
        collectionView.reloadData()
    }
    
    @objc func updateHairstyles() {
        hairstyles = Hairstyle.all.values.sorted(by: { $0.creationDate > $1.creationDate })
        savedHairstyles = hairstyles.filter { $0.isLike }
        collectionView.reloadData()
    }
    
    @IBAction func outFitButtonTapped(_ sender: Any) {
        isOutFits = true
    }
    
    @IBAction func hairstylesButtonTapped(_ sender: Any) {
        isOutFits = false
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        let selectedOutFitsForCombine = outFits.filter { $0.isSelectedForCombine }
        let selectedHairstylesForCombine = hairstyles.filter { $0.isSelectedForCombine }
        
        guard !selectedHairstylesForCombine.isEmpty || !selectedOutFitsForCombine.isEmpty else {return}
        
        var newCollection: Collection
        if !selectedOutFitsForCombine.isEmpty {
            let first = selectedOutFitsForCombine.first
            newCollection = Collection(image: first?.image ?? .ref, name: textField.text ?? "", outFits: selectedOutFitsForCombine, hairstyles: selectedHairstylesForCombine)
        } else {
            let first = selectedHairstylesForCombine.first
            newCollection = Collection(image: first?.image ?? .ref, name: textField.text ?? "", outFits: selectedOutFitsForCombine, hairstyles: selectedHairstylesForCombine)
        }
        newCollection.update()
        
        for outFit in savedOutFits {
            var updatedOutFit = outFit
            updatedOutFit.isSelectedForCombine = false
            updatedOutFit.update()
        }
        for hairstyle in savedHairstyles {
            var updatedHairstyle = hairstyle
            updatedHairstyle.isSelectedForCombine = false
            updatedHairstyle.update()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        for outFit in savedOutFits {
            var updatedOutFit = outFit
            updatedOutFit.isSelectedForCombine = false
            updatedOutFit.update()
        }
        for hairstyle in savedHairstyles {
            var updatedHairstyle = hairstyle
            updatedHairstyle.isSelectedForCombine = false
            updatedHairstyle.update()
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOutFits {
            return savedOutFits.count
        } else {
            return savedHairstyles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(of: OutFitCell.self, for: indexPath)
        
        if isOutFits {
            var object = savedOutFits[indexPath.item]
            
            cell.configure(outFit: object, hairstyle: nil, isDeleteMode: nil, isCombineMode: true)
            cell.onCheckboxTapped = { [weak self] in
                guard self != nil else { return }
                object.isSelectedForCombine.toggle()
                object.update()
                self?.updateButton()
            }
        } else {
            var object = savedHairstyles[indexPath.item]
            
            cell.configure(outFit: nil, hairstyle: object, isDeleteMode: nil, isCombineMode: true)
            cell.onCheckboxTapped = { [weak self] in
                guard self != nil else { return }
                object.isSelectedForCombine.toggle()
                object.update()
                self?.updateButton()
            }
        }
        return cell
    }
}

extension NewCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfColumns: CGFloat = 2
        let totalSpacing = layout.sectionInset.left + (numberOfColumns - 1) * layout.minimumInteritemSpacing + layout.sectionInset.right
        let width = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        let height = width / 173 * 251
        return CGSize(width: width, height: height)
    }
}
