//
//  ParameterControlView.swift
//  TestProgressMaskView
//
//  Created by eytyet on 2020/02/14.
//  Copyright © 2020 Yu Software. All rights reserved.
//

import UIKit
import ProgressMaskView

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

    /// Return parameter set
    public var parameters: ProgressMaskBarParameter {
        return ProgressMaskBarParameter(color1: color1View.backgroundColor!, color2: color2View.backgroundColor!, blend: CGFloat(blendSlider!.value), widthRatio: CGFloat(widthSliderView!.value), radiusRatio: CGFloat(radiusSliderView!.value))
    }

    private var _backgroundColor: UIColor?

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
        widthSliderView.value = 0.1
        widthValue.text = "0.10"
        radiusSliderView.minimumValue = 0
        radiusSliderView.maximumValue = 0.5
        radiusSliderView.value = 0.5
        radiusValue.text = "0.50"
    }

    // MARK: - UIView

    /// IB set this backgroundColor and then set backgroundView.backgroundColor. Therefore, the specified background color is removed. So, keep it on _backgroundColor.
    override var backgroundColor: UIColor? {
        get { backgroundView?.backgroundColor }
        set {
            _backgroundColor = newValue
            backgroundView?.backgroundColor = newValue
        }
    }

    override func awakeFromNib() {
        if let color = _backgroundColor {
            backgroundView.backgroundColor = color
        }
    }

    override func prepareForInterfaceBuilder() {
        // Avoid 0 width on title.
        if let view = titleLabel.superview {
            view.addConstraint(view.widthAnchor.constraint(equalToConstant: 30))
        }
        if let color = _backgroundColor {
            backgroundView.backgroundColor = color
        }
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

    // MARK: - Methods

    func setParameter(color1: UIColor? = nil, color2: UIColor? = nil, blendLevel: CGFloat? = nil, radiusRatio: CGFloat? = nil, widthRatio: CGFloat? = nil) {
        if let color = color1 {
            color1View.backgroundColor = color
        }
        if let color = color2 {
            color2View.backgroundColor = color
        }
        if let blend = blendLevel {
            blendSlider.value = Float(blend)
            blendLabel.text = blend.decimal(2)
        }
        if let radius = radiusRatio {
            radiusSliderView.value = Float(radius)
            radiusValue.text = radius.decimal(2)
        }
        if let width = widthRatio {
            widthSliderView.value = Float(width)
            widthValue.text = width.decimal(2)
        }
    }


}
