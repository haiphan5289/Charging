//
//  ListSoundCell.swift
//  Charging
//
//  Created by haiphan on 03/08/2021.
//

import UIKit
import RxSwift
import MediaPlayer
import Alamofire

class ListSoundCell: UITableViewCell {
    
    enum StateVideo {
        case play, pause, none, finishPlay
    }
    var statePlay: ((StateVideo, AVAudioPlayer) -> Void)?
    var textError: ((String) -> Void)?

    @IBOutlet weak var btPlay: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    private let error = ErrorTracker()
    var fileName: String?
    var finalURL: URL?
    
    @VariableReplay var stateVideo: StateVideo = .none
    
    
    var bombSoundEffect: AVAudioPlayer = AVAudioPlayer()
    private var isPlaying: Bool = false
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        self.setupRX()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
        self.bombSoundEffect.stop()
    }
    
}
extension ListSoundCell {
    
    private func setupRX() {
        
        self.$stateVideo.asObservable().bind { [weak self] (state) in
            guard let wSelf = self else { return }
            
            switch state {
            case .none, .finishPlay:
                wSelf.bombSoundEffect.stop()
                wSelf.isPlaying = false
                wSelf.btPlay.setImage(Asset.icPlaySound.image, for: .normal)
            case .pause:
                wSelf.btPlay.setImage(Asset.icPlaySound.image, for: .normal)
                wSelf.bombSoundEffect.pause()
            case .play:
                wSelf.btPlay.setImage(Asset.icPauseSound.image, for: .normal)
                guard let url = wSelf.finalURL else { return }
                wSelf.playAudio(url: url)
            }
            
        }.disposed(by: disposeBag)
        
        self.btPlay.rx.tap.bind { _ in
            
            guard (self.finalURL != nil) else {
                self.flowDowloadURL()
                return
            }
            self.statePlay?(self.stateVideo, self.bombSoundEffect)
            switch self.stateVideo {
            case .pause, .none, .finishPlay:
                self.stateVideo = .play
            case .play:
                self.stateVideo = .pause
            }
            
        }.disposed(by: disposeBag)
        
//        _ = self.error
//            .asObservable()
//            .observe(on: MainScheduler.asyncInstance)
//            .flatMap { err -> Observable<Void> in
//                if let error = err as? AFError {
//                    self.textError?(error.localizedDescription)
//                }
//                return Observable.just(())
//            }.asDriverOnErrorJustComplete()
    }
    
    private func flowDowloadURL() {
        
        self.dowloadURL { [weak self] url  in
            guard let wSelf = self else { return }
            wSelf.finalURL = url
            wSelf.stateVideo = .play
            wSelf.statePlay?(wSelf.stateVideo, wSelf.bombSoundEffect)
        }
        
    }
    
    private func dowloadURL(complention:@escaping ((URL) -> Void) ) {
        guard let text = self.fileName, let url = URL(string: text) else {
            return
        }
       
        ChargeManage.shared.dowloadURL(url: url) { dowloadURL in
            complention(dowloadURL)
        } failure: { textError in
            self.textError?(textError)
        }

        
    }
    
    private func playAudio(url: URL) {
        //detect If Audio isplaying that solve to play Audio
        if isPlaying {
            bombSoundEffect.play()
            return
        }
        
        do {
            self.bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            self.bombSoundEffect.prepareToPlay()
            self.bombSoundEffect.volume = 1.0
            self.bombSoundEffect.play()
            self.bombSoundEffect.delegate = self
            self.isPlaying = true
        } catch {
            print(" Erro play Audio \(error.localizedDescription) ")
        }
    }
    
}
 
extension ListSoundCell: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stateVideo = .finishPlay
    }
}
