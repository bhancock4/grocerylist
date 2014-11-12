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
    
    //programmatially create/setup instance of the MBCalendarKit calendar/tableview object
    CKCalendarView* calendar = [[CKCalendarView alloc] initWithMode:CKCalendarViewModeMonth];
    calendar.delegate = self;
    calendar.dataSource = self;
    //add the calendar the the UI
    [[self view] addSubview:calendar];
    //force centering/resizing of calendar
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin   |
                                  UIViewAutoresizingFlexibleRightMargin  |
                                  UIViewAutoresizingFlexibleTopMargin    |
                                  UIViewAutoresizingFlexibleBottomMargin);
    
    //keep calendar from being hidden behind navigation controller bars
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    //testing code...adds two bogus CKCalendarEvents on the day 5 days from now
    NSDateComponents* dateComps1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSDateComponents* dateComps2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*5]];
    
    NSDate* date1 = [[NSCalendar currentCalendar] dateFromComponents:dateComps1];
    NSDate* date2 = [[NSCalendar currentCalendar] dateFromComponents:dateComps2];
    
    if([date1 isEqualToDate:date2])
    {
        CKCalendarEvent* event1 = [CKCalendarEvent eventWithTitle:@"Test Event1" andDate:date andInfo:nil ];
        CKCalendarEvent* event2 = [CKCalendarEvent eventWithTitle:@"Test Event2" andDate:date andInfo:nil ];
        
        return [NSArray arrayWithObjects:event1, event2, nil];
    }
    return nil;
}

@end
