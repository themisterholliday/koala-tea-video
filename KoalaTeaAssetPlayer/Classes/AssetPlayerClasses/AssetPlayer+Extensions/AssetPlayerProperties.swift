//
//  properties.swift
//  KoalaTeaAssetPlayer
//
//  Created by Craig Holliday on 7/11/19.
//

public struct AssetPlayerProperties {
    public let asset: Asset?
    public let startTimeForLoop: Double
    public let endTimeForLoop: Double?
    public let isMuted: Bool
    public let currentTime: Double
    public let bufferedTime: Double
    public let currentTimeText: String
    public let durationText: String
    public let timeLeftText: String
    public let duration: Double
    public let rate: Float
    public let state: AssetPlayerPlaybackState
}

public extension AssetPlayer {
    var properties: AssetPlayerProperties {
        return AssetPlayerProperties(
            asset: asset,
            startTimeForLoop: startTimeForLoop,
            endTimeForLoop: endTimeForLoop,
            isMuted: player.isMuted,
            currentTime: currentTime,
            bufferedTime: bufferedTime,
            currentTimeText: createTimeString(time: currentTime),
            durationText: createTimeString(time: duration),
            timeLeftText: "-\(createTimeString(time: duration - currentTime))",
            duration: duration,
            rate: rate,
            state: state)
    }

    private func createTimeString(time: Double) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))

        return timeRemainingFormatter.string(from: components as DateComponents)!
    }
}