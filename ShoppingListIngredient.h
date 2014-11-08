//
//  ShoppingListIngredient.h
//  GroceryList
//
//  Created by Benjamin Hancock on 11/7/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Ingredient, ShoppingList;

@interface ShoppingListIngredient : BaseEntity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Ingredient *ingredient;
@property (nonatomic, retain) ShoppingList *shoppingList;

@end
