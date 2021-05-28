import UIKit

class MessageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    // MARK: - Init -
    
    // initialize whatever in the xib file
    override func awakeFromNib() {
        super.awakeFromNib()
        // make the corner radius adapt to the height of the message
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }
}
