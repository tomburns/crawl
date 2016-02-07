import CoreData
import RxSwift

struct Crawl {
    let intro: String
    let preTitle: String
    let title: String
    let bodyParagraphs: [String]
    let mediaID: String?

    init(intro: String, preTitle: String, title: String, body: String, mediaID: String? = nil) {
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

extension Crawl: ManagedObjectConvertible {

    typealias ManagedType = ManagedCrawl

    init(managedObject: ManagedType) throws {
        guard let intro = managedObject.intro,
            let preTitle = managedObject.preTitle,
            let title = managedObject.title,
            let body = managedObject.body else {
                throw CrawlError.ManagedObjectMapping
        }
        
        self.init(intro: intro, preTitle: preTitle, title: title, body: body, mediaID: managedObject.mediaID)
    }
    
    func createManagedObjectInContext(context: NSManagedObjectContext) -> Observable<ManagedType> {
        return Observable.create { observer in
            context.performBlock {
                guard let newCrawl = NSEntityDescription.insertNewObjectForEntityForName(ManagedType.entityName, inManagedObjectContext: context) as? ManagedCrawl else {
                    fatalError("Core Data typecasting failed.")
                }
                newCrawl.title = "Foo"
                newCrawl.preTitle = "Foo"
                newCrawl.intro = "\(NSDate())"
                newCrawl.body = "Baz"
                
                newCrawl.mediaID = self.mediaID

                observer.onNext(newCrawl)
                observer.onCompleted()
            }

            return NopDisposable.instance
        }.debug("create")
    }
}

//MARK: Equatable / Hashable
extension Crawl: Equatable {}

func ==(lhs: Crawl, rhs: Crawl) -> Bool {
    return lhs.title == rhs.title
}

extension Crawl: Hashable {
    var hashValue: Int {
        return (title + bodyParagraphs.reduce("", combine: +) + preTitle + intro).hashValue
    }
}