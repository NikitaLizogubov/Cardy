//
//  XibView.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02/10/2022.
//

import UIKit

class XibView: UIView {
    
    // MARK: - Public properties
    
    var contentView: UIView!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView

        backgroundColor = .clear
        clipsToBounds = true
        
        addFullSubview(contentView)
        
        awakeFromNib()
    }
    
}
