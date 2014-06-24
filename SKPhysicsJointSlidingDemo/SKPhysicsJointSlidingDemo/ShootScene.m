//
//  ShootScene.m
//  SKPhysicsJointSlidingDemo
//
//  Created by jins on 14-6-23.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

#import "ShootScene.h"

@interface ShootScene()<SKPhysicsContactDelegate>
@property int direction;
@property int playerMove;
@end

@implementation ShootScene

- (void)didMoveToView:(SKView *)view
{
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.view.frame];
    self.physicsBody.dynamic = NO;
    
    self.physicsWorld.contactDelegate = self;
    
    self.direction = 1;
    
    [self createPlayer];
    [self createBlocks];
    [self createButton];
}

- (void)createBlocks
{
    for (int i=0; i<7; i++) {
        SKSpriteNode *block = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(20, 20)];
        block.position = CGPointMake(i * 30 + 40, CGRectGetMaxY(self.frame) - 80);
        block.name = @"block";
        [self addChild:block];
        
        block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size];
        block.physicsBody.categoryBitMask = 0x1;
        block.physicsBody.contactTestBitMask = 0x1;
        
        SKPhysicsJointSliding *s = [SKPhysicsJointSliding jointWithBodyA:block.physicsBody bodyB:self.physicsBody anchor:block.position axis:CGVectorMake(1, 0)];
        [self.physicsWorld addJoint:s];
    }
}

- (void)createPlayer
{
    SKNode *player = [SKNode node];
    player.position = CGPointMake(160, 140);
    player.name = @"player";
    [self addChild:player];
    
    SKSpriteNode *partA = [SKSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:CGSizeMake(50, 20)];
    partA.position = CGPointMake(0, -10);
    [player addChild:partA];
    
    SKSpriteNode *partB = [SKSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:CGSizeMake(20, 30)];
    [player addChild:partB];
    
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 30)];
    
    SKPhysicsJointSliding *s = [SKPhysicsJointSliding jointWithBodyA:player.physicsBody bodyB:self.physicsBody anchor:player.position axis:CGVectorMake(1, 0)];
    [self.physicsWorld addJoint:s];
}

- (void)createButton
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:20 startAngle:0 endAngle:2.0*M_PI clockwise:NO];
    for (int i=0; i<3; i++) {
        SKShapeNode *btn = [SKShapeNode node];
        btn.name = [NSString stringWithFormat:@"button%d", i];
        btn.position = CGPointMake(i * 90 + 70, 40);
        btn.path = path.CGPath;
        btn.fillColor = [SKColor whiteColor];
        [self addChild:btn];
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    [self enumerateChildNodesWithName:@"block" usingBlock:^(SKNode *node, BOOL *stop) {
        node.physicsBody.velocity = CGVectorMake(self.direction * 10, 0);
        if (node.position.x > 300) {
            self.direction = -1;
        } else if (node.position.x < 20) {
            self.direction = 1;
        }
    }];
    
    SKNode *player = [self childNodeWithName:@"player"];
    player.physicsBody.velocity = CGVectorMake(self.playerMove * 40, 0);
}

- (void)shoot
{
    SKNode *player = [self childNodeWithName:@"player"];
    
    SKSpriteNode *beam = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(2, 7)];
    beam.position = CGPointMake(player.position.x, player.position.y + 30);
    [self addChild:beam];
    
    beam.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:beam.size];
    beam.physicsBody.velocity = CGVectorMake(0, 100);
    beam.physicsBody.linearDamping = 0;
    beam.physicsBody.allowsRotation = NO;
    beam.physicsBody.collisionBitMask = 0x1;
    
    SKAction *act = [SKAction customActionWithDuration:0 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        [beam removeFromParent];
    }];
    [beam runAction:[SKAction sequence:@[[SKAction waitForDuration:3.0], act]]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInNode:self];
    SKNode *btnL = [self childNodeWithName:@"button0"];
    SKNode *btnC = [self childNodeWithName:@"button1"];
    SKNode *btnR = [self childNodeWithName:@"button2"];
    
    if ([btnC containsPoint:p]) {
        [self shoot];
    } else if ([btnL containsPoint:p]) {
        self.playerMove = -1;
    } else if ([btnR containsPoint:p]) {
        self.playerMove = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.playerMove = 0;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    
    SKAction *fade = [SKAction fadeOutWithDuration:0.4];
    
    [nodeA runAction:fade completion:^{
        [nodeA removeFromParent];
    }];
    
    [nodeB runAction:fade completion:^{
        [nodeB removeFromParent];
    }];
}

@end