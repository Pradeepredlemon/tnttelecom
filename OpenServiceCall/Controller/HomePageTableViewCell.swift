
import UIKit

class HomePageTableViewCell: UITableViewCell {

    // Label Outlet
    @IBOutlet weak var labelTaskOutlet: UILabel!
    
    // Button Outlet
    @IBOutlet weak var buttonViewOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonViewOutlet.buttonLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
