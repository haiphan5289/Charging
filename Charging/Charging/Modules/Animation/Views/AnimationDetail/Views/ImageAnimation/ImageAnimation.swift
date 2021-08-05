//
//  ImageAnimation.swift
//  Charging
//
//  Created by haiphan on 05/08/2021.
//

import UIKit

class ImageAnimation: UIView {

    @IBOutlet weak var imgAnimation: UIImageView!
    @IBOutlet weak var imgSelection: UIImageView!
//    @IBOutlet weak var btSelect: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
}
