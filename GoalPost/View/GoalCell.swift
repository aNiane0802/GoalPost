//
//  GoalCell.swift
//  GoalPost
//
//  Created by Aboubakrine Niane on 15/03/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {
    
    private let goalCompleteLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "GOAL COMPLETE"
        label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var goalCompleteView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        view.alpha = 0.8
        return view
    }()

    private let goalLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.init(name: "AvenirNext-Regular", size: 17)
        label.text = "Goal:"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true 
        return label
    }()
    
    private let goalDescriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "AvenirNext-Medium", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let typeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "AvenirNext-Regular", size: 17)
        label.text = "Type:"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goalTypeDescription : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "AvenirNext-Medium", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let goalProgressLabel : UILabel = {
       let label = UILabel.init()
        label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 28)
        label.textColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let goalStackLabel = UIStackView.init(arrangedSubviews: [goalLabel,goalDescriptionLabel])
        goalStackLabel.translatesAutoresizingMaskIntoConstraints = false
        goalStackLabel.distribution = .fillProportionally
        goalStackLabel.spacing = 10
        let goalTypeStackLabel = UIStackView.init(arrangedSubviews: [typeLabel,goalTypeDescription])
        goalTypeStackLabel.translatesAutoresizingMaskIntoConstraints = false
        goalTypeStackLabel.distribution = .fillProportionally
        goalStackLabel.spacing = 10
        
        let containerStackView = UIStackView.init(arrangedSubviews: [goalStackLabel,goalTypeStackLabel])
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.spacing = 2
        containerStackView.axis = .vertical
        
        addSubview(goalProgressLabel)
        NSLayoutConstraint.activate([
            goalProgressLabel.widthAnchor.constraint(equalToConstant: 70),
            goalProgressLabel.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            goalProgressLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            goalProgressLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: goalProgressLabel.leadingAnchor)
            ])
        
        addSubview(goalCompleteView)
        NSLayoutConstraint.activate([
            goalCompleteView.centerXAnchor.constraint(equalTo: centerXAnchor),
            goalCompleteView.centerYAnchor.constraint(equalTo: centerYAnchor),
            goalCompleteView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            goalCompleteView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
            ])
        goalCompleteView.addSubview(goalCompleteLabel)
        NSLayoutConstraint.activate([
            goalCompleteLabel.centerXAnchor.constraint(equalTo: goalCompleteView.centerXAnchor),
            goalCompleteLabel.centerYAnchor.constraint(equalTo: goalCompleteView.centerYAnchor),
            goalCompleteLabel.widthAnchor.constraint(equalTo: goalCompleteView.widthAnchor, multiplier:2/3),
            goalCompleteLabel.heightAnchor.constraint(equalTo: goalCompleteView.heightAnchor, multiplier: 1/3)
            ])

    }
    
    func setGoalInformations(goalDescription:String,goalType: GoalType,goalProgress: Int){
        goalProgressLabel.text = String.init(describing: goalProgress)
        goalDescriptionLabel.text = goalDescription
        goalTypeDescription.text = goalType.rawValue
    }
    
    func changeStateIfProgressComplete(goal: Goal){
        if goal.goalProgress >= goal.goalCompletionValue {
            goalCompleteView.isHidden = false
        }else{
            goalCompleteView.isHidden = true
        }
    }
    
    

}
