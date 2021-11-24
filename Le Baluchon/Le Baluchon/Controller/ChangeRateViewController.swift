
import UIKit

class ChangeRateViewController: UIViewController {

    var currentChangeRate: ChangeRate?

    var currentDate: String {
        getCurrentDate()
    }

//MARK: - Outlets
    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        makeConvertButtonCornersRounded()
        setSegmentedControlAspect()
    }

//MARK: - Functions
    @IBAction func toggleConvertButton(_ sender: UIButton) {
        switch currencySegmentedControl.selectedSegmentIndex {
        case 0:
            updateCurrencyTextField(dollarsTextField)
        case 1:
            updateCurrencyTextField(eurosTextField)
        default:
            break
        }
    }

    private func updateCurrencyTextField(_ currencyTextField: UITextField) {
        currencyTextField.text = ""
        currencyTextField.text = convert()
    }

    private func convert() -> String? {

        guard let changeRate = currentChangeRate, changeRate.date == currentDate else {
            toggleActivityIndicator(shown: true)
            obtainCurrentChangeRate()
            return nil
        }
        let rate = changeRate.rates.USD

        switch currencySegmentedControl.selectedSegmentIndex {
        case 0:
            guard let eurosTextFieldText = eurosTextField.text else {
                emptyTextFieldAlert()
                return nil
            }
            guard let eurosAmount = Double(eurosTextFieldText) else {
                return nil
            }
            let result = eurosAmount * rate
            let resultToDisplay = String(result)
            return resultToDisplay
        case 1:
            guard let dollarsTextFieldText = dollarsTextField.text else {
                emptyTextFieldAlert()
                return nil
            }
            guard let dollarsAmount = Double(dollarsTextFieldText) else {
                return nil
            }
            let result = dollarsAmount / rate
            let resultToDisplay = String(result)
            return resultToDisplay
        default:
            return nil
        }
    }

    private func obtainCurrentChangeRate() {
        ChangeRateService.shared.getChangeRate { result in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false)
            }
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.errorAlert()
                }
            case .success(let changeRate):
                self.currentChangeRate = changeRate
            }
        }
    }

    private func getCurrentDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let currentDate = format.string(from: date)
        return currentDate
    }

//MARK: - Alerts
    private func errorAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il semble que le courant passe mal avec le serveur 🔌", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

    private func emptyTextFieldAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il faut d'abord entrer un montant pour le convertir 💵", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }

//MARK: - Aspect
    private func toggleActivityIndicator(shown: Bool) {
        convertButton.isHidden = shown
        activityIndicator.isHidden = !shown
        shown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    private func makeConvertButtonCornersRounded() {
        convertButton.layer.cornerRadius = 25.0
    }

    private func setSegmentedControlAspect() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        currencySegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
}

//MARK: - Keyboard Management
extension ChangeRateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        eurosTextField.resignFirstResponder()
        dollarsTextField.resignFirstResponder()
    }

}
