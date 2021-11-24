
import UIKit

class ChangeRateViewController: UIViewController {

    var currentChangeRate: ChangeRate? {
        didSet {
            DispatchQueue.main.async {
                self.updateDollarsTextField()
            }
        }
    }

    var currentDate: String {
        getCurrentDate()
    }

//MARK: - Outlets
    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        makeConvertButtonCornersRounded()
    }

//MARK: - Functions
    @IBAction func toggleConvertButton(_ sender: UIButton) {
        updateDollarsTextField()
        print(currentDate)
    }

    private func updateDollarsTextField() {
        dollarsTextField.text = ""
        dollarsTextField.text = convertEurtoUSD()
    }

    private func convertEurtoUSD() -> String? {

        guard let changeRate = currentChangeRate else {
            toggleActivityIndicator(shown: true)
            obtainCurrentChangeRate()
            return nil
        }
        guard let eurosTextFieldText = eurosTextField.text else {
            return nil
        }
        guard let eurosAmount = Double(eurosTextFieldText) else {
            return nil
        }

        let rate = changeRate.rates.USD
        let result = eurosAmount * rate
        let resultToDisplay = String(result)
        
        return resultToDisplay
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

//MARK: - Alert
    private func errorAlert() {
        let alert = UIAlertController(title: "Erreur", message: "Il semble que le courant passe mal avec le serveur...", preferredStyle: .alert)
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
