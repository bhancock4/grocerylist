//
//  RecipeInstructionsViewController.m
//  ReciPlan
//
//  Created by Benjamin Hancock on 4/17/15.
//  Copyright (c) 2015 Ben Hancock. All rights reserved.
//

#import "RecipeInstructionsViewController.h"

@interface RecipeInstructionsViewController ()

@end

@implementation RecipeInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.recipeInstructionsTextView.text = self.recipeInstructions;
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
