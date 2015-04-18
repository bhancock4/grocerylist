//
//  RecipeInstructionsViewController.m
//  ReciPlan
//
//  Created by Benjamin Hancock on 4/17/15.
//  Copyright (c) 2015 Ben Hancock. All rights reserved.
//

#import "RecipeInstructionsViewController.h"

@interface RecipeInstructionsViewController ()

@end

@implementation RecipeInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.recipeName;
    //self.recipeInstructionsTextView.text = self.recipeInstructions;
    
    NSString* text = @"";
    
    if([self.recipeIngredients count] > 0)
        text = @"Ingredients:\n";
    
    for(RecipeIngredient* ingredient in self.recipeIngredients)
    {
        NSString* quantity = ingredient.quantity == nil ? @"" : ingredient.quantity;
        NSString* unit = ingredient.unit == nil ? @"" : ingredient.unit;
        
        text = [text stringByAppendingString:@"- "];
        
        text = [text stringByAppendingString:quantity];
        if([quantity length] > 0)
            text = [text stringByAppendingString:@" "];
        
        text = [text stringByAppendingString:unit];
        if([unit length] > 0)
            text = [text stringByAppendingString:@" "];
        
        text = [text stringByAppendingString:ingredient.name];
        text = [text stringByAppendingString:@"\n"];
    }
    
    if([self.recipeInstructions length] > 0)
    {
        text = [text stringByAppendingString:@"\n\nInstructions:\n"];
        text = [text stringByAppendingString:self.recipeInstructions];
    }
    self.recipeInstructionsTextView.text = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
