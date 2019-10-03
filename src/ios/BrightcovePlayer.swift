import BrightcovePlayerSDK

@objc(BrightcovePlayer) class BrightcovePlayer : CDVPlugin {
    
    //MARK: Properties
    
    fileprivate var playerView: PlayerViewController?
    fileprivate var storyboard: UIStoryboard?
    fileprivate var brightcovePolicyKey: String?
    fileprivate var brightcoveAccountId: String?
    
    //MARK: Cordova Methods
    
    @objc(play:)
    func play(_ command: CDVInvokedUrlCommand) {
        let videoId = command.arguments[0] as? String ?? ""
        playById(videoId)
    }
    
    @objc(initAccount:)
    func initAccount(_ command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil
        self.brightcovePolicyKey = command.arguments[0] as? String ?? ""
        self.brightcoveAccountId = command.arguments[1] as? String ?? ""
        
        if self.brightcovePolicyKey?.isEmpty == false && self.brightcoveAccountId?.isEmpty == false {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Brightcove player initialised")
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Could not initialise Brightcove player")
        }
        
        commandDelegate.send(pluginResult, callbackId: "01")
    }
    
    //MARK: Private Methods
    
    fileprivate func initPlayerView(_ videoId: String) {
        if self.playerView == nil {
            self.storyboard = UIStoryboard(name: "BrightcovePlayer", bundle: nil)
            self.playerView = self.storyboard?.instantiateInitialViewController() as? PlayerViewController
            playerView?.setAccountIds(brightcovePolicyKey!, accountId: brightcoveAccountId!)
            playerView?.setVideoId(videoId)
        } else {
            playerView?.setVideoId(videoId)
            playerView?.playFromExistingView()
        }
    }
    
    fileprivate func playById(_ videoId: String) {
        var pluginResult: CDVPluginResult?
        
        if self.brightcovePolicyKey == nil || self.brightcovePolicyKey?.isEmpty == true {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Please set up Brightcove IDs")
        } else {
            if videoId.isEmpty == true {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "There is no video ID")
            } else {
                initPlayerView(videoId)
                self.viewController.present(self.playerView!, animated: true)
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Playing with video: \(videoId)")
            }
        }
        
        commandDelegate.send(pluginResult, callbackId: "02")
    }
}
