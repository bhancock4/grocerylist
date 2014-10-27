//
//  AddRecipeViewController.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "AddRecipeViewController.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import <QuartzCore/QuartzCore.h>

@interface AddRecipeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *recipeName;
@property (weak, nonatomic) IBOutlet UIImageView *RecipeImage;
@property (weak, nonatomic) IBOutlet UITextView *recipeDirections;
@property (weak, nonatomic) IBOutlet UITableView *tableRecipeIngredients;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *btnAddIngredient;
@end

@implementation AddRecipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recipeIngredients = [[NSMutableArray alloc] init];
    
    if([self.sourceSegue isEqualToString:@"ShowEditRecipe"])
    {
        self.navigationItem.title = self.recipe.name;
        self.recipeName.hidden = YES;
        self.recipeName.text = self.recipe.name;
        self.recipeName.userInteractionEnabled = NO;
        self.initialRecipeName = self.recipe.name;
        self.recipeDirections.text = self.recipe.directions;
        self.recipeIngredients = [NSMutableArray arrayWithArray:[self.recipe.recipeIngredients allObjects]];
        
        self.isUpdating = YES;
    }
    else
    {
        self.recipeName.selected = YES;
        
        self.isUpdating = NO;
    }
    [[self.recipeDirections layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.recipeDirections layer] setBorderWidth:2.0];
    [[self.recipeDirections layer] setCornerRadius:10];
    
    self.tableRecipeIngredients.delegate = self;
    self.tableRecipeIngredients.dataSource = self;
    self.tableRecipeIngredients.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)handleAddIngredientClicked:(id)sender
{
    RecipeIngredient* recipeIngredient = [RecipeIngredient newEntity];
    
    recipeIngredient.unit = @"oz";
    recipeIngredient.quantity = [NSNumber numberWithInt:1];
    
    [self.recipeIngredients insertObject:recipeIngredient atIndex:0];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.recipeIngredients indexOfObject:recipeIngredient] inSection:0];

    [self.tableRecipeIngredients
     insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    BOOL shouldSegue = YES;
    
    if(self.isUpdating)
        self.recipe = [Recipe getEntityByName:self.initialRecipeName];
    else
        self.recipe = [Recipe newEntity];
    
    if(nil != self.recipe && sender == self.saveButton && self.recipeName.text.length > 0)
    {
        self.recipe.name = self.recipeName.text;
        self.recipe.directions = self.recipeDirections.text;
        self.recipe.recipeIngredients = [NSSet setWithArray: self.recipeIngredients];
        
        if(![self.recipe saveEntity])
        {
            shouldSegue = NO;
            
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:@"Recipe Save Error" message: @"An error occurred saving the recipe." delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    return shouldSegue;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.recipeIngredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IngredientCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITextField* ingredientTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, 275, 30)];
    ingredientTextField.adjustsFontSizeToFitWidth = YES;
    ingredientTextField.textColor = [UIColor blackColor];
    ingredientTextField.text = ((RecipeIngredient *)[self.recipeIngredients objectAtIndex:indexPath.row]).name;
    ingredientTextField.tag = indexPath.row;
    ingredientTextField.delegate = self;
    [ingredientTextField setEnabled:YES];
    [cell.contentView addSubview:ingredientTextField];
    
    [ingredientTextField addTarget:self
                            action:@selector(textFieldInputDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

- (void) textFieldInputDidChange:(UITextField *) textField
{
    RecipeIngredient* ingredient = self.recipeIngredients[textField.tag];
    ingredient.name = textField.text;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.ingredientTextfieldTag = textField.tag;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    RecipeIngredient* ingredient = self.recipeIngredients[textField.tag];
    ingredient.name = textField.text;
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
