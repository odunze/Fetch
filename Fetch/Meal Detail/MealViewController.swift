//
//  MealViewController.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import UIKit

class MealViewController: UIViewController {

    private var vm: MealDetailViewModel
    
    var scroller: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var instructionsView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
            
            measurementLabel.numberOfLines = 2
            measurementLabel.lineBreakMode = .byCharWrapping
            measurementLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true

            ingredientLabel.text = ingredient.name
            measurementLabel.text = ingredient.measure

            let measurementStack = UIStackView(arrangedSubviews: [ingredientLabel, measurementLabel])
            measurementStack.axis = .horizontal
            measurementStack.distribution = .equalCentering

            ingredientStack.addArrangedSubview(measurementStack)
        }
    }
    
    init(viewModel: MealDetailViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        view.addSubview(scroller)
        scroller.addSubview(contentView)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(ingredientStack)
        contentView.addSubview(instructionsView)
        
        
        NSLayoutConstraint.activate([
            scroller.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroller.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroller.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroller.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroller.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scroller.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroller.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroller.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scroller.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ingredientStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            ingredientStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ingredientStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            instructionsView.topAnchor.constraint(equalTo: ingredientStack.bottomAnchor, constant: 20),
            instructionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            instructionsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
