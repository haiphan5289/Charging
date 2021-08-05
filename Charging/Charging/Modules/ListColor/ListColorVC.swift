//
//  ListColorVC.swift
//  Charging
//
//  Created by haiphan on 27/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class ListColorVC: UIViewController {
    
    enum ColorCell: Int, CaseIterable {
        case white, yellow, cyan, green, pink, purple, orange, none
        
        var color: UIColor? {
            switch self {
            case .white:
                return Asset.white.color
            case .yellow:
                return Asset.yellow.color
            case .cyan:
                return Asset.cyan.color
            case .green:
                return Asset.green.color
            case .pink:
                return Asset.pink.color
            case .purple:
                return Asset.purple.color
            case .orange:
                return Asset.orange.color
            case .none:
                return UIColor.clear
            }
        }
        
    }
    
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vHeader: UIView!
    
    @VariableReplay private var datatSource: [IconModel] = []
    private var colorIndex: Int = ColorCell.white.rawValue
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
}
extension ListColorVC {
    
    private func setupUI() {
        tableView.delegate = self
        tableView.register(ListColorCell.nib, forCellReuseIdentifier: ListColorCell.identifier)
        self.colorIndex = ChargeManage.shared.colorIndex
        self.loadJSONEffect()
        self.vHeader.clipsToBounds = true
        self.vHeader.layer.cornerRadius = 15
        self.vHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupRX() {
        self.$datatSource.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: ListColorCell.identifier, cellType: ListColorCell.self)) {(row, element, cell) in
                guard let s = ColorCell(rawValue: row) else { return }
                cell.lbTitle.text = element.text
                cell.vColor.backgroundColor = s.color
                cell.imgSelection.isHidden = (self.colorIndex == row) ? false : true
                
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind(onNext: weakify({ (index, wSelf) in
            wSelf.colorIndex = index.row
            wSelf.tableView.reloadData()
        })).disposed(by: disposeBag)
        
        LisiConVC.TapAction.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            
            bt.rx.tap.bind { _ in
                
                switch type {
                case .cancel:
                    self.dismiss(animated: true, completion: nil)
                case .done: 
                    self.dismiss(animated: true) {
                        RealmManage.shared.addAndUpdateColor(data: self.colorIndex)                    }
                }
                
            }.disposed(by: disposeBag)
            
        }
        
    }
    
    private func loadJSONEffect() {
        ReadJSONFallLove.shared
            .readJSONObs(offType: [IconModel].self, name: "listColor", type: "json")
            .asObservable().bind(onNext: weakify({ (list, wSelf) in
                wSelf.datatSource =  list
            })).disposed(by: disposeBag)
    }
}
extension ListColorVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
