//
//  CalendarViewController.h
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBCalendarKit/CalendarKit.h"
#import "CalendarDay.h"
#import "Recipe.h"
#import "MyRecipesViewController.h"

@interface CalendarViewController : UIViewController <CKCalendarViewDelegate, CKCalendarViewDataSource>

- (IBAction) unwindToCalendar:(UIStoryboardSegue *)segue sender:(id)sender;
@property CalendarDay* selectedCalendarDay;
@property CKCalendarView* calendar;

@end

