import UIKit
import BrightcovePlayerSDK

let kViewControllerCatalogToken = "BCpkADawqM3n0ImwKortQqSZCgJMcyVbb8lJVwt0z16UD0a_h8MpEYcHyKbM8CGOPxBRp0nfSVdfokXBrUu3Sso7Nujv3dnLo0JxC_lNXCl88O7NJ0PR0z2AprnJ_Lwnq7nTcy1GBUrQPr5e"
let accountId = "4800266849001"

class PlayerViewController: UIViewController, BCOVPlaybackControllerDelegate {
    
    let sharedSDKManager: BCOVPlayerSDKManager = BCOVPlayerSDKManager.shared()
    let kViewControllerVideoID = "5255514387001"
    
    var kViewControllerPlaylistID: String? = nil
//    var kViewControllerCatalogToken: String? = nil
    var playbackService = BCOVPlaybackService(accountId: accountId, policyKey: kViewControllerCatalogToken)
    var playbackController: BCOVPlaybackController
    
    @IBOutlet weak var videoContainer: UIView!

    required init?(coder aDecoder: NSCoder) {
        playbackController = sharedSDKManager.createPlaybackController()
        
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
        
        
        
        
//        setup()
//        playbackController?.view.frame = videoContainer.bounds
//        playbackController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        

        let playerView = BCOVPUIPlayerView(playbackController: self.playbackController, options: nil, controlsView: BCOVPUIBasicControlView.withVODLayout())
print(1213121)
        playerView?.frame = self.videoContainer.bounds
        playerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.videoContainer.addSubview(playerView!)
        
        playerView?.playbackController = playbackController
        
        requestContentFromPlaybackService()
    }
    
    func requestContentFromPlaybackService() {
        playbackService?.findVideo(withVideoID: kViewControllerPlaylistID, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
            
            if let v = video {
                self.playbackController.setVideos([v] as NSArray)
            } else {
                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }

//    func setup() {
//        if kViewControllerCatalogToken != nil && kViewControllerCatalogToken?.isEmpty == false && kViewControllerPlaylistID != nil && kViewControllerPlaylistID?.isEmpty == false {
//            playbackService = BCOVPlaybackService(accountId: accountId, policyKey: kViewControllerCatalogToken)
//
//            requestContentFromCatalog()
//        }
//    }

//    func requestContentFromCatalog() {
//        print(111)
//        playbackService.findVideo(widthVideoID: kViewControllerPlaylistID, parameters: nil) { (video: BCOVVideo, jsonResponse: [AnyHashable: Any], error: Error?) -> Void in
//
//            if let v = video {
//                self.playbackController.setVideos([v] as NSArray)
//            }
//            else {
//                print("BrightcovePluginViewController Debug - Error retrieving video: \(error)")
//            }
//        }
//    }
    
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        print("Advanced to new session")
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
        print("Progress: \(progress) seconds")
    }

}
