//
//  RecipeIngredientTableViewCell.m
//  GroceryList
//
//  Created by Benjamin Hancock on 10/30/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "RecipeIngredientTableViewCell.h"

@implementation RecipeIngredientTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.ingredientNameTextField.delegate = self;
    self.ingredientNameTextField.tag = 2;
    self.ingredientQuantityTextField.delegate = self;
    self.ingredientQuantityTextField.tag = 1;
    self.ingredientUnitsUIPickerView.delegate = self;
    self.ingredientUnitsUIPickerView.dataSource = self;
    
    [self.ingredientQuantityTextField addTarget:self
                            action:@selector(textFieldInputDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    
    [self.ingredientNameTextField addTarget:self
                            action:@selector(textFieldInputDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    
    self.ingredientUnitsUIPickerView.transform = CGAffineTransformMakeScale(.4, 0.4);
    
    self.pickerData = @[@"", @"oz", @"tsp", @"tbs", @"cups", @"lbs"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.recipeIngredient.unit = [self.pickerData objectAtIndex:row];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self setEntityValueFromTextField:textField];
}

- (void) textFieldInputDidChange:(UITextField *) textField
{
    [self setEntityValueFromTextField:textField];
}

- (void) setEntityValueFromTextField:(UITextField *) textField
{
    switch(textField.tag)
    {
        case 1: //quantity text field
            self.recipeIngredient.quantity = textField.text;
            break;
            
        case 2: //name text field
            self.recipeIngredient.name = textField.text;
            break;
            
        default: //???
            break;
    }
    
}

@end
