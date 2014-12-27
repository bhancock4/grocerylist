//
//  IngredientTableViewController.h
//  GroceryList
//
//  Created by Benjamin Hancock on 12/27/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientTableViewController : UITableViewController

@property NSMutableArray* ingredients;
@property BOOL keyboardIsShown;
@property int16_t selectedIngredientRow;
@property UIColor* preAlertCellColor;
@property NSIndexPath* swipeLIndex;
@property NSIndexPath* longPressIndex;

- (NSIndexPath*)getCellIndexFromGesture:(UIGestureRecognizer *) g;

@end
