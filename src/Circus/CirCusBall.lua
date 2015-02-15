local Manager = require("Circus.CirCusBallManager")
local CirCusBall = class("CirCusBall",function()
    return cc.Sprite:create()
end)

function CirCusBall.create()
    return CirCusBall.new()
end

function CirCusBall:ctor()
    self:setSpriteFrame("circus/ballmotion1.png")
    Manager:addBall(self)
end

function CirCusBall:beAttach(character)
    self:stopAllActions()
    self:setOpacity(255)
    local stablePos = cc.p(character:getPositionX(), self:getPositionY())
    local moveAction = cc.MoveTo:create(0.2, stablePos)
    local rotateAction = cc.RotateBy:create(0.2, 30)
    local stableAction = cc.RepeatForever:create(cc.RotateBy:create(1,90))
    self:runAction(cc.Sequence:create(cc.Spawn:create(moveAction, rotateAction)))
    self:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,90)))
end

function CirCusBall:beDetach()
    local moveOut = cc.MoveTo:create(1, cc.p(-50, self:getPositionY()))
    local fadeout = cc.FadeOut:create(1)
    local step1 = cc.Spawn:create(moveOut, fadeout)
    local step2 = cc.CallFunc:create(function() self:enterStage() end)
    self:runAction(cc.Sequence:create(step1, step2))    
end

function CirCusBall:enterStage()
    self:stopAllActions()
    self:setOpacity(255)
    local startpos = cc.p(1000, self:getPositionY())
    local endpos = cc.p(-self:getBoundingBox().width, self:getPositionY())
    local distance = cc.pGetDistance(startpos,endpos)
    local speed_factor = math.random(3.5,6.1)
    local time = distance / (self:getBoundingBox().width * speed_factor)
    local step1 = cc.CallFunc:create(function() self:setPosition(startpos) end)
    local moveIn  = cc.MoveTo:create(time, cc.p(endpos)) --move out to the scene
    local step2 =  moveIn
    self:runAction(cc.Sequence:create(step1, step2))
    self:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,-170)))
end

return CirCusBall