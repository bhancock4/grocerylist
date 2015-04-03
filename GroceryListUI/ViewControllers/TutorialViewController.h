//
//  TutorialViewController.h
//  ReciPlan
//
//  Created by Benjamin Hancock on 3/20/15.
//  Copyright (c) 2015 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIPageViewController <UIPageViewControllerDataSource>

@property UIPageViewController* pageViewController;
@property NSInteger pageIndex;
@property UITabBarController* tabBarController;

@end
