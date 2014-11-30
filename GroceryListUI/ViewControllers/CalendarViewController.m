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

    UISwitch* multiSelectButton = [UISwitch new];
    multiSelectButton.onTintColor = [UIColor grayColor];
    multiSelectButton.onImage = [UIImage imageNamed: @"Calendar"];
    multiSelectButton.offImage = [UIImage imageNamed: @"Calendar"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithCustomView:multiSelectButton];
    self.navigationItem.leftBarButtonItems = [self.navigationItem.leftBarButtonItems arrayByAddingObject:bbi];
    self.multiSelectButton = multiSelectButton;
    
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

//action that fires when the add to shopping list button is pressed
- (IBAction)AddToList:(id)sender
{
    //if we are dealing with multiple calendar days...
    if(self.multiSelectButton.isOn)
    {
        //grab the begin date...
        //if the begin was after the end the code in the control class will swap that for us
        NSDate* beginDate = self.calendar.beginDate;
        //loop through the days adding one day at a time
        while([beginDate compare:self.calendar.endDate] == NSOrderedAscending || [beginDate compare:self.calendar.endDate] == NSOrderedSame)
        {
            [Utilities addToList: [((CalendarDay *)[CalendarDay getEntityByDate:beginDate]).recipes allObjects]];
        
            NSDateComponents* dayComponent = [NSDateComponents new];
            dayComponent.day = 1;
            NSCalendar* tempCalendar = [NSCalendar currentCalendar];
            beginDate = [tempCalendar dateByAddingComponents:dayComponent toDate:beginDate options:0];
        }
    }
    //otherwise, if only a single day was selected just use the recipes for that day
    else
    {
        [Utilities addToList:[self.selectedCalendarDay.recipes allObjects]];
    }
}

//refresh the calendar view after coming back from the add recipes screen
- (IBAction) unwindToCalendar:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.calendar reload];
}

- (void) calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{
    //set the current calendar day
    self.selectedCalendarDay = [CalendarDay getEntityByDate:date];
    //initialize new calendar entities when a date is selected
    if(nil == self.selectedCalendarDay)
    {
        self.selectedCalendarDay = [CalendarDay newEntity];
        self.selectedCalendarDay.date = date;
    }
    //set controller properties for multi-select behavior
    if(self.multiSelectButton.isOn)
    {
        if(!(nil == self.calendar.beginDate) && !(nil == self.calendar.endDate))
        {
            self.calendar.beginDate = date;
            self.calendar.endDate = nil;
        }
        else if(nil == self.calendar.beginDate && nil == self.calendar.endDate)
        {
            self.calendar.beginDate = date;
        }
        else
        {
            self.calendar.endDate = date;
        }
    }
    else
    {
        self.calendar.beginDate = nil;
        self.calendar.endDate = nil;
    }
}


@end
