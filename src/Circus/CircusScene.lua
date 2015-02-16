CONSTANTS = {
    ATTACH_WIDTH_ORIGIN = 1,
    JUMP_TIME_ORIGIN = 1,
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
    self.ball1 = ball1
    self.ball2 = ball2
    self.char = char
    char.scene = self
    cc.SimpleAudioEngine:getInstance():playMusic("background2.mp3",true)
    self:getScheduler():scheduleScriptFunc(function() self:Crash() end, 1/60.0, false)
end

function CircusScene:Crash()
    if cc.rectIntersectsRect(self.ball1:getBoundingBox(),self.ball2:getBoundingBox()) 
        and self.char.dead == false then
        self.char:Die()
    end
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
    
    
    
    self.moveby = cc.MoveBy:create(50, cc.p(-self.audienceSize.width ,0))
    self.moveby:retain()
    
    self.bgAudience1:runAction(cc.Sequence:create(self.moveby:clone(), 
        cc.CallFunc:create(function() self:swapbg();end)))
    self.bgAudience2:runAction(self.moveby:clone())
end

function CircusScene:pausebg()
    self.bgAudience1:pause()
    self.bgAudience2:pause()
end
function CircusScene:resumebg()
    self.bgAudience1:resume()
    self.bgAudience2:resume()
end

function CircusScene:swapbg()
    self.bgAudience1:setPosition(cc.p(self.audienceSize.width, 768/2))
    local t = self.bgAudience1;
    self.bgAudience1 = self.bgAudience2
    self.bgAudience2 = t

    self.bgAudience1:runAction(cc.Sequence:create(self.moveby:clone(), cc.CallFunc:create(function() self:swapbg();end)))
    self.bgAudience2:runAction(self.moveby:clone())
end

function CircusScene:reset()
    CircusBallManager:reset()
    self.char:reset()
    self.char:attach(CircusBallManager.balls[1])
    self.scoreLable:setString("Score: 0")
    self.againButton:setVisible(false)
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
    self.againButton = configui:getChildByName("AgainButton")
    self.scoreLable = configui:getChildByName("ScoreLable")
    --local highScore = cc.UserDefault:getInstance():getIntegerForKey("HIGH_SCORE", 0)
    self.scoreLable:setString("Score: " .. 0)
    self.againButton:setVisible(false)
    self.speedLable:setVisible(false)
    self.attachWidthLable:setVisible(false)
    self.jumpTimeLable:setVisible(false)
    self.attachWidthSlider:setVisible(false)
    self.jumpTimeSlider:setVisible(false)
    self.speedSlider:setVisible(false)
    self.attachWidthSlider:setPercent(50)
    self.jumpTimeSlider:setPercent(100)

    
--    local menuIm = cc.MenuItemLabel:create()
--    menuIm.setString("5555")
--    
--    
--    local menu = cc.Menu:create();
--    menu:addChild(menuIm);
--    local size = cc.Director:getInstance():getWinSize();
--    menu:setPosition(size.width/2,size.height/2);
--    self:addChild(menu,2);
    
    CONSTANTS.BALL_SPEED = CONSTANTS.BALL_SPEED_ORIGIN * self.speedSlider:getPercent() / 5

    CONSTANTS.ATTACH_WIDTH = CONSTANTS.ATTACH_WIDTH_ORIGIN * self.attachWidthSlider:getPercent() / 100
    CONSTANTS.JUMP_TIME = CONSTANTS.JUMP_TIME_ORIGIN * self.jumpTimeSlider:getPercent() / 100
    self.attachWidthLable:setString("attach " .. CONSTANTS.ATTACH_WIDTH)
    self.jumpTimeLable:setString("jump time " .. CONSTANTS.JUMP_TIME)
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
    self.attachWidthSlider:addEventListener(attachCallback)
    self.jumpTimeSlider:addEventListener(jumpTimeCallBack)
    local resetfunc = function(ref, event_type)
        self:reset()
    end
    self.againButton:addClickEventListener(resetfunc)
end


return CircusScene
