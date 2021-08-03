//
//  ManageCharge.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import Foundation
import RxSwift
import MediaPlayer

final class ChargeManage: ActivityTrackingProgressProtocol {
    
    struct LoadingModel {
        let current: Float
        let total: Float
        init(current: Float, total: Float) {
            self.current = current
            self.total = total
        }
        
        func getPercent() -> Float {
            return Float((self.current) / self.total)
        }
    }
    
    struct CacheSound {
        let originURL: String
        let destinationURL: URL
        init(originURL: String, destinationURL: URL) {
            self.originURL = originURL
            self.destinationURL = destinationURL
        }
    }
    
    struct CacheAnimation {
        let originURL: String
        let destinationURL: URL
        init(originURL: String, destinationURL: URL) {
            self.originURL = originURL
            self.destinationURL = destinationURL
        }
    }
    
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
    
    let imageCache = NSCache<NSString, UIImage>()
    
    @VariableReplay var eventBatteryLevel: Float?
    @VariableReplay var iconAnimation: IconModel = IconModel(text: "1")
    @VariableReplay var colorIndex: Int = ListColorVC.ColorCell.white.rawValue
    @VariableReplay var animationModel: AnimationRealmModel?
    @VariableReplay var eventPauseAVPlayer: Void?
    @VariableReplay var eventPlayAVPlayer: Void?
    @VariableReplay var listAnimation: [AnimationModel] = []
    @VariableReplay var listSound: [SoundModel] = []
    @VariableReplay var loadingModel: LoadingModel?
    @VariableReplay private var listSoundCache: [CacheSound] = []
//    @VariableReplay var listAnimationCache: [CacheAnimation] = []
    @VariableReplay var listURL: [URL] = []
//    @VariableReplay private var selectAnimationDraft: AnimationRealmModel?
    
    private let videoCache = NSCache<NSString, AVPlayer>()
    private var playerHome: AVPlayer?
    private var playerAnimationSelection: AVPlayer?
    private var playerIntroduce: AVPlayer?
    private var avplayerfrom: AVPlayerfrom = .animation
    private var disposeScroll: Disposable?
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
                guard  let wSelf = self,
                       let icon = notify.object as? AnimationIconModelRealm,
                       let model = icon.setting?.toCodableObject() as AnimationRealmModel?  else { return }
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
                playerLayer.frame = UIScreen.main.bounds
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
            
//            self.playerAnimationSelection = AVPlayer(url: url)
//            if let player = self.playerIntroduce {
//                let playerLayer = AVPlayerLayer(player: player)
//                playerLayer.frame = UIScreen.main.bounds
//                playerLayer.videoGravity = AVLayerVideoGravity.resize
//                view.layer.addSublayer(playerLayer)
//
//                player.play()
//    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//    //                player.play()
//    //            }
//            }
            
            // check cached image
            
            if let index = self.listURL.firstIndex(where: { $0.lastPathComponent == url.lastPathComponent })  {
                self.playerAnimationSelection = AVPlayer(url: self.listURL[index])
                let playerLayer = AVPlayerLayer(player: self.playerAnimationSelection)
                playerLayer.frame = UIScreen.main.bounds
                playerLayer.videoGravity = AVLayerVideoGravity.resize
                view.layer.addSublayer(playerLayer)
                self.playerAnimationSelection?.play()
                print("==== \(self.listURL[index])")
                return
            }

