//
//  WWScene.m
//  SKPhysicsJointSlidingDemo
//
//  Created by jins on 14-6-23.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

#import "WWScene.h"

@implementation WWScene
{
    CGPoint _touchStartPosition;
    CGPoint _blockStartPosition;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self addEdge];
        [self addBlock];
        [self addJoint];
        
        self.physicsWorld.gravity = CGVectorMake(0, -10);
    }
    return self;
}

- (void)addBlock
{
    CGSize winSize = self.scene.size;
    
    SKSpriteNode *sprite = [self createBlockWithPosition:CGPointMake(winSize.width / 2, 0)];
    [sprite setPosition:CGPointMake(sprite.position.x, sprite.frame.size.height)];
    [sprite setName:@"myBlock"];
    
    SKSpriteNode *sprite2 = [self createBlockWithPosition:CGPointMake(winSize.width / 2, winSize.height)];
    [sprite2 setPosition:CGPointMake(sprite2.position.x, sprite2.position.y - sprite2.frame.size.height)];
    [sprite2 setName:@"enemyBlock"];
    [sprite2 runAction:
     [SKAction sequence:
      @[
        [SKAction moveToX:sprite2.size.width / 2 duration:0.5f],
        [SKAction repeatActionForever:
         [SKAction sequence:
          @[
            [SKAction moveToX:winSize.width duration:1],
            [SKAction moveToX:sprite2.size.width / 2 duration:1]
            ]
          ]
         ]
        ]
      ]
     ];
    
    [self addChild:sprite];
    [self addChild:sprite2];
}

- (SKSpriteNode *)createBlockWithPosition:(CGPoint)position
{
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(50, 25)];
    sprite.position = position;
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:sprite.frame.size];
    [sprite setPhysicsBody:body];
    sprite.physicsBody.affectedByGravity = NO;
    
    return sprite;
}

- (void)addEdge
{
    CGSize winSize = self.scene.size;
    
    SKSpriteNode *edgeLeft = [self createEdgeWithSize:CGSizeMake(1, winSize.height)];
    [edgeLeft setName:@"edgeLeft"];
    [edgeLeft setPosition:CGPointMake(0, winSize.height / 2)];
    
    SKSpriteNode *edgeRight = [self createEdgeWithSize:CGSizeMake(1, winSize.height)];
    [edgeRight setName:@"edgeRight"];
    [edgeRight setPosition:CGPointMake(winSize.width, winSize.height / 2)];
    
    //    SKSpriteNode *edgeBottom = [self createEdgeWithSize:CGSizeMake(winSize.width, 1)];
    //    [edgeBottom setPosition:CGPointMake(winSize.width / 2, 0)];
    
    [self addChild:edgeLeft];
    [self addChild:edgeRight];
    //    [self addChild:edgeBottom];
}

- (SKSpriteNode *)createEdgeWithSize:(CGSize)size
{
    SKSpriteNode *edge = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:size];
    edge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:edge.frame.size];
    edge.physicsBody.dynamic = NO;
    return edge;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        _touchStartPosition = location;
        
        SKSpriteNode *sprite = (SKSpriteNode *)[self childNodeWithName:@"myBlock"];
        _blockStartPosition = sprite.position;
        
        NSLog(@"%.2f, %.2f", location.x, location.y);
        //        [self addBlock];
    }
}

- (void)addJoint
{
    SKSpriteNode *edgeLeft = (SKSpriteNode *)[self childNodeWithName:@"edgeLeft"];
    SKSpriteNode *block = (SKSpriteNode *)[self childNodeWithName:@"myBlock"];
    
    SKPhysicsJointSliding *joint = [SKPhysicsJointSliding jointWithBodyA:edgeLeft.physicsBody bodyB:block.physicsBody anchor:block.position axis:CGVectorMake(1, 0)];
    
    SKSpriteNode *block2 = (SKSpriteNode *)[self childNodeWithName:@"enemyBlock"];
    
    SKPhysicsJointSliding *joint2 = [SKPhysicsJointSliding jointWithBodyA:edgeLeft.physicsBody bodyB:block2.physicsBody anchor:block2.position axis:CGVectorMake(1, 0)];
    
    [self.physicsWorld addJoint:joint];
    [self.physicsWorld addJoint:joint2];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = (SKSpriteNode *)[self childNodeWithName:@"myBlock"];
        
        CGPoint delta = CGPointMake(location.x - _touchStartPosition.x, location.y - _touchStartPosition.y);
        CGPoint position = CGPointMake(_blockStartPosition.x + delta.x, _blockStartPosition.y + delta.y);
        
        [sprite setPosition:position];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)sendData:(NSString *)json
{
    
}

- (void)receiveData:(NSString *)json
{
    
}

@end
