//
//  Utilities.h
//  GroceryList
//
//  Created by Benjamin Hancock on 11/22/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOFFSET_FOR_KEYBOARD 80.0

@interface Utilities : NSObject

+ (void) addToList: (NSArray *) recipes;
+ (BOOL) quantityContainsFractionalPart: (NSString *) quantity;
+ (double) getDecimalValue: (NSString *) quantity;
+ (NSString *) getFractionalValue: (double) quantity;
+ (NSString *) addQuantity1: (NSString *) q1 ToQuantity2: (NSString *) q2;

@end
