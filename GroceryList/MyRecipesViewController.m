//
//  SecondViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "MyRecipesViewController.h"
#import "AddRecipeViewController.h"
#import "RecipeDataAccess.h"
#import "Recipe.h"

@interface MyRecipesViewController ()

@end

@implementation MyRecipesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToMyRecipes:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)unwindToMyRecipes:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSMutableArray* recipes = [RecipeDataAccess getRecipes];
    //recipes = nil;
    
    
    
    
    AddRecipeViewController* source = [segue sourceViewController];
    Recipe* recipe = source.recipe;
    
    if(recipe != nil)
    {
        //item.order = (int)[self.toDoItems count];
        //[XYZDataAccess updateToDoListItem: item];
        //self.recipes = [XYZDataAccess getToDoListItemByCompleted:NO];
        //self.recipes[0] = recipe;
        //[self.tableView reloadData];
    }
    recipe = [Recipe new];
    recipe.name = @"test recipe";
    recipe.directions = @"test recipe directions";
    
    NSMutableArray* ingredients = [NSMutableArray new];
    RecipeIngredient* ri1 = [RecipeIngredient new];
    ri1.unit = @"cups";
    ri1.quantity = 1;
    ri1.name = @"sugar";
    [ingredients addObject: ri1];
    
    RecipeIngredient* ri2 = [RecipeIngredient new];
    ri2.unit = @"ounces";
    ri2.quantity = 2;
    ri2.name = @"water";
    [ingredients addObject: ri2];
    
    recipe.recipeIngredients = ingredients;
    
    [RecipeDataAccess insertRecipe:recipe];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyRecipesCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //if(indexPath.row < [self.toDoItems count])
      {
        // Configure the cell
        Recipe* recipe = [self.recipes objectAtIndex:indexPath.row];
        cell.textLabel.text = recipe.name;
        //cell.backgroundColor = [XYZUtilities getCellColorFromStatus:toDoItem.status];
      }
      //else
     // {
         // cell.textLabel.text = @"";
       //   cell.backgroundColor = [UIColor whiteColor];
     // }
    return cell;
}


@end
