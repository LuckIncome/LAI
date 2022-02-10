//
//  Extentions.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/8/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SVProgressHUD
import SwiftyJSON
import GoogleMaps
import FirebaseMessaging

let kz_dictionary = [
    
    "free_tech": "Бос тех.",
    "free_moto": "Бос мото",
    
    "back": "Артқа",
    "smsCode": "СМС-код",
    "ready": "Дайын",
    
    "wait": "Күте тұрыңыз...",
    "wentWrong": "Белгісіз қате туындады",
    
    "enterInfo": "Мәліметтерді енгізіңіз",
    
    "smsSent": "СМС сіздің нөміріңізге жіберілді",
    "enterSMSCode": "СМС-кодты енгізіңіз",
    "sum": "Қажетті сомма",
    "insufficientMoney": "Қаражат жеткіліксіз",
    "balanceUnder100": "Қаражат 100 тг төмен болмауы керек",
    
    "from" : "Қайдан",
    "to" : "Қайда",
    "price" : "Сіздің бағаңыз",
    "passengers_count" : "Жолаушылар саны",
    "take_traveler" : "Жолдас-сапаршы",
    "bonus" : "Бонус",
    "order" : "Тапсырыс жасау",
    "create" : "Құру",
    "city" : "Такси",
    "history" : "Тарих",
    "intercity" : "Қалааралық",
    "toi_taxi" : "VIP такси",
    "special_eqipment" : "Арнайы техника",
    "cargo" : "Жүк автомобилі",
    "contactUs": "Бізге жазу",
    "moto": "Мотолюбитель",
    "find_friends" : "Ата-аналық бақылау",
    "promocode" : "Бонус алу",
    "notifications" : "Хабарламалар",
    "depositLimitMessage": "Сізде 100 теңгеден аз ақша болмауы керек",
    "help" : "Көмек",
    "driver_mode" : "Жүргізуші режимі",
    "profile" : "Профиль",
    "date" : "Шығу күні мен уақыты",
    "my_orders" : "Менің брондауым",
    "cancel_order" : "Тапсырысты болдырмау",
    "offers" : "Ұсыныстар",
    "note" : "Пікірлер",
    "document" : "Құжат",
    "torg" : "Сауда-саттық",
    "phone_number" : "Телефон нөмірі",
    "send" : "Жіберу",
    "enter_promocode" : "Промокодты жазыңыз",
    "add" : "Қосу",
    "share" : "Бөлісу",
    "surname" : "Тегі",
    "name" : "Аты",
    "authCode": "Сізге авторизация коды жіберілді",
    "transfer": "Аудару",
    "withdraw": "Шығарып алу",
    
    "myAuto": "Менің автом",
    "myOrders": "Менің тапсырыстарым",
    
    "middle_name" : "Әкесінің аты",
    "car_mark" : "Көліктің маркасы",
    "car_model" : "Көліктің моделі",
    "car_year" : "Көліктің жылы",
    "car_color" : "Көліктің түсі",
    "gos_number" : "Мемлекеттік нөмір",
    "iin" : "ЖСН",
    "id_card_number" : "Жеке куәлік нөмірі",
    "id_card_date" : "Жеке куәліктің берілген куні",
    "tech_passport_number" : "Техникалық паспорттың нөмері",
    "id_card_photo" : "Жеке куәліктің суреті (алды)",
    "id_card_photo2" : "Жеке куәліктің суреті (арты)",
    "tech_passport_photo" : "Техникалық паспорттың суреті (алды)",
    "tech_passport_photo2" : "Техникалық паспорттың суреті (арты)",
    "prava_photo" : "Жүргізуші кұжатының суреті (алды)",
    "prava_photo2" : "Жүргізуші кұжатының суреті (арты)",
    "car_photo" : "Көліктің суреті (алды)",
    "car_photo2" : "Көліктің суреті (арты)",
    "add_car" : "Көлік қосу",
    "continue" : "Жалғастыру",
    "minute" : "мин",
    "save" : "Сақтау",
    "choose_language" : "Тілді таңдаңыз",
    "cancel" : "Болдырмау",
    "busy" : "Бос емес",
    "accept_order" : "Тапсырысты қабылдау",
    "repeat" : "Қайталау",
    "reverse" : "Кері бағытта",
    "choose_action" : "Әрекетті таңдаңыз",
    "cargo_note" : "Көлік жүргізудің күні, уақыты, көлемі және түрі (жүргізушіге нақты ақпарат беріңіз)",
    "send_request" : "Өтініш жіберу",
    "promo_text_1" : "Сәлем! Arzan Taksi мобильді қосымшасынан менің ",
    "promo_text_2" : " промокодымды  пайдалана отырып, тегін жол жүру үшін бонус немесе бірлік ал! Жүктеу:",
    "edit_profile" : "Профильді өңдеу",
    "add_cargo" : "Жүк көлігін қосу",
    "add_spec" : "Арнайы көлік қосу",
    "add_toi" : "Той такси қосу",
    "toi_price" : "Бағасы",
    "promo_label" : "Жүргізушілер мен жол жүрушілерге артықшылығымыз: Осы қосымшаны жүктеп және достарыңызды шақыру арқылы тегін жол жүруге арналған бонустар мен бірліктерге қол жеткіз!",
    "driver_online" : "Онлайн",
    "driver_online_text" : "Жүргізуші режимінің барлық функционалына 8 сағатқа мүмкіндік алу үшін 20₸ төлеуге келісезібе?",
    "yes" : "Иә",
    "no" : "Жоқ",
    "desc" : "Сипаттама",
    "comment" : "Пікір",
    "complaint" : "Шағымдар мен ұсыныстар үшін",
    "end_order" : "Тапсырысты аяқтау",
    "friend_label" : "Достарды бақылау",
    "friend_position": "Friend Position",
    "friend_text" : "сіздің орналасқан жеріңіздi көру үшін сізді дос ретінде қосқысы келеді, өтінімді қабылдайсыз ба?",
    "fill_all" : "Барлық жолдарды толтырыңыз және барлық фотосуреттерді таңдаңыз",
    "doc_yes" : "Құжаттармен",
    "doc_no" : "Құжаттарсыз",
    "torg_yes" : "Сауда-саттық",
    "torg_no" : "Сауда-саттықсыз",
    "orders" : "Тапсырыстар",
    "new_tex": "Жаңа техника",
    "my_tex" : "Техникаларым",
    "user_orders" : "Тапсырыс беру",
    "free_auto": "Тапсырыстар тізімі",
    "user_my_orders" : "Менің тапсырыстарым",
    "feedback_label" : "Сапарды бағалаңыз",
    "feedback_label_2" : "Сіздің бағалауыңыз қызмет көрсету сапасын жақсартады",
    "close" : "Аяқтау",
    "promo_main" : "Промо-кодты достарыңызбен бөлісіңіз",
    "driver_arrived" : "Жеттім",
    "client_out" : "Жолаушы шығып келе жатыр",
    "notif_driver" : "Жолаушыға хабарландыру жіберілді",
    "woman": "Lady-жүргізуші",
    "invalid": "Продукт",
    "fields": "Барлық жерді толтырыңыз!",
    "balanceCard": "Балансты картамен толтыру",
    "balanceSMS": "Балансты СМС-пен толтыру",
    "balanceUnits": "Балансты моб. байланыс бірліктері ретінде шығару",
    "balanceUser": "Балансты басқа қолданушыға аудару",
    "balanceKassa24": "Балансты Касса24 арқылы толтыру",
    "balanceQiwi": "Балансты Qiwi арқылы толтыру",
    "pay": "Төлеу",
    "amount": "Ақша мөлшері",
    "error": "Қате!",
    "success": "Сәтті!",
    "notPaid":"Не оплачено",
    "free":"Бос",
    "accept": "Кабылдау",
    "addPhotos" : "Суреттерді қосу",
    "offer_price": "Баға ұсыну",
    "getYourPrice": "Өз бағаңызды ұсыныңыз",
    "skip": "Өткізіп жіберу",
    "next": "Келесі",
    "start": "Бастау"
]

