//
//  MGMyScene.m
//  MainGame
//
//  Created by jins on 14-6-24.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

#import "MGMyScene.h"

@implementation MGMyScene
{
    SKSpriteNode *_player;
    NSArray *_playerWalkingFrames;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        NSMutableArray *walkFrames = [NSMutableArray array];
        SKTextureAtlas *playerAnimatedAtlas = [SKTextureAtlas atlasNamed:@"texture"];
        for (NSString *name in playerAnimatedAtlas.textureNames) {
            SKTexture *temp = [playerAnimatedAtlas textureNamed:name];
            [walkFrames addObject:temp];
        }
        _playerWalkingFrames = walkFrames;
        
        _player = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"stand"]];
        _player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.size];
        _player.physicsBody.affectedByGravity = NO;
        [self addChild:_player];
        
        SKTexture *bee1 = [SKTexture textureWithImageNamed:@"bee1"];
        SKTexture *bee2 = [SKTexture textureWithImageNamed:@"bee2"];
        SKSpriteNode *bee = [SKSpriteNode spriteNodeWithTexture:bee1];
        [bee runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:@[bee1, bee2] timePerFrame:0.2]]];
        bee.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bee.size];
        bee.physicsBody.affectedByGravity = NO;
        bee.position = CGPointMake(300, 100);
        [bee runAction:[SKAction moveToX:0 duration:5]];
        [self addChild:bee];
        
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    float playerVelocity = self.size.width/3.0f;
    
    CGPoint moveDifference = CGPointMake(location.x - _player.position.x, location.y - _player.position.y);
    float distance = sqrtf(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y);
    float moveDuration  = distance / playerVelocity;
//    CGFloat multiplierForDirection;
//    if (moveDifference.x < 0) {
//        multiplierForDirection = -1;
//    } else {
//        multiplierForDirection = 1;
//    }
//    _player.xScale = fabs(_player.xScale) * multiplierForDirection;
    
    _player.zRotation = atan2f(moveDifference.y, moveDifference.x);
    
    if ([_player actionForKey:@"playerMoving"]) {
        [_player removeActionForKey:@"playerMoving"];
    }
    
    if (![_player actionForKey:@"walkingInPlacePlayer"]) {
        [_player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_playerWalkingFrames timePerFrame:0.2f resize:NO restore:YES]] withKey:@"walkingInPlacePlayer"];
    }
    
    SKAction *moveAction = [SKAction moveTo:location duration:moveDuration];
    SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^() {
        NSLog(@"Animation Completed");
        [_player removeAllActions];
    }];
    
    SKAction *moveActionWithDone = [SKAction sequence:@[moveAction,doneAction]];
    
    [_player runAction:moveActionWithDone withKey:@"playerMoving"];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
