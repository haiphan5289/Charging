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
    
    enum ExtensionMovie: String {
        case mp4, mov
    }
    
    struct Constant {
        static let heightCell: CGFloat = 190
        static let widthCell: CGFloat = 107
        static let heightImageSelection: CGFloat = 156
        static let sizeCell = CGSize(width: 71, height: 156)
        static let spaceCell: CGFloat = 10
    }
    
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var selectIconModel:((IconModel) -> Void)?
    var actionSeeAll:(() -> Void)?
    
    var selectAnimation: IconModel?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btSeeAll: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @VariableReplay private var listAnimation: [IconModel] = []
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
    
    func setupDisplay(item: ChargingAnimationModel?) {
        guard let item = item else {
            return
        }
        self.lbTitle.text = item.title ?? ""
        self.listAnimation = item.link ?? []
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.register(AnimationDetailCell.nib, forCellWithReuseIdentifier: AnimationDetailCell.identifier)
    }
     
    private func setupRX() {
        self.$listAnimation.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: AnimationDetailCell.identifier, cellType: AnimationDetailCell.self)) { row, data, cell in
                guard let name = data.text else { return }
                
                if let s = self.selectAnimation, let n1 = s.text, let n2 = data.text {
                    if n1 == n2 {
                        cell.imgSelection.isHidden = false
                    } else {
                        cell.imgSelection.isHidden = true
                    }
                } else {
                    cell.imgSelection.isHidden = true
                }
                
                if let url = name.getURLLocal(extensionMovie: .mov), let thumbnail = url.getThumbnailImage()?.resizeImage(Constant.sizeCell) {
                    cell.imgAnimation.image = thumbnail
                } else {
                    cell.imgAnimation.image = UIIMAGE_DEFAULT
                }
                
                cell.imgSelection.image = Asset.icSelectionHome.image.resizeImage(Constant.sizeCell) 
                
        }.disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected.bind { [weak self] idx in
            guard let wSelf = self else { return }
            let item = wSelf.listAnimation[idx.row]
            wSelf.selectIconModel?(item)
        }.disposed(by: disposeBag)
        
        self.btSeeAll.rx.tap.bind { _ in
            self.actionSeeAll?()
        }.disposed(by: disposeBag)
    }
    
}
extension AnimationDetail: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let name = self.listAnimation[indexPath.row].text ?? ""
//        if let url = name.getURLLocal(extensionMovie: .mov), let thumbnail = url.getThumbnailImage(), let new = self.resizeImage(image: thumbnail, targetSize: Constant.sizeCell) {
//            return new.size
//        }
        return Constant.sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spaceCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
