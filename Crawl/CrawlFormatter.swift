//
//  CrawlFormatter.swift
//  Crawl
//
//  Created by Tom Burns on 2/1/16.
//  Copyright © 2016 Claptrap, LLC. All rights reserved.
//

import UIKit

struct CrawlFormatter {
    static func attributedStringArrayForCrawl(crawl: Crawl) -> [NSAttributedString] {
        let attributedEpisode = NSMutableAttributedString(string: crawl.preTitle)
        
        let episodeFontDescriptor = UIFontDescriptor(name: "Futura", size: 36.0)
        let episodeFont = UIFont(descriptor: episodeFontDescriptor, size: 0)
        attributedEpisode.addAttribute(NSFontAttributeName, value: episodeFont, range: NSMakeRange(0, attributedEpisode.length))
        
        let episodeParagraphStyle = NSMutableParagraphStyle()
        episodeParagraphStyle.setParagraphStyle(NSParagraphStyle.defaultParagraphStyle())
        episodeParagraphStyle.alignment = NSTextAlignment.Center
        episodeParagraphStyle.lineHeightMultiple = 1.5
        attributedEpisode.addAttribute(NSParagraphStyleAttributeName, value: episodeParagraphStyle, range: NSMakeRange(0, attributedEpisode.length))
        
        
        let attributedTitle = NSMutableAttributedString(string: crawl.title+"\n\n")
        
        let titleFontDescriptor = UIFontDescriptor(name: "Futura-CondensedMedium", size: 48.0)
        let titleFont = UIFont(descriptor: titleFontDescriptor, size: 0)
        attributedTitle.addAttribute(NSFontAttributeName, value: titleFont, range: NSMakeRange(0, attributedTitle.length))
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.setParagraphStyle(NSParagraphStyle.defaultParagraphStyle())
        titleParagraphStyle.alignment = NSTextAlignment.Center
        titleParagraphStyle.paragraphSpacingBefore = 0
        
        attributedTitle.addAttribute(NSParagraphStyleAttributeName, value: titleParagraphStyle, range: NSMakeRange(0, attributedTitle.length))
        
        let bodyFontDescriptor = UIFontDescriptor(name: "Futura", size: 24.0)
        let bodyFont = UIFont(descriptor: bodyFontDescriptor, size: 0)
        
        let bodyParagraphStyle = NSMutableParagraphStyle()
        bodyParagraphStyle.alignment = NSTextAlignment.Justified
        
        bodyParagraphStyle.paragraphSpacingBefore = 20
        
        var attributedStrings: [NSMutableAttributedString] = []
        
        attributedStrings.append(attributedEpisode)
        attributedStrings.append(attributedTitle)
        
        for paragraph in crawl.bodyParagraphs {
            let attributedBody = NSMutableAttributedString(string: paragraph)
            attributedBody.addAttribute(NSFontAttributeName, value: bodyFont, range: NSMakeRange(0, attributedBody.length))
            attributedBody.addAttribute(NSParagraphStyleAttributeName, value: bodyParagraphStyle, range: NSMakeRange(0, attributedBody.length))
            attributedStrings.append(attributedBody)
        }
        
        return attributedStrings
    }
}