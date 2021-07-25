//
//  AnimationSelection.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import UIKit
import RxCocoa
import RxSwift
import MediaPlayer

class AnimationSelection: HideNavigationController {
    
    enum StatusAction {
        case show, hide
    }
    
//    var moviePlayer:AVContro!

    @IBOutlet weak var lbBattery: UILabel!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var hViewBottom: NSLayoutConstraint!
    @IBOutlet weak var vButtons: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btStatus: UIButton!
    
    @VariableReplay private var statusAction: StatusAction = .hide
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
        
//        let url:NSURL = NSURL(string: "https://www.youtube.com/watch?v=Xsl5P1JdIvY&list=RDXsl5P1JdIvY&start_radio=1")!
//
//        moviePlayer = MPMoviePlayerController(contentURL: url as URL)
//              moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
//
//              self.view.addSubview(moviePlayer.view)
//        moviePlayer.isFullscreen = true
//
//        moviePlayer.controlStyle = MPMovieControlStyle.embedded
        
//        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
        
//        let url = URL(string:myURL)
//
//        let player = AVPlayer(url: url!)
//
//        avpController.player = player
//
//        avpController.view.frame.size.height = videoView.frame.size.height
//
//        avpController.view.frame.size.width = videoView.frame.size.width
//
//        self.videoView.addSubview(avpController.view)
        
//        let player = AVPlayer(url: URL(string: "https://www.youtube.com/watch?v=Xsl5P1JdIvY&list=RDXsl5P1JdIvY&start_radio=1")!) // your video url
//              let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//              player.play()
    }
}
extension AnimationSelection {
    
    private func setupUI() {
        self.hViewBottom.constant = self.view.safeAreaBottom
        self.vButtons.clipsToBounds = true
        self.vButtons.layer.cornerRadius = 7
        self.vButtons.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupRX() {
        
        ChargeManage.shared.$eventBatteryLevel.bind(onNext: weakify({ value, wSelf in
            wSelf.lbBattery.text = value?.batterCharging
        })).disposed(by: disposeBag)
        
        self.$statusAction.asObservable().bind(onNext: weakify({ action, wSelf in
            
            let vs = [wSelf.btBack, wSelf.stackView]
            
            switch action {
            case .hide:
                vs.forEach { v in
                    v?.isHidden = true
                }
            case .show:
                vs.forEach { v in
                    v?.isHidden = false
                }
            }
            
        })).disposed(by: disposeBag)
        
        self.btStatus.rx.tap.bind { _ in
            switch self.statusAction {
            case .hide:
                self.statusAction = .show
            case .show:
                self.statusAction = .hide
            }
        }.disposed(by: disposeBag)
    }
    
}
