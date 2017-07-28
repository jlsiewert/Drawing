//
//  ColorSelectionViewController.swift
//  drawing
//
//  Created by Jan Luca Siewert on 28.07.17.
//  Copyright © 2017 Jan Luca Siewert. All rights reserved.
//

import UIKit

protocol ColorSelectionViewControllerDelegate: class {
    func colorSelectionViewController(_ controller: ColorSelectionViewController, didSelectColor color: ColorSelectionViewController.ColorSelection)
}

class ColorSelectionViewController: UIViewController {

    enum ColorSelection {
        case gray
        case white
        case red
        case blue
        case yellow
        case green
        case orange

        var uiColor: UIColor {
            switch self {
            case .gray:
                return .lightGray
            case .white:
                return .white
            case .red:
                return .red
            case .blue:
                return .blue
            case .yellow:
                return .yellow
            case .green:
                return .green
            case .orange:
                return .init(red: 1, green: 165/255, blue: 0, alpha: 1)
            }
        }
    }

    var delegate: ColorSelectionViewControllerDelegate?

    let colors: [ColorSelection]
    var buttons: [UIButton]!

    init(colors: [ColorSelection]) {
        self.colors = colors
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        colors = []
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        preferredContentSize = CGSize(width: 0, height: 60)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buttons = []
        for color in colors {
            buttons.append(createButton(forColor: color))
        }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        stackView.frame = view.frame
        view.addSubview(stackView)
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }

    func createButton(forColor color: ColorSelection) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_brightness_1_48pt"), for: .normal)
        button.tintColor = color.uiColor
        button.addTarget(self, action: #selector(didSelectButton(sender:)), for: .touchUpInside)
        return button
    }

    @objc func didSelectButton(sender: UIButton) {
        guard let index = buttons.index(of: sender) else {
            return
        }
        delegate?.colorSelectionViewController(self, didSelectColor: colors[index])
        dismiss(animated: true, completion: nil)
    }
}
