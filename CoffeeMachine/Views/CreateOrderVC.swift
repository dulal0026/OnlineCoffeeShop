//
//  CreateOrderVC.swift
//  CoffeeMachine
//
//  Created by user on 14/9/22.
//

import UIKit

protocol CreateOrderVCDelegate {
    func addCoffeeOrderVCDidSave(order:Order,controller:UIViewController)
    func addCoffeeOrderVCDidClose(controller:UIViewController)
}
class CreateOrderVC: UIViewController {

    var viewModel:AddCoffeeViewModel =  AddCoffeeViewModel()
    var delegate:CreateOrderVCDelegate?
    
    
    lazy var tableView:UITableView = {
        let tblView:UITableView = UITableView(frame: .zero)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.backgroundColor = .clear
        tblView.tableFooterView = UIView()
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tblView
    }()
    lazy var segmentControl:UISegmentedControl = {
        let segC:UISegmentedControl = UISegmentedControl(frame: .zero)
        segC.translatesAutoresizingMaskIntoConstraints = false
        return segC
    }()
    lazy var nameTextField:UITextField = {
        let txtF:UITextField = UITextField(frame: .zero)
        txtF.keyboardType = .default
        txtF.textColor = .black
        txtF.placeholder = "Name"
        txtF.translatesAutoresizingMaskIntoConstraints = false
        txtF.borderStyle = .roundedRect
        return txtF
    }()
    lazy var emailTextField:UITextField = {
        let txtF:UITextField = UITextField(frame: .zero)
        txtF.keyboardType = .emailAddress
        txtF.textColor = .black
        txtF.placeholder = "Email Address"
        txtF.translatesAutoresizingMaskIntoConstraints = false
        txtF.borderStyle = .roundedRect
        return txtF
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Place Order"
        self.view.backgroundColor = .white
        
       // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(placeOrder(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(placeOrder(_:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(popBack(_:)))

        self.view.addSubview(segmentControl)
        self.view.addSubview(nameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(tableView)
        setuUpConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self

        for i in 0..<viewModel.sizes.count {
            segmentControl.insertSegment(withTitle: viewModel.sizes[i], at: i,animated: true)
        }
        segmentControl.selectedSegmentIndex = 0
    }
    
    func setuUpConstraints(){
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        segmentControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nameTextField.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10).isActive = true

        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
    }
    
    @objc func popBack(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }

    @objc func placeOrder(_ sender:UIBarButtonItem){
        guard let name = nameTextField.text,let email = emailTextField.text,!name.isEmpty,!email.isEmpty else {
            return
        }
        let selecedSegIndex = segmentControl.selectedSegmentIndex
        guard let selectedSize = segmentControl.titleForSegment(at: selecedSegIndex) else {
            return
        }
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        let selectedType = viewModel.types[indexPath.row]
        
        viewModel.name = name
        viewModel.email = email
        viewModel.selectedSize = selectedSize
        viewModel.selectedType = selectedType
   
        WebService().load(resource: Order.create(viewModel)) {[weak self] (result) in
            
            switch result{
            
            case .success(let order):
                if let order = order{
                    self?.delegate?.addCoffeeOrderVCDidSave(order: order, controller: self!)
                }
            case.failure(let error):
            print(error)
            
            }
        }
    }
}

extension CreateOrderVC : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.types.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
