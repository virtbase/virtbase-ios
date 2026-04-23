//
//  Configuration.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 23.04.26.
//

import Foundation

class Configuration {
    
    #if DEBUG
    static let BASE_URL = "https://staging.virtbase.com/api/v1"
    #else
    static let BASE_URL = "https://app.virtbase.com/api/v1"
    #endif
    
    static let WEBSITE_URL = "https://virtbase.com/de"
    static let EMAIL_URL = "mailto:support@virtbase.com"
    static let DISCORD_URL = "https://discord.gg/ywrqTubzh5"
    
    /*
     You may provide a Vercel deployment bypass key here
     to test the application against a private or beta deployment.

     The key can be generated within Vercel under Deployment Protection.

     MARK: Do not commit this value to version control.
     MARK: This key is highly sensitive and must be kept confidential.
    */
    
    static let VERCEL_BYPASS = ""
}
