//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public class ImageView: UIImageView {
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(frame: CGRect, cornerRadius: CGFloat = 0) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
