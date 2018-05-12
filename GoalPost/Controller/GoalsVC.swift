//
//  ViewController.swift
//  GoalPost
//
//  Created by Aboubakrine Niane on 13/03/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit
import CoreData

class GoalsVC: UIViewController {
    
    private let _cellID = "GoalCell"
    private var goals = [Goal]()
    var undoContainerBottomAnchor : NSLayoutConstraint?
    
    lazy var welcomeLabel : UILabel = {
       let label = UILabel()
        label.text = "Welcome to GoalPost"
        label.font = UIFont.systemFont(ofSize: 34)
        label.textAlignment = .center
        return label
    }()
    
    lazy var undoViewContainer : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        let swipeToDismiss = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipeForUndoContainer))
        swipeToDismiss.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeToDismiss)
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var undoLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Goal Removed"
        label.textColor = .white
        label.font = UIFont.init(name: "AvenirNext-Regular", size: 18)
        return label
    }()
    
    lazy var undoButton : UIButton = {
       let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString.init(string: "UNDO", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font: UIFont.init(name: "AvenirNext-Bold", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)]), for: .normal)
        button.addTarget(self, action: #selector(handleUndoAction), for: .touchUpInside)
        return button
    }()
    
    lazy var createLabel : UILabel = {
        let label = UILabel()
        label.text = "To begin , create a goal"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var goalsTable : UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alpha = 0
        tableView.register(GoalCell.self, forCellReuseIdentifier: self._cellID)
        return tableView
    }()

    fileprivate func createSwipeControlToShowUndoMenu() {
        let swipeToDismiss = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipeToShowUndoMenu))
        swipeToDismiss.direction = UISwipeGestureRecognizerDirection.up
        view.addGestureRecognizer(swipeToDismiss)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "addGoal"), style: .done, target: self, action: #selector(addGoal))
        navigationItem.rightBarButtonItem = addBarButton
        navigationItem.titleView = titleVC()
        goalsTable.delegate = self
        goalsTable.dataSource = self 
        setLandingLabels()
        
        createSwipeControlToShowUndoMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillGoalsArray()
        goalsTable.reloadData()
    }
    
    fileprivate func cleanPersistentStore(_ managedObjectContext: NSManagedObjectContext) {
        for goal in goals {
            managedObjectContext.delete(goal)
        }
        do {
            try managedObjectContext.save()
        }catch let error {
            print(error)
        }
    }
    
    func fillGoalsArray(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedObjectContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Goal")
        do {
            goals = try managedObjectContext.fetch(request) as! [Goal]
        } catch let error {
            print("Unable to fetch data\n",error)
        }
        changeTableViewState()
    }
    
    @objc func addGoal() {
        let createGoalVC = CreateGoalVC()
        createGoalVC.view.backgroundColor = .white
        createGoalVC.navigationItem.titleView = titleVC()
        let navigationController = UINavigationController.init(rootViewController: createGoalVC)
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
        navigationController.navigationBar.tintColor = .white
        present(navigationController, animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    func removeGoalFromPersistantStore(indexPath:IndexPath){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedObjectContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        managedObjectContext.delete(goals[indexPath.row])
        do {
            try managedObjectContext.save()
        } catch let error {
            debugPrint("Unable to save changes into the persitant store\n",error)
        }
    }


}








extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    
    @objc func handleSwipeToShowUndoMenu(){
        UIView.animate(withDuration: 0.7) {
            self.undoContainerBottomAnchor?.constant = 0
        }
    }
    
    
    @objc func handleSwipeForUndoContainer() {
        UIView.animate(withDuration: 0.7) {
            self.undoContainerBottomAnchor?.constant = 60
        }
    }

    
    @objc func handleUndoAction(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedObjectContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        managedObjectContext.undo()

        
        do {
            try managedObjectContext.save()
        } catch let error {
            debugPrint(error)
        }
        fillGoalsArray()
        goalsTable.reloadData()
        handleSwipeForUndoContainer()
    }
    
    
    
    func changeTableViewState(){
        if goals.count != 0  {
                self.goalsTable.alpha = 1
            
        }else {
            UIView.animate(withDuration: 0.5) {
                self.goalsTable.alpha = 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func updateValueInPersistentStore(indexPath : IndexPath){
        let goal = self.goals[indexPath.row]
        goal.goalProgress += 1
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedObjectContext = appDelegate?.persistentContainer.viewContext else {return}
        do {
            try managedObjectContext.save()
        } catch let error {
            debugPrint("Unable to update values : \(error.localizedDescription)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteGoalAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.destructive, title: "Delete") { (rowAction, indexPath) in
            self.removeGoalFromPersistantStore(indexPath: indexPath)
            self.fillGoalsArray()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            UIView.animate(withDuration: 0.7, animations: {
                self.undoContainerBottomAnchor?.constant = 0
            })
        }
        
        let addProgress = UITableViewRowAction.init(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.updateValueInPersistentStore(indexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        addProgress.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        return [deleteGoalAction,addProgress]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: _cellID, for: indexPath)  as? GoalCell else {
            return GoalCell()
        }
        let goal = goals[indexPath.row]
        guard let goalDescription = goal.goalDescription , let goalType = goal.goalType else {
            return GoalCell()
        }
        cell.setGoalInformations(goalDescription: goalDescription, goalType: GoalType(rawValue: goalType)!, goalProgress: Int(goal.goalProgress))
        cell.changeStateIfProgressComplete(goal: goal)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
    
    func setLandingLabels() {
        let stackView = UIStackView.init(arrangedSubviews: [welcomeLabel,createLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo:view.safeAreaLayoutGuide.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            stackView.heightAnchor.constraint(equalToConstant: 70),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            ])
        
        view.addSubview(goalsTable)
        NSLayoutConstraint.activate([
            goalsTable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            goalsTable.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            goalsTable.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            goalsTable.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
            ])
        
        undoContainerBottomAnchor = undoViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 60)
        view.addSubview(undoViewContainer)
        NSLayoutConstraint.activate([
            undoViewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0),
            undoContainerBottomAnchor!,
            undoViewContainer.heightAnchor.constraint(equalToConstant: 60),
            undoViewContainer.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
            ])
        
        undoViewContainer.addSubview(undoLabel)
        NSLayoutConstraint.activate([
            undoLabel.centerYAnchor.constraint(equalTo: undoViewContainer.centerYAnchor),
            undoLabel.leadingAnchor.constraint(equalTo: undoViewContainer.leadingAnchor, constant: 16),
            undoLabel.topAnchor.constraint(equalTo: undoViewContainer.topAnchor, constant: 16),
            undoLabel.widthAnchor.constraint(equalToConstant: 200)
            ])
        
        undoViewContainer.addSubview(undoButton)
        NSLayoutConstraint.activate([
            undoButton.centerYAnchor.constraint(equalTo: undoViewContainer.centerYAnchor),
            undoButton.topAnchor.constraint(equalTo: undoViewContainer.topAnchor, constant: 16),
            undoButton.trailingAnchor.constraint(equalTo: undoViewContainer.trailingAnchor, constant: -16),
            undoButton.widthAnchor.constraint(equalToConstant: 70)
            ])
    }
    
    
    
    
}

