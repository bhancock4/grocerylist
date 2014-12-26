//
//  AddRecipeViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "AddRecipeViewController.h"

@implementation AddRecipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.keyboardIsShown = NO;
    //initializeour array of ingredients
    self.recipeIngredients = [[NSMutableArray alloc] init];
    
    //figure out if we got here by adding a new recipe or viewing/editing an existing one
    if([self.sourceSegue isEqualToString:@"ShowEditRecipe"])
    {
        /* existing recipe, so let's set all the UI fields from the entity, which was given to us by the previous ViewController */
        
        //for now at least, prevent editing of an existing recipe's name property
        self.navigationItem.title = self.recipe.name;
        self.recipeName.text = self.recipe.name;
        self.RecipeImage.image = [UIImage imageWithData:self.recipe.picture];
        //...set other fields
        self.recipeDirections.text = self.recipe.directions;
        //set our ingredients array to the entity's recipeIngredients relationship property
        self.recipeIngredients = [NSMutableArray arrayWithArray:[self.recipe.recipeIngredients array]];

        self.isExistingRecipe = YES;
        self.addToList.enabled = YES;
    }
    else
    {
        self.recipeName.selected = YES;
        self.isExistingRecipe = NO;
        self.addToList.enabled = NO;
    }
    
    //allow keyboard to be dismissed with a "Done" button
    [self addDoneToolBarToTextFieldKeyboard: self.recipeName];
    [self addDoneToolBarToTextViewKeyboard: self.recipeDirections];
    
    //add some styling to the text field to make it obvious what the boundaries are
    [[self.recipeDirections layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.recipeDirections layer] setBorderWidth:2.0];
    [[self.recipeDirections layer] setCornerRadius:10];
    
    //set this ViewController as the delegate for the text fields
    self.recipeName.delegate = self;
    self.recipeDirections.delegate = self;
    
    //set this ViewController as the delegate/datasource for the ingredients table
    self.tableRecipeIngredients.delegate = self;
    self.tableRecipeIngredients.dataSource = self;
    //prevent ingredients table from showing extra lines
    self.tableRecipeIngredients.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableRecipeIngredients registerNib:[UINib nibWithNibName:@"IngredientTableViewCell"
                                      bundle:[NSBundle mainBundle]]
                      forCellReuseIdentifier:@"IngredientTableViewCell"];
    
    self.tableRecipeIngredients.allowsMultipleSelectionDuringEditing = NO;
    self.tableRecipeIngredients.editing = YES;  //edit mode allows reordering
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//hide delete button during edit
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//allows reordering during edit
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//hide delete button during edit
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

//construct an instance of a UIToolBar for the keyboard that contains a "Done" button
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

//tried doing this with UIControl instead of 2 methods, but apparently the inputAccessoryView
//property is readonly on that class
-(void)addDoneToolBarToTextFieldKeyboard:(UITextField *) textField
{
    UIToolbar* doneToolbar = [self getDoneKeyboardToolbar];
    textField.inputAccessoryView = doneToolbar;
}

//see above comment
-(void)addDoneToolBarToTextViewKeyboard:(UITextView *) textView
{
    UIToolbar* doneToolbar = [self getDoneKeyboardToolbar];
    textView.inputAccessoryView = doneToolbar;
}

//dismiss keyboard when done button is clicked
-(void)doneButtonClickedDismissKeyboard
{
    [self.recipeName resignFirstResponder];
    [self.recipeDirections resignFirstResponder];
}

//give up focus when return key is pressed on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//button click to add a new ingredient to the recipe
- (IBAction) handleAddIngredientClicked:(id)sender
{
    //instantiate a new ingredient entity
    RecipeIngredient* recipeIngredient = [RecipeIngredient newEntity];
  
    recipeIngredient.order = 0;
    for(int i = 0; i < self.recipeIngredients.count; i++)
    {
        ++((RecipeIngredient *)self.recipeIngredients[i]).order;
    }
    
    //insert the new ingredient at the TOP of the table by putting it at the beginning of our local array
    [self.recipeIngredients insertObject:recipeIngredient atIndex:0];

    //create in indexpath from the local array and use that to insert into the table
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.recipeIngredients indexOfObject:recipeIngredient] inSection:0];
    [self.tableRecipeIngredients
     insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    self.addToList.enabled = NO;
}

