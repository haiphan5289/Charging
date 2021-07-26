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
    @VariableReplay private var listIcon: [IconModel] = []
    private var spaceLine: CGFloat = 0
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }

}
extension LisiConVC {
    
    private func setupUI() {
        self.collectionView.delegate = self
        self.collectionView.register(ListiConCell.nib, forCellWithReuseIdentifier: ListiConCell.identifier)
        self.loadJSONEffect()
        
        spaceLine = (self.collectionView.bounds.size.width - (Constant.widthCell * 3)) / 2
        self.collectionView.reloadData()
    }
    
    private func setupRX() {
        TapAction.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            
            bt.rx.tap.bind { _ in
                
                switch type {
                case .cancel:
                    self.dismiss(animated: true, completion: nil)
                case .done: break
                }
                
            }.disposed(by: disposeBag)
            
        }
        
        self.$listIcon.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: ListiConCell.identifier, cellType: ListiConCell.self)) { row, data, cell in
                guard let t = data.text else { return }
                
                cell.imgIcon.image = UIImage(named: t)
                
                cell.imgSelect.isHidden = ( row == 0 ) ? false : true
                
        }.disposed(by: disposeBag)
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
