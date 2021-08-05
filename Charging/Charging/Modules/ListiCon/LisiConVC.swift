//
//  LisiConVC.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class LisiConVC: UIViewController {
    
    struct Constant {
        static let widthCell: CGFloat = 80
    }
    
    enum TapAction: Int, CaseIterable {
        case cancel, done
    }

    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vHeader: UIView!
    @VariableReplay private var listIcon: [IconModel] = []
    private var spaceLine: CGFloat = 0
    private var selectIcon: IconModel?
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spaceLine = (self.collectionView.bounds.size.width - (Constant.widthCell * 3)) / 2
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
extension LisiConVC {
    
    private func setupUI() {
        self.collectionView.delegate = self
        self.collectionView.register(ListiConCell.nib, forCellWithReuseIdentifier: ListiConCell.identifier)
        self.loadJSONEffect()
        self.selectIcon = ChargeManage.shared.iconAnimation
        self.vHeader.clipsToBounds = true
        self.vHeader.layer.cornerRadius = 15
        self.vHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupRX() {
        TapAction.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            
            bt.rx.tap.bind { _ in
                
                switch type {
                case .cancel:
                    self.dismiss(animated: true, completion: nil)
                case .done:
                    self.dismiss(animated: true) {
                        if let ic = self.selectIcon {
                            do {
                                let d = try ic.toData()
                                RealmManage.shared.addAndUpdateSetting(data: d)
                            } catch {
                                print("\(error.localizedDescription)")
                            }
                        }
                    }
                }
                
            }.disposed(by: disposeBag)
            
        }
        
        self.$listIcon.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: ListiConCell.identifier, cellType: ListiConCell.self)) { row, data, cell in
                guard let t = data.text else { return }
                cell.imgIcon.image = UIImage(named: t)
                cell.imgSelect.isHidden = (self.selectIcon == data) ? false : true
        }.disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected.bind(onNext: weakify({ idx, wSelf in
            wSelf.selectIcon = wSelf.listIcon[idx.row]
            wSelf.collectionView.reloadData()
        })).disposed(by: disposeBag)
    }
    
    private func loadJSONEffect() {
        ReadJSONFallLove.shared
            .readJSONObs(offType: [IconModel].self, name: "listicon", type: "json")
            .asObservable().bind(onNext: weakify({ (list, wSelf) in
                wSelf.listIcon =  list
            })).disposed(by: disposeBag)
    }
    
}
extension LisiConVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.widthCell, height: Constant.widthCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.spaceLine
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
