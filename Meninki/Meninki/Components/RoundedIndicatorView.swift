//
//  RoundedIndicatorView.swift
//  Meninki
//
//  Created by Shirin on 3/30/23.
//

import Parchment

class RoundedIndicatorView: PagingIndicatorView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
}
