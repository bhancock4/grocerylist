//
//  Ingredient.h
//  GroceryList
//
//  Created by Benjamin Hancock on 10/5/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"


@interface Ingredient : BaseEntity

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic) int16_t order;
@property BOOL checked;

@end
