CONSTANTS = {
    JUMP_HEIGHT_ORIGIN = 0.4,
    BALL_SPEED_ORIGIN = 0.4,
    ATTACH_WIDTH_ORIGIN = 1,
    JUMP_TIME_ORIGIN = 1,
    JUMP_HEIGHT  = 2, --人物高度
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
    local char = CircusChar:create()
    local ball1 = CircusBall:create()
    local ball2 = CircusBall:create()
    local bgGrass = cc.Sprite:createWithSpriteFrameName("circus/grass.png")
    bgGrass:setScale(1.3)
    bgGrass:setAnchorPoint(cc.p(0.0, 0.0))
    self:addChild(bgGrass)
    self:addChild(char,1)
    self:addChild(ball1)
    self:addChild(ball2)
    char:attach(ball1)
    ball2:enterStage()
    self.char = char
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
    configui:setNormalizedPosition(cc.p(0.0, 0.4))
    self:addChild(configui,2)
    self.speedLable = configui:getChildByName("BallSpeedLable")
    self.jumpHeightLable = configui:getChildByName("JumpHeightLable")
    self.attachWidthLable = configui:getChildByName("AttachWidthLable")
    self.jumpTimeLable = configui:getChildByName("JumpTimeLable")
    self.speedSlider = configui:getChildByName("BallSpeedSlider")
    self.jumpHeightSlider = configui:getChildByName("JumpHeightSlider")
    self.attachWidthSlider = configui:getChildByName("AttachWidthSlider")
    self.jumpTimeSlider = configui:getChildByName("JumpTimeSlider")
    self.attachWidthSlider:setPercent(100)
    self.jumpTimeSlider:setPercent(100)
    CONSTANTS.BALL_SPEED = CONSTANTS.BALL_SPEED_ORIGIN * self.speedSlider:getPercent() / 5
    CONSTANTS.JUMP_HEIGHT = CONSTANTS.JUMP_HEIGHT_ORIGIN * self.jumpHeightSlider:getPercent() / 5
    CONSTANTS.ATTACH_WIDTH = CONSTANTS.ATTACH_WIDTH_ORIGIN * self.attachWidthSlider:getPercent() / 100
    CONSTANTS.JUMP_TIME = CONSTANTS.JUMP_TIME_ORIGIN * self.jumpTimeSlider:getPercent() / 100
    self.speedLable:setString("speed " .. CONSTANTS.BALL_SPEED)
    self.jumpHeightLable:setString("jump height " .. CONSTANTS.JUMP_HEIGHT)
    self.attachWidthLable:setString("attach " .. CONSTANTS.ATTACH_WIDTH)
    self.jumpTimeLable:setString("jump time " .. CONSTANTS.JUMP_TIME)
    local speedCallBack = function(ref, event_type)
        if (event_type == ccui.SliderEventType.percentChanged) then
            CONSTANTS.BALL_SPEED = CONSTANTS.BALL_SPEED_ORIGIN * self.speedSlider:getPercent() / 5 
            self.speedLable:setString("speed " .. CONSTANTS.BALL_SPEED)
        end
    end
    local jumpCallBack = function(ref, event_type)
        if (event_type == ccui.SliderEventType.percentChanged) then
            CONSTANTS.JUMP_HEIGHT = CONSTANTS.JUMP_HEIGHT_ORIGIN * self.jumpHeightSlider:getPercent() / 5
            self.jumpHeightLable:setString("jump height" .. CONSTANTS.JUMP_HEIGHT)
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
    self.jumpHeightSlider:addEventListener(jumpCallBack)
    self.attachWidthSlider:addEventListener(attachCallback)
    self.jumpTimeSlider:addEventListener(jumpTimeCallBack)
end


return CircusScene
