import UIKit
import BrightcovePlayerSDK

class PlayerViewController: UIViewController, BCOVPlaybackControllerDelegate, BCOVPUIPlayerViewDelegate {

    var playbackService: BCOVPlaybackService? = nil
    var playbackController: BCOVPlaybackController? = nil
    let accountId = "4800266849001"
    @IBOutlet weak var videoContainer: UIView!

    var sharedSDKManager: BCOVPlayerSDKManager? = nil

    var kViewControllerPlaylistID: String? = nil
    var kViewControllerCatalogToken: String? = nil
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playbackController?.view.frame = videoContainer.bounds
        playbackController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoContainer.insertSubview((playbackController?.view)!, at: 0)
    }

    func setup() {
        sharedSDKManager = BCOVPlayerSDKManager.shared()

        playbackController?.delegate = self
        playbackController?.isAutoAdvance = true
        playbackController?.isAutoPlay = true

        if kViewControllerCatalogToken != nil && kViewControllerCatalogToken?.isEmpty == false && kViewControllerPlaylistID != nil && kViewControllerPlaylistID?.isEmpty == false {
            playbackService = BCOVPlaybackService(accountId: accountId, policyKey: kViewControllerCatalogToken)
            requestContentFromCatalog()
        }
    }

    func requestContentFromCatalog() {
        print(111)
//        playbackService.findVideo(widthVideoID: kViewControllerPlaylistID, parameters: nil) { (video: BCOVVideo, jsonResponse: [AnyHashable: Any], error: Error?) -> Void in
//
//            if let v = video {
//                self.playbackController.setVideos([v] as NSArray)
//            }
//            else {
//                print("BrightcovePluginViewController Debug - Error retrieving video: \(error)")
//            }
//        }
    }

}