let ru_dictionary = [
    "back": "Назад",
    "smsCode": "СМС-код",
    "ready": "Готово",
    
    "free_tech": "Свободная тех.",
    "free_moto": "Свободное мото",
    
    "enterInfo": "Введите данные",
    
    "wait": "Подождите...",
    
    "from" : "Откуда",
    "to" : "Куда",
    
    "wentWrong": "Что-то пошло не так",
    
    "myAuto": "Мое авто",
    "myOrders": "Мои заказы",
    "transfer": "Перевести",
    "minute" : "мин",
    "withdraw": "Вывести",
    "balanceUnder100": "Баланс должен быть не ниже 100 тг",
    
    "smsSent": "СМС отправлен на ваш номер",
    "enterSMSCode": "Введите СМС-код",
    "sum": "Нужная сумма",
    "insufficientMoney": "Недостаточно средств",
    
    "price" : "Ваша цена",
    "passengers_count" : "Количество пассажиров",
    "take_traveler" : "Взять попутчика",
    "bonus" : "Бонус",
    "order" : "Заказать",
    "create" : "Создать",
    "city" : "Такси",
    "history" : "История",
    "intercity" : "Межгород",
    "toi_taxi" : "VIP такси",
    "special_eqipment" : "Спецтехника",
    "cargo" : "Грузовые",
    "moto": "Мотолюбитель",
    "find_friends" : "Родительский контроль",
    "promocode" : "Получить бонусы",
    "notifications" : "Уведомления",
    "help" : "Помощь",
    "driver_mode" : "Режим водителя",
    "profile" : "Профиль",
    "contactUs": "Написать нам",
    "date" : "Дата и время выезда",
    "my_orders" : "Мои заказы",
    "cancel_order" : "Отменить заказ",
    "offers" : "Предложения",
    "depositLimitMessage": "У вас должно остаться не меньше 100 тенге",
    "note" : "Комментарии",
    "document" : "Документ",
    "torg" : "Торг",
    "phone_number" : "Номер телефона",
    "send" : "Отправить",
    "enter_promocode" : "Введите промокод",
    "add" : "Добавить",
    "share" : "Поделиться",
    "surname" : "Фамилия",
    "name" : "Имя",
    "middle_name" : "Отчество",
    "car_mark" : "Марка машины",
    "car_model" : "Модель машины",
    "car_year" : "Год машины",
    "car_color" : "Цвет машины",
    "gos_number" : "Гос номер",
    "iin" : "ИИН",
    "authCode": "Вам отправлен код авторизации",
    "id_card_number" : "Номер удостоверения личности",
    "id_card_date" : "Дата выдачи удостоверения личности",
    "tech_passport_number" : "Номер техпаспорта",
    "id_card_photo" : "Фото удост. личности (передняя часть)",
    "id_card_photo2" : "Фото удост. личности (задняя часть)",
    "tech_passport_photo" : "Фото техпаспорта (передняя часть)",
    "tech_passport_photo2" : "Фото техпаспорта (задняя часть)",
    "prava_photo" : "Фото прав (передняя часть)",
    "prava_photo2" : "Фото прав (задняя часть)",
    "car_photo" : "Фото авто (передняя часть)",
    "car_photo2" : "Фото авто (задняя часть)",
    "add_car" : "Добавить транспорт",
    "continue" : "Продолжить",
    "save" : "Сохранить",
    "choose_language" : "Выберите язык",
    "cancel" : "Отмена",
    "busy" : "Занят",
    "accept_order" : "Принять заказ",
    "repeat" : "Повторить",
    "reverse" : "Обратное направление",
    "choose_action" : "Выберите действие",
    "cargo_note" : "Дата и время поездки, размеры и тип груза (Укажите более точную информацию для водителя)",
    "send_request" : "Отправить заявку",
    "promo_text_1" : "Привет! Воспользуйся моим промо кодом ",
    "promo_text_2" : " в приложении ArzanTaksi и заработай деньги на бесплатные поездки или на единицы! Скачать здесь:",
    "edit_profile" : "Редактирование профиля",
    "add_cargo" : "Добавить грузовик",
    "add_spec" : "Добавить спецтехнику",
    "add_toi" : "Добавить той такси",
    "toi_price" : "Стоимость",
    "promo_label" : "Преимущество для клиентов и водителей: Скачав данное приложение и приглашая друзей вы можете заработать деньги в виде бонуса на бесплатные поездки или единицы!",
    "driver_online" : "Онлайн",
    "driver_online_text" : "Согласны ли вы заплатить 20₸ чтобы получить доступ к функциям режима водителя на 8 часов?",
    "yes" : "Да",
    "no" : "Нет",
    "desc" : "Описание",
    "comment" : "Комментарий",
    "complaint" : "Для жалоб и предложений",
    "end_order" : "Завершить заказ",
    "friend_label" : "Отследить друзей",
    "friend_text" : "хочет добавить вас в друзья, чтобы иметь доступ к вашим геоданным, принять заявку?",
    "fill_all" : "Заполните все поля и выберите все фотографии",
    "doc_yes" : "С документами",
    "doc_no" : "Без документов",
    "torg_yes" : "Торг",
    "torg_no" : "Без торга",
    "orders" : "Заказы",
    "new_tex": "Новая техника",
    "my_tex" : "Моя техника",
    "user_orders" : "Заказать",
    "free_auto": "Список заказов",
    "user_my_orders" : "Мои заказы",
    "feedback_label" : "Оцените поездку",
    "feedback_label_2" : "Оценивая, вы улучшаете качество сервиса",
    "close" : "Закончить",
    "promo_main" : "Поделитесь с промокодом с друзьями",
    "driver_arrived" : "Я приехал",
    "client_out" : "Пассажир выходит",
    "notif_driver" : "Пассажиру отправлено уведомление, что вы приехали",
    "woman": "Lady-водитель",
    "invalid": "Продукт",
    "fields": "Заполните все поля!",
    "balanceCard": "Пополнить баланс карточкой",
    "balanceSMS": "Пополнить баланс через СМС",
    "balanceUnits": "Вывод баланса в виде единиц на моб. связь",
    "balanceUser": "Перевести баланс на другого пользователя",
    "balanceKassa24": "Пополнить баланс через Касса24",
    "balanceQiwi": "Пополнить баланс через Qiwi",
    "pay": "Оплатить",
    "amount": "Сумма пополнения",
    "error": "Ошибка!",
    "success": "Успешно!",
    "notPaid":"Не оплачено",
    "free":"Свободен",
    "accept": "Принять",
    "addPhotos" : "Добавить изображения",
    "offer_price": "Предлагать цену",
    "getYourPrice": "Предложите свою цену",
    "skip": "Пропустить",
    "next": "Далее",
    "start": "Начать",
    
    "policy": "Политика конфиденциальности",
    "agree": "Согласен",
    "disagree": "Не согласен"
]

