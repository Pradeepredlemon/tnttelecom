
import UIKit

class NewTaskDetailPageTableViewCell: UITableViewCell {

    // Label Outlet
    @IBOutlet weak var textLabelOutlet: UILabel!
    @IBOutlet weak var detailTextLabelOutlet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
