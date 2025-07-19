//
//  CustomImageView.swift
//  AI Photos
//
//  Created by Никита Горьковой on 3.12.24.
//

import UIKit

class CustomImageView: UIView {
    
    // MARK: - Subviews
    
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private let getProButton = UIButton(type: .system)
    private let ideaLabel = UILabel()
    
    // MARK: - Modes
    
    enum Mode {
        case normal
        case activity
        case hidden
    }
    
    var mode: Mode = .normal {
        didSet {
            updateViewForCurrentMode()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        updateViewForCurrentMode()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
        updateViewForCurrentMode()
    }
    
    // MARK: - Setup Methods
    
    private func setupSubviews() {
        // Настройка imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        // Настройка индикатора активности
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        
        // Настройка blurView
        blurView.isHidden = true
        addSubview(blurView)
        sendSubviewToBack(blurView)
        sendSubviewToBack(imageView)
        
        // Настройка кнопки Get Pro
        getProButton.isHidden = true
        getProButton.setAttributedTitle("Get Pro".styled(as: .SemiBold15), for: .normal)
        getProButton.backgroundColor = .accent
        getProButton.setTitleColor(.white, for: .normal)
        getProButton.layer.cornerRadius = 3
        addSubview(getProButton)
        
        // Настройка лейбла
        ideaLabel.isHidden = true
        ideaLabel.attributedText = Constants.ResultScreen.moreIdeas.styled(as: .SemiBold17)
        ideaLabel.textColor = .background
        ideaLabel.textAlignment = .center
        addSubview(ideaLabel)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        getProButton.translatesAutoresizingMaskIntoConstraints = false
        ideaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Констрейнты для imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Констрейнты для activityIndicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Констрейнты для blurView
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Констрейнты для getProButton
        NSLayoutConstraint.activate([
            getProButton.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
            getProButton.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor, constant: 20),
            getProButton.widthAnchor.constraint(equalToConstant: 89),
            getProButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // Констрейнты для ideaLabel
        NSLayoutConstraint.activate([
            ideaLabel.bottomAnchor.constraint(equalTo: getProButton.topAnchor, constant: -16),
            ideaLabel.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 16),
            ideaLabel.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateViewForCurrentMode() {
        switch mode {
        case .normal:
            activityIndicator.stopAnimating()
            blurView.isHidden = true
            getProButton.isHidden = true
            ideaLabel.isHidden = true
        case .activity:
            activityIndicator.startAnimating()
            blurView.isHidden = false
            getProButton.isHidden = true
            ideaLabel.isHidden = true
        case .hidden:
            activityIndicator.stopAnimating()
            blurView.isHidden = false
            getProButton.isHidden = false
            ideaLabel.isHidden = false
        }
    }
    
    // MARK: - Public Methods
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
}
