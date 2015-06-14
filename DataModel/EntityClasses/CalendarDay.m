//
//  CalendarDay.m
//  GroceryList
//
//  Created by Benjamin Hancock on 11/11/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "CalendarDay.h"
#import "Recipe.h"


@implementation CalendarDay

@dynamic date;
@dynamic recipes;

+ (id) getEntityByDate: (NSDate *) date
{
    //add one day to the date to get the exclusive end of the date range
    NSDateComponents* dayComponent = [NSDateComponents new];
    dayComponent.day = 1;
    NSDate* dateEnd = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:date options:0];

    DataAccess* da = [DataAccess sharedDataAccess];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(date >= %@) && (date < %@)", date, dateEnd];
    
    //NSArray* objects = [da getEntitiesByName: NSStringFromClass([self class]) WithPredicate:predicate AndSortByProperty:@"calendarOrder"];
    
    NSArray* objects = [da getEntitiesByName: NSStringFromClass([self class]) WithPredicate:predicate];
    
    if(objects.count > 0)
    {
        CalendarDay* cd = (CalendarDay *)objects[0];
        NSArray* recipes = [cd.recipes allObjects];
        for(int i = 0; i < recipes.count; i++)
        {
            NSLog([NSString stringWithFormat:@"Recipe Name: %@", ((Recipe *)recipes[i]).name]);
            NSLog([NSString stringWithFormat:@"Recipe Directions: %@", ((Recipe *)recipes[i]).directions]);
        }
    }

    return objects.count == 0 ? nil : objects[0];
}

@end
