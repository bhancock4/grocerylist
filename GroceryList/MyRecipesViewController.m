//
//  SecondViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "MyRecipesViewController.h"
#import "AddRecipeViewController.h"
#import "Recipe.h"
#import "AppDelegate.h"

@interface MyRecipesViewController ()

@property Recipe* selectedRecipe;

@end

@implementation MyRecipesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recipes = [Recipe getEntities];
    //self.tableView.editing = YES;  //edit mode allows reordering
    //self.tableView.allowsSelectionDuringEditing = YES;  //still allow cell selection
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowEditRecipe"])
    {
        AddRecipeViewController* addRecipeVC = (AddRecipeViewController *)segue.destinationViewController;
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        addRecipeVC.sourceSegue = segue.identifier;
        addRecipeVC.recipe = [self.recipes objectAtIndex: indexPath.row];
    }
}

- (IBAction)unwindToMyRecipes:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddRecipeViewController* source = [segue sourceViewController];
    Recipe* recipe = source.recipe;
    
    if(recipe != nil)
    {
        self.recipes = [Recipe getEntities];
        [self.tableView reloadData];
    }
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
    
    //if(indexPath.row < [self.toDoItems count])
    
        // Configure the cell
    Recipe* recipe = [self.recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = recipe.name;
    cell.imageView.image = [UIImage imageNamed: @"Calendar"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

@end
