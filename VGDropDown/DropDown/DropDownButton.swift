//
//  DropDownButton.swift
//  VGDropDown
//
//  Created by Vivek on 1/9/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import Foundation

class DropDownButton: UIButton {
   
    //-------------------------
    var listView = DropDownView()
    var height = NSLayoutConstraint()
    var isOpen = false
    
    //----- Initializer---------
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.setTitleColor(.white, for: .normal)
        self.setTitle("Button title", for: .normal)
        
        listView.delegate = self
        listView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(listView)
        self.superview?.bringSubview(toFront: listView)
        
        listView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        listView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        listView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = listView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    //---------------Touch Began event handler for Button---------------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if isOpen {
            //-------------When List is already visiable----------------------------
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            //-------Animation for hiding dropdown list-----------------------------
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .transitionCurlUp, animations: {
                self.listView.center.y -= self.listView.frame.height / 2
                self.listView.layoutIfNeeded()
            }, completion: nil)
            
        }else{
            //-------------When List is not visiable----------------------------
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            if self.listView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            }else{
                self.height.constant = self.listView.tableView.contentSize.height
            }
            NSLayoutConstraint.activate([self.height])
            
            //-------Animation for displaying dropdown list---------------------------
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .transitionCurlDown, animations: {
                self.listView.center.y += self.listView.frame.height
                self.listView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    //-----To hide list on selection---------------------------
    func dismissDropDown() {
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .transitionCurlUp, animations: {
            self.listView.center.y -= self.listView.frame.height / 2
            self.listView.layoutIfNeeded()
        }, completion: nil)
    }
    
}

//MARK:- Delegate method
extension DropDownButton: DropDownDelegate {
    
    //-----Called when selection made at Index---------------------------
    func optionSelected(at index: Int) {
        self.dismissDropDown()
    }
    
}
