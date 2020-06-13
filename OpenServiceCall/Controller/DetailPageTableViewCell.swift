
import UIKit

class DetailPageTableViewCell: UITableViewCell {

    // Label Outlet
    @IBOutlet weak var textLabelOutlet: UILabel!
    @IBOutlet weak var detailTextLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        //set cell to initial state here
        //set like button to initial state - title, font, color, etc.
        
        textLabelOutlet.text = ""
        detailTextLabelOutlet.text = ""
        accessoryView = nil
    }

}