let en_dictionary = [
    "back": "Back",
    "smsCode": "SMS-code",
    "free_tech": "Free car",
    "free_moto": "Free moto",
    "ready": "Ready",
    "from" : "From",
    "to" : "To",
    "transfer": "Transfer",
    "withdraw": "Withdraw",
    "myAuto": "My auto",
    "myOrders": "My orders",
    "wentWrong": "Something went wrong",
    "enterInfo": "Enter info",
    "wait": "Please, wait...",
    "smsSent": "SMS sent to your number",
    "enterSMSCode": "Enter SMS-code",
    "sum": "Necessary sum",
    "insufficientMoney": "Insuffiecient money",
    "price" : "Your price",
    "passengers_count" : "Number of passengers",
    "take_traveler" : "Take a traveler",
    "balanceUnder100": "Balance should be not less than 100 ₸",
    "bonus" : "Bonus",
    "order" : "Get Order",
    "create" : "Create",
    "city" : "Taxi",
    "history" : "History",
    "intercity" : "Intercity",
    "toi_taxi" : "VIP taxi",
    "special_eqipment" : "Special machinery",
    "cargo" : "Cargo",
    "moto": "Motorcycle",
    "find_friends" : "Track a friend",
    "promocode" : "Promocode",
    "notifications" : "Notifications",
    "help" : "Help",
    "driver_mode" : "Driver mode",
    "profile" : "Profile",
    "date" : "Date and time of departure",
    "my_orders" : "My orders",
    "cancel_order" : "Cancel order",
    "offers" : "Offers",
    "note" : "Comments",
    "document" : "Document",
    "torg" : "Bargin",
    "phone_number" : "Phone number",
    "send" : "Send",
    "enter_promocode" : "Enter a promotional code",
    "add" : "Add",
    "share" : "Share",
    "surname" : "Surname",
    "authCode": "The authorization code is sent to you",
    "name" : "Name",
    "middle_name" : "Middle name",
    "minute" : "min",
    "car_mark" : "Car mark",
    "car_model" : "Car model",
    "car_year" : "Car year",
    "car_color" : "Car color",
    "gos_number" : "State number",
    "iin" : "IIN",
    "contactUs": "Feedback",
    "depositLimitMessage": "You should have not less than 100 ₸",
    "id_card_number" : "ID number",
    "id_card_date" : "Date of issue of identity card",
    "tech_passport_number" : "Technical document number",
    "id_card_photo" : "ID card photo (front)",
    "id_card_photo2" : "ID card photo (back)",
    "tech_passport_photo" : "Tech. document photo (front)",
    "tech_passport_photo2" : "Tech. document photo (back)",
    "prava_photo" : "License photo (front)",
    "prava_photo2" : "License photo (back)",
    "car_photo" : "Car photo (front)",
    "car_photo2" : "Car photo (back)",
    "add_car" : "Add car",
    "continue" : "Continue",
    "save" : "Save",
    "choose_language" : "Choose language",
    "cancel" : "Cancel",
    "busy" : "Busy",
    "accept": "Accept",
    "getYourPrice": "Get your price",
    "accept_order" : "Accept order",
    "repeat" : "Repeat",
    "reverse" : "Reverse",
    "choose_action" : "Choose action",
    "cargo_note" : "Date and time of the trip, size and type of cargo (Please provide more precise information for the driver)",
    "send_request" : "Send request",
    "promo_text_1" : "Hello! Use my promo code ",
    "promo_text_2" : " at BidKab app and earn bonuses for free trips or balance.",
    "edit_profile" : "Edit profile",
    "add_cargo" : "Add cargo",
    "add_spec" : "Add special car",
    "add_toi" : "Add toi taxi",
    "toi_price" : "Price",
    "promo_label" : "The advantage for clients and drivers by downloading and inviting your friends you can earn money as bonus for free trips or units.",
    "driver_online" : "Online",
    "driver_online_text" : "Do you agree to pay 500₸ to get access to the driver's mode functions for 24 hours?",
    "yes" : "Yes",
    "no" : "No",
    "desc" : "Description",
    "comment" : "Comment",
    "complaint" : "For complaintsm and suggestions",
    "end_order" : "End order",
    "friend_label" : "Track friends",
    "friend_text" : "wants to add you as a friend to have access to your location, accept the application?",
    "fill_all" : "Fill in all the fields and select all photos",
    "doc_yes" : "With documents",
    "doc_no" : "Without documents",
    "torg_yes" : "Bargain",
    "torg_no" : "Without bargain",
    "orders" : "Orders",
    "new_tex": "New tex",
    "my_tex" : "My tex",
    "user_orders" : "Order",
    "free_auto": "Order list",
    "user_my_orders" : "My orders",
    "feedback_label" : "Rate the trip",
    "feedback_label_2" : "By evaluating, you improve the quality of service",
    "close" : "Finish",
    "promo_main" : "Share the promo code with your friends",
    "driver_arrived" : "I have arrived",
    "client_out" : "Passenger coming outside",
    "notif_driver" : "A notification has been sent to the passenger that you have arrived",
    "woman": "Lady-driver",
    "invalid": "Product",
    "fields": "Fill all fields!",
    "balanceCard": "Fill balance with card",
    "balanceSMS": "Fill balance with SMS",
    "balanceUnits": "Get balance as mob. connection units",
    "balanceUser": "Transfer balance to other users",
    "balanceKassa24": "Fill balance with Касса24",
    "balanceQiwi": "Fill balance with Qiwi",
    "pay": "Pay",
    "amount": "Amount of money",
    "error": "Error!",
    "success": "Success!",
    "notPaid":"Not paid",
    "free":"Free",
    "delete": "Delete",
    "offer_price": "Offer price",
    "addPhotos" : "Add photos",
    "skip": "Skip",
    "next": "Next",
    "start": "Start",
    
    "policy": "Privacy policy",
    "agree": "Agree",
    "disagree": "Disagree"
]

protocol LeftMenuControllerDelegate : class {
    func switchToDriverMode(isOn : Bool, completion: ((Bool)->()) )
}

protocol TutorialViewControllerDelegate : class {
    func handleContinue()
}

protocol CargoViewControllerDelegate {
    func handleOrderButton(aPoint : String, bPoint : String, price : String, document : Bool, bargain : Bool, text : String, images: [UIImage])
}

protocol IntercityViewControllerDelegate {
    func handleOrderButton(aPoint : String, bPoint : String, price : String, date : String, text : String)
}

protocol SpecialViewControllerDelegate {
    func handleOrderButton(bPoint : String, price : String, text : String, images: [UIImage])
}

protocol ToyTaxiViewControllerDelegate {
    func handleOrderButton(price : String, date : String, text : String)
}

protocol MotoViewControllerDelegate {
    func handleOrderButton(aPoint : String, bPoint : String, price : String, date : String, text : String)
}

protocol DriverProfileControllerDelegate {
    func switchToDriver(body : [String : String])
    func editProfile(body : [String : String])
    func pickImage(tag : Int)
    func addCar()
}

protocol DriverIntercityViewControllerDelegate {
    func handleOrderButton(aPoint : String, bPoint : String, price : String, text : String)
}

protocol DriverCargoControllerDelegate {
    func handleOrderButton(price : String, text : String, images: [UIImage])
}

protocol DriverMotoControllerDelegate {
    func handleOrderButton(price : String, text : String, images: [UIImage])
}

protocol DriverToyControllerDelegate {
    func handleOrderButton(price : String, text : String)
}

protocol DriverSpecialControllerDelegate {
    func handleOrderButton(price : String, text : String)
}

protocol HistoryViewControllerDelegate {
    func optionButton(from : String, to : String, price : Int, fromLat : Double, fromLon : Double, toLat : Double, toLon : Double, getPassenger : Int, passengersCount : Int, bonus : Int, description: String, cityId: Int)
}

protocol OptionDelegate {
    func optionButton(id: Int)
}

extension UIApplication {
    var statusBarView : UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func shadow(opacity: Float, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
    }
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static let blue : UIColor = {
        return "4AA3C4".hexColor
    }()
    
    static let yellow : UIColor = {
        return "FBE84D".hexColor
    }()
    
    static let pray: UIColor = {
        return UIColor.rgb(red: 214, green: 54, blue: 209)
    }()
    
    static let mainGreenColor: UIColor = {
        return UIColor.rgb(red: 34, green: 139, blue: 34)
    }()
    
    static let gray : UIColor = {
        return UIColor.rgb(red: 149, green: 152, blue: 154)
    }()
    
    static let green : UIColor = {
        return "228B22".hexColor
    }()
    
    static let red : UIColor = {
        return UIColor.rgb(red: 237, green: 21, blue: 21)
    }()
    
    static let paleGray: UIColor = UIColor.rgb(red: 250, green: 250, blue: 250)
}

