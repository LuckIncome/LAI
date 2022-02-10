//
//  DropDownButton.swift
//  ArzanTaxi
//
//  Created by Esset Murat on 11/24/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit

class DropDownButton : UIButton {
    
    var dropView = DropDownView()
    
    var height = NSLayoutConstraint()
    var isOpen = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dropView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.layer.borderColor = UIColor.lightGray.cgColor
        dropView.layer.borderWidth = 1.5

        dropView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isOpen {
            isOpen = true
            NSLayoutConstraint.deactivate([height])
            
            height.constant = dropView.tableView.contentSize.height
            
            NSLayoutConstraint.activate([height])
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
            isOpen = false
            NSLayoutConstraint.deactivate([height])
            height.constant = 0
            NSLayoutConstraint.activate([height])
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
