//
//  RecipeIngredientTableViewCell.h
//  GroceryList
//
//  Created by Benjamin Hancock on 10/30/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeIngredient.h"

@interface RecipeIngredientTableViewCell : UITableViewCell <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property RecipeIngredient* recipeIngredient;
@property (weak, nonatomic) IBOutlet UITextField *ingredientNameTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *ingredientUnitsUIPickerView;
@property (weak, nonatomic) IBOutlet UITextField *ingredientQuantityTextField;

@property NSArray* pickerData;

@end
