//
//  RecipeDataAccess.m
//  GroceryList
//
//  Created by Benjamin Hancock on 10/3/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "RecipeDataAccess.h"
#import "AppDelegate.h"

@implementation RecipeDataAccess

+ (NSArray *) getRecipes
{
    DataAccess* da = [DataAccess sharedDataAccess];
    return [da getEntitiesByName:@"Recipe"];
}

+ (Recipe *) getRecipeByName: (NSString *) name
{
    DataAccess* da = [DataAccess sharedDataAccess];
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"(name = %@)", name];
    return [da getEntitiesByName: @"Recipe" WithPredicate:predicate][0];
}

+ (Recipe*) initNewRecipe
{
    DataAccess* da = [DataAccess sharedDataAccess];
    
    NSEntityDescription *recipeEntityDescription = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:da.context];
    
    return [[Recipe alloc] initWithEntity:recipeEntityDescription insertIntoManagedObjectContext:da.context];
}

+ (BOOL) validateRecipe: (Recipe *) recipe
{
    BOOL isSuccess = YES;
    if(0)
    {
        isSuccess = NO;
    }
    return isSuccess;
}

+ (BOOL) saveRecipe: (Recipe *) recipe
{
    BOOL isSuccess = YES;
    DataAccess* da = [DataAccess sharedDataAccess];
    if([self validateRecipe: recipe])
    {
        NSError* error;
        [da.context save:&error];
    }
    else
        isSuccess = NO;
    
    return isSuccess;
}


@end
