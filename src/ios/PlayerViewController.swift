import BrightcovePlayerSDK

class PlayerViewController: UIViewController, BCOVPlaybackControllerDelegate, BCOVPUIPlayerViewDelegate {

    //MARK: Properties

    private var playbackService: BCOVPlaybackService?
    private var playbackController: BCOVPlaybackController?
    private var videoView: BCOVPUIPlayerView?
    private var kViewControllerPlaybackServicePolicyKey: String?
    private var kViewControllerAccountID: String?
    private var kViewControllerVideoID: String?

    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var closeButton: UIButton!


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createPlaybackController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupVideoView()
        self.requestContentFromPlaybackService()
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

    internal func setAccountIds(_ policyKey: String, accountId: String) {
        self.kViewControllerPlaybackServicePolicyKey = policyKey
        self.kViewControllerAccountID = accountId
    }

    internal func setVideoId(_ videoId: String) {
        self.kViewControllerVideoID = videoId
    }

    internal func playFromExistingView() {
        self.createPlaybackController()
        self.setupVideoView()
        self.requestContentFromPlaybackService()
    }

    //MARK: Private Methods

    private func createPlaybackController() {
        let sharedSDKManager: BCOVPlayerSDKManager = BCOVPlayerSDKManager.shared()
        self.playbackController = sharedSDKManager.createPlaybackController()
        self.playbackController?.delegate = self
        self.playbackController?.isAutoAdvance = true
        self.playbackController?.isAutoPlay = true
    }

    private func requestContentFromPlaybackService() {
        self.playbackService?.findVideo(withVideoID: self.kViewControllerVideoID!, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in

            if let video = video {
                self.playbackController?.setVideos([video] as NSArray)
            }
        }
    }

    private func setupVideoView() {
        self.playbackService = BCOVPlaybackService(accountId: self.kViewControllerAccountID, policyKey: self.kViewControllerPlaybackServicePolicyKey)
        self.videoView = BCOVPUIPlayerView(playbackController: self.playbackController, options: nil, controlsView: BCOVPUIBasicControlView.withVODLayout())
        self.videoView?.delegate = self
        self.videoView?.frame = self.videoContainer.bounds
        self.videoView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.videoContainer.addSubview(videoView!)
        self.videoView?.playbackController = playbackController
        self.customizeUI()
    }

    private func customizeUI() {
        // Hide fullscreen button
        let fullscreenButton: BCOVPUIButton? = self.videoView?.controlsView.screenModeButton
        fullscreenButton?.isHidden = true
    }

    private func clear() {
        self.playbackController = nil
        self.playbackService = nil
        self.kViewControllerVideoID = nil
    }

    //MARK: Delegate Methods
    // Check to docs of BCOVPlaybackControllerDelegate to add other delegate methods

    internal func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        // Nothing to do
    }

    //MARK: Actions

    @IBAction func dismissPlayerView(_ sender: Any) {
        self.dismiss(animated: true, completion: {(_: Void) -> Void in
            self.playbackController?.pause()
            self.clear()
        })
    }
}
