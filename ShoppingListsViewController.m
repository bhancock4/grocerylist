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
    NSArray* lists = [ShoppingList getEntities];
    if(lists.count > 0)
    {
        self.shoppingList = [ShoppingList getEntities][0];
        if(!(nil == self.shoppingList))
        {
            self.shoppingListIngredients = [NSMutableArray arrayWithArray: [self.shoppingList.shoppingListIngredients allObjects]];
            [self.tableView reloadData];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.tableView.editing = YES;  //edit mode allows reordering
    self.tableView.allowsSelectionDuringEditing = YES;  //still allow cell selection
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
    static NSString *CellIdentifier = @"ShoppingListIngredientCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    ShoppingListIngredient* shoppingListIngredient = [self.shoppingListIngredients objectAtIndex:indexPath.row];
    
    NSString* ingredientQuantity = shoppingListIngredient.quantity == nil ? @"" : shoppingListIngredient.quantity;
    
    NSString* ingredientUnit = shoppingListIngredient.unit == nil ? @"" : shoppingListIngredient.unit;
    
    NSArray* ingredientTextComponents = @[ingredientQuantity, ingredientUnit, shoppingListIngredient.name];
    
    cell.textLabel.text = [ingredientTextComponents componentsJoinedByString:@" "];

    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [ShoppingListIngredient deleteEntity: [self.shoppingListIngredients objectAtIndex:indexPath.row]];
        [self.shoppingListIngredients removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
