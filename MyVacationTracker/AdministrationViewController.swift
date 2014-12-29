import UIKit

class AdministrationViewController: UIViewController {

  @IBOutlet weak var startingBalanceTextField: UITextField!
  @IBOutlet weak var accrualRateTextField: UITextField!

  override func viewWillAppear(animated: Bool) {
    var startingBalancePtoItem: PTOItem = PTOItem.getStartingBalancePtoItem()
    startingBalanceTextField.text = "\(startingBalancePtoItem.hours)"

    accrualRateTextField.text = "6.0"
  }

  @IBAction func saveButtonPressed(sender: AnyObject) {
    var startingBalancePtoItem: PTOItem = PTOItem.getStartingBalancePtoItem()
    startingBalancePtoItem.hours = (startingBalanceTextField.text as NSString).doubleValue
    saveDatabase(getManagedObjectContext())
    showSuccess()
  }

  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    self.view.endEditing(true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let directions = [
      UISwipeGestureRecognizerDirection.Up,
      UISwipeGestureRecognizerDirection.Down,
      UISwipeGestureRecognizerDirection.Right,
      UISwipeGestureRecognizerDirection.Left
    ]

    for direction in directions {
      var swipe = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
      swipe.direction = direction
      self.view.addGestureRecognizer(swipe)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  private func showSuccess() {
    let alert = UIAlertController(title: "Updated", message: "Updates made. Go to Balance tab to see update.", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

extension AdministrationViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == startingBalanceTextField {
      accrualRateTextField.becomeFirstResponder()
    } else if textField == accrualRateTextField {
      saveButtonPressed(UIButton())
    }
    return false
  }
}


