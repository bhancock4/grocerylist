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
    
    NSArray* objects = [da getEntitiesByValue: NSStringFromClass([self class]) WithPredicate:predicate AndSortByProperty:@"calendarOrder"];
    return objects.count == 0 ? nil : objects[0];
}

@end
