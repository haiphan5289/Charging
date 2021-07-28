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
//        static let heightCell: CGFloat = 190
//        static let widthCell: CGFloat = 130
        static let sizeCell = CGSize(width: 130, height: 190)
        static let spaceCell: CGFloat = 10
    }
    
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var selectIconModel:((IconModel) -> Void)?
    
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
                
                if let url = self.getUrlLocal(name: name, extensionMovie: .mov), let thumbnail = url.getThumbnailImage() {
                    cell.imgAnimation.image = thumbnail
                } else {
                    cell.imgAnimation.image = UIIMAGE_DEFAULT
                }
                
        }.disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected.bind { [weak self] idx in
            guard let wSelf = self else { return }
            let item = wSelf.listAnimation[idx.row]
            wSelf.selectIconModel?(item)
        }.disposed(by: disposeBag)
    }
    
    private func getUrlLocal(name: String, extensionMovie: ExtensionMovie) -> URL? {
        guard let path = Bundle.main.path(forResource: "\(name)", ofType: extensionMovie.rawValue)else {
            debugPrint("video.m4v not found")
            return nil
        }
        return URL(fileURLWithPath: path)
    }
    
}
extension AnimationDetail: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constant.sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spaceCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
