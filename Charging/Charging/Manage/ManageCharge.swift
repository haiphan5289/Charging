//
//  ManageCharge.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import Foundation
import RxSwift
import MediaPlayer

final class ChargeManage {
    
    enum AVPlayerfrom {
        case animation, animationSelection, introduce
    }
    
    static var shared = ChargeManage()
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    var batteryState: UIDevice.BatteryState {
        return UIDevice.current.batteryState
    }
    
    @VariableReplay var eventBatteryLevel: Float?
    @VariableReplay var iconAnimation: IconModel = IconModel(text: "1")
    @VariableReplay var colorIndex: Int = ListColorVC.ColorCell.white.rawValue
    @VariableReplay var animationModel: IconModel = IconModel(text: ANIMATION_DEFAULT)
    @VariableReplay var eventPauseAVPlayer: Void?
    @VariableReplay var eventPlayAVPlayer: Void?
    
    private var playerHome: AVPlayer?
    private var playerAnimationSelection: AVPlayer?
    private var playerIntroduce: AVPlayer?
    private var avplayerfrom: AVPlayerfrom = .animation
    private let disposeBag = DisposeBag()
    private init() {
        
    }
    
    func start() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        self.setupData()
        self.setupRX()
    }
    
    private func setupRX() {
        
        eventBatteryLevel = batteryLevel
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: UIDevice.batteryLevelDidChangeNotification.rawValue))
            .bind { notify in
                self.eventBatteryLevel = self.batteryLevel
                print("==== batteryLevel \(UIDevice.current.batteryLevel) ")
            }.disposed(by: disposeBag)
        
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: UIDevice.batteryStateDidChangeNotification.rawValue))
            .bind { notify in
                
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: PushNotificationKeys.updateIconModel.rawValue))
            .bind { [weak self] notify in
                guard  let wSelf = self, let icon = notify.object as? IconModelRealm, let model = icon.setting?.toCodableObject() as IconModel?  else { return }
                wSelf.iconAnimation = model
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: PushNotificationKeys.updateAnimation.rawValue))
            .bind { [weak self] notify in
                guard  let wSelf = self, let icon = notify.object as? IconModelRealm, let model = icon.setting?.toCodableObject() as IconModel?  else { return }
                wSelf.animationModel = model
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: PushNotificationKeys.updateColor.rawValue))
            .bind { [weak self] notify in
                guard  let wSelf = self, let icon = notify.object as? ColorRealm else { return }
                let m = icon.colorIndex 
                wSelf.colorIndex = m
            }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
            .bind { [weak self] notify in
                guard  let wSelf = self else { return }
                
                switch wSelf.avplayerfrom {
                case .animation:
                    if let player = wSelf.playerHome {
                        wSelf.playAgain(player: player)
                    }
                case .animationSelection:
                    if let player = wSelf.playerAnimationSelection {
                        wSelf.playAgain(player: player)
                    }
                case .introduce:
                    if let player = wSelf.playerIntroduce {
                        wSelf.playAgain(player: player)
                    }
                }
                
            }.disposed(by: disposeBag)
        
        self.$eventPauseAVPlayer.asObservable().bind { _ in
            switch self.avplayerfrom {
            case .animation:
                if let player = self.playerHome {
                    self.pauseAVPlayer(player: player)
                }
            case .animationSelection:
                if let player = self.playerAnimationSelection {
                    self.pauseAVPlayer(player: player)
                }
            case .introduce:
                if let player = self.playerIntroduce {
                    self.pauseAVPlayer(player: player)
                }
            }
        }.disposed(by: disposeBag)
        
        self.$eventPlayAVPlayer.asObservable().bind { _ in
            switch self.avplayerfrom {
            case .animation:
                if let player = self.playerHome {
                    self.playAgain(player: player)
                }
            case .animationSelection:
                if let player = self.playerAnimationSelection {
                    self.playAgain(player: player)
                }
            case .introduce:
                if let player = self.playerIntroduce {
                    self.playAgain(player: player)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func playAnimation(view: UIView, url: URL, avplayerfrom: AVPlayerfrom) {
        self.avplayerfrom = avplayerfrom
        switch avplayerfrom {
        case .animation:
            
    //        guard let path = Bundle.main.path(forResource: "\(link)", ofType:"mp4")else {
    //            debugPrint("video.m4v not found")
    //            return
    //        }
    //        let url = URL(fileURLWithPath: path)
    //        let player = AVPlayer(url: URL(fileURLWithPath: path))
    //        let player = AVPlayer(url: url)
            self.playerHome = AVPlayer(url: url)
            if let player = self.playerHome {
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = view.bounds
                playerLayer.videoGravity = AVLayerVideoGravity.resize
                view.layer.addSublayer(playerLayer)
                
                player.play()
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //                player.play()
    //            }
            }
        case .introduce:
            self.playerIntroduce = AVPlayer(url: url)
            if let player = self.playerIntroduce {
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = view.bounds
                playerLayer.videoGravity = AVLayerVideoGravity.resize
                view.layer.addSublayer(playerLayer)
                
                player.play()
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //                player.play()
    //            }
            }
        default:
//            guard let path = Bundle.main.path(forResource: "\(link)", ofType:"mp4")else {
//                debugPrint("video.m4v not found")
//                return
//            }
//            let url = URL(fileURLWithPath: path)
    //        let player = AVPlayer(url: URL(fileURLWithPath: path))
    //        let player = AVPlayer(url: url)
            self.playerAnimationSelection = AVPlayer(url: url)
            if let player = self.playerAnimationSelection {
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = view.bounds
                playerLayer.videoGravity = AVLayerVideoGravity.resize
                view.layer.addSublayer(playerLayer)
                
                player.play()
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //                player.play()
    //            }
            }
        }
    }
    
    private func setupData() {
        self.getIconModel()
        self.getColornModel()
        self.getAnimationModel()
    }
    
    func updateAVPlayerfrom(avplayerfrom: AVPlayerfrom) {
        self.avplayerfrom = avplayerfrom
    }
    
    private func pauseAVPlayer(player: AVPlayer) {
        player.pause()
    }
    
    private func playAgain(player: AVPlayer) {
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    private func getIconModel() {
        let list = RealmManage.shared.getIconModel()
        if let f = list.first {
            self.iconAnimation = f
        }
    }
    private func getColornModel() {
        let list = RealmManage.shared.getColorModel()
        if let f = list.first {
            self.colorIndex = f
        }
    }
    private func getAnimationModel() {
        let list = RealmManage.shared.getAnimationIconModel()
        if let f = list.first {
            self.animationModel = f
        }
    }
}
