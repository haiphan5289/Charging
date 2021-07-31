//
//  HowToUserAnimation.swift
//  Charging
//
//  Created by haiphan on 30/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class HowToUserAnimation: BaseNavigationViewController {
    
    enum StateCell: Int, CaseIterable {
        case open, click, slide, select, addAction, apps, chargingAnimation, selectChargingAnimation, next, turnOff, success
        
        var text: NSMutableAttributedString {
            switch self {
            case .open: return self.getAttributePrice(listText: [L10n._1.open, L10n.shortcuts, L10n.app])
            case .click: return self.getAttributePrice(listText: [L10n._2.clickThe, L10n.createPersonalAutomation])
            case .slide: return self.getAttributePrice(listText: [L10n._3.slideDownToTheBonttomOfTableAndSelect, L10n.charger])
            case .select: return self.getAttributePrice(listText: [L10n._4.selectThe, L10n.isConnected])
            case .addAction: return self.getAttributePrice(listText: [L10n._5.clickThe, L10n.addAction])
            case .apps: return self.getAttributePrice(listText: [L10n._6.clickThe, L10n.apps, L10n.button])
            case .chargingAnimation: return self.getAttributePrice(listText: [L10n._7.choose, L10n.animation, L10n.app2])
            case .selectChargingAnimation: return self.getAttributePrice(listText: [L10n._8.select, L10n.chargingAnimation, L10n.app3])
            case .next: return self.getAttributePrice(listText: [L10n._9.click, L10n.next])
            case .turnOff: return self.getAttributePrice(listText: [L10n._10.turnOffThe, L10n.askBeforeRunning, L10n.switchButton])
            case .success: return self.getAttributePrice(listText: [L10n.success])
            }
        }
        
        var imageState: UIImage? {
            switch self {
            case .open: return Asset.howToUseAnimation1.image
            case .click: return Asset.howToUseAnimation2.image
            case .slide: return Asset.howToUseAnimation3.image
            case .select: return Asset.howToUseAnimation4.image
            case .addAction: return Asset.howToUseAnimation5.image
            case .apps: return Asset.howToUseAnimation6.image
            case .chargingAnimation: return Asset.howToUseAnimation7.image
            case .selectChargingAnimation: return Asset.howToUseAnimation8.image
            case .next: return Asset.howToUseAnimation9.image
            case .turnOff: return Asset.howToUseAnimation10.image
            case .success: return Asset.howToUseAnimation11.image
            }
        }
        
        private func getAttributePrice(listText: [String]) -> NSMutableAttributedString {
            
            var attributedString1: NSMutableAttributedString?
            
            let attrs1 = [NSAttributedString.Key.font : UIFont.myMediumSystemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor : UIColor.white]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont.myMediumSystemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor : Asset._00D3Ff.color]
            
            listText.enumerated().forEach { item in
                if item.offset == 0 {
                    attributedString1 = NSMutableAttributedString(string: item.element, attributes:attrs1 as [NSAttributedString.Key : Any])
                } else if item.offset == 1 {
                    let attributedString2 = NSMutableAttributedString(string: item.element, attributes:attrs2 as [NSAttributedString.Key : Any])
                    attributedString1?.append(attributedString2)
                } else {
                    let attributedString2 = NSMutableAttributedString(string: item.element, attributes:attrs1 as [NSAttributedString.Key : Any])
                    attributedString1?.append(attributedString2)
                }
            }
            
            return attributedString1 ?? NSMutableAttributedString()
        }
        
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btOpenShortcuts: UIButton!
    
    @VariableReplay private var dataSource = StateCell.allCases
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }

}
extension HowToUserAnimation {
    
    private func setupUI() {
        titleLarge = L10n.howToUseAnimation
        collectionView.delegate = self
        collectionView.register(HowToUseAnimationCell.nib, forCellWithReuseIdentifier: HowToUseAnimationCell.identifier)
        self.pageControl.numberOfPages = self.dataSource.count
    }
    
    private func setupRX() {
        self.$dataSource.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: HowToUseAnimationCell.identifier, cellType: HowToUseAnimationCell.self)) { row, data, cell in
                cell.lbTitle.attributedText = data.text
                cell.imageAnimation.image = data.imageState
        }.disposed(by: disposeBag)
    }
    
}
extension HowToUserAnimation: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Hiển thị page curent
        let page_number = targetContentOffset.pointee.x / (self.view.frame.width)
        pageControl.currentPage = Int(page_number)
    }
    
}
