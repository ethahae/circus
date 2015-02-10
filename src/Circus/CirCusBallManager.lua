local CirCusBallManager = class("CirCusBallManager", {})

function CirCusBallManager:ctor()
    self.balls = {}
end
function CirCusBallManager:addBall(ball)
    if (self.balls == nil) then
        self.balls = {}
        local visible = cc.Director:getInstance():getVisibleSize()
        local origin = cc.Director:getInstance():getVisibleOrigin()
        self.ball_pos = cc.p(origin.x + visible.width/3, origin.y + ball:getBoundingBox().height / 2)
    end
    ball:setPosition(self.ball_pos)
    print("set ball default pos " , self.ball_pos.x, " , ", self.ball_pos.y)
    table.insert(self.balls, ball)
end

function CirCusBallManager:searchBall(pos)
    for _,ball in pairs(self.balls) do
        local box = ball:getBoundingBox()
        box.x = pos.x - box.width * CONSTANTS.ATTACH_WIDTH
        box.width =  box.width * CONSTANTS.ATTACH_WIDTH * 2
        if (cc.rectContainsPoint(box, cc.p(ball:getPosition()))) then
            return ball
        end
    end
    return nil
end

function CirCusBallManager:pauseAllBall()
    for _, ball in pairs(self.balls) do
        ball:stopAllActions()
    end
end

function CirCusBallManager:reset()
    for _, ball in pairs(self.balls) do
        ball:stopAllActions()
        ball:setPosition(self.ball_pos)
    end
end

return CirCusBallManager