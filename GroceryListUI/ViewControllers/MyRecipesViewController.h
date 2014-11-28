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
#import "CalendarDay.h"

@interface MyRecipesViewController : UITableViewController

@property Recipe* selectedRecipe;
@property NSMutableArray* recipes;
@property (nonatomic) NSString* sourceSegue;
@property BOOL isInMultiSelectMode;
@property NSMutableArray* selectedRecipes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property CalendarDay* calendarDay;
@property NSString* searchText;

- (IBAction)unwindToMyRecipes:(UIStoryboardSegue *)segue sender:(id)sender;

@end

