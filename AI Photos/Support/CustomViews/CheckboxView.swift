//
//  CheckboxView.swift
//  AI Photos
//
//  Created by Никита Горьковой on 26.11.24.
//

import UIKit

class CheckboxView: UIButton {
    // Свойства для изображений
    var checkedImage: UIImage? = UIImage.homeCheckboxOn
    var uncheckedImage: UIImage? = UIImage.homeCheckboxOff
    
    var onCheckboxTapped: (() -> Void)?
    
    // Состояние чекбокса
    var isChecked: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Устанавливаем начальное изображение
        updateImage()
        
        // Добавляем действие на клик
        addTarget(self, action: #selector(toggleChecked), for: .touchUpInside)
    }
    
    private func updateImage() {
        // Устанавливаем изображение в зависимости от состояния
        let image = isChecked ? checkedImage : uncheckedImage
        setImage(image, for: .normal)
    }
    
    @objc private func toggleChecked() {
        // Переключаем состояние
        isChecked.toggle()
        
        onCheckboxTapped?()
    }
}
