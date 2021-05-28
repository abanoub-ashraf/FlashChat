struct Constants {
    
    // MARK: - Segues -
    
    static let loginSegue    = "loginToChat"
    static let registerSegue = "registerToChat"
    
    // MARK: - TableViewCells -
    
    static let cellNibName    = "MessageTableViewCell"
    static let cellIdentifier = "ReusableCell"
    
    // MARK: - Titles -

    static let appName = "⚡️FlashChat"
    
    // MARK: - Colors -
    
    struct BrandColors {
        static let purple      = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue        = "BrandBlue"
        static let lightBlue   = "BrandLightBlue"
    }
    
    // MARK: - Firebase -
    
    struct Firestore {
        static let collectionName = "messages"
        static let senderField    = "sender"
        static let bodyField      = "body"
        static let dateField      = "date"
    }
}
