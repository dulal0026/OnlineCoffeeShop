//
//  OrderListVC.swift
//  CoffeeMachine
//
//  Created by user on 14/9/22.
//

import UIKit

class OrderListVC: UITableViewController {

    var orderListVM:OrderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Orders"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(createOrder(_:)))

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView()
        getOrders()
    }
    
    func getOrders()  {
         
        WebService().load(resource: Order.all) {[weak self] (result) in
        
            switch result{
            case .success(let orders):
            print(orders)
                DispatchQueue.main.async {
                    self?.orderListVM.ordersViewModel = orders.map({ OrderViewModel(order: $0)})
                    self?.tableView.reloadData()
                }
            case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListVM.noOfOrders()
    }
    
    @objc func createOrder(_ sender:UIBarButtonItem){
        let vc:CreateOrderVC = CreateOrderVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        let orVM = orderListVM.orderViewModel(at: indexPath.row)
        cell.textLabel?.text = orVM.name
        cell.detailTextLabel?.text = orVM.type
        return cell
    }
}

extension OrderListVC:CreateOrderVCDelegate{
    func addCoffeeOrderVCDidSave(order:Order,controller:UIViewController){
        
        self.orderListVM.ordersViewModel.append(OrderViewModel(order: order))
        self.tableView.reloadData()
        
        controller.navigationController?.popViewController(animated: true)
    }
    func addCoffeeOrderVCDidClose(controller:UIViewController){
        controller.navigationController?.popViewController(animated: true)
    }

}
