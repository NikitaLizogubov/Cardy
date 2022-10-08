//
//  Resources.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 08.10.2022.
//

import UIKit

struct Resources { }

// MARK: - Colors

extension Resources {
    
    enum Colors {
        
        enum Common {
            
            static var delicatePink: UIColor {
                UIColor(red: 2149, green: 209, blue: 225, alpha: 1)
            }
            
            static var aquamarine: UIColor {
                UIColor(red: 219, green: 253, blue: 250, alpha: 1)
            }
            
            static var white: UIColor {
                .white
            }
            
            static var black: UIColor {
                .black
            }
            
            static var grayII: UIColor {
                UIColor(red: 42, green: 42, blue: 42, alpha: 1)
            }
            
            static var grayIV: UIColor {
                UIColor(red: 26, green: 26, blue: 26, alpha: 1)
            }
            
        }
        
    }
    
}

// MARK: - Images

extension Resources {
    
    enum Images {
        
        enum Common {
            
            static var edit: UIImage? {
                UIImage(systemName: "pencil.circle.fill")
            }
            
            static var back: UIImage? {
                UIImage(systemName: "chevron.backward")
            }
            
            static var preview: UIImage? {
                UIImage(systemName: "play")
            }
            
            static var canvas: UIImage? {
                UIImage(systemName: "photo.on.rectangle.angled")
            }
            
            static var music: UIImage? {
                UIImage(systemName: "music.note")
            }
            
            static var text: UIImage? {
                UIImage(systemName: "textformat.abc.dottedunderline")
            }
            
            static var filter: UIImage? {
                UIImage(systemName: "camera.filters")
            }
            
            static var trim: UIImage? {
                UIImage(systemName: "timeline.selection")
            }
            
            static var speed: UIImage? {
                UIImage(systemName: "speedometer")
            }
            
        }
        
    }
    
}
