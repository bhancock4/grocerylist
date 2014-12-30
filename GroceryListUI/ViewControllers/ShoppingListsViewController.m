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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray: self.shoppingListIngredients];
    [self.shoppingList saveEntity];
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
        self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray: self.shoppingListIngredients];
        [self.shoppingList saveEntity];
        
        cell.backgroundColor = shoppingListIngredient.checked ? [UIColor greenColor] : [UIColor whiteColor];
    }
}

- (IBAction)clearShoppingList:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Clear all or completed?"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Clear All", @"Clear Completed", nil];
    
    [alert setTag:2];
    [alert show];
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

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // Remove inset of iOS 7 separators.
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Setting the background color of the cell.
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    // Configuring the views and colors.
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    UIView *clockView = [self viewWithImageName:@"clock"];
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    
    UIView *listView = [self viewWithImageName:@"list"];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    [cell.textLabel setText:@"Switch Mode Cell"];
    [cell.detailTextLabel setText:@"Swipe to switch"];
    
    // Adding gestures per state basis.
    [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Checkmark\" cell");
    }];
    
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Cross\" cell");
    }];
    
    [cell setSwipeGestureWithView:clockView color:yellowColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Clock\" cell");
    }];
    
    [cell setSwipeGestureWithView:listView color:brownColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"List\" cell");
    }];
    
    return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //add our custom cell
    static NSString *CellIdentifier = @"IngredientTableViewCell";
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        cell.separatorInset = UIEdgeInsetsZero;

    
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
    
    //add a long press gesture to pick status
    UILongPressGestureRecognizer* longPress;
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasLongPressed: )];
    longPress.minimumPressDuration = 0.25;  //seconds
    [cell.contentView addGestureRecognizer:longPress];
    
    cell.backgroundColor = cell.ingredient.checked ? [UIColor greenColor] : [UIColor whiteColor];
    
    UIView *crossView = [self viewWithImageName:@"Calendar"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    [cell setSwipeGestureWithView:crossView
                            color:redColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell* cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
                    {
                        [self deleteIngredientForCell:(IngredientTableViewCell *)cell];
                     }];
    
    cell.firstTrigger = 0.35;
    cell.secondTrigger = 0.65;
    
    return cell;
}

- (void) deleteIngredientForCell: (IngredientTableViewCell *) cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.shoppingListIngredients removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if([self.shoppingListIngredients count] > 0)
    {
        for(int i = (int)indexPath.row; i < [self.shoppingListIngredients count]; i++)
        {
            ShoppingListIngredient * item = [self.shoppingListIngredients objectAtIndex:i];
            item.order = i;
        }
    }
    self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray:self.shoppingListIngredients];
    [self.shoppingList saveEntity];
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

//handle result of user interaction with delete confirm dialog
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //clearing items from list
    if(alertView.tag == 2)  //there used to be a 1...
    {   //if not cancel...
        if(buttonIndex != [alertView cancelButtonIndex])
        {   //if we are clearing all items
            if(buttonIndex == 1)
            {
                for(int i = (int)self.shoppingListIngredients.count - 1; i >= 0; i--)
                {
                    [self.shoppingListIngredients removeObjectAtIndex:i];
                }
            }
            else //otherwise only clear completed items
            {
                for(int i = (int)self.shoppingListIngredients.count - 1; i >= 0; i--)
                {
                    if(((ShoppingListIngredient *)[self.shoppingListIngredients objectAtIndex:i]).checked)
                    {
                        [self.shoppingListIngredients removeObjectAtIndex:i];
                    }
                }
                //now some elements have been removed so we need to reset the orders on the collection...
                //we'll sort the elements into an array using the existing order and then just reset from 0
                NSSortDescriptor *sortDescriptor;
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order"
                                                             ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                NSArray *sortedArray;
                sortedArray = [self.shoppingListIngredients sortedArrayUsingDescriptors:sortDescriptors];
                for(int i = 0; i < self.shoppingListIngredients.count; i++)
                {
                    ((ShoppingListIngredient *)sortedArray[i]).order = i;
                }
                
            }
            self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray: self.shoppingListIngredients];
            [self.shoppingList saveEntity];
            [self.tableView reloadData];
        }
    }
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
