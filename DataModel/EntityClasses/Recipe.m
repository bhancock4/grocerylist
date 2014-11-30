//
//  Recipe.m
//  GroceryList
//
//  Created by Benjamin Hancock on 10/5/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "Recipe.h"
#import "RecipeIngredient.h"
#import "DataAccess.h"

@implementation Recipe

@dynamic calendarOrder;
@dynamic recipeOrder;
@dynamic directions;
@dynamic name;
@dynamic picture;
@dynamic recipeIngredients;

- (BOOL) validateRecipe
{
    BOOL isSuccess = YES;
    if(0)
    {
        isSuccess = NO;
    }
    return isSuccess;
}

@end
