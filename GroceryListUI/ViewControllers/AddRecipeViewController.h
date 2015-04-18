//
//  AddRecipeViewController.h
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import <QuartzCore/QuartzCore.h>
#import "IngredientTableViewCell.h"
#import "ShoppingList.h"
#import "ShoppingListIngredient.h"
#import "Utilities.h"
#import "RecipeInstructionsViewController.h"

@interface AddRecipeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property Recipe* recipe;
@property NSMutableArray* recipeIngredients;
@property NSMutableArray* tempDeletedRecipeIngredients;
@property (nonatomic) NSString* sourceSegue;
@property BOOL isExistingRecipe;
@property BOOL keyboardIsShown;
@property int16_t selectedIngredientRow;
@property UIColor* preAlertCellColor;
- (IBAction)AddToList:(id)sender;
@property BOOL imageIsSet;

@property (weak, nonatomic) IBOutlet UIButton*          addToList;
@property (weak, nonatomic) IBOutlet UITextField*       recipeName;
@property (weak, nonatomic) IBOutlet UIImageView*       RecipeImage;
@property (weak, nonatomic) IBOutlet UITextView*        recipeDirections;
@property (weak, nonatomic) IBOutlet UITableView*       tableRecipeIngredients;
@property (weak, nonatomic) IBOutlet UIBarButtonItem*   saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem*   cancelButton;
@property (weak, nonatomic) IBOutlet UIButton*          btnAddIngredient;
@property (weak, nonatomic) IBOutlet UIButton*          recipeImageButton;
@property (weak, nonatomic) IBOutlet UIButton *btnFullScreenInstructions;

- (NSIndexPath*)getCellIndexFromGesture:(UIGestureRecognizer *) g;

@end
