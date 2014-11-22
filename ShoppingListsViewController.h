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

@interface ShoppingListsViewController : UITableViewController

@property ShoppingList* shoppingList;
@property NSMutableArray* shoppingListIngredients;

@end
