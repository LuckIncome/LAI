//
//  ConfidentialViewController.swift
//  BidKab
//
//  Created by Nursultan on 08.01.2019.
//  Copyright © 2019 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseMessaging
import Firebase

class ConfidentialViewController: UIViewController {

    var delegate: ConfidentialAnswer?
//    let accountKit = AKFAccountKit(responseType: .accessToken)
    var phone: String?

    lazy var informationTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textView.isEditable = false
        textView.textAlignment = .justified
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = "Privacy policy\n\nThis Privacy Policy (hereinafter referred to as the <Policy>) defines the main principles, objectives, general conditions and methods for processing personal data, implemented measures to protect personal data, the list of subjects of personal data processed by the Operator, the Operator's functions, the rights of personal data subjects in use Service BIDKAB (further - Service).\nThe policy is an appendix to the License Agreement (the Public Offer) (hereinafter - the License Agreement) and regulates the terms of confidentiality and processing of personal data between the Service and Users during the use of the Service. All terms and conditions defined in the License Agreement are applicable and have a similar meaning in this Privacy Policy.\nUsing the Service, the User agrees with this Policy. Acceptance of the terms of the Policy by the User is expressly expressed, subject, certain and non-abstract consent of the User to the processing of personal data by the Operator.\n\n1. Concepts and terms\n\n1.1. Terms and terms used in this Policy:\na. Operator - Administration, legal or natural person, independently or jointly with other persons, organizing and (or) carrying out the processing of personal data, as well as determining the purposes of processing personal data, the composition of personal data to be processed, the actions (operations) performed with personal data ;\nb. personal data processing - any action (operation) or a set of actions (operations) performed using automation tools or without using such tools with personal data, including collection, recording, systematization, accumulation, storage, updating (updating, modification), extraction, use, transfer (distribution, provision, access), depersonalization, blocking, deletion, destruction of personal data;\nc. personal data - any information relating directly or indirectly to a certain or determined individual (subject of personal data):\n\n- information that the User provides about himself when registering (creating an account) and using the Service. Mandatory information for the provision of services by the Operator is marked in a special way. Other information is provided by the User at its discretion;\n\n- Data that is automatically available to the Operator during access to and direct use of the Service, including but not limited to: data on the identification of the User's browser (or other program through which the User accesses the Service, the order in which the User visits the pages, the time and date of connection and access of the User to the Service, IP-address, cookies data, the model of the mobile device used by the User, data on the location of the User provided by geolo- the technical characteristics of the equipment and software used by the User and other similar information;\n\n- other information about the User that becomes available to the Operator in the process of providing the User with services by the Operator, including information received from third parties.\n\nd. the subject of personal data is the User of the Service who provides personal data to the Operator and in respect of which the Operator processes personal data.\n\n2. General Provisions\n\n2.1. If you do not agree with this Policy as well as the terms and conditions of the License Agreement and the Terms of Use of the Service, do not want to comply with them, do not install the mobile application, immediately remove it / any of its components from your mobile phone or computer and do not use the mobile application. In the event that for any reason you do not agree with the terms below, this means your obligation to remove the Service from your mobile device or computer and to not use the Service inDriver. Otherwise, you will be considered to agree unconditionally with the terms of this Policy.\n2.2. This Policy applies to all subjects of personal data that provide personal data to the Operator, and in respect of which the Operator carries out the processing of personal data. The requirements of the Policy are also taken into account and made against other persons if they need to participate in the process of processing personal data by the Operator, as well as in cases of personal data transfer to them in accordance with the established procedure on the basis of agreements, contracts, processing orders.\n2.3. The operator, proceeding from the principles of reasonableness and conscientiousness, assumes that:\n2.3.1. The user carefully read the terms of this Service Policy and other official documents of the Service before using the Service;\n2.3.2. Having started using the Service, he expressed his consent to the terms of this Policy and assumed the rights and duties indicated in it;\n2.3.3. The User understands and understands that in the process of using the Service, information posted by the User about himself may be available to other Users of the Service, while the Operator is not responsible for the actions of third parties.\n2.4. This Policy is an open and public document, valid for an indefinite period (or until it is approved in a new version) and provides for the possibility of acquaintance of any persons with it. The policy can be changed and / or supplemented unilaterally by the Service Administrator without any special notification (consent) of the subjects of personal data. The current version of the Policy is available on the Internet at: http://biddriver.com/,\n2.5. Changes and additions take effect on the day after the posting of the new version of the Policy on the Internet at:, https: //biddriver.com/\n2.6. Users are required to regularly check the terms of this Policy for changes and / or additions. Continuation of the use of the Service after making changes and / or additions to this Policy will mean acceptance and consent of the User with such changes and / or additions.\n2.7. In the event of a contradiction or inconsistency between the text of the Service Agreement and this Policy, the Policy shall apply.\n2.8. In accordance with Art. 22 of the Federal Law No. 152-FZ of July 27, 2006 <On Personal Data> The operator has the right to process personal data of Users without notifying the authorized body for the protection of the rights of subjects of personal data.\n2.9. The administrator is the operator for the processing of personal data, except for cases when the functions for the processing of personal data are transferred to another person on the basis of a contract concluded with such a person. The processing of personal data can be carried out by the Administrator together with another operator for the processing of personal data. The administrator has the right to transfer the functions of processing personal data to another person also with respect to certain categories of personal data subjects, the list of which is defined in this Policy.\n\n- other information about the User that becomes available to the Operator in the process of providing the User with services by the Operator, including information received from third parties.\n\nd. the subject of personal data is the User of the Service who provides personal data to the Operator and in respect of which the Operator processes personal data.\n\n3. Subjects of personal data\n\n3.1. We handle the following personal persons:\n\n3.1.1. Service Users;\n\n4. Objectives of Information Processing\n\n4.1. The operator collects and stores only that personal information that is necessary to provide services to the User, which are requested by the User, including for the execution of agreements with Users, except for cases when the legislation provides for mandatory storage of personal (personal) information during a period determined by law.\n\n4.2. The operator performs processing of personal data in order to:\n4.2.1. Conclusion, execution and termination by the Administrator of the License Agreement with the User, as well as for the Administrator to fulfill the obligations to provide the User with access to the Service within the framework of the License Agreement (Public Offer) accepted by the latter;\n4.2.2. Carrying out by the Operator of its legitimate rights and interests in the course of its activities to provide access to the Service, including for administrative purposes, for example, for internal investigations in violation of the License Agreement (Public Offer) and this Policy.\n4.2.3. Execution of judicial acts, acts of other bodies or officials subject to enforcement in accordance with the legislation of the Russian Federation;\n4.2.4. Ensuring the security of Users;\n4.2.5. For other legitimate purposes.\n\n5. Principles and conditions for the processing of personal data\n\n5.1. Processing of personal data is based on the following principles:\n- legality and justice;\n- concreteness;\n- good faith;\n- Inadmissibility of combining databases containing personal data, processing of which is carried out for purposes incompatible with each other.\n\n5.2. Conditions for processing personal (personal) information:\n- when processing the User's personal data, the Operator is guided by the Federal Law of the Russian Federation <On Personal Data>;\n- the processing of the User's personal data is carried out in accordance with the Licensing Agreement of the Administration and this Privacy Policy;\n- in respect of personal data of information, its confidentiality remains, unless the provision of information about the User is carried out for the execution of the agreement with the User;\n- in respect of personal data, its integrity and accessibility for the proper provision of services by the Operator also remain;\n5.2.1. The transfer by the Operator of the User's personal (personal) information to third parties is carried out in the following cases:\n- in connection with the fulfillment of obligations to the User for the provision of services within the Service, and also for the purpose of executing various agreements or contracts with the User;\n- the transfer is necessary at the request of law enforcement agencies and courts in connection with their activities within their competence, in accordance with the legislation of the Russian Federation;\n- to respond to users' requests for support;\n- in order to protect the legal rights and interests of the Operator and / or third parties, including when the User violates the License Agreement (Public Offer) or other applicable documents (contracts, agreements, rules) of the Service;\n- if the management system changes in the company, including mergers, acquisitions or acquisitions of the entire property of the company or a significant part of it;\n- in accordance with your express prior authorization. In order to avoid misunderstandings, the company may transfer and disclose impersonal information to third parties for conducting research, performing works or providing services on behalf of the Operator;\n-. transfer of impersonal statistical information for research purposes, including marketing and advertising;\n- in other cases provided for by the legislation of the Russian Federation;\n- if there is a sale or other alienation of the Service.\n\n6. List of processed personal data\n\n6.1. In relation to Users:\n6.1.1. With the purpose of the subsequent conclusion by the Administrator of the License Agreement with Users when using and when authorizing the Service, when installing the User on the mobile device of the Service, personal data may be requested that may include the following data of the Users: e-mail address, full name, date of birth, age, sex, location (city), mobile phone number, vehicle data (state number, car make and model, year of issue ska car, car color), identity document, driver's license, and additional information may be requested.\nWith the help of Service servers, information about the User's activity on the Service is stored. The service collects and stores data in the form of information about the provided Services on access to the functionality of the Service, as well as information about them. Personal information and personal data may include some information that is not directly provided by Users, because the Service records information related to the order of access to the Service.\n\nDespite the above provisions, the Service has the right to collect the following information:\n- information about the mobile device of the User (model, operating system version, unique device identifiers, as well as mobile network data and phone number);\n- log information containing information about the use of the Service or viewing content provided through the Service (including but not limited to details of the use of the Service, including search queries, phone call data, including phone numbers for incoming, outgoing and forwarded calls, date, time, type and duration of calls, as well as information about the SMS route, IP-addresses, data about hardware events, including about failures and actions in the system, as well as about the settings, type and language of the browser ra, the date and time of the request, and the referral URL);\n- location information (including GPS data sent by the mobile device, data from various coordinate determination technologies).\n6.2. In respect of other subjects of personal data:\n6.2.1. The list of personal data processed by the Operator in relation to other subjects of personal data is determined in accordance with the legislation of the Russian Federation and local acts of the Operator, taking into account the purposes of processing personal data specified in section 4 of the Policy.\n6.3. Processing of special categories of personal data relating to race, nationality, political views, religious or philosophical beliefs, health status, or the private life of Users is not exercised by the Operator.\n7. Processing of personal data\n\n7.1. Personal data processing is understood as any action (operation) or set of actions (operations) performed using automation tools or without using such means with personal data, including collection, recording, systematization, accumulation, storage, updating (updating, modification), extraction , use, transfer (distribution, provision, access), depersonalization, blocking, deletion, destruction of personal data.\n7.2. The processing of the User's personal data is carried out in accordance with the purposes, conditions and principles defined by this Policy, the local acts of the Operator, and in some cases also in accordance with the License Agreement.\n7.3. Processing of personal data in the Operator is carried out with the consent of the subject of personal data to the processing of his personal data, unless otherwise provided by the legislation of the Russian Federation in the field of personal data.\n7.4. In accordance with the terms of the License Agreement, as well as in accordance with clause 5 Part 1 of Art. 6 of the Federal Law No. 152-FZ of July 27, 2006 <On Personal Data>, the User's separate written consent to the processing of his personal data is not required.\n7.5. The processing of personal data of a personal data subject is carried out in strict accordance with the legislation of the Russian Federation, including in accordance with the legislation in the field of processing and protection of personal data, as well as legislation in the field of information and information technology.\n7.6. Processing of personal data is carried out in an automated mode, i.e. with the use of computer facilities, except when manual processing of personal data is necessary in connection with the implementation of legal requirements. Processing of personal data can be carried out in a mixed way.\n7.7. Information received by the Operator from the User, including information received in automatic mode when the User accesses the Service is confidential, except for cases of voluntary provision by the User of information about himself for general access to an unlimited number of persons.\n7.8. The operator collects, records, systemizes, accumulates, stores, updates (updates, changes), retrieves, uses, transfers (distributes, provides, accesses), depersonalizes, blocks, deletes and destroys personal data of personal data subjects.\n7.9. The Operator has the right to destroy the User's personal data in cases of violation by the User of the terms of this Policy and / or the License Agreement or other applicable documents (contracts, agreements, rules) of the Service.\n7.10. In cases stipulated by the legislation of the Russian Federation, the Operator has the right and / or the obligation to store information and impersonal personal data of the personal data subject during the period specified by law and to transmit such information at the request of authorized state authorities of the Russian Federation.\n7.11. The operator stores your information as long as your account remains active, unless you are prompted to delete your information or account. In some cases, the Operator may store certain information about you in accordance with legal requirements or for other purposes described in this section, even if your account is deleted.\n\nSubject to the following exceptions, the Operator Company deletes or impersonates your information on your request.\n\nDeletion of the account of the User is carried out by his written application, sent to the details specified in section 11 of the Offer.\n\nThe operator can store information after the account is deleted in the following cases:\n\n- if there is an outstanding dispute in connection with your account;\n\n- if required by law, as well as in aggregated or impersonal form;\n\nThe operator can also store certain information if necessary to protect its legitimate business interests, such as preventing fraud and ensuring the safety and security of\n\n8. Cookies\n\n8.1. While you use the Service with a mobile application, the Operator can use industry-wide technology called <cookies>, which allows you to store certain information on your phone. Cookies allow you to automatically log in to the application: registered users will be identified automatically. Most phones have the function of clearing the computer of cookies, blocking their reception or sending a notification each time before storing a similar file. However, after blocking or deleting cookies, your opportunities in interactive activities may be limited.\n8.2. Cookies files provided by the Operator to the equipment and software of the User may be used by the Operator to provide personalized services, to send advertising to the target audience, for statistical and research purposes, and to improve the quality of the Operator's services.\n\n9. Rights of subjects of personal data\n\n9.1. The subject of personal data has the right to withdraw consent to the processing of personal data by sending the relevant request to the Operator for the details specified in section 11 of this Policy.\n9.2. The subject of personal data has the right to receive information concerning the processing of his personal data on the basis of a request, the form and requirements to which are established by the legislation of the Russian Federation. The request must contain information provided for by the Federal Law of the Russian Federation No. 152-FZ of July 27, 2006 <On Personal Data>.\n9.3. The subject of personal data has the right to demand from the Operator the specification of his personal data, their blocking or destruction in the event that personal data are incomplete, outdated, inaccurate, illegally obtained or are not necessary for the stated purpose of processing.\n9.3.1. The user has the right to independently change, clarify or delete his personal data and other information, taking into account the available functionality of the Service, including in the Personal Area.\n\n10. Measures taken to protect information\n\n10.1. The operator takes the necessary legal, technical and organizational measures to protect the User's personal information from unauthorized or accidental access to them, destruction, modification, blocking, copying, distribution, as well as other illegal actions. Such measures include:\n- Appointment of persons responsible for the organization of processing and ensuring the security of personal data;\n- publication of local acts and other documents in the field of processing and protection of personal data, familiarization with such documents of the Operator's employees;\n- obtaining consent of the subjects of personal data for the processing of their personal data, except for cases stipulated by the legislation of the Russian Federation;\n- restriction and delimitation of access of employees and other persons to personal data and processing facilities, monitoring of actions with personal data;\n- Separating personal data processed without using automation tools, from other information, in particular by fixing them on separate material carriers of personal data, in special sections;\n- provision of separate storage of personal data and their material carriers, processing of which is carried out for different purposes and which contain different categories of personal data;\n- security of premises and facilities, access, security, video surveillance;\n- storage of material carriers of personal data in compliance with the conditions ensuring the safety of personal data and excluding unauthorized access to them;\n- the use of security equipment (including antivirus and other technical means in accordance with the legislation of the Russian Federation);\n- backup information for recovery;\n- other measures provided for by the legislation of the Russian Federation in the field of personal data.\n\n11. Restricting the Effect of the Policy\n\n11.1. The Operator is not liable for the actions of Users and third parties who, as a result of using the Service, have access to information about the User and the consequences of using, distributing and performing other actions with respect to such information, access to which, due to the features of the Service, is available to any Internet user and the Service .\n\n12. Other provisions\n\n12.1. Subjects of personal data send inquiries, notifications to the e-mail address:\n __________________________________________\n12.2. The operator responds to requests of subjects of personal data within 30 calendar days from the moment of their receipt."
        return textView
    }()

    lazy var disagreeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle(.localizedString(key: "disagree"), for: .normal)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.tag = 0
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    lazy var agreeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle(.localizedString(key: "agree"), for: .normal)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.tag = 1
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = .localizedString(key: "policy")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    @objc private func buttonPressed(button: UIButton){
        switch button.tag {
        case 0:
//            delegate?.confidentialReceive(isAccepted: false)
            exit(0)
            break
        case 1:
//            delegate?.confidentialReceive(isAccepted: true)
//            confirmPhoneNumber()
            self.present(UINavigationController(rootViewController: LoginViewController()), animated: true, completion: nil)
            break
        default:
            break
        }
        self.navigationController?.popViewController(animated: true)
    }

