//
//  RecipeDataAccess.h
//  GroceryList
//
//  Created by Benjamin Hancock on 10/3/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "DataAccess.h"
#import "Recipe.h"

@interface RecipeDataAccess : DataAccess

+ (BOOL) insertRecipe: (Recipe*) recipe;
+ (NSMutableArray *) getRecipes;

@end
