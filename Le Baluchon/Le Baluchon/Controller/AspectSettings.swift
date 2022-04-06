
import Foundation
import UIKit

class AspectSettings {

    // MARK: - Functions

    func setButtonAspect(for button: UIButton) {
        button.layer.cornerRadius = 25.0
    }

    func setSegmentedControlAspect(for segmentedControl: UISegmentedControl) {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
}
