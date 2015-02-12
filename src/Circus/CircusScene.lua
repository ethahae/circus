CONSTANTS = {
    BALL_SPEED_ORIGIN = 0.4,
    ATTACH_WIDTH_ORIGIN = 1,
    JUMP_TIME_ORIGIN = 1,
    BALL_SPEED   = 2, --球的直径
    ATTACH_WIDTH = 1, --以人的中心为准, 向两边扩展, 基数是球的直径
    JUMP_TIME    = 1  --人物跳跃时间,second
}
local CircusBall = require("Circus.CirCusBall")
local CircusBallManager = require("Circus.CirCusBallManager")
local CircusChar = require("Circus.CirCusChar")
local CircusScene = class("CircusScene",function()
    return cc.Scene:create()
end)

function CircusScene.create()
    return CircusScene.new()
end


function CircusScene:ctor()
    self:setConfigUi()
    self:init_bg()
    local char = CircusChar:create()
    local ball1 = CircusBall:create()
    local ball2 = CircusBall:create()
    self:addChild(char,1)
    self:addChild(ball1)
    self:addChild(ball2)
    char:attach(ball1)
    ball2:enterStage()
    self.char = char
end

function CircusScene:init_bg()
    local bgGrass = cc.Sprite:createWithSpriteFrameName("circus/grass.png")
    bgGrass:setScale(1.3)
    bgGrass:setAnchorPoint(cc.p(0.0, 0.0))
    self:addChild(bgGrass)
    
    local bgAudience1 = cc.Sprite:create("audience.png")
    local bgAudience2 = cc.Sprite:create("audience2.png")
    self.audienceSize = bgAudience1:getContentSize()
    
    self.bgAudience1 = bgAudience1
    self.bgAudience2 = bgAudience2
    bgAudience1:setAnchorPoint(cc.p(0.0, 0.0))
    bgAudience2:setAnchorPoint(cc.p(0.0, 0.0))
    bgAudience1:setPosition(cc.p(0, 768 / 2))
    bgAudience2:setPosition(cc.p(self.audienceSize.width, 768/2))
    self:addChild(bgAudience1)
    self:addChild(bgAudience2)
    
    
    self.moveby = cc.MoveBy:create(10, cc.p(-self.audienceSize.width ,0))
    self.moveby:retain()
    
    self.bgAudience1:runAction(cc.Sequence:create(self.moveby:clone(), 
        cc.CallFunc:create(function() self:swapbg();end)))
    self.bgAudience2:runAction(self.moveby:clone())
end

function CircusScene:swapbg()
    self.bgAudience1:setPosition(cc.p(-self.audienceSize.width, 768/2))
    local t = self.bgAudience1;
    self.bgAudience1 = self.bgAudience2
    self.bgAudience2 = t

    self.bgAudience1:runAction(cc.Sequence:create(self.moveby:clone(), cc.CallFunc:create(function() self:swapbg();end)))
    self.bgAudience2:runAction(self.moveby:clone())
end

function CircusScene:reset()
    self.char:reset()
    CircusBallManager:reset()
    self.char:attach(CircusBallManager.balls[1])
    CircusBallManager.balls[2]:enterStage()
end

function CircusScene:setConfigUi()
    local configui = cc.CSLoader:createNode("ConfigUI.csb")
    self.configui = configui
    configui:setNormalizedPosition(cc.p(0.0, 0.55))
    self:addChild(configui,2)
    self.speedLable = configui:getChildByName("BallSpeedLable")
    self.attachWidthLable = configui:getChildByName("AttachWidthLable")
    self.jumpTimeLable = configui:getChildByName("JumpTimeLable")
    self.speedSlider = configui:getChildByName("BallSpeedSlider")
    self.attachWidthSlider = configui:getChildByName("AttachWidthSlider")
    self.jumpTimeSlider = configui:getChildByName("JumpTimeSlider")
    self.attachWidthSlider:setPercent(50)
    self.jumpTimeSlider:setPercent(100)
    CONSTANTS.BALL_SPEED = CONSTANTS.BALL_SPEED_ORIGIN * self.speedSlider:getPercent() / 5
    CONSTANTS.ATTACH_WIDTH = CONSTANTS.ATTACH_WIDTH_ORIGIN * self.attachWidthSlider:getPercent() / 100
    CONSTANTS.JUMP_TIME = CONSTANTS.JUMP_TIME_ORIGIN * self.jumpTimeSlider:getPercent() / 100
    self.speedLable:setString("speed " .. CONSTANTS.BALL_SPEED)
    self.attachWidthLable:setString("attach " .. CONSTANTS.ATTACH_WIDTH)
    self.jumpTimeLable:setString("jump time " .. CONSTANTS.JUMP_TIME)
    local speedCallBack = function(ref, event_type)
        if (event_type == ccui.SliderEventType.percentChanged) then
            CONSTANTS.BALL_SPEED = CONSTANTS.BALL_SPEED_ORIGIN * self.speedSlider:getPercent() / 5 
            self.speedLable:setString("speed " .. CONSTANTS.BALL_SPEED)
        end
    end
    local attachCallback = function(ref, event_type)
        if (event_type == ccui.SliderEventType.percentChanged) then
            CONSTANTS.ATTACH_WIDTH = CONSTANTS.ATTACH_WIDTH_ORIGIN * self.attachWidthSlider:getPercent() / 100
            self.attachWidthLable:setString("attach " .. CONSTANTS.ATTACH_WIDTH)
        end
    end
    local jumpTimeCallBack = function(ref, event_type)
        if (event_type == ccui.SliderEventType.percentChanged) then
            CONSTANTS.JUMP_TIME = CONSTANTS.JUMP_TIME_ORIGIN * self.jumpTimeSlider:getPercent() / 100
            self.jumpTimeLable:setString("jump time " .. CONSTANTS.JUMP_TIME) 
        end
    end
    self.speedSlider:addEventListener(speedCallBack)
    self.attachWidthSlider:addEventListener(attachCallback)
    self.jumpTimeSlider:addEventListener(jumpTimeCallBack)
end


return CircusScene
