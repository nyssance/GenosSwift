//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class SignInController<D: Decodable, V: UITableViewCell>: BaseSign<D, V> {
    // MARK: - 💖 生命周期 (Lifecycle)

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        submitButton.setTitle("sign_in".locale, for: .normal)
    }

    // MARK: - 🐤 Taylor

    open override func onCreate() {
        super.onCreate()
        title = "sign_in".locale
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
    }
}
