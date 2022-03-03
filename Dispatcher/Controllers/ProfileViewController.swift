import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var optionsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(for: Constants.ScreenNames.profile)
    }
    
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.goToUpdateProfile, sender: self)
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == Constants.Segues.goToUpdateProfile {
            let destinationVC = segue.destination as! ViewProfileViewController
            //destinationVC.variableName = valueToSet // pass any variables?
        }
      }
}

//MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return optionsArray.count
       }
    
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)

           //cell.textLabel?.text = itemArray[indexPath.row]
           return cell
       }
}

//MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
