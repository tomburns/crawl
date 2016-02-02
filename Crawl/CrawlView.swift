import UIKit

public class CrawlView: UIView {
    static let defaultColor = UIColor(red: 229.0/255.0, green: 177.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    
    let scrollView: UIScrollView
    let stackView: UIStackView
    
    var scrollingTimer: NSTimer?
    
    public override init(frame: CGRect) {
        self.stackView = UIStackView(frame: CGRectZero)
        self.scrollView = UIScrollView(frame: CGRectZero)
        super.init(frame: frame)
        
        scrollView.addSubview(stackView)
        
        self.addSubview(scrollView)
        
        stackView.axis = .Vertical
        stackView.spacing = 30
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding = UIScreen.mainScreen().bounds.height * 1.5
        
        scrollView.contentInset = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        
        for attributedString in CrawlFormatter.attributedStringArrayForCrawl(Crawl.defaultCrawl()) {
            let fullRange = NSMakeRange(0, attributedString.length)
            
            let mutableAttributedString = attributedString.mutableCopy() as! NSMutableAttributedString
            
            mutableAttributedString.addAttributes([NSBackgroundColorAttributeName: UIColor.clearColor(),
                NSForegroundColorAttributeName: self.dynamicType.defaultColor], range: fullRange)
            
            let label = UILabel(frame: CGRectZero)
            label.numberOfLines = 0
            label.attributedText = mutableAttributedString
            
            label.widthAnchor.constraintEqualToAnchor(stackView.widthAnchor)
            stackView.addArrangedSubview(label)
        }
        
        scrollView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        scrollView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        scrollView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        scrollView.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 0.4).active = true
        
        
        stackView.leadingAnchor.constraintEqualToAnchor(self.scrollView.leadingAnchor).active = true
        stackView.trailingAnchor.constraintEqualToAnchor(self.scrollView.trailingAnchor).active = true
        stackView.topAnchor.constraintEqualToAnchor(self.scrollView.topAnchor).active = true
        stackView.bottomAnchor.constraintEqualToAnchor(self.scrollView.bottomAnchor).active = true
        stackView.widthAnchor.constraintLessThanOrEqualToAnchor(self.scrollView.widthAnchor).active = true
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    public func startAutoScrollWithDuration(duration: NSTimeInterval) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if let strongSelf = self {
                
                let contentOffset = strongSelf.scrollView.contentInset.top * -1
                
                strongSelf.scrollView.setContentOffset(CGPointMake(0, contentOffset), animated: false)
                
                
                UIView.animateWithDuration(60,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveLinear,
                    animations: {
                        strongSelf.scrollView.setContentOffset(CGPoint(x: 0, y: strongSelf.scrollView.frame.size.height), animated: false)
                        
                    },
                    completion: nil)
            }
        }
    }
}
