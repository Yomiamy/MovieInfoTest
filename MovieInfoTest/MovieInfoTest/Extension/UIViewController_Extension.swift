import UIKit

// MARK:- Public interface
extension UIViewController {
    func showLoading() {
        self.setActivityIndicatorView()
    }

    func closeLoading() {
        self.removeActivityIndicatorView()
    }
}

// MARK:- Private interface
fileprivate let loadingViewTag: Int = 1000
fileprivate let activityIndicatorViewTag: Int = 999

extension UIViewController {
    private var loadingView: UIView {
        let loadingView: UIView = {
            let loadingView = UIView()
            loadingView.tag = loadingViewTag
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.center = self.view.center
            loadingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4373481195)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            return loadingView
        }()
        
        return loadingView
    }
    
    private var activityIndicatorView: UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.tag = activityIndicatorViewTag
        activityIndicatorView.frame = CGRect(x: .zero, y: .zero, width: 40.0, height: 40.0)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.color = .white
        
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }

    private func setActivityIndicatorView() {
        guard !isDisplaying() else {
            return
        }
        
        // add overlay constraints
        self.view.addSubview(self.loadingView)
        self.view.addSubview(self.activityIndicatorView)
    }

    private func removeActivityIndicatorView() {
        guard self.isDisplaying() else {
            return
        }
        
        let loadingView = self.view.viewWithTag(loadingViewTag)
        loadingView?.removeFromSuperview()
        
        let activityIndicatorView = self.view.viewWithTag(activityIndicatorViewTag) as? UIActivityIndicatorView
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
    }

    private func isDisplaying() -> Bool {
        guard let loadingView = self.view.viewWithTag(loadingViewTag) else {
            return false
        }
        
        return self.view.subviews.contains(loadingView)
    }
}
