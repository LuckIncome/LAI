//
//  HelpController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 10/1/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

typealias TitleWithLink = (title: String, link: String)

class HelpController: UIViewController {

    let titlesWithLinks: [TitleWithLink] = [
        ("Ссылка на наш инстаграм", "https://instagram.com/arzantaksi?utm_source=ig_profile_share&igshid=2r2su3jcmjec"),
        ("Как получить бонус?", "https://youtu.be/hS0z9oe5Rjs"),
        ("Как стать пользователем?", "https://youtu.be/-nrcA9hL_vw"),
        ("Как найти спецтехнику?", "https://youtu.be/Jtc_OfEJoSQ"),
        ("Как заказать такси?", "https://youtu.be/FJ_lOh8f46c"),
        ("Как заказать мототакси?", "https://youtu.be/RL9h0yUZueU"),
        ("Вызвать Lady-водитель", "https://youtu.be/fFNhAKXhYEg"),
        ("Как оставить жалоб или предложение?", "https://youtu.be/K-tWnZ79-Kw"),
        ("Как пополнить через карточку?", "https://youtu.be/EyrSiy-anuk"),
        ("Как пополнить баланс через терминалы?", "https://youtu.be/easd0SCGZYk"),
        ("Как передать свой бонус другому пользователю?", "https://youtu.be/tJh-TtR-ZRs"),
        ("Как стать водителем и получить 200 тенге?", "https://youtu.be/wqaT-lr1bFA"),
        ("Как получить заказы?", "https://youtu.be/bbDCysnK0P8"),
        ("Как перевести бонус на единицы?", "https://youtu.be/erQz6BEDjo8")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBarItems()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
    }
    
    private func setupNavBarItems() {
//        var langImage = UIImage()
//        if UserDefaults.standard.string(forKey: "language") == "kz" {
//            langImage = UIImage(named: "kazakh")!
//        } else if UserDefaults.standard.string(forKey: "language") == "ru" {
//            langImage = UIImage(named: "russian")!
//        } else if UserDefaults.standard.string(forKey: "language") == "en" {
//            langImage = UIImage(named: "english")!
//        }
//        
//        langImage = langImage.withRenderingMode(.alwaysOriginal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: langImage, style: .plain, target: self, action: #selector(changeLanguage))
        
        navigationItem.title = String.localizedString(key: "help")
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationController?.navigationBar.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
    }
    
    private func openLink(at index: Int) {
        let titleWithLink = titlesWithLinks[index]
        guard let url = URL(string: titleWithLink.link) else {
            print("error")
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.register(NewHelpCell.self, forCellReuseIdentifier: "cellId")
        
        return tv
    }()
    
}

extension HelpController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesWithLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NewHelpCell
        cell.linkLabel.tag = indexPath.row + 1
        let titleWithLink = titlesWithLinks[indexPath.row]
        cell.titleLabel.text = titleWithLink.title
        cell.linkLabel.text = titleWithLink.link
        cell.selectionStyle = .none
        cell.action = { [unowned self] (index) in
            self.openLink(at: index)
        }
        
        return cell
    }
}


