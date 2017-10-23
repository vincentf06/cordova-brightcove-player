import UIKit
import BrightcovePlayerSDK

class PlayerViewController: UIViewController, BCOVPlaybackControllerDelegate {
    
    fileprivate let sharedSDKManager: BCOVPlayerSDKManager = BCOVPlayerSDKManager.shared()
    
    fileprivate var playbackController: BCOVPlaybackController
    fileprivate var playbackService: BCOVPlaybackService
    fileprivate var kViewControllerPlaybackServicePolicyKey: String?
    fileprivate var kViewControllerAccountID: String?
    fileprivate var kViewControllerVideoID: String?
    
    //MARK: UIOutlets
    
    @IBOutlet weak var videoContainer: UIView!
    
    
    //MARK: Constructor & Destructor
    
    required init?(coder aDecoder: NSCoder) {
        self.playbackController = self.sharedSDKManager.createPlaybackController()
        
        print("\n", self.kViewControllerVideoID, "\n", self.kViewControllerPlaybackServicePolicyKey, "\n", self.kViewControllerAccountID)
        
        self.playbackService = BCOVPlaybackService(accountId: self.kViewControllerAccountID, policyKey: self.kViewControllerPlaybackServicePolicyKey)
    
        super.init(coder: aDecoder)
        
        playbackController.delegate = self
        playbackController.isAutoAdvance = true
        playbackController.isAutoPlay = true
    }
    
    deinit {
        print("destroyed")
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerView = BCOVPUIPlayerView(playbackController: self.playbackController, options: nil, controlsView: BCOVPUIBasicControlView.withVODLayout())

        playerView?.frame = self.videoContainer.bounds
        playerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.videoContainer.addSubview(playerView!)
        playerView?.playbackController = playbackController
        
        requestContentFromPlaybackService()
    }
    
    internal func setAccountIds(policyKey: String, accountId: String) {
        self.kViewControllerPlaybackServicePolicyKey = policyKey
        self.kViewControllerAccountID = accountId
    }
    
    internal func setVideoId(_ videoId: String) {
        self.kViewControllerVideoID = videoId
    }
    
    fileprivate func requestContentFromPlaybackService() {
        playbackService.findVideo(withVideoID: self.kViewControllerVideoID!, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
            
            if let v = video {
                self.playbackController.setVideos([v] as NSArray)
            } else {
                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    //MARK: BCOVPlaybackControllerDelegate Methods
    
    internal func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        print("Advanced to new session")
    }
    
    internal func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
        print("Progress: \(progress) seconds")
    }

}
