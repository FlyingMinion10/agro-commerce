import SwiftUI

class UserData {
    static let shared = UserData()
    var profileName: String = ""
    var accountType: String = ""

    private init() {}
}


struct ProfileData {
    let profileName: String = UserDefaults.standard.string(forKey: "profileName") ?? ""
    let accountType: String = UserDefaults.standard.string(forKey: "accountType") ?? ""
    
    init() {
        UserData.shared.profileName = profileName
        UserData.shared.accountType = accountType
    }
}
