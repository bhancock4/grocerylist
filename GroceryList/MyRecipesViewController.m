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
    
    self.recipes = [Recipe getEntities];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //set up the tableCell based on the recipe populating it
    Recipe* recipe = [self.recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = recipe.name;
    if(nil == recipe.picture)
        cell.imageView.image = [UIImage imageNamed: @"Calendar"];
    else
        cell.imageView.image = [UIImage imageWithData:recipe.picture];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 66;
}

@end
