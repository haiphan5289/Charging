//
//  ListSoundVM.swift
//  Charging
//
//  Created by haiphan on 03/08/2021.
//

import Foundation
import RxSwift

class ListSoundVM: ActivityTrackingProgressProtocol  {
    
    @VariableReplay var listSound: [SoundModel] = []
    
    private let disposeBag = DisposeBag()
    init() {
        self.getListSound()
    }
    
    private func getListSound() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[SoundModel]>.self,
                                      url: APILink.listSound.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.listSound = model
                    ChargeManage.shared.listSound = model
                case .failure(let _): break
                }}.disposed(by: disposeBag)
        
        
    }
    
}
