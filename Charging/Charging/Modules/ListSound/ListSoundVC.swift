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

protocol SoundCallBack {
    func resendSound(sound: SoundRealmModel)
}

class ListSoundVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var vHeader: UIView!
    
    var delegate: SoundCallBack?
    private let viewModel = ListSoundVM()
    @VariableReplay private var listSound: [SoundModel] = []
    private var index: Int?
    private var selectSound: SoundRealmModel?
    private var listAVPlayer: [AVAudioPlayer] = []
     
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
        self.vHeader.clipsToBounds = true
        self.vHeader.layer.cornerRadius = 15
        self.vHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupRX() {
        
        ChargeManage.shared.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
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
                cell.fileName = element.filename
                if let index = self.index, index == row {
                    cell.imgSelection.isHidden = false
                } else {
                    cell.imgSelection.isHidden = true
                    cell.stateVideo = .pause
                }
                cell.statePlay = { (_, av) in
                    if self.index == nil {
                        self.index = row
                        if let finalURL = cell.finalURL {
                            self.selectSound = SoundRealmModel(destinationURL: finalURL)
                        }
                    } else  if let index = self.index, index == row {
                        return
                    } else if let finalURL = cell.finalURL {
                        self.index = row
                        self.selectSound = SoundRealmModel(destinationURL: finalURL)
                    }
                    self.tableView.reloadData()
                }
                cell.textError = { textError in
                    LoadingManager.instance.dismiss()
                    self.showAlert(title: nil, message: textError)
                }
                
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind(onNext: weakify({ (index, wSelf) in
            guard let cell = wSelf.tableView.cellForRow(at: index) as? ListSoundCell, let finalURL = cell.finalURL else { return }
            wSelf.selectSound = SoundRealmModel(destinationURL: finalURL)
            wSelf.index = index.row
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        LisiConVC.TapAction.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            
            bt.rx.tap.bind { _ in
                
                switch type {
                case .cancel:
                    self.stopVideo()
                    self.dismiss(animated: true, completion: nil)
                case .done:
                    self.stopVideo()
                    self.dismiss(animated: true) {
                        if let s = self.selectSound {
                            self.delegate?.resendSound(sound: s)
                        }
                        
                    }
                    
                }
                
            }.disposed(by: disposeBag)
        }
    }
    
    private func stopVideo() {
        guard let index = self.index, let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ListSoundCell else {
            return
        }
        cell.bombSoundEffect.stop()
    }
    
}
extension ListSoundVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
