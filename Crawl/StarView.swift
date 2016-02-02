import UIKit

public class StarView: UIView {
    
    private var starImage: UIImage? = nil

    override public func drawRect(rect: CGRect) {
        if let starImage = starImage where starImage.size == rect.size {
            starImage.drawInRect(rect)
        } else {
            let newStarImage = generateStarImage(rect.size)
            newStarImage?.drawInRect(rect)
            self.starImage = newStarImage
        }
    }
    
    public func generateStarImage(size: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0 else {
            return nil
        }
        
        UIGraphicsBeginImageContext(size);
        
        let context = UIGraphicsGetCurrentContext()
        
        let starCount = Int(size.width)
        
        for _ in 0..<starCount {
            
            
            let x = CGFloat(arc4random_uniform(UInt32(size.width)))
            let y = CGFloat(arc4random_uniform(UInt32(size.height)))
            
            let diameter: CGFloat = {
                let seed = Int(arc4random_uniform(100))
                switch seed {
                case 0..<5:
                    return 2
                case 6..<30:
                    return 1.5
                default:
                    return 1
                }
                
            }()
            
            let red = CGFloat(arc4random_uniform(UInt32(5))+80) * 0.01
            let green = CGFloat(arc4random_uniform(UInt32(5))+80) * 0.01
            let blue = CGFloat(arc4random_uniform(UInt32(10))+80) * 0.01
            
            CGContextSetRGBFillColor(context,red,green,blue,1.0);
            
            CGContextFillEllipseInRect(context, CGRect(x: x, y: y, width: diameter, height: diameter))
            
            CGContextStrokePath(context);
        }
        
        let starImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return starImage
    }
}