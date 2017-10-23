import UIKit
import BrightcovePlayerSDK

class PlayerViewController: UIViewController, BCOVPlaybackControllerDelegate {
    
    private let sharedSDKManager: BCOVPlayerSDKManager = BCOVPlayerSDKManager.shared()
    
    private var playbackController: BCOVPlaybackController
    private var playbackService: BCOVPlaybackService
    private var kViewControllerPlaybackServicePolicyKey: String?
    private var kViewControllerAccountID: String?
    private var kViewControllerVideoID: String?
    
    //MARK: UIOutlets
    
    @IBOutlet weak var videoContainer: UIView!
    
    
    //MARK: Constructor & Destructor
    
    required init?(coder aDecoder: NSCoder) {
        self.playbackController = self.sharedSDKManager.createPlaybackController()
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
    
    func setAccountIds(policyKey: String, accountId: String) {
        self.kViewControllerPlaybackServicePolicyKey = policyKey
        self.kViewControllerAccountID = accountId
    }
    
    func setVideoId(_ videoId: String) {
        self.kViewControllerVideoID = videoId
    }
    
    func requestContentFromPlaybackService() {
        playbackService.findVideo(withVideoID: self.kViewControllerVideoID, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
            
            if let v = video {
                self.playbackController.setVideos([v] as NSArray)
            } else {
                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        print("Advanced to new session")
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
        print("Progress: \(progress) seconds")
    }

}
