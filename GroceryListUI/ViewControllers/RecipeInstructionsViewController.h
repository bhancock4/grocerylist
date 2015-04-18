//
//  RecipeInstructionsViewController.h
//  ReciPlan
//
//  Created by Benjamin Hancock on 4/17/15.
//  Copyright (c) 2015 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeInstructionsViewController : UIViewController

@property NSString* recipeInstructions;

@property (weak, nonatomic) IBOutlet UITextView *recipeInstructionsTextView;

@end
