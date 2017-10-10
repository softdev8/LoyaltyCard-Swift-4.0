//
//  NFCHelper.swift
//  LoyaltyCard(Simple)
//
//  Created by admin on 13/09/2017.
//

import Foundation
import AVFoundation
import FirebaseAuth
import FirebaseDatabase
import CoreNFC

class NFCHelper: NSObject, NFCNDEFReaderSessionDelegate {
    weak var controller: ViewController!
    var userRef: FIRDatabaseReference! = nil
    var onNFCResult: ((Bool, String) -> ())?
    func restartSession() {
        let session = NFCNDEFReaderSession(delegate: self,
                                           queue: nil,
                                           invalidateAfterFirstRead: true)
        session.alertMessage = "High-five your iPhone with the sticker on your cup!"
        session.begin()
    }
    
    // MARK: NFCNDEFReaderSessionDelegate
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        guard let onNFCResult = onNFCResult else { return }
        onNFCResult(false, error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let onNFCResult = onNFCResult else { return }
        for message in messages {
            for record in message.records {
                if let resultString = String(data: record.payload, encoding: .utf8) {
                    onNFCResult(true, resultString)
                    
                    // 1. Redeem QR code scanned
                    if resultString == redeemQRCode {
                        print("Redeem scanned!")
                        
                        // Check the number of stamps the user has
                        if self.controller.checkForRedeemable() {
                            
                            // User has redeemed enough stamps (10+)
                            Alert.show(controller: self.controller, title: "", message: AlertMessage.Redeemed.rawValue, action: {
                                DispatchQueue.main.async {
                                    Utils.playSound()
                                    self.controller.updateUIOfMine()
                                    UserDefaultsManager.saveDefaults(latteStamps: self.controller.latteStamps, redeemCount: self.controller.redeemCount)
                                    self.controller.changeUIDoneEdit(state: false)
                                    self.controller.isAuthorized = false
                                    self.controller.editOutlet.isHidden = false
                                }
                            })
                            return
                        }
                        
                        // User hasn't redeemed enough stampsz
                        Alert.show(controller: self.controller, title: "", message: AlertMessage.NotEnoughStamps.rawValue, action: {
                            self.controller.editOutlet.isHidden = false
                        })
                        return
                    }
                    
                    // 2. Add stamp QR code scanned
                    //if self.controller.verificationCodes.contains(where: result.value) {
                    let resultVerification: VerificationCode = VerificationCode(code: resultString);
                    debugPrint("codes ", verificationCodeArray)
                    for verificationCode in verificationCodeArray {
                        if( verificationCode.code == resultVerification.code) {
                            print("Approved!")
                            print(verificationCode.stamps);
                            if self.controller.isUserNearStore() {
                                
                                //Vibrate phone
                                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                                
                                Alert.show(controller: self.controller, title: "", message: AlertMessage.StampAdded.rawValue, action: {
                                    DispatchQueue.main.async {
                                        for (_, verificationCode) in self.controller.verificationCodes.enumerated() {
                                            if resultString != verificationCode.code {
                                                continue
                                            }
                                            print("no of stamps:  \(self.controller.latteStamps)");
                                            print(resultVerification.stamps);
                                            self.controller.latteStamps += verificationCode.stamps;
                                            self.controller.updateUIOfMine()
                                            UserDefaultsManager.saveDefaults(latteStamps: self.controller.latteStamps, redeemCount: self.controller.redeemCount)
                                            if FIRAuth.auth()!.currentUser != nil {
                                                self.userRef = FIRDatabase.database().reference(withPath: "users/\(FIRAuth.auth()!.currentUser!.uid)")
                                                self.userRef.child("/stampCount").setValue(self.controller.latteStamps)
                                                let formatter = DateFormatter()
                                                formatter.dateStyle = .long
                                                formatter.timeStyle = .medium
                                                
                                                // let dateString = formatter.string(from: Date())
                                                // let stampData = [
                                                //     "stampCount": verificationCode.stamps,
                                                //     "time": dateString
                                                //     ] as [String : Any]
                                                //self.userRef.child("/allStamps").childByAutoId().setValue(stampData)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(verificationCode.stamps/2), execute: {
                                                self.controller.giveFreeStamptoUser()
                                            })
                                            self.controller.changeUIDoneEdit(state: false)
                                            self.controller.isAuthorized = false
                                            self.controller.redeemStarsLblTxt.isHidden = true
                                            
                                            break
                                        }
                                    }
                                })
                            } else {
                                Alert.show(controller: self.controller, title: "Location verification error", message: "You are not within the range permissible (15 meters) to redeem your stamp(s). Please be present inside the store.", action: {
                                    self.controller.changeUIDoneEdit(state: false)
                                    self.controller.isAuthorized = false
                                    self.controller.redeemStarsLblTxt.isHidden = true
                                })
                            }
                            return
                        }
                    }
                    
                    // 3. Invalid QR code scanned
                    Alert.show(controller: self.controller, title: "", message: AlertMessage.InvalidQRCode.rawValue, action: {
                        DispatchQueue.main.async {
                            //self.controller.ScanQRCode(scannedString: "", isSuccess: false)
                            self.controller.changeUI(state: false)
                            print("Authorization Failed!")
                        }
                    })
                }
            }
        }
    }
}
