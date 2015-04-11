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

+ (UIColor *) cellBackGroundColor
{
    return [UIColor colorWithRed:255.0/255.0 green:178.0/255.0 blue:30.0/255.0 alpha:1.0];
}

int englishUnitConversionTable[8][8] = {
    //           lbs     gallons     quarts      pints   cups    oz      tbs     tsp
    /*lbs*/     {1,      0,          0,          0,      0,      0,     0,      0},
    /*gallons*/ {0,      1,          4,          8,      16,     128,    256,    768},
    /*quarts*/  {0,      0,          1,          2,      4,      32,     64,     128},
    /*pints*/   {0,      0,          0,          1,      2,      16,     32,     96},
    /*cups*/    {0,      0,          0,          0,      1,      8,      16,     48},
    /*oz*/      {0,      0,          0,          0,      0,      1,      2,      6},
    /*tbs*/     {0,      0,          0,          0,      0,      0,      1,      3},
    /*tsp*/     {0,      0,          0,          0,      0,      0,      0,      1}
};

+ (void)reduceIngredient:(ShoppingListIngredient *)ingredient
{
    long roundedQuantity = [[Utilities roundUpRational:ingredient.quantity] longLongValue];
    int unitIndex = (int)[[Utilities unitPickerData] indexOfObject:ingredient.unit] - 1;
    for(int i = 0; i < unitIndex; i++)
    {
        if([Utilities unit:ingredient.unit IsCompatibleWith:[Utilities unitPickerData][i + 1]])
        {
            if(englishUnitConversionTable[i][unitIndex] && englishUnitConversionTable[i][unitIndex] <= roundedQuantity)
            {
                long dividend = roundedQuantity / englishUnitConversionTable[i][unitIndex];
                if(roundedQuantity % englishUnitConversionTable[i][unitIndex])
                    dividend += 1;
                ingredient.quantity = [NSString stringWithFormat: @"%ld ", dividend];
                ingredient.unit = [Utilities unitPickerData][i + 1];
                break;
            }
        }
    }
}

+ (BOOL)unit:(NSString *)unit1 IsCompatibleWith:(NSString *)unit2
{
    int unit1Index = (int)[[Utilities unitPickerData] indexOfObject:unit1] - 1;
    int unit2Index = (int)[[Utilities unitPickerData] indexOfObject:unit2] - 1;
    return englishUnitConversionTable[unit1Index][unit2Index] || englishUnitConversionTable[unit2Index][unit1Index];
}

+ (NSString *)getSmallerUnitBetween:(NSString *)unit1 And:(NSString *)unit2
{
    int unit1Index = (int)[[Utilities unitPickerData] indexOfObject:unit1];
    int unit2Index = (int)[[Utilities unitPickerData] indexOfObject:unit2];
    return unit1Index >= unit2Index ? unit1 : unit2;
}

+ (NSString *)multiplyRational:(NSString *)rational ByInteger:(NSInteger) multiplier
{
    NSString* tempRational = [NSString stringWithString:rational];
    for(int i = 0; i < (int)multiplier - 1; i++)
    {
        rational = [Utilities addRational1:rational ToRational2:tempRational];
    }
    return rational;
}

+ (NSArray*) unitPickerData
{
    if(YES) //english
    {
        return @[@"", @"lbs", @"gallons", @"quarts", @"pints", @"cups", @"oz", @"tbs", @"tsp"];
    }
    else //metric
    {
        return @[@""];
    }
}

+ (NSString *)roundUpRational:(NSString *)rational
{
    NSString* roundedRational = [NSString stringWithString:rational];
    if([roundedRational componentsSeparatedByString:@"/"].count > 1)
    {
        //check to see if there is also a whole component and extract it
        long wholePart = [roundedRational componentsSeparatedByString: @" "].count > 1 ? [[roundedRational componentsSeparatedByString: @" "][0] longLongValue] : 0;
        
        if(wholePart != 0) //there is a whole and fractional part, just add 1 to the whole part
        {
            roundedRational = [NSString stringWithFormat: @"%ld ", wholePart + 1];
        }
        else //there is only a fractional part, just round up to 1
        {
            roundedRational = @"1";
        }
    }
    return roundedRational;
}

+ (BOOL) quantityContainsFractionalPart: (NSString *) quantity
{
    return [quantity componentsSeparatedByString: @"/"].count > 1;
}

