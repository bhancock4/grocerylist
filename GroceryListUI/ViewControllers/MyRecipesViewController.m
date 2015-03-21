//
//  SecondViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "MyRecipesViewController.h"

@implementation MyRecipesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableIsFiltered = NO;
    
    self.recipes = [[Recipe getEntitiesWithSortProperty: @"name"] mutableCopy];
    self.filteredRecipes = [NSMutableArray arrayWithCapacity:[self.recipes count]];
    
    self.isInMultiSelectMode = NO;
    
    self.addButton = self.navigationItem.rightBarButtonItem;
    
    //figure out if we got here by adding a new recipe or viewing/editing an existing one
    if([self.sourceSegue isEqualToString:@"SelectRecipesForCalendar"])
    {
        self.isInMultiSelectMode = YES;
        self.selectedRecipes = [NSMutableArray new];
        self.doneButton.enabled = YES;
        self.addButton.enabled = NO;
    }
    else
    {
        self.doneButton.enabled = NO;
        self.addButton.enabled = YES;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName: @"RecipeTableViewCell"
                                               bundle: [NSBundle mainBundle]]
         forCellReuseIdentifier: @"RecipeTableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL shouldSegue = YES;
    if(self.isInMultiSelectMode)
    {
        if(nil != identifier)
            shouldSegue = NO;
        else
        {
            self.calendarDay.recipes = [NSSet setWithArray: self.selectedRecipes];
            [self.calendarDay saveEntity];
        }
    }
    return shouldSegue;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //in the case where we're segue-ing from an existing recipe, we want to give the target ViewController a way to know that, so we set a property on that ViewController
    if([segue.identifier isEqualToString:@"ShowEditRecipe"])
    {
        AddRecipeViewController* addRecipeVC = (AddRecipeViewController *)segue.destinationViewController;
        //NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        addRecipeVC.sourceSegue = segue.identifier;
        
        //also, pass the selected recipe along to that ViewController
        //addRecipeVC.recipe = [self.recipes objectAtIndex: indexPath.row];
        
        if(self.tableIsFiltered)
        {
            NSIndexPath* indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            
            addRecipeVC.recipe = [self.filteredRecipes objectAtIndex: indexPath.row];
        }
        else
        {
            NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
            addRecipeVC.recipe = [self.recipes objectAtIndex:indexPath.row];
        }
    }
}

- (IBAction)unwindToMyRecipes:(UIStoryboardSegue *)segue sender:(id)sender
{
    //get the recipe we just looked at...
    AddRecipeViewController* source = [segue sourceViewController];
    Recipe* recipe = source.recipe;
    [recipe saveEntity];
    //...and if it's not null then reload our table
    if(recipe != nil)
    {
        self.recipes = [NSMutableArray arrayWithArray:[Recipe getEntities]];
        [self.tableView reloadData];
    }
}

- (IBAction)unwindToCalendar:(id)sender
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        self.tableIsFiltered = YES;
        return self.filteredRecipes.count;
    }
    else
    {
        self.tableIsFiltered = NO;
        return [self.recipes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecipeTableViewCell";
    RecipeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //set up the tableCell based on the recipe populating it
    Recipe* recipe = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        recipe = [self.filteredRecipes objectAtIndex: indexPath.row];
    }
    else
    {
        recipe = [self.recipes objectAtIndex:indexPath.row];
    }
    
    if(nil == recipe.picture)
        cell.imageView.image = [UIImage imageNamed: @"Calendar"];
    else
        cell.imageView.image = [UIImage imageWithData:recipe.picture];
    
    cell.textLabel.text = recipe.name;
    
    if(self.isInMultiSelectMode)
    {
        for(Recipe* selectedRecipe in self.selectedRecipes)
        {
            if([selectedRecipe.name isEqualToString:recipe.name])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                break;
            }
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    UIView *crossView = [self viewWithImageName:@"RedXDelete"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    [cell setSwipeGestureWithView:crossView
                            color:redColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell* cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         [self deleteRecipeForCell:(RecipeTableViewCell *)cell];
     }];
    
    cell.firstTrigger = 0.35;
    cell.secondTrigger = 0.65;
    
    return cell;
}

- (void) deleteRecipeForCell: (RecipeTableViewCell *) cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [Recipe deleteEntity: [self.recipes objectAtIndex:indexPath.row]];
    [self.recipes removeObjectAtIndex:indexPath.row];
    
    // Delete the row from the table view
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (UIView *)viewWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isInMultiSelectMode)
    {
        Recipe* recipe = [self.recipes objectAtIndex:indexPath.row];
        BOOL foundRecipe = NO;
        for(Recipe* selectedRecipe in self.selectedRecipes)
        {
            if([selectedRecipe.name isEqualToString:recipe.name])
            {
                foundRecipe = YES;
                [self.selectedRecipes removeObject:selectedRecipe];
                break;
            }
        }
        if(!foundRecipe)
            [self.selectedRecipes addObject:recipe];
        
        [self.tableView reloadData];
    }
    else
        [self performSegueWithIdentifier:@"ShowEditRecipe" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 66;
}

- (void) filterContentForSearchText: (NSString *) searchText scope: (NSString *) scope
{
    [self.filteredRecipes removeAllObjects];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name beginswith[c] %@", searchText];
    self.filteredRecipes = [NSMutableArray arrayWithArray:[self.recipes filteredArrayUsingPredicate:predicate]];
}

- (BOOL) searchDisplayController: (UISearchDisplayController *) controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope: [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex: [self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [Recipe deleteEntity: [self.recipes objectAtIndex:indexPath.row]];
        [self.recipes removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
