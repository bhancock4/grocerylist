//
//  FirstViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "CalendarViewController.h"

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. Instantiate a CKCalendarView
    CKCalendarView* calendar = [[CKCalendarView alloc] initWithMode:CKCalendarViewModeMonth];
    
    // 2. Optionally, set up the datasource and delegates
    calendar.delegate = self;
    calendar.dataSource = self;
    
    // 3. Present the calendar
    [[self view] addSubview:calendar];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    NSDateComponents* dateComps1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSDateComponents* dateComps2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*5]];
    
    NSDate* date1 = [[NSCalendar currentCalendar] dateFromComponents:dateComps1];
    NSDate* date2 = [[NSCalendar currentCalendar] dateFromComponents:dateComps2];
    
    if([date1 isEqualToDate:date2])
        return [NSArray arrayWithObjects:@"Breakfast", @"Lunch", @"Dinner", nil];
    
    return nil;
}

@end
