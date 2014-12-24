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

+ (BOOL) quantityContainsFractionalPart: (NSString *) quantity
{
    return [quantity componentsSeparatedByString: @"/"].count > 1;
}

+ (double) getDecimalValue: (NSString *) quantity
{
    double decimalValue = 0;
    if([Utilities quantityContainsFractionalPart: quantity])
    {
        int wholeNumber = 0;
        int numerator;
        NSArray* quantityArray = [quantity componentsSeparatedByString: @"/"];
        NSArray* wholePartArray = [quantityArray[0] componentsSeparatedByString: @" "];
        if(wholePartArray.count > 1)
        {
            wholeNumber = [wholePartArray[0] doubleValue];
            numerator = [wholePartArray[1] doubleValue];
        }
        else
        {
            numerator = [wholePartArray[0] doubleValue];
        }
        decimalValue = wholeNumber + [quantityArray[0] doubleValue] / [quantityArray[1] doubleValue];
    }
    else
    {
        decimalValue = [quantity doubleValue];
    }
    return decimalValue;
}

+ (NSString *) getFractionalValue: (double) quantity
{
    NSString* fractionalValue = @"";
    
    long numerator = quantity * 1000000;
    long denominator = 1000000;
    long calcNumerator = numerator;
    long calcDenominator = denominator;
    long temp = 0;
    
    while (calcDenominator != 0)
    {
        temp = calcNumerator % calcDenominator;
        calcNumerator = calcDenominator;
        calcDenominator = temp;
    }
    
    numerator /= calcNumerator;
    denominator /= calcNumerator;
    
    //format the result
    if(numerator > denominator)
    {
        long mixed = numerator / denominator;
        numerator -= (mixed * denominator);
        fractionalValue = [NSString stringWithFormat: @"%ld %ld/%ld", mixed, numerator, denominator];
    }
    else if(denominator != 1)
    {
        fractionalValue = [NSString stringWithFormat: @"%ld/%ld", numerator, denominator];
    }
    else
    {
        fractionalValue = [NSString stringWithFormat: @"%ld", numerator];
    }
    return fractionalValue;
}

+ (NSString *) addQuantity1: (NSString *) q1 ToQuantity2: (NSString *) q2
{
    return [Utilities getFractionalValue: [Utilities getDecimalValue: q1] + [Utilities getDecimalValue: q2]];
}

+ (void) addToList: (NSArray *) recipes
{
    NSMutableArray* shoppingListIngredients = nil;
    ShoppingList* shoppingList = [ShoppingList getEntityByName:@"ShoppingList"];
    if(shoppingList == nil)
    {
        shoppingList = [ShoppingList newEntity];
        shoppingList.name = @"ShoppingList";
        [shoppingList saveEntity];
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
                    if([ri.unit length] > 0)
                        sli.unit = ri.unit;
                    if([ri.quantity length] > 0)
                        sli.quantity = [Utilities addQuantity1: sli.quantity ToQuantity2: ri.quantity];
                    
                    [shoppingListIngredients addObject:sli];
                    shoppingList.shoppingListIngredients = [NSSet setWithArray: shoppingListIngredients];
                    [shoppingList saveEntity];
                }
            }
            if(!foundIngredient)
            {
                ShoppingListIngredient* shoppingListIngredient = [ShoppingListIngredient newEntity];
                shoppingListIngredient.name = ri.name;
                
                if([ri.unit length] > 0)
                    shoppingListIngredient.unit = ri.unit;
                
                if([ri.quantity length] > 0)
                    shoppingListIngredient.quantity = ri.quantity;
                
                [shoppingListIngredients addObject: shoppingListIngredient];
                shoppingList.shoppingListIngredients = [NSSet setWithArray: shoppingListIngredients];
                [shoppingList saveEntity];
            }
            foundIngredient = NO;
        }
        
        
        UIAlertView* listAddConfirmation = [[UIAlertView alloc] initWithTitle:@"Added to Shopping List"
                                                                      message:[NSString stringWithFormat: @"The recipe %@ has been added to your shopping list", recipe.name]
                                                                     delegate: nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
        
        [listAddConfirmation show];
    }
}



@end
