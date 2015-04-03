//
//  TutorialChildViewController01.h
//  ReciPlan
//
//  Created by Benjamin Hancock on 4/2/15.
//  Copyright (c) 2015 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialChildViewController01 : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *TutorialImageView;
@property (assign, nonatomic) NSInteger index;
@property UITabBarController* tabBarController;

- (IBAction)quitTutorialButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *quitTutorialButton;

@end
