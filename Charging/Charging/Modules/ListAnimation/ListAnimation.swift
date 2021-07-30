//
//  ListAnimation.swift
//  Charging
//
//  Created by haiphan on 29/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class ListAnimation: BaseNavigationViewController {
    
    struct Constant {
        static let widthCell: CGFloat = 71
        static let heightCell: CGFloat = 158
        static let spaceSection: CGFloat = 8
        static let sizeCell: CGSize = CGSize(width: 71, height: 156)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @VariableReplay var listAnimation: [IconModel] = []
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
        titleLarge = L10n.hotAnimation
        collectionView.delegate = self
        collectionView.register(ListAnimationCell.nib, forCellWithReuseIdentifier: ListAnimationCell.identifier)
    }
    
    private func setupRX() {
        self.$listAnimation.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: ListAnimationCell.identifier, cellType: ListAnimationCell.self)) { row, data, cell in
                guard let name = data.text else { return }
              
                if let url = name.getURLLocal(extensionMovie: .mov), let thumbnail = url.getThumbnailImage() {
                    cell.imgCell.image = thumbnail
                } else {
                    cell.imgCell.image = UIIMAGE_DEFAULT
                }
                
        }.disposed(by: disposeBag)
    }
    
}
extension ListAnimation: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constant.sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spaceSection
    }

}