//    private func confirmPhoneNumber(){
//        let akfPhoneNumber = AKFPhoneNumber(countryCode: "+234", phoneNumber: String())
//        let inputState = UUID().uuidString
//        let controller = accountKit.viewControllerForPhoneLogin(with: akfPhoneNumber, state: inputState)
//        controller.delegate = self
//        controller.isEditing = false
//        controller.setAdvancedUIManager(MyUIManager())
//        self.present(controller, animated: true, completion: nil)
//    }

//    private func getVerifiedPhoneNumber(){
//        accountKit.requestAccount { (account, error) in
//            if error != nil {
//                return
//            } else {
//                if let phoneInfo = account?.phoneNumber {
//                    self.phone = phoneInfo.countryCode + phoneInfo.phoneNumber
//                    self.moveToNext()
//                }
//            }
//        }
//    }

    func moveToNext(){
        if let phone = phone {
            SVProgressHUD.show()
            User.authUser(body: ["phone" : phone.removingWhitespaces()], completion: { (result, user, statusCode) in
                if let token = user.token {
                    Messaging.messaging().subscribe(toTopic: "/topics/\(token)")
                }
                print(statusCode)
                SVProgressHUD.dismiss()
                if statusCode == Constant.statusCode.notFound {
                    let regController = RegisterViewController()
                    regController.phone = phone
                    self.navigationController?.pushViewController(regController, animated: true)
                } else {
                    print("Logged in")
                    UserDefaults.standard.set(phone, forKey: "phoneNumber")
                    let navController = UINavigationController(rootViewController: HomeViewController())
                    let leftController = LeftMenuController()
                    leftController.user = user
                    let slideController = SWRevealViewController(rearViewController: leftController, frontViewController: navController)
                    UIApplication.shared.keyWindow?.rootViewController = slideController
                    self.dismiss(animated: true) {
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    }
                }
            })
        }
    }

    private func setupViews(){
        view.addSubview(disagreeButton)
        disagreeButton.snp.makeConstraints { (disagreeButton) in
            disagreeButton.left.equalToSuperview().offset(20)
            disagreeButton.bottom.equalToSuperview().offset(-20)
            disagreeButton.right.equalTo(view.snp.centerX).offset(-10)
            disagreeButton.height.equalTo(40)
        }
        view.addSubview(agreeButton)
        agreeButton.snp.makeConstraints { (agreeButton) in
            agreeButton.right.equalToSuperview().offset(-20)
            agreeButton.height.bottom.equalTo(disagreeButton)
            agreeButton.left.equalTo(view.snp.centerX).offset(10)
        }
        view.addSubview(informationTextView)
        informationTextView.snp.makeConstraints { (informationTextView) in
            informationTextView.top.left.right.equalToSuperview()
            informationTextView.bottom.equalTo(agreeButton.snp.top).offset(-10)
        }
    }
}

//extension ConfidentialViewController: AKFViewControllerDelegate {
//    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
//        getVerifiedPhoneNumber()
//    }
//    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
//        print("AKF error: \(error.localizedDescription)")
//    }
//}
