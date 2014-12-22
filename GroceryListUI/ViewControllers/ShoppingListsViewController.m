//
//  ShoppingListsViewControllerTableViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "ShoppingListsViewController.h"

@implementation ShoppingListsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ShoppingList* shoppingList = [ShoppingList getEntityByName:@"ShoppingList"];
    if(shoppingList == nil)
    {
        shoppingList = [ShoppingList newEntity];
        shoppingList.name = @"ShoppingList";
        [shoppingList saveEntity];
    }
    self.shoppingList = shoppingList;
    
    if(nil == self.shoppingList.shoppingListIngredients)
    {
        self.shoppingList.shoppingListIngredients = [NSSet new];
    }
    
    self.shoppingListIngredients = [NSMutableArray arrayWithArray: [self.shoppingList.shoppingListIngredients allObjects]];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(cellTextFieldEndedEditing) name: UITextFieldTextDidEndEditingNotification object: nil];
}

//need to add code to get selected text field
- (void)cellTextFieldEndedEditing
{
    self.shoppingList.shoppingListIngredients = [NSSet setWithArray:self.shoppingListIngredients];
    [self.shoppingList saveEntity];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.keyboardIsShown = NO;
    
    //self.tableView.editing = YES;  //edit mode allows reordering
    self.tableView.allowsSelectionDuringEditing = YES;  //still allow cell selection
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IngredientTableViewCell"
                                                            bundle:[NSBundle mainBundle]]
                      forCellReuseIdentifier:@"IngredientTableViewCell"];
    
}

- (void) addShoppingListItem:(id)sender
{
    //instantiate a new ingredient entity
    ShoppingListIngredient* shoppingListIngredient = [ShoppingListIngredient newEntity];
    
    shoppingListIngredient.order = 0;
    for(int i = 0; i < self.shoppingListIngredients.count; i++)
    {
        ++((ShoppingListIngredient *)self.shoppingListIngredients[i]).order;
    }
    
    //insert the new ingredient at the TOP of the table by putting it at the beginning of our local array
    [self.shoppingListIngredients insertObject:shoppingListIngredient atIndex:0];
    
    //create in indexpath from the local array and use that to insert into the table
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.shoppingListIngredients indexOfObject:shoppingListIngredient] inSection:0];
    [self.tableView
     insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shoppingListIngredients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //add our custom cell
    static NSString *CellIdentifier = @"IngredientTableViewCell";
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.viewControllerName = @"ShoppingListsViewController";
    
    //set the recipIngredient on the cell so it can manage changes to fields
    cell.ingredient = [self.shoppingListIngredients objectAtIndex:indexPath.row];
    
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
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    [self.ingredientTextField resignFirstResponder];
}

//give up focus when return key is pressed on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.shoppingListIngredients removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.shoppingList.shoppingListIngredients = [NSSet setWithArray: self.shoppingListIngredients];
        [self.shoppingList saveEntity];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
