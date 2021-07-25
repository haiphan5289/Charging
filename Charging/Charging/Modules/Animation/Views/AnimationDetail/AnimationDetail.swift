//
//  AnimationDetail.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class AnimationDetail: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btSeeAll: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @VariableReplay private var listAnimation: [CGFloat] = [1,2,3,4,5,6]
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
}
extension AnimationDetail {
    
    func setupDisplay(item: [Banner]?) {
        guard let item = item else {
            return
        }
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.register(AnimationDetailCell.nib, forCellWithReuseIdentifier: AnimationDetailCell.identifier)
    }
     
    private func setupRX() {
        self.$listAnimation.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: AnimationDetailCell.identifier, cellType: AnimationDetailCell.self)) { row, data, cell in
                if row % 2 == 0 {
                    cell.vContent.layer.borderWidth = 2
                    cell.vContent.layer.borderColor = Asset.brightskyblue.color.cgColor
                } else {
                    cell.vContent.layer.borderWidth = 0
                    cell.vContent.layer.borderColor = UIColor.clear.cgColor
                }
        }.disposed(by: disposeBag)
    }
    
}
extension AnimationDetail: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let g = (self.collectionView.bounds.size.width - 10 ) / 2
        
        let w = (self.collectionView.bounds.size.width - 10 - (g / 2) ) / 2
        
        return CGSize(width: w, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
