//
//  CalendarDay.h
//  GroceryList
//
//  Created by Benjamin Hancock on 11/11/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Recipe;

@interface CalendarDay : BaseEntity

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *recipes;

+ (id) getEntityByDate: (NSDate *) date;
@end

@interface CalendarDay (CoreDataGeneratedAccessors)

- (void)addRecipesObject:(Recipe *)value;
- (void)removeRecipesObject:(Recipe *)value;
- (void)addRecipes:(NSSet *)values;
- (void)removeRecipes:(NSSet *)values;

@end
