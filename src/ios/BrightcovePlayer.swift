import BrightcovePlayerSDK

var token: String? = nil
var playerView: PlayerViewController? = nil
var storyboard: UIStoryboard? = nil

@objc(BrightcovePlayer) class BrightcovePlayer : CDVPlugin {
    @objc(play:)
    func play(_ command: CDVInvokedUrlCommand) {
        let videoId = command.arguments[0] as? String ?? ""
        playById(videoId)
    }
    
    @objc(init:)
    func setToken(_ command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil
        
        let brightcoveToken = command.arguments[0] as? String ?? ""
        if brightcoveToken.isEmpty == false {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Inited")
        }
        else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Empty Brightcove token!")
        }
        commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    func initPlayerView() {
        if playerView == nil {
            storyboard = UIStoryboard(name: "BrightcovePlayer", bundle: nil)
            playerView = storyboard?.instantiateInitialViewController() as? PlayerViewController
//            playerView.delegate = self
            playerView?.kViewControllerCatalogToken = token
        }
        else {
            playerView?.kViewControllerCatalogToken = token
            playerView?.setup()
        }
    }

    func playById(_ videoId: String) {
        var pluginResult: CDVPluginResult? = nil
        if token == nil && token?.isEmpty == false {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Please init the brightcove with token!")
        }
        else {
            if videoId.isEmpty == false {
                initPlayerView()
                setVideoId(videoId)

                self.viewController.present(playerView!, animated: true) { _ in }
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Playing now with Brightcove ID: \(videoId)")
            }
            else {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Empty video ID!")
            }
        }
        commandDelegate.send(pluginResult, callbackId: nil)
    }

    func setVideoId(_ videoId: String) {
        playerView?.kViewControllerPlaylistID = videoId
    }

}