//button click to add or update recipe image
- (IBAction)handleRecipeImageButtonClicked:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Take picture or select from library?"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Camera", @"Photo Library", nil];
    [alert setTag: 2];
    [alert show];
}

- (void) presentCamera
{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}


- (void) presentPhotoLibrary
{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* chosenImage = info[UIImagePickerControllerEditedImage];
    self.RecipeImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL shouldSegue = YES;
    
    if(sender == self.cancelButton)
    {
        self.recipe = nil;
        return shouldSegue;
    }
    
    //check for required fields
    NSString* validationFailureMessage = [self getValidationMessage];
    if([validationFailureMessage length] > 0)
    {
        shouldSegue = NO;
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:@"Validation Error" message: validationFailureMessage delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if(self.isExistingRecipe)
            self.recipe = [Recipe getEntityByName:self.recipe.name];
        else
            self.recipe = [Recipe newEntity];
    
        //check for required fields
        NSString* validationFailureMessage = [self getValidationMessage];
        if([validationFailureMessage length] > 0)
        {
            shouldSegue = NO;
            
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:@"Validation Error" message: validationFailureMessage delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
            [alert setTag: 3];
            [alert show];
        }
        else //passed validation
        {
            //set fields on the entity to be saved
            self.recipe.name = self.recipeName.text;
            self.recipe.picture = UIImagePNGRepresentation(self.RecipeImage.image);
            self.recipe.directions = self.recipeDirections.text;
            self.recipe.recipeIngredients = [NSOrderedSet orderedSetWithArray: self.recipeIngredients];
        
            //if something bad happens then display a pop-up error to the user
            if(![self.recipe saveEntity])
            {
                shouldSegue = NO;
            
                UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:@"Recipe Save Error" message: @"An error occurred saving the recipe." delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
                [alert setTag: 3];
                [alert show];
            }
        }
    }
    return shouldSegue;
}
            
- (NSString *) getValidationMessage
{
    NSString* validationMessage = @"";
    
    //ensure the recipe has a name
    if([self.recipeName.text length] == 0)
        validationMessage = @"You must supply a recipe name";
    
    //ensure that the name is unique
    Recipe* existingRecipe = [Recipe getEntityByName: self.recipeName.text];
    if(nil != existingRecipe && !self.isExistingRecipe)
        validationMessage = @"A recipe with that name already exists";
    
    //ensure each ingredient has a name
    for(RecipeIngredient* recipeIngredient in self.recipeIngredients)
    {
        if([recipeIngredient.name length] == 0)
            validationMessage = @"You must supply a name for each ingredient";
    }
    return validationMessage;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipeIngredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //add our custom cell
    static NSString *CellIdentifier = @"IngredientTableViewCell";
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //set the recipIngredient on the cell so it can manage changes to fields
    cell.ingredient = [self.recipeIngredients objectAtIndex:indexPath.row];
    
    //set the units UIPicker selected value based on the unit value of the RecipeIngredient entity
    for(int i = 0; i < cell.pickerData.count; i++)
    {
        if([cell.pickerData[i] isEqualToString:cell.ingredient.unit])
        {
            [cell.ingredientUnitsUIPickerView selectRow:i inComponent:0 animated:NO];
        }
    }
    //set the other UI fields on the custom cell
    cell.ingredientQuantityTextField.text = [Utilities getFractionalValue: [Utilities getDecimalValue: cell.ingredient.quantity]];
    cell.ingredientNameTextField.text = cell.ingredient.name;
    
    //add a right-swipe gesture to move to delete
    UISwipeGestureRecognizer* swipeL;
    swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedLeft: )];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:swipeL];
    
    return cell;
}

