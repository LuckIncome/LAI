//
//  ProfileCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/21/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import MaterialTextField
import Alamofire
import SVProgressHUD
import SwiftyJSON

class ProfileCell : UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func createPickerView(tag : Int) -> UIPickerView {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        
        return pickerView
    }
    
    var user : User? {
        didSet {
            if let surname = user?.surname, let name = user?.name, let middleName = user?.middle_name, let gos_number = user?.taxi_cars?.number, let car_mark = user?.taxi_cars?.mark?.name, let car_model = user?.taxi_cars?.model?.name, let car_year = user?.taxi_cars?.year, let car_color = user?.taxi_cars?.color?.name_en, let city = user?.city, let car_mark_ID = user?.taxi_cars?.mark?.id, let car_model_ID = user?.taxi_cars?.model?.id, let color_ID = user?.taxi_cars?.color?.id, let year = user?.taxi_cars?.year, let city_ID = user?.city_id, let ava = user?.avatar {
            
                surnameTextField.text = surname
                nameTextField.text = name
                patronymicTextField.text = middleName
                gosNumber.text = gos_number
                carMark.text = car_mark
                carModel.text = car_model
                carYear.text = car_year
                carColor.text = car_color
                cityTextField.text = city
                profileImage.kf.setImage(with: URL(string: ava), placeholder: #imageLiteral(resourceName: "profile_image"), options: nil, progressBlock: nil, completionHandler: nil)
                
                carMarkID = car_mark_ID
                carModelID = car_model_ID
                colorID = color_ID
                if let year = Int(year) {
                    self.year = year
                }
                cityID = city_ID
                
                setupViews()
            }
        }
    }
    
    let indicator = SVProgressHUD.self
    var cities = [City]()
    var carMarks = [CarMark]()
    var carModels = [CarModel]()
    var carMarkNames = [String]()
    var carModelNames = [String]()
    var carYears = [String]()
    var carColors = [CarColor]()
    var carColorNames = [String]()
    
    var carMarkID = 0
    var carModelID = 0
    var colorID = 0
    var year = 0
    var cityID = 0
    
    lazy var profileImage : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_image"))
        imageView.tag = 0
//        imageView.layer.cornerRadius = 50
//        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let surnameTextField = Helper.createInputField(withPlaceholder: .localizedString(key: "surname"), errorText: "")
    let nameTextField = Helper.createInputField(withPlaceholder: .localizedString(key: "name"), errorText: "")
    let patronymicTextField = Helper.createInputField(withPlaceholder: .localizedString(key: "middle_name"), errorText: "")
    let cityTextField = Helper.createInputField(withPlaceholder: .localizedString(key: "city"), errorText: "")

    let carMark = Helper.createInputField(withPlaceholder: .localizedString(key: "car_mark"), errorText: "")
    let carModel = Helper.createInputField(withPlaceholder: .localizedString(key: "car_model"), errorText: "")
    let carYear = Helper.createInputField(withPlaceholder: .localizedString(key: "car_year"), errorText: "")
    let carColor = Helper.createInputField(withPlaceholder: .localizedString(key: "car_color"), errorText: "")

    let gosNumber: MFTextField = {
        let gosNumber = Helper.createInputField(withPlaceholder: .localizedString(key: "gos_number"), errorText: "")

        return gosNumber
    }()
    let promocodeNumber: MFTextField  = {
        let promocodeNumber = Helper.createInputField(withPlaceholder: .localizedString(key: "promocode"), errorText: "Number have to consist 7-digits")
        promocodeNumber.keyboardType = .numberPad
        promocodeNumber.errorColor = .red

        return promocodeNumber
    }()
    
    lazy var cityPicker = createPickerView(tag : 4)
    lazy var carMarkPicker = createPickerView(tag : 0)
    lazy var carModelPicker = createPickerView(tag : 1)
    lazy var carYearPicker = createPickerView(tag : 2)
    lazy var carColorPicker = createPickerView(tag : 3)
    
    let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        let locale = Locale(identifier: "en_US")
        picker.datePickerMode = .date
        picker.locale = locale
        return picker
    }()
    
    lazy var idCardImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.tag = 1
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var idCardImageView2 : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.tag = 2
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var techPassportImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.tag = 3
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var techPassportImageView2 : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.tag = 4
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var pravaImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.tag = 5
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var pravaImageView2 : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.tag = 6
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var carImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.tag = 7
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var carImageView2 : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.tag = 8
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let idCardImageLabel : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "id_card_photo")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    let idCardImageLabel2 : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "id_card_photo2")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    let techPassportImageLabel : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "tech_passport_photo")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    let techPassportImageLabel2 : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "tech_passport_photo2")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    let pravaImageLabel : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "prava_photo")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    let pravaImageLabel2 : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "prava_photo2")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    let carImageLabel : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "car_photo")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    let carImageLabel2 : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "car_photo2")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    lazy var addSpecialEq : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.localizedString(key: "add_car"), for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return button
    }()
    
    lazy var continueButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.localizedString(key: "continue"), for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleImageViewTap(sender : UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            if tag == 1 {
                idCardImageLabel.isHidden = true
            } else if tag == 2 {
                idCardImageLabel2.isHidden = true
            } else if tag == 3 {
                techPassportImageLabel.isHidden = true
            } else if tag == 4 {
                techPassportImageLabel2.isHidden = true
            } else if tag == 5 {
                pravaImageLabel.isHidden = true
            } else if tag == 6 {
                pravaImageLabel2.isHidden = true
            } else if tag == 7 {
                carImageLabel.isHidden = true
            } else if tag == 8 {
                carImageLabel2.isHidden = true
            }
            delegate?.pickImage(tag: tag)
        }
    }
    
    var delegate : DriverProfileControllerDelegate?
    
    @objc func handleAddButton() {
        delegate?.addCar()
    }
    
    @objc func handleContinueButton() {
        if let token = UserDefaults.standard.string(forKey: "token"), let number = gosNumber.text, let surname = surnameTextField.text, let name = nameTextField.text, let patronymic = patronymicTextField.text, let promocode = promocodeNumber.text {
            let body : [String : String] = [
                "token" : token,
                "surname" : surname,
                "name" : name,
                "middle_name" : patronymic,
                "city_id" : "\(cityID)",
                "car_mark_id" : "\(carMarkID)",
                "car_model_id" : "\(carModelID)",
                "year" : "\(year)",
                "color_id" : "\(colorID)",
                "vip" : "0",
                "number" : number
            ]

            if user?.driver_was == 0 {
                if promocode != "" {
                    if promocode.count == 7 {
                        handlePromoCode()
                        delegate?.switchToDriver(body: body)
                    } else {
                        promocodeNumber.setError(NSError(domain: "Number have to consist 7-digits", code: 1, userInfo: nil), animated: true)
                        print("Error promo: \(promocodeNumber.error)")
                    }
                } else {
                    delegate?.switchToDriver(body: body)
                }
            } else {
                if promocode != "" {
                    if promocode.count == 7 {
                        handlePromoCode()
                        delegate?.editProfile(body: body)
                    } else {
                        promocodeNumber.setError(NSError(domain: "Number have to consist 7-digits", code: 1, userInfo: nil), animated: true)
                        print("Error promo: \(promocodeNumber.error)")
                    }
                } else {
                    delegate?.editProfile(body: body)
                }
            }
        }
    }

    @objc func handlePromoCode() {
        if let promo = promocodeNumber.text, let token = UserDefaults.standard.string(forKey: "token") {
            let body : Parameters = ["token" : token, "promo_code" : promo]
            Alamofire.request(Constant.api.add_promo_code, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if let json = response.result.value, let jsonData = JSON(json).dictionaryObject as [String: Any]?, let statusCode = jsonData["statusCode "] as? Int {
                    print("Promocode: \(jsonData)")
                }
            })
        }
    }
    
    func setupViews() {
        contentView.isUserInteractionEnabled = false
        
        addSubview(profileImage)
        addSubview(surnameTextField)
        addSubview(nameTextField)
        addSubview(patronymicTextField)
        addSubview(cityTextField)
        addSubview(carMark)
        addSubview(carModel)
        addSubview(carYear)
        addSubview(carColor)
        addSubview(gosNumber)
        addSubview(promocodeNumber)
        
        if let isDriverWas = user?.driver_was {
//            if isDriverWas == 0 {
//                addSubview(idCardImageView)
//                idCardImageView.addSubview(idCardImageLabel)
//                addSubview(idCardImageView2)
//                idCardImageView2.addSubview(idCardImageLabel2)
//                addSubview(techPassportImageView)
//                techPassportImageView.addSubview(techPassportImageLabel)
//                addSubview(techPassportImageView2)
//                techPassportImageView2.addSubview(techPassportImageLabel2)
//                addSubview(pravaImageView)
//                pravaImageView.addSubview(pravaImageLabel)
//                addSubview(pravaImageView2)
//                pravaImageView2.addSubview(pravaImageLabel2)
//                addSubview(carImageView)
//                carImageView.addSubview(carImageLabel)
//                addSubview(carImageView2)
//                carImageView2.addSubview(carImageLabel2)
//            }
//
//            addSubview(addSpecialEq)
            addSubview(continueButton)
            
            profileImage.snp.makeConstraints { (make) in
                make.top.equalTo(30)
                make.centerX.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            
            surnameTextField.snp.makeConstraints { (make) in
                make.top.equalTo(profileImage.snp.bottom).offset(50)
                make.left.equalTo(60)
                make.right.equalTo(-60)
            }
            
            nameTextField.snp.makeConstraints { (make) in
                make.top.equalTo(surnameTextField.snp.bottom).offset(10)
                make.left.equalTo(60)
                make.right.equalTo(-60)
            }
            
            patronymicTextField.snp.makeConstraints { (make) in
                make.top.equalTo(nameTextField.snp.bottom).offset(10)
                make.left.equalTo(60)
                make.right.equalTo(-60)
            }
            
            cityTextField.snp.makeConstraints { (make) in
                make.top.equalTo(patronymicTextField.snp.bottom).offset(10)
                make.left.equalTo(60)
                make.right.equalTo(-60)
            }
            
            carMark.snp.makeConstraints { (make) in
                make.top.equalTo(cityTextField.snp.bottom).offset(10)
                make.left.equalTo(60)
                make.right.equalTo(-60)
                make.height.equalTo(cityTextField.snp.height)
            }
            
            carModel.snp.makeConstraints { (make) in
                make.top.equalTo(carMark.snp.bottom).offset(10)
                make.left.equalTo(60)
                make.right.equalTo(-60)
                make.height.equalTo(carMark)
            }
            
            carYear.snp.makeConstraints { (make) in
                make.top.equalTo(carModel.snp.bottom).offset(10)
                make.left.equalTo(60)
                make.right.equalTo(-60)
                make.height.equalTo(carModel)
            }
            
            carColor.snp.makeConstraints { (make) in
                make.top.equalTo(carYear.snp.bottom).offset(10)
                make.left.equalTo(60)
                make.right.equalTo(-60)
                make.height.equalTo(carYear)
            }
            
            gosNumber.snp.makeConstraints { (make) in
                make.top.equalTo(carColor.snp.bottom).offset(10)
                make.left.equalTo(60)
                make.right.equalTo(-60)
            }

            promocodeNumber.snp.makeConstraints { (promocodeNumber) in
                promocodeNumber.top.equalTo(gosNumber.snp_bottomMargin).offset(10)
                promocodeNumber.left.right.equalTo(gosNumber)
            }
            
            continueButton.snp.makeConstraints { (make) in
                make.top.equalTo(promocodeNumber.snp.bottom).offset(10)
                make.left.equalTo(65)
                make.right.equalTo(-65)
                make.height.equalTo(45)
            }
            
            /*if isDriverWas == 0 {
                idCardImageView.snp.makeConstraints { (make) in
                    make.top.equalTo(gosNumber.snp.bottom).offset(10)
                    make.left.equalTo(gosNumber)
                    make.right.equalTo(gosNumber.snp.centerX).offset(-2)
                    make.height.equalTo(90)
                }
                
                idCardImageLabel.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.left.equalTo(5)
                    make.right.equalTo(-5)
                }
                
                idCardImageView2.snp.makeConstraints { (make) in
                    make.top.equalTo(gosNumber.snp.bottom).offset(10)
                    make.left.equalTo(gosNumber.snp.centerX).offset(2)
                    make.right.equalTo(gosNumber)
                    make.height.equalTo(90)
                }
                
                idCardImageLabel2.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.left.equalTo(5)
                    make.right.equalTo(-5)
                }
                
                techPassportImageView.snp.makeConstraints { (make) in
                    make.top.equalTo(idCardImageView.snp.bottom).offset(4)
                    make.left.equalTo(idCardImageView)
                    make.right.equalTo(idCardImageView)
                    make.height.equalTo(90)
                }
                
                techPassportImageLabel.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.left.equalTo(5)
                    make.right.equalTo(-5)
                }
                
                techPassportImageView2.snp.makeConstraints { (make) in
                    make.top.equalTo(techPassportImageView)
                    make.left.equalTo(idCardImageView2)
                    make.right.equalTo(idCardImageView2)
                    make.height.equalTo(90)
                }
                
                techPassportImageLabel2.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.left.equalTo(5)
                    make.right.equalTo(-5)
                }
                
                pravaImageView.snp.makeConstraints { (make) in
                    make.top.equalTo(techPassportImageView.snp.bottom).offset(4)
                    make.left.equalTo(techPassportImageView)
                    make.right.equalTo(techPassportImageView)
                    make.height.equalTo(90)
                }
                
                pravaImageLabel.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.left.equalTo(5)
                    make.right.equalTo(-5)
                }
                
                pravaImageView2.snp.makeConstraints { (make) in
                    make.top.equalTo(pravaImageView)
                    make.left.equalTo(techPassportImageView2)
                    make.right.equalTo(techPassportImageView2)
                    make.height.equalTo(90)
                }
                
                pravaImageLabel2.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.left.equalTo(5)
                    make.right.equalTo(-5)
                }
                
                carImageView.snp.makeConstraints { (make) in
                    make.top.equalTo(pravaImageView.snp.bottom).offset(4)
                    make.left.equalTo(pravaImageView)
                    make.right.equalTo(pravaImageView)
                    make.height.equalTo(90)
                }
                
                carImageLabel.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.left.equalTo(5)
                    make.right.equalTo(-5)
                }
                
                carImageView2.snp.makeConstraints { (make) in
                    make.top.equalTo(carImageView)
                    make.left.equalTo(pravaImageView2)
                    make.right.equalTo(pravaImageView2)
                    make.height.equalTo(90)
                }
                
                carImageLabel2.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.left.equalTo(5)
                    make.right.equalTo(-5)
                }
                
                addSpecialEq.snp.makeConstraints { (make) in
                    make.top.equalTo(carImageView.snp.bottom).offset(20)
                    make.left.equalTo(65)
                    make.right.equalTo(-65)
                    make.height.equalTo(45)
                }
                
                continueButton.snp.makeConstraints { (make) in
                    make.top.equalTo(addSpecialEq.snp.bottom).offset(10)
                    make.left.equalTo(65)
                    make.right.equalTo(-65)
                    make.height.equalTo(45)
                }
            } else {
                addSpecialEq.snp.makeConstraints { (make) in
                    make.top.equalTo(gosNumber.snp.bottom).offset(20)
                    make.left.equalTo(65)
                    make.right.equalTo(-65)
                    make.height.equalTo(45)
                }
                
                continueButton.snp.makeConstraints { (make) in
                    make.top.equalTo(addSpecialEq.snp.bottom).offset(10)
                    make.left.equalTo(65)
                    make.right.equalTo(-65)
                    make.height.equalTo(45)
                }
            }*/
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        carMark.tag = 1
        carMark.delegate = self
        carModel.tag = 2
        carModel.delegate = self
        carModel.isEnabled = false
        carYear.tag = 3
        carYear.delegate = self
        carColor.tag = 4
        carColor.delegate = self
        cityTextField.tag = 5
        cityTextField.delegate = self
        
        CarMark.getCarMarks { (carMarks) in
            self.indicator.show(withStatus: "Loading...")
            self.carMarks = carMarks
            self.indicator.dismiss()
        }
        
        for year in 1995..<2019 {
            carYears.append("\(year)")
        }
        
        CarColor.getCarColors { (carColors) in
            self.indicator.show(withStatus: "Loading...")
            self.carColors = carColors
            self.indicator.dismiss()
        }
        
        City.getCities { (cities) in
            self.indicator.show(withStatus: "Loading...")
            self.cities = cities
            self.indicator.dismiss()
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            textField.inputView = datePicker
        } else if textField.tag == 1 {
            textField.inputView = carMarkPicker
        } else if textField.tag == 2 {
            textField.inputView = carModelPicker
        } else if textField.tag == 3 {
            textField.inputView = carYearPicker
        } else if textField.tag == 4 {
            textField.inputView = carColorPicker
        } else if textField.tag == 5 {
            textField.inputView = cityPicker
        }
    }
    
    let formatter = DateFormatter()
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            formatter.dateFormat = "dd.MM.yyyy"
            textField.text = formatter.string(from: datePicker.date)
        } else if textField.tag == 1 {
            let id = carMarkID
            CarModel.getCarModel(id: id, completion: { (carModels) in
                self.indicator.show(withStatus: "Loading...")
                self.carModels.removeAll()
                self.carModels = carModels
                self.indicator.dismiss()
                self.carModel.isEnabled = true
            })
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return carMarks.count
        } else if pickerView.tag == 1 {
            return carModels.count
        } else if pickerView.tag == 2 {
            return carYears.count
        } else if pickerView.tag == 3 {
            return carColors.count
        } else if pickerView.tag == 4 {
            return cities.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return carMarks[row].name
        } else if pickerView.tag == 1 {
            return carModels[row].name
        } else if pickerView.tag == 2 {
            return "\(carYears[row])"
        } else if pickerView.tag == 3 {
            return carColors[row].name_en
        } else if pickerView.tag == 4 {
            return cities[row].name
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            carMark.text = carMarks[row].name
            carMarkID = carMarks[row].id!
        } else if pickerView.tag == 1 {
            carModel.text = carModels[row].name
            carModelID = carModels[row].id!
        } else if pickerView.tag == 2 {
            carYear.text = carYears[row]
            year = Int(carYears[row])!
        } else if pickerView.tag == 3 {
            carColor.text = carColors[row].name_en
            colorID = carColors[row].id!
        } else if pickerView.tag == 4 {
            cityTextField.text = cities[row].name
            cityID = cities[row].id!
        }
    }
}
