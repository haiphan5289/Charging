//
//  ListAnimation.swift
//  Charging
//
//  Created by haiphan on 29/07/2021.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class ListAnimation: BaseNavigationViewController {
    
    struct Constant {
        static let widthCell: CGFloat = 110
        static let heightCell: CGFloat = 190
        static let spaceSection: CGFloat = 10
        static let sizeCell = CGSize(width: 110, height: 190)
        static let resizeImage = CGSize(width: 130, height: 190)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @VariableReplay var listAnimation: [Video] = []
    private var spaceLine: CGFloat = 0
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

}
extension ListAnimation {
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.register(ListAnimationCell.nib, forCellWithReuseIdentifier: ListAnimationCell.identifier)
    }
    
    private func setupRX() {
        self.$listAnimation.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: ListAnimationCell.identifier, cellType: ListAnimationCell.self)) { row, data, cell in
                
                // check cached image
                if let t = data.image, let cachedImage = ChargeManage.shared.imageCache.object(forKey: t as NSString)  {
                    let thumbnail = cachedImage.resizeImage(Constant.resizeImage)
                    cell.imgCell.image = thumbnail
                    return
                }
                
                if let t = data.image, let url = URL(string: t) {
                    
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                        
                        if let image = image, let t = data.image {
                            let thumbnail = image.resizeImage(Constant.resizeImage)
                            ChargeManage.shared.imageCache.setObject(image, forKey: t as NSString)
                            cell.imgCell.image = thumbnail
                        } else {
                            cell.imgCell.image = UIIMAGE_DEFAULT
                        }
                        
                    })
                } else {
                    cell.imgCell.image = UIIMAGE_DEFAULT
                }
                
        }.disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected.bind(onNext: weakify({ idx, wSelf in
            if idx.row <= LIMIT_PRENIUM {
                let vc = AnimationSelection.createVCfromStoryBoard()
                let item = self.listAnimation[idx.row]
                vc.animationIconModel = item
                wSelf.navigationController?.pushViewController(vc, animated: true)
            } else if Configuration.inPremiumUser() {
                let vc = AnimationSelection.createVCfromStoryBoard()
                let item = self.listAnimation[idx.row]
                vc.animationIconModel = item
                wSelf.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = InAppVC.createVC()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
        })).disposed(by: disposeBag)
    }
    
}
extension ListAnimation: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constant.sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spaceLine
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spaceSection
    }

}