- (void)cellWasSwipedLeft:(UIGestureRecognizer *)g
{
    NSIndexPath* cellIndex = [self getCellIndexFromGesture: g];
    self.swipeLIndex = cellIndex;
    UITableViewCell* cell = [self.tableRecipeIngredients cellForRowAtIndexPath:cellIndex];
    self.preAlertCellColor = cell.backgroundColor;
    cell.backgroundColor = [UIColor redColor];
    cell.textLabel.textColor = [UIColor blackColor];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Delete?"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert setTag: 1];
    
    [alert show];
}

//handle result of user interaction with delete confirm dialog
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        UITableViewCell* cell = [self.tableRecipeIngredients cellForRowAtIndexPath:self.swipeLIndex];
        cell.textLabel.textColor = [UIColor blackColor];
    
        if(buttonIndex == [alertView cancelButtonIndex])
        {
            UITableViewCell* cell = [self.tableRecipeIngredients cellForRowAtIndexPath:self.swipeLIndex];
            cell.backgroundColor = self.preAlertCellColor;
        }
        else
        {
            [self.recipeIngredients removeObjectAtIndex:self.swipeLIndex.row];
            [self.tableRecipeIngredients deleteRowsAtIndexPaths:@[self.swipeLIndex] withRowAnimation:UITableViewRowAnimationFade];
        
            if([self.recipeIngredients count] > 0)
            {
                for(int i = (int)self.swipeLIndex.row; i < [self.recipeIngredients count]; i++)
                {
                    RecipeIngredient* item = [self.recipeIngredients objectAtIndex:i];
                    item.order = i;
                }
            }
        }
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == [alertView cancelButtonIndex])
        {
            return;
        }
        else if(buttonIndex == 1)
        {
            [self presentCamera];
        }
        else
        {
            [self presentPhotoLibrary];
        }
    }
}

- (NSIndexPath*)getCellIndexFromGesture:(UIGestureRecognizer *) g
{
    CGPoint p = [g locationInView:self.tableRecipeIngredients];
    return [self.tableRecipeIngredients indexPathForRowAtPoint:p];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //...this will only persist if we select "save" instead of "cancel"
        [self.recipeIngredients removeObjectAtIndex:indexPath.row];
        [self.tableRecipeIngredients deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString* strMove = self.recipeIngredients[fromIndexPath.row];
    [self.recipeIngredients removeObjectAtIndex:fromIndexPath.row];
    [self.recipeIngredients insertObject:strMove atIndex:toIndexPath.row];
    
    for(int i = 0; i < [self.recipeIngredients count]; i++)
    {
        RecipeIngredient* ingredient = [self.recipeIngredients objectAtIndex:i];
        ingredient.order = i;
    }
}

- (NSIndexPath*)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return proposedDestinationIndexPath;
}

-(void)keyboardWillShow
{
    if(!self.keyboardIsShown)
    {
        self.keyboardIsShown = YES;
        for(UIView* view in self.view.subviews)
        {
            if(view.isFirstResponder)
            {
                if(view == self.recipeName || view == self.recipeDirections)
                    return;
            }
        }
        [self setViewMovedUp: self.view.frame.origin.y >= 0];
    }
}

-(void)keyboardWillHide
{
    self.keyboardIsShown = NO;
    for(UIView* view in self.view.subviews)
    {
        if(view.isFirstResponder)
        {
            if(view == self.recipeName || view == self.recipeDirections)
                return;
        }
    }
    [self setViewMovedUp: self.view.frame.origin.y >= 0];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    int cellIndex = self.selectedIngredientRow < 4 ? self.selectedIngredientRow : 4;
    int keyboardOffset = kOFFSET_FOR_KEYBOARD + (cellIndex * 44);
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= keyboardOffset;
        rect.size.height += keyboardOffset;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += keyboardOffset;
        rect.size.height -= keyboardOffset;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

//register listeners for keyboard event notifications before view is loaded
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//remove listeners for keyboard event notifications when view is being destroyed
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

//button click to add a new ingredient to the recipe
- (IBAction)AddToList:(id)sender 
{
    [Utilities addToList: @[self.recipe]];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