extension String {    
    static func localizedString(key : String) -> String {
        if let lang = UserDefaults.standard.string(forKey: "language") {
            if lang == "kz" {
                if let value = kz_dictionary[key] {
                    return value
                }
            } else if lang == "ru" {
                if let value = ru_dictionary[key] {
                    return value
                }
            } else if lang == "en" {
                if let value = en_dictionary[key] {
                    return value
                }
            }
        }
        
        return ""
    }
    
    var serverUrlString: String {
        return Constant.api.prefixForImage + self
    }
    
    var url: URL {
        return URL(string: self)! 
    }
    
    func imageURL() -> String {
        return "http://185.111.106.48/\(self)"
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    
    static var heightNavBar = UINavigationController().navigationBar.bounds.height

    
    @objc func changeLanguage() {
        let alertController = UIAlertController(title: String.localizedString(key: "choose_language"), message: nil, preferredStyle: .actionSheet)
        let russiaAction = UIAlertAction(title: "Русский", style: .default) { (action) in
            UserDefaults.standard.set("ru", forKey: "language")
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "russian")?.withRenderingMode(.alwaysOriginal)
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            appDelegate.setupAppdelegate()
        }
        
        let kazakhAction = UIAlertAction(title: "Қазақша", style: .default) { (action) in
            UserDefaults.standard.set("kz", forKey: "language")
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "kazakh")?.withRenderingMode(.alwaysOriginal)
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            appDelegate.setupAppdelegate()
        }
        
        let englishAction = UIAlertAction(title: "English", style: .default) { (action) in
            UserDefaults.standard.set("en", forKey: "language")
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "english")?.withRenderingMode(.alwaysOriginal)
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            appDelegate.setupAppdelegate()
        }
        
        let cancelAction = UIAlertAction(title: String.localizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(russiaAction)
        alertController.addAction(kazakhAction)
        alertController.addAction(englishAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func optionAction() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: .localizedString(key: "delete"), style: .default) { (action) in
        }
        
        let cancelAction = UIAlertAction(title: String.localizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(delete)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func getPlaceName(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, _ stringView: UITextField){
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&language=en&key=\(GMS_API_KEY)"
        Alamofire.request(url).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print("Place json: \(json)")

                let street = json["results"][0]["address_components"][1]["long_name"].stringValue
                let address = json["results"][0]["address_components"][0]["long_name"].stringValue

                let fromPointAddress = "\(street), \(address)"
                stringView.text = fromPointAddress

                break
            case .failure:
                stringView.text = ""
                break
            }
        })
    }

    func getPlaceName(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, _ stringView: UILabel){
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&language=en&key=\(GMS_API_KEY)"
        Alamofire.request(url).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print("Place json: \(json)")

                let street = json["results"][0]["address_components"][1]["long_name"].stringValue
                let address = json["results"][0]["address_components"][0]["long_name"].stringValue

                let fromPointAddress = "\(street), \(address)"
                stringView.text = fromPointAddress

                break
            case .failure:
                stringView.text = ""
                break
            }
        })
    }
    
    func setNavigationBarTransparent(title: String?, shadowImage: Bool) -> Void {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        if title == nil {
            self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Лого"))
            self.navigationItem.titleView?.contentMode = .scaleAspectFill
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.navigationController?.navigationBar.tintColor = .blue
        } else {
            let titleView = TextTitleView()
            titleView.titleLabel.text = title
            self.navigationItem.titleView = titleView
            self.navigationItem.titleView?.contentMode = .scaleAspectFill
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.navigationController?.navigationBar.tintColor = .blue
            
        }
    }
}

extension HomeViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let value = marker.userData {
            let json = JSON(value)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                marker.icon = #imageLiteral(resourceName: "highlighted_car")
                
                self.carText.text = json["car"].stringValue
                let path = json["avatar"].stringValue
                var avatar = ""
                if path.contains("public") {
                    let startIndex = path.index(path.startIndex, offsetBy: 14)
                    let url = path[startIndex...]
                    
                    avatar = Constant.api.images + url
                }
                if let url = URL(string: avatar) {
                    self.profileImage.kf.setImage(with: url)
                }
                self.fullName.text = json["full_name"].stringValue
                self.ratingView.rating = json["rating"].doubleValue
                self.ratingView.text = "\((json["rating"].doubleValue))"
                
                if let navBarHeight =  self.navigationController?.navigationBar.frame.height {
                    let statusBarHeight = UIApplication.shared.statusBarFrame.height
                    self.mapsView?.frame = CGRect(x: 0, y: navBarHeight + statusBarHeight, width: self.view.frame.width, height: self.view.frame.height - (navBarHeight + statusBarHeight) - 120)
                }
                self.orderView.frame.origin.y = self.view.frame.height
                self.infoView.frame.origin.y = self.view.frame.height - 120
                
            }, completion: nil)
        }
        
        return true
    }

    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        UIView.animate(withDuration: 0.5) {
            self.orderView.frame.origin.y = self.view.frame.height
            self.mapsView?.frame.size.height = self.view.frame.height - self.navigationController!.navigationBar.frame.height - UIApplication.shared.statusBarFrame.height
            self.mapButton.frame.origin.y = self.view.frame.height - 30
        }
    }

    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        getPlaceName(marker.position.latitude, marker.position.longitude, selectedTextField)
        UIView.animate(withDuration: 0.5) {
            self.orderView.frame.origin.y = self.view.frame.height - self.orderView.frame.height
            self.mapButton.frame.origin.y = self.orderView.frame.height - 30
            self.mapsView?.frame.size.height = self.view.frame.height - self.orderView.frame.height - self.navigationController!.navigationBar.frame.height - UIApplication.shared.statusBarFrame.height
            mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 15)
        }

    }
}

