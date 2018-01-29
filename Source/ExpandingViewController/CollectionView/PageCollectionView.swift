//
//  PageCollectionView.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

public class PageCollectionView: UICollectionView {
    public var collectionHeightConstraint: NSLayoutConstraint?
    
    public func setHeight(itemSize: CGSize, andUpdateLayout update: Bool = false) {
        if collectionHeightConstraint == nil {
            collectionHeightConstraint = NSLayoutConstraint(item: self,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1,
                                                            constant: itemSize.height + itemSize.height / 5 * 2)
            self.addConstraint(collectionHeightConstraint!)
        } else {
            collectionHeightConstraint?.constant = itemSize.height + itemSize.height / 5 * 2
        }
        setNeedsUpdateConstraints()
        
        if update {
            self.collectionViewLayout = PageCollectionLayout(itemSize: itemSize)
        }
    }
}

// MARK: init

extension PageCollectionView {

    class func createOnView(_ view: UIView,
                            itemSize: CGSize,
                            dataSource: UICollectionViewDataSource,
                            delegate: UICollectionViewDelegate) -> PageCollectionView {

        let layout = PageCollectionLayout(itemSize: itemSize)
        let collectionView = Init(PageCollectionView(frame: CGRect.zero, collectionViewLayout: layout)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.decelerationRate = UIScrollViewDecelerationRateFast
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = dataSource
            $0.delegate = delegate
            $0.backgroundColor = UIColor(white: 0, alpha: 0)
        }
        view.addSubview(collectionView)
        collectionView.clipsToBounds = false
        
        // add constraints
        collectionView.setHeight(itemSize: itemSize)
        [NSLayoutAttribute.left, .right, .centerY].forEach { attribute in
            (view, collectionView) >>>- {
                $0.attribute = attribute
                return
            }
        }

        return collectionView
    }
}
