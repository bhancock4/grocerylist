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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