            RequestService.shared
                .startDownload(audioUrl: url.absoluteString) { [weak self] loadingModel in
                    guard let wSelf = self else { return }
                    wSelf.loadingModel = loadingModel
            }
            .bind { [weak self] dowURL  in
                guard let wSelf = self, let dowloadURL = dowURL else { return }
                wSelf.playerAnimationSelection = AVPlayer(url: dowloadURL)
                let playerLayer = AVPlayerLayer(player: wSelf.playerAnimationSelection)
                playerLayer.frame = UIScreen.main.bounds
                playerLayer.videoGravity = AVLayerVideoGravity.resize
                view.layer.addSublayer(playerLayer)
                if let p = wSelf.playerAnimationSelection {
//                    wSelf.videoCache.setObject(p, forKey: url.absoluteString as NSString)
//                    wSelf.listAnimationCache.append(CacheAnimation(originURL: url.absoluteString, destinationURL: dowloadURL))
//                    wSelf.selectAnimationDraft = Am(originURL: url.absoluteString, destinationURL: dowloadURL)
                    wSelf.copy(oldUrl: dowloadURL, success: { copyURL in
                        wSelf.listURL.append(copyURL)
                    }, failure: { _ in
                        
                    })
                    print("==== \(dowloadURL.absoluteString)")
                    p.play()
                }

            }.disposed(by: disposeBag)
        }
    }
    
    func playVideofromApp(view: UIView) {
        if  let destinationURL = self.animationModel?.destinationURL, let index = self.listURL.firstIndex(where: { $0.lastPathComponent == destinationURL.lastPathComponent }) {
            self.avplayerfrom = .animationSelection
            self.playerAnimationSelection = AVPlayer(url: self.listURL[index])
            if let player = self.playerAnimationSelection {
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = UIScreen.main.bounds
                playerLayer.videoGravity = AVLayerVideoGravity.resize
                view.layer.addSublayer(playerLayer)
                player.play()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    player.play()
                }
            }
        }
    }

    
    private func setupData() {
        self.getIconModel()
        self.getColornModel()
        self.getAnimationModel()
        self.getListRecord()
    }
    
    func updateAVPlayerfrom(avplayerfrom: AVPlayerfrom) {
        self.avplayerfrom = avplayerfrom
    }
    
    private func pauseAVPlayer(player: AVPlayer) {
        player.pause()
        player.seek(to: CMTime.zero)
    }
    
    private func playAgain(player: AVPlayer) {
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func getIconModel() {
        let list = RealmManage.shared.getIconModel()
        if let f = list.first {
//            self.iconAnimation = f
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
//            self.animationModel = f
            self.animationModel = f
        }
    }
    
    func dowloadURL(string: String, completion: @escaping ((URL) -> Void) ) {
        // check cached image
        if let index = self.listSoundCache.firstIndex(where: { $0.originURL == string })  {
            completion(self.listSoundCache[index].destinationURL)
            return
        }

        RequestService.shared
            .startDownload(audioUrl: string) { [weak self] loadingModel in
                guard let wSelf = self else { return }
                wSelf.loadingModel = loadingModel
        }
        .bind { [weak self] dowURL  in
            guard let wSelf = self, let dowloadURL = dowURL else { return }

            wSelf.listSoundCache.append(CacheSound(originURL: string, destinationURL: dowloadURL))
            completion(dowloadURL)
        }.disposed(by: disposeBag)
        
//                if let index = self.listSoundCache.firstIndex(where: { $0.originURL == string })  {
//                    completion(self.listSoundCache[index].destinationURL)
//                    return
//                }
//
//        let url = self.urlDefault()
//        self.listSoundCache.append(CacheSound(originURL: string, destinationURL: url))
//        completion(url)
        
    }
    
    func urlDefault() -> URL {
        guard let path = Bundle.main.path(forResource: "iphoneX", ofType:"mp4")else {
            debugPrint("video.m4v not found")
            return URL(fileURLWithPath: "path")
        }
        return URL(fileURLWithPath: path)
    }
    
    func copy(oldUrl: URL, success: @escaping ((URL) -> Void), failure: @escaping ((Error?) -> Void)) {
        //get media item first
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = oldUrl.lastPathComponent
        let outputURL = documentURL.appendingPathComponent("\(LINK_ANIMATION)/\(name)")
        do
            {
                try FileManager.default.copyItem(at: oldUrl, to: outputURL)
                success(outputURL)
            }
        catch let error as NSError
        {
            print(error.debugDescription)
        }
        
    }
    
    func createFolder(folder: String) {
        // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let imagesDirectoryPath = documentDirectoryPath.appending("/\(folder)")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: imagesDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: imagesDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                } catch {
                    print("Error creating images folder in documents dir: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func getListRecord() {
        guard let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        let appURL = URL(fileURLWithPath: documentDirectoryPath)
        let pdfPath = appURL.appendingPathComponent(LINK_ANIMATION)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: pdfPath , includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            //print the file listing to the console
            let l =  contents.sorted { ( u1: URL, u2: URL) -> Bool in
                do{
                    let values1 = try u1.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
                    let values2 = try u2.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
                    if let date1 = values1.contentModificationDate, let date2 = values2.contentModificationDate {
                        return date1.compare(date2) == ComparisonResult.orderedDescending
                    }
                }catch _{
                }
                
                return true
            }
            self.listURL = l
            
        } catch let err {
            print("\(err.localizedDescription)")
        }
    }
    
}
