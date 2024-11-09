//
//  MealViewController.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import UIKit

class MealViewController: UIViewController {
    
    // Meal name
    // Instructions
    // Ingredients/measurements
    
    private var meal: Meal
    
    var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var instructionsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var ingredientsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var infoStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = meal.name
        //instructionsLabel.text =
        //ingredientsLabel.text =
        
    }
    
    init(meal: Meal) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
        
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(instructionsLabel)
        infoStack.addArrangedSubview(ingredientsLabel)

        view.addSubview(infoStack)
        
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            //infoStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            infoStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
