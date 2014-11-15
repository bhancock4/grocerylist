//
//  XYZDataAccess.h
//  ToDoList
//
//  Created by Benjamin Hancock on 2/16/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "BaseEntity.h"

@interface DataAccess : NSObject

@property (nonatomic, retain) NSManagedObjectContext* context;

+ (id)sharedDataAccess;
- (NSArray *) getEntitiesByName: (NSString *) entityName;
- (NSArray *) getEntitiesByName: (NSString *) entityName WithPredicate: (NSPredicate *) predicate;
- (NSArray*) getEntitiesByValue: (NSString *) entityName WithPredicate: (NSPredicate*) predicate AndSortByProperty: (NSString *) sortProperty;
@end
