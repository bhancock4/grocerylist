//
//  RecipeViewController.h
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRecipesViewController : UITableViewController

@property NSMutableArray* recipes;
- (IBAction)unwindToMyRecipes:(UIStoryboardSegue *)segue sender:(id)sender;

@end

