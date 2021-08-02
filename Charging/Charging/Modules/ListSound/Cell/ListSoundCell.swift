//
//  ListSoundCell.swift
//  Charging
//
//  Created by haiphan on 03/08/2021.
//

import UIKit
import RxSwift

class ListSoundCell: UITableViewCell {
    
    enum StateVideo {
        case play, pause
    }
    var statePlay: ((StateVideo) -> Void)?

    @IBOutlet weak var btPlay: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        self.btPlay.rx.tap.bind { _ in
            
            if self.btPlay.isSelected {
                self.btPlay.isSelected = false
                self.statePlay?(StateVideo.pause)
                self.btPlay.setImage(Asset.icPlaySound.image, for: .normal)
            } else {
                self.btPlay.isSelected = true
                self.statePlay?(StateVideo.play)
                self.btPlay.setImage(Asset.icPauseSound.image, for: .normal)
            }
            
        }.disposed(by: disposeBag)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
