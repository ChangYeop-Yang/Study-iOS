//
//  File.swift
//  KakaoPaySubject
//
//  Created by 양창엽 on 14/01/2019.
//  Copyright © 2019 양창엽. All rights reserved.
//

import Foundation

// MARK: - NSAttributedString Extension
extension NSAttributedString {
    
    internal convenience init?(html: String) {
        
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString: attributedString)
    }
}
