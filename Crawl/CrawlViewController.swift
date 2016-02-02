import UIKit
import MediaPlayer

public class CrawlViewController: UIViewController {
    
    let starView: StarView
    let longTimeView: LongTimeView
    let crawlView: CrawlView
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.starView = StarView(frame: CGRectZero)
        self.longTimeView = LongTimeView(frame: CGRectZero)
        self.crawlView = CrawlView(frame: CGRectZero)
        
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
                
        starView.translatesAutoresizingMaskIntoConstraints = false
        crawlView.translatesAutoresizingMaskIntoConstraints = false
        longTimeView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(starView)
        self.starView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        self.starView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        self.starView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        self.starView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        
        self.view.insertSubview(crawlView, aboveSubview: starView)
        self.crawlView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        self.crawlView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        self.crawlView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 2.0).active = true
        self.crawlView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 1.0).active = true
        crawlView.hidden = true
        
        self.view.insertSubview(longTimeView, aboveSubview: crawlView)
        self.longTimeView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        self.longTimeView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        self.longTimeView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
        self.longTimeView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
    }
    
    func startWithMediaCollection(mediaCollection: MPMediaItemCollection) {
        let player = MPMusicPlayerController.applicationMusicPlayer()
        player.setQueueWithItemCollection(mediaCollection)
        player.prepareToPlay()
        
        longTimeView.flashIntroTextWithCompletion { [weak self] in
            self?.longTimeView.removeFromSuperview()
            self?.crawlView.hidden = false
            self?.crawlView.startAutoScrollWithDuration(mediaCollection.items.first?.playbackDuration ?? 60)
            player.play()
        }
    }
    
    func start(gestureRecognizer: UIGestureRecognizer) {
        gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
        
        
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        starView.generateStarImage(starView.frame.size)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.crawlView.bounds
        gradientLayer.locations = [0.1,0.4]
        gradientLayer.colors = [UIColor.clearColor().CGColor,UIColor.blackColor().CGColor]
        self.crawlView.layer.mask = gradientLayer
        
        
        let crawlLayer = self.crawlView.layer
        
        crawlLayer.zPosition = 200.0
        
        var crawlTransform = CATransform3DIdentity;
        crawlTransform.m34 = 1.0 / -500;
        crawlTransform = CATransform3DRotate(crawlTransform, 60.0 * CGFloat(M_PI) / 180.0, 1.0, 0.0, 0.0);
        crawlLayer.transform = crawlTransform;
    }
}