extension HomeViewController : GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        fromCoordinate = selectedTextField == aPointSearchButton ? place.coordinate : fromCoordinate
        toCoordinate = selectedTextField == bPointSearchButton ? place.coordinate : toCoordinate
        selectedTextField.text = place.name
        viewController.dismiss(animated: true, completion: {
//            self.pointChooseMarker.position = place.coordinate
            self.isInSearchPage = false
//            self.mapsView?.camera = GMSCameraPosition.camera(withTarget: self.pointChooseMarker.position, zoom: 15)
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
        viewController.dismiss(animated: true, completion: {
            self.isInSearchPage = false
        })
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: {
            self.isInSearchPage = false
//            self.mapsView?.camera = GMSCameraPosition.camera(withTarget: self.pointChooseMarker.position, zoom: 15)
        })
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    static func createOrderLabel(with image : UIImage, placeholder : String) -> UITextField {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = CGRect(x: 5, y: 0, width: 16, height: 24)
        
        let view = UIView(frame: CGRect(x: 5, y: 0, width: 35, height: 24))
        view.addSubview(imageView)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .black
        textField.leftView = view
        textField.leftView?.frame = view.frame
        textField.leftViewMode = .always
        textField.borderStyle = .none

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)

        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
        return textField
    }
    
    @objc func getAllDrivers() {
        Socket.shared.getAllDrivers(completion: { (drivers, statusCode) in
            if statusCode == Constant.statusCode.success {
                self.drivers = drivers
                self.mapsView?.clear()
                for driver in drivers {
                    let marker = GMSMarker()
                    marker.icon = #imageLiteral(resourceName: "taxi_icon")
                    
                    if let surname = driver.surname, let name = driver.name, let middle_name = driver.middle_name, let rating = driver.rating, let mark = driver.taxi_cars?.mark?.name, let model = driver.taxi_cars?.model?.name, let color = driver.taxi_cars?.color?.name_ru, let avatar = driver.avatar {
                        
                        var driverData = Dictionary<String, Any>()
                        driverData["full_name"] = surname + " " + name + " " + middle_name
                        driverData["car"] = mark + " " + model + " " + color
                        driverData["avatar"] = avatar
                        driverData["rating"] = rating
                        
                        marker.userData = driverData
                    }
                    
                    marker.map = self.mapsView
                    if let latitude = Double(driver.lat!), let longitude = Double(driver.lon!) {
                        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    }
                }
            } else {
                print("GCODE")
            }
        })
    }
    
    func fetchUserData() {
        let indicator = SVProgressHUD.self
        indicator.setDefaultMaskType(.black)
        indicator.show(withStatus: "Please, wait...")
        if let phone = UserDefaults.standard.string(forKey: "phoneNumber") {
            User.authUser(body: ["phone" : phone.removingWhitespaces()], completion: { (result, user, statusCode) in
                print("result: \(result)")
                switch result {
                case .success:
                    if statusCode == Constant.statusCode.success {
                        self.user = user
                        print("UserCityIDForHome: \(user.city_id)")
                        UserDefaults.standard.set(user.promo_code, forKey: "promoCode")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.set(user.token, forKey: "token")
                        UserDefaults.standard.set(user.city_id, forKey: "city_id")
                        indicator.dismiss()
                    } else {
                        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                        indicator.showError(withStatus: "Something is wrong")
                    }
                    break
                case .failure:
                    indicator.showError(withStatus: "Something is wrong")
                    break
                }
            })
        } else {
            indicator.dismiss()
        }
    }
    
    @objc func handlePassangersCount(sender: UIButton) {
        if sender.tag == 0 {
            if passengersCount > 1 {
                passengersCount -= 1
                countOfPassangers.text = "\(passengersCount)"
            } else {
                passengersCount = 1
                countOfPassangers.text = "\(passengersCount)"
            }
        } else {
            if passengersCount < 7 {
                passengersCount += 1
                countOfPassangers.text = "\(passengersCount)"
            }
        }
    }
    
    @objc func handleMyLocation() {
        if let latitude = locationManager.location?.coordinate.latitude, let longitude = locationManager.location?.coordinate.longitude {
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
            
            mapsView?.animate(to: camera)
        }
    }
    
    @objc func handleOrderButton() {
        let socketManager = Socket.shared
        let orderController = OrderViewController()
        orderController.delegate = self
        var fromLat = 0.0
        var fromLon = 0.0
        var toLat = 0.0
        var toLon = 0.0
        var getPassengers = 0
        var bonus = 0
        fromLat = fromCoordinate?.latitude ?? 0.0
        fromLon = fromCoordinate?.longitude ?? 0.0
        toLat = toCoordinate?.latitude ?? 0.0
        toLon = toCoordinate?.longitude ?? 0.0
        getPassengers = takeTravelerSwitcher.isOn ? 1 : 0
        bonus = bonusSwitcher.isOn ? 1 : 0
        if let from = aPointSearchButton.text,
            let to = bPointSearchButton.text,
            let price = priceTextField.text,
            let passengersCount = countOfPassangers.text,
            let description = descriptionTextField.text,
            let token = UserDefaults.standard.string(forKey: "token") {
            indicator.show()
            UserDefaults.standard.set(from, forKey: "fromL")
            UserDefaults.standard.set(to, forKey: "toL")
            UserDefaults.standard.set(price, forKey: "priceL")
            if from == "" || to == "" || price == "" || passengersCount == "" || from == " " || to == " " || price == " " || passengersCount == " " {
                indicator.showError(withStatus: String.localizedString(key: "fields"))
                indicator.dismiss(withDelay: 0.5)
            } else {
                socketManager.createOrder(token: token, from: from, fromLat: "\(fromLat)", fromLon: "\(fromLon)", to: to, toLat: "\(toLat)", toLon: "\(toLon)", price: price, passengersCount: passengersCount, getPassengers: getPassengers, bonus: bonus, description: description, isWoman: isWoman, isInvalid: isInvalid, completion: { id, step
                    in
                    DispatchQueue.main.async {
                        self.orderID = id
                        UserDefaults.standard.set(id, forKey: "currentOrderID")
                        orderController.id = id
                        orderController.from = from
                        orderController.to = to
                        if bonus == 1 {
                            let doublePrice = Double(price)!
                            orderController.price = "\(doublePrice.getRemainder())₸ + \(doublePrice.getBonus())₸ bonus"
                        } else {
                            orderController.price = price
                        }
                        orderController.fromLat = fromLat
                        orderController.fromLon = fromLon
                        orderController.toLat = toLat
                        orderController.toLon = toLon
                        orderController.cityID = self.user?.city_id
                        orderController.completion = {
                            socketManager.client.off("order_create")
                            print("Order is completed")
                        }
                        if orderController.id != 0 {
//                            self.present(orderController, animated: true, completion: nil)
                            self.navigationController?.pushViewController(orderController, animated: true)
                        }
                    }
                })
            }
        }
    }
}

extension OrderViewController {
    @objc func handleEndButton() {
        UserDefaults.standard.set(0, forKey: "currentOrderID")
        if let orderID = id {
            Socket.shared.endOrder(id: orderID)
        }
    }
    
    @objc func handleDiscardButton(_ sender: UIButton) {
        if let orderID = id, let cityID = cityID {
            indicator.show()
            Socket.shared.cancelOrder(id: orderID, city_id: cityID) { isSuccess in
                if isSuccess {
                    indicator.dismiss()
                    self.dismiss(animated: true, completion: {
                        UserDefaults.standard.setValue(0, forKey: "currentOrderID")
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.setupAppdelegate()
                        }
                    })
                } else {
                    indicator.showError(withStatus: "Error")
                }
            }
        } else {
            print("cant handle discard!!!!!")
        }
    }
    
    static func createLabel(text : String) -> UILabel {
        let label = UILabel()
        label.text = text
        
        return label
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        let parameters : [String : String] = ["key" : "AIzaSyBxsonU1udXLJqY0uzhDuPN_opy-WfLl-g", "sensor" : "false", "mode" : "driving", "alternatives" : "false", "origin" : "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)", "destination" : "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"]
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?mode=driving")
        
        Alamofire.request(url!, method: .get, parameters: parameters).responseJSON { (response) in
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            // print route using Polyline
            
            print("Route: \(routes.count) ")
            
            for route in routes {
                self.polyline?.map = nil
                
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath(fromEncodedPath: points!)
                self.polyline = GMSPolyline(path: path)
                self.polyline?.strokeWidth = 4
                self.polyline?.strokeColor = .blue
                self.polyline?.map = self.mapsView
            }
        }
    }
}

extension DriverHomeController {
    func fetchUserData() {
        let indicator = SVProgressHUD.self
        indicator.setDefaultMaskType(.black)
        indicator.show(withStatus: "Please, wait...")
        if let phone = UserDefaults.standard.string(forKey: "phoneNumber") {
            User.authUser(body: ["phone" : phone.removingWhitespaces()], completion: { (result,user, statusCode) in
                print("Result: \(result)")
                switch result{
                case .success:
                    if statusCode == Constant.statusCode.success {
                        self.user = user
                        UserDefaults.standard.set(user.promo_code, forKey: "promoCode")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.set(user.token, forKey: "token")
                        UserDefaults.standard.set(user.city_id, forKey: "city_id")

                        indicator.dismiss()
                    } else {
                        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                        indicator.showError(withStatus: "Something is wrong")
                    }
                break
                case .failure:
                    indicator.showError(withStatus: "Something is wrong")
                break
                }
            })
        }
    }
}

