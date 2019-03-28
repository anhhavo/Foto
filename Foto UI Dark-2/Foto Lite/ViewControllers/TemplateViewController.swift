//
//  TemplateViewController.swift
//  Foto1
//
//  Created by Isabelle Xu on 11/27/18.
//  Copyright © 2018 Maysam Shahsavari. All rights reserved.
//

import Foundation
import UIKit

class TemplateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    let templateList: [Template] = [
        Template(
            header: "You're Invited!\nCome join the party!",
            body: "When: November 12th, 2019\nWhere: 64 Winslow Avenue",
            id: 0,
            tempImg: UIImage(named: "partyTempImg")!
            
        ),
        Template(
            header: "Come join our study session!",
            body: "Saturday, November 29th\nWinston Library 2nd Floor\n\nThere will be cookies!",
            id: 1,
            tempImg: UIImage(named: "libraryTempImg")!
        
        )
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "templateCell") as! templateCell
        if indexPath.row == 0 {
            cell.tempImage.image = UIImage(named: "partyTempPrev")
        } else if indexPath.row == 1 {
            cell.tempImage.image = UIImage(named: "libraryTempPrev")
        }
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the index path from the cell that was tapped
        let indexPath = tableview.indexPathForSelectedRow
        // Get the Row of the Index Path and set as index
        let index = indexPath?.row
        // Get in touch with the DetailViewController
        let TemplateDetailViewController = segue.destination as! TemplateDetailViewController
        // Pass on the template data to detail controller
        TemplateDetailViewController.currentTemp = templateList[index!]

        
    }

    

}
