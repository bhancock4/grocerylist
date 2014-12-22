//
//  ShoppingListsViewControllerTableViewController.h
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingList.h"
#import "ShoppingListIngredient.h"
#import "IngredientTableViewCell.h"
#import "Utilities.h"

@interface ShoppingListsViewController : UITableViewController

@property ShoppingList* shoppingList;
@property NSMutableArray* shoppingListIngredients;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* AddButton;
@property (weak, nonatomic) IBOutlet UITextField* ingredientTextField;
@property BOOL keyboardIsShown;
@property int16_t selectedIngredientRow;

- (IBAction)addShoppingListItem:(id)sender;

@end
