//
//  RecipeIngredient.h
//  GroceryList
//
//  Created by Benjamin Hancock on 10/5/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "Ingredient.h"

@class Ingredient;
@class Recipe;

@interface RecipeIngredient : Ingredient


@property (nonatomic, retain) Recipe *recipe;

@end
