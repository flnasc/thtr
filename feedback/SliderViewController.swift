//
//  SliderViewController.swift
//  feedback
//
//  Created by James Little on 11/15/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class SliderViewController: UITableViewController {

    var viewModels: [FeedbackDimension: FeedbackItemViewModel] = [
        .timeDistortion: FeedbackItemViewModel(type: .timeDistortion, value: 0),
        .spaceDistortion: FeedbackItemViewModel(type: .spaceDistortion, value: 0),
        .bodyDistortion: FeedbackItemViewModel(type: .bodyDistortion, value: 0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(FeedbackSliderTableViewCell.self, forCellReuseIdentifier: "FSReuseIdentifier")
        tableView.register(THTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.separatorColor = UIColor.clear
        tableView.alwaysBounceVertical = false

        navigationItem.title = "Distortion"

        if let sliderVals = GlobalReviewCoordinator.getCurrentReview()?.extras["sliders"] as? Int {
            viewModels[.timeDistortion]?.value = Float(sliderVals / 100) // 100s digit
            viewModels[.spaceDistortion]?.value = Float(sliderVals / 10 % 10) // 10s digit
            viewModels[.bodyDistortion]?.value = Float(sliderVals % 10) // 1s digit
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCellLabelWidths()
    }

    override func viewWillDisappear(_ animated: Bool) {
        let time = floor(viewModels[.timeDistortion]?.value ?? 0) * 100
        let space = floor(viewModels[.spaceDistortion]?.value ?? 0) * 10
        let body = floor(viewModels[.bodyDistortion]?.value ?? 0)

        if (time + space + body) > 0 {
            GlobalReviewCoordinator.getCurrentReview()?.extras["sliders"] = time + space + body
        }

        super.viewWillDisappear(animated)
    }

    func setCellLabelWidths() {
        let widths: [CGFloat] = tableView.visibleCells.compactMap {
            guard let cell = $0 as? FeedbackSliderTableViewCell else {
                return nil
            }
            return cell.typeLabel.frame.width
        }

        guard let maxLabelWidth = widths.max() else {
            return
        }

        tableView.visibleCells.forEach {
            guard let cell = $0 as? FeedbackSliderTableViewCell else {
                return
            }

            cell.setWidthConstraintTo(maxLabelWidth)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FSReuseIdentifier", for: indexPath) as? FeedbackSliderTableViewCell ?? FeedbackSliderTableViewCell()

            let type: FeedbackDimension = {
                switch indexPath.row {
                case 0:
                    return .timeDistortion
                case 1:
                    return .spaceDistortion
                case 2:
                    return .bodyDistortion
                default:
                    fatalError()
                }
            }()

            cell.model = viewModels[type]

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
            cell.textLabel?.text = "Use the Distortion Sliders to record a show's mediatization. To the left (more white) equals less media influence. Move a button to the right (more blue) to record greater media in the time, space, and bodies used in performance. \n\nFor more information on recording performance distortion, cf. Bay-Cheng, et al., Performance and Media: Taxonomies for a Changing Field (2015)."
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

typealias FeedbackValue = Float

enum FeedbackDimension {
    case timeDistortion
    case spaceDistortion
    case bodyDistortion
}

class FeedbackItemViewModel {
    var type: FeedbackDimension
    var value: FeedbackValue

    init(type: FeedbackDimension, value: FeedbackValue) {
        self.type = type
        self.value = value
    }
}

class FeedbackSliderTableViewCell: THTableViewCell {
    let slider: UISlider = create {
        $0.minimumValue = 0
        $0.maximumValue = 9
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let typeLabel: THLabel = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var model: FeedbackItemViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            let label = { () -> String in
                switch model.type {
                case .bodyDistortion:
                    return "Bodies"
                case .spaceDistortion:
                    return "Space"
                case .timeDistortion:
                    return "Time"
                }
            }()

            typeLabel.text = label
            slider.value = model.value
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Slider setup
        contentView.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)

        // Title setup
        contentView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            slider.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: contentView.layoutMargins.left * 3),
            slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.layoutMargins.right * 3),
            slider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])

        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left * 3),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
    }

    func setWidthConstraintTo(_ width: CGFloat) {
        NSLayoutConstraint.activate([typeLabel.widthAnchor.constraint(equalToConstant: width)])
        layoutSubviews()
    }

    @objc
    func sliderValueDidChange(sender: UISlider) {
        guard model != nil else {
            return
        }

        model!.value = sender.value
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
