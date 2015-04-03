//
//  TutorialChildViewController01.m
//  ReciPlan
//
//  Created by Benjamin Hancock on 4/2/15.
//  Copyright (c) 2015 Ben Hancock. All rights reserved.
//

#import "TutorialChildViewController01.h"

@interface TutorialChildViewController01 ()

@end

@implementation TutorialChildViewController01

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString* tutorialScreenImageName = [NSString stringWithFormat:@"TutScreenImage%ld", (long)self.index];
    self.TutorialImageView.image = [UIImage imageNamed:tutorialScreenImageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)quitTutorialButtonClicked:(id)sender
{
    self.parentViewController.view.window.rootViewController = self.tabBarController;
    ((UITabBarItem *)self.tabBarController.tabBar.items[0]).selectedImage = [UIImage imageNamed:@"Calendar"];
    ((UITabBarItem *)self.tabBarController.tabBar.items[1]).selectedImage = [UIImage imageNamed:@"Recipes"];
    ((UITabBarItem *)self.tabBarController.tabBar.items[2]).selectedImage = [UIImage imageNamed:@"ShoppingList"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
