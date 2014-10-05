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

/*
+ (NSMutableArray *) getRecipes
{
    NSArray* objects = [DataAccess getEntitiesByName:@"Recipe"];
    NSMutableArray * recipes = [NSMutableArray new];
    for(int i = 0; i < objects.count; i++)
    {
        NSManagedObject* managedObject = objects[i];
        Recipe* recipe = [Recipe new];
        recipe.name = [managedObject valueForKey:@"name"];
        recipe.directions = [managedObject valueForKey:@"directions"];
        //recipe.picture = [managedObject valueForKey:@"picture"];
        
        NSMutableArray* recipeIngredients = [NSMutableArray new];
        NSMutableSet* recipeIngredientObjects = [managedObject mutableSetValueForKey: @"recipeIngredients"];
        for(NSManagedObject* recipeIngredientObject in recipeIngredientObjects)
        {
            RecipeIngredient* recipeIngredient = [RecipeIngredient new];
            recipeIngredient.unit = [recipeIngredientObject valueForKey:@"unit"];
            recipeIngredient.quantity = [[recipeIngredientObject valueForKey: @"quantity"] intValue];
            [recipeIngredients addObject: recipeIngredient];
        }
        recipe.recipeIngredients = recipeIngredients;
        [recipes addObject: recipe];
    }
    return recipes;
}
 */

/*
+ (BOOL) insertRecipe: (Recipe*) recipe
{
    BOOL success = YES;
    if(YES != success)  //check for duplicates
        success = NO;
    else
    {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        NSManagedObject* newRecipe;
        newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
        [newRecipe setValue: recipe.name forKey:@"name"];
        [newRecipe setValue: recipe.directions forKey:@"directions"];
        //[newRecipe setValue: recipe.picture forKey:@"picture"];
        
        NSMutableSet* newRecipeIngredients = [NSMutableSet new];
        for(int i = 0; i < recipe.recipeIngredients.count; i++)
        {
            NSManagedObject* newRecipeIngredient;
            newRecipeIngredient = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeIngredient" inManagedObjectContext:context];
            [newRecipeIngredient setValue: ((RecipeIngredient *)recipe.recipeIngredients[i]).unit forKey:@"unit"];
            [newRecipeIngredient setValue: [NSNumber numberWithInt:((RecipeIngredient *)recipe.recipeIngredients[i]).quantity] forKey:@"quantity"];
            
            [newRecipeIngredients addObject: newRecipeIngredient];
        }
        [newRecipe setValue: newRecipeIngredients forKey:@"recipeIngredients"];
    
        NSError* error;
        [context save:&error];
    }
    return success;
}*/

+ (NSMutableArray *) getRecipes
{
    return [DataAccess getEntitiesByName:@"Recipe"];
}

+ (BOOL) insertRecipe: (Recipe*) recipe
{
    BOOL success = YES;
    if(YES != success)  //check for duplicates
        success = NO;
    else
    {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        NSManagedObject* newRecipe;
        newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
        
        NSError* error;
        [context save:&error];
    }
    return success;
}


@end
