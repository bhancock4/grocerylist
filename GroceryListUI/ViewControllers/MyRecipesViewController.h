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
#import "RecipeTableViewCell.h"

@interface MyRecipesViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property Recipe* selectedRecipe;
@property NSMutableArray* recipes;
@property NSMutableArray* filteredRecipes;
@property (nonatomic) NSString* sourceSegue;
@property BOOL isInMultiSelectMode;
@property NSMutableArray* selectedRecipes;
@property (strong) IBOutlet UIBarButtonItem* doneButton;
@property (strong) IBOutlet UIBarButtonItem* addButton;
@property CalendarDay* calendarDay;
@property NSString* searchText;
@property IBOutlet UISearchBar* searchBar;
@property BOOL tableIsFiltered;

- (IBAction)unwindToMyRecipes:(UIStoryboardSegue *)segue sender:(id)sender;
- (void) deleteRecipeForCell: (RecipeTableViewCell *) cell;
- (UIView *)viewWithImageName:(NSString *)imageName;

@end

