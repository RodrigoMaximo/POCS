import UIKit

class ViewController: UIViewController {

    var actions: [Action] = [
        Action(id: "action1", name: "Change Color", color: .blue),
        Action(id: "action2", name: "Change Size", color: .green),
        Action(id: "action3", name: "Change Size & Color", color: .red)
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
        performAction(ofRow: indexPath.row)
    }
}