extension DriverProfileController {
    func switchToDriver(body : [String : String]) {
        let indicator = SVProgressHUD.self
        indicator.show(withStatus: "Loading...")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
//                if let idCardImage = self.idCardImage {
//                    if let idCardImageData = UIImageJPEGRepresentation(idCardImage, 0.7) {
//                        let imageRandomName = NSUUID().uuidString
//                        multipartFormData.append(idCardImageData, withName: "card_photo", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
//                    }
//                } else {
//                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
//                    indicator.dismiss(withDelay: 2)
//                    return
//                }
//                
//                if let idCardImage2 = self.idCardImage2 {
//                    if let idCardImageData2 = UIImageJPEGRepresentation(idCardImage2, 0.7) {
//                        let imageRandomName = NSUUID().uuidString
//                        multipartFormData.append(idCardImageData2, withName: "card_photo_2", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
//                    }
//                } else {
//                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
//                    indicator.dismiss(withDelay: 2)
//                    return
//                }
//                
//                if let techPassportImage = self.techPassportImage {
//                    if let techPasswordImageData = UIImageJPEGRepresentation(techPassportImage, 0.7) {
//                        let imageRandomName = NSUUID().uuidString
//                        multipartFormData.append(techPasswordImageData, withName: "tech_photo", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
//                    }
//                } else {
//                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
//                    indicator.dismiss(withDelay: 2)
//                    return
//                }
//                
//                if let techPassportImage2 = self.techPassportImage2 {
//                    if let techPasswordImageData2 = UIImageJPEGRepresentation(techPassportImage2, 0.7) {
//                        let imageRandomName = NSUUID().uuidString
//                        multipartFormData.append(techPasswordImageData2, withName: "tech_photo_2", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
//                    }
//                } else {
//                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
//                    indicator.dismiss(withDelay: 2)
//                    return
//                }
//                
//                if let pravaImage = self.pravaImage {
//                    if let pravaImageData = UIImageJPEGRepresentation(pravaImage, 0.7) {
//                        let imageRandomName = NSUUID().uuidString
//                        multipartFormData.append(pravaImageData, withName: "prava_photo", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
//                    }
//                } else {
//                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
//                    indicator.dismiss(withDelay: 2)
//                    return
//                }
//                
//                if let pravaImage2 = self.pravaImage2 {
//                    if let pravaImageData2 = UIImageJPEGRepresentation(pravaImage2, 0.7) {
//                        let imageRandomName = NSUUID().uuidString
//                        multipartFormData.append(pravaImageData2, withName: "prava_photo_2", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
//                    }
//                } else {
//                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
//                    indicator.dismiss(withDelay: 2)
//                    return
//                }
//                
//                if let carImage = self.carImage {
//                    if let carImageData = UIImageJPEGRepresentation(carImage, 0.7) {
//                        let imageRandomName = NSUUID().uuidString
//                        multipartFormData.append(carImageData, withName: "car_photo", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
//                    }
//                } else {
//                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
//                    indicator.dismiss(withDelay: 2)
//                    return
//                }
//                
//                if let carImage2 = self.carImage2 {
//                    if let carImageData2 = UIImageJPEGRepresentation(carImage2, 0.7) {
//                        let imageRandomName = NSUUID().uuidString
//                        multipartFormData.append(carImageData2, withName: "car_photo_2", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
//                    }
//                } else {
//                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
//                    indicator.dismiss(withDelay: 2)
//                    return
//                }
                
                if let profileImage = self.profileImage {
                    if let profileImageData = UIImageJPEGRepresentation(profileImage, 0.7) {
                        let imageRandomName = NSUUID().uuidString
                        multipartFormData.append(profileImageData, withName: "avatar", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
                    }
                }
                
                for (key, value) in body {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: Constant.api.driver, method: .post,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        if response.result.isSuccess {
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("Switch to driver: \(json)")
                                
                                if json["statusCode "].intValue == Constant.statusCode.success {
                                    indicator.dismiss()
                                    indicator.showSuccess(withStatus: "Вы теперь в режиме водителя")
                                    indicator.dismiss(withDelay: 1.5)
                                    
                                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                        appDelegate.setupAppdelegate()
                                    }
                                } else {
                                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
                                    indicator.dismiss(withDelay: 2)
                                }
                            }
                        } else {
                            if let error = response.result.error {
                                indicator.dismiss()
                                indicator.showError(withStatus: "Not OK")
                                indicator.dismiss(withDelay: 3)
                                print("EncodingResult: \(encodingResult)")
                                print(error.localizedDescription)
                                if error.localizedDescription == "The Internet connection appears to be offline." { }
                                else { }
                            }
                        }
                    }
                case .failure(let encodingError):
                    
                    print(encodingError.localizedDescription)
                }
        })
    }
    
    func editProfile(body : [String : String]) {
        let indicator = SVProgressHUD.self
        indicator.show(withStatus: "Loading...")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let profileImage = self.profileImage {
                    if let profileImageData = UIImageJPEGRepresentation(profileImage, 0.7) {
                        let imageRandomName = NSUUID().uuidString
                        multipartFormData.append(profileImageData, withName: "avatar", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
                    }
                }
                
                for (key, value) in body {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: Constant.api.edit_profile, method: .post,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Response profile edit: \(response)")
                        if response.result.isSuccess {
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("Edit profile: \(json)")
                                
                                if json["statusCode "].intValue == Constant.statusCode.success {
                                    indicator.dismiss()
                                    indicator.showSuccess(withStatus: "Data is updated")
                                    indicator.dismiss(withDelay: 1.5)
                                    
                                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                        appDelegate.setupAppdelegate()
                                    }
                                } else {
                                    indicator.showError(withStatus: .localizedString(key: "fill_all"))
                                    indicator.dismiss(withDelay: 2)
                                }
                            }
                        } else {
                            if let error = response.result.error {
                                indicator.dismiss()
                                indicator.showError(withStatus: "Not OK")
                                indicator.dismiss(withDelay: 3)
                                print("Encoding result: \(encodingResult)")
                                print(error.localizedDescription)
                                if error.localizedDescription == "The Internet connection appears to be offline." { }
                                else { }
                            }
                        }
                    }
                case .failure(let encodingError):
                    
                    print(encodingError.localizedDescription)
                }
        })
    }
    
    func addCar() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let isCargoExist = user?.cargoExist {
            if !isCargoExist {
                let cargoAction = UIAlertAction(title: .localizedString(key: "add_cargo"), style: .default) { (action) in
                    let viewController = AddCargoViewController()
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
                alert.addAction(cargoAction)
            }
        }
        
        let specAction = UIAlertAction(title: .localizedString(key: "add_spec"), style: .default) { (action) in
            
            let viewController = DriverSpecialViewController()
            //viewController.user = self.user
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        let toiAction = UIAlertAction(title: .localizedString(key: "add_toi"), style: .default) { (action) in
            let viewController = DriverToiCarViewController()
            
            viewController.user = self.user
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: .localizedString(key: "cancel"), style: .cancel, handler: nil)
        
        
        alert.addAction(specAction)
        alert.addAction(toiAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension DriverIntercityListCell {
    @objc func getAllIntercityList() {
        let indicator = SVProgressHUD.self
        indicator.show(withStatus: "Loading...")
        Alamofire.request(Constant.api.intercity_list).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print("Intercity list: \(json)")
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        let intercityArray = json["result"].arrayValue
                        
                        self.list.removeAll()
                        
                        for intercity in intercityArray {
                            let temp = Intercity()
                            
                            temp.id = intercity["id"].intValue
                            temp.type = intercity["type"].stringValue
                            
                            let passenger = User()
                            
                            passenger.id = intercity["passenger"]["id"].intValue
                            passenger.surname = intercity["passenger"]["surname"].stringValue
                            passenger.name = intercity["passenger"]["name"].stringValue
                            passenger.middle_name = intercity["passenger"]["middle_name"].stringValue
                            passenger.phone = intercity["passenger"]["phone"].stringValue
                            passenger.role = intercity["passenger"]["role"].intValue
                            passenger.city_id = intercity["passenger"]["city_id"].intValue
                            passenger.city = intercity["passenger"]["city"].stringValue
                            passenger.lat = intercity["passenger"]["lat"].stringValue
                            passenger.lon = intercity["passenger"]["lon"].stringValue
                            passenger.avatar = intercity["passenger"]["avatar"].stringValue
                            passenger.token = intercity["passenger"]["token"].stringValue
                            passenger.promo_code = intercity["passenger"]["promo_code"].stringValue
                            passenger.balanse = intercity["passenger"]["balanse"].intValue
                            passenger.online = intercity["passenger"]["online"].intValue
                            passenger.iin = intercity["passenger"]["iin"].stringValue
                            passenger.id_card = intercity["passenger"]["id_card"].stringValue
                            passenger.expired_date = intercity["passenger"]["expired_date"].stringValue
                            passenger.year = intercity["passenger"]["year"].intValue
                            passenger.driver_was = intercity["passenger"]["driver_was"].intValue
                            passenger.tech_passport = intercity["passenger"]["tech_passport"].stringValue
                            passenger.rating = intercity["passenger"]["rating"].stringValue
                            passenger.socket_id = intercity["passenger"]["socket_id"].intValue
//                            passenger.taxi_cars = intercity["passenger"]["taxi_cars"].
                            
                            temp.passenger = passenger
                            temp.driver_id = intercity["driver_id"].intValue
                            temp.from = intercity["from"].stringValue
                            temp.to = intercity["to"].stringValue
                            temp.price = intercity["price"].intValue
                            temp.text = intercity["text"].stringValue
                            temp.date = intercity["date"].stringValue
                            temp.status = intercity["status"].intValue
                            temp.step = intercity["step"].intValue
                            
                            self.list.append(temp)
                            self.tableView.reloadData()
                            self.refresh.endRefreshing()
                            indicator.dismiss()
                        }
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}
    
    func createIntercityOrder(id : Int) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let body : Parameters = [
                "token" : token,
                "parent_id" : id,
                "parent_type" : "intercity_orders"
            ]
            
            Alamofire.request(Constant.api.accept_order, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("Accept order: \(json)")
                    }
                case .failure(let error):
                    print(error)
                    return
                }
            }
        }
    }
    
    func createCargoOrder(id : Int) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let body : Parameters = [
                "token" : token,
                "parent_id" : id,
                "parent_type" : "cargo_orders"
            ]
            
            Alamofire.request(Constant.api.accept_order, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            
                        } else if json["statusCode "].intValue == Constant.statusCode.phoneExist {
                            
                        }
                        
                        print("Accept order: \(json)")
                    }
                case .failure(let error):
                    print(error)
                    return
                }
            }
        }
    }

