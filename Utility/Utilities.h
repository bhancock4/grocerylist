//
//  Utilities.h
//  GroceryList
//
//  Created by Benjamin Hancock on 11/22/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#import "ShoppingListIngredient.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface Utilities : NSObject

+ (NSArray*) unitPickerData;
+ (void) addToList: (NSArray *) recipes;
+ (BOOL) quantityContainsFractionalPart: (NSString *) quantity;
+ (NSString *) addRational1: (NSString *) r1 ToRational2: (NSString *) r2;
+ (BOOL) foundIngredientMatchWithName:(NSString *)name Quantity:(NSString *)quantity Unit:(NSString *)unit ForIngredient:(ShoppingListIngredient *)ingredient;
+ (NSString *)getSmallerUnitBetween:(NSString *)unit1 And:(NSString *)unit2;
+ (NSString *)multiplyRational:(NSString *)rational ByInteger:(NSInteger) multiplier;
+ (BOOL)unit:(NSString *)unit1 IsCompatibleWith:(NSString *)unit2;
+ (void)reduceIngredient:(ShoppingListIngredient *)ingredient;

@end
