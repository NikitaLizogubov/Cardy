//
//  AssetEdit.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

enum AssetEdit: CaseIterable {
    case preview, canvas, music, filter, speed, trim, text
    
    var image: UIImage? {
        switch self {
        case .preview:
            return Resources.Images.Common.preview
        case .canvas:
            return Resources.Images.Common.canvas
        case .music:
            return Resources.Images.Common.music
        case .filter:
            return Resources.Images.Common.filter
        case .speed:
            return Resources.Images.Common.speed
        case .trim:
            return Resources.Images.Common.trim
        case .text:
            return Resources.Images.Common.text
        }
    }
    
    var text: String {
        switch self {
        case .preview:
            return "!-!Preview"
        case .canvas:
            return "!-!Canvas"
        case .music:
            return "!-!Music"
        case .filter:
            return "!-!Filter"
        case .speed:
            return "!-!Speed"
        case .trim:
            return "!-!Trim"
        case .text:
            return "!-!Text"
        }
    }
    
    var tintColor: UIColor {
        if self == .preview {
            return Resources.Colors.Common.black
        } else {
            return Resources.Colors.Common.white
        }
    }
    
    var backgroundColor: UIColor {
        if self == .preview {
            return Resources.Colors.Common.white
        } else {
            return Resources.Colors.Common.grayII
        }
    }
    
}
