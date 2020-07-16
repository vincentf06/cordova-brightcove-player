import BrightcovePlayerSDK

@objc(BrightcovePlayer) class BrightcovePlayer : CDVPlugin {

    //MARK: Properties

    private var playerView: PlayerViewController?
    private var storyboard: UIStoryboard?
    private var brightcovePolicyKey: String?
    private var brightcoveAccountId: String?

    //MARK: Cordova Methods

    @objc(play:)
    func play(_ command: CDVInvokedUrlCommand) {
        let videoId = command.arguments[0] as? String ?? ""
        if videoId.isEmpty {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Video ID is not valid")
            commandDelegate.send(pluginResult, callbackId: "01")
        }

        self.playById(videoId)
    }

    @objc(initAccount:)
    func initAccount(_ command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult?
        self.brightcovePolicyKey = command.arguments[0] as? String ?? ""
        self.brightcoveAccountId = command.arguments[1] as? String ?? ""

        if self.brightcovePolicyKey?.isEmpty == false && self.brightcoveAccountId?.isEmpty == false {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Brightcove player initialised")
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Could not initialise Brightcove player")
        }

        commandDelegate.send(pluginResult, callbackId: "01")
    }

    @objc(switchAccount:)
    func switchAccount(_ command: CDVInvokedUrlCommand) {
        self.brightcovePolicyKey = command.arguments[0] as? String ?? ""
        self.brightcoveAccountId = command.arguments[1] as? String ?? ""

        if self.brightcovePolicyKey?.isEmpty == false && self.brightcoveAccountId?.isEmpty == false {
            self.playerView?.setAccountIds(self.brightcovePolicyKey!, accountId: self.brightcoveAccountId!)
        }
    }

    //MARK: Private Methods

    private func initPlayerView(_ videoId: String) {
        if self.playerView == nil {
            self.storyboard = UIStoryboard(name: "BrightcovePlayer", bundle: nil)
            self.playerView = self.storyboard?.instantiateInitialViewController() as? PlayerViewController
            self.playerView?.setAccountIds(self.brightcovePolicyKey!, accountId: self.brightcoveAccountId!)
            self.playerView?.setVideoId(videoId)
        } else {
            self.playerView?.setVideoId(videoId)
            self.playerView?.playFromExistingView()
        }
    }

    private func playById(_ videoId: String) {
        self.initPlayerView(videoId)
        self.viewController.present(self.playerView!, animated: true)
    }
}
