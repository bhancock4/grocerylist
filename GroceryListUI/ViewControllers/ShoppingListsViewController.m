//
//  ShoppingListsViewControllerTableViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "ShoppingListsViewController.h"

@implementation ShoppingListsViewController

//######################################################################################################
#pragma mark - Initialization & setup

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(cellTextFieldEndedEditing)
                                                 name: UITextFieldTextDidEndEditingNotification
                                               object: nil];
    
    ShoppingList* shoppingList = [ShoppingList getEntityByName:@"ShoppingList"];
    if(shoppingList == nil)
    {
        shoppingList = [ShoppingList newEntity];
        shoppingList.name = @"ShoppingList";
        [shoppingList saveEntity];
    }
    self.shoppingList = shoppingList;
    
    if(nil == self.shoppingList.shoppingListIngredients)
        self.shoppingList.shoppingListIngredients = [NSOrderedSet new];
    
    self.shoppingListIngredients = [NSMutableArray arrayWithArray: [self.shoppingList.shoppingListIngredients array]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"IngredientTableViewCell"
                                               bundle: [NSBundle mainBundle]]
                               forCellReuseIdentifier: @"IngredientTableViewCell"];
    
    self.keyboardIsShown = NO;
    self.tableView.allowsSelectionDuringEditing = YES;  //still allow cell selection
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.editing = YES;  //edit mode allows reordering
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//######################################################################################################
#pragma mark - Other methods

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
     insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

//save state of shoppig list whenever a cell is edited
- (void)cellTextFieldEndedEditing
{
    //begin weird hack -> last ingredient name not persisting so we add/delete a bogus entry to force save
    [self addShoppingListItem: self.AddButton];
    [self.shoppingListIngredients removeObjectAtIndex: 0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //...end weird hack
    
    self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray: self.shoppingListIngredients];
    [self.shoppingList saveEntity];
}

//toggle cell color (completion state) when long pressed
- (void)cellWasLongPressed:(UILongPressGestureRecognizer *) g
{
    if (g.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath* cellIndex = [self getCellIndexFromGesture: g];
        self.longPressIndex = cellIndex;
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellIndex];
        ShoppingListIngredient* shoppingListIngredient = ((ShoppingListIngredient *)[self.shoppingListIngredients objectAtIndex: cellIndex.row]);
        
        shoppingListIngredient.checked = !shoppingListIngredient.checked;
        cell.backgroundColor = shoppingListIngredient.checked ? [UIColor greenColor] : [UIColor whiteColor];
    }
}


//######################################################################################################
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
    cell.ingredientQuantityTextField.text = cell.ingredient.quantity;
    cell.ingredientNameTextField.text = cell.ingredient.name;
    
    //add a right-swipe gesture to move to delete
    UISwipeGestureRecognizer* swipeL;
    swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedLeft: )];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:swipeL];
    
    //add a long press gesture to pick status
    UILongPressGestureRecognizer* longPress;
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasLongPressed: )];
    longPress.minimumPressDuration = 0.25;  //seconds
    [cell.contentView addGestureRecognizer:longPress];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


//######################################################################################################
#pragma mark - Custom cell delete

- (void)cellWasSwipedLeft:(UIGestureRecognizer *)g
{
    NSIndexPath* cellIndex = [self getCellIndexFromGesture: g];
    self.swipeLIndex = cellIndex;
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellIndex];
    self.preAlertCellColor = cell.backgroundColor;
    cell.backgroundColor = [UIColor redColor];
    cell.textLabel.textColor = [UIColor blackColor];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Delete?"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    
    [alert show];
}

//handle result of user interaction with delete confirm dialog
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.swipeLIndex];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if(buttonIndex == [alertView cancelButtonIndex])
    {
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.swipeLIndex];
        cell.backgroundColor = self.preAlertCellColor;
    }
    else
    {
        [self.shoppingListIngredients removeObjectAtIndex:self.swipeLIndex.row];
        [self.tableView deleteRowsAtIndexPaths:@[self.swipeLIndex] withRowAnimation:UITableViewRowAnimationFade];
        
        if([self.shoppingListIngredients count] > 0)
        {
            for(int i = (int)self.swipeLIndex.row; i < [self.shoppingListIngredients count]; i++)
            {
                ShoppingListIngredient * item = [self.shoppingListIngredients objectAtIndex:i];
                item.order = i;
            }
        }
        self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray:self.shoppingListIngredients];
        [self.shoppingList saveEntity];
    }
}

- (NSIndexPath*)getCellIndexFromGesture:(UIGestureRecognizer *) g
{
    CGPoint p = [g locationInView:self.tableView];
    return [self.tableView indexPathForRowAtPoint:p];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//give up focus when return key is pressed on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray:self.shoppingListIngredients];
    [self.shoppingList saveEntity];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.shoppingListIngredients removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray: self.shoppingListIngredients];
        [self.shoppingList saveEntity];
    }
}


//######################################################################################################
#pragma mark - Cell reordering
//hide delete button during edit
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//hide delete button during edit
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

//allows reordering during edit
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString* strMove = self.shoppingListIngredients[fromIndexPath.row];
    [self.shoppingListIngredients removeObjectAtIndex:fromIndexPath.row];
    [self.shoppingListIngredients insertObject:strMove atIndex:toIndexPath.row];
    
    for(int i = 0; i < [self.shoppingListIngredients count]; i++)
    {
        ShoppingListIngredient* ingredient = [self.shoppingListIngredients objectAtIndex:i];
        ingredient.order = i;
    }
    self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray:self.shoppingListIngredients];
    [self.shoppingList saveEntity];
}

- (NSIndexPath*)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return proposedDestinationIndexPath;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
