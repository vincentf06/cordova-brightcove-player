import BrightcovePlayerSDK

@objc(BrightcovePlayer) class BrightcovePlayer : CDVPlugin {
  @objc(play:)
  func play(command: CDVInvokedUrlCommand) {
    // Need to instantiate BCOVPUIPlayerView
    // and add it as a subview of current UIView
  }
}
