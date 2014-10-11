//
//  AddRecipeViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "AddRecipeViewController.h"
#import "AppDelegate.h"
#import "RecipeDataAccess.h"

@interface AddRecipeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *recipeName;
@property (weak, nonatomic) IBOutlet UITextField *recipeDirections;
@property (weak, nonatomic) IBOutlet UITableView *tableRecipeIngredients;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property BOOL isUpdating;
@property NSString* initialRecipeName;
@end

@implementation AddRecipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self.sourceSegue isEqualToString:@"ShowEditRecipe"])
    {
        self.recipeName.text = self.recipe.name;
        self.recipeDirections.text = self.recipe.directions;
        self.initialRecipeName = self.recipe.name;
        self.isUpdating = YES;
    }
    else
        self.isUpdating = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL shouldSegue = YES;
    
    if(self.isUpdating)
        self.recipe = [RecipeDataAccess getRecipeByName:self.initialRecipeName];
    else
        self.recipe = [RecipeDataAccess initNewRecipe];
    
    if(nil != self.recipe && sender == self.saveButton && self.recipeName.text.length > 0)
    {
        self.recipe.name = self.recipeName.text;
        self.recipe.directions = self.recipeDirections.text;
        
        if(![RecipeDataAccess saveRecipe: self.recipe])
        {
            shouldSegue = NO;
            
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:@"Recipe Save Error" message: @"An error occurred saving the recipe." delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    return shouldSegue;
    
    
/*    NSEntityDescription *recipeIngredientEntityDescription = [NSEntityDescription entityForName:@"RecipeIngredient" inManagedObjectContext:context];
    
    NSMutableSet* ingredients = [NSMutableSet new];
    RecipeIngredient* ri1 = [[RecipeIngredient alloc] initWithEntity:recipeIngredientEntityDescription insertIntoManagedObjectContext:context];
    ri1.unit = @"cups";
    ri1.quantity = [NSNumber numberWithInt:1];
    ri1.name = @"sugar";
    [ingredients addObject: ri1];
    
    RecipeIngredient* ri2 = [[RecipeIngredient alloc] initWithEntity:recipeIngredientEntityDescription insertIntoManagedObjectContext:context];
    ri2.unit = @"ounces";
    ri2.quantity = [NSNumber numberWithInt:2];
    ri2.name = @"water";
    [ingredients addObject: ri2];
    
    recipe.recipeIngredients = ingredients;
 */
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
