//
//  EditNameOrNicknameVC.swift
//  teacher
//
//  Created by 汪俊 on 2018/5/22.
//
import UIKit

@objc enum EditVCType: Int {
    case name, nickName
}

// MARK: - EditNameOrNicknameVCDelegate
@objc protocol EditNameOrNicknameVCDelegate {
    func editNameOrNicknameVCDidClickSave(inputString: String, editType: EditVCType)
}

// MARK: - life cycle
@objc class EditNameOrNicknameVC: UIViewController {
    
    @objc weak var weakDelegate: EditNameOrNicknameVCDelegate?
    @IBOutlet weak var inputTextField: UITextField! // 输入姓名或昵称的TextField
    @IBOutlet weak var descriptionLabel: UILabel! // 关于姓名或昵称的描述
    var editType: EditVCType!
    var inputString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 重置控件的属性
        self.resetControlsAttribute()
        // 根据EditVCType初始化数据
        self.resetData()
        // 设置右上角的保存按钮
        self.initNavigationBarButton()
    }
    
    // 快速实例化方法
    // 返回枚举为name的VC
    @objc static func editNameVC(inputString: String) -> EditNameOrNicknameVC {
        let editVC = EditNameOrNicknameVC.init()
        editVC.editType = .name
        editVC.inputString = inputString
        return editVC
    }
    // 返回枚举为nickname的VC
    @objc static func editNicknameVC(inputString: String) -> EditNameOrNicknameVC {
        let editVC = EditNameOrNicknameVC.init()
        editVC.editType = .nickName
        editVC.inputString = inputString
        return editVC
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { // swift里面 - 在iOS8下，也需要给控制器的xib重写一下init 方法，只记得在自定义view的是时候用过，没想到这里也需要，特意加上，兼容手机系统8.0
        super.init(nibName: "EditNameOrNicknameVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private
private extension EditNameOrNicknameVC {
    // 代码重置属性
    func resetControlsAttribute() {
        // 初始化设置inputTextField的属性
        self.inputTextField?.font = UIFont.systemFont(ofSize: 14)
        self.inputTextField?.textColor = UIColor.orange
        self.inputTextField?.clearButtonMode = .whileEditing
        if (self.inputString != nil && !self.inputString.isEmpty) {
            self.inputTextField?.text = self.inputString
        }
        // 监听文字输入 - 用于红色提示
        self.inputTextField?.addTarget(self, action: #selector(self.textFieldFontDidChange), for: .editingChanged)
        // 初始化设置descriptionLabel的属性
        self.descriptionLabel?.font = UIFont.systemFont(ofSize: 14)
        self.descriptionLabel?.textColor = UIColor.orange
    }
    
    @objc func textFieldFontDidChange() {
        // 根据具体需求确认红字显示与否
        if (!(self.inputTextField?.text?.isEmpty)!) {
            self.inputTextField?.attributedPlaceholder = nil
            if (self.editType == .name) {
                self.inputTextField?.placeholder = "请输入您的真实姓名"
            } else if (self.editType == .nickName) {
                self.inputTextField?.placeholder = "请输入您的昵称"
            }
            var inputText = NSString(cString: (self.inputTextField?.text!)!, encoding: String.Encoding.utf8.rawValue)
            if ((inputText?.length)! > 16) {
                inputText = inputText!.substring(to: 16) as NSString
                self.inputTextField?.text = String(inputText!)
            }
        }
    }
    
    // 确认当前的类型是姓名还是昵称来选择不同的值
    func resetData() {
        if (self.editType == nil) {
            self.editType = .name
        }
        self.resetEditVCTypeData(editType: self.editType)
    }
    
    // 确认当前的类型是姓名还是昵称来选择不同的值 - 子方法
    func resetEditVCTypeData(editType: EditVCType) {
        switch editType {
        case .name:
//            self.navTitleString = "姓名"
            self.inputTextField?.placeholder = "请输入您的真实姓名"
            self.descriptionLabel?.text = "请与您身份证上的姓名保持一致，否则将无法通过实名认证"
            break
        case .nickName:
//            self.navTitleString = "昵称"
            self.inputTextField?.placeholder = "请输入您的昵称"
            self.descriptionLabel?.text = "请输入16字以内的昵称，好的昵称会让家长对您的印象更加深刻"
            break
        }
    }
    
    // 右侧保存按钮
    func initNavigationBarButton () {
        // 左边返回按钮
//        self.setNavLeftItemWithImageName("icon_top_back", target: self, action: #selector(self.didClickOnBackButton))
        // 右边保存按钮
//        self.setNavRightItemWithTitle("保存") { [weak self] in
//            guard let `self` = self else {
//                return
//            }
//            self.view.endEditing(true)
//            let inputString = self.inputTextField?.text
//            if (inputString?.isEmpty)! {
//                if (self.editType == nil) {
//                    return
//                }
//                // 红字的提示文字
//                var waringString = "请输入姓名"
//                if (self.editType == .nickName) {
//                    waringString = "请输入昵称"
//                }
//                //设置文字颜色成红色，属性文本别的设置也几乎就是在这个字典中设置
//                let waringAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.red]
//                let waringAttrString: NSAttributedString  = NSAttributedString(string: waringString, attributes: waringAttribute)
//                self.inputTextField?.attributedPlaceholder = waringAttrString
//                
//                return
//            }
//            self.weakDelegate?.editNameOrNicknameVCDidClickSave(inputString: inputString!, editType: self.editType)
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    // 左侧返回按钮
    @objc func didClickOnBackButton() {
        // 如果输入为空的时候点击了返回按钮
        if (self.inputTextField?.text?.isEmpty)! { // 非空判断
            if (self.inputString == nil || (self.inputString?.isEmpty)!) {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
        if (self.inputTextField?.text == self.inputString) { // UAT修改 为没有修改返回不出现弹框，而不是是否为空
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.view.endEditing(true)
//        QQThemeAlertView.show(withTitle: nil, message: "您还未保存, 确认要退出吗?", options: ["我再想想", "确认退出"]) { [weak self] (index) -> ()  in
//            guard let `self` = self else {
//                return
//            }
//            if (index == 1) { // 点击确认退出的时候
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
    }
}

