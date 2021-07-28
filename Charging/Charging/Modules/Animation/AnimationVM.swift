//
//  AnimationVM.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import RxSwift
import Foundation

class AnimationVM {
    
    @VariableReplay var listAnimation: [ChargingAnimationModel] = []
    
    private let disposeBag = DisposeBag()
    init() {
        self.loadJSONEffect()
    }
    
    private func loadJSONEffect() {
        ReadJSONFallLove.shared
            .readJSONObs(offType: [ChargingAnimationModel].self, name: "listVideo", type: "json")
            .asObservable().bind { [weak self] list in
                guard let wSelf = self else { return }
                wSelf.listAnimation = list
            }.disposed(by: disposeBag)
    }
    
    
}
