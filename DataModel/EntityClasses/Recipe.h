//
//  Recipe.h
//  GroceryList
//
//  Created by Benjamin Hancock on 10/5/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RecipeIngredient.h"
#import "BaseEntity.h"

@class RecipeIngredient;

@interface Recipe : BaseEntity

- (BOOL) validateRecipe;

@property (nonatomic, retain) NSString * directions;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSOrderedSet *recipeIngredients;
@property (nonatomic) int16_t recipeOrder;
@property (nonatomic) int16_t calendarOrder;
@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addRecipeIngredientsObject:(RecipeIngredient *)value;
- (void)removeRecipeIngredientsObject:(RecipeIngredient *)value;
- (void)addRecipeIngredients:(NSOrderedSet *)values;
- (void)removeRecipeIngredients:(NSOrderedSet *)values;

@end
