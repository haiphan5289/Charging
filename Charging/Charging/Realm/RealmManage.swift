//
//  RealmManage.swift
//  CanCook
//
//  Created by paxcreation on 2/18/21.
//
import Realm
import RealmSwift
import RxSwift


class RealmManage {
    static var shared = RealmManage()
    var realm : Realm!
    init() {
        migrateWithCompletion()
        realm = try! Realm()
    }
    
    func migrateWithCompletion() {
        let config = RLMRealmConfiguration.default()
        config.schemaVersion = 7
        
        config.migrationBlock = { (migration, oldSchemaVersion) in
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        }
        
        RLMRealmConfiguration.setDefault(config)
        print("schemaVersion after migration:\(RLMRealmConfiguration.default().schemaVersion)")
        RLMRealm.default()
    }
    private func getSettingApp() -> [IconModelRealm] {
        let list = realm.objects(IconModelRealm.self).toArray(ofType: IconModelRealm.self)
        return list
    }
    func addAndUpdateSetting(data: Data) {
        let list = self.getSettingApp()
        guard list.count > 0, let _ = list.first else {
            let model: IconModel = IconModel(text: "1")
            let itemAdd = IconModelRealm.init(model: model)
            try! realm.write {
                realm.add(itemAdd)
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.updateIconModel.rawValue), object: itemAdd, userInfo: nil)
            }
            return
        }
        try! realm.write {
            list[0].setting = data
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.updateIconModel.rawValue), object: list[0], userInfo: nil)
        }
    }
    
    func getIconModel() -> [IconModel] {
        if self.getSettingApp().count <= 0 {
            self.addAndUpdateSetting(data: Data())
        }
        
        let listDiaryRealm = self.getSettingApp()
        var listDiaryModel: [IconModel] = []
        
        for m in listDiaryRealm {
            guard let model = m.setting?.toCodableObject() as IconModel? else{
                return []
            }
            listDiaryModel.append(model)
        }
        return listDiaryModel
    }
    
    private func getColorRealm() -> [ColorRealm] {
        let list = realm.objects(ColorRealm.self).toArray(ofType: ColorRealm.self)
        return list
    }
    func addAndUpdateColor(data: Int) {
        let list = self.getColorRealm()
        guard list.count > 0, let _ = list.first else {
            let itemAdd = ColorRealm.init(colorIndex: ListColorVC.ColorCell.white.rawValue)
            try! realm.write {
                realm.add(itemAdd)
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.updateColor.rawValue), object: itemAdd, userInfo: nil)
            }
            return
        }
        try! realm.write {
            list[0].colorIndex = data
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.updateColor.rawValue), object: list[0], userInfo: nil)
        }
    }
    
    func getColorModel() -> [Int] {
        if self.getColorRealm().count <= 0 {
            self.addAndUpdateColor(data: ListColorVC.ColorCell.white.rawValue)
        }
        
        let listDiaryRealm = self.getColorRealm()
        var listDiaryModel: [Int] = []
        
        for m in listDiaryRealm {
            listDiaryModel.append(m.colorIndex)
        }
        return listDiaryModel
    }
    
    private func getAnimationApp() -> [AnimationIconModelRealm] {
        let list = realm.objects(AnimationIconModelRealm.self).toArray(ofType: AnimationIconModelRealm.self)
        return list
    }
    func addAndUpdateAnimation(data: Data) {
        let list = self.getAnimationApp()
        guard list.count > 0, let _ = list.first else {
            let model: IconModel = IconModel(text: ANIMATION_DEFAULT)
            let itemAdd = AnimationIconModelRealm.init(model: model)
            try! realm.write {
                realm.add(itemAdd)
                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.updateAnimation.rawValue), object: itemAdd, userInfo: nil)
            }
            return
        }
        try! realm.write {
            list[0].setting = data
            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.updateAnimation.rawValue), object: list[0], userInfo: nil)
        }
    }
    
    func getAnimationIconModel() -> [IconModel] {
        if self.getAnimationApp().count <= 0 {
            self.addAndUpdateAnimation(data: Data())
        }
        
        let listDiaryRealm = self.getAnimationApp()
        var listDiaryModel: [IconModel] = []
        
        for m in listDiaryRealm {
            guard let model = m.setting?.toCodableObject() as IconModel? else{
                return []
            }
            listDiaryModel.append(model)
        }
        return listDiaryModel
    }
//    
//    private func getAudioEffect() -> [ManageEffectRealm] {
//        let list = realm.objects(ManageEffectRealm.self).toArray(ofType: ManageEffectRealm.self)
//        return list
//    }
//    func addAndUpdateEffect(data: Data) {
//        let list = self.getAudioEffect()
//        guard list.count > 0, let _ = list.first else {
//            let model: ManageEffectModel = ManageEffectModel()
//            let itemAdd = ManageEffectRealm.init(model: model)
//            try! realm.write {
//                realm.add(itemAdd)
//                NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.updateEffect.rawValue), object: nil, userInfo: nil)
//            }
//            return
//        }
//        try! realm.write {
//            list[0].effect = data
//            NotificationCenter.default.post(name: NSNotification.Name(PushNotificationKeys.updateEffect.rawValue), object: nil, userInfo: nil)
//        }
//    }
//    
//    func getEffect() -> [ManageEffectModel] {
//        if self.getAudioEffect().count <= 0 {
//            self.addAndUpdateEffect(data: Data())
//        }
//        
//        let listDiaryRealm = self.getAudioEffect()
//        var listDiaryModel: [ManageEffectModel] = []
//        
//        for m in listDiaryRealm {
//            guard let model = m.effect?.toCodableObject() as ManageEffectModel? else{
//                return []
//            }
//            listDiaryModel.append(model)
//        }
//        return listDiaryModel
//    }
}
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

extension Data {
    func toCodableObject<T: Codable>() -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        if let obj = try? decoder.decode(T.self, from: self) {
            return obj
        }
        return nil    }
    
}
