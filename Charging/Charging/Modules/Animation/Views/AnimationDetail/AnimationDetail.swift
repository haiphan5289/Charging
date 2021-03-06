//
//  AnimationDetail.swift
//  Charging
//
//  Created by haiphan on 25/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class AnimationDetail: UIView, UpdateDisplayProtocol, DisplayStaticHeightProtocol {
    
    enum ExtensionMovie: String {
        case mp4, mov
    }
    
    struct Constant {
        static let heightCell: CGFloat = 190
        static let widthCell: CGFloat = 131
        static let heightImageSelection: CGFloat = 156
        static let sizeCell = CGSize(width: 131, height: 190)
        static let resizeImage = CGSize(width: 262, height: 380)
        static let spaceCell: CGFloat = 10
    }
    
    static var height: CGFloat { return 0 }
    static var bottom: CGFloat { return 0 }
    static var automaticHeight: Bool { return true }
    
    var selectIconModel:((Video) -> Void)?
    var actionSeeAll:(() -> Void)?
    var moveToIntroduceApp:(() -> Void)?
    
    var selectAnimation: AnimationRealmModel?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btSeeAll: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    //    @IBOutlet weak var stackView: UIStackView!
//    @IBOutlet weak var collectionView: UICollectionView!
    
    @VariableReplay private var listAnimation: [Video] = []
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
    
    func setupDisplay(item: AnimationModel?) {
        guard let item = item else {
            return
        }
        self.lbTitle.text = item.name ?? ""
        self.listAnimation = item.videos ?? []
        self.setupStackView(videos: self.listAnimation)
    }
    
    private func setupUI() {
//        collectionView.delegate = self
//        collectionView.register(AnimationDetailCell.nib, forCellWithReuseIdentifier: AnimationDetailCell.identifier)
    }
     
    private func setupRX() {
//        self.$listAnimation.asObservable()
//            .bind(to: self.collectionView.rx.items(cellIdentifier: AnimationDetailCell.identifier, cellType: AnimationDetailCell.self)) { row, data, cell in
//                if let s = self.selectAnimation, let n2 = data.filename, let u2 = URL(string: n2)?.lastPathComponent {
//
//                    if s.destinationURL.lastPathComponent == u2 {
//                        cell.imgSelection.isHidden = false
//                    } else {
//                        cell.imgSelection.isHidden = true
//                    }
//                } else {
//                    cell.imgSelection.isHidden = true
//                }
//
//                // check cached image
//                if let t = data.image, let cachedImage = ChargeManage.shared.imageCache.object(forKey: t as NSString)  {
////                    let thumbnail = cachedImage.resizeImage(Constant.resizeImage)
//                    cell.imgAnimation.image = cachedImage
//                    return
//                }
//
//                if let t = data.image, let url = URL(string: t) {
//
////                    ChargeManage.shared.dowloadImageURL(url: url) { dowloadURL in
////                        do {
////                            let data = try Data(contentsOf: dowloadURL)
////                            let img = UIImage(data: data)
////                            let thumbnail = img?.resizeImage(Constant.resizeImage)
////                            cell.imgAnimation.image = thumbnail
////                        } catch {
////
////                        }
////
////                    }
//
//                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
//
//                        if let image = image, let t = data.image {
////                            let thumbnail = image.resizeImage(Constant.resizeImage)
//                            ChargeManage.shared.imageCache.setObject(image, forKey: t as NSString)
//                            cell.imgAnimation.image = image
//                        } else {
//                            cell.imgAnimation.image = UIIMAGE_DEFAULT
//                        }
//
//                    })
//                } else {
//                    cell.imgAnimation.image = UIIMAGE_DEFAULT
//                }
//
//
//
//
////                if let url = name.getURLLocal(extensionMovie: .mov), let thumbnail = url.getThumbnailImage()?.resizeImage(Constant.resizeImage) {
////                    cell.imgAnimation.image = thumbnail
////                } else {
////                    cell.imgAnimation.image = UIIMAGE_DEFAULT
////                }
//
//        }.disposed(by: disposeBag)
//
//        self.collectionView.rx.itemSelected.bind { [weak self] idx in
//            guard let wSelf = self else { return }
//            if idx.row <= LIMIT_PRENIUM {
//                let item = wSelf.listAnimation[idx.row]
//                wSelf.selectIconModel?(item)
//            } else if Configuration.inPremiumUser() {
//                let item = wSelf.listAnimation[idx.row]
//                wSelf.selectIconModel?(item)
//            }
//        }.disposed(by: disposeBag)
        
        self.btSeeAll.rx.tap.bind { _ in
            self.actionSeeAll?()
        }.disposed(by: disposeBag)
    }
    
    func setupStackView(videos: [Video]) {
        
        videos.enumerated().forEach { item in
            let imageAnimation: ImageAnimation = ImageAnimation.loadXib()
            stackView.addArrangedSubview(imageAnimation)
            imageAnimation.snp.makeConstraints { make in
                make.width.equalTo(Constant.widthCell)
                make.height.equalTo(Constant.heightCell)
            }
            
            if let s = self.selectAnimation, let n2 = item.element.filename, let u2 = URL(string: n2)?.lastPathComponent {
                
                if s.destinationURL.lastPathComponent == u2 {
                    imageAnimation.imgSelection.isHidden = false
                } else {
                    imageAnimation.imgSelection.isHidden = true
                }
            } else {
                imageAnimation.imgSelection.isHidden = true
            }
            
            if let t = item.element.image, let url = URL(string: t) {
                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    
                    if let image = image, let t = item.element.image {
                        ChargeManage.shared.imageCache.setObject(image, forKey: t as NSString)
                        imageAnimation.imgAnimation.image = image
                    } else {
                        imageAnimation.imgAnimation.image = UIIMAGE_DEFAULT
                    }
                    
                })
            } else {
                imageAnimation.imgAnimation.image = UIIMAGE_DEFAULT
            }
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer()
            imageAnimation.addGestureRecognizer(tap)
            tap.rx.event.bind { [weak self] _ in
                guard let wSelf = self else { return }
                if item.offset <= LIMIT_PRENIUM {
                    wSelf.selectIconModel?(item.element)
                } else if Configuration.inPremiumUser() {
                    wSelf.selectIconModel?(item.element)
                } else {
                    self?.moveToIntroduceApp?()
                }
            }.disposed(by: disposeBag)
            
//            imageAnimation.btSelect.rx.tap.bind { [weak self] _ in
//                guard let wSelf = self else { return }
//                if item.offset <= LIMIT_PRENIUM {
//                    wSelf.selectIconModel?(item.element)
//                } else if Configuration.inPremiumUser() {
//                    wSelf.selectIconModel?(item.element)
//                }
//            }.disposed(by: disposeBag)
            
        }
        
    }
    
    func downloadImage(from url: URL, img: UIImageView) {
        print("Download Started")
        ChargeManage.shared.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                img.image = UIImage(data: data)
            }
        }
    }
    
}
//extension AnimationDetail: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let name = self.listAnimation[indexPath.row].text ?? ""
////        if let url = name.getURLLocal(extensionMovie: .mov), let thumbnail = url.getThumbnailImage(), let new = self.resizeImage(image: thumbnail, targetSize: Constant.sizeCell) {
////            return new.size
////        }
//        return Constant.sizeCell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return Constant.spaceCell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}
