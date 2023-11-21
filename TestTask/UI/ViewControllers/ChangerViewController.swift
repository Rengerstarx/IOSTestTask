//
//  ChangerViewController.swift
//  TestTask
//
//  Created by sergey on 11/14/23.
//

import UIKit
import TinyConstraints

class ChangerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var taperLoopa = UITapGestureRecognizer()
    var taperArrow = UITapGestureRecognizer()
    
    //ViewTop:
    let viewTop = UIView()
    let imageLoopa = UIImageView(image: UIImage(named: "loopa"))
    let imageArrow = UIImageView(image: UIImage(named: "arrow"))
    let lableTop = UILabel()
    
    //UICollectionView
    var collectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    
    //Color
    let mainBlue = UIColor(named: "mainBlue")
    let backGrey = UIColor(named: "mainBackGrey")
    
    //Local var
    var arrayCity = [City]()
    var count = 0
    var selectedString = ""
    
    //UserDefaults
    let defaults = UserDefaults()
    let defaultsString = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taperLoopa = UITapGestureRecognizer(target: self, action: #selector(trigerLoopa))
        taperArrow = UITapGestureRecognizer(target: self, action: #selector(trigerArrow))
        
        selectedString = defaultsString.string(forKey: "Selected") ?? ""
        arrayCity = ParsCities().parser()
        
        let lbl  = selectedString != "selectedCrypto" ? "Выбор города" : "Выбор криптовалюты"
        initTopView(lbl)
        
        if lbl == "Выбор города" {
            initUICollectionView()
        }
        else{
            let child = CryptoCollectionView()
            addChild(child)
            view.addSubview(child.view)
            child.view.bottomToSuperview()
            child.view.leftToSuperview()
            child.view.rightToSuperview()
            child.view.topToBottom(of: viewTop)
        }
        
    }
    
    private func initUICollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(UICityCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = backGrey
        view.addSubview(collectionView)
        collectionView.topToBottom(of: viewTop)
        collectionView.leftToSuperview()
        collectionView.rightToSuperview()
        collectionView.bottomToSuperview(/*offset: 10*/)
    }
    
    private func initTopView(_ lable: String){
        view.addSubview(viewTop)
        viewTop.backgroundColor = mainBlue
        
        viewTop.edgesToSuperview(excluding: .bottom)
        viewTop.height(90)
        
        viewTop.addSubview(lableTop)
        lableTop.text = lable
        lableTop.textColor = .white
        lableTop.font = UIFont.systemFont(ofSize: 24)
        lableTop.bottomToSuperview(offset: -10)
        lableTop.centerXToSuperview()
        
        viewTop.addSubview(imageLoopa)
        imageLoopa.isUserInteractionEnabled = true
        imageLoopa.addGestureRecognizer(taperLoopa)    
        imageLoopa.bottomToSuperview(offset: -10)
        //imageArrow.centerY(to: lableTop)
        imageLoopa.rightToSuperview(offset: -15)
        
        viewTop.addSubview(imageArrow)
        imageArrow.isUserInteractionEnabled = true
        imageArrow.addGestureRecognizer(taperArrow)
        imageArrow.bottomToSuperview(offset: -10)
        //imageArrow.centerY(to: lableTop)
        imageArrow.leftToSuperview(offset: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCity.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        if count >= arrayCity.count{
            return cell
        }
        cell.backgroundColor = .white
        //LabelCode
        let lableCode = UILabel(frame: cell.contentView.bounds)
        lableCode.textColor = .black
        lableCode.font = UIFont.systemFont(ofSize: 22)
        lableCode.text = arrayCity[count].code
        cell.addSubview(lableCode)
        lableCode.leftToSuperview(offset: 15)
        lableCode.centerYToSuperview()
        //LabelCity
        let lableCity = UILabel(frame: cell.contentView.bounds)
        //lableCity.textAlignment = .center
        lableCity.textColor = .black
        lableCity.font = UIFont.systemFont(ofSize: 18)
        lableCity.text = arrayCity[count].name
        cell.contentView.addSubview(lableCity)
        lableCity.leftToRight(of: lableCode, offset: 15)
        lableCity.centerYToSuperview()
        count += 1
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let encodedPerson = try? encoder.encode(arrayCity[indexPath.item]) {
            defaults.set(encodedPerson, forKey: selectedString)
        }
        let viewController = ViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func trigerLoopa(){
        
    }
    
    @objc func trigerArrow(){
        let viewController = ViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    private func alert(){
        let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при получении информации о текущей валюте. Пожалуйста попробуйте снова ^_^", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
    }
}
