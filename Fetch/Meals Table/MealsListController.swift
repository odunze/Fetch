//
//  MealsListController.swift
//  Fetch
//
//  Created by Lotanna Igwe-Odunze on 11/8/24.
//

import UIKit

class MealsListController: UIViewController {
    
    private var vm: MealsListViewModel
    private var cellIdentifier: String = "mealCell"
    
    private var mealsTable: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMeals()
    }
    
    init(viewModel: MealsListViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white

        mealsTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        mealsTable.dataSource = self
        mealsTable.delegate = self
        view.addSubview(mealsTable)

        NSLayoutConstraint.activate([
            mealsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mealsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mealsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mealsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadMeals() {
        Task {
            do {
                try await vm.loadDesserts()
                DispatchQueue.main.async {
                    self.mealsTable.reloadData()
                }
            } catch {
                print("NETWORK CALL FROM VC WITH ERROR: \(error.localizedDescription)")
            }
        }
    }
}

extension MealsListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meal = vm.meals[indexPath.row]
        
        let cell = mealsTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = meal.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = vm.meals[indexPath.row]
        let mealVM = MealDetailViewModel(meal: meal)
        let mealVC = MealDetailViewController(viewModel: mealVM)
        
        navigationController?.pushViewController(mealVC, animated: true)
    }
}
