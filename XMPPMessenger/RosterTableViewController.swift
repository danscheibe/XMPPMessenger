//
//  RosterTableViewController.swift
//  XMPPMessenger
//
//  Created by Hamza Öztürk on 16/01/2017.
//  Copyright © 2017 Hamza Öztürk. All rights reserved.
//

import UIKit
import XMPPFramework

class RosterTableViewController: UITableViewController, ChatDelegate {
    
    var onlineBuddies = NSMutableArray()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.object(forKey: "userID") != nil) {
            if appDelegate.connect() {
                self.title = appDelegate.xmppStream.myJID.bare()
                appDelegate.xmppRoster.fetch()
            }
        } else {
            performSegue(withIdentifier: "Home.To.Login", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlineBuddies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)

        cell.textLabel?.text = onlineBuddies[indexPath.row] as? String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Warning!", message: "It will send Yo! to the recipient, continue ?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            let message = "Yo!"
            let senderJID = XMPPJID(string: self.onlineBuddies[indexPath.row] as? String)
            let msg = XMPPMessage(type: "chat", to: senderJID)
            
            msg?.addBody(message)
            self.appDelegate.xmppStream.send(msg)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func buddyWentOnline(name: String) {
        if !onlineBuddies.contains(name) {
            onlineBuddies.add(name)
            tableView.reloadData()
        }
    }
    
    func buddyWentOffline(name: String) {
        onlineBuddies.remove(name)
        tableView.reloadData()
    }
    
    func didDisconnect() {
        onlineBuddies.removeAllObjects()
        tableView.reloadData()
    }

}