extension Date {
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
}

extension FriendLocationViewController {
    @objc func getAllFriends() {
        if let token = UserDefaults.standard.string(forKey: "token") {
            indicator.show()
            friends.removeAll()
            Alamofire.request(Constant.api.friends_list, method: .post, parameters: ["token" : token], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        print("Friends List: \(json)")
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            for friend in json["result"].arrayValue {
                                let temp = User()
                                
                                temp.id = friend["id"].intValue
                                temp.surname = friend["surname"].stringValue
                                temp.name = friend["name"].stringValue
                                temp.phone = friend["phone"].stringValue
                                temp.token = friend["token"].stringValue
                                temp.lat = friend["lat"].stringValue
                                temp.lon = friend["lon"].stringValue
                                
                                self.friends.append(temp)
                            }
                            
                            self.tableView.reloadData()
                            indicator.dismiss()
                            self.refresh.endRefreshing()
                        } else {
                            indicator.dismiss()
                            self.refresh.endRefreshing()
                        }
                    }
                } else {
                    print("some error", response.error!)
                    self.refresh.endRefreshing()
                }
            }
        }
    }
}

extension AddFriendViewController {
    @objc
    func addFriend() {
        indicator.show()
        if let phoneNumber = phoneNumber.text, let token = UserDefaults.standard.string(forKey: "token") {
            let phone = String(phoneNumber.suffix(phoneNumber.count - 1))
            Alamofire.request(Constant.api.add_friend, method: .post, parameters: ["token": token, "friend_phone": phone.removingWhitespaces()], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            self.navigationController?.popViewController(animated: true)
                            indicator.showSuccess(withStatus: "Push sent.")
                            indicator.dismiss(withDelay: 1.5)
                        } else if json["statusCode "].intValue == Constant.statusCode.notFound {
                            indicator.showInfo(withStatus: "User with this phone number is founded.")
                            indicator.dismiss(withDelay: 1.5)
                        } else {
                            indicator.showError(withStatus: "Error")
                            indicator.dismiss(withDelay: 1.5)
                        }
                    }
                } else {
                    print("some error", response.error!)
                }
            })
        }
    }
}

extension VipTaxiViewController {
    func loadVipTaxi() {
        indicator.show(withStatus: "Loading...")
        Alamofire.request(Constant.api.toy_cars).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        for car in json["result"].arrayValue {
                            let temp = VipTaxi()
                            
                            temp.id = car["id"].intValue
                            temp.type = car["type"].stringValue
                            temp.name = car["name"].stringValue
                            temp.phone = car["phone"].stringValue
                            temp.price = car["price"].stringValue
                            temp.car_mark_id = car["car_mark_id"].intValue
                            temp.car_mark = car["car_mark"].stringValue
                            temp.car_model_id = car["car_model_id"].intValue
                            temp.car_model = car["car_model"].stringValue
                            temp.year = car["year"].stringValue
                            
                            let color = CarColor()
                            color.id = car["color"]["id"].intValue
                            color.name_kk = car["color"]["name_kk"].stringValue
                            color.name_ru = car["color"]["name_ru"].stringValue
                            color.name_en = car["color"]["name_en"].stringValue
                            
                            temp.color = color
                            
                            for image in car["images"].arrayValue {
                                let path = image["path"].stringValue
                                let startIndex = path.index(path.startIndex, offsetBy: 14)
                                let url = path[startIndex...]
                                
                                temp.imageURLs = [String]()
                                temp.imageURLs?.append(Constant.api.images + url)
                                
                                print(Constant.api.images + url)
                            }
                            
                            self.list.append(temp)
                            self.tableView.reloadData()
                            indicator.dismiss()
                        }
                    }
                }
            }
        }
    }
}

extension NotificationsViewController {
    func loadNotifications() {
        Alamofire.request(Constant.api.notifications).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        print("Notifications: \(json)")
                        var tempList = [Notification]()
                        for notification in json["result"].arrayValue {
                            print("hiiiiiiiii")
                            let temp = Notification()
                            
                            temp.id = notification["id"].intValue
                            temp.title = notification["title"].stringValue
                            temp.text = notification["text"].stringValue
                            
                            let image = notification["image"].stringValue
                            let startIndex = image.index(image.startIndex, offsetBy: 14)
                            let url = image[startIndex...]
                            temp.image = Constant.api.images + url
                            
                            temp.created_at = notification["created_at"].stringValue
                            temp.updated_at = notification["updated_at"].stringValue
                            
                            tempList.append(temp)
                        }
                        self.list = tempList
                        self.refresh.endRefreshing()
                        self.tableView.reloadData()
                    } else {
                        print("some error")
                    }
                }
            }
        }
    }
}

