//
//  AddRecipeViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 80.0
#import "AddRecipeViewController.h"

@implementation AddRecipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
        self.recipeIngredients = [NSMutableArray arrayWithArray:[self.recipe.recipeIngredients allObjects]];

        self.isExistingRecipe = YES;
    }
    else
    {
        self.recipeName.selected = YES;
        
        self.isExistingRecipe = NO;
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
    
    [self.tableRecipeIngredients registerNib:[UINib nibWithNibName:@"RecipeIngredientTableViewCell"
                                      bundle:[NSBundle mainBundle]]
                      forCellReuseIdentifier:@"RecipeIngredientTableViewCell"];
    
    self.tableRecipeIngredients.allowsMultipleSelectionDuringEditing = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

-(void)addDoneToolBarToTextViewKeyboard:(UITextView *) textView
{
    UIToolbar* doneToolbar = [self getDoneKeyboardToolbar];
    textView.inputAccessoryView = doneToolbar;
}

-(void)doneButtonClickedDismissKeyboard
{
    [self.recipeName resignFirstResponder];
    [self.recipeDirections resignFirstResponder];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}

//button click to add or update recipe image
- (IBAction)handleRecipeImageButtonClicked:(id)sender
{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
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
        self.recipe = nil;
    else
    {
        if(self.isExistingRecipe)
            self.recipe = [Recipe getEntityByName:self.recipe.name];
        else
            self.recipe = [Recipe newEntity];
    }
    
    //if whatever validation we need succeeds...
    if(nil != self.recipe && sender == self.saveButton && self.recipeName.text.length > 0)
    {
        //set fields on the entity to be saved
        self.recipe.name = self.recipeName.text;
        self.recipe.picture = UIImagePNGRepresentation(self.RecipeImage.image);
        self.recipe.directions = self.recipeDirections.text;
        self.recipe.recipeIngredients = [NSSet setWithArray: self.recipeIngredients];
        
        //if something bad happens then display a pop-up error to the user
        if(![self.recipe saveEntity])
        {
            shouldSegue = NO;
            
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:@"Recipe Save Error" message: @"An error occurred saving the recipe." delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    return shouldSegue;
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
    static NSString *CellIdentifier = @"RecipeIngredientTableViewCell";
    RecipeIngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //set the recipIngredient on the cell so it can manage changes to fields
    cell.recipeIngredient = [self.recipeIngredients objectAtIndex:indexPath.row];
    
    //set the units UIPicker selected value based on the unit value of the RecipeIngredient entity
    for(int i = 0; i < cell.pickerData.count; i++)
    {
        if([cell.pickerData[i] isEqualToString:cell.recipeIngredient.unit])
        {
            [cell.ingredientUnitsUIPickerView selectRow:i inComponent:0 animated:NO];
        }
    }
    //set the other UI fields on the custom cell
    cell.ingredientQuantityTextField.text = cell.recipeIngredient.quantity;
    cell.ingredientNameTextField.text = cell.recipeIngredient.name;
    
    return cell;
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

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
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
 
 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
