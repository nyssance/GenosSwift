//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public class PasswordTextField: UITextField {
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        keyboardType = .asciiCapable
        isSecureTextEntry = true
        // 密码小眼睛
        let button = UIButton(frame: CGRect(origin: .zero, size: .settingsIcon))
        button.setIcon(icon: .fontAwesomeSolid(.eyeSlash), color: .gray, forState: .normal)
        button.setIcon(icon: .fontAwesomeSolid(.eye), color: APP_THEME.colorPrimary, forState: .selected)
        button.setIcon(icon: .fontAwesomeSolid(.eye), color: APP_THEME.colorPrimary, forState: [.selected, .highlighted])
        button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
    }

    @objc
    func toggle() {
        // SO https://stackoverflow.com/questions/35293379/uitextfield-securetextentry-toggle-set-incorrect-font
        resignFirstResponder()
        isSecureTextEntry.toggle()
        becomeFirstResponder()
        (rightView as? UIButton)?.let {
            $0.isSelected.toggle()
        }
    }
}
