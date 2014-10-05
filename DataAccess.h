//
//  XYZDataAccess.h
//  ToDoList
//
//  Created by Benjamin Hancock on 2/16/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XYZToDoItem;

@interface DataAccess : NSObject

+ (NSArray *) getEntitiesByName: (NSString *) entityName;
+ (NSArray*) getEntitiesByName: (NSString *) entityName WithPredicate: (NSPredicate*) predicate AndSortByProperty: (NSString *) sortProperty;
//+ (BOOL)insertToDoListItem: (XYZToDoItem*) item;
//+ (XYZToDoItem*) getToDoListItemByItemName: (NSString*) itemName;
//+ (NSMutableArray*) getToDoListItems: (NSPredicate*) predicate;
//+ (NSMutableArray*) getToDoListItemByCompleted: (BOOL) completed;
//+ (void) updateToDoListItem: (XYZToDoItem*) updatedItem;
//+ (void) deleteToDoListItem: (XYZToDoItem*) deletedItem;

@end
