import UIKit

public class LongTimeView: UIView {
    static let defaultColor = UIColor(red: 75.0/255.0, green: 213.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    
    let label: UILabel
    
    public override init(frame: CGRect) {
        self.label = UILabel(frame: CGRectZero)
        
        super.init(frame: frame)
        
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = self.dynamicType.defaultColor
        label.numberOfLines = 0
        label.text = "Hello!"
        label.alpha = 0
        
        label.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        label.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        
        self.backgroundColor = UIColor.blackColor()
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    public func flashIntroTextWithCompletion(completion: (() -> Void)?) {
        UIView.animateWithDuration(2.0,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: { self.label.alpha = 1 }) { _ in
                UIView.animateWithDuration(2.0,
                    delay: 3.0,
                    options: UIViewAnimationOptions.CurveEaseIn,
                    animations: { self.label.alpha = 0 }) { _ in
                        UIView.animateWithDuration(0.0,
                            delay: 1.0,
                            options: [],
                            animations: { self.alpha = 0 },
                            completion: { _ in completion?() })
                }
        }
    }
}
