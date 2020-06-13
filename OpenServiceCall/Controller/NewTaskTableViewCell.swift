
import UIKit

class NewTaskTableViewCell: UITableViewCell {

    // Button Outlet
    @IBOutlet weak var buttonViewOutlet: UIButton!

    // Label Outlet
    @IBOutlet weak var labelTaskOutlet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        buttonViewOutlet.buttonLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
