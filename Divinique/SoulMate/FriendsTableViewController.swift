//
//  FriendsTableViewController.swift
//  Divinique
//
//  Created by LinjunCai on 6/6/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FriendsTableViewController: UITableViewController{
    var friends: [String] = [] //store all the friend's user id
    var friendDetails: [User] = [] //store allthe friends in here
    var friend: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFriends()
    }
    
    func fetchFriends() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        // Find the current user's document based on the userId field
        db.collection("users").whereField("userId", isEqualTo: currentUserId).getDocuments { (snapshot, error) in
            guard let document = snapshot?.documents.first else {
                print("User document not found: \(String(describing: error))")
                return
            }
            
            if let friendsArray = document.data()["friends"] as? [String] {
                self.friends = friendsArray
                self.fetchFriendDetails()
            }
        }
    }
    
    //get the friends from the friends array in the databse
    func fetchFriendDetails() {
        let db = Firestore.firestore()
        let group = DispatchGroup()
        
        for friendId in friends {
            group.enter()
            db.collection("users").whereField("userId", isEqualTo: friendId).getDocuments { (snapshot, error) in
                if let document = snapshot?.documents.first {
                    do {
                        let user = try document.data(as: User.self)
                        self.friendDetails.append(user)
                    } catch let error {
                        print("Error decoding user: \(error)")
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //for each cell display friend's name
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        let friend = friendDetails[indexPath.row]
        cell.textLabel?.text = friend.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //user clicked on one of the cell
        friend = friendDetails[indexPath.row]
        print("Selected friend: \(friend.name)")
        //go to the chat page
        performSegue(withIdentifier: "chatSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatSegue" {
            //pass the user to next view
            if let destinationVC = segue.destination as? FriendChatViewController{
                destinationVC.secondUser = self.friend
            }
        }
    }
}
