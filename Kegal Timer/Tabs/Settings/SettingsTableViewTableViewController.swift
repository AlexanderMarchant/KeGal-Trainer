//
//  SettingsTableViewTableViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2018.
//  Copyright © 2018 Alex Marchant. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingsTableViewController : UITableViewController, UITextFieldDelegate, UITabBarControllerDelegate, GADBannerViewDelegate, Storyboarded {
    
    weak var coordinator: SettingsCoordinator?
    let adMobDisplayer = AdMobDisplayer()
    
    let userPreferences = UserDefaults.standard
    
    var adBannerView: GADBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    private var dirtyInput = false
    
    @IBOutlet weak var repsPerSetTextBox: UITextField!
    @IBOutlet weak var repLengthTextBox: UITextField!
    @IBOutlet weak var restLengthTextBox: UITextField!
    
    @IBOutlet weak var vibrateCueSwitch: UISwitch!
    @IBOutlet weak var visualCueSwitch: UISwitch!
    @IBOutlet weak var soundCueSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        repsPerSetTextBox.text = String(userPreferences.integer(forKey: Constants.repsPerSet))
        repLengthTextBox.text = String(userPreferences.integer(forKey: Constants.repLength))
        restLengthTextBox.text = String(userPreferences.integer(forKey: Constants.restLength))
        
        vibrateCueSwitch.isOn = userPreferences.bool(forKey: Constants.vibrationCue)
        visualCueSwitch.isOn = userPreferences.bool(forKey: Constants.visualCue)
        soundCueSwitch.isOn = userPreferences.bool(forKey: Constants.soundCue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        navigationItem.setLeftBarButton(nil, animated: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
        
        self.tabBarController?.delegate = self
        
        repsPerSetTextBox.delegate = self
        repLengthTextBox.delegate = self
        restLengthTextBox.delegate = self
        
        vibrateCueSwitch.addTarget(self, action: #selector(switchStateChanged), for: UIControl.Event.valueChanged)
        visualCueSwitch.addTarget(self, action: #selector(switchStateChanged), for: UIControl.Event.valueChanged)
        soundCueSwitch.addTarget(self, action: #selector(switchStateChanged), for: UIControl.Event.valueChanged)
        
        self.hideKeyboardWhenTappedAround()
        
        self.adBannerView = self.adMobDisplayer.setupAdBannerView(self.adBannerView, viewController: self, adUnitId: Constants.settingsTabBannerAdId, bannerViewDelgate: self)
        
        self.adMobDisplayer.displayBannerAd(self.adBannerView)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let selectedCell = tableView.cellForRow(at: indexPath)
        if (selectedCell!.textLabel!.text == nil) {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayChosenPresetAlert(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        displayPresetInformation(indexPath)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedChracters = "0123456789"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedChracters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        dirtyInput = true
        
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    
    private func displayChosenPresetAlert(_ indexPath: IndexPath) {
        let presetName = tableView.cellForRow(at: indexPath)?.textLabel?.text!
        
        var presetRepsPerSet: Int?
        var presetRepLength: Int?
        var presetRestLength: Int?
        
        switch(indexPath.item) {
        case 1:
            presetRepsPerSet = 25
            presetRepLength = 1
            presetRestLength = 1
        case 2:
            presetRepsPerSet = 10
            presetRepLength = 5
            presetRestLength = 4
        case 3:
            presetRepsPerSet = 10
            presetRepLength = 12
            presetRestLength = 5
        default:
            presetRepsPerSet = 10
            presetRepLength = 2
            presetRestLength = 3
        }
        
        let alertMessage = String(format: "This preset will change the workout settings to the following: \n\n Reps Per Set: %@ \n Rep Length (secs): %@ \n Rest Length (secs): %@", String(presetRepsPerSet!), String(presetRepLength!), String(presetRestLength!))
        
        let selectPresetAlert = UIAlertController(title: presetName, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        selectPresetAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in selectPresetAlert.dismiss(animated: true, completion: nil)}))
        
        selectPresetAlert.addAction(UIAlertAction(title: "Use Preset", style: UIAlertAction.Style.default) {_ in self.setWorkoutSettings(repsPerSet: presetRepsPerSet!, repLength: presetRepLength!, restLength: presetRestLength!) })
        
        self.present(selectPresetAlert, animated: true, completion: nil)
    }
    
    private func displayPresetInformation(_ indexPath: IndexPath)
    {
        let presetName = tableView.cellForRow(at: indexPath)?.textLabel?.text!
        
        var presetInstructions: String
        var presetBenefits: String
        
        switch(indexPath.item) {
        case 1:
            presetBenefits = "The rapid flex creates greater control, endurance and stamina"
            presetInstructions = "Very quickly squeeze and release, these are rapid-fire pulsating contractions"
        case 2:
            presetBenefits = "The long hard flex helps build longer lasting strength"
            presetInstructions = "Perform a slow contraction whilst squeezing as hard as you can"
        case 3:
            presetBenefits = "The hold helps build strength, control and increases muscle size"
            presetInstructions = "Perform a long, hard contraction"
        default:
            presetBenefits = "The basic flex helps to build basic strength and control"
            presetInstructions = "Hold the contraction and then release"
        }
        
        let alertMessage = String(format: "Benefits: \n %@ \n\n Instructions: \n %@", presetBenefits, presetInstructions)
        
        let presetInformationAlert = UIAlertController(title: presetName, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        presetInformationAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in presetInformationAlert.dismiss(animated: true, completion: nil)}))
        
        self.present(presetInformationAlert, animated: true, completion: nil)
    }
    
    private func setWorkoutSettings(repsPerSet: Int, repLength: Int, restLength: Int) {
        dirtyInput = true
        
        repsPerSetTextBox.text = String(repsPerSet)
        repLengthTextBox.text = String(repLength)
        restLengthTextBox.text = String(restLength)
    }
    
    @objc private func switchStateChanged(switch: UISwitch)
    {
        dirtyInput = true
    }
    
    @objc func saveChanges()
    {
        if (!checkValuesAreValid())
        {
            let invalidInputAlert = UIAlertController(title: "Invalid Inputs", message: "Please enter valid values for all inputs", preferredStyle: UIAlertController.Style.alert)
            
            invalidInputAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in invalidInputAlert.dismiss(animated: true, completion: nil)}))
            
            self.present(invalidInputAlert, animated: true, completion: nil)
        } else {
            dirtyInput = false
            
            saveSettings()
            
            let saveSuccessfulAlert = UIAlertController(title: "Save Successful", message: "", preferredStyle: coordinator?.getAlertStyle() ?? UIAlertController.Style.alert)
            
            saveSuccessfulAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in saveSuccessfulAlert.dismiss(animated: true, completion: nil)}))
            
            self.present(saveSuccessfulAlert, animated: true, completion: nil)
        }
    }
    
    private func checkValuesAreValid() -> Bool
    {
        if(repsPerSetTextBox.text!.isEmpty || repsPerSetTextBox.text!.first == "0")
        {
            return false
        }
        else if(repLengthTextBox.text!.isEmpty || repLengthTextBox.text!.first == "0")
        {
            return false
        }
        else if(restLengthTextBox.text!.isEmpty || restLengthTextBox.text!.first == "0")
        {
            return false
        }
        
        return true
    }
    
    private func saveSettings()
    {
        userPreferences.set(Int(repsPerSetTextBox.text!), forKey: Constants.repsPerSet)
        userPreferences.set(Int(repLengthTextBox.text!), forKey: Constants.repLength)
        userPreferences.set(Int(restLengthTextBox.text!), forKey: Constants.restLength)
        
        /// Since the user is editing the workout values, invalidate current level
        userPreferences.set(0, forKey: Constants.stage)
        userPreferences.set("", forKey: Constants.level)
        userPreferences.set(0, forKey: Constants.levelOrder)
        
        userPreferences.set(vibrateCueSwitch.isOn, forKey: Constants.vibrationCue)
        userPreferences.set(visualCueSwitch.isOn, forKey: Constants.visualCue)
        userPreferences.set(soundCueSwitch.isOn, forKey: Constants.soundCue)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if(dirtyInput) {
            let unsavedChangesAlert = UIAlertController(title: "Unsaved changes", message: "You have unsaved changes, are you sure you want to navigate away?", preferredStyle: UIAlertController.Style.actionSheet)
            
            unsavedChangesAlert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (_) in self.dirtyInput = false; tabBarController.selectedViewController = viewController }))
            unsavedChangesAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive))
            
            self.present(unsavedChangesAlert, animated: true, completion: nil)

            return false
        } else {
            return true
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.tableView.tableHeaderView = bannerView
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
}