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
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listAnimation: [CGFloat] = []
    private var viewModel = AnimationVM()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
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
        self.viewModel.$listAnimation.asObservable().bind(onNext: weakify({ list, wSelf in
            wSelf.listAnimation = list
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
//        self.viewModel.$listAnimation.asObservable()
//            .bind(to: tableView.rx.items(cellIdentifier: AnimationCell.identifier, cellType: AnimationCell.self)) {(row, element, cell) in
//                cell.backgroundColor = (row % 2 == 0) ? .red : .blue
//
//        }.disposed(by: disposeBag)
    }
 }
extension Animation: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAnimation.count
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
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AnimationSelection.createVCfromStoryBoard()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension Animation: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
