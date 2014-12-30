//
//  IngredientTableViewCell.m
//  GroceryList
//
//  Created by Benjamin Hancock on 10/30/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "IngredientTableViewCell.h"

@implementation IngredientTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    //set the delegate/datasource for the fields on the UITableViewCell
    self.ingredientNameTextField.delegate = self;
    self.ingredientQuantityTextField.delegate = self;
    //set the tags so we know which textField is firing events
    self.ingredientQuantityTextField.tag = 1;
    self.ingredientNameTextField.tag = 2;
    
    self.ingredientUnitsUIPickerView.delegate = self;
    self.ingredientUnitsUIPickerView.dataSource = self;
    
    //add listeners to the textChanged events on both text fields
    [self.ingredientQuantityTextField addTarget:self
                            action:@selector(textFieldInputDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    
    [self.ingredientNameTextField addTarget:self
                            action:@selector(textFieldInputDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    
    //allow keyboard to be dismissed with a "Done" button
    [self addDoneToolBarToTextFieldKeyboard: self.ingredientQuantityTextField];
    [self addDoneToolBarToTextFieldKeyboard: self.ingredientNameTextField];
    
    //keep unselected picker wheel from appearing outside cell bounds
    self.clipsToBounds = YES;
    
    //hard-code sone picker data while developing
    self.pickerData = nil;
}

- (UIToolbar *) getDoneKeyboardToolbar
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    return doneToolbar;
}

-(void)addDoneToolBarToTextFieldKeyboard:(UITextField *) textField
{
    UIToolbar* doneToolbar = [self getDoneKeyboardToolbar];
    textField.inputAccessoryView = doneToolbar;
}

-(void)doneButtonClickedDismissKeyboard
{
    [self.ingredientQuantityTextField resignFirstResponder];
    [self.ingredientNameTextField resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
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
    self.ingredient.unit = [self.pickerData objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* labelUnits = (UILabel*)view;
    if (!labelUnits)
    {
        labelUnits = [[UILabel alloc] init];
        labelUnits.adjustsFontSizeToFitWidth = YES;
    }
    labelUnits.text = self.pickerData[row];
    return labelUnits;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO)
        view = [view superview];
    
    UITableView* tableView = (UITableView *)view;
    if([self.viewControllerName isEqualToString:@"ShoppingListsViewController"])
    {
        ((ShoppingListsViewController *)tableView.delegate).selectedIngredientRow = self.ingredient.order;
    }
    else
    {
        ((AddRecipeViewController *)tableView.delegate).selectedIngredientRow = self.ingredient.order;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self setEntityValueFromTextField:textField];
}

- (void) textFieldInputDidChange:(UITextField *) textField
{
    [self setEntityValueFromTextField:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void) setEntityValueFromTextField:(UITextField *) textField
{
    switch(textField.tag)
    {
        case 1: //quantity text field
            self.ingredient.quantity = textField.text;
            break;
            
        case 2: //name text field
            self.ingredient.name = textField.text;
            break;
            
        default: //???
            break;
    }
    
}

@end
