import BrightcovePlayerSDK

class PlayerViewController: UIViewController, BCOVPlaybackControllerDelegate, BCOVPUIPlayerViewDelegate {
    
    //MARK: Properties

    fileprivate var playbackService: BCOVPlaybackService?
    fileprivate var playbackController: BCOVPlaybackController?
    fileprivate var videoView: BCOVPUIPlayerView?
    private var kViewControllerPlaybackServicePolicyKey: String?
    private var kViewControllerAccountID: String?
    private var kViewControllerVideoID: String?
    
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        let sharedSDKManager: BCOVPlayerSDKManager = BCOVPlayerSDKManager.shared()
        self.playbackController = sharedSDKManager.createPlaybackController()

        super.init(coder: aDecoder)

        self.playbackController?.delegate = self
        self.playbackController?.isAutoAdvance = true
        self.playbackController?.isAutoPlay = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupVideoView()
        requestContentFromPlaybackService()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Force switching to portrait mode to fix a UI bug
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    //MARK: Internal Methods
    
    internal func setAccountIds(policyKey: String, accountId: String) {
        self.kViewControllerPlaybackServicePolicyKey = policyKey
        self.kViewControllerAccountID = accountId
    }
    
    internal func setVideoId(_ videoId: String) {
        self.kViewControllerVideoID = videoId
    }
    
    internal func playFromExistingView() {
        let sharedSDKManager: BCOVPlayerSDKManager = BCOVPlayerSDKManager.shared()
        self.playbackController = sharedSDKManager.createPlaybackController()
        
        self.playbackController?.delegate = self
        self.playbackController?.isAutoAdvance = true
        self.playbackController?.isAutoPlay = true
        
        self.setupVideoView()
        requestContentFromPlaybackService()
    }

    //MARK: Private Methods
    
    fileprivate func requestContentFromPlaybackService() {
        playbackService?.findVideo(withVideoID: self.kViewControllerVideoID!, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
            
            if let v = video {
                self.playbackController?.setVideos([v] as NSArray)
            } else {
                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    fileprivate func setupVideoView() {
        self.playbackService = BCOVPlaybackService(accountId: self.kViewControllerAccountID, policyKey: self.kViewControllerPlaybackServicePolicyKey)
        self.videoView = BCOVPUIPlayerView(playbackController: self.playbackController, options: nil, controlsView: BCOVPUIBasicControlView.withVODLayout())
        self.videoView?.delegate = self
        self.videoView?.frame = self.videoContainer.bounds
        self.videoView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.videoContainer.addSubview(videoView!)
        self.videoView?.playbackController = playbackController
        
        self.customizeUI()
    }
    
    fileprivate func customizeUI() {
        // Hide fullscreen button
        let fullscreenButton: BCOVPUIButton? = self.videoView?.controlsView.screenModeButton
        fullscreenButton?.isHidden = true
    }
    
    fileprivate func clear() {
        self.playbackController = nil
        self.playbackService = nil
        self.kViewControllerVideoID = nil
    }
    
    //MARK: BCOVPlaybackControllerDelegate Methods
    
    internal func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        print("Advanced to new session")
    }
    
    internal func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
        // Nothing to do for now
    }
    
    //MARK: Actions
    
    @IBAction func dismissPlayerView(_ sender: Any) {
        self.dismiss(animated: true, completion: {(_: Void) -> Void in
            self.playbackController?.pause()
            self.clear()
        })
    }
}
