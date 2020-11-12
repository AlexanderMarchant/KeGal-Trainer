//
//  Constants.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 05/02/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation

struct Constants {
    //  User Preference Keys
    static let repsPerSet = "RepsPerSet"
    static let repLength = "RepLength"
    static let restLength = "RestLength"
    static let vibrationCue = "VibrationCueOn"
    static let visualCue = "VisualCueOn"
    static let soundCue = "SoundCueOn"
    static let stage = "Stage"
    static let level = "Level"
    static let levelOrder = "LevelOrder"
    static let adsDisabled = "AdsDisabled"
    
    //  User Default Keys
    static let appLaunchCount = "AppLaunchCount"
    static let launchedBefore = "LaunchedBefore"
    static let levelsCompleted = "LevelsCompleted"
    
    //  Font Styling
    static let fontName = "Avenir Next Condensed"
    static let fontSize = 25.0
    
    //  Animation Keys
    static let strokeEndAnimation = "strokeEndAnimation"
    
    //  Cell Identifier
    static let repCollectionViewCellReuseIdentifier = "RepCollectionViewCell"
    static let remindersTableViewCellReuseIdentifier = "Reminder"
    static let trackWorkoutsCalendarViewCellReuseIdentifier = "CustomCell"
    
    //  Dispatch Queue
    static let dispatchQueueLabel = "resumeWorkout"
    
    // AdMob Test Ad Id's
    static let testBannerAdId = "ca-app-pub-3940256099942544/2934735716"
    static let testInterstitialAdId = "ca-app-pub-3940256099942544/4411468910"
    
    //  AdMob Ad Unit Id's
    static let trackTabBannerAdId = "ca-app-pub-4293952743610750/7827912265"
    static let stagesTabBannerAdId = "ca-app-pub-4293952743610750/9079508085"
    static let timerTabBannerAdId = "ca-app-pub-4293952743610750/5867252897"
    static let workoutCompleteAdId = "ca-app-pub-4293952743610750/3195065512"
    static let remindersTabBannerAdId = "ca-app-pub-4293952743610750/9271079775"
    static let settingsTabBannerAdId = "ca-app-pub-4293952743610750/5906549836"
    static let generalBannerAdId = "ca-app-pub-4293952743610750/6811033049"
    static let generalInterstitialAdId = "ca-app-pub-4293952743610750/6815930145"
    
    //  Audience Network Ad Placement Id's
    static let audienceNetworkWorkoutCompletePlacementId = "767020503801089_767022473800892"
    static let audienceNetworkTabsBannerAdPlacementId = "767020503801089_767591013744038"
}