//
//  FileManager.swift
//  Сardy
//
//  Created by Nikita Lizogubov on 03/10/2022.
//

import Foundation

extension FileManager {
    
    func makeTampDirectory(_ pathComponent: String) -> URL {
        let cachesDirectory = FileManager.SearchPathDirectory.cachesDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(cachesDirectory, userDomainMask, true).first!
        let documentDirectoryURL = URL(fileURLWithPath: documentDirectory).appendingPathComponent(pathComponent)
        
        return documentDirectoryURL
    }
    
    // TODO: - Add error handling
    func removeFileIfExists(_ documentDirectoryURL: URL) {
        do {
            if FileManager.default.fileExists(atPath: documentDirectoryURL.path) {
                try FileManager.default.removeItem(at: documentDirectoryURL)
            }
        } catch {
            print(error)
        }
    }
    
}
