//
//  ShoppingListIngredient.h
//  GroceryList
//
//  Created by Benjamin Hancock on 11/7/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "Ingredient.h"

@class Ingredient, ShoppingList;

@interface ShoppingListIngredient : Ingredient

//@property (nonatomic, retain) Ingredient *ingredient;
@property (nonatomic, retain) ShoppingList *shoppingList;

@end
