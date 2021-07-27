//
//  RealmManageModel.swift
//  CanCook
//
//  Created by paxcreation on 2/18/21.
//
import Foundation
import RealmSwift
import UIKit

class IconModelRealm: Object {
    @objc dynamic var setting: Data?

    init(model: IconModel) {
        super.init()
        do {
            setting = try model.toData()
        } catch let err {
            print("\(err.localizedDescription)")
        }
    }
    required init() {
        super.init()
    }
}

class ColorRealm: Object {
    @objc dynamic var colorIndex: Int = 0

    init(colorIndex: Int) {
        super.init()
        self.colorIndex = colorIndex
    }
    required init() {
        super.init()
    }
}
