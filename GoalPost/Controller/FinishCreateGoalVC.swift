//
//  FinishCreateGoalVC.swift
//  GoalPost
//
//  Created by Aboubakrine Niane on 09/04/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

class FinishCreateGoalVC: UIViewController {
    
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var _goalDescription = String()
    private var _goalType = GoalType.init(rawValue: "")
    
    
    let questionLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How many points until complete?"
        label.font = UIFont.init(name: "AvenirNext-Medium", size: 18)
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        return label
    }()
    
    let pointsToCompleteField : UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "0"
        textField.textColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
        textField.textAlignment = .center
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 18
        textField.font = UIFont.init(name: "AvenirNext-Bold", size: 28)
        textField.borderStyle = UITextBorderStyle.roundedRect
        return textField
    }()
    
    
    let createGoalButton : UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let font = UIFont(name: "AvenirNext-Bold", size: 18) {
            let attributedTitle = NSAttributedString(string: "CREATE GOAL", attributes: [NSAttributedStringKey.font : font ,NSAttributedStringKey.foregroundColor:UIColor.white])
            button.setAttributedTitle(attributedTitle, for: .normal)
        }
        button.layer.cornerRadius = 4
        button.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backToGoalInfos))
        setupViews()
        createGoalButton.addTarget(self, action: #selector(handleGoalCreation), for: .touchUpInside)
        createGoalButton.bindToKeyboard()
    }
    
    func initializeGoal(goalDescription: String!,goalType: GoalType){
        _goalDescription = goalDescription
        _goalType = goalType
    }
    

    @objc func backToGoalInfos() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleGoalCreation(){
        
        if(pointsToCompleteField.text != "" && pointsToCompleteField.text != "0"){
            saveGoal { (finished) in
                if finished {
                    navigationController?.dismiss(animated: true, completion: nil)
                }else {
                    print("Failed to save a goal")
                }
            }
        }
    }

    
    func saveGoal(completion:(_ finished : Bool)->()) {
        guard let managedObjectContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        
        let goal = Goal(context: managedObjectContext)
        goal.goalType = _goalType?.rawValue
        goal.goalDescription = _goalDescription
        goal.goalProgress = Int32(0)
    
        guard let completionValue = pointsToCompleteField.text else {
            return
        }
        
        goal.goalCompletionValue = Int32(completionValue)!
        
        do {
            try managedObjectContext.save()
            completion(true)
        } catch let error {
            print(error.localizedDescription)
            completion(false)
        }
  
    }
    
    func setupViews(){
        view.addSubview(createGoalButton)
        NSLayoutConstraint.activate([
            createGoalButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createGoalButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            createGoalButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            createGoalButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        view.addSubview(questionLabel)
        NSLayoutConstraint.activate([
            questionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            questionLabel.heightAnchor.constraint(equalToConstant: 34)
            ])
        
        view.addSubview(pointsToCompleteField)
        NSLayoutConstraint.activate([
            pointsToCompleteField.centerXAnchor.constraint(equalTo: questionLabel.centerXAnchor),
            pointsToCompleteField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 16),
            pointsToCompleteField.widthAnchor.constraint(equalToConstant: 80),
            pointsToCompleteField.heightAnchor.constraint(equalToConstant: 80)
            ])
    }
}
