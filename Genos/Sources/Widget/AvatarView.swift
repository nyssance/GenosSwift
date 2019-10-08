//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public class AvatarView: UIView {
    public var avatar: ImageView!

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        avatar = ImageView(frame: CGRect(x: frame.width / 2 - 30, y: frame.height / 2 - 30, width: 60, height: 60), cornerRadius: 30)
        addSubview(avatar)
    }
}
