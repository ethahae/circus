
-- CC_USE_DEPRECATED_API = true
require "cocos.init"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
 
    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
    -- initialize director
    local director = cc.Director:getInstance()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("assets.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("circus.plist") 
    --turn on display FPS
    director:setDisplayStats(true)
    
    --set FPS. the default value is 1.0/60 if you don't call this
    print(cc.FileUtils:getInstance():getWritablePath())
    director:setAnimationInterval( 1.0 / 60)
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1024, 768, 1)
    cc.Device:setKeepScreenOn(true)
    
 --create scene 
    local scene = require("Circus.CircusScene")
    local gameScene = scene.create()
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end

end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end

--Load all files
--local PlayLayer = require "GameObject.PlayLayer"
--local Planet  = require "GameObject.Docks.Planet"
--local Fleet = require "GameObject.Fleets.Fleets"
--local MySelf = require "GameObject.Player.MySelf"
--local PlayerManager = require("GameObject.Manager.PlayerManager")
--myself= nil
--playlayer = nil



--Create View
--local mainScene = cc.Scene:create()
--    playlayer = PlayLayer:create()
--    mainScene:addChild(playlayer)
--    
--
--    local p1 = Planet.new()
--    p1:setNormalizedPosition({x = .3, y = .3})
--    p1:setColor(cc.c3b(255,0,0))
--    local p2 = Planet.new()
--    p2:setNormalizedPosition({x = .7, y = .7})
--    local p3  = Planet.new()
--    p3:setNormalizedPosition(cc.p(.7, .3))
--
--
--    myself = MySelf.new(cc.c3b(0,0,255))
--    local f = Fleet.new(myself, 20)
--    p1:bindToPlayer(myself)
--    p1:addFleets(f)
--    p2:addFleets(Fleet.new(myself, 10))
--    p3:addFleets(Fleet.new(myself, 40))
--    mainScene:getScheduler():scheduleScriptFunc(function(delta) PlayerManager:update(delta) end, 1, false)

