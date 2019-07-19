import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    var actions: [Action] = [
        Action(id: "action1", name: "Change Color", color: .blue),
        Action(id: "action2", name: "Change Size", color: .green),
        Action(id: "action3", name: "Change Size & Color", color: .red),
        Action(id: "action4", name: "Face Id", color: .yellow)
    ]

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func performAction(activity: NSUserActivity, delayed: Bool = false) {
        if delayed {
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.performAllActions(activity: activity)
            }
        } else {
            self.performAllActions(activity: activity)
        }
    }
    
    fileprivate func performAllActions(activity: NSUserActivity) {
        for (index, action) in actions.enumerated() where action.name == activity.title {
            performAction(ofRow: index)
        }
    }

    fileprivate func performAction(ofRow row: Int) {
        setupIntents(of: actions[row])
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {
            return
        }
        switch row {
        case 0:
            cell.animateColor()
        case 1:
            cell.animateSize()
        case 2:
            cell.animateColor()
            cell.animateSize()
        default:
            break
        }
    }

    private func setupIntents(of action: Action) {
        let hasActionSaved = Persistence.getObject(of: action.id)
        guard hasActionSaved == false else {
            return
        }
        Persistence.save(action)
        let bundleAction = "com.rodrigomaximo.Movile.ShortCuts." + action.id
        let activity = NSUserActivity(activityType: bundleAction)
        activity.title = action.name
        activity.userInfo = ["Action": action.id]
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(bundleAction)
        view.userActivity = activity
        activity.becomeCurrent()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else {
            fatalError()
        }
        let action = actions[indexPath.row]
        let actionViewModel: CollectionViewCell.ActionViewModel = CollectionViewCell.ActionViewModel(title: action.name, color: action.color)
        cell.render(action: actionViewModel)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < actions.count - 1 else {
            faceId()
            return
        }
        performAction(ofRow: indexPath.row)
    }

    private func faceId() {
        let myContext = LAContext()
        var authError: NSError?
        guard #available(iOS 8.0, macOS 10.12.1, *) else {
            print("Ooops!!.. This feature is not supported.")
            return
        }
        guard myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
            print("Sorry!!.. Could not evaluate policy.")
            return
        }
        myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Insert touch Id.") { success, evaluateError in
            DispatchQueue.main.async {
                if success {
                    print("Awesome!!... User authenticated successfully")
                } else {
                    print("Sorry!!... User did not authenticate successfully")
                }
            }
        }
    }
}

