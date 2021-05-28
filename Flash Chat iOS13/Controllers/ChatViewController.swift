import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    // MARK: - Variables -
    
    let db = Firestore.firestore()
    
    var messages: [MessageModel] = []
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        title = Constants.appName
        navigationItem.hidesBackButton = true
        // set the cell nib file to be the cell for our table view
        tableView.register(
            UINib(nibName: Constants.cellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.cellIdentifier
        )
        
        loadMessages()
    }
    
    // MARK: - IBActions -
    
    // send a message, save it to firestore
    @IBAction func sendPressed(_ sender: UIButton) {
        if messageTextfield.text == "" { return }
        if let messageBody = messageTextfield.text,
           let messageSender = Auth.auth().currentUser?.email {
            let documentData = [
                Constants.Firestore.senderField: messageSender,
                Constants.Firestore.bodyField: messageBody,
                // this field is for sorting the messages when we display them in the table view
                Constants.Firestore.dateField: Date().timeIntervalSince1970
            ] as [String : Any]
            /**
             * create a collection and add the document into it
             * the data of the document matches the message model
             * each document gets added has an auto generated id which is the document name
             */
            db.collection(Constants.Firestore.collectionName).addDocument(data: documentData) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore: \(e.localizedDescription)")
                } else {
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                        // reset the message text field
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
    }
    
    // MARK: - Helper Functions -
    
    // get the messages from firestore
    func loadMessages() {
        // get all the documents and listen to any change happens in them
        db.collection(Constants.Firestore.collectionName)
            .order(by: Constants.Firestore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            // reset this array cause the listener gets all the documents again when any change happens
            self.messages = []
            // if any error happened while getting the documents
            if let e = error {
                print("Couldn't get the data: \(e.localizedDescription)")
            } else {
                // if no errors happened then get the documents
                if let snapshotDocuments = querySnapshot?.documents {
                    // each document has the data as a dictionary
                    for doc in snapshotDocuments {
                        // data() is a dictionary
                        let data = doc.data()
                        // pull the sender and the message body from the dictionry and unwrap them
                        if let messageSender = data[Constants.Firestore.senderField] as? String,
                           let messageBody = data[Constants.Firestore.bodyField] as? String {
                            // create a new message model object with the data we pulled
                            let newMessage = MessageModel(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            // reload the table view wi the new messages
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                /// scroll to the bottom of the table view automatically
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource -

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier,
            for: indexPath
        ) as! MessageTableViewCell
        cell.label.text = message.body
        /// this is the message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
        } else {
            /// this is a message from another sender
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        return cell
    }
}
