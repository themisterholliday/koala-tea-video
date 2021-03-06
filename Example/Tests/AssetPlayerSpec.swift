//
//  AssetPlayerSpec.swift
//  KoalaTeaAssetPlayer_Tests
//
//  Created by Craig Holliday on 7/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Nimble
import Quick
import SwifterSwift
import CoreMedia
import KoalaTeaAssetPlayer

class AssetPlayerSpec: QuickSpec {
    lazy var thirtySecondAsset: Asset = Asset(url: Bundle(for: AssetPlayerSpec.self).url(forResource: "SampleVideo_1280x720_5mb", withExtension: "mp4")!)
    lazy var fiveSecondAsset: Asset = Asset(url: Bundle(for: AssetPlayerSpec.self).url(forResource: "SampleVideo_1280x720_1mb", withExtension: "mp4")!)

    override func spec() {
        describe("AssetPlayerSpec") {
            var assetPlayer: AssetPlayer!

            beforeEach {
                assetPlayer = AssetPlayer()
            }

            afterEach {
                assetPlayer = nil
                expect(assetPlayer).to(beNil())
            }

            describe("perform action") {
                beforeEach {
                    assetPlayer.perform(action: .setup(with: self.thirtySecondAsset))
                }

                it("should have SETUP state") {
                    expect(assetPlayer.properties.state).to(equal(AssetPlayerPlaybackState.setup(asset: self.thirtySecondAsset)))
                }

                it("should have PLAYED state") {
                    assetPlayer.perform(action: .play)

                    expect(assetPlayer.properties.state).to(equal(AssetPlayerPlaybackState.playing))
                    expect(assetPlayer.properties.state).toEventuallyNot(equal(AssetPlayerPlaybackState.failed(error: nil)), timeout: 2)
                }

                it("should have PAUSED state") {
                    assetPlayer.perform(action: .pause)

                    expect(assetPlayer.properties.state).to(equal(AssetPlayerPlaybackState.paused))
                }

                it("should mute player & un-mute") {
                    assetPlayer.perform(action: .changeIsMuted(to: true))
                    expect(assetPlayer.properties.isMuted).to(equal(true))

                    assetPlayer.perform(action: .changeIsMuted(to: false))
                    expect(assetPlayer.properties.isMuted).to(equal(false))
                }

                /*
                stop
                beginFastForward
                endFastForward
                beginRewind
                endRewind
                seekToTimeInSeconds
                skip
                changePlayerPlaybackRate
                changeVolume
                 */
            }

            describe("finished state") {
                beforeEach {
                    assetPlayer.perform(action: .setup(with: self.fiveSecondAsset))
                }

                it("should have FINISHED state") {
                    expect(assetPlayer.properties.state).to(equal(AssetPlayerPlaybackState.setup(asset: self.fiveSecondAsset)))
                    assetPlayer.perform(action: .play)
                    expect(assetPlayer.properties.state).toEventually(equal(AssetPlayerPlaybackState.finished), timeout: 8)
                }
            }

            //                // @TODO: Test failure states with assets with protected content or non playable assets
            //                describe("failed state test") {
            //                    beforeEach {
            //                        assetPlayer.perform(action: .setup(with: fiveSecondAsset, startMuted: false, shouldLoop: false))
            //                    }
            //
            //                    it("should have FAILED state") {
            //                        let error = NSError(domain: "TEST", code: -1, userInfo: nil)
            //                        assetPlayer.properties.state = .failed(error: error as Error)
            //                        expect(assetPlayer.properties.state).to(equal(AssetPlayerPlaybackState.failed(error: error)))
            //                    }
            //                }
        }
    }
}
