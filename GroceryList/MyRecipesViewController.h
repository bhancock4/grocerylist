//
//  RecipeViewController.h
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "AddRecipeViewController.h"
#import "AppDelegate.h"

@interface MyRecipesViewController : UITableViewController

    @property Recipe* selectedRecipe;
    @property NSArray* recipes;

    - (IBAction)unwindToMyRecipes:(UIStoryboardSegue *)segue sender:(id)sender;

@end

