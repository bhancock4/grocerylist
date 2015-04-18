//
//  RecipeInstructionsViewController.h
//  ReciPlan
//
//  Created by Benjamin Hancock on 4/17/15.
//  Copyright (c) 2015 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeIngredient.h"

@interface RecipeInstructionsViewController : UIViewController

@property NSString* recipeName;
@property NSString* recipeInstructions;
@property NSOrderedSet* recipeIngredients;
@property (weak, nonatomic) IBOutlet UITextView *recipeInstructionsTextView;

@end
