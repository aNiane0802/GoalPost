//
//  CreateGoalVC.swift
//  GoalPost
//
//  Created by Aboubakrine Niane on 17/03/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController {
    
    private var _goalType = GoalType.shortTerm
    
    private let shortTermButton : UIButton = {
       let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
        if let font = UIFont.init(name: "AvenirNext-DemiBold", size: 22){
            let attributedTitle = NSAttributedString.init(string: "Short Term", attributes: [NSAttributedStringKey.font: font,NSAttributedStringKey.foregroundColor:UIColor.white])
            button.setAttributedTitle(attributedTitle, for: .normal)
        }
        button.layer.cornerRadius = 3
        return button
    }()
    
    private let longTermButton : UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.8666666667, blue: 0.6862745098, alpha: 1)
        if let font = UIFont.init(name: "AvenirNext-DemiBold", size: 22){
            let attributedTitle = NSAttributedString.init(string: "Long Term", attributes: [NSAttributedStringKey.font: font,NSAttributedStringKey.foregroundColor:UIColor.white])
            button.setAttributedTitle(attributedTitle, for: .normal)
        }
        button.layer.cornerRadius = 3
        return button
    }()
    
    internal let goalDescription : UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.init(name: "AvenirNext-Medium", size: 17)
        textView.isScrollEnabled = false
        textView.textColor = UIColor.lightGray
        textView.text = "What is your goal?"
        textView.layer.borderWidth = 3
        textView.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        textView.layer.cornerRadius = 3
        return textView
    }()
    
    private let selectTypeGoal : UILabel = {
       let label = UILabel.init()
        label.text = "Select One"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 20)
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        return label
    }()
    
    private let nextButton : UIButton = {
       let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let font = UIFont(name: "AvenirNext-Bold", size: 18) {
            let attributedTitle = NSAttributedString(string: "NEXT", attributes: [NSAttributedStringKey.font : font ,NSAttributedStringKey.foregroundColor:UIColor.white])
             button.setAttributedTitle(attributedTitle, for: .normal)
        }
        button.layer.cornerRadius = 4
        button.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backToGoalsVC))
        setupViews()
        shortTermButton.addTarget(self, action: #selector(shortTermSelected), for: .touchUpInside)
        longTermButton.addTarget(self, action: #selector(longTermSelected), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonWasPressed), for: .touchUpInside)
        goalDescription.delegate = self
        nextButton.bindToKeyboard()
    }
    
    func titleVC() -> UIView {
        
        let goalLabel = UILabel.init()
        goalLabel.text = "GOAL"
        goalLabel.font = UIFont.init(name: "AvenirNext-Regular", size: 20)
        //goalLabel.font = UIFont.systemFont(ofSize: 17)
        goalLabel.textColor = UIColor.white
        
        let postLabel = UILabel.init()
        postLabel.text = "POST"
        postLabel.font = UIFont.boldSystemFont(ofSize: 20)
        postLabel.textColor = UIColor.white
        
        let stackView = UIStackView.init(arrangedSubviews: [goalLabel,postLabel])
        return stackView
    }
    
    @objc func nextButtonWasPressed(){
        
        if goalDescription.text != "" && goalDescription.text != "What is your goal?" {
            let finishCreation = FinishCreateGoalVC()
            finishCreation.view.backgroundColor = .white
            finishCreation.navigationItem.titleView = titleVC()
            finishCreation.initializeGoal(goalDescription: goalDescription.text,goalType: _goalType)
            navigationController?.pushViewController(finishCreation, animated: true)
        }

    }
    
    @objc func shortTermSelected(){
        shortTermButton.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
        longTermButton.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.8666666667, blue: 0.6862745098, alpha: 1)
        _goalType = .shortTerm
    }
    
    @objc func longTermSelected() {
        longTermButton.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
        shortTermButton.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.8666666667, blue: 0.6862745098, alpha: 1)
        _goalType = .longTerm
    }
    
    @objc func backToGoalsVC(){
       dismiss(animated: true, completion: nil)
    }
    
    func setupViews(){
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nextButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        view.addSubview(goalDescription)
        NSLayoutConstraint.activate([
            goalDescription.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            goalDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            goalDescription.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            goalDescription.heightAnchor.constraint(equalToConstant: 120)
            ])
        
        view.addSubview(selectTypeGoal)
        NSLayoutConstraint.activate([
            selectTypeGoal.topAnchor.constraint(equalTo: goalDescription.bottomAnchor, constant: 16),
            selectTypeGoal.leadingAnchor.constraint(equalTo: goalDescription.leadingAnchor),
            selectTypeGoal.widthAnchor.constraint(equalTo: goalDescription.widthAnchor, multiplier: 1/3),
            selectTypeGoal.heightAnchor.constraint(equalToConstant: 22)
            ])
        
        let stackView = UIStackView.init(arrangedSubviews: [shortTermButton,longTermButton])
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: selectTypeGoal.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: selectTypeGoal.bottomAnchor,constant:16),
            stackView.widthAnchor.constraint(equalTo: goalDescription.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
}

extension CreateGoalVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
}
