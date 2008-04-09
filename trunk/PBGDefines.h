/*
 *  PBGDefines.h
 *  Neurosis
 *
 *  Created by Patrick B. Gibson on 07/04/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

// Notifications
#define kPictureTakenNotification	@"PBGPictureTakenNotification"
#define kMeaningIdentifier			@"PBGMeaningIdentifier"
#define kFilePathIdentifier			@"PBGFilePathIdentifier"

// PBGTreeNode Types
typedef enum _PBGTreeNodeType {
	SpecialFolderTreeNode = 0,
	CameraItemTreeNode = 1,
	LessonFolderTreeNode = 2,
	LessonTreeNode = 3
} PBGTreeNodeType;


