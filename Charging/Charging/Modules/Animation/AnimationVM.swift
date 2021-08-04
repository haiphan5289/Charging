//
//  AnimationVM.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import RxSwift
import Foundation

class AnimationVM: ActivityTrackingProgressProtocol {
    
    @VariableReplay var listAnimation: [AnimationModel] = []
    
    private let disposeBag = DisposeBag()
    init() {
//        self.loadJSONEffect()
        self.getListAnimation()
    }
    
//    private func loadJSONEffect() {
//        ReadJSONFallLove.shared
//            .readJSONObs(offType: [ChargingAnimationModel].self, name: "listVideo", type: "json")
//            .asObservable().bind { [weak self] list in
//                guard let wSelf = self else { return }
//                wSelf.listAnimation = list
//            }.disposed(by: disposeBag)
//    }
//
    func getListAnimation() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[AnimationModel]>.self,
                                      url: APILink.listAnimation.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.listAnimation = model
                    ChargeManage.shared.listAnimation = model
                case .failure(let _): break
                }}.disposed(by: disposeBag)
        
        
    }
    
}
