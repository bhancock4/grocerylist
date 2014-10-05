//
//  RecipeIngredient.h
//  GroceryList
//
//  Created by Benjamin Hancock on 10/5/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Recipe.h"

@class Ingredient;
@class Recipe;

@interface RecipeIngredient : NSManagedObject

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) Ingredient *ingredient;
@property (nonatomic, retain) Recipe *recipe;

@end
