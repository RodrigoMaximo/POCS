import UIKit

class CollectionViewCell: UICollectionViewCell {

    struct ActionViewModel {
        var title: String
        var color: UIColor
    }

    var action: ActionViewModel?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupContentView()
    }

    func render(action: ActionViewModel) {
        self.action = action
        setupTitleLabel()
        setupColor()
    }

    func animateColor() {
        guard let action = self.action else {
            fatalError("Render Method must be called before calling `animate()` method.")
        }
        let animationColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        let timeAnimation: TimeInterval = 1.0
        UIView.animate(withDuration: timeAnimation, animations: {
            self.containerView.backgroundColor = animationColor
        }) { _ in
            UIView.animate(withDuration: timeAnimation, animations: {
                self.containerView.backgroundColor = action.color
            }) { _ in
                UIView.animate(withDuration: timeAnimation, animations: {
                    self.containerView.backgroundColor = animationColor
                }) { _ in
                    UIView.animate(withDuration: timeAnimation, animations: {
                        self.containerView.backgroundColor = action.color
                    })
                }
            }
        }
    }

    func animateSize() {
        guard let _ = self.action else {
            fatalError("Render Method must be called before calling `animate()` method.")
        }
        let newWidth: CGFloat = 200
        let oldWidth: CGFloat = self.widthConstraint.constant
        let timeAnimation: TimeInterval = 1.0
        let delay: TimeInterval = 0.0
        let damping: CGFloat = 0.5
        let initialSpringVelocity: CGFloat = 3.0
        
        self.widthConstraint.constant = newWidth
        UIView.animate(withDuration: timeAnimation, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.widthConstraint.constant = oldWidth
            UIView.animate(withDuration: timeAnimation, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    private func setupContentView() {
        self.containerView.layer.cornerRadius = 10
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
        self.contentView.layer.shadowColor = UIColor.gray.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contentView.layer.shadowOpacity = 0.9
        self.contentView.layer.shadowRadius = 7
    }

    private func setupTitleLabel() {
        titleLabel.text = action?.title ?? ""
    }

    private func setupColor() {
        containerView.backgroundColor = action?.color ?? .white
    }
}
