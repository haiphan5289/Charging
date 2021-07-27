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
    static var shared = ChargeManage()
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    var batteryState: UIDevice.BatteryState {
        return UIDevice.current.batteryState
    }
    
    @VariableReplay var eventBatteryLevel: Float?
    @VariableReplay var iconAnimation: IconModel = IconModel(text: "1")
    
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
    }
    
    func playAnimation(view: UIView, link: String) {
        guard let path = Bundle.main.path(forResource: "\(link)", ofType:"mp4")else {
            debugPrint("video.m4v not found")
            return
        }
        let url = URL(fileURLWithPath: path)
//        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            player.play()
        }
        
    }
    
    private func setupData() {
        self.getIconModel()
    }
    
    private func getIconModel() {
        let list = RealmManage.shared.getIconModel()
        if let f = list.first {
            self.iconAnimation = f
        }
    }
}
