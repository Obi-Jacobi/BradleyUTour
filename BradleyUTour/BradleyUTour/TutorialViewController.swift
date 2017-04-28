//
//  TutorialViewController.swift
//  BradleyUTour
//
//  Created by Ethan Ronne on 4/25/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController {
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newTutorialPageViewController(pageNumber: 1),
                self.newTutorialPageViewController(pageNumber: 2),
                self.newTutorialPageViewController(pageNumber: 3),
                self.newTutorialPageViewController(pageNumber: 4),
                self.newTutorialPageViewController(pageNumber: 5),
                self.newTutorialPageViewController(pageNumber: 6),
                self.newTutorial7PageViewController(pageNumber: 7),]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self;
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func newTutorialPageViewController(pageNumber: Int) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "TutorialPage\(pageNumber)")
    }
    
    private func newTutorial7PageViewController(pageNumber: Int) -> Tutorial7ViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "TutorialPage\(pageNumber)") as! Tutorial7ViewController
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension TutorialViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}
