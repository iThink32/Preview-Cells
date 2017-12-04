//
//  AdvertisementFlowLayout.swift
//  DemoApp
//
//  Created by Shashank on 10/11/17.
//

import UIKit

class AdvertisementFlowLayout: UICollectionViewFlowLayout {
    
    var latestOffset = CGPoint(x: 0, y: 0)
    let peekLengthOfCell = CGFloat(10)
    
    override func prepare() {
        super.prepare()
        self.minimumLineSpacing = 10
        guard let collectionView = self.collectionView else{
            return
        }
        self.itemSize = CGSize(width: collectionView.frame.size.width - ((self.minimumLineSpacing * 2) + ( self.peekLengthOfCell * 2)), height: collectionView.frame.size.height - 20)
        self.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard velocity != CGPoint.zero,let collectionView = self.collectionView else{
            return self.latestOffset
        }
        let bounds = collectionView.bounds
        let halfWidth = bounds.size.width * 0.5
        
        guard let arrVisibleCellAttributes = self.layoutAttributesForElements(in: bounds) else{
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        var reqdElementAttributes:UICollectionViewLayoutAttributes?
        arrVisibleCellAttributes.forEach { (layoutAttributes) in
            guard layoutAttributes.representedElementCategory == UICollectionElementCategory.cell else{
                return
            }
            let reqdPoint = layoutAttributes.frame.origin.x + layoutAttributes.bounds.size.width - self.peekLengthOfCell
            guard (reqdPoint == 0) || (layoutAttributes.center.x  > collectionView.contentOffset.x + halfWidth) && velocity.x < 0 else{
                reqdElementAttributes = layoutAttributes
                return
            }
            return
        }
        guard let unwrappedElementAttributes = reqdElementAttributes else{
            return self.latestOffset
        }
        self.latestOffset = CGPoint(x: floor(unwrappedElementAttributes.frame.origin.x - (self.peekLengthOfCell + self.minimumLineSpacing)), y: proposedContentOffset.y)
        return latestOffset
    }

}
