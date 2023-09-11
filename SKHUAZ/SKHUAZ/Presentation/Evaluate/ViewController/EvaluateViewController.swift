//
//  EvaluateViewController.swift
//  SKHUAZ
//
//  Created by 천성우 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

class EvaluateViewController: UIViewController {
    
    //MARK: - UI Components
    
    private let mainLogo = UIImageView()
    private let titleLabel = UILabel()
    private let searchTextField = UITextField()
    private lazy var tableView = UITableView(frame:.zero, style:.plain)
    private let createButton = UIButton()
    private let wroteMeButton = UIButton()
    
    //MARK: - Properties
    
    private var wroteMeButtonBottomConstraint: Constraint?
    private var isMove: Bool = false
    private var isTouch: Bool = false
    private var filteredReviews: [EvaluateDataModel]!
    var reviews: [EvaluateDataModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setUI()
        setLayout()
        setRegister()
        setDelegate()
        addTarget()
    }
}

extension EvaluateViewController {
    
    // MARK: - UI Components Property

    private func setUI() {
        
        view.backgroundColor = .white
        
        mainLogo.do {
            $0.contentMode = .scaleAspectFit
            $0.image = Image.Logo1
        }
        
        titleLabel.do {
            $0.text = "강의평"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 16)
        }
        
        searchTextField.do {
            $0.placeholder = "검색어를 입력해주세요"
            $0.font = .systemFont(ofSize: 8)
            $0.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1)
            $0.borderStyle = .roundedRect
        }
        
        tableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
        
        createButton.do {
            $0.setImage(Image.CreateButton, for: .normal)
        }
        
        wroteMeButton.do {
            $0.setImage(Image.WritingOff, for: .normal)
        }
    }
    
    // MARK: - Layout Helper

    private func setLayout() {
        
        view.addSubviews(mainLogo, titleLabel, searchTextField, tableView, wroteMeButton, createButton)
        
        mainLogo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(47)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(43)
            $0.width.equalTo(168)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mainLogo.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(39)
            $0.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        createButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(104)
            $0.width.height.equalTo(56)
        }
        
        wroteMeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            self.wroteMeButtonBottomConstraint = $0.bottom.equalToSuperview().inset(104).constraint
            $0.width.height.equalTo(56)
        }
    }
    
    // MARK: - Methods

    private func setupData() {
        reviews = [review1, review2, review3, review4, review5, review6]
        filteredReviews = reviews
    }
    
    private func setRegister() {
        tableView.register(EvaluateTableViewCell.self,
                           forCellReuseIdentifier:"evaluateCell")
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self

    }
    
    private func addTarget() {
        createButton.addTarget(self, action: #selector(movewroteMeButton), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        wroteMeButton.addTarget(self, action: #selector(wroteMeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func wroteMeButtonTapped() {
        isTouch.toggle()
        if isTouch {
            wroteMeButton.setImage(Image.WritingOn, for: .normal)
            searchTextField.text = "천성우"
            searchTextChanged()
        } else {
            wroteMeButton.setImage(Image.WritingOff, for: .normal)
            searchTextField.text = ""
            searchTextChanged()
        }
    }
    
    @objc
    private func movewroteMeButton() {
        isMove.toggle()
        if isMove {
            self.wroteMeButtonBottomConstraint?.update(inset: 168)
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
        else if !isMove {
            let vc = CreateEvaluateViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            self.wroteMeButtonBottomConstraint?.update(inset: 104)
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
        print(isMove)
    }
    
    @objc
    private func searchTextChanged() {
        
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            filteredReviews = reviews
            tableView.reloadData()
            return
        }
        
        filteredReviews = reviews.filter { review in
            return review.department.contains(searchText) ||
            review.lectureNameLabel.contains(searchText) ||
            review.title.contains(searchText) ||
            review.authorNameLabel.contains(searchText) ||
            review.professorNameLabel.contains(searchText)
        }
        
        tableView.reloadData()
    }
}

extension EvaluateViewController: UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isUserInteractionEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isUserInteractionEnabled = true
    }
}

extension EvaluateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
       return filteredReviews.count
    }

    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier:"evaluateCell",for:indexPath) as! EvaluateTableViewCell
       let review = filteredReviews[indexPath.row]
       cell.configure(with:review)

       return cell
    }
    
    
    
    func tableView(_ tableview:UITableView,didSelectRowAt indexPath:IndexPath){
        print("You selected cell #\(reviews[indexPath.row].title)")
        let detailVC = DetailEvaluateViewController()
        // 필요한 경우 detailVC의 데이터를 설정할 수 있
        // ex) detailVC.dataModel = dataModels[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
