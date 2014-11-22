//
//  Utilities.m
//  GroceryList
//
//  Created by Benjamin Hancock on 11/22/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "Utilities.h"
#import "ShoppingList.h"
#import "Recipe.h"
#import "ShoppingListIngredient.h"

@implementation Utilities

+ (void) addToList: (NSArray *) recipes
{
    NSMutableArray* shoppingListIngredients = nil;
    
    ShoppingList* shoppingList = [ShoppingList getEntityByName:@"ShoppingList"];
    if(shoppingList == nil)
    {
        shoppingList = [ShoppingList newEntity];
        shoppingList.name = @"ShoppingList";
    }
    for(Recipe* recipe in recipes)
    {
        if(shoppingList.shoppingListIngredients.count > 0)
            shoppingListIngredients = [NSMutableArray arrayWithArray:[shoppingList.shoppingListIngredients allObjects]];
        else
            shoppingListIngredients = [NSMutableArray new];
        
        for(RecipeIngredient* ri in recipe.recipeIngredients)
        {
            BOOL foundIngredient = NO;
            for(ShoppingListIngredient* sli in shoppingList.shoppingListIngredients)
            {
                if([sli.name isEqualToString:ri.name])
                {
                    foundIngredient = YES;
                    sli.unit = ri.unit;
                    sli.quantity = [NSString stringWithFormat:@"%d", [sli.quantity intValue] + [ri.quantity intValue]];
                    [shoppingListIngredients addObject:sli];
                }
            }
            if(!foundIngredient)
            {
                ShoppingListIngredient* shoppingListIngredient = [ShoppingListIngredient newEntity];
                shoppingListIngredient.name = ri.name;
                shoppingListIngredient.unit = ri.unit;
                shoppingListIngredient.quantity = ri.quantity;
                [shoppingListIngredients addObject: shoppingListIngredient];
            }
            foundIngredient = NO;
        }
        shoppingList.shoppingListIngredients = [NSSet setWithArray: shoppingListIngredients];
        [shoppingList saveEntity];
        
        UIAlertView* listAddConfirmation = [[UIAlertView alloc] initWithTitle:@"Added to Shopping List"
                                                                      message:[NSString stringWithFormat: @"The recipe %@ has been added to your shopping list", recipe.name]
                                                                     delegate: nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
        
        [listAddConfirmation show];
    }
}

@end
