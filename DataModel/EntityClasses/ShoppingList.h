//
//  ShoppingList.h
//  GroceryList
//
//  Created by Benjamin Hancock on 11/7/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class ShoppingListIngredient;

@interface ShoppingList : BaseEntity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *shoppingListIngredients;
@end

@interface ShoppingList (CoreDataGeneratedAccessors)

- (void)addShoppingListIngredientsObject:(ShoppingListIngredient *)value;
- (void)removeShoppingListIngredientsObject:(ShoppingListIngredient *)value;
- (void)addShoppingListIngredients:(NSSet *)values;
- (void)removeShoppingListIngredients:(NSSet *)values;

@end
