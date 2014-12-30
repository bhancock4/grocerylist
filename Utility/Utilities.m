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

+ (NSArray*) unitPickerData
{
    return @[@"", @"tsp", @"tbs", @"cups", @"oz", @"lbs"];
}

+ (BOOL) quantityContainsFractionalPart: (NSString *) quantity
{
    return [quantity componentsSeparatedByString: @"/"].count > 1;
}

+ (NSString *) addRational1: (NSString *) r1 ToRational2: (NSString *) r2
{
    //get original whole parts as long integer
    long r1WholePart = [r1 componentsSeparatedByString: @" "].count > 1 ? [[r1 componentsSeparatedByString: @" "][0] longLongValue] : 0;
    if(r1WholePart != 0)
    {
        r1 = [r1 componentsSeparatedByString: @" "][1];
    }
    long r2WholePart = [r2 componentsSeparatedByString: @" "].count > 1 ? [[r2 componentsSeparatedByString: @" "][0] longLongValue] : 0;
    if(r2WholePart != 0)
    {
        r2 = [r2 componentsSeparatedByString: @" "][1];
    }
    long resultWholePart = r1WholePart + r2WholePart;
    
    //set these to double so we can test integer division result
    double resultNumerator = 0;
    double resultDenominator = 1;
    
    //extract numerators/denominators as well as original copies for math
    long r1Numerator = [[r1 componentsSeparatedByString: @"/"][0] longLongValue];
    long r1Denominator = [[r1 componentsSeparatedByString: @"/"][1] longLongValue];
    long r1DenominatorOrig = [[r1 componentsSeparatedByString: @"/"][1] longLongValue];
    long r2Numerator = [[r2 componentsSeparatedByString: @"/"][0] longLongValue];
    long r2Denominator = [[r2 componentsSeparatedByString: @"/"][1] longLongValue];
    long r2DenominatorOrig = [[r2 componentsSeparatedByString: @"/"][1] longLongValue];
    
    //multiply both sides by d/d od opposite denominator
    r1Numerator *= r2DenominatorOrig;
    r1Denominator *= r2DenominatorOrig;
    r2Numerator *= r1DenominatorOrig;
    r2Denominator *= r1DenominatorOrig;
    
    //add the fractional parts
    resultNumerator = r1Numerator + r2Numerator;
    resultDenominator = r1Denominator;  //could use either since both should be equal at this point
    
    //extract whole parts from fractional part
    if(resultNumerator >= resultDenominator)
    {
        long tempWholePart = resultNumerator / resultDenominator;
        resultWholePart += tempWholePart;
        resultNumerator -= resultDenominator * tempWholePart;
    }
    
    //reduce fraction
    for(int i = 2; i < resultNumerator; i++)
    {
        if((long)resultNumerator % i == 0 && (long)resultDenominator % i == 0)
        {
            i = 2;
            resultNumerator /= i;
            resultDenominator /= i;
        }
    }
    
    //parse results out to mixed-number string
    NSString* wholePart = resultWholePart > 0 ? [NSString stringWithFormat: @"%ld ", resultWholePart] : @"";
    NSString* rtn = [wholePart stringByAppendingString: [NSString stringWithFormat: @"%ld/%ld", (long)resultNumerator, (long)resultDenominator]];
    
    return rtn;
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
            shoppingListIngredients = [NSMutableArray arrayWithArray:[shoppingList.shoppingListIngredients array]];
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
                        sli.quantity = [Utilities addRational1: sli.quantity ToRational2: ri.quantity];
                    
                    [shoppingListIngredients addObject:sli];
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
            }
            foundIngredient = NO;
            shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray: shoppingListIngredients];
            [shoppingList saveEntity];
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
