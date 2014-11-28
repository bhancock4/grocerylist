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
    
    self.recipes = [[Recipe getEntities] mutableCopy];
    
    self.isInMultiSelectMode = NO;
    
    //figure out if we got here by adding a new recipe or viewing/editing an existing one
    if([self.sourceSegue isEqualToString:@"SelectRecipesForCalendar"])
    {
        self.isInMultiSelectMode = YES;
        self.selectedRecipes = [NSMutableArray new];
        //NSMutableArray* toolBarButtons = [self.toolbarItems mutableCopy];
        //[toolBarButtons removeObject:self.doneButton];
        //[self setToolbarItems: toolBarButtons animated: NO];
    }

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
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        addRecipeVC.sourceSegue = segue.identifier;
        
        //also, pass the selected recipe along to that ViewController
        addRecipeVC.recipe = [self.recipes objectAtIndex: indexPath.row];
    }
}

- (IBAction)unwindToMyRecipes:(UIStoryboardSegue *)segue sender:(id)sender
{
    //get the recipe we just looked at...
    AddRecipeViewController* source = [segue sourceViewController];
    Recipe* recipe = source.recipe;
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
    // Return the number of rows in the section.
    return [self.recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyRecipesCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //set up the tableCell based on the recipe populating it
    Recipe* recipe = [self.recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = recipe.name;
    if(nil == recipe.picture)
        cell.imageView.image = [UIImage imageNamed: @"Calendar"];
    else
        cell.imageView.image = [UIImage imageWithData:recipe.picture];
    
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
    return cell;
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 66;
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
