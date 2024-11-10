//
//  MealViewController.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import UIKit

class MealViewController: UIViewController {

    private var vm: MealDetailViewModel
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var instructionsView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var amountStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var ingredientStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = vm.meal.name
        nameLabel.text = vm.meal.name
        
        loadMealDetails()
    }
    
    func loadMealDetails() {
        Task {
            do {
                try await vm.loadMealDetails()
                DispatchQueue.main.async {
                    self.instructionsView.text = self.vm.meal.instructions
                    self.loadIngredients()
                }
            } catch {
                print("NETWORK CALL FROM VC WITH ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func loadIngredients() {
        guard let mealIngredients = vm.meal.ingredients else { return }
        
        for ingredient in mealIngredients {
            let ingredientLabel = UILabel()
            let measurementLabel = UILabel()

            ingredientLabel.text = ingredient.name
            measurementLabel.text = ingredient.measure

            let measurementStack = UIStackView(arrangedSubviews: [ingredientLabel, measurementLabel])
            measurementStack.axis = .horizontal
            
            ingredientStack.addArrangedSubview(measurementStack)
        }
    }
    
    init(viewModel: MealDetailViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white

        view.addSubview(nameLabel)
        view.addSubview(ingredientStack)
        view.addSubview(instructionsView)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            ingredientStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            ingredientStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            ingredientStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            instructionsView.topAnchor.constraint(equalTo: ingredientStack.bottomAnchor, constant: 20),
            instructionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            instructionsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            instructionsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
