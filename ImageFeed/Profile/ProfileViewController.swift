import UIKit


final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImageView = createProfileImage()
        
        view.addSubview(profileImageView)
        
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let exitButton = createExitButton()
        
        view.addSubview(exitButton)
        
        exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        
        let nameLabel = createNameLabel()
        view.insertSubview(nameLabel, belowSubview: exitButton)
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let usernameLabel = createUsernameLabel()
        view.insertSubview(usernameLabel, belowSubview: nameLabel)
        
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let summaryLabel = createSummaryLabel()
        view.insertSubview(summaryLabel, belowSubview: usernameLabel)
        
        summaryLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        summaryLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func createProfileImage() -> UIImageView {
        let profileImageView = UIImageView(image: UIImage(named: "Profiles") ?? UIImage())
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    
        return profileImageView
    }
    
    private func createExitButton() -> UIButton {
        let exitButton = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!, target: self, action: nil)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.tintColor = UIColor(named: "YP Red") ?? UIColor.red
        
        return exitButton
    }
    
    private func createNameLabel() -> UILabel {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White") ?? UIColor.white
        nameLabel.font = nameLabel.font.withSize(23)
        return nameLabel
    }
    
    private func createUsernameLabel() -> UILabel {
        let usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = "@ekaterina_nov"
        usernameLabel.textColor = UIColor(named: "YP Gray") ?? UIColor.gray
        usernameLabel.font = usernameLabel.font.withSize(13)
        return usernameLabel
    }
    
    private func createSummaryLabel() -> UILabel {
        let summaryLabel = UILabel()
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.text = "Hello, World!"
        summaryLabel.textColor = UIColor(named: "YP White") ?? UIColor.white
        summaryLabel.font = summaryLabel.font.withSize(13)
        return summaryLabel
    }
}
