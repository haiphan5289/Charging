//
//  Animation.swift
//  Charging
//
//  Created by haiphan on 23/07/2021.
//

import UIKit
import RxSwift
import RxCocoa


class Animation: UIViewController {
    
    enum Openfrom {
        case selectAnimation, home
    }
    
    @IBOutlet weak var viewCharging: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    private var listAnimation: [AnimationModel] = []
    private var selectIconModel: AnimationRealmModel?
    private var viewModel = AnimationVM()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChargeManage.shared.updateAVPlayerfrom(avplayerfrom: .animation)
        ChargeManage.shared.eventPlayAVPlayer = ()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ChargeManage.shared.openfrom == .selectAnimation {
            self.viewModel.getListAnimation()
            ChargeManage.shared.openfrom = .home
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.tableView.reloadData()
    }
}
extension Animation {
    
    private func setupUI() {
        let charingView: ChargingView = ChargingView.loadXib()
        self.viewCharging.addSubview(charingView)
        charingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        charingView.playAnimation()
    }
    
    private func setupRX() {
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.viewModel.$listAnimation.asObservable().bind(onNext: weakify({ list, wSelf in
            wSelf.listAnimation = list
            wSelf.setupStackView(list: list)
        })).disposed(by: disposeBag)
        
//        ChargeManage.shared.$animationModel.asObservable().bind(onNext: weakify({ item, wSelf in
//            wSelf.selectIconModel = item
//            wSelf.tableView.reloadData()
//        })).disposed(by: disposeBag)
    }
    
//    func autoMove() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let vc = AnimationSelection.createVCfromStoryBoard()
//            vc.openfrom = .app
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
    private func setupStackView(list: [AnimationModel]) {
        list.enumerated().forEach { item in
            let animationDetail: AnimationDetail = AnimationDetail.loadXib()
            stackView.addArrangedSubview(animationDetail)
            animationDetail.snp.makeConstraints { make in
                make.width.equalTo(240)
            }
            animationDetail.selectAnimation = self.selectIconModel
            animationDetail.setupDisplay(item: item.element)
            animationDetail.actionSeeAll = {
                let vc = ListAnimation.createVC()
                let link = item.element.videos ?? []
                vc.listAnimation = link
                vc.titleLarge = item.element.name ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            animationDetail.selectIconModel = { [weak self] v in
                guard let wSelf = self else {
                    return
                }
                let vc = AnimationSelection.createVCfromStoryBoard()
                vc.animationIconModel = v
                wSelf.navigationController?.pushViewController(vc, animated: true)
            }
            animationDetail.moveToIntroduceApp = {
                let vc = IntroduceAppVC.createVC()
                vc.stataBack = .home
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    

 }
//extension Animation: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.listAnimation.count + 1
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        switch indexPath.row {
//        case 0:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChargingView.identifier) as? HomeCellGeneric<ChargingView>  else {
//                fatalError("Please Implement")
//            }
//            cell.view.playAnimation()
//            cell.backgroundColor = .clear
//            return cell
//        default:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnimationDetail.identifier) as? HomeCellGeneric<AnimationDetail>else {
//                fatalError("Please Implement")
//            }
//            cell.backgroundColor = .clear
//            let item = self.listAnimation[indexPath.row - 1]
//            cell.view.selectAnimation = self.selectIconModel
//            cell.view.setupDisplay(item: item)
//            cell.view.selectIconModel = { [weak self] v in
//                guard let wSelf = self else {
//                    return
//                }
//                let vc = AnimationSelection.createVCfromStoryBoard()
//                vc.animationIconModel = v
//                wSelf.navigationController?.pushViewController(vc, animated: true)
//            }
//            cell.view.actionSeeAll = {
//                let vc = ListAnimation.createVC()
//                let link = self.listAnimation[indexPath.row - 1].videos ?? []
//                vc.listAnimation = link
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            return cell
//        }
//
//    }
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let vc = AnimationSelection.createVCfromStoryBoard()
////
////        if let s = self.selectIconModel {
////            vc.animationIconModel = s
////        }
////
////        self.navigationController?.pushViewController(vc, animated: true)
////    }
//
//}
//extension Animation: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.1
//    }
//}
