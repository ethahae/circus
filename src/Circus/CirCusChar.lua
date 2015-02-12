local CiruCurBallManager = require("Circus.CirCusBallManager")
local CirCusChar = class("CirCusChar",function()
    return cc.Sprite:create()
end)

function CirCusChar.create()
    return CirCusChar.new()
end

function CirCusChar:ctor()
    self:setSpriteFrame("circus/level2motion1.png")
    local origin = cc.Director:getInstance():getVisibleOrigin()
    local visible = cc.Director:getInstance():getVisibleSize()
    self.origin = origin
    self.visible = visible
    local animation = cc.Animation:create()
    for i = 2,3 do
        animation:addSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("circus/level2motion" .. i .. ".png"))
    end
    animation:setDelayPerUnit(0.5/3.0)
    animation:setRestoreOriginalFrame(true)
    local animate = cc.Animate:create(animation)
    self.animate = cc.RepeatForever:create(animate)
    self.animate:retain()
    self.dieAnimate = animate:reverse()
    self.dieAnimate:retain()
    self:registEvent()
    self:reset()
end

function CirCusChar:reset()
    self:stopAllActions()
    self.jumping = false
    self.dead = false
    self.ball = nil
    self:setPosition(cc.p(self.origin.x + self.visible.width /3, self.origin.y + self:getBoundingBox().height / 2))
    self:runAction(self.animate:clone())
end

function CirCusChar:registEvent()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function()
        if (self.dead == true) then 
            self:getParent():reset()
            return
        end --restart cheating,should be remove later
        if (self.jumping == true or self.dead == true) then return true end
        self.jumping = true
        --local moveback = cc.MoveTo:create(CONSTANTS.JUMP_TIME,cc.p(self:getPosition()))
        --local moveup = cc.MoveTo:create(CONSTANTS.JUMP_TIME, cc.p(self:getPositionX(), self:getPositionY() + self:getBoundingBox().height * CONSTANTS.JUMP_HEIGHT))
        local jumpby = cc.JumpBy:create(CONSTANTS.JUMP_TIME, cc.p(0,0), self:getBoundingBox().height * 2.5, 1)
        local checkAttach = cc.CallFunc:create(function() self:checkAttach() end)
        self:runAction(cc.Sequence:create(jumpby, checkAttach))
        if (self.ball ~= nil) then
            self.ball:beDetach()
            self.ball = nil
        end
        return true
    end,
    cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function CirCusChar:checkAttach()
    local targetBall = CiruCurBallManager:searchBall(cc.p(self:getPosition()))
    if (targetBall ~= nil) then
        self:attach(targetBall)
    else
        self:Die()
    end
end

function CirCusChar:attach(ball)
    if (ball == nil) then error("invalid ball attach") end
    if (self.ball ~= nil) then self.ball:beDetach() end
    self.jumping = false
    ball:beAttach(self)
    self.ball = ball
    local selfBox = self:getBoundingBox()
    local newPos = cc.p(self:getPositionX(), self.origin.y + 44 + selfBox.height / 2.0)
    self:setPosition(newPos)
end

function CirCusChar:Die()
    self:stopAllActions()
    local moveToGround = cc.MoveBy:create(.5,cc.p(0, -self:getBoundingBox().height/2))
    local stopBall = function() CiruCurBallManager:pauseAllBall() end
    local setDead = function() self.dead = true end
    self:runAction(cc.Sequence:create(cc.CallFunc:create(stopBall), self.dieAnimate, moveToGround, cc.CallFunc:create(setDead)))
end

return CirCusChar