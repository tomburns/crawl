import UIKit

public struct Crawl {
    let intro: String
    let preTitle: String
    let title: String
    let bodyParagraphs: [String]
    let mediaID: String?
    
    init(managedCrawl: ManagedCrawl) throws {
        guard let intro = managedCrawl.intro,
            let preTitle = managedCrawl.preTitle,
            let title = managedCrawl.title,
            let body = managedCrawl.body else {
                throw CrawlError.CoreData
        }
        
        self.intro = intro
        self.preTitle = preTitle
        self.title = title
        self.bodyParagraphs = Crawl.paragraphsForBody(body)
        self.mediaID = managedCrawl.mediaID
    }
    
    public init(intro: String, preTitle: String, title: String, body: String, mediaID: String? = nil) {
        self.intro = intro
        self.preTitle = preTitle
        self.title = title
        self.bodyParagraphs = Crawl.paragraphsForBody(body)
        self.mediaID = mediaID
    }
    
    static func defaultCrawl() -> Crawl {
        guard let defaultFile = NSBundle.mainBundle().pathForResource("Lorem", ofType: "plist"),
            let plistDictionary = NSDictionary(contentsOfFile: defaultFile),
            let intro = plistDictionary["intro"] as? String,
            let preTitle = plistDictionary["preTitle"] as? String,
            let title = plistDictionary["title"] as? String,
            let body = plistDictionary["body"] as? String else {
                return Crawl(intro: "how did i get here\ni am not good with computers", preTitle: "Hello", title: "GREETINGS", body: "How are you?")
        }
        
        return Crawl(intro: intro, preTitle: preTitle, title: title, body: body)
    }
    
    private static func paragraphsForBody(body: String) -> [String] {
        return body.characters.split{$0 == "\n"}.map(String.init)
    }
}