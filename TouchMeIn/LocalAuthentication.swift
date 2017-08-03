//
//  LocalAuthentication.swift
//  TouchMeIn
//
//  Created by 余锦海 on 17/8/3.
//  Copyright © 2017年 iT Guy Technologies. All rights reserved.
//

import Foundation
import LocalAuthentication

class TouchIDAuth {
    let context = LAContext()
    
    //     if Touch ID is supported.
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser(completion: @escaping (String?) -> Void) { // 1
        // 2
        guard canEvaluatePolicy() else {
            completion("Touch ID not available")
            return
        }
        
        // 3
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Logging in with Touch ID") { (success, evaluateError) in
                                // 4
                                if success {
                                    // on main thread to update UI.
                                    DispatchQueue.main.async {
                                        // User authenticated successfully, take appropriate action
                                        completion(nil)
                                    }
                                } else {
                                    // TODO: deal with LAError cases
                                    // 1
                                    let message: String
                                    
                                    // 2
                                    switch evaluateError {
                                    // 3
                                    case LAError.authenticationFailed?:
                                        message = "There was a problem verifying your identity."
                                    case LAError.userCancel?:
                                        message = "You pressed cancel."
                                    case LAError.userFallback?:
                                        message = "You pressed password."
                                    default:
                                        message = "Touch ID may not be configured"
                                    }
                                    // 4
                                    completion(message)
                                    
                                }
        }
    }
    
}
