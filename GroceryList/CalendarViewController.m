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
    self.calendar = calendar;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SelectRecipesForCalendar"])
    {
        UINavigationController* navController = segue.destinationViewController;
        MyRecipesViewController* myRecipesVC = (MyRecipesViewController *)([navController viewControllers][0]);
        myRecipesVC.sourceSegue = segue.identifier;
        myRecipesVC.calendarDay = self.selectedCalendarDay;
    }
}

//populate date entry with the recipes
- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    CalendarDay* calendarDay = [CalendarDay getEntityByDate:date];
    if(nil != calendarDay && calendarDay.recipes.count > 0)
    {
        NSArray* recipes = [calendarDay.recipes allObjects];
        NSMutableArray* recipeEvents = [NSMutableArray new];
        for(Recipe* recipe in recipes)
        {
            CKCalendarEvent* recipeEvent = [CKCalendarEvent eventWithTitle: recipe.name andDate: date andInfo: nil andImage:recipe.picture];
            [recipeEvents addObject:recipeEvent];
        }
        return recipeEvents;
    }
    return nil;
}

- (IBAction)AddToList:(id)sender
{
    //[Utilities addToList: @[self.recipe]];
}

- (IBAction) unwindToCalendar:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.calendar reload];
}

- (void) calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{
    self.selectedCalendarDay = [CalendarDay getEntityByDate:date];
    if(nil == self.selectedCalendarDay)
    {
        self.selectedCalendarDay = [CalendarDay newEntity];
        self.selectedCalendarDay.date = date;
    }
}


@end
