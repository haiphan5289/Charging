//
//  Animation.swift
//  Charging
//
//  Created by haiphan on 23/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

let imageCache = NSCache<NSString, UIImage>()
class Animation: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listAnimation: [AnimationModel] = []
    private var selectIconModel: IconModel?
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.reloadData()
    }
}
extension Animation {
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeCellGeneric<AnimationDetail>.self, forCellReuseIdentifier: AnimationDetail.identifier)
        tableView.register(HomeCellGeneric<ChargingView>.self, forCellReuseIdentifier: ChargingView.identifier)
    }
    
    private func setupRX() {
        
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.viewModel.$listAnimation.asObservable().bind(onNext: weakify({ list, wSelf in
            wSelf.listAnimation = list
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        ChargeManage.shared.$animationModel.asObservable().bind(onNext: weakify({ item, wSelf in
            wSelf.selectIconModel = item
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
    }
    
//    func autoMove() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let vc = AnimationSelection.createVCfromStoryBoard()
//            vc.openfrom = .app
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
    

 }
extension Animation: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAnimation.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChargingView.identifier) as? HomeCellGeneric<ChargingView>  else {
                fatalError("Please Implement")
            }
            cell.view.playAnimation()
            cell.backgroundColor = .clear
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnimationDetail.identifier) as? HomeCellGeneric<AnimationDetail>else {
                fatalError("Please Implement")
            }
            cell.backgroundColor = .clear
            let item = self.listAnimation[indexPath.row - 1]
            cell.view.selectAnimation = self.selectIconModel
            cell.view.setupDisplay(item: item)
            cell.view.selectIconModel = { [weak self] v in
                guard let wSelf = self else {
                    return
                }
                let vc = AnimationSelection.createVCfromStoryBoard()
                vc.animationIconModel = v
                wSelf.navigationController?.pushViewController(vc, animated: true)
            }
            cell.view.actionSeeAll = {
                let vc = ListAnimation.createVC()
                let link = self.listAnimation[indexPath.row - 1].videos ?? []
                vc.listAnimation = link
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AnimationSelection.createVCfromStoryBoard()
        
        if let s = self.selectIconModel {
            vc.animationIconModel = s
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension Animation: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
