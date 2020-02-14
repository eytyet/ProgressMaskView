//
//  ParameterControlView.swift
//  TestProgressMaskView
//
//  Created by eytyet on 2020/02/14.
//  Copyright © 2020 Yu Software. All rights reserved.
//

import UIKit

@objc protocol ParameterControlViewDelegate: class {
    @objc optional func didColorChanged(_ parameterView: ParameterControlView, index: Int, color: UIColor)
    @objc optional func didBlendLevelChanged(_ parameterView: ParameterControlView, blendLevel: CGFloat)
    @objc optional func didWidthRatioChanged(_ parameterView: ParameterControlView, widthRatio: CGFloat)
    @objc optional func didRadiusRatioChanged(_ parameterView: ParameterControlView, radiusRatio: CGFloat)
}

class ParameterControlView: UIView {

    @IBOutlet var backgroundView: SimpleRView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var color1View: SimpleRView!
    @IBOutlet weak var color2View: SimpleRView!
    @IBOutlet weak var blendLabel: UILabel!
    @IBOutlet weak var blendSlider: UISlider!
    @IBOutlet weak var radiusSliderView: UISlider!
    @IBOutlet weak var radiusValue: UILabel!
    @IBOutlet weak var widthSliderView: UISlider!
    @IBOutlet weak var widthValue: UILabel!

    public weak var delegate: ParameterControlViewDelegate?

    /// Title string
    public var title: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }

    private func initialSetup() {
        // load xib
        let nib = UINib(nibName: "ParameterControlView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else {
            fatalError("Can't load ParameterControlView.xib")
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubviewWithConstraints(view)

        // setup UI
        blendSlider.minimumValue = 0
        blendSlider.maximumValue = 1.0
        blendSlider.value = 0.5
        blendLabel.text = "0.5"
        widthSliderView.minimumValue = 0
        widthSliderView.maximumValue = 0.5
        widthSliderView.value = 0.25
        widthValue.text = "0.25"
        radiusSliderView.minimumValue = 0
        radiusSliderView.maximumValue = 0.5
        radiusSliderView.value = 0.25
        radiusValue.text = "0.25"
    }

    // MARK: - UIView

    override var backgroundColor: UIColor? {
        get { backgroundView?.backgroundColor }
        set { backgroundView?.backgroundColor = newValue }
    }

    // MARK: - Actions

    @IBAction func onColor1Tap(_ sender: Any) {
        let color = UIColor.random
        UIView.animate(withDuration: 0.2) {
            self.color1View.backgroundColor = color
        }
        delegate?.didColorChanged?(self, index: 1, color: color)
    }

    @IBAction func onColor2Tap(_ sender: Any) {
        let color = UIColor.random
        UIView.animate(withDuration: 0.2) {
            self.color2View.backgroundColor = color
        }
        delegate?.didColorChanged?(self, index: 2, color: color)
    }

    @IBAction func onRadiusChanged(_ sender: UISlider) {
        let value = sender.value
        radiusValue.text = value.decimal(2)
        delegate?.didRadiusRatioChanged?(self, radiusRatio: CGFloat(value))
    }
    
    @IBAction func onWidthChanged(_ sender: UISlider) {
        let value = sender.value
        widthValue.text = value.decimal(2)
        delegate?.didWidthRatioChanged?(self, widthRatio: CGFloat(value))
    }
    
    @IBAction func onBlendChanged(_ sender: UISlider) {
        let value = sender.value
        blendLabel.text = value.decimal(2)
        delegate?.didBlendLevelChanged?(self, blendLevel: CGFloat(value))
    }
}