+ (NSString *) addRational1: (NSString *) r1 ToRational2: (NSString *) r2
{
    long r1WholePart = 0;
    long r2WholePart = 0;
    //get original whole parts as long integer
    
    //if there is a fractional component...
    if([r1 componentsSeparatedByString:@"/"].count > 1)
    {
        //check to see if there is also a whole component and extract it
        r1WholePart = [r1 componentsSeparatedByString: @" "].count > 1 ? [[r1 componentsSeparatedByString: @" "][0] longLongValue] : 0;
        
        //if there was a whole part then set r1 to the rational component
        if(r1WholePart != 0)
        {
            r1 = [r1 componentsSeparatedByString: @" "][1];
        }
    }
    else //there was no rational component
    {
        r1WholePart = [r1 longLongValue];
        r1 = @"0/1";
    }
    
    
    //if there is a fractional component...
    if([r2 componentsSeparatedByString:@"/"].count > 1)
    {
        //check to see if there is also a whole component and extract it
        r2WholePart = [r2 componentsSeparatedByString: @" "].count > 1 ? [[r2 componentsSeparatedByString: @" "][0] longLongValue] : 0;
        
        //if there was a whole part then set r2 to the rational component
        if(r2WholePart != 0)
        {
            r2 = [r2 componentsSeparatedByString: @" "][1];
        }
    }
    else //there was no rational component
    {
        r2WholePart = [r2 longLongValue];
        r2 = @"0/1";
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
    for(int i = 2; i <= resultNumerator; i++)
    {
        if((long)resultNumerator % i == 0 && (long)resultDenominator % i == 0)
        {
            resultNumerator /= i;
            resultDenominator /= i;
            i = 1;
        }
    }
    
    //parse results out to mixed-number string
    NSString* wholePart = resultWholePart > 0 ? [NSString stringWithFormat: @"%ld ", resultWholePart] : @"";
    
    NSString* rationalPart = resultNumerator != 0 ? [NSString stringWithFormat: @"%ld/%ld", (long)resultNumerator, (long)resultDenominator] : @"";
    
    NSString* rtn = [wholePart stringByAppendingString: rationalPart];
    
    return rtn;
}

+ (NSString *) addToList: (NSArray *) recipes
{
    NSMutableArray* shoppingListIngredients = nil;
    ShoppingList* shoppingList = [ShoppingList getEntityByName:@"ShoppingList"];
    if(shoppingList == nil)
    {
        shoppingList = [ShoppingList newEntity];
        shoppingList.name = @"ShoppingList";
        [shoppingList saveEntity];
    }
    NSMutableDictionary* recipeDictionary = [NSMutableDictionary new];
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
                if([Utilities foundIngredientMatchWithName:ri.name  Quantity:ri.quantity Unit:ri.unit ForIngredient:sli])
                {
                    NSString* tempUnit = [NSString stringWithString:sli.unit];
                    foundIngredient = YES;
                    if([ri.unit length] > 0)
                        sli.unit = [Utilities getSmallerUnitBetween:ri.unit And:sli.unit];
                    
                    if([ri.quantity length] > 0)
                    {
                        NSString* tempRational = @"1";
                        int unit1Index = (int)[[Utilities unitPickerData] indexOfObject:ri.unit] - 1;
                        int unit2Index = (int)[[Utilities unitPickerData] indexOfObject:tempUnit] - 1;
                        //ri.unit is the smaller one
                        if([[Utilities getSmallerUnitBetween:ri.unit And:sli.unit] isEqualToString:ri.unit])
                        {
                            tempRational = [Utilities multiplyRational:sli.quantity ByInteger:(NSInteger)englishUnitConversionTable[unit2Index][unit1Index]];
                            
                            sli.quantity = [Utilities addRational1: tempRational ToRational2: ri.quantity];
                        }
                        else //sli.unit is the smaller one
                        {
                            tempRational = [Utilities multiplyRational:ri.quantity ByInteger:(NSInteger)englishUnitConversionTable[unit1Index][unit2Index]];
                            
                            sli.quantity = [Utilities addRational1: sli.quantity ToRational2: tempRational];
                        }
                    }
                    [shoppingListIngredients addObject:sli];
                }
            }
            if(!foundIngredient)
            {
                ShoppingListIngredient* shoppingListIngredient = [ShoppingListIngredient newEntity];
                
                if([ri.unit length] > 0)
                    shoppingListIngredient.unit = ri.unit;
                
                if([ri.quantity length] > 0)
                    shoppingListIngredient.quantity = ri.quantity;
                
                //if name is set before it isn't fetched from the datastore ???
                shoppingListIngredient.name = ri.name;
                
                [shoppingListIngredients addObject: shoppingListIngredient];
            }
            foundIngredient = NO;
            shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray: shoppingListIngredients];
            [shoppingList saveEntity];
        }
        if([recipeDictionary objectForKey:recipe.name] == nil)
        {
            [recipeDictionary setObject:@"1" forKey:recipe.name];
        }
        else
        {
            int recipeCount = [[recipeDictionary objectForKey:recipe.name] intValue] + 1;
            [recipeDictionary setObject:[NSString stringWithFormat:@"%d", recipeCount] forKey:recipe.name];
        }
    }
    NSString* recipeList = @"";
    for(id key in recipeDictionary)
    {
        recipeList = [recipeList stringByAppendingString:[NSString stringWithFormat:@"\r%@ %@", [recipeDictionary objectForKey:key], key]];
    }
    return recipeList;
}

+ (BOOL)foundIngredientMatchWithName:(NSString *)name Quantity:(NSString *)quantity Unit:(NSString *)unit ForIngredient:(ShoppingListIngredient *)ingredient
{
    BOOL foundMatch = NO;
    if([name isEqualToString:ingredient.name])
    {
        foundMatch = YES;
        
        if(([quantity length] == 0 && [ingredient.quantity length] != 0) || ([quantity length] != 0 && [ingredient.quantity length] == 0))
            foundMatch = NO;
        
        if(([unit length] == 0 && [ingredient.unit length] != 0) || ([unit length] != 0 && [ingredient.unit length] == 0))
            foundMatch = NO;
        
        if(([unit length] > 0 && [ingredient.unit length] > 0) && ![Utilities unit:unit IsCompatibleWith:ingredient.unit])
            foundMatch = NO;
    }
    return foundMatch;
}



@end
