//
//  FriendChatViewController.swift
//  Divinique
//
//  Created by LinjunCai on 6/6/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FriendChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var secondUser: User!
    
    @IBOutlet weak var chatTitleText: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgInputField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        guard let text = msgInputField.text, !text.isEmpty else { return }
        sendMessage(text)
        msgInputField.text = ""
    }
    
    
    // Define an array to hold Message objects
    var messages: [Message] = []
    
    // Firestore database reference
    var db: Firestore!
    
    // viewDidLoad is called when the view is first loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTitleText.text = secondUser.name
        // Initialize Firestore database
        db = Firestore.firestore()
        
        // Enable automatic dimension for row height
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        // Set the table view's delegate and data source to the current view controller
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the UITableViewCell class for use in creating new table cells
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        
        tableView.separatorStyle = .none
        
        // Fetch existing messages from Firestore
        fetchMessages()
    }
    
    // Function to fetch messages from Firestore
    func fetchMessages() {
        // Ensure there is a currently authenticated user
        guard let firstUserId = Auth.auth().currentUser?.uid else { return }
        
        // Query Firestore for messages where the current user is the first user
        db.collection("messages")
            .whereField("firstUser", isEqualTo: firstUserId)
            .whereField("secondUser", isEqualTo: self.secondUser.userId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching chat: \(error)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    // If a chat exists, load messages from the document
                    self.loadMessages(from: document)
                } else {
                    // If no chat is found, query for messages where the current user is the second user
                    self.db.collection("messages")
                        .whereField("firstUser", isEqualTo: self.secondUser.userId)
                        .whereField("secondUser", isEqualTo: firstUserId)
                        .getDocuments { (snapshot, error) in
                            if let error = error {
                                print("Error fetching chat: \(error)")
                                return
                            }
                            
                            if let document = snapshot?.documents.first {
                                // If a chat exists, load messages from the document
                                self.loadMessages(from: document)
                            } else {
                                // If no chat exists between the users
                                print("No chat history found.")
                            }
                        }
                }
            }
    }
    
    // Function to load messages from a Firestore document
    func loadMessages(from document: QueryDocumentSnapshot) {
        // Retrieve messages array from the document
        if let messagesArray = document.data()["messages"] as? [String] {
            // Convert the messages array from strings to Message objects
            self.messages = messagesArray.compactMap { messageString in
                let components = messageString.split(separator: ",")
                if components.count == 3 {
                    let whichSender = String(components[0])
                    let text = String(components[1])
                    let timestamp = ISO8601DateFormatter().date(from: String(components[2])) ?? Date()
                    return Message(sender: whichSender, text: text, timestamp: timestamp)
                }
                return nil
            }
            // Reload the table view to display the messages
            self.tableView.reloadData()
            // Scroll to the bottom of the table view to show the latest message
            self.scrollToBottom()
        }
    }
    
    // Function to scroll to the bottom of the table view
    func scrollToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // Function to send a message
    func sendMessage(_ text: String) {
        // Ensure there is a currently authenticated user
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        // Create a new Message object
        let message = Message(sender: currentUserId, text: text, timestamp: Date())
        // Convert the Message object to a string
        let messageString = "\(message.sender),\(message.text),\(ISO8601DateFormatter().string(from: message.timestamp))"
        
        // Query Firestore for an existing chat where the current user is the first user
        db.collection("messages")
            .whereField("firstUser", isEqualTo: currentUserId)
            .whereField("secondUser", isEqualTo: secondUser.userId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching chat: \(error)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    // If a chat exists, update the messages array
                    document.reference.updateData([
                        "messages": FieldValue.arrayUnion([messageString])
                    ])
                    self.fetchMessages()
                } else {
                    // If no chat is found, query for messages where the current user is the second user
                    self.db.collection("messages")
                        .whereField("firstUser", isEqualTo: self.secondUser.userId)
                        .whereField("secondUser", isEqualTo: currentUserId)
                        .getDocuments { (snapshot, error) in
                            if let error = error {
                                print("Error fetching chat: \(error)")
                                return
                            }
                            
                            if let document = snapshot?.documents.first {
                                // If a chat exists, update the messages array
                                document.reference.updateData([
                                    "messages": FieldValue.arrayUnion([messageString])
                                ])
                                self.fetchMessages()
                            } else {
                                // If no chat exists, create a new chat document
                                self.db.collection("messages").addDocument(data: [
                                    "firstUser": currentUserId,
                                    "secondUser": self.secondUser.userId,
                                    "messages": [messageString]
                                ])
                                self.fetchMessages()
                            }
                        }
                }
            }
    }
    
    // Table view data source method to configure and provide a cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        //check if its from the curreny user
        let isFromCurrentUser = message.sender != self.secondUser.userId
        
        cell.configure(with: message, isFromCurrentUser: isFromCurrentUser)
        return cell
    }
    
    // Table view data source method to return the number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}
