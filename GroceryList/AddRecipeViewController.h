//
//  AddRecipeViewController.h
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface AddRecipeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property Recipe* recipe;
@property NSMutableArray* recipeIngredients;
@property (nonatomic) NSString* sourceSegue;
@property long ingredientTextfieldTag;
@property BOOL isUpdating;
@property NSString* initialRecipeName;
@end
