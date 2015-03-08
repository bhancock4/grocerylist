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
    self.pickerData = [Utilities unitPickerData];
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

- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = YES;
    
    //
    if(textField.tag == 1) //quantity textfield
    {
        //general rule...only allowed characters
        NSCharacterSet* allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" 0123456789/"];
        NSRange allowedRange = [string rangeOfCharacterFromSet: allowedCharacterSet];
        //check if character is allowed or if it is a backspace (string is empty string)
        if(allowedRange.location == NSNotFound && ![string isEqualToString:@""])
            shouldChange = NO;
        
        if ( (range.location > 0 && [string length] > 0 &&
              [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[string characterAtIndex:0]] &&
              [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[[textField text] characterAtIndex:range.location - 1]]) )
        {
            //Manually replace the space with your own space, programmatically
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@" "];
            return NO;
        }
    }
    return shouldChange;
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
            if(![self isProperMixedNumber:textField.text])
            {
                UIAlertView* alert = [[UIAlertView alloc]
                                      initWithTitle:@"Invalid number" message: @"Please enter a valid whole, fractional or mixed number" delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
                [alert show];
                textField.text = @"";
            }
            self.ingredient.quantity = textField.text;
            break;
            
        case 2: //name text field
            
            self.ingredient.name = textField.text;
            break;
            
        default: //???
            break;
    }
    
}

- (BOOL)isProperMixedNumber:(NSString *)text
{//return YES;
    BOOL isProperMixedNumber = YES;
    
    NSUInteger len = [text length];
    unichar buffer[len];
    [text getCharacters:buffer range:NSMakeRange(0, len)];
    
    BOOL foundSpace = NO;
    BOOL foundSlash = NO;
    BOOL justFoundSpace = NO;
    BOOL justFoundSlash = NO;
    
    for(int i = 0; i < len; i++)
    {
        char c = buffer[i];
        if(i == 0)
        {
            if((c == ' ' || c == '/' || c == '0'))
            {
                isProperMixedNumber = NO;
                break;
            }
        }
        else
        {
            if(c == ' ' && (foundSpace || foundSlash))
            {
                isProperMixedNumber = NO;
                break;
            }
            if(c == '/' && foundSlash)
            {
                isProperMixedNumber = NO;
                break;
            }
            if(c == ' ' && !foundSpace)
            {
                foundSpace = YES;
                justFoundSpace = YES;
                continue;
            }
            if((c == '/' || c == '0') && justFoundSpace)
            {
                isProperMixedNumber = NO;
                break;
            }
            if(c == '/' && !foundSlash)
            {
                foundSlash = YES;
                justFoundSlash = YES;
                continue;
            }
            justFoundSpace = NO;
            justFoundSlash = NO;
        }
        
    }
   /*
    NSRange range = NSMakeRange(0, [text length]);
    NSError* error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if(error)
        NSLog(@"Something bad happened with the regex creation.");
    
    NSUInteger matches = [regex numberOfMatchesInString:text options:0 range:range];
    
    if(matches == 0)
        isProperMixedNumber = NO;
    */
    return isProperMixedNumber;
}

@end
