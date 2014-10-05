//
//  Recipe.h
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RecipeIngredientz.h"

@interface Recipez : NSObject

@property NSString* name;
@property NSMutableArray* recipeIngredients;
@property NSString* directions;
@property UIImage* picture;

@end