extension DriverCargoListCell {
    @objc func getAllCargoList() {
        let indicator = SVProgressHUD.self
        indicator.show(withStatus: "Loading...")
        Alamofire.request(Constant.api.cargo_list).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        let cargoArray = json["result"].arrayValue
                        
                        self.list.removeAll()
                        
                        for cargo in cargoArray {
                            let temp = Cargo()
                            
                            temp.id = cargo["id"].intValue
                            temp.type = cargo["type"].stringValue
                            
                            let passenger = User()
                            
                            passenger.id = cargo["passenger"]["id"].intValue
                            passenger.surname = cargo["passenger"]["surname"].stringValue
                            passenger.name = cargo["passenger"]["name"].stringValue
                            passenger.middle_name = cargo["passenger"]["middle_name"].stringValue
                            passenger.phone = cargo["passenger"]["phone"].stringValue
                            passenger.role = cargo["passenger"]["role"].intValue
                            passenger.city_id = cargo["passenger"]["city_id"].intValue
                            passenger.city = cargo["passenger"]["city"].stringValue
                            passenger.lat = cargo["passenger"]["lat"].stringValue
                            passenger.lon = cargo["passenger"]["lon"].stringValue
                            passenger.avatar = cargo["passenger"]["avatar"].stringValue
                            passenger.token = cargo["passenger"]["token"].stringValue
                            passenger.promo_code = cargo["passenger"]["promo_code"].stringValue
                            passenger.balanse = cargo["passenger"]["balanse"].intValue
                            passenger.online = cargo["passenger"]["online"].intValue
                            passenger.iin = cargo["passenger"]["iin"].stringValue
                            passenger.id_card = cargo["passenger"]["id_card"].stringValue
                            passenger.expired_date = cargo["passenger"]["expired_date"].stringValue
                            passenger.year = cargo["passenger"]["year"].intValue
                            passenger.driver_was = cargo["passenger"]["driver_was"].intValue
                            passenger.tech_passport = cargo["passenger"]["tech_passport"].stringValue
                            passenger.rating = cargo["passenger"]["rating"].stringValue
                            passenger.socket_id = cargo["passenger"]["socket_id"].intValue
                            //                            passenger.taxi_cars = cargo["passenger"]["taxi_cars"].
                            
                            temp.passenger = passenger
                            temp.driver_id = cargo["driver_id"].intValue
                            temp.from = cargo["from"].stringValue
                            temp.to = cargo["to"].stringValue
                            temp.price = cargo["price"].intValue
                            temp.text = cargo["text"].stringValue
                            temp.document = cargo["document"].intValue
                            temp.bargain = cargo["bargain"].intValue
//                            temp.date = cargo["date"].stringValue
                            temp.status = cargo["status"].intValue
                            temp.step = cargo["step"].intValue
                            
                            self.list.append(temp)
                            self.tableView.reloadData()
                            self.refresh.endRefreshing()
                            indicator.dismiss()
                        }
                    }
                    else {
                        indicator.showInfo(withStatus: "Empty")
                        indicator.dismiss(withDelay: 1.5)
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}

extension DriverOrderViewController {
    func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        let parameters : [String : String] = ["key" : "\(GMS_API_KEY)", "sensor" : "false", "mode" : "driving", "alternatives" : "false", "origin" : "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)", "destination" : "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"]
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?mode=driving")
        
        Alamofire.request(url!, method: .get, parameters: parameters).responseJSON { (response) in
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            // print route using Polyline
            for route in routes {
                self.polyline?.map = nil
                
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                self.polyline = GMSPolyline.init(path: path)
                self.polyline?.strokeWidth = 4
                self.polyline?.strokeColor = .blue
                self.polyline?.map = self.mapsView
            }
        }
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension DriverCargoAcceptedListCell {
    func getAllCargoList() {
        let indicator = SVProgressHUD.self
        indicator.show(withStatus: "Loading...")
        Alamofire.request(Constant.api.cargo_list).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        let cargoArray = json["result"].arrayValue
                        
                        for cargo in cargoArray {
                            let temp = Cargo()
                            
                            temp.id = cargo["id"].intValue
                            temp.type = cargo["type"].stringValue
                            
                            let passenger = User()
                            
                            passenger.id = cargo["passenger"]["id"].intValue
                            passenger.surname = cargo["passenger"]["surname"].stringValue
                            passenger.name = cargo["passenger"]["name"].stringValue
                            passenger.middle_name = cargo["passenger"]["middle_name"].stringValue
                            passenger.phone = cargo["passenger"]["phone"].stringValue
                            passenger.role = cargo["passenger"]["role"].intValue
                            passenger.city_id = cargo["passenger"]["city_id"].intValue
                            passenger.city = cargo["passenger"]["city"].stringValue
                            passenger.lat = cargo["passenger"]["lat"].stringValue
                            passenger.lon = cargo["passenger"]["lon"].stringValue
                            passenger.avatar = cargo["passenger"]["avatar"].stringValue
                            passenger.token = cargo["passenger"]["token"].stringValue
                            passenger.promo_code = cargo["passenger"]["promo_code"].stringValue
                            passenger.balanse = cargo["passenger"]["balanse"].intValue
                            passenger.online = cargo["passenger"]["online"].intValue
                            passenger.iin = cargo["passenger"]["iin"].stringValue
                            passenger.id_card = cargo["passenger"]["id_card"].stringValue
                            passenger.expired_date = cargo["passenger"]["expired_date"].stringValue
                            passenger.year = cargo["passenger"]["year"].intValue
                            passenger.driver_was = cargo["passenger"]["driver_was"].intValue
                            passenger.tech_passport = cargo["passenger"]["tech_passport"].stringValue
                            passenger.rating = cargo["passenger"]["rating"].stringValue
                            passenger.socket_id = cargo["passenger"]["socket_id"].intValue
                            //                            passenger.taxi_cars = cargo["passenger"]["taxi_cars"].
                            
                            temp.passenger = passenger
                            temp.driver_id = cargo["driver_id"].intValue
                            temp.from = cargo["from"].stringValue
                            temp.to = cargo["to"].stringValue
                            temp.price = cargo["price"].intValue
                            temp.text = cargo["text"].stringValue
                            temp.document = cargo["document"].intValue
                            temp.bargain = cargo["bargain"].intValue
                            //                            temp.date = cargo["date"].stringValue
                            temp.status = cargo["status"].intValue
                            temp.step = cargo["step"].intValue
                            
                            self.temp.append(temp)
//                            self.tableView.reloadData()
                            indicator.dismiss()
                        }
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}

extension DriverIntercityCell {
    static func createOrderLabel(with image : UIImage, placeholder : String) -> UITextField {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 15, y: 0, width: 18, height: 22)
        imageView.tintColor = .blue
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: 40, height: 25))
        view.addSubview(imageView)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.leftView = view
        textField.leftView?.frame = view.frame
        textField.leftViewMode = .always
        textField.isUserInteractionEnabled = false
        
        return textField
    }
}

extension DriverOrdersTableCell {
    static func createOrderLabel(with image : UIImage, placeholder : String) -> UITextField {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = CGRect(x: 15, y: 0, width: 20, height: 25)
        imageView.tintColor = .blue
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: 40, height: 17))
        view.addSubview(imageView)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.leftView = view
        textField.leftView?.frame = view.frame
        textField.leftViewMode = .always
        textField.isUserInteractionEnabled = false
        
        return textField
    }
}

extension DriverToyCell {
    static func createOrderLabel(with image : UIImage, placeholder : String) -> UITextField {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = CGRect(x: 15, y: 0, width: 25, height: 25)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .blue
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: 50, height: 27))
        view.addSubview(imageView)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.leftView = view
        textField.leftView?.frame = view.frame
        textField.leftViewMode = .always
        textField.isUserInteractionEnabled = false
        
        return textField
    }
}

extension FreeAutoWithImageCell {
    static func createOrderLabel(with image : UIImage, placeholder : String) -> UITextField {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = CGRect(x: 15, y: 0, width: 20, height: 20)
        imageView.tintColor = .blue
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: 40, height: 17))
        view.addSubview(imageView)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.leftView = view
        textField.leftView?.frame = view.frame
        textField.leftViewMode = .always
        textField.isUserInteractionEnabled = false
        
        return textField
    }
}

extension DriverFreeAutoWithImageCell {
    static func createOrderLabel(with image : UIImage, placeholder : String) -> UITextField {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = CGRect(x: 15, y: 0, width: 20, height: 25)
        imageView.tintColor = .blue
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: 40, height: 22))
        view.addSubview(imageView)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.leftView = view
        textField.leftView?.frame = view.frame
        textField.leftViewMode = .always
        textField.isUserInteractionEnabled = false
        
        return textField
    }
}

extension DriverCargoCell {
    static func createOrderLabel(with image : UIImage, placeholder : String) -> UITextField {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = CGRect(x: 15, y: 0, width: 15, height: 17)
        imageView.tintColor = .blue
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: 40, height: 17))
        view.addSubview(imageView)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .black
        textField.leftView = view
        textField.leftView?.frame = view.frame
        textField.leftViewMode = .always
        textField.isUserInteractionEnabled = false
        
        return textField
    }
}
