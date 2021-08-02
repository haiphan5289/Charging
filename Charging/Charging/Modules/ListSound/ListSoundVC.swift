//
//  ListSoundVC.swift
//  Charging
//
//  Created by haiphan on 03/08/2021.
//

import UIKit
import RxCocoa
import RxSwift
import MediaPlayer

class ListSoundVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ListSoundVM()
    @VariableReplay private var listSound: [SoundModel] = []
    private var index: Int?
     
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
}
extension ListSoundVC {
    
    private func setupUI() {
        tableView.delegate = self
        tableView.register(ListSoundCell.nib, forCellReuseIdentifier: ListSoundCell.identifier)
    }
    
    private func setupRX() {
        self.viewModel.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.viewModel.$listSound.asObservable().bind(onNext: weakify({ list, wSelf in
            wSelf.listSound = list
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        self.$listSound.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: ListSoundCell.identifier, cellType: ListSoundCell.self)) {(row, element, cell) in
                cell.lbTitle.text = element.name
                if let index = self.index, index == row {
                    cell.imgSelection.isHidden = false
                } else {
                    cell.imgSelection.isHidden = true
                }
                
                guard let t = element.filename, let url = URL(string: t) else {
                    return
                }
                let player = AVPlayer(url: url)
                cell.statePlay = { stt in
                    switch stt {
                    case .pause:
                        player.pause()
                    case .play:
                        player.play()
                    }
                }
                
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind(onNext: weakify({ (index, wSelf) in
            wSelf.index = index.row
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
    }
    
}
extension ListSoundVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
