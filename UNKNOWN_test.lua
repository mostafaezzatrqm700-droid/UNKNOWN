-- DIAGNOSTIC COPY ONLY: do not publish or share.
local __t = os.clock()
local __lines = {}
local __panel
pcall(function()
    local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local g = Instance.new("ScreenGui"); g.Name="UnknownTimingDiagnostic"; g.ResetOnSpawn=false; g.DisplayOrder=100000; g.Parent=pg
    local label=Instance.new("TextLabel"); label.Size=UDim2.new(0.95,0,0,245); label.Position=UDim2.new(0.025,0,0,5); label.BackgroundColor3=Color3.fromRGB(20,15,28); label.TextColor3=Color3.new(1,1,1); label.TextSize=14; label.TextWrapped=true; label.Font=Enum.Font.Code; label.TextYAlignment=Enum.TextYAlignment.Top; label.Parent=g; __panel=label
end)
local function __mark(message)
    local line=string.format("%.2fs %s",os.clock()-__t,message)
    table.insert(__lines,line); while #__lines>12 do table.remove(__lines,1) end
    print("[UNKNOWN timing] "..line); if __panel then __panel.Text=table.concat(__lines,"\n") end
end
__mark("Source started (unprotected test)")
-- UNKNOWN | Protected launch through LuaProtect.
local function startUnknown()
-- Auto Execute: register the next-server launch once, and retry silently if registration fails.
local HttpService = game:GetService("HttpService")
local PROTECTED_LOADER_URL = "https://cdn.luaprotect.dev/u/f545ad/7RyTSD6vY5pp3E_V"
-- Auto Execute starts enabled on every fresh script launch.
-- The in-menu toggle can still disable it for the current session. 
local autoExecuteEnabled = true
local autoExecuteQueued = false
local function queueAutoExecute()
    if not autoExecuteEnabled or autoExecuteQueued then return autoExecuteQueued end
    local candidates = {}
    if type(queue_on_teleport) == "function" then table.insert(candidates, queue_on_teleport) end
    if type(queueonteleport) == "function" then table.insert(candidates, queueonteleport) end
    if type(syn) == "table" and type(syn.queue_on_teleport) == "function" then
        table.insert(candidates, syn.queue_on_teleport)
    end
    if type(fluxus) == "table" and type(fluxus.queue_on_teleport) == "function" then
        table.insert(candidates, fluxus.queue_on_teleport)
    end
    local payload = 'local h=game:GetService("HttpService");local ok,s=pcall(function()return h:JSONDecode(readfile("tenshi_beta_ui.json"))end);if not ok or type(s)~="table" or s.autoExecute~=false then local success,err=pcall(function()local f,e=loadstring(game:HttpGet("' .. PROTECTED_LOADER_URL .. '"));if not f then error(e) end;f() end);if not success then warn("UNKNOWN Auto Execute loader failed: "..tostring(err)) end end'
    for _, callback in ipairs(candidates) do
        for attempt = 1, 3 do
            local ok = pcall(callback, payload)
            if ok then
                autoExecuteQueued = true
                return true
            end
            if attempt < 3 then task.wait(0.15) end
        end
    end
    warn("UNKNOWN Auto Execute: could not register teleport queue; executor support may be missing")
    return false
end
queueAutoExecute()
__mark("Teleport queue registered")
-- UNKNOWN public v0.4.3 / UI18
-- Based on public commit 7fd7826415b94846abc924aa0ce9308b541c0653.
-- Public host/config; broadcast contract preserved from public v0.4.3.
-- Schema reference: monthonsova/Steal-An-Egg, EggESP/esp/EggData.lua.
-- Reports egg sightings and server IDs to the shared Finder host.
-- V4: field snapshot + separately replicated Halloween world eggs.
-- Records are never filtered by distance or by model availability.
local Players = game:GetService('Players')
local RS = game:GetService('ReplicatedStorage')
local player = Players.LocalPlayer
assert(player, 'Join the game first')
local parent = player:WaitForChild('PlayerGui', 15)
assert(parent, 'PlayerGui unavailable')
local old = parent:FindFirstChild('UNKNOWN') or parent:FindFirstChild('TENSHI_'..'FINDER_BETA')
if old then old:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name = 'UNKNOWN'
gui:SetAttribute('TenshiUIBuild','PUBLIC-V05-TOP10')
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
pcall(function() gui.ClipToDeviceSafeArea = false end)
gui.DisplayOrder = 1200
gui.Parent = parent
__mark("ScreenGui created (not necessarily visible)")
local alive = true
local sharedRuntime = _G
pcall(function()
    if type(getgenv) == "function" then sharedRuntime = getgenv() end
end)
sharedRuntime.__UNKNOWN_STOP_ACTIVE = function()
    alive = false
    if gui and gui.Parent then
        pcall(function() gui:Destroy() end)
    end
end
local highlight
gui.Destroying:Connect(function() alive = false; if highlight then highlight:Destroy() end end)
local function make(class, props, holder)
    local obj = Instance.new(class)
    for key, value in pairs(props) do obj[key] = value end
    obj.Parent = holder
    return obj
end
local function label(holder, text, pos, size, color, fontSize)
    return make('TextLabel', {Text=text,Position=pos,Size=size,BackgroundTransparency=1,TextColor3=color or Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=fontSize or 13,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},holder)
end
local function module(path)
    local obj = RS
    for part in path:gmatch('[^.]+') do
        obj = obj:FindFirstChild(part)
        assert(obj, 'Missing game module: '..path)
    end
    return require(obj)
end
local function numberField(record, keys)
    for _, key in ipairs(keys) do
        local value = record and record[key]
        if type(value)=='number' and value==value and math.abs(value)<math.huge then return value end
    end
end
local function modelFor(uid)
    if type(uid)~='string' then return end
    local folder = workspace:FindFirstChild('AreaEggSlotsClient')
    local obj = (folder and folder:FindFirstChild(uid)) or workspace:FindFirstChild(uid)
    if obj and obj:IsA('Model') then return obj end
end
local function displayedRate(model)
    if not model then return end
    for _,obj in ipairs(model:GetDescendants()) do
        if obj:IsA('TextLabel') or obj:IsA('TextButton') then
            local text=obj.Text:gsub('<[^>]+>',''):gsub(',','')
            local amount,suffix=text:match('%$?%s*(%d+%.?%d*)%s*(%a*)%s*/[sS]')
            local powers={['']=1,k=1e3,m=1e6,b=1e9,t=1e12,qa=1e15,q=1e15,qi=1e18}
            local factor=suffix and powers[suffix:lower()]
            if amount and factor then return tonumber(amount)*factor end
        end
    end
end
local function money(value)
    if not value then return 'Income unavailable' end
    for _,entry in ipairs({{1e18,'Qi'},{1e15,'Qa'},{1e12,'T'},{1e9,'B'},{1e6,'M'},{1e3,'K'}}) do
        if value>=entry[1] then return string.format('$%.2f%s/s',value/entry[1],entry[2]) end
    end
    return string.format('$%.2f/s',value)
end
local function valid(value)
    return type(value)=='number' and value==value and value>=0 and value<math.huge
end
local function computedRate(base, scale, muts, mutationModule)
    if not valid(base) or not valid(scale) or scale==0 then return nil end
    local multi=1
    if type(muts)~='table' then return nil end
    if next(muts) then
        local fn=mutationModule and mutationModule.EarningsFor
        if type(fn)~='function' then return nil end
        local ok,result=pcall(fn,muts)
        if not ok or not valid(result) then return nil end
        multi=result
    end
    -- Observed public implementation; displayed model income takes precedence.
    local factor=scale>5 and (scale/5)^1.2*19.637875755794113 or scale^1.85
    local result=base*factor*multi
    return valid(result) and result or nil
end
local function compare(a,b,sortMode)
    -- Unknown event species are visibly pinned for inspection, not called Divine.
    local av,bv
    if sortMode==1 then av,bv=a.rate,b.rate
    elseif sortMode==2 then av,bv=a.scale,b.scale
    else av,bv=a.tier,b.tier end
    -- Unavailable values are never replaced with invented zeroes.
    if av==nil and bv~=nil then return false end
    if bv==nil and av~=nil then return true end
    if av~=bv then return av>bv end
    if sortMode~=1 and a.rate~=b.rate then return (a.rate or -1)>(b.rate or -1) end
    if a.tier~=b.tier then return a.tier>b.tier end
    return tostring(a.key)<tostring(b.key)
end
local function canonical(value)
    return tostring(value or ''):lower():gsub('^halloween%s*',''):gsub('%s*egg$',''):gsub('[^%w]','')
end
local function isHalloweenEgg(entry)
    local source=tostring(entry and (entry.source or (entry.isEvent and 'event')) or ''):lower()
    local area=tostring(entry and (entry.area or entry.areaKey) or ''):lower()
    return source=='event' or area:find('halloween',1,true)~=nil or area:match('^hw[%s/]')~=nil
end
local function resolveSpec(specs, source, modelName)
    if source and specs[source] then return specs[source] end
    local result
    local wanted=canonical(source or modelName)
    if wanted=='' then return nil end
    for key,spec in pairs(specs) do
        if type(spec)=='table' then
            for _,alias in pairs({key,spec.Id,spec.DisplayName,spec.Source,spec.EggSource,spec.EggModel}) do
                if canonical(alias)==wanted then
                    if result and result~=spec then return nil end -- ambiguous aliases stay unresolved
                    result=spec
                end
            end
        end
    end
    return result
end
local function eventTraits(model,record)
    local names,seen,sources={},{},{}
    local known=false
    local function insert(v)
        if type(v)=='string' and v~='' and v~='None' and v~='Normal' and not seen[v] then
            seen[v]=true; names[#names+1]=v
        end
    end
    local function parse(value)
        if type(value)=='table' then
            for key,v in pairs(value) do
                if v==true and type(key)=='string' then insert(key)
                elseif type(v)=='string' then insert(v) end
            end
        elseif type(value)=='string' then
            local ok,parsed=pcall(function() return game:GetService('HttpService'):JSONDecode(value) end)
            if ok and type(parsed)=='table' then parse(parsed)
            else for v in value:gmatch('[^,;|]+') do insert(v:match('^%s*(.-)%s*$')) end end
        end
    end
    local keys={'Mutations','Mutation','BaseMutation','MutationIds','MutationId'}
    local function inspect(attrs,source,authoritative)
        for _,key in ipairs(keys) do
            local value=attrs[key]
            if type(value)=='string' or type(value)=='table' then
                parse(value)
                if authoritative or #names>0 then known=true end
                sources[source]=true
            end
        end
    end
    if type(record)=='table' then inspect(record,'UID record',true) end
    inspect(model:GetAttributes(),'model attrs',true)
    for _,child in ipairs(model:GetDescendants()) do
        inspect(child:GetAttributes(),'child attrs',false)
        if child:IsA('StringValue') then
            for _,key in ipairs(keys) do
                if child.Name==key then parse(child.Value); sources['StringValue']=true; if #names>0 then known=true end end
            end
        end
    end
    table.sort(names)
    local origin={}; for source in pairs(sources) do origin[#origin+1]=source end; table.sort(origin)
    return names,known,table.concat(origin,' + ')
end
local function meshSignature(model)
    local ids={}
    for _,obj in ipairs(model:GetDescendants()) do
        if obj:IsA('MeshPart') or obj:IsA('SpecialMesh') then
            local id=tostring(obj.MeshId):match('%d+')
            if id then ids[#ids+1]=id end
        end
    end
    table.sort(ids)
    return #ids>0 and table.concat(ids,':') or nil
end
local function uniqueMatch(candidates)
    local found
    for _,candidate in ipairs(candidates) do
        if found and found~=candidate then return nil end
        found=candidate
    end
    return found
end
local function readTraitNames(record)
    local names,seen={},{}
    local known=record.Mutations~=nil or record.BaseMutation~=nil
    local function add(value)
        if type(value)=='string' and value~='' and value~='None' and value~='Normal' and not seen[value] then seen[value]=true;names[#names+1]=value end
    end
    if type(record.Mutations)=='table' then
        for key,value in pairs(record.Mutations) do
            if value==true and type(key)=='string' then add(key)
            elseif type(value)=='string' then add(value)
            elseif type(value)=='table' then local id=value.Id or value._id or value.Name; if type(id)=='string' then add(id) else known=false end end
        end
    elseif type(record.Mutations)=='string' then
        for value in record.Mutations:gmatch('[^,;|]+') do add(value:match('^%s*(.-)%s*$')) end
    end
    add(record.BaseMutation);table.sort(names)
    return names,known
end
local function installFinderButtonMotion(D,panel,Input,isActive)
    local Tweens=game:GetService('TweenService')
    local states={}
    local function attachButtonMotion(button)
        if not (button:IsA('TextButton') or button:IsA('ImageButton')) then return end
        if button.Name=='SettingsOverlay' or button.Name=='LauncherHitArea' or button:GetAttribute('TenshiButtonMotion') then return end
        button:SetAttribute('TenshiButtonMotion',true)
        local motion=D.make('UIScale',{Name='ButtonMotion',Scale=1},button)
        local state={button=button,motion=motion,base=button.Position,hover=false,input=nil,tween=nil,writing=false,alive=true}
        states[button]=state
        local function enabled() return button.Active~=false and button.Selectable~=false end
        local function center()
            if not state.alive or not button.Parent then return end
            local delta=motion.Scale-1
            local x,y=0.5-button.AnchorPoint.X,0.5-button.AnchorPoint.Y
            local size=button.Size
            local goal=UDim2.new(state.base.X.Scale-size.X.Scale*delta*x,state.base.X.Offset-size.X.Offset*delta*x,state.base.Y.Scale-size.Y.Scale*delta*y,state.base.Y.Offset-size.Y.Offset*delta*y)
            state.lastPosition=goal
            if button.Position==goal then return end
            state.writing=true
            button.Position=goal
            state.writing=false
        end
        local function update()
            if not state.alive then return end
            if state.tween then state.tween:Cancel();state.tween=nil end
            local target=1
            if enabled() then
                if state.input then target=0.95
                elseif state.hover then
                    local width=math.max(1,button.AbsoluteSize.X/math.max(0.01,motion.Scale))
                    target=math.min(1.06,1+5/width)
                end
            else state.input=nil;state.hover=false end
            state.tween=Tweens:Create(motion,TweenInfo.new(state.input and 0.08 or 0.13,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=target})
            state.tween:Play()
        end
        state.update=update
        motion:GetPropertyChangedSignal('Scale'):Connect(center)
        button:GetPropertyChangedSignal('Position'):Connect(function()
            if not state.writing and button.Position~=state.lastPosition then state.base=button.Position;center() end
        end)
        button:GetPropertyChangedSignal('Size'):Connect(center)
        button:GetPropertyChangedSignal('AnchorPoint'):Connect(center)
        button:GetPropertyChangedSignal('Active'):Connect(update)
        button:GetPropertyChangedSignal('Selectable'):Connect(update)
        button.MouseEnter:Connect(function()
            if Input:GetLastInputType()==Enum.UserInputType.Touch then return end
            state.hover=true;update()
        end)
        button.MouseLeave:Connect(function() state.hover=false;update() end)
        button.SelectionGained:Connect(function() state.hover=true;update() end)
        button.SelectionLost:Connect(function() state.hover=false;update() end)
        button.InputBegan:Connect(function(input)
            if not enabled() then return end
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                if input.UserInputType==Enum.UserInputType.Touch then state.hover=false end
                state.input=input;update()
            end
        end)
        button.Destroying:Connect(function()
            state.alive=false
            if state.tween then state.tween:Cancel() end
            states[button]=nil
        end)
    end
    local release=Input.InputEnded:Connect(function(input)
        for _,state in pairs(states) do
            if state.input and (state.input==input or state.input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1) then
                state.input=nil;state.update()
            end
        end
    end)
    for _,button in ipairs(panel:GetDescendants()) do attachButtonMotion(button) end
    local added=panel.DescendantAdded:Connect(function(button)
        if button:IsA('TextButton') or button:IsA('ImageButton') then
            task.defer(function() if isActive() and button.Parent then attachButtonMotion(button) end end)
        end
    end)
    local hidden=panel:GetPropertyChangedSignal('Visible'):Connect(function()
        if panel.Visible then return end
        for _,state in pairs(states) do state.input=nil;state.hover=false;state.update() end
    end)
    D.gui.Destroying:Connect(function()
        release:Disconnect();added:Disconnect();hidden:Disconnect()
        for _,state in pairs(states) do
            state.alive=false;if state.tween then state.tween:Cancel() end
        end
        table.clear(states)
    end)
end

local function installFinderScrollbarMotion(D,panel,list,Input,isActive)
    local Tweens=game:GetService('TweenService')
    local hovered,moving,scheduled=false,false,false
    local lastMovement=0
    local tween
    local function paint()
        if tween then tween:Cancel() end
        local highlighted=hovered or moving
        tween=Tweens:Create(list,TweenInfo.new(0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
            ScrollBarThickness=highlighted and 9 or 6,
            ScrollBarImageColor3=highlighted and Color3.fromRGB(200,205,220) or Color3.fromRGB(137,140,150),
            ScrollBarImageTransparency=highlighted and 0 or 0.18
        })
        tween:Play()
    end
    local function idle()
        if not isActive() or not list.Parent then scheduled=false;return end
        if os.clock()-lastMovement<0.22 then task.delay(0.12,idle);return end
        scheduled=false;moving=false;paint()
    end
    local enter=list.MouseEnter:Connect(function()
        if Input:GetLastInputType()==Enum.UserInputType.Touch then return end
        hovered=true;paint()
    end)
    local leave=list.MouseLeave:Connect(function() hovered=false;paint() end)
    local scrolled=list:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
        lastMovement=os.clock()
        if not moving then moving=true;paint() end
        if not scheduled then scheduled=true;task.delay(0.24,idle) end
    end)
    local hidden=panel:GetPropertyChangedSignal('Visible'):Connect(function()
        if not panel.Visible then hovered=false;moving=false;paint() end
    end)
    D.gui.Destroying:Connect(function()
        enter:Disconnect();leave:Disconnect();scrolled:Disconnect();hidden:Disconnect()
        if tween then tween:Cancel() end
    end)
    paint()
end

local function createFinder(D)
    local cycleModule
    pcall(function() cycleModule=module('Shared.Util.AreaEggCycle') end)
    local function cycleInfo()
        if not cycleModule then return nil end
        local ok,info=pcall(function()
            local now=workspace:GetServerTimeNow()
            local running=cycleModule.IsRunning()
            local remaining=cycleModule.SecondsUntilReset(now)
            local respawnAt
            if type(cycleModule.PeriodStartTime)=='function' and type(cycleModule.PeriodIndexAt)=='function' then
                local known,value=pcall(function() return cycleModule.PeriodStartTime(cycleModule.PeriodIndexAt(now))*1000 end)
                if known and type(value)=='number' then respawnAt=value end
            end
            return {resetAt=cycleModule.NextResetTime(now)*1000,respawnAt=respawnAt,remaining=remaining,running=running}
        end)
        return ok and info or nil
    end
    -- Display/join quarantine only. This never filters broadcast snapshots.
    D.publicPrioritySeen={}
    D.publicPriorityVisible=function(entry,rank)
        if rank~=1 then return true end
        local first=D.publicPrioritySeen[entry.key]
        if not first then first=os.clock();D.publicPrioritySeen[entry.key]=first end
        return os.clock()-first>=5
    end
    D.publicSightings={}
    D.publicSightingsDirty=false
    D.publicSightingsWriteAt=-math.huge
    D.publicSightingsPath='tenshi_public_sighting_lifecycle_v1.json'
    if type(readfile)=='function' then
        pcall(function()
            local saved=game:GetService('HttpService'):JSONDecode(readfile(D.publicSightingsPath))
            if type(saved)=='table' and saved.version==1 and type(saved.items)=='table' then
                local count=0
                for key,value in pairs(saved.items) do
                    if count>=60000 then break end
                    if type(key)=='string' and #key<=512 and type(value)=='table' and (value.retired==true or type(value.deadline)=='number' and value.deadline==value.deadline and math.abs(value.deadline)<math.huge) then D.publicSightings[key]=value;count+=1 end
                end
            end
        end)
    end
    -- This exact sighting was confirmed to predate multiple resets.
    D.publicSightings['107778070777162:10d3ade5-36f6-42c6-b25e-b4cbaa61977e:845e5200c4984a26bb83680e068ac9c5']={retired=true}
    D.publicEntryAllowed=function(entry,now)
        if type(entry)~='table' then return false end
        local key=entry.key
        if type(key)~='string' then return true end
        if not D.publicPrioritySeen[key] then D.publicPrioritySeen[key]=os.clock() end
        local prior=D.publicSightings[key]
        if prior and prior.retired then return false end
        if prior and prior.deadline<=now then prior.retired=true;D.publicSightingsDirty=true;return false end
        if entry.resetEstimated==false and type(entry.expiresAt)=='number' then
            if not prior then
                prior={deadline=entry.expiresAt};D.publicSightings[key]=prior;D.publicSightingsDirty=true
            elseif entry.expiresAt<prior.deadline then prior.deadline=entry.expiresAt;D.publicSightingsDirty=true end
            if prior.deadline<=now then prior.retired=true;return false end
        end
        return true
    end
    D.savePublicSightings=function()
        if not D.publicSightingsDirty or os.clock()-D.publicSightingsWriteAt<2 or type(writefile)~='function' then return end
        D.publicSightingsWriteAt=os.clock()
        local ok=pcall(function() writefile(D.publicSightingsPath,game:GetService('HttpService'):JSONEncode({version=1,items=D.publicSightings})) end)
        if ok then D.publicSightingsDirty=false end
    end

    local originalMake,originalLabel=D.make,D.label
    D.make=function(class,props,parent)
        if class=='TextButton' or class=='TextBox' then props.Font=Enum.Font.GothamBold;props.TextSize=math.max(props.TextSize or 15,15) end
        if class=='TextBox' then props.TextColor3=Color3.fromRGB(25,25,30) end
        local obj=originalMake(class,props,parent)
        if class=='TextButton' or class=='TextBox' then originalMake('UICorner',{CornerRadius=UDim.new(0,5)},obj) end
        return obj
    end
    D.label=function(parent,text,pos,size,color,fontSize)
        local obj=originalLabel(parent,text,pos,size,color or Color3.fromRGB(240,242,255),math.max(fontSize or 15,14))
        obj.Font=Enum.Font.GothamBold;obj.TextStrokeColor3=Color3.new(0,0,0);obj.TextStrokeTransparency=0.45;return obj
    end
    local DISCORD='https://discord.com/users/1078459357185970268'
    local Http=game:GetService('HttpService')
    local Teleports=game:GetService('TeleportService')
    local requestFn=request or http_request or (syn and syn.request) or (http and http.request)
    local active,othersOnly=true,false
    local reporterId=Http:GenerateGUID(false)
    local config,configAt=nil,-math.huge
    local feed,feedAt={},0
    local clockOffset=0
    local networkBusy=false
    local networkTicket=0
    local localStates={}
    local reportStatus='Connecting'
    local queryStatus=''
    local minRate,minRank=1e9,6
    local serversMinValue=1e9
    local joining=false
    local currentJoinSource='JOIN'
    local joinAttemptSerial=0
    local joinedEggSettingKey='UNKNOWNJoinedEggV1'
    local takenEggNightCleanupDone=false
    local joinedEgg
    pcall(function()
        local saved=Teleports:GetTeleportSetting(joinedEggSettingKey)
        if type(saved)=='table' and type(saved.uid)=='string' and type(saved.jobId)=='string' and type(saved.placeId)=='number' then joinedEgg=saved end
    end)
    local function rememberJoinedEgg(entry)
        if type(entry)~='table' or entry.uid==nil or tonumber(entry.placeId)==nil or type(entry.jobId)~='string' then return end
        local saved={
            placeId=tonumber(entry.placeId),jobId=entry.jobId,uid=tostring(entry.uid),
            name=tostring(entry.name or 'Unknown egg'),rate=tonumber(entry.rate) or 0,
            missingRate=entry.missingRate==true,scale=tonumber(entry.scale),weight=tonumber(entry.weight),
            icon=type(entry.icon)=='string' and entry.icon or '',rarity=tostring(entry.rarity or 'Unknown'),
            rank=tonumber(entry.rank or entry.localTier) or 0,
            mutations=tostring(entry.mutations or entry.mutationText or ''),
            traitsKnown=entry.traitsKnown~=false,area=tostring(entry.area or ''),
            source=tostring(entry.source or 'field')
        }
        joinedEgg=saved
        takenEggNightCleanupDone=false
        pcall(function() Teleports:SetTeleportSetting(joinedEggSettingKey,saved) end)
    end
    D.joinedEgg=joinedEgg
    local localHighlight
    local pageOffset,nextOffset=0,nil
    local queryEpoch=0
    local settingsPath='tenshi_beta_ui.json'
    local settings={}
    if type(readfile)=='function' then pcall(function() local data=Http:JSONDecode(readfile(settingsPath));if type(data)=='table' then settings=data end end) end
    local currentLanguage=settings.language=='Arabic' and 'Arabic' or 'English'
    local function L(english,arabic) return currentLanguage=='Arabic' and arabic or english end
    local autoJoinMinValue=1e9
    local autoJoinMinValueSettingKey='UNKNOWNAutoJoinMinValueV1'
    -- TeleportSetting is the freshest value across a server hop; local JSON may be stale.
    local teleportSavedAutoJoinValue
    pcall(function()
        local saved=Teleports:GetTeleportSetting(autoJoinMinValueSettingKey)
        if type(saved)=='number' and saved>=1e9 and saved<=50e9 then teleportSavedAutoJoinValue=saved end
    end)
    if teleportSavedAutoJoinValue then
        autoJoinMinValue=teleportSavedAutoJoinValue
    elseif type(settings.autoJoinMinValue)=='number' and settings.autoJoinMinValue>=1e9 and settings.autoJoinMinValue<=50e9 then
        autoJoinMinValue=settings.autoJoinMinValue
    end
    if type(settings.myServer)=='boolean' then othersOnly=settings.myServer end
    if type(settings.serversMinValue)=='number' and settings.serversMinValue>=1e9 and settings.serversMinValue<=50e9 then serversMinValue=settings.serversMinValue end
    if type(settings.minRank)=='number' then
        local saved=math.floor(settings.minRank)
        if saved>=6 and saved<=10 then minRank=saved
        elseif saved==0 and settings.rarityMenu=='mythic-up-v1' then minRank=0 end
    end
    local menuHotkey=Enum.KeyCode.F
    local sharingNotice=D.label(D.gui,'EGG FINDER ON â¢ Sharing egg sightings & server ID',UDim2.new(0,12,1,-28),UDim2.new(1,-24,0,22),Color3.fromRGB(245,245,245),12)
    sharingNotice.Visible=false;sharingNotice.TextSize=12;sharingNotice.TextWrapped=true;sharingNotice.TextStrokeTransparency=0.15
    local panel=D.make('Frame',{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-18,0.5,0),Size=UDim2.new(0.94,0,0.86,0),BackgroundColor3=Color3.fromRGB(22,23,27),Visible=false},D.gui)
    local responsiveScale=D.make('UIScale',{Scale=0.8},panel)

    D.make('UICorner',{CornerRadius=UDim.new(0,4)},panel)
    D.make('UIStroke',{Color=Color3.fromRGB(125,128,138),Thickness=2},panel)
    local bar=D.make('Frame',{Position=UDim2.fromOffset(1,1),Size=UDim2.new(1,-2,0,45),BackgroundColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0},panel)
    D.make('UICorner',{CornerRadius=UDim.new(0,4)},bar)
    local heading=D.label(panel,'UNKNOWN',UDim2.fromOffset(14,8),UDim2.new(1,-55,0,32),nil,22)
    local open=D.make('ImageButton',{Image='',Position=UDim2.fromOffset(18,80),Size=UDim2.fromOffset(90,90),BackgroundColor3=Color3.fromRGB(250,250,250),ScaleType=Enum.ScaleType.Fit,ClipsDescendants=true},D.gui)
    D.make('UICorner',{CornerRadius=UDim.new(1,0)},open)
    local fallback=D.label(open,'UNKNOWN',UDim2.new(),UDim2.fromScale(1,1),Color3.fromRGB(150,25,40),19)
    local iconCaption=D.label(open,'UNKNOWN',UDim2.new(0.5,-48,1,5),UDim2.fromOffset(96,27),Color3.new(1,1,1),18)
    open.ClipsDescendants=true
    -- Original icon only; no decorative portal or black-hole effects.
    iconCaption.TextStrokeTransparency=0.15;iconCaption.TextXAlignment=Enum.TextXAlignment.Center
    local function restorePosition(target,value)
        if type(value)~='table' then return end
        for i=1,4 do if type(value[i])~='number' or value[i]~=value[i] or math.abs(value[i])>5000 then return end end
        target.Position=UDim2.new(value[1],value[2],value[3],value[4])
    end
    restorePosition(panel,settings.panel);restorePosition(open,settings.icon)
    D.publicGuiPercent=function(value,factor)
        local n=tonumber(value) or (tonumber(factor) or 1)*100
        if n~=n or math.abs(n)==math.huge then n=100 end
        return math.clamp(math.floor(n/10+0.5)*10,70,150)
    end
    do
        local latest
        local function consider(value)
            if type(value)=='table' and type(value.percent)=='number' and value.percent>=70 and value.percent<=150 and type(value.at)=='number' and (not latest or value.at>latest.at) then latest=value end
        end
        if type(readfile)=='function' then pcall(function() consider(Http:JSONDecode(readfile('tenshi_public_gui_size_v2.json'))) end) end
        pcall(function() local data=Teleports:GetTeleportSetting('TenshiPublicGuiSizeV2');if type(data)=='string' then consider(Http:JSONDecode(data)) end end)
        if latest then settings.sizePercent=latest.percent end
    end
    D.savePublicGuiSize=function(percent)
        local data=Http:JSONEncode({percent=percent,at=workspace:GetServerTimeNow()*1000})
        if type(writefile)=='function' then pcall(writefile,'tenshi_public_gui_size_v2.json',data) end
        pcall(function() Teleports:SetTeleportSetting('TenshiPublicGuiSizeV2',data) end)
    end
    local sizePercent=D.publicGuiPercent(settings.sizePercent,settings.sizeFactor)
    local sizeFactor=sizePercent/100
    local launcherScale=D.make('UIScale',{Scale=0.8},open)
    local function fitFinder()
        local view=D.gui.AbsoluteSize
        if view.X<=0 or view.Y<=0 then return end
        local landscape=view.X>view.Y
        local width=math.min(321.6*sizeFactor,view.X*(landscape and 0.40 or 0.92),view.X-16)
        local height=math.min(680*sizeFactor,view.Y*0.83)
        width=math.min(width,view.X-65)
        local scale=math.max(0.2,math.min(width/402,height/680))*1.10
        responsiveScale.Scale=scale*0.95
        panel.Size=UDim2.fromOffset(402,680)
        launcherScale.Scale=math.min(0.8,math.max(0.5,math.min(view.X,view.Y)/650))
        local function keepVisible(target,caption)
            local size=target.AbsoluteSize
            local p=target.Position
            local anchor=target.AnchorPoint
            local x=p.X.Scale*view.X+p.X.Offset
            local y=p.Y.Scale*view.Y+p.Y.Offset
            x=math.clamp(x,8+size.X*anchor.X,math.max(8+size.X*anchor.X,view.X-8-size.X*(1-anchor.X)))
            y=math.clamp(y,8+size.Y*anchor.Y,math.max(8+size.Y*anchor.Y,view.Y-8-caption-size.Y*(1-anchor.Y)))
            target.Position=UDim2.fromScale(x/view.X,y/view.Y)
        end
        task.defer(function()
            if panel.Parent then keepVisible(panel,0);keepVisible(open,28*launcherScale.Scale) end
        end)
    end
    local resizeConnection=D.gui:GetPropertyChangedSignal('AbsoluteSize'):Connect(fitFinder)
    D.gui.Destroying:Connect(function() resizeConnection:Disconnect() end)
    task.defer(fitFinder)

    local function saveSettings()
        pcall(D.savePublicGuiSize,sizePercent)
        if type(writefile)~='function' then return end
        pcall(function()
            local function coords(p) return {p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset} end
            writefile(settingsPath,Http:JSONEncode({myServer=othersOnly,minRank=minRank,rarityMenu='mythic-up-v1',serversMinValue=serversMinValue,autoJoinMinValue=autoJoinMinValue,autoExecute=autoExecuteEnabled,language=currentLanguage,sizeFactor=sizeFactor,sizePercent=sizePercent,panel=coords(panel.Position),icon=coords(open.Position)}))
        end)
    end
    local settingsButton=D.make('TextButton',{Name='SettingsButton',Text='⚙',Position=UDim2.new(0,7,0,7),Size=UDim2.fromOffset(38,38),BackgroundColor3=Color3.fromRGB(42,44,52),BackgroundTransparency=1,TextColor3=Color3.fromRGB(255,255,255),TextSize=38,Font=Enum.Font.Gotham,BorderSizePixel=0,ZIndex=20},panel)
    D.make('UICorner',{CornerRadius=UDim.new(1,0)},settingsButton)
    local settingsOverlay=D.make('Frame',{Name='SettingsOverlay',Position=UDim2.fromScale(0,0),Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(18,20,26),BackgroundTransparency=0.04,BorderSizePixel=0,Visible=false,ZIndex=30},panel)
    D.make('UICorner',{CornerRadius=UDim.new(0,5)},settingsOverlay)
    local settingsTitle=D.label(settingsOverlay,'⚙',UDim2.fromOffset(10,11),UDim2.fromOffset(38,38),Color3.fromRGB(255,255,255),38)
    settingsTitle.TextXAlignment=Enum.TextXAlignment.Center
    settingsTitle.TextYAlignment=Enum.TextYAlignment.Center
    settingsTitle.Font=Enum.Font.Gotham
    settingsTitle.ZIndex=31
    local autoExecuteToggle=D.make('TextButton',{Name='AutoExecuteToggle',Text='',Position=UDim2.fromOffset(14,120),Size=UDim2.new(1,-28,0,46),BackgroundColor3=Color3.fromRGB(67,70,80),TextColor3=Color3.fromRGB(255,255,255),TextSize=22,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=31},settingsOverlay)
    D.make('UICorner',{CornerRadius=UDim.new(0,6)},autoExecuteToggle)
    local discordAccountButton=D.make('TextButton',{Name='DiscordAccountButton',Text='DISCORD ACCOUNT',Position=UDim2.fromOffset(14,178),Size=UDim2.new(1,-28,0,46),BackgroundColor3=Color3.fromRGB(88,101,242),TextColor3=Color3.fromRGB(255,255,255),TextSize=25,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,BorderSizePixel=0,ZIndex=31},settingsOverlay)
    D.make('UICorner',{CornerRadius=UDim.new(0,6)},discordAccountButton)
    local languageButton=D.make('TextButton',{Name='LanguageButton',Text='',Position=UDim2.fromOffset(14,62),Size=UDim2.new(1,-28,0,46),BackgroundColor3=Color3.fromRGB(67,70,80),BackgroundTransparency=0.5,TextColor3=Color3.fromRGB(255,255,255),TextSize=25,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=31},settingsOverlay)
    D.make('UICorner',{CornerRadius=UDim.new(0,6)},languageButton)
    D.make('ImageLabel',{Name='DiscordIcon',Image='rbxassetid://126999699866157',ImageColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,Position=UDim2.fromOffset(13,10),Size=UDim2.fromOffset(26,26),ScaleType=Enum.ScaleType.Fit,Active=false,ZIndex=33},discordAccountButton)
    discordAccountButton.Activated:Connect(function()
        local discordUrl='https://discord.com/users/1078459357185970268'
        local opened=false
        local openers={
            function() if type(openurl)=='function' then openurl(discordUrl);return true end end,
            function() if type(open_url)=='function' then open_url(discordUrl);return true end end,
            function() if syn and type(syn.open_url)=='function' then syn.open_url(discordUrl);return true end end,
            function() game:GetService('GuiService'):OpenBrowserWindow(discordUrl);return true end
        }
        for _,tryOpen in ipairs(openers) do
            local ok,result=pcall(tryOpen)
            if ok and result==true then opened=true;break end
        end
        if not opened then
            local copied=false
            if type(setclipboard)=='function' then copied=pcall(setclipboard,discordUrl)
            elseif type(toclipboard)=='function' then copied=pcall(toclipboard,discordUrl) end
            pcall(function()
                game:GetService('StarterGui'):SetCore('SendNotification',{
                    Title='UNKNOWN • Discord',
                    Text=copied and 'Could not open Discord automatically. Profile link copied; paste it in your browser.' or 'Could not open Discord automatically. Use the Discord link shown at the top of the menu.',
                    Duration=6
                })
            end)
        end
    end)
    local function refreshAutoExecuteToggle()
        autoExecuteToggle.Text=autoExecuteEnabled and L('AUTO EXECUTE: ON','التشغيل التلقائي: مفعّل') or L('AUTO EXECUTE: OFF','التشغيل التلقائي: متوقف')
        autoExecuteToggle.BackgroundColor3=autoExecuteEnabled and Color3.fromRGB(100,0,170) or Color3.fromRGB(0,0,0)
        autoExecuteToggle.BackgroundTransparency=autoExecuteEnabled and .3 or 0
        local stroke=autoExecuteToggle:FindFirstChildOfClass('UIStroke')
        if stroke then stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;stroke.Color=Color3.fromRGB(130,120,143);stroke.Thickness=1 end
    end
    local function refreshLanguageButton()
        languageButton.Text=currentLanguage=='Arabic' and 'ENGLISH' or 'العربية'
    end
    refreshLanguageButton()
    refreshAutoExecuteToggle()
    settingsButton.Activated:Connect(function() settingsOverlay.Visible=not settingsOverlay.Visible end)
    autoExecuteToggle.Activated:Connect(function()
        autoExecuteEnabled=not autoExecuteEnabled
        refreshAutoExecuteToggle()
        saveSettings()
        if not autoExecuteEnabled then autoExecuteQueued=false end
    end)
    local stopScriptButton=D.make('TextButton',{Name='StopScriptButton',Text='STOP SCRIPT',AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,14,1,-14),Size=UDim2.new(1,-28,0,46),BackgroundColor3=Color3.fromRGB(200,45,45),BackgroundTransparency=0,TextColor3=Color3.fromRGB(255,255,255),TextSize=22,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=31},settingsOverlay)
    stopScriptButton.Activated:Connect(function()
        stopScriptButton.Text=L('STOPPING...','جارٍ الإيقاف...')
        stopScriptButton.Active=false
        autoExecuteEnabled=false
        saveSettings()
        if type(D.stopScript)=='function' then
            D.stopScript()
        elseif D.gui and D.gui.Parent then
            D.gui:Destroy()
        end
    end)
    D.saveGuiBeforeTeleport=saveSettings
    heading.Size=UDim2.fromOffset(185,32)
    heading.TextSize=19
    local brandLogo=D.make('ImageLabel',{Name='TenshiBrandLogo',Position=UDim2.fromOffset(10,2),Size=UDim2.fromOffset(180,42),BackgroundTransparency=1,Image='',ScaleType=Enum.ScaleType.Fit,Active=true},panel)
    brandLogo.Visible=false
    heading.Text='UNKNOWN'
    heading.TextSize=18
    heading.Font=Enum.Font.Arcade
    heading.TextScaled=true
    heading.TextWrapped=false
    heading.TextTruncate=Enum.TextTruncate.None
    D.make('UITextSizeConstraint',{MinTextSize=1,MaxTextSize=20},heading)
    heading.Size=UDim2.fromOffset(205,25)
    heading.Position=UDim2.fromOffset(10,2)
    heading.TextStrokeTransparency=0.65
    open.BackgroundTransparency=1
    iconCaption.Visible=false
    -- Static launcher artwork is installed from the embedded image below.
    open.ClipsDescendants=false
    open.Size=UDim2.fromOffset(120,120)
    local oldLauncherCorner=open:FindFirstChildOfClass('UICorner');if oldLauncherCorner then oldLauncherCorner:Destroy() end

    -- The static launcher retains the original open and drag behavior.

    -- Main-panel red close button intentionally removed.
    local suppressOpenUntil=0
    open.Activated:Connect(function() if os.clock()<suppressOpenUntil then return end; panel.Visible=not panel.Visible; D.localPanel.Visible=not panel.Visible end)
    local Input=game:GetService('UserInputService')
    local drag
    local function draggable(target,handle,isLauncher)
        handle.Active=true
        handle.InputBegan:Connect(function(input)
            if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
            drag={target=target,input=input,start=input.Position,position=target.Position,absolute=target.AbsolutePosition,size=target.AbsoluteSize,launcher=isLauncher,moved=false}
        end)
    end
    draggable(panel,heading,false)
    draggable(panel,brandLogo,false)
    -- Window dragging is confined to its header; scrollbar has no drag overlay.
    draggable(panel,bar,false)

    draggable(open,open,true)
    local launcherHit=D.make('TextButton',{Name='LauncherHitArea',Text='',AutoButtonColor=false,BackgroundTransparency=1,Position=UDim2.fromOffset(-8,-8),Size=UDim2.new(1,16,1,16),ZIndex=5},open)
    draggable(open,launcherHit,true)
    launcherHit.Activated:Connect(function()
        if os.clock()<suppressOpenUntil then return end
        panel.Visible=not panel.Visible;D.localPanel.Visible=not panel.Visible
    end)
    local moveConnection=Input.InputChanged:Connect(function(input)
        if not drag then return end
        local mouse=drag.input.UserInputType==Enum.UserInputType.MouseButton1
        if (mouse and input.UserInputType~=Enum.UserInputType.MouseMovement) or (not mouse and input~=drag.input) then return end
        local dx,dy=input.Position.X-drag.start.X,input.Position.Y-drag.start.Y
        if dx*dx+dy*dy>25 then drag.moved=true end
        if not drag.moved then return end
        if drag.launcher then suppressOpenUntil=os.clock()+0.5 end
        local view=D.gui.AbsoluteSize
        local origin=D.gui.AbsolutePosition
        if view.X<=0 or view.Y<=0 then return end
        local left=drag.absolute.X-origin.X
        local top=drag.absolute.Y-origin.Y
        local x=math.clamp(left+dx,0,math.max(0,view.X-drag.size.X))
        local y=math.clamp(top+dy,0,math.max(0,view.Y-drag.size.Y-(drag.launcher and 28*launcherScale.Scale or 0)))
        local anchor=drag.target.AnchorPoint
        drag.target.Position=UDim2.fromScale((x+anchor.X*drag.size.X)/view.X,(y+anchor.Y*drag.size.Y)/view.Y)
    end)
    local endConnection=Input.InputEnded:Connect(function(input)
        if drag and (input==drag.input or input.UserInputType==Enum.UserInputType.MouseButton1) then
            if drag.moved and drag.launcher then suppressOpenUntil=os.clock()+0.3 end
            if drag.moved then saveSettings() end
            drag=nil
        end
    end)
    D.gui.Destroying:Connect(function() moveConnection:Disconnect();endConnection:Disconnect();drag=nil end)
    local status=D.label(panel,'Connectingâ¦',UDim2.fromOffset(14,52),UDim2.new(1,-28,0,48),Color3.fromRGB(210,218,240),14)
    status.Visible=false -- Hide all status messages while keeping internal status logic active
    status.TextWrapped=true
    local discordSubtitle=D.label(panel,DISCORD,UDim2.fromOffset(8,27),UDim2.fromOffset(224,17),Color3.new(1,1,1),15)
    discordSubtitle.TextSize=15
    discordSubtitle.TextScaled=false;discordSubtitle.TextWrapped=false;discordSubtitle.TextXAlignment=Enum.TextXAlignment.Center;discordSubtitle.Visible=true
    local page={Text=''}
    local scope=D.make('TextButton',{Name='AllServers',Text=L('ALL SERVERS','كل السيرفرات'),Position=UDim2.new(0,10,1,-170),Size=UDim2.new(0.5,-15,0,34),BackgroundColor3=Color3.fromRGB(67,70,80),TextColor3=Color3.new(1,1,1),TextSize=13},panel)
    local myScope=D.make('TextButton',{Name='MyServer',Text=L('MY SERVER','سيرفري'),Position=UDim2.new(0.5,5,1,-170),Size=UDim2.new(0.5,-15,0,34),BackgroundColor3=Color3.fromRGB(67,70,80),TextColor3=Color3.new(1,1,1),TextSize=13},panel)
    for _,button in ipairs({scope,myScope}) do
        button.TextScaled=true;button.TextWrapped=false
        D.make('UITextSizeConstraint',{MinTextSize=1,MaxTextSize=16},button)
    end
    local function stateAppearance(button,selected)
        button.BackgroundColor3=selected and Color3.fromRGB(100,0,170) or Color3.fromRGB(0,0,0)
        button.BackgroundTransparency=selected and 0.3 or 0
        local stroke=button:FindFirstChildOfClass('UIStroke')
        if stroke then stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;stroke.Color=selected and Color3.fromRGB(220,180,255) or Color3.fromRGB(130,120,143);stroke.Thickness=selected and 2 or 1 end
    end
    local function styleScope()
        stateAppearance(scope,not othersOnly);stateAppearance(myScope,othersOnly)
        scope.TextColor3=Color3.new(1,1,1);myScope.TextColor3=Color3.new(1,1,1)
    end
    local requestScopeRender
    local function setScope(myServer)
        if othersOnly==myServer then return end
        othersOnly=myServer;styleScope()
        page.Text=othersOnly and L('LOCAL EGGS','بيض السيرفر الحالي') or 'TOP 10'
        queryEpoch+=1;pageOffset=0;feedAt=-math.huge;task.defer(saveSettings)
        if requestScopeRender then requestScopeRender() end
    end
    scope.Activated:Connect(function() setScope(false) end)
    myScope.Activated:Connect(function() setScope(true) end)
    styleScope()
    local rarityOptions={{name='Mythic',rank=6},{name='Cosmic',rank=7},{name='Secret',rank=8},{name='Eternal',rank=9},{name='Divine',rank=10},{name='Any',rank=0}}
    local rarityIndex=#rarityOptions
    minRank=0
    local function rarityButtonText()
        local name=rarityOptions[rarityIndex].name
        local colors={Mythic='#FF4B55',Cosmic='#BE55FF',Secret='#FFFFFF',Eternal='#DACAEC',Divine='#FFCD37',Any='#FFFFFF'}
        return 'MIN RARITY: <font color="'..colors[name]..'">'..name..'</font>'
    end
    local rarity=D.make('TextButton',{Text=rarityButtonText(),RichText=true,Position=UDim2.new(0,10,1,-96),Size=UDim2.new(0.60,-15,0,36),BackgroundColor3=Color3.fromRGB(45,90,175),TextColor3=Color3.new(1,1,1),TextSize=12},panel)
    rarity.Visible=false;rarity.Active=false
    rarity.Activated:Connect(function()
        rarityIndex=rarityIndex%#rarityOptions+1;minRank=rarityOptions[rarityIndex].rank
        rarity.Text=rarityButtonText()
        queryEpoch+=1;feed={};pageOffset=0;feedAt=-math.huge;saveSettings()
    end)
    local refreshButton=D.make('TextButton',{Text='',Position=UDim2.fromOffset(10,54),Size=UDim2.new(1,-20,0,30),BackgroundColor3=Color3.fromRGB(115,215,45),BackgroundTransparency=0.5,TextColor3=Color3.new(1,1,1),TextSize=14,Active=false,Selectable=false,AutoButtonColor=false},panel)
    local resetTimer=D.label(refreshButton,'إعادة الضبط --:--',UDim2.fromOffset(0,0),UDim2.new(1,0,1,0),Color3.fromRGB(230,245,255),13)
    resetTimer.TextXAlignment=Enum.TextXAlignment.Center
    resetTimer.TextTruncate=Enum.TextTruncate.AtEnd
    resetTimer.Active=false
    resetTimer.Selectable=false
    local refreshing=false
    local function recordJoinError(source,stage,message) end
    local list=D.make('ScrollingFrame',{Position=UDim2.fromOffset(14,92),Size=UDim2.new(1,-16,1,-272),BackgroundTransparency=1,BorderSizePixel=0,AutomaticCanvasSize=Enum.AutomaticSize.None,CanvasSize=UDim2.new(),ScrollBarThickness=6,ScrollBarImageColor3=Color3.fromRGB(137,140,150),ScrollBarImageTransparency=0},panel)
    
    D.make('UIListLayout',{Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder},list)
    D.make('UIPadding',{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,3)},list)
    local loadingVisible=true
    local function loadingText(now)
        return 'Loading '..string.rep('.',math.floor(now/0.4)%3+1)
    end
    local aliveContainer=D.make('Frame',{Name='EmptyMessageContainer',Size=UDim2.new(1,-10,0,32),BackgroundTransparency=1},list)
    local aliveMessage=D.label(aliveContainer,loadingText(os.clock()),UDim2.new(),UDim2.new(1,0,1,0),nil,18)
    aliveMessage.TextYAlignment=Enum.TextYAlignment.Center
    local function network(url,method,body,headers,raw)
        if type(requestFn)~='function' then return nil,'Executor HTTP POST unavailable' end
        if not url:find('/v1/join',1,true) then
            local queueDeadline=os.clock()+12
            while networkBusy and active and os.clock()<queueDeadline do task.wait(0.05) end
            if not active then return nil,'Finder is no longer active' end
            if networkBusy then return nil,'Network queue timeout: previous request did not finish' end
            networkBusy=true
            networkTicket+=1
        elseif not active then return nil,'Finder is no longer active' end
        local ticket=networkTicket
        local done,result=false,nil
        local worker=task.spawn(function()
            result=table.pack(pcall(requestFn,{Url=url,Method=method,Headers=headers or {},Body=body,Timeout=10}))
            done=true
            if not url:find('/v1/join',1,true) and networkTicket==ticket then networkBusy=false end
        end)
        local deadline=os.clock()+12
        while active and not done and os.clock()<deadline do task.wait(0.01) end
        if not done then
            if not url:find('/v1/join',1,true) and networkTicket==ticket then networkTicket+=1;networkBusy=false end
            pcall(task.cancel,worker)
            return nil,'Network timeout'
        end
        if not result[1] then return nil,'Network request failed' end
        local response=result[2]
        if type(response)~='table' then return nil,'Invalid HTTP response' end
        local code=tonumber(response.StatusCode or response.Status)
        if code~=200 then
            local message='HTTP '..tostring(code)
            local good,details=pcall(Http.JSONDecode,Http,response.Body or '')
            if good and type(details)=='table' and type(details.error)=='string' then message=message..': '..details.error:sub(1,120) end
            return nil,message
        end
        if raw then return response.Body end
        local ok,decoded=pcall(Http.JSONDecode,Http,response.Body or '')
        if not ok then return nil,'Invalid JSON response' end
        return decoded
    end
    -- Roblox public-server directory, independent of the Finder report feed.
    status.Size=UDim2.new(0.53,-14,0,24)
    status.TextSize=11
    -- Independent minimum income shown in ALL SERVERS; Auto Join keeps its own threshold.
    local serversValueFrame=D.make('Frame',{Name='ValueOfServers',Position=UDim2.new(0,10,1,-128),Size=UDim2.new(1,-20,0,34),BackgroundColor3=Color3.fromRGB(67,70,80),BackgroundTransparency=0.5,BorderSizePixel=0},panel)
    D.make('UICorner',{CornerRadius=UDim.new(0,6)},serversValueFrame)
    local serversValueLabel=D.label(serversValueFrame,L('VALUE OF SERVERS','قيمة السيرفرات'),UDim2.fromOffset(-137,0),UDim2.new(0.62,-8,1,0),Color3.new(1,1,1),20)
    serversValueLabel.TextXAlignment=Enum.TextXAlignment.Left
    local serversValueInput=D.make('TextBox',{Name='ValueOfServersInput',Text=string.format('%gB',serversMinValue/1e9),PlaceholderText='1B - 50B',ClearTextOnFocus=false,Position=UDim2.new(0.64,0,0,3),Size=UDim2.new(0.36,-5,1,-6),BackgroundColor3=Color3.fromRGB(28,12,58),TextColor3=Color3.new(1,1,1),PlaceholderColor3=Color3.fromRGB(205,210,220),TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,BorderSizePixel=0},serversValueFrame)
    D.make('UICorner',{CornerRadius=UDim.new(0,5)},serversValueInput)
    serversValueInput.TextColor3=Color3.fromRGB(255,255,255)
    local function parseServersMinValue(value)
        if type(value)~='string' then return nil end
        local number=value:match('^%s*(%d+%.?%d*)%s*[bB]%s*$')
        local amount=tonumber(number)
        if not amount or amount<1 or amount>50 then return nil end
        return amount*1e9
    end
    serversValueInput.FocusLost:Connect(function()
        local parsed=parseServersMinValue(serversValueInput.Text)
        if parsed then
            serversMinValue=parsed
            serversValueInput.Text=serversValueInput.Text:match('^%s*(.-)%s*$'):upper()
            saveSettings()
            if requestScopeRender then requestScopeRender() end
            queryStatus='ALL SERVERS minimum set to '..serversValueInput.Text
        else
            serversValueInput.Text=string.format('%gB',serversMinValue/1e9)
            queryStatus='Enter a value from 1B to 50B (example: 1.5B)'
        end
    end)
    -- Auto Join minimum is loaded from persistent settings above.
    local minValueFrame=D.make('Frame',{Name='MinAutoJoinValue',Position=UDim2.new(0,10,1,-86),Size=UDim2.new(1,-20,0,34),BackgroundColor3=Color3.fromRGB(67,70,80),BackgroundTransparency=0.5,BorderSizePixel=0},panel)
    D.make('UICorner',{CornerRadius=UDim.new(0,6)},minValueFrame)
    local minValueLabel=D.label(minValueFrame,L('MIN AUTO JOIN VALUE','أقل قيمة للانضمام التلقائي'),UDim2.fromOffset(-92,0),UDim2.new(0.62,-8,1,0),Color3.new(1,1,1),18)
    minValueLabel.TextXAlignment=Enum.TextXAlignment.Left
    local minValueInput=D.make('TextBox',{Name='MinAutoJoinValueInput',Text=string.format('%gB',autoJoinMinValue/1e9),PlaceholderText='1B - 50B',ClearTextOnFocus=false,Position=UDim2.new(0.64,0,0,3),Size=UDim2.new(0.36,-5,1,-6),BackgroundColor3=Color3.fromRGB(28,12,58),TextColor3=Color3.new(1,1,1),PlaceholderColor3=Color3.fromRGB(205,210,220),TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,BorderSizePixel=0},minValueFrame)
    D.make('UICorner',{CornerRadius=UDim.new(0,5)},minValueInput)
    minValueInput.TextColor3=Color3.fromRGB(255,255,255)
    local function parseAutoJoinMinValue(value)
        if type(value)~='string' then return nil end
        local number=value:match('^%s*(%d+%.?%d*)%s*[bB]%s*$')
        local amount=tonumber(number)
        if not amount or amount<1 or amount>50 then return nil end
        return amount*1e9
    end
    minValueInput.FocusLost:Connect(function()
        local parsed=parseAutoJoinMinValue(minValueInput.Text)
        if parsed then
            autoJoinMinValue=parsed
            pcall(function() Teleports:SetTeleportSetting(autoJoinMinValueSettingKey,autoJoinMinValue) end)
            minValueInput.Text=minValueInput.Text:match("^%s*(.-)%s*$")
            saveSettings()
            autoJoinCandidates={};autoJoinCandidateIndex=1;autoJoinRetryRequested=false
            queryStatus='Auto Join minimum set to '..minValueInput.Text
        else
            minValueInput.Text=string.format('%.0fB',autoJoinMinValue/1e9)
            queryStatus='Enter a value from 1B to 50B (example: 1.5B)'
        end
    end)
    -- Auto Join modes are mutually exclusive.
    local autoJoinEnabled=false
    local smartAutoJoinEnabled=false
    local smartBestCandidate=nil
    local smartBestSince=0
    local SMART_AUTO_JOIN_STABLE_SECONDS=1
    local autoJoinBusy=false
    local autoJoinCandidates={}
    local autoJoinCandidateIndex=1
    local autoJoinRetryRequested=false
    local autoJoinAttempted={}
    local autoJoinCooldown={}
    local autoJoinFeed={}
    local autoJoinFeedAt=-math.huge
    local autoJoinNextRefreshAt=0
    local autoJoinFeedStamp=-1
    local autoJoinClockOffset=0
    local AUTO_JOIN_MIN_RANK=7
    local AUTO_JOIN_REFRESH_SECONDS=0.5
    local AUTO_JOIN_SERVER_COOLDOWN=4
    local AUTO_JOIN_ALLOWED_RANKS={[7]=true,[8]=true,[9]=true,[10]=true}
    local autoJoinButton=D.make('TextButton',{Name='AutoJoin',Text='AUTO JOIN: OFF',Position=UDim2.new(0,10,1,-46),Size=UDim2.new(0.5,-15,0,40),BackgroundColor3=Color3.fromRGB(200,45,45),TextColor3=Color3.new(1,1,1),TextSize=20,Font=Enum.Font.GothamBold},panel)
    local smartAutoJoinButton=D.make('TextButton',{Name='SmartAutoJoin',Text='SMART AUTO: OFF',Position=UDim2.new(0.5,5,1,-46),Size=UDim2.new(0.5,-15,0,40),BackgroundColor3=Color3.fromRGB(200,45,45),TextColor3=Color3.new(1,1,1),TextSize=20,Font=Enum.Font.GothamBold},panel)
    for _,button in ipairs({autoJoinButton,smartAutoJoinButton}) do
        D.make('UICorner',{CornerRadius=UDim.new(0,6)},button)
        button.TextScaled=true;button.TextWrapped=false
        D.make('UITextSizeConstraint',{MinTextSize=1,MaxTextSize=16},button)
    end
    local function resetAutoJoinState()
        autoJoinCandidates={};autoJoinCandidateIndex=1;autoJoinRetryRequested=false
        autoJoinAttempted={};autoJoinCooldown={};autoJoinFeed={};autoJoinFeedAt=-math.huge
        autoJoinNextRefreshAt=0;autoJoinFeedStamp=-1
        smartBestCandidate=nil
        smartBestSince=0
        if autoJoinEnabled or smartAutoJoinEnabled then feedAt=-math.huge end
    end
    local function paintAutoJoin()
        autoJoinButton.Text=autoJoinEnabled and L('AUTO JOIN: ON','الانضمام التلقائي: مفعّل') or L('AUTO JOIN: OFF','الانضمام التلقائي: متوقف')
        stateAppearance(autoJoinButton,autoJoinEnabled)
        smartAutoJoinButton.Text=smartAutoJoinEnabled and L('SMART AUTO: ON','الانضمام الذكي: مفعّل') or L('SMART AUTO: OFF','الانضمام الذكي: متوقف')
        stateAppearance(smartAutoJoinButton,smartAutoJoinEnabled)
        for _,button in ipairs({autoJoinButton,smartAutoJoinButton}) do
            button.TextScaled=false;button.TextSize=currentLanguage=='Arabic' and 11 or 12
            local limit=button:FindFirstChildOfClass('UITextSizeConstraint');if limit then limit.MaxTextSize=currentLanguage=='Arabic' and 11 or 16 end
        end
    end
    local function applyLanguage()
        refreshLanguageButton()
        refreshAutoExecuteToggle()
        discordAccountButton.Text=L('DISCORD ACCOUNT','حساب ديسكورد')
        stopScriptButton.Text=L('STOP','إيقاف');stopScriptButton.TextSize=currentLanguage=='Arabic' and 20 or 16
        scope.Text=L('ALL SERVERS','كل السيرفرات')
        myScope.Text=L('MY SERVER','سيرفري')
        serversValueLabel.Text=L('VALUE OF SERVERS','قيمة السيرفرات')
        minValueLabel.Text=L('MIN AUTO JOIN VALUE','أقل قيمة للانضمام التلقائي')
        paintAutoJoin()
        if currentLanguage=='Arabic' then
            serversValueLabel.TextXAlignment=Enum.TextXAlignment.Left
            minValueLabel.TextXAlignment=Enum.TextXAlignment.Left
            serversValueLabel.Position=UDim2.fromOffset(6,0)
            minValueLabel.Position=UDim2.fromOffset(1,0)
        else
            serversValueLabel.TextXAlignment=Enum.TextXAlignment.Left
            minValueLabel.TextXAlignment=Enum.TextXAlignment.Left
            serversValueLabel.Position=UDim2.fromOffset(8,0)
            minValueLabel.Position=UDim2.fromOffset(8,0)
        end
    end
    languageButton.Activated:Connect(function()
        currentLanguage=currentLanguage=='English' and 'Arabic' or 'English'
        applyLanguage()
        saveSettings()
    end)
    applyLanguage()
    autoJoinButton.Activated:Connect(function()
        if not active then return end
        autoJoinEnabled=not autoJoinEnabled
        if autoJoinEnabled then smartAutoJoinEnabled=false end
        resetAutoJoinState()
        paintAutoJoin()
        queryStatus=autoJoinEnabled and 'Auto Join enabled: joining the first eligible server' or 'Auto Join disabled'
    end)
    smartAutoJoinButton.Activated:Connect(function()
        if not active then return end
        smartAutoJoinEnabled=not smartAutoJoinEnabled
        if smartAutoJoinEnabled then autoJoinEnabled=false end
        resetAutoJoinState()
        paintAutoJoin()
        queryStatus=smartAutoJoinEnabled and 'Smart Auto Join: waiting for the best server to stay unchanged for 1 second' or 'Smart Auto Join disabled'
    end)
    local publicBroadcastConfig=nil
    local featureConfig=nil
    local featureSending=false
    local featureTicket=0
    local function optionalFeatureSync(payload)
        if not featureConfig or featureSending or type(requestFn)~='function' then return end
        local endpoint,key=featureConfig.endpoint,featureConfig.roomKey
        featureSending=true;featureTicket+=1
        local ticket=featureTicket
        local worker=task.spawn(function()
            local ok,response=pcall(function()
                return requestFn({Url=endpoint..'/v1/report',Method='POST',Timeout=6,
                    Headers={['Content-Type']='application/json',['X-NYX-Room']=key},Body=Http:JSONEncode(payload)})
            end)
            if featureTicket~=ticket then return end
            featureSending=false
            if D.gui then pcall(function() D.gui:SetAttribute('TenshiFeatureReportOK',ok and type(response)=='table' and tonumber(response.StatusCode or response.Status)==200) end) end
        end)
        task.delay(8,function()
            if featureTicket==ticket and featureSending then featureTicket+=1;featureSending=false;pcall(task.cancel,worker) end
        end)
    end
    -- Feature configuration is optional. Its requests never own the primary
    -- broadcast/feed network lock and cannot gate the classic public sender.
    task.spawn(function()
        while active do
            local ok,data=pcall(function()
                local response=requestFn({Url='https://raw.githubusercontent.com/syss1211/Tenshi-script/experimental/NYX-Finder-Experimental-Config.json?features='..os.time(),Method='GET',Timeout=6})
                if tonumber(response.StatusCode or response.Status)~=200 then return nil end
                return Http:JSONDecode(response.Body)
            end)
            if ok and type(data)=='table' and type(data.endpoint)=='string' and data.endpoint:match('^https://[%w%.%-]+$') and type(data.roomKey)=='string' then
                featureConfig=data
                if publicBroadcastConfig then config=data;feedAt=-math.huge end
            end
            task.wait(60)
        end
    end)
    local function loadConfig()
        local data,err=network('https://raw.githubusercontent.com/syss1211/Tenshi-script/main/NYX-Finder-Config.json?nyx='..os.time(),'GET')
        if not data then return false,err end
        if type(data.endpoint)~='string' or not data.endpoint:match('^https://[%w%.%-]+$') or type(data.roomKey)~='string' then return false,'Finder configuration unavailable' end
        publicBroadcastConfig=data;config=featureConfig or data; configAt=os.clock()
        if false and type(writefile)=='function' then
            local asset=getcustomasset or getsynasset
            if type(asset)=='function' then
                local bytes=network(config.endpoint..'/assets/finder.jpg','GET',nil,nil,true)
                if bytes then
                    pcall(function() writefile('nyx_finder_icon_v19.jpg',bytes);open.Image=asset('nyx_finder_icon_v19.jpg');fallback.Visible=false end)
                end
            end
        end
        return true
    end
    local function headers() return {['Content-Type']='application/json',['X-NYX-Room']=config.roomKey} end
    local broadcastInterval=5
    local function snapshot()
        local eggs={}
        for _,entry in ipairs(D.entries()) do
            if not entry.unresolved and entry.uid and entry.rate and entry.rate>0 then
                eggs[#eggs+1]={uid=tostring(entry.uid),name=entry.name,category=entry.category,rarity=entry.rarity,rank=entry.tier,rate=entry.rate,scale=entry.scale,weight=entry.weight,icon=entry.icon,area=entry.areaKey or entry.area,mutations=entry.mutationText or (entry.traitsKnown==false and 'UNKNOWN' or ''),traitsKnown=entry.traitsKnown~=false,estimated=entry.estimated==true or entry.unmutatedRate~=nil or entry.scaleFromModel==true,visualId=entry.visualId==true,source=entry.isEvent and 'event' or 'field'}
            end
        end
        table.sort(eggs,function(a,b) return a.rate>b.rate end)
        while #eggs>10 do eggs[#eggs]=nil end
        return eggs
    end
    local function report()
        if game.JobId=='' then return false,'No live server ID' end
        if not D.ready() then return false,'Waiting for a fresh field scan' end
        if not publicBroadcastConfig then return false,'Public broadcast configuration unavailable' end
        local eggs=snapshot()
        local good,metadata=pcall(function() return D.metadata and D.metadata() end)
        if not good then metadata=nil end
        local classicEggs=eggs
        -- Match the classic sender's native spawn-slot behavior. Optional state
        -- parsing is protected and never becomes a prerequisite for reporting.
        if metadata and type(metadata.states)=='table' then
            local parsed,filtered=pcall(function()
                local states={}
                for _,state in ipairs(metadata.states) do states[state.uid]=state.state end
                local values={}
                for _,e in ipairs(eggs) do if e.source=='event' or states[e.uid]=='Slot' then values[#values+1]=e end end
                return values
            end)
            if parsed then classicEggs=filtered end
        end
        local body={placeId=game.PlaceId,jobId=game.JobId,reporterId=reporterId,eggs=classicEggs}
        local data,err=network(publicBroadcastConfig.endpoint..'/v1/report','POST',Http:JSONEncode(body),
            {['Content-Type']='application/json',['X-NYX-Room']=publicBroadcastConfig.roomKey})
        if not data or data.ok~=true or type(data.accepted)~='number' then return false,err or 'Public broadcast not acknowledged' end
        if #classicEggs>0 and data.accepted<=0 then return false,'Public broadcast accepted zero eggs' end
        if D.gui then pcall(function() D.gui:SetAttribute('TenshiPublicAccepted',data.accepted);D.gui:SetAttribute('TenshiPublicSent',#classicEggs) end) end
        -- A separate, bounded worker sends feature metadata after primary ACK.
        -- The feature service must not relay this already-published report.
        local native={placeId=game.PlaceId,jobId=game.JobId,reporterId=reporterId,eggs=eggs,publicDirect=true,primaryAccepted=data.accepted,primarySent=#classicEggs}
        pcall(function()
            if metadata then
                native.eggStates=metadata.states;native.resetAt=metadata.resetAt;native.scanAt=metadata.scanAt
                native.scanAgeMs=math.max(0,(os.clock()-metadata.scanClock)*1000)
                native.resetRemainingMs=metadata.resetAt and math.max(0,metadata.resetAt-workspace:GetServerTimeNow()*1000) or nil
            end
            native.userId=D.player.UserId;native.playerIds={}
            for _,member in ipairs(game:GetService('Players'):GetPlayers()) do native.playerIds[#native.playerIds+1]=member.UserId end
            optionalFeatureSync(native)
        end)
        return true,'Shared '..tostring(data.accepted)..' eggs'
    end
    D.flushReport=report
    local function refresh(forceAllServers)
        local epoch=queryEpoch
        local baseQuery='?localJob='..Http:UrlEncode(game.JobId)..'&placeId='..game.PlaceId..'&limit=10&tier=public&minRate='..tostring(minRate)..'&minRank='..tostring(minRank)
        local requestedCycle=cycleInfo()
        if requestedCycle then baseQuery=baseQuery..'&cycleRemainingMs='..tostring(math.max(0,requestedCycle.remaining*1000))..'&cycleId='..tostring(requestedCycle.resetAt) end
        if othersOnly and not forceAllServers then baseQuery=baseQuery..'&onlyJob='..Http:UrlEncode(game.JobId) end

        -- Follow the Finder API's nextOffset cursor, with strict bounds and
        -- duplicate-page protection so a malformed cursor cannot loop forever.
        local allItems,seenItems={},{}
        local mergedStates={}
        local offset,maxPages=0,30
        local pageCount=0
        local pageLimitReached=false
        local lastPageSignature=nil
        local serverTime=nil
        while pageCount<maxPages do
            local requestQuery=baseQuery..'&offset='..tostring(offset)
            local data,err=network(config.endpoint..'/v1/eggs'..requestQuery,'GET',nil,headers())
            if epoch~=queryEpoch then return true end
            if not data or type(data.items)~='table' then
                if pageCount==0 then return false,err or 'Invalid finder feed' end
                queryStatus='Finder pagination stopped: '..tostring(err or 'invalid page')
                break
            end

            pageCount+=1
            serverTime=tonumber(data.serverTime) or serverTime
            for _,entry in ipairs(data.localStates or {}) do
                if type(entry)=='table' and entry.key~=nil then mergedStates[entry.key]=entry end
            end

            local signatureParts={}
            for _,entry in ipairs(data.items) do
                local identity
                if type(entry)=='table' then
                    identity=type(entry.key)=='string' and entry.key
                        or (tostring(entry.placeId or '')..':'..tostring(entry.jobId or '')..':'..tostring(entry.uid or ''))
                end
                if identity and identity~='::' then
                    signatureParts[#signatureParts+1]=identity
                    if not seenItems[identity] then
                        seenItems[identity]=true
                        allItems[#allItems+1]=entry
                    end
                end
            end
            local signature=table.concat(signatureParts,'|')
            if #data.items==0 or signature=='' or signature==lastPageSignature then
                nextOffset=nil
                break
            end
            lastPageSignature=signature
            local following=tonumber(data.nextOffset)
            if not following or following<=offset then
                nextOffset=following
                break
            end
            nextOffset=following
            if following==offset then break end
            offset=following
            task.wait(0.01)
        end

        if epoch~=queryEpoch then return true end
        pageLimitReached=pageCount>=maxPages
        clockOffset=(serverTime or os.time()*1000)/1000-os.clock()
        localStates=mergedStates
        feed={}
        for _,entry in ipairs(allItems) do
            if D.publicEntryAllowed(entry,(os.clock()+clockOffset)*1000) then
                feed[#feed+1]=entry
            end
        end
        D.savePublicSightings()
        feedAt=os.clock()
        if pageLimitReached then
            queryStatus='Updated '..tostring(#feed)..' reports (30-page safety limit; more may exist)'
        else
            queryStatus='Updated '..tostring(#feed)..' reports from '..tostring(pageCount)..' pages'
        end
        page.Text='TOP '..tostring(#feed)
        return true
    end
    -- Auto Join has its own API feed, independent of the ALL SERVERS display feed.
    -- API filtering (minRank=7) is reinforced by a local allowlist (Cosmic through Divine).
    local function refreshAutoJoinFeed()
        if not config then return false,'Finder connection unavailable' end
        local baseQuery='?localJob='..Http:UrlEncode(game.JobId)..'&placeId='..game.PlaceId
            ..'&limit=30&tier=public&minRate='..tostring(minRate)
            ..'&minRank='..tostring(AUTO_JOIN_MIN_RANK)
        local allItems,seenItems={},{}
        -- 100 pages x 30 reports = up to 3,000 reports per Auto Join refresh.
        local offset,maxPages=0,100
        local pageCount,lastPageSignature=0,nil
        local serverTime=nil
        while pageCount<maxPages do
            local requestQuery=baseQuery..'&offset='..tostring(offset)
            local data,err=network(config.endpoint..'/v1/eggs'..requestQuery,'GET',nil,headers())
            if not data or type(data.items)~='table' then
                if pageCount==0 then return false,err or 'Invalid Auto Join feed' end
                break
            end
            pageCount+=1
            serverTime=tonumber(data.serverTime) or serverTime
            local signatureParts={}
            for _,entry in ipairs(data.items) do
                if type(entry)=='table' then
                    local identity=type(entry.key)=='string' and entry.key
                        or (tostring(entry.placeId or '')..':'..tostring(entry.jobId or '')..':'..tostring(entry.uid or ''))
                    if identity~='::' then
                        signatureParts[#signatureParts+1]=identity
                        if not seenItems[identity] then
                            seenItems[identity]=true
                            allItems[#allItems+1]=entry
                        end
                    end
                end
            end
            local signature=table.concat(signatureParts,'|')
            if #data.items==0 or signature=='' or signature==lastPageSignature then break end
            lastPageSignature=signature
            local following=tonumber(data.nextOffset)
            -- Do not crawl more pages looking for a better server; use this first page now.
            break
        end
        autoJoinClockOffset=(serverTime or os.time()*1000)/1000-os.clock()
        for _,entry in ipairs(allItems) do
        end
        autoJoinFeed=allItems
        autoJoinFeedAt=os.clock()
        autoJoinFeedStamp+=1
        return true,'Auto Join feed updated: '..tostring(#allItems)..' reports / '..tostring(pageCount)..' pages'
    end
    -- Keep feed order: join the first eligible server instead of waiting for a higher-value one.
    task.spawn(function()
        while active do
            if (autoJoinEnabled or smartAutoJoinEnabled) and not autoJoinBusy and not joining then
                autoJoinBusy=true
                local ok,err=pcall(function()
                    if not config then
                        queryStatus='Auto Join: waiting for Finder connection'
                        return
                    end
                    local nowClock=os.clock()
                    if nowClock>=autoJoinNextRefreshAt then
                        local refreshed,message=refreshAutoJoinFeed()
                        if refreshed then
                            autoJoinNextRefreshAt=autoJoinFeedAt+AUTO_JOIN_REFRESH_SECONDS
                            queryStatus=message
                            autoJoinCandidates={}
                            autoJoinCandidateIndex=1
                        else
                            autoJoinNextRefreshAt=nowClock+1
                            recordJoinError(smartAutoJoinEnabled and 'SMART AUTO JOIN' or 'AUTO JOIN','FEED',message or 'Could not refresh the server list.')
                            queryStatus='Auto Join: '..tostring(message or 'feed refresh failed')
                            return
                        end
                    end
                    for job,untilAt in pairs(autoJoinCooldown) do
                        if untilAt<=nowClock then autoJoinCooldown[job]=nil end
                    end
                    if #autoJoinCandidates==0 then
                        local now=(os.clock()+autoJoinClockOffset)*1000
                        local candidates={}
                        for _,entry in ipairs(autoJoinFeed) do
                            local rate=tonumber(entry.rate)
                            local job=type(entry.jobId)=='string' and entry.jobId or ''
                            local place=tonumber(entry.placeId)
                            local expiry=tonumber(entry.expiresAt)
                            local rank=tonumber(entry.rank or entry.localTier or entry.tier)
                            local cooldownUntil=autoJoinCooldown[job] or 0
                            local validEntry=job~='' and job~=game.JobId and place and place>0
                                and expiry and expiry>now and rate and rate>=autoJoinMinValue
                                and entry.uid~=nil and AUTO_JOIN_ALLOWED_RANKS[rank]==true
                                and entry.full~=true and entry.unavailable~=true
                                and entry.takenConfirmed~=true and cooldownUntil<=nowClock
                                and D.publicEntryAllowed(entry,now)
                            if validEntry then candidates[#candidates+1]=entry end
                        end
                        autoJoinCandidates=candidates
                        autoJoinCandidateIndex=1
                        autoJoinRetryRequested=false
                    end
                    if smartAutoJoinEnabled and autoJoinCandidateIndex==1 then
                        local function isBetterSmartCandidate(a,b)
                            if not a then return false end
                            if not b then return true end
                            local ar,br=tonumber(a.rate) or 0,tonumber(b.rate) or 0
                            if ar~=br then return ar>br end
                            local ak,bk=tonumber(a.rank or a.localTier or a.tier) or 0,tonumber(b.rank or b.localTier or b.tier) or 0
                            if ak~=bk then return ak>bk end
                            return (tonumber(a.expiresAt) or 0)>(tonumber(b.expiresAt) or 0)
                        end
                        table.sort(autoJoinCandidates,function(a,b)
                            return isBetterSmartCandidate(a,b)
                        end)
                        local newestBest=autoJoinCandidates[1]
                        if newestBest and isBetterSmartCandidate(newestBest,smartBestCandidate) then
                            smartBestCandidate=newestBest
                            smartBestSince=os.clock()
                        end
                        if not smartBestCandidate then
                            queryStatus='Smart Auto Join: waiting for eligible servers'
                            return
                        end
                        local stableFor=os.clock()-smartBestSince
                        if stableFor<SMART_AUTO_JOIN_STABLE_SECONDS then
                            queryStatus='Smart Auto Join: best server found; checking for better servers ('..tostring(math.max(0,math.ceil(SMART_AUTO_JOIN_STABLE_SECONDS-stableFor)))..'s)'
                            return
                        end
                        autoJoinCandidates={smartBestCandidate}
                        autoJoinCandidateIndex=1
                        smartBestCandidate=nil
                        smartBestSince=0
                    end
                    if autoJoinCandidateIndex>#autoJoinCandidates then
                        queryStatus=(smartAutoJoinEnabled and 'Smart Auto Join' or 'Auto Join')..': no eligible servers; waiting for next feed refresh'
                        autoJoinCandidates={}
                        autoJoinCandidateIndex=1
                        return
                    end
                    local target=autoJoinCandidates[autoJoinCandidateIndex]
                    local now=(os.clock()+autoJoinClockOffset)*1000
                    if not target or tonumber(target.expiresAt or 0)<=now then
                        autoJoinCandidateIndex+=1
                        autoJoinRetryRequested=true
                        queryStatus='Auto Join: report expired; trying next server'
                        return
                    end
                    local attemptKey=tostring(target.jobId)..':'..tostring(target.uid)
                    local targetJob=tostring(target.jobId)
                    autoJoinAttempted[attemptKey]=true
                    autoJoinCooldown[targetJob]=os.clock()+AUTO_JOIN_SERVER_COOLDOWN
                    queryStatus=(smartAutoJoinEnabled and 'Smart Auto Join: trying best match (' or 'Auto Join: trying first available server (')..tostring(target.rate)..'/s)'
                    local claim,claimError=network(config.endpoint..'/v1/join','POST',
                        Http:JSONEncode({placeId=target.placeId,jobId=target.jobId,uid=target.uid,reporterId=reporterId,userId=D.player.UserId}),
                        headers())
                    if not claim or claim.allowed~=true then
                        local reason=claim and (claim.error or (claim.full and 'The target server is full.' or claim.taken and 'The egg has already been taken.' or claim.unavailable and 'The target server is unavailable.' or 'The reservation was denied.')) or claimError or 'Reservation request failed.'
                        recordJoinError(smartAutoJoinEnabled and 'SMART AUTO JOIN' or 'AUTO JOIN','RESERVATION',reason)
                        if claim and (claim.unavailable or claim.full or claim.taken) then
                            target.full=true;target.unavailable=claim.unavailable==true
                        end
                        autoJoinCandidateIndex+=1
                        autoJoinRetryRequested=true
                        queryStatus=(smartAutoJoinEnabled and 'Smart Auto Join: selected server unavailable; trying next match' or 'Auto Join: server unavailable; trying next server')
                        return
                    end
                    local joinExpiry=math.min(tonumber(target.expiresAt) or math.huge,tonumber(claim.expiresAt) or math.huge)
                    if now>=joinExpiry then
                        recordJoinError(smartAutoJoinEnabled and 'SMART AUTO JOIN' or 'AUTO JOIN','EXPIRED','The server report or reservation expired before teleport could begin.')
                        autoJoinCandidateIndex+=1;autoJoinRetryRequested=true
                        queryStatus='Auto Join: report expired; trying next server'
                        return
                    end
                    joining=true
                    currentJoinSource=smartAutoJoinEnabled and 'SMART AUTO JOIN' or 'AUTO JOIN'
                    joinAttemptSerial+=1
                    local thisAttempt=joinAttemptSerial
                    queryStatus=(smartAutoJoinEnabled and 'Smart Auto Join: joining ranked server #' or 'Auto Join: joining server #')..tostring(autoJoinCandidateIndex)
                    queueAutoExecute()
                    D.saveGuiBeforeTeleport()
                    D.stopFarm()
                    rememberJoinedEgg(target)
                    local teleported,teleportError=pcall(function()
                        Teleports:TeleportToPlaceInstance(80978566387592,target.jobId,D.player)
                    end)
                    if not teleported then
                        recordJoinError(currentJoinSource,'TELEPORT',teleportError)
                        joining=false;joinAttemptSerial+=1
                        autoJoinCandidateIndex+=1;autoJoinRetryRequested=true
                        queryStatus='Auto Join: teleport failed; trying next server'
                        warn('UNKNOWN Auto Join teleport:',teleportError)
                    else
                        task.delay(12,function()
                            if joining and joinAttemptSerial==thisAttempt then
                                recordJoinError(currentJoinSource,'TIMEOUT','Teleport was requested, but Roblox did not start the server transition within 12 seconds.')
                                joining=false;joinAttemptSerial+=1
                                autoJoinCandidateIndex+=1;autoJoinRetryRequested=true
                            end
                        end)
                    end
                end)
                if not ok then
                    recordJoinError(smartAutoJoinEnabled and 'SMART AUTO JOIN' or 'AUTO JOIN','INTERNAL',err)
                    joining=false;joinAttemptSerial+=1
                    autoJoinCandidateIndex+=1
                    autoJoinRetryRequested=true
                    autoJoinNextRefreshAt=math.min(autoJoinNextRefreshAt,os.clock()+1)
                    queryStatus='Auto Join error: '..tostring(err)
                    warn('UNKNOWN Auto Join:',err)
                end
                autoJoinBusy=false
            end
            task.wait(0.01)
        end
    end)

    local lastRender
    local rarityColors={
        divine=Color3.fromRGB(255,205,55),eternal=Color3.fromRGB(218,202,236),
        secret=Color3.fromRGB(255,255,255),cosmic=Color3.fromRGB(190,85,255),
        mythic=Color3.fromRGB(255,75,85),legendary=Color3.fromRGB(255,155,45),
        epic=Color3.fromRGB(255,110,200),rare=Color3.fromRGB(65,165,255),
        uncommon=Color3.fromRGB(105,220,120),common=Color3.fromRGB(220,225,235)
    }
    local function weightPresentation(entry)
        local isKg=type(entry.weight)=='number'
        local value=isKg and entry.weight or entry.scale
        local neutral=Color3.fromRGB(220,224,235)
        if type(value)~='number' or value~=value or value<0 or value==math.huge then return 'â',neutral end
        local compact=value>=1000
        local number
        if value>=1e15 then number=string.format('%.2g',value)
        elseif value>=1e12 then number=string.format('%.2f',value/1e12):gsub('0+$',''):gsub('%.$','')..'T'
        elseif value>=1e9 then number=string.format('%.2f',value/1e9):gsub('0+$',''):gsub('%.$','')..'B'
        elseif value>=1e6 then number=string.format('%.2f',value/1e6):gsub('0+$',''):gsub('%.$','')..'M'
        elseif compact then number=string.format('%.2f',value/1000):gsub('0+$',''):gsub('%.$','')..'K'
        else number=string.format('%.2f',value) end
        local color=neutral
        if not isKg and not compact then
            if value<0.60 then color=Color3.fromRGB(245,85,85)
            elseif value<0.80 then color=Color3.fromRGB(255,210,75)
            elseif value>2.50 then color=Color3.fromRGB(100,240,140) end
        end
        return (isKg and number..' KG' or 'Ã'..number),color
    end
    local function mutationNames(entry)
        if entry.isEvent or entry.source=='event' then return {} end
        local raw=tostring(entry.mutations or entry.mutationText or ''):gsub('%s*%[[^%]]*%]',''):match('^%s*(.-)%s*$')
        raw=raw:gsub('^[Mm]utation[sS]?%s*:%s*','')
        local lower=raw:lower()
        if entry.traitsKnown==false or lower:find('unknown',1,true) or lower:find('unverified',1,true) then return {'Unknown'} end
        if raw=='' or lower=='none' or lower=='normal' or lower=='none (explicit data)' then return {} end
        local result,seen={},{}
        for token in raw:gmatch('[^,;|+]+') do
            local name=token:match('^%s*(.-)%s*$')
            local key=name:lower()
            if key=='gold' or key=='golden' then name='Golden';key='golden'
            elseif key=='silver' then name='Silver'
            elseif key=='rainbow' then name='Rainbow' end
            if name~='' and not seen[key] then result[#result+1]=name;seen[key]=true end
        end
        local order={golden=1,silver=2,rainbow=3}
        table.sort(result,function(a,b)
            local left,right=order[a:lower()] or 4,order[b:lower()] or 4
            if left~=right then return left<right end
            return a:lower()<b:lower()
        end)
        return result
    end
    -- Glyph masks rendered from Minecraft.ttf by Craftron Gaming:
    -- https://www.dafont.com/minecraft.font
    local mutationSpriteData={
        studs_v05={width=512,height=512,data='iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAMAAADDpiTIAAABm1BMVEWBgIGBgoGEgoR2d3Zzc3NSVVJjZGNaWVpzcXNoaGh+fH6UkpSJh4mJiImEhISMjoyvr6+1trWtrq2lpqWIiIilo6Wcmpx+f36UlpSfoZ+lpaWfnp+io6KPkI+9vr3AwcC6vLqUk5SioqKPjo+Eg4SUlJSfn5+RkJGysbKXl5eJiomvsq+GhIZSUVLFxsWcnpy1s7WamJqnp6eal5qyr7KXlJeqq6qtra2Ji4mipaKPj49zdHO1tbW1srWXmJeGiIbAvsC6urrFwsWloqWtsa2Ul5Sam5pubW5FQ0WGioZHSEdjXWNVUVV2c3ZoZWhoZGhVVlWlp6VKSUpKTEqBf4FoaWh2dXZNTU1gYWBoa2hrbWucm5xaVVpHRkdVVFVraWt5eHmMjIxFRUV2eHZwcXBdXV1QTlBrbGtFSEVoZ2hubG57e3tFRkV2dHZjZWN5eXlQTVBQUlA6NTpQUFA6PTqipqK1urWPko95d3ljYWOGh4Z7eXtKSko6OzpQUVA6OTpaXVpzdXOtqq2Mioynpqe9ur2RkpGEhoR7fXsQXKHEAAAWjUlEQVR42uyaW1PbRhiGU9kicV1oJBUsnNZ2YXIodTtDSNurDibMdKaXnU4PCUkakh5xm5ZAiG21tWzZ4J+dbx2UVTYSi2IyK9j3vREe/HzPy85nz15wLi5vUcTX/Cn5fbrAf9L+s1AAfiwA/FgA+CfwTy6cYI70PdHC8Kv1YwHgxwHo7tf+AHT3n3hSDIf/jPq1PwDd/dofgO5+7Q/gVPmjbx5JIhtsUI7i4VftlxfY3Kc8peyLOWaBo3j4FfulBTY3+kPKHmX4SgYjT1pg/csjefgV+yUFNjc2+gPKE8pAyJDytScpUFxfP4rvePBnyi+W6HRct2yVy/MUhzJ7GMe2LctaawyFrxEx9XqxmMzXqoyHP2N+XiCXu3+/45bL5Q/n3eeZO4zj2FajYa0NB8kFGN9q1YtJfLVq1RgPf/b8vADFKMdtEO3fzYY1HEoKUJL42qfVMQ9/tvy8QO727Z8oRtmKSaWy1rhJA/YTC8j4Wq065uHPlJ/n4KF/697de+3eV/aLXKSwJ7uaVioV68aNz7ykC4zxvf8d4725fp8x0Rkhf+3aR6MoC79qv1ige7fdW11dfe8w0xT2DII+DbBtaQHivSAIGBOdEfJiAfiV+8UC3YQCwdCyHXkB4j3v1QIhLxaAX7E/RYG+5TjOBAXGvFgAfvV+XuDvdvv/bte/MPPuzLSQpaWlj63ry9cHdIkQQM7nzhd+6HZ/TORn52ajBSjwq/ArLPAFKwB/Nv3afwJ092t/ALr7xwOSClAuWvPu56xASp4XcFznm73LRvQSAr9if8oC8yddAP50fiwA/FgA+N/wAvRKxemkAk/2no4iMPgzxJ/6PwA8FgA8FgD8RAuw8/hx8oBLxUvvWx8k/kPDwUPfT8HDr9x/8gVuHYeHP5t+7T8Buvu1/wTo7n9xiSiU3NI7Qur1et9aWFywbXf0Onyn0znkLzfDwizwq/UnDXCLQlbqKzRgIaGAnF/uLI95sQD86v3igAeFQqn0thDawJXFxQUrvoCc71AYLxaAX71fHND9pFAoXIiJ5yV9Bcn5HoXxYgH4lft5jLw5tb1LeXDnzvmY+M1mcMW+aoiXjzjepIh8Oz/jMj7Cwa/ez2MYpun/vjvOf5F0Kbu7f+74vzWDq1eM2AIizxiRb1MDxocc/Mr9YoEp06cJsQVoAhVoGkZ8AZFnjMi38/kZxocc/Mr9YgHD3Pb97X8o/0byK2WHIi/A+W8pIk8F8tEC8Cv3i4OCnGmaj6Yi+YXCnn9Qtra2WlFGzvMZMTz8mfHzjQh6j8yXwuDwQtHeahnpeD4j5OHPpj8ccO7goNfLR/IzhT3/orRahpGO5zNCHv5s+vkAihGJ+DotL86AP2N+DvOfWWQikTnme+FX5c9yAfixAPBjAeBX4JeVS8vIC8Gv1o8FgB8HAD8OAP64i4IcTF9anB2+hl+tHwsAPw4AfhyA9v7ETCqU3TXgPz1+7Q9Ad7/2B6C7/1l7Z9cbV3WF4cgguaqpEB2Z2Ba9CLJvqKWQEIJtWq6o2tIvSvmqxE1VqZVIxR2pPyqNWy6an83ZTg7rZM3ss/b2TGYvz3rWjWPnvPt5Z2lLHAHyE34B0fnrJ0qEv34F4HMB4M+fGAXgL4mvXxL04foZ/bX2f2SA35bPBYDPAuCzAPj9N0+MGYMU54UH3wFfFziq8s/L2P57VQC+H74UOJpMqv3zMrb/fsCD74CvCxx9MJlcxz9v+e8lLzz4Tvgy4q9/aPjndfl5/vu9bubl+wx8Z3zx19f456VAWV4KwHfGF399nX9eCkhebqDOSwH4rvj1/nldQOff7mZevs/Ad8GXQ3r//Pm9Mv+8Pmjj9OzrCn89fEd8KZD89efn5zn/vFHgrMRfD98VXxeYqgLKP28WsP318P3x7QLin68vIPmrAvDd8UVenOTDOXFhkg+LuFBePsrFh7sPU77Pwm/MX32BnecKwF85nwsAnwsAv+frg/7/8tnZ6AF7d/aSeLBeXiz5wQeA34rPAuCzAPgsAL4qUSofNvKmuBB+Uz4XAD4LgD96wE9ebAH4Tvj6Xwj08uEfvbL1ytgB83/pkMiP9UuIzsN/8XwuAPxrXYDLqwN+/GILwLf4XAD4K+BX+ef39/cn4q8XqPqPEZtj/vvHxyfHKT/MwnfBt/3zBwcHXYE38wVs/31X4HimAHwXfNs/393AA/HXqwKF/vuTk9kC8Bvza/31RgEjfzJTAL4Dfr1/3vbXS0rmn53+XPnr4Xvg1/vndYF6/33KwXfCr/fP6wL1/vuUg++EX++f1wXq/fcpB785Xxex/fN9Jk0+L7mZvAz89nx9gO2fVwUyecnpPPzGfKOA5Z9XBXJ5yek8/MZ8o4DhnzcKSF5yKg/fBb9+MkApU5GHf/P44RcQnR9+AdH54Rew9vxFiqWxC8nfw2/D5wLA5wLA5wLAtw5bVjFLXJi+wm/L5wLAZwHwWQB8I/jCZIfw2/C5APC5APC5APBzY7xA2Bk1ubPg++eHX0B0fvgFROeHX0Aovn74Bb+YwL8uf10LwOcCwOcCwG/Et/3zRhkzD9833/DPWwXsPHzffNs/bxQw8/Bd803//G8vxgvY/nr43vhyiPjntb36Pe2fl1y9/x6+A74uUOuv1wVq8vAd8XUB219vFbDz8B3wdYFaf70uUJOH74sv0qLu15WLf17c8+mr9s8LXKb331v+eviO+LqA+OfFPJ2+in/eKFDgr4fviK8LiH5cFRD/vFHA9tfDb86vL6D98/UFJA/fB79eHn3/3n0tHtT530+nv8vmJzsTLT+G35bPBYDPAuCzAPhKPpw94MMPfzX3JUblDfmx5OCvnM8FgM8FgM8FgD/nAtj26l48KGE5rDgvA78F32sB+FwA+FwA+G34Ii+WAyrkw6I/t/PwffJv/AeAf3nJBYA/mucfAfAlP+clYrPUX6+zaWr99/B98KWA7a83CtT57+E74UsB219vFKjy38N3wpcCtr/eKFDlv4ffnC/hEv/8pfjnZ6c+D98BXwpo/7wa5Z9XU+evh++Grwto/7yM8s+rqfPXw3fD1wW0f15G+efV1Pnr4Tvh6yKl/no9Y/763mHf5xOn58F3wZcCpf56PWP++t5h3+eHBeC35+sCtr/eGO2v7x32fX5YAL4fvhSw/PXGaH+9Pm9YAL4D/vLndoG8WF5+4K8bX6a4APz154dfQHR++AXcCL7+RcX1gPpS8NvxuQDwuQDwWUBsvgTNIvaLhc7ZxeCvgu+5AHwuAHwuAPxGfHk4V8QUF9kfCL5zfvgFROeHX0B0fvgFROdXTenLCfz15odfQHR++AVE54dfwFrxU2BVRYYvNfDb8rkA8FkAfBYQnv/cXy7Nf2/n4TviS4HF/fdHEpjNw/fLvyqwsP/+aDIZBGbz8N3yrwos6r8/+mAyUTGVh++VfzWHh1tbvb9+r5sr83Qa8c9nxIXaf5/316csfFd80Y+fnh5uaf/83W7EP68L1PvrUxa+L74U6GZjb/YGin/eKmD761MWvkO+9s+/3U3GP68K1PnrUxa+O77458/vPe+vH/rnHzx4V71GSJmN07Ozjz/6+Bvtv5/jr4fvjy/++f+en58PzdND/7xZYPrRN9p/r/318H3ye/34nALin7cLTL/R+nPtr4fvk58vIP75yfULiL8evk/+lXx4VDy4/fp7Ih8WeEn+rbfe+mWSH6cC8H3ywy8gOr+kwPYyCsD3yQ+/gLB8JRzIFkjiwSQfFrD6AC+nAna+z6av8NvyuQDwWUB0fvgFROcb8mJDPCgHFcuPhwXgr5zPBYDPBYDPBYCv+HXyYR3uC6S8vISYHwC+D77Yq1dRAL5PfvgFROeHX0B0/tUB/5hONy3/fFZ4VOCv33vtzkafge+KLwUs/7xdIJ8fFoDviS8FfpP3z1sFbH/9sAB8P3wpYPjnzQJGflgAvi++7Z9/pPzzqsQwn3Sl+bxk4Lvh1/vrdYFhftpN3l8vGfhO+Iv466WA5HUBne8z8N3wbX+9XUDyf+lG+es35xWA35y/uL9eDrLzCgy/JX9xf70uYOf75+F74Nf7640Cdv72s+fhu+DX++vtAnY+PQ/fEV//wIAUiw+tLPy2fC4AfBYAnwWE52cf0IdkgNcWJcFfHZ8LAJ8LAJ8LAF9lddguq6biRUUP/FXxPReAzwWAzwWA34BvwKrHfomB758ffgHR+eEXEJ0ffgHh+MsE1hSD35bPBYDPAuCzgPD8eogNE0j+A8O/gfzwC4jOD7+A6PzwC1hbvvzQ9s9/2o3kNMTO98/D98PXBf4m7no1BQXG/fdSAL4Xvi7Q+esfd5P1zxsFSvz36Vn4Tvi6QPLXf9tNzj//3cV4gRL/fXoWvht+vX9eQbP5vW4yefg++SX+eV2gPg/fK7/IP28UkLzcQJWH75Zf5J9XBer99/Cd8dNB/e+rF3+9zNA/L+JCPVfy4q/L/PfChd+YrwuIv15m6J83CpxZ/ntdAH5zvi4wnS0g/nmzgOW/1wXgN+aXFRB//fUKSF4XgN+Wv5C+XA6Q/BfT6ZcZefHPUz7JiwcvMPDb8uvt1QsW2B4WgL96PhcAPhcAfuYCmPLiyc4kCQskISWK8nt39gYfAH4rvtcC8LkA8LkA8JtfgPf3t/Zz8uFvH/87U8CWF0tesvDb8rkA8FkAfBYAv0I+PCouVPJjKw+/FZ8FwGcB8FlAeL58U+afTwdk/z3C51/9UfI5//3Bo+5R+C74uoDtnzcLWPlUAL4Tvi5g++ftApa/PhWA74WvC9j+ebOAlU8F4Dvhy9T766V4fR6+T37OX6/989kCpf56+D75GX+99s/nC5T66+H75M/z14t/vhu7gOQ/6Sbnr4fvky/++YF3vtRfr/33+oxBHr5bvvLPp3Cpv1777/UZfR6+a37vnxfvfKm/Xvvv9Rl9Hr5vvvjnxTtf5K/P+e/19/Ad8lPYOLhIfFggMYK/av5NKACfCwCfCwC/Eb/+4UWExfB98sMvIDo//AKi88MvIDp/JYfoFxf4N48ffgHR+eEXEJ0ffgEh+UUvL/WSQvg3hB9+AdH54RcQnR9+AWvNlwfUz5b+IWTgt+VzAeCzAPgsAH7tAcbPS8+AfwP54RcQnR9+AdH54Rew9vz0l6X++kXy8H3ybxX5580Cdh6+T/6tYv+8UcDMw/fEl7H889pfr6fcXw/fGV8OyPnr09dS//3h4dZWqf8evgu+FMj55+92U+q/Pz093Cr138N3wZcCOX99+lrqvz/tptR/D98FXwoY/vql++/hu+BLgd5ff/F63j+fxIO5/1Cx8fnlZ8pfb+bhu+BLgeSfv+hU0zn/vFVA+evNPPzmfF1genbRNcj4580CSl9u5uE74NsFxD9fV8DOw2/Ll0MK/fNaPFgrL1Z5+C34LAD+dQtsL6MA/OvzuQDwl8avlxfv7jz88+ODjVT4uvLjYYF0DvzG/MoCu8suAL+OzwWAzwWAv2T+8uTHdl5Jj+C34HstAJ8LAJ8LAH9FfDmkVl6s8/3UyI/ht+VzAeCzAPgsIDz/h+kPsP3zO2MvMZtj+cfHJ8fP8vB98aWA7Z/PFzDyXYHjqwLwXfGlgO2vNwoY+ZOTpwXg++JLAdtfbxSw8idXBeB742v//L82507Sj9/96avZD5D310s++evh++Rn/fVpev/8q3fzBUr99/B98rP++jS9f/7Jq0+yBUr99/B98n/wzydX/X/U9P75J0/yBUr99/Ad8rV/Xjvo/9RN8s/frvDfy4i/PnHSwHfBl9H+ee2g/6qbWv+9jPjr+wLwXfBltH9eO+j/0E3yz4/dwFx+6K/vC8B3wZfJ+ecNf70andcjBeD74tuSIfVnK6e/5p6D75cffgHR+eEXEJ0ffgEh+PJSYAANuUHmHCsPf9V8FgCfBcBnAfBfiOTQlh7p5+C35XMB4LMA+CwgPF9mTignPLRfTuyi8FfD5wLA5wLA5wLAr/EILi4otp+H75MffgHR+eEXEJ0ffgFh+PpFYpmFCs6D35LPAuCHX0B0fvgFROerb5bov7fz8H3wJSz+eZll++/hu+NLWPzzMkv338P3xpew+OdlFvff6zx8Z3wJa3/9Xjfz/PO5rM7vPtzdne+/lyz8tnx1iPjrDf98pkCp/16y8BvzVQHx18sNVP55q4Dk08z330sWfnO+/EH759/uxvDXS7bKXy9Z+M35MkleLP55mZx/Xs/G6dnXVv7Bg3cvBnD4PvhSQPzzMkP/vFHgzMoPC8B3xJcC09kDxD9vFrDywwLwnfDtAuKftwpY+WEB+L74tnx4d/ehLqDzIi409efwW/PrC+wUFbDs1fB98sMvIDo//AKi80358C+2t7aTuDDrHbTkxXt39lIB+D754RcQnR9+AdH54RcQlp8OGWrL3t/f2p97wBs/e0MKzJ6h5MVZcSH8pnwuAHwWAJ8FwFcHiHz4Oh+gTn4sOfht+VwA+CwAPguIyx/+QoExf/3h4eH/nvrrDx4JVKY0v/fanY1BHn5bvhSw/PPvHL7THfCmUcDODwvAb86XApZ/vrtB73T++teMAmZ+WAB+c74uYPvrjQJmflgAfmO+nlL/vP4lhcX5R8/56+F74mt//bSbjH8+W6DUXw/fJ1/89aqA8s9nC5T66+H75N8a+uc/6Ub7560Chr9+s8/D98nP+OfFYZ/88ypg5lNO/PVXefhu+SP++XRQnb9eckN/PXzXfOWfVw775J8vz0tu6K+/Dd81P+uf739em9ffw/fNN1yC9Tn9c/g3hx9+AdH54RcQnR9+AWH4KqAetL/XYwmQ4bflcwHgswD4LAC+/RJh//1I8aKLBr8tnwsAnwXAZwGx+Vo4qENjYAtoCZPgt+FzAeBzAeBzAeCP/dAeG2Rk4LfkswD4LAA+C4BvHJ6m/kD7XPj++eEXEJ0ffgHR+eEXEI7/xJhPu1GFqvKDHHxnfNtfX1bgyPLXpxx8n3zbX28VOJpMLH99ysH3yTf99d9djBc4+mAysfz1KQffJ//W4eHWlvLXZ/zzMjn/fYpl8vB98l966fT0cMvwz2cKlPvr4XvlpwLdKH99xj8vk/Pfp9i8PHy3/Fp/vRSo8dfD98GXsIgHf13kn8/MxueXn6X8xevj/nv4bvi6gO2ftwqk/EWnqh7z38N3w9cFTP+8WSDlL7oGY/57+I35RgHDP28X0DdQ++/hN+fnC4yKB8U/L1n5aufv37ufCsD3wq8vsL2MAvCvz+cCwOcCwF+Yn5cXfzGdfjkmH07iQoHWy4/1B4Dfls8FgM8C4LOA2Pz0hyL58O7OrogHZ6c4L3D4LfksAD4LgM8CovPlgL9fXlryYqtASf4ZHH5LPguAzwLgzxT466oKwPfElwM2c/75/f39yVN//c5ogbH84+OT42E+FYHvgm/75w8ODroCb+oCNfmuwPFMAfgu+LZ/vrtBB8k/rwpU5U9OZgvAb8uv9s8bBYz8yUwB+M359f56Ha7210sevg9+vX8+HUB+vfKF/nk5gPx65U3/vD6A/Hrls/565Z/PS4kkL+56lb8tOfh++La/Xvzz+QI6nwrofP8sfD98218v/vnRApIXd73O9zcQvk+++OczYxeQ/Lyz+mfh++R3c9uUFZo/twe+W36aygLw148ffgHR+eEXEIZf88uI62GShe+TH34B0fnhFxCdH34B0flyuBrjsGJw7oUGfls+FwA+C4DPAsLzvwfzUIWI2YVaYwAAAABJRU5ErkJggg=='},
        kindly_full={width=82,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAFIAAAAgCAMAAAC2GN9jAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/v7+/////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////////////2UwisQAAABB0Uk5TAGv/rovDTtqcelwZJgwzQFSiFWwAAAGWSURBVHja1ZVbbsMgFAUvh6fNa/+7LQZXp2AqtVF+Ml/W2J6Ar1Dkg8ju0Bodb8pQBjjkQgEhSSc2aasQmgWHRgi4cVfR+uh6c+jRtAA0lBCaiQpYG6Tim3iF7AEgi0PHSyOhVuSKKIPVEG9jVgA5pfhs0ChiwaU7Kxo4cEpnNSShOEwoCS7iogpugogole77ndUQ5wUzKWMsEoW38hVQU2A11Lpgwogz8e4wWUX0I6D/lLRO5HBmXAuTqgXMHFgMCTYD0BJPC6T7SXROJmGaZr2zmkXzRWEnCpP61aRmsu9b/HuSBYODd9+VrG9JOibHrNTrSW6VSWHyxYk7HtEB8w3FPAM0+yQVzyCT9ZVkYZLixE38R9Lgt09keAkvIhUDm6UofW6NLANYlZPz5+AKJuzT8H0KzmchNp0xozamU/Gcjwd5nH3yNOuS0rpzEvmNQdLGdPAY+W8bOjBTNmb+7Tr9a4IEGRTMbMzAcdXEgIS8/8ZqZwaGIyCKz+0X7+veDEoAvJKZaDwAfeZJKo2GDWfamA/iCy04Eex2Qi54AAAAAElFTkSuQmCC'},
        filter_divine={width=111,height=44,data='iVBORw0KGgoAAAANSUhEUgAAAG8AAAAsCAMAAABc1xaQAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAZlJREFUeNrtlt1uwyAMhQ8/gcwk8fu/7VQ0MNRZZHVqb5bvqoHqfICBBP+YUJi3YOz/O44r3tZvZ+XGRsmhk7myYsLQb/AJ5J/av6BQ/S/4hPyZ+Qn0mfoJ9Nb9qX2c8UZW1rj3+zb4tDXf+gkfgNiE8jvCc2VBZeGKl/6WANQBlwghleORnd25D4F7uOQd4y4ifnBA+9w27zcgHtxIyjc9rZInikqTa9/OPAsTD6znPtefJC/JSWuLm5SvIWu/6Dbtw6Z94hD3te8A4A7VZvRh5wck5dtx7ePQRyakC98++b76poVc0tpHDlGqtXMlwxFXinl+Sx90kFqMPskLPY0rJJls2y/SmPtLwZ35wrQ+gRW28yAhBSjy39Gn4xBZEY3nfUhso3nNZ7rPxmxps/rIdl/Pvj6vFmbwQSZleB/Nvl63VkeLr11vVBNCzBR+8yU8+zIPZJMvXdRvhqB8gQeCyYfD6CNoH3gANl+w+TLOfIU7xehDMPjI49SXuJOsPji69Mn3vPZ57nizD3CJtp/sHHBzc3Nz8yrfthddso2aFx0AAAAASUVORK5CYII='},
        filter_cosmic={width=126,height=44,data='iVBORw0KGgoAAAANSUhEUgAAAH4AAAAsCAMAAACUu/xGAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/v7+/v7+/////v7+/v7+/v7+/v7+/v7+/v7+/////v7+////4dkYLQAAAA90Uk5TADNrGSacQItcesPaTgyuo6mgiAAAAeZJREFUeNrtlttSxCAMQAMpbbnm//9WZYsBM5BxRuuDPU87LHBaGpLAw++yOaKywR+RqYKggacL9E4sPsGPcVLFwhrjqAN+DEsVDyuyp4F73z4HGrnz20s73Rr5hYT+RhL9qT7SRUkIANnsHu5jp4skg+J0sT7XiTxofKF3wpHw82IVwIOInIEPUiAKNr9mU8W0HZMLdYFvIwfbF7fxQKhg4bHC+q1twhuGLPTZEmOGsy8iZCMNGL5HQs9Td/B0EXo97zjq8+Tlkb6ytTeTeiZ261KnZ9OoN7y5chtjhkyanmL3c9SXlV4EpMSCWeklW6839A29aweYAfZAldgmOwRAY22nN3DSxZHxWmBZzzta/LAmv60On17gkJU3bPH1iRURHzlwXK8XnkXobWOh2pu2UMVZg4M+10lcW8P1dVi/ico7vXgyW1DF9tUppk7f3ZWTk0mn5x+MSDuqHiAVEXrt2bs1VtfLpKsffgX3o/2t6+Xh6yVnFnrQ8C2vqXoZenrBnV08OJPJALmdmKZfXrxVu2FIYsVUTb9MO/Nma5J0v446Tb9OulP/tOSMWyRNvyw580Z7VnBH/QGaXim4Y0PKTNqNUW9B1avtBoPpKK9FPk2bLTxdnRRdHdL0y2br4eHh4eE/8Qa+qGDlqs0taAAAAABJRU5ErkJggg=='},
        filter_prefix={width=213,height=44,data='iVBORw0KGgoAAAANSUhEUgAAANUAAAAsCAMAAADFAw1gAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAn1JREFUeNrt2NGSoyAQBdCrIhJQ+v//dqtWKnfAaSBlZX1Y7lNEO9NnWi0qGBkZ+UacWDCMFQc4+ZsdcMcEhutghNndgiyLMFutgMsGu5RxcO9PZ8pjLttfUYVKyKqomN0AzCZM0AvaqklSzm7mdBRRqshiNrmoyGqo2AITRBi1oK0qh+PTkb2qroteriqyOlXyUs4tekFbNUUOSx0VHK0Z6qIiq1clKx+rn9n0grYKVs54dVRs0Baoq4qsblUsHiv2oxa0VYjpYNZHBUcuUYoqsXpV/FJf9q4XtFUcVnhfelFdO1BUZFVVBpONxVSiZJmrBXmrJnvFZN9m5d0Gr92pIouoUkVWSwVMR7oY4PuXsXpBj2qVPKamEkuUrhJZ2iq4rBcrKZETUQvaKt6a7EJXiU0oRUVWvyqbf/AJd1Nl8lEpKrKlpiLrwzswHclm5cx04w4shxWQhyqmSyXho7fFJCnLImfWG2+LcljzXRWjqMqs+dP9vualFugqZVge/1TFG/DFywNPKAV9qqU6Kjbu+c7YddVxfKJa8sfKcZMxKQW9KvjqqNg491QV1T4d/SpbnDD8HxuloFPF5bmhwit9c1UFshqquLCBS5xS8LEKLRXsiaqryKqrQvXJ3ZWCL6hgxaKlIktRec9Hh++rMkrBN1SY0VSRpahM+nCswGS4nsdoBV9Qoa0iS1UFYfj38zit4BkVWapqFSZVXhKygsdVZKkqxJ9NBvk1ecHTKrJ01Vo0yd0Tzy1ZwV0VF/cbqpOlqeDZ5FJsbaZ0uOUFT6vI0lXsEht/rMj2T6EoeFpFlq6C8VEkhhWh3LC9klIpuK8aGRkZGRkZGRn5T/MHRajDgu99WcoAAAAASUVORK5CYII='},
        filter_eternal={width=124,height=44,data='iVBORw0KGgoAAAANSUhEUgAAAHwAAAAsCAMAAACQTix7AAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/v7+/////v7+/v7+/v7+/v7+/////v7+/v7+/v7+/////v7+/v7+/v7+////PxJuawAAAA90Uk5TAGszTtrDekAZnFwMiyauhcx3uQAAAWtJREFUeNrt1N1ugzAMhmEnThYgib/7v9uJnypOGw3ItjJpvGdpZZ4iiunuP2ZQZ97jyZ/FJxG5DHcArsIDLsTlQnzAW3Eh3cdVuIWO1nh0AGSK+gpCZJMHHmcQsQAYLW0N/CEOANw22oFbh0es8ThTCt/OQKI1gWpq4bomzlCZMuQ9atwDtS7QmQ48oCqoIY3XhQaO4TQeHarcIdy18HQaZzzFR3DkBo4dfMnog8fSRDFhaVRDnrO+SIpkqwds7Px9HrGWz+LqHyTlTougBkaapdbi2HR7Es94SWE1ntWD9rSlr8K7G67GLV6yBWsM6EOcBOtywpL5QZx2cIauH0+NBS07eMB3ccKaPY87zPmBiL/AdaZ8FvSrhrTw2U4pH8Oz+tVyHA/lKMR4zh7DLbrufNA4uU48o3QCp1HjuRMn14cPGqfciYc+nLLGKaYunLgD33aTBiKn7ZymTArv33BvTJaY7u7u7u5+u09VVWeS1tprlAAAAABJRU5ErkJggg=='},
        filter_mythic={width=119,height=44,data='iVBORw0KGgoAAAANSUhEUgAAAHcAAAAsCAMAAABorteMAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/v7+/v7+/v7+/////v7+/v7+/v7+/////v7+/v7+/v7+/v7+/v7+////////MZLCiAAAAA90Uk5TAGuuiwwZXNpAw3qcJk4ztJa4QQAAAaRJREFUeNrt1tluwyAARNFh88Yy//+3lXCTEXUSSmM5L71PJAIfecEy/jutFEmbcHWetYAnGWYolWnwuwxrFk0Ta+bFqvyQfcfVv9urVUd4Ys+drLVvnu8Rduy6M8nWHb2/gsV23YUHd+x5NhQstuvajtvNULDYnht4lssstu9up7iCKyvXUMcvrJU6UJCbLclY0E7f8zmuddZW5AoWO+yuK/fc0fWGqtxdwWKHXeV+umnmS5eWZ7hcWteTHZfnuHPr2qtcJkBu4TmuFqE5gvEoWqrpkXsmACh5S83uc7yV7air/ZvuY03XNYDSKndj8YaLtY5XaHpibcMTF9s3+3dXPzRdg2cucmWvd5Ere3SDXsnDbv86Awho3Xwfwc8j7sBzpeQm7mWEyKO7PHU7+6jnYiaV3IX3bNc9vjf6rnnshhEXdtz1j13EEdePu8i8tZJaFUZcpHnUFezafZhGXHgz7KJEknE5fLhM9oXb+c4ZKetAl2ZZ87gy3WdcknNT8QCK417EJVmyrXzGtfiMGz7izgn4gOs8rsovxq4kucbJ478/9gW3Z2rKa5ClvgAAAABJRU5ErkJggg=='},
        filter_secret={width=113,height=44,data='iVBORw0KGgoAAAANSUhEUgAAAHEAAAAsCAMAAABlsKfLAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAbNJREFUeNrtlkGOwyAMRQ04hICJ73/bEVWCYQypKjWzGOWtKtKvV4NxAw//Chdo5wJR8OYPfMQtCHfjmW82rkQEguXbjeXEQIi3GxfujXy7kXqju91ouTfi4cmLKX5co4Pvsk2MVvdwKidOqwHB+JS5rG4IELhAABgz8zCF3CI1j4y484mvvsACnkZDXFApbew7J5n5JQ3Hke88MObML3RqZgx8EJe2oTteTwyzNgqD1MRoMlciHms7d+xlkd4ZdUob9WaRk91p8BKeG3VqYgQTuaEoj7LX+igBpPN4LACg35wYs3cwTsmpQY/dmjrt2U2x2UuA+oMqoWusYUobBayFJnCsONc2UMY0nF7aqDHnvhlkBaIegaGvepS6NEr742dG+NBo3dQYQZjvKolRp0ZGZI4r2vKJ6s1lVZDqHG1UqalRgZBlItQ/FHU7lHGQEuNyZbTg1RqqL6IyDlL96KOJMQPAPsjStXGSAntllPrdIGuujZMUQHpnDMMwygAeG6cpsL+MNnHLvsiwVVkT5sZ5ClxrLBi/UeYCbUub9pG4QHF1V28dwiy1Hkvw8PDw8PBlfgCXA1jVCBzQTwAAAABJRU5ErkJggg=='},
        filter_any={width=73,height=44,data='iVBORw0KGgoAAAANSUhEUgAAAEkAAAAsCAMAAAAelGUHAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAUdJREFUeNrtlsGOhSAMRYsgIiD3//92Mi9oaYZqBlzMYs6ShEO9aRH655ckMDQFGixNYNGw0QQbGtJkTC8FBcFCwywQeBrGQxBpmAhBoQ/hTM1nAMnJ1W8cPjg2lao4OCjeYzKX+mDimFYRVGA9q+5NKypncTubBOuTab9aMtUyFFN5Mp31b1evm74J9t5kUHFk+TPYFM25BUE1yZi42ffGlJoRz6pJ5JF5AHNd50sm1wBvTRk/aUziuHsTOrgRk0OH8GRamvZxMiZJVk2ejzJFmjJ6qCZ7TdSSIE3oYjUTFTDCZNFlU01BMV0DcsjRSarJaKbEV4YYZ8UkbthDmFDxcnZgNROrougnK38oXLzXTeQSgLQSm2bx8ybZiuatkkCDxLg5Q0Quzr4jstJO86ZMb5mWl0zF0jumaGgcs4Z8AMCRNkN/mC83BENujAyPQwAAAABJRU5ErkJggg=='},
        varesco_b08={width=157,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAJ0AAAAgCAMAAAA/rIpPAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAaxJREFUeNrtmEGugzAMRCeEOkATfP/bfv0qJaU2phZZdNFZVUNm/FQgisBPVzTxpnJPQXEXCmJx1YSJCZqIp215Rvv10FjjsONy4BI0dwrHdExq+0d0VlwdyKPmlnhIp/Un/ozOiut0PKrucEgn+xd20Glxg46D5haDjkm0O+hk3KRbVJcMOibR7qATcZOOVXe16Jh27Q46I47XXNxmj6/u0p68ZssNiVq7g86MY5+L9UrauVTdm0nH1Nr9dDIu6bBdUV2bjqm2e+hk3PXfSbomYO8QFvbR2XH7uZN31qbjzD46I269s8ZbYdHxNbom/35X8B10QXVv30E3qu4dFl1eNpeym07GfWcULsGmw7Of4KAz4o7zHc8Q28+7M9d2D50dt8/GTRHndKBHu0m34qEk6WRcDBRD12ltS8/oQEyw6TgBQFhru4y76DJSXTsAcTihw4AjupGrUkAs7UUTcR9dlOclzWlxnQ6siMR0Lx1KH7qJpcJ1OupDF1go4TodShc63OT23oMu9qEDvcGFLnSIfegQ8/629qFDSP+JPIdrdECcc/32AZzT/XRBfxCrpGiud4MdAAAAAElFTkSuQmCC'},
        varesco_b12={width=169,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAKkAAAAgCAMAAABetKgNAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAfJJREFUeNrtmNtygzAMRGUwmGAZ/f/fdloYr12bSiHkqdknzWYzexJzM/TRO7XIjxjOEGL6tlIMQy+3JEetryfguHnl3ePFXyb1LIXY94gAAl9NoCFWDRdJXZRferiWCCDwlQQaVpEbSMckjZJriAACX0ug4Q5St4n0UFsigMDXE0RO5BZSlq5iSwQQ+HqCKN1DOsuJpoYIIPD1BAW5h3TL354HomFmObQ1RACBryco823BExENfg4XSCc5NNMu/AW+5gAIfEMCi7a8duVfZVdoPpRHzZE1wrckIhpeIM2LnwiCV3MABL4hIXl6idTVa1+v/xmHjPCVRN2ACD9N6vMxCWVzOOOQmH0lgYbxJlIqBPwzDvSpCTT8O1Lr6qdUc6gJNCikd59R7FJNqieOKVTV/ParFFMJwmoCDds10sfVKz9TCcJ6Ag3rJdLt6t2UqQRhQwINcXiC1MfgiQb8TPsTCjgAwpYEGmSdRjOpVFrMT32YShC2JGiSVrzvWLZAzdAl9eYnaUwlCFsSRGuP9Oid2qFHSubdCaYShPUExl+kw9HTDh3Shcw7PkwlCOuJfYzn967OAFLQmHfRmEoQNiR2hWf/07EMOyLzmwlMJQjriTwv2zPHKV65pHU37G97wAEQNiSgcdkrhOMy/nHuf/QOfQG6mZZb0anW7AAAAABJRU5ErkJggg=='},
        varesco_b13={width=288,height=32,data='iVBORw0KGgoAAAANSUhEUgAAASAAAAAgCAMAAACFKlUGAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAA1xJREFUeNrtmdGSqyAQREEQiYDz/397a/WShhGUzFr7lH5CKkw3JwkQor766rfy5FRLjnxuBoLUIUsnYei0hPTTs8WX+zHYFdV/0SErtEbB8oFM0e2TVhD6s7Rb49EXvR0ARK4ZEimpkLkFZAMV6gMSWtcFDR3yZbcnEEJ/O18cANSKuRBSGiq03ADSL6IxQELrqqBOtCupGhAIcX+9En0KqBFzr+KRGAoXgJB4BJDQuiqY3w3DAIEQ8zeJJIAQEyGRMlCpLiDwGQMktEZBpFgUAwRCtb8mEgIix0MiJVWargBFGgcktUZBveUWBwRCtX+SAUJMhETKiSq5C0COPgAktUbBAHAMEAhV/guJAMEeIZGSz3pVUMQLd21vW/cTWtv51QcktEbBmQ7N6gQIhCp/ytoWu78B1i2DgBBzJaREB7T1Ac2oBHUByaxRMGHtbgACIfQ7lIdGACEmMqHMRnWgqQtoRZ0BQBJrFIR0C1CWKfsD1nQZIHI5JFJiHZgxlw4grJnMoCUrtvasThcQP2FTbokBUSSeEt+bPP9XD5DGNEYASa0xDF19QGRyf5XPw3ccEISUOIuF/AlNPUA2RxoDJLPmBe0dIAq5H/keBISjw/LeJPUNoDEDK7PmBedrQFBEvkcBaUzIINMTgGTWvKD/K0ARa6SL8MY6gP3n9cxXTGbNC8Y+oJTagKwMEDbpat6+qBPQfGCRFlrzgn1AUaeaJL8V+AxQXhMd5g0GtQTbfOMcJLTmgOY+IFUSiu98mxSQcnvIOiU1ZB85KAqtASiibgdQSSgi3yoFpBw5Nm9LDflHfmoIrQFoSjBrAyoJxSJfmISA1MTm3dkQHvmxKrTGsLz5+0kpM7UBgVAs89E6GwEgPm80mZqABNcdImsMmwjyTUA7ITzNbeR6JdoWdWqMAKKmTAuQ4MJMZo1h8RYQCMXT9QArM58b94AMNbW0AAmuXGXWGGZvASFUbOfDBzGdG/eAFsJLi8N/aAESXNpLrKth4RIQQuELF/on7HPjHlDAxlj9fGwBEvztI7Pmm1QfEAjhaXn0E8T37RkrAQMEmTAGSGrNNqlLQCCEJ+23x9YgQ+wWUSP1CRA05b92L/96llqzYS7uRroNCITKJ+PDATYGby52sa+++q3+AbUZC9EWhVOuAAAAAElFTkSuQmCC'},
        varesco_b05={width=346,height=33,data='iVBORw0KGgoAAAANSUhEUgAAAVoAAAAhCAMAAACvHZPyAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAA9ZJREFUeNrt2OuSoyAUBOCDIEFu5/3fdmtHJw1yC2vG3a1K/xqJreQLYzT0ySf/YwxrqkWzITL8FU9kgiAE40kY8UZSFsnIo1fAsCLP5xgyz7/2YLsRPoV+NCo9i2HWVdkTLcO2Q4t4RUkejLh2YUwr+Mg+m4X3RPo3aWGbUBS0sB3QwgFxnKRZGNOel6nlPXqOVnjv9R205cwsl7Sw7dMiW+M12S6MaUXEsk0W7RytZmZzBy1sIVvSwnZAi6y41KZ5tAtjWtK8x6aLdpI23EjLupAtaGH7Km3E9SWN7RTGtBR5z5Is2jlaxXfRwhayJS1sX6XFQW0O2CuMabFs3XPXOVp7I23JUNLCtk+rSOh4Wp+Rsyy9AobLyeZH03yahsJGOStE8J20sLXcoIXtiJZIhGNnwi1SEt0rjGlXzqNmaH3lnmTZPDNHq7KOIvHwX/t877zYyByMoD1iNT7sENvSpWUN2TYtsxzTkslANB+JWJutwpgWPJjFFVqx4VAipd2nDVoNgW86ZBNVWthaHtOynKPF5+XsIXyRVnEaNaJFTIVWBEbigo7lnDYkAiUt+y4te+7QInLyghB4z0PzHnHpgpD7OMozSxs4Tah1+JwAOkS3aJExLbuprzHBR6TkPeulr7F82S7XaB9cAI1pWVfo4nVapKRFQIivnec+W68wpk2BLF2jjVwCjWldjU7eRYvrwYbdHV6oF16klVi0c7QYMunHHhZSAMLnpkR6DEXCJtPRZlVEtHzbPOq03mKx+zZtCDO0Epfa07+faBQGtIjFor1Ea/ABqQPo2QkyP4ZMfmiq/a5nGrTJ83iH1ovwOq0+vaCw2lSj8CIthpeLtI7PMTklCi498Vo5iW3R0na8vS4twXZAGyUUiph6YZ6WeimPVtB6PseDsizkG9odzwt+bzZpSe+yfVrY9mkxMcNlfLXwb9GaAa2MjAxoSbOmES1sG7TW4nKK2Z9TK/xF2qXSUX3ahXmClhYa0sK2QauOP8JKJBTG86hW4U5avH0npmntcy8VBrRIlxa2TVrHCM6Wx7QKP0OLPIe8SO+5o16ISKjVbK/RpoPmPbSwbdKujOzNMi4r3EsbsKUo8il+gva9qxa2Tdp0ukSOq8kLt9LalFZfo0Wu08K2TbuepHAniNdkVrhKi0E/ppUJLaBnae3baWHbpE2ni/exHD08FaaFO2lpYy7OPU27vJ8Wtm1aTJce+Nkje+x1ReE+WrIpLa3xT2hJxrfTwrZNS8pG5uhWctnDPpZMbBR+nBZnw0mk8V/bwZtVgPbC09gnb8rmf2ejTz75r/MLcw4tywdjeYYAAAAASUVORK5CYII='},
        varesco_b07={width=295,height=42,data='iVBORw0KGgoAAAANSUhEUgAAAScAAAAqCAMAAADGbW0ZAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAA2tJREFUeNrtl1GyozoMRGVsjGODtf/dvnohl76YaQSEqfnhfCWA0vFBqIw8PNxL0igARE0iSd+MImlyAnBcgIIxeVnhFQxGgc4EGbUlSVo+zeD7GiP+BAiKf9TUeNLJWZ5WjEEEDAoKL7A9Of0w/5tOZ6psoPFXPUEUGHTjCaIMT1gUKKqAFtie2gbKOhNlC4u/7Gkbk3XrCaL2PYEXOed5ge3JVTSU0U4s/qoniIKmrSeIMjyBHvPhNwMvsD1J1JlstxOLv+4JSUhvPEHUYU8Vj/Fv8k6B7UmqznRmO5H4i55aUVmJJ4gyPTU/mlsbvMD2hIYqy6UEEn+FtF0T8QRRu56CuFibW1d1RbdbsF58aKcvfi1q8zcCvgASf80TRGUlniDK8iTips/F8qbbdg0vsD31uiZwT3Z8ki5X1Sm59dH/GRWrTOv6rMzTgjc94fJlMzZT0TW0wPbUPJCjcE92fIpYl+UJorLantSf8wT55fOhXvaEYyDseLLjJ13whicw6o4n4E8+d5PODFFn3IXnjjVUEQMjHkyGpwbbk5ZTc9wtfr3O9JfmOAgHp7IR3xLv9ATsfUG/nrvLNS9awD2RhspicCK+/AtPeOxeuLzgBCk45skfbic7PojLCDE8jRndN3JP03TGk1/Ph4SdsSMFhieQj7STFY/M8sm0PQnelXY8jW467ik2JwL6IJCCw57CsXay48vvn+ttTz/9GWXXk0CU4al6LGlDIgWnPQnHjocRfLE9SXxrMjxBFPWE+4SEhpEU3OfJjL/uSaJGsTxBFPGUM2YA0lpIwY2ejHjqCWPPKfEknZieIIrun/TN1Iu4gONrAiu41xONp54qbtpAPYntCaKop6IAK1qTWMG9nmg89VT0Tekk6jeeIIp66hWwDVohBTd7ovHUU1TwjSeIop6kIkTQLGtIwc2eaDz15G7yBFHcU98sG+8wOOdpwXVPYfOfeDzzJOkeTxDFPUnGsv3qBQP3ayAF93ri8cTTat9Tv/EEUdwT1i3DT2bzGlFIwb2eeDz1BFF+/MoTRHFPEnJVraVf5kNuXksrKbjXE4/nnsSlSbW+nPx4etinPp5M0LMveeBgTg3ysCWMqfci0sW6bCEetgQFz3g64SnIw66nZ4rvER5N5z3VXh4IfsifffjrGU0Pf4X/AEjjBw+3fBz2AAAAAElFTkSuQmCC'},
        varesco_b04={width=335,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAU8AAAAgCAMAAAClxgr7AAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAABAVJREFUeNrt2dt2pCAQBdACAZFb/f/fzpqeWtBYVJcZ46x5yHlS00fDDt7S8JOf/N+JGGCVgBEg4isFIFYDPWP7e3CkxA2mbDiyKwXa5KDgORFiX3plWpdiQvqzq1pS3B73xLDkPHliNZrnlOLgLTuOZLmgexqkGPgdS2sN5MT5MI97rkB3ZJ4dVPfkUybjW8SC7nmekInWAkgxFZ/1NKWUMHnyXych9yTQ6554CD/b5ILuaRotm2vTM+HDnmGeOhE5aMKVJ4Fe90Q/XT57drmge0Kg5aRPTxJ/1rOuPDEwTu5JoNc9G7t8koRc0D2h0Yq9Mj3j054OuecMmlDwHKC657zTxNTEgu45JmjuHxWTn/ZMzJONXfAkUM3TgQntNBMbTrEfCzOSm25i097Cmchxr4I0mA0AjPPxgG+NQckTA3GKngSqeo6bal1fxMKngu7pcY7TPRODsEdBxJamub29NmLNwQL0v/ZeSOzcKounkzgPM6HsSdl0T4iTQkBK66OTC7onFHYGi55p7WmOUTe9XrCndM9AGKwlew7QhLonbl/07HvNiVhvejo2PQXPcSf08kNpo8sPYZ08E2Hwlu6JBRVPAv3i+U5ruAdaMLfO93kgWbm+Uepu52eckUoQ3HMk8pbqSdE9MV+9H81j2jZa8LfuR/MEterj9iA1fdKy67lDxZO37nmyME8eP98/+mcOsaB48gmaQMnBB90Wj71F8+Stf+5Z5xGV/jhYxcJFz41NTzmeIDq/p4PZvvOt77B4ALAuRoDRcUZoAaDwvFRSr4cie9aqevIX9crPGSMUdE9KGj56Qsaeo4/Fjr3vEPnuqFBpFIvWJ8+3d+EPnsXU657h9AM35pUTCpc93TQ91Zi9jr9ZXpyKtM3w8RDnqvXREw4a00dPIFDds2196DxRKHzZEy7H9wlaFheuwgc0Pz6sWp89Ibw4FU8CVT3z2xF4ilB40BOOye6qZ/x7TwgYQPMkUNkzpdOpU3CRVeEJT2dETwsj8vnugLJoaZ5gQfUkUNnT0UL1AMbRdhYnFb7Zs2CN3gGA3alRgcaSDTCGJHvylu4JumcHlT0zjtDIWaJU+HbPc0q/krZg+z+d2PMS81y1AKhlbngSqOzpcYSaLFkoPO+ZABozZh8szHPZgoo97u88CVT2nI4MkHEZofC8pwcICxmneK5bkO56DlDZ0y940M+nzcYKNz1pY1E8q/QlXVQ8163trucAlTynI48DWurR6i4UHvZsltNQ6VA8pdZ9TwKVPceR+xtmO/2vLLPCI557mwiS4S/1veSK7Cm30l3PASp7gksNsWUP+fyifZCvVLjvOWeL+c+Aat7ttL28dGqJ3nz6voMitlxq9Mmf/OS/zi9nFxx4DT01UgAAAABJRU5ErkJggg=='},
        varesco_b03={width=347,height=34,data='iVBORw0KGgoAAAANSUhEUgAAAVsAAAAiCAMAAADGS4piAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////v7+/v7+/v7+/////v7+/v7+/v7+/v7+/v7+/////v7+kOFPvQAAABB0Uk5TAP+uwwzanHpAXBkmi04za7jclMIAAAQ+SURBVHja7dnbcsMoEATQGQTowu3//3YrkZK2sBpMReWtrXW/xdZg+WgCSJZPPvnkf5jiVIt8Iven6Fdm+m6SqyQtP6VqRMpkBcHrgihiSpBTgiJrqwAvZzFapxyfjF7B350s8z6c8WWT26J7uHy6pK1sFbgNW8RkEWRVxPOCvq3VI/vZbLrHSTO2OEXK7baW2QL3ZFHbApfa1hCIV0VoQd+2btSoe5K0kl01yvv69vnUoj7bArdti8zkvcAL+rbWoVdebNtUj/K++Ra4oL2wBW7HFlkw3T5m5QVdW0hF0raMFilv2SeAKVW0z7bAfdnWVdMtVGhB31ac7tlea9t8McqbUrTGjUpsgdu1rQaNtSAv6Nuicf3voY24f9GWOdS2wG3bZrHJoUOvvt/WLADYY9tdaCX9PQ0ca+iMMH+PGPK6iLzTFrhRiS1we7YidjoOFsFOCUmtgr7toufklu2E866T9y3vFIEtdvVu33BnnGKWNKlO5XuI7UvIH59pTg7hGNCnrbLVBFpuqxq6tji86h2H7qQFfdtqsjDSsN1A29iYuXSxMGTYRgwSgFXZZlOfU1EkgbZhq2HMFhfMR0y4f7HNddty28Sm5FlPiZjrnm0nPTLJptjTwBYDUls12rBFwtCcgP/LNWFvOjwnsMb18hhC6DgthgEcbKukiF4/2xaltgi3RfzQWmb1SAi45sNrGWvcTVoxkLscAFkBzm2dIgm2GPDvtspsERhi7fk9ZqYF3JY0bpRXbAtZ4R5jxfRs606HrXmrLaaEGYd7vEEKXrMNaNtxW5T7ILJhh2/QkDnNAecS7TaBfNU9sP0d0CwisuVSHm1NRK8bbjtNI7bh3CQF67AlBR1bJKJtR+cEfOn5tN75Y9BJEEyt2/NmKsC2XJ0N+CIuH7c1dnrdNlVvZDRMJgUv2+ZG2/bXMo8rjIs//Qzq5pRPpz7jILWY5DJsMeCl7XEaSZq2AtyOrQtgeEohBcO2QsP3YCA5X4DTY5244VxWQbMKehi2GJDYStpp27bAbdv60yfUMaTgRlt+78BtZYuuXlexA0fNuK0kTdKzBS6xjbH6/zB6EVJwny2/5+Vzwp68Hr6W2o7OCV/ZpGsLXLq/Pb7MImLpPiazgvts+bMatpb9xB6N27N9eS1DmrbApbZeESicU1jBfbb8GSPbg4WSwxc/HmD3bfkebNwWuNR2UYRtoD0puNWWPxs3+hxbH7r2bNv3DuO2wKW24h6pvF6GFNxoy3/TIfe89athwDbfYQtcbrtUVLj/xXuBFYzbkudgFLeQZzUVkJMBWyk32AKX20oEVahuTi3apCq425b/hk6eMVa2YchW5htsgcttYSUruuC0KfKk4E5bpDhFCnk2frKdgozZSjZ/twUut5Ucnarzy+90G+u7UFJwry2Si3HfZr5s9DedZd4PMvMi0rdt/abzySf/yfwDy4w24BgFvIQAAAAASUVORK5CYII='},
        varesco_b09={width=221,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAN0AAAAgCAMAAAChFo3vAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAoBJREFUeNrtmNuOpDAMRG1CBwgx/v+/XWmHjQE7VyGtZjT11F2ijE+4hAR+9Z21chLtCxpu8Ahi37TCyh4seV7T4fHy66/mMw7luNa07HR2Ol0QCDVQtBoOaLkr5unYm9010RXjSnPki+IsPIRlOtFsueSydFZ/C7fRFeMP4c4PbTLmhHU6wdPulKXT/QVupCvG73LESoQJgbCRjtFyKUen+wvcSleM34QHcw5vlZ8NdMF0fYZO9Re4l86O3xTZ1C4IhG10bLqHTSfs0l0vnR2/ynNGH+mKUNPJH5d6n69ukCdPbD2heOmum86OX3XwqegngMlHa8wJC3QAjr+03Fwvw5Sjk/4Cj9DZcdFHjjq1yJWQIoQlOkiVTbdMx166G6DT8STxF33i7VbE9V07TSdK8dRf4GE6Hdc3JlnevYhrfO70nVmj48jjdDouwsR/0WIXcfV3pv1WqdLxIJ0dF81p1A1zehTZh+Y7gv9OB2AhqyID3yr8+Rl0s+nuUKKLIbk+dtHp+OidSdRAN5suYZkOQnry++h0fPStElHwutZ3vOlvuKeznQ100un46IwQ4YoXa2tzkYM6Hfiv7kp0hx52HR+dzSMInjWbq+yxHnKqGh149pCnk/bwSKxWvP9LTIogddDFf1XWCcBNFTqYIEc386kFZR262/GBr2gpgtRD5/R6RzkSz9IBG/JgxkdWQFIEqYMO6B26lbXQputavWoEpA46/w4dstICGbqhnQcpgtROB/QKHXyqwy7x9l0jEwGpnc69Qwf+AYd1uvqOn42A1EwH7h06cPF+W5bounZrdRGkZjrAJTJz3HCY7pTb4rl3D1Ch69pp10WQIvzqG+sPiy/aZj0vmSkAAAAASUVORK5CYII='},
        varesco_b10={width=389,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAYUAAAAgCAMAAADKW5STAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAABLhJREFUeNrtmkuy7CgMRPkZfwCz/9121Gu6EywyKIUHb1Ia+VJ2IulwEWCbn/3sZ0876h/LaHF7Kp+mknY3u+8olj6PtmblitYMliqsNVFJCOVOZ+1qNDOL9Xg2+SPf/+rnI9rWYWcHicW3ps00u1tDXEt8QyHkXiKHWWqKXVEY7Bg6rp351sYkR6ELmV65GqcQnhR8HvQDoSBiQRRnU3KI6GsJTsGm+rDTTlJTrIZCLb6LvHa24wFIUgq4f+2qxLDXRqHHoqSAWFL76ymlkKAUfKnCin2mBo0LCjDXJwOWWiORlEKXabZwVWK46pOCq0oKiAVhWKh/LCkkGAV71zqNTaamWBWFIssCCgOThJDEsHY1SggjhUtPAbF4PPOx0v7cFRKMQq5TS7PUFKuhgJxMBwUkOQXEuXZVYLiqpFD1FDrh2iva2swrJAiFWIlts9QUq6FwYxoQ3nBJCMGsWboKcUAQFLyGgowl93FvtZlRSBAKd22WozPGxYxnRGrETDXX9Ndj1MfJBMMkcdU7c5ilq2AMCIJCaG1lsx8mYb88OlzHcvRz6lnx3JcShAKARlFJw3SAFrukgLRvSIgYE0RyFAoYb0tX8TP6ZBQc8XwRS0B/KAuHQmJKAc7ucmo5yTThlxTGCRSDuHQ5oJKjkEcAa1eBARBGCk5NAbGQ6xoUEoTCLeo32giF6nUUUBa2Lk1MEkKD7LF2FRYBgVTnZGlF47GgMKT+31RKaCnYLi9idc8oVK+bkVDGbmw+hSShYFWuNsuVUMBt18Yp8FgOWZCzQoJQwEQ3mzwZhZoU1RllLPWbTy75QJwVrsIYBVvwwxUIBRYLBpTHsvlUSCwomFlogVKojMJo5bG7weaTPEAoKFwlFGD+7nvzJIUsFovahGWyQuJvUNgGz2tArVVTKC8pwOxVO/PfpnAbRlRCWbBGKfF+RipFQSEZsbvBfzGRfDsjZeQ4ZlAYzJ03OnQihTwWzK632bsBrpN4X52zLV9TwNkE7k64JJIvq3M21//3gYKwcFV2FMdiGYeUS92AUki8W6mCW1lRgHv89McYIflypYqnzgaBUhjPyC0e5bGIDUcc9ogaCdip3rXhypavKHhygIZpRUi+37XhaCwaQgEYZPXjsUjuw7pHISGl9CcYGYs9QuE+7jH2QCqmkHx/goH1eTRzCs4vKfBY+GmMTiKkPRjj/lO61Kd5GWtuul/YW/DOGO/oUkhIvj/Ng0vOEAqh1msPrn9zuuHRRSz8ZFInEcSIVJ5sZ2x9KAU/9pCn6kZKvj/ZhkucAowucg8SCz+lV0hIJ4LmLU+7Qs4YBVOGbufynkry9yPc1TcUnEwhi4W/sVpLcAqL14iEAnJGKMS+W1+nthPJl2889RQKS6GMhb69VUqEx62at/9jkLZQCj39Y9zd4LfEJfVv/99Q2FgKZSz0SwalRBDu089LGAXkjFPwXbcJqRyO9qik/kuYNxQOmkIZC/uqRyEhFLJdfGpFKCBnlILx6PYxteNUkkjqvwrTUHAjxXvjKZSxkC/c9BI2Xn98K9e2+OyQU0DOKAVj9/y5Pq1/lDEcRBBJ7ReSCgotA2duC4FzIykksZCvPVUSP/vZz5r9A5oZgsazuzpzAAAAAElFTkSuQmCC'},
        varesco_b02={width=342,height=44,data='iVBORw0KGgoAAAANSUhEUgAAAVYAAAAsCAMAAAAJv2CiAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAABB5JREFUeNrt2dF2oyAUheGDIEEE9vu/7axZOt2B5ARsTHsx/ldpktPiV2p0Va6urv6DQgGCXJ1bAAAs+steGPMI/2aRREI2wvi8MLAUrFRZsFtnAFtOEtqChK9HW/xaCdnIk0yGDMX1PH32hbp/qtqwIpsBVpaqZdzAVn2gz2qwt61mwlbRUWpXqp7DalRWulYMDSuX12OlAVsBpg70WdvtGbHldZRnrlNGh9WklPw7u5WrYhEPrFzeKCsW5TWrD/RZTeE+0TcrwxNXSxEt//hrPnhupStVH1m5vGFWzDyO+276QJ9VPLbi0GYVPLpa9Fmzztq/EqCQr1QVVmRziLU0p1aCqAN9VinYmkY2q+DB1aLP6qCwjhZAV6oqrMjmACu/aWzx9IE+K7frOnDEaF0tBljjGawtgc6KbHqsTowvzb4sqJr0gYfDcC0Cv5tHswz39QVD42oxwGpwGis8VXVWZNNlFTF5f7PwMgjM6wMjrDPqXJeVrhb3rAD5ErCNJ4AFrmeKBcjBSPX2PbskAMirnxpWeKrqrIDts0qoMDz2CvekMtBh5SGxJD1Wulp8mzXy+B9YXWqXE8C8RPRZYY+yRmytcdd9k9XhPtdjpavF91mZbVkXMLKyhBFW2IMngYytm8eWeeskUB/5Ki8DWMYprLlhDdBZWZ8V66GPLIM9a7E1qwNjrA5sGmfFOazwFavDWaxQWRn5Zh4IthZ1QGdVtmuUn2ddK9b0o6w8Byx8+8oXlIExVsvNejorn6+vfJ2YiC2+nUtJs4hMLoR71hS5xZPOmvMRVlufWgNvt4wy0GFlkZt1iJX3eXk+zMr1rF+PE2WeLIRyvL9+wZpMHmf1zQuOv1qnDAyzuv5mrVEstrJx32Xl+Wzm2/9JG4VVlv3QXrKKyYOsxVLgoaAMHGaVUVaxZVOV77PyFb6dDxRW8Zvqa1a6vmZdq5/QlpSBz7FuC89GfpxVPLz0WOmqsMbY/FUkPEkZ+CSrmJyNPGGNvAocZR0/Cfxtki4rXRVWtz/Is4hxfL7OaQMfZBVjmtFCktsh1vGPLNZhpavCuoLxKOqCNvA51naUH+zrJB6PrMmorJ0LrOOsdFVZZzDtwnitBn6L1SuX4hlfOZ1Vvx04zkpXlVXKvdKKp9UDv8RqFNZ4hNWdwUpXnXVulHgjy9dsNfAuK59MR1glPGe1R1glnMBKV51VIpVsdZfJDXKrB36FtbpaLADHlyOsspzASledlUxyq/6BxfPW2gz8DitdLZ24nkFWcel9VrrqrOJiAco6y9revC87szLww6xiQgbKYoROXE+HVfmny5WwsjtdnRb38CJXp8Vz7E2u3s6lMFsRmXzBlpWrt3Ng16n1c6xOrs5kvT6wTsxdqh9nLbNcnZO9xf12ablOq1f/ZX8Af1EvkgIYcc0AAAAASUVORK5CYII='},
        varesco_b14={width=192,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAMAAAAAgCAMAAABzRoe3AAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/v7+/////v7+/v7+/v7+/v7+/////v7+/v7+/v7+/v7+/////v7+/v7+////c5l14QAAAA90Uk5TAGsMwxlOi0B62lycMyau5MLPsQAAAoRJREFUeNrtmN1y4yAMhYVkk/gH9P5vu9MsDCrH8oB3Z3rT7w5PTuIPScYt/fLznAoQhbaQuDL9hbXAsO45tEEdvMasX+QczrtEvY1MFISJCK7fCzQCl2Bd04dYlisBakhkOQ81ZCcBAio8L9CQdLHlS1lsBCQ17NTgqIoCmEABFZ4S6Fnoi72V4LYAuxoOIyYKAk4CBIrBUwGhD1v1gQLgCOAQsPZkL4ECzWBeoO3zWlbRFgDpq1cQFHASKFAMngtsXQlSuwVgAXdok5Z2EyigwiBQyLW3+2SKZldsCUpCT0JW/Ubsd3nbP6nlXHcngQLVYFagffcL2sArAEUsnr3JMJpAARWeFqD2s9hyWADbZ9KKZ+Z0H0mgQCX9owBlKIA7Aq9vLQ2Ru4QvoOl5C2EJEl3w0kLd2Ld9hq5k7yd7CV9A09MhxhJEuuJdz6PaNWLFEwg4CVdAjwEBQOD1r0ghorXZ64OTTYxA4DIBAsCkwAvOWa8A3AY81bAv4CX+t8ABIwcFgBFog/s2AicIeAkUEHkqIEz46UiXBPP9tlsvXzXzTQIFMsusQNsP59NIVsQ86zcQcBMoQCxPBBLNCOgFpzltIwg4iSsBYpkQ2MJWLk8InHpBsJ1+LEbATTgCxWD0HNjL9YUoLWMC/gNj00p8pSrgJjwBYpkQSNoIYwJZrygPGyC7CVeAWMYFSKYFtIJjFBXIfsIVIJZxgXVWIOkle/lhEPATvgCxDAuQTArs3auH2IOQDxTwE74AsQwLpEmBeouxe7OrfijgJ3wBYhkVoDQn0P8h/OrOEg5bJ+AmHIFqMCpAvGdVzW8eEUj9exLjPy9SOMoUHiHdJDyBapDplx/nD7iSr8sVV+OmAAAAAElFTkSuQmCC'},
        varesco_b00={width=224,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAOAAAAAgCAMAAAA8G4RnAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAqtJREFUeNrtmd2SrCAMhPlVRIT3f9tTsx6qowExzN3WfleWpd1phgg66o9fw15APRfKD0kpdqaDDSmfV6Sw6Ho9CPTMERdd7ysnvgrlcrKMJR78KYVgJwPaVCiuGxAEfbHf1IlBKS8k+v7AFsI6F3ApRRywHJZOoOMuJZBo+YO1EPapgKZIAgJD/fWpFVHJawnuf29BMBUwygPiV7PXog7MpVcSPX/ARkQesMgCgoXcHdQHjRZ8KdH2B4ZdLw5opwPmz+2JKntMpZcSTf/+8yFOBHR1unj9ievWaJ8VbKQTJtDu2ArueynR8u/3T54NiOk9VsCwenK7oy0YBBLwb5FrfFwlDWjEAdF4nePiBBLcv9WCHk04+5DZ9S0geAyYsEQ53CCQgD8HTZ2xoxAGRCXRjwLyKYpLyWESSXB/sNX02FHIA+oDdUQ3CMgeMspjZUjYuAkkmD/AuoodhTygsrmAZHvVMY7L2reiBb1EgvsDjaa20BYHVDoWgn1bnb+M8o4W1Eokwf15C2JbLwkIzJbhYN5Vt1/7JKuV/CwSCe5foU2941ASELgI2zfVHfo2zGYngyyR4P6VVDjigEDXCnVXAWxsrVouG0aJBPf/T2ngpgOip924Ost3G8dligkkuD82WZwgDWisJGAOudpM7hch0ffHDZw0sReNqzOfo1RO/INCfZQEo5Q14h0/l2j5N1tQ9KYSaECG6yskZenp4TvbWKLpf1Ka2O8Dmqfq1EFOD9+6xxJNf7ypctavAx7P1S3k9PC7yVii5X+CdfW6o/g6oH+sjo5/GH75Gku0/K/jFm87728DhlF1Fqd73y4FEi3/k1tTY1svC2j2Qsl+WB3KC52vzxKJpv/lEnNbRZZ3AYFetnSc3pt/U53Sa/q5Wjf/P5BJ3P3/+B38AwaP306lyouhAAAAAElFTkSuQmCC'},
        varesco_b01={width=196,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAMQAAAAgCAMAAAB6rSfNAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAqFJREFUeNrtl9uSrSAMRMNFRET4/7895RysJsYLmZpdNQ/TT1t3bHsRQKU//R7FGuhKoUYytcnQLnbM5GIudVfOMZjdlCv2Z7YUzHFdOzVRU2knwpgFIEDBGGpEmEhfSsctTgi59vK3EFBsGdrh0pxsbXJjFoC4opj3Kj70uEURvGqIujnatbajs9WoBSAkRTqGfz4s7hthqwYCstT5G97qddACEDJXQvCC+ptGJD0ERt/hml1bO5wVFoAABWLFvsHpdkVUNUTvcxTwjcMNWwCCR0sw7ltxDFomJqeH6Duae9MJS0JhgWJQJFzGWpGRsZc/WjuZHcnPCcMI3u6MS5jSuD3tWjBOCgtGHMAACMxT3IDJww56SoBxmbrLfX+rqLLgbQtg6CC8mCxMVg2BhSB+N3mVBYeoAQwooPzQCNit5gQB3SeA+9oPl8pCFOfKIWQrHEEngzS9Q8i5EOVazioLWcwhZCsSCZmt+9s/QshViR3J4T6LwuIdQrbCkpQrFcruLoHQxp4NM5bEpLAYhqCVNULIJDbhRhNMbPdbMVaGdBZoEoKEfIawvBFSdilwtmMJVqL+4VBoZsOrsABE91YhICiLRgj5BOuRBJshYo9pu3ZLQmcBCFoag4TAmSeZI4W53eShRbQ5sIeuwoIXh+bwPQisUf+ewBFU2riyOauwELtvIC2EdRqIEotwSlcvdSoLXmxJDeFrTbO3+69WVaend4a5WVkiZ8WXIRaewkIW6yGE/P17dCYnNnF79Y2gsPgMhH1IgFdV+F19cyosPgKxPScIAmJltfQOET4PMT0noO0MMcsHmMLiIxDxLYE7Q7jaaR6BcD8MYflkKNNLAkSAn9j+dRZ6CCkTlrz9N1mmkQRk5vxVbUguCiKlxZ9+jf4BLBO+YP55rzgAAAAASUVORK5CYII='},
        varesco_b06={width=333,height=34,data='iVBORw0KGgoAAAANSUhEUgAAAU0AAAAiCAMAAADs+3vNAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAABAtJREFUeNrt2ttyrCAQBdBGEBGE/v+/PZUczEbuTsaqPMx+imiPuOzxMhX65JNP/lxMYDbD9Z9MxfBX9tfWd6o01aLZnB/JB5HxghCMJ2HkMJIukYxsvQIMKzo4j4l7RtdguRE+E7CPZJwGdbc1WVcxM032YkYTPoqSbIy4dsFYU3CMoK8sJ1VPBQk6HxeDOnFXs8a5caEJzqFm2S6OkzQLxpp5M9q4pPuayLE83ZvlZCyXmuCc1OS9sU62C8aaIqBrGq3Zn5V89roJTmBWNME5q8krLptptnbBWJN0/Ns2W3MwK/nUPR0wOsMsNcE5rRlw4UhjOwVjTQpxYWm15mhW4tEnBXACs9QE56wmPtRmZp2CsSaa052b3tJk87BmeeSlJjj7moqEDlkXBr5k6RZciVR+O8Cnac6mobBQzkrtfEY8rAlOyw1NcI40iYSPGxOeY5LoXsFYc+VrVF8TO7HJhfs4j8CmMyUfTyrW06mx2MDsDU7Fsh/MHKyqabIGZlUzRo41yVwMNMcEdGCjYKwZJZCD5jRxdD7V1On3ZYkSFU2d3cXEjhkIaCIamB1Nlvc0cYqcjagva2IMUfOaIi5BMwUk0JaaPnsoEJ6RsEATOXhGk+XNb3pc4k3jwnX7m95qTkdZOpq0x6VUKyTfFxvPdqGZxuOYMARNZE6T3a27kOAYKfFcefsu1GrO5Y6mKjUhCNmOZuzjrRh6XZNbmgjUcNf42WZvFow00Zzw/6XmirOyYBY9TXeyI+FhTfT/js0dVtQLJjUlWvMVzTXVErjRx44TVU2Fh4LzDPiFVHIxBZhF0x5tTe/vaMrrZdPgCyIaBbOaZNGav+pNzM/RebI9ZZqYm4v1BqdS4WQALHnn7Wgews9r6myFQk+pRsG0pkJr/u4uhMGfjfeaprv0tmu8YAFsj0fU1SThJzWDxIEXMfWC+5rUz/gJCZ8lSWLbZD1mjIWD8xyZJulvzIEmOPuarvZ+gMpqwQOa46d3EJ0zpbdokmZNI01wNjStxaUR88pTK3hCc/xmib8xNqu5EFJo0kJDTXA2NFX8w69EQmH8GtUqeESz/NUDWjCA21AzVjjR06SxJjibmo4RHPc1plXwgGa570xTxnHcvEeaK/9P0MuXh1rN/pImOJuaKyOxsohrFTyv6UWqVW5EE5oUOMvxkiY4m5rprogcV9MqeF5TUqHpGHFTmvo9muBsa64ZDt4ysU6OCuY1+78hlZil5sbINqVJ9i2a4GxrkgWOzF4BBSZdFjyveSxU0ZS59liT7Fs0wdnWxK5ow88Cl/dMVxY8r+k1UUUzvdQEmtSkNbxDE5xtTVI2MAe3kstfqPc460bBI5r4z5mGJhrNTmsSSXN8i/rDrII++eTP5h+q2iFWqTkG/QAAAABJRU5ErkJggg=='},
        varesco_b11={width=223,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAN8AAAAgCAMAAACl413SAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAwRJREFUeNrtmNmypSAMRRlFmfL/f9vlLXQzWigv3V13P0EOyclCTVD2q/9CcveRTnm/b5yxnUrtaZ0jKJnytcGezqWEcYGIKPpjuxd7lpQcVf7LHhAEdlj4Zv2VrJqi85RLjfkok0QCufaCUDnKNMlHAIS9jQjzszaiST5JmUyfj4LETh9EX/gAWHtwS/SST9A0n6FMruKDxIUX6BsfACsPGeg1n53nc5RryBeA940PgKUHJ3rPR/N8VEiM+Ghjpzx95QNg6RE+8Ml5PlFRDPkiHutPfAAsPAx94FOUwml+0ipjJYI+FiJbb7C0+aWNdw7bOeVKH7N8ACw8sH9G/ey32sw0n4BpxGepUKzXYgc0YxqXGZrmAyDsG+6mFxKzfLgiAS71WmRggfeBL0nmdofG9EbJy/EqDahuJBqpj/kizE1gaMQHQNgJEV8I4ax+5MMdd+V+PNyfHHuwwkfysiMiwkzQlm3Kqge+427sDn1uVF/Uld8iH7lkR8Q5PkhGgrwc8KH7mLtQ80HKAWWLLfFB4GOv+NpDnRzwcSQjUSa76ei/gw8SR0Qo0efT2TSNjjplnEzX788Q+nzqDR+kLNLr8u1ZRIch1hZta72+eB4KPla/t8zxQdylCLzb/zy1qlNGVUV/+Nr/PMsB/R0xfuTDnqsuH3WkKj7ckN/7O0Y5oEdE+4pPyDk+RR3tSDnuMZlOLZ3PsAaAPovoxAwf8rZGiXPkk79u+UZVLU/ZJGbBmBTr52ufmjNmEX1ay3m+Rqr3fuSpp5xP5g5r70dYwwNmur/D3BJFw5rBkE/0+KhWewAOhQPzq3wJEDPb40v/o9vBgC+wDp+krkzzAgM+Hpb5AOgxrPhEyrodDPh0j88APj+suSKdAAeks8IHQI8WNjjXtAPwlSw9PlcWZ3b0UpZw+P59ECMAYmbeXj/hKFfUrMtXV3vdvqABEF1CuhU+AGLG9zj9/CWP7fDpIT6SreGTzbfNi7cqd8b/xOHor/fX9GN7zQfAfCZ3l/J1u3yon7/61/UHZHTVeZNWn6cAAAAASUVORK5CYII='},
        kindly_b01={width=83,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAFMAAAAgCAMAAABZ2rRdAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAfFJREFUeNrVlktyxCAMRMXXgAV9/9umAIMIOFPJMm/lgkdbwgM19J9QN7J5HhmRJvq6C4DCl5qub0OcHH30IgBoqjCAMEyuXgBkmgJwG49K8R88jcsBqT4aVBT15+yuQpRQSU8XBTEWdJJ68UaZdAOYFeOiSsmKLJDR4N6FUwXC/eY1MmokTF0k4waO4vflHlZlrPjTe1oPZVSHTh2+QBcEV1+etkjkF6/i0MsLNb5jiSgxFVRkm2BjX6cSHk6vEZj46dgCc0OZtTRkq2jhRnGEB7t7nVsyPTqxrsqpWpomfqmF0dHirTATnswA+XijjoHMhiVz8wYZ5ufMREKULvRodvMGAGNnZqIwA/C01JZpfn57eB28cAybJRMZD/fp/SEzSKaQ1en9IVNL5hp5er/OvFtLfJZ0eh8yJcFpqhyZkRqrJxQJWo4x3fOWODLlptu8Q2XJZPmF91Pp3/azGHrxGkmCeDl9brTYLw4ts5Lt37xKWDNl+9XW6ewSIUjoi1exEsRYGskYbCc3LDHm9BroeFnVdv/aXTdf7mX49NYN1XPVTSTNbxeHNNQ5vUZ3mfYLLu4HpMyGNAan1/EzKPT0jiqYXG1Wlhkpa/MGNiUr/wkUPZjtHKoi3ZkiR37zPqNSAcDXaMgwShhzEUhq9/4TX1qPVTffcQyrAAAAAElFTkSuQmCC'},
        kindly_b00={width=80,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAFAAAAAgCAMAAACy7Q9eAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAfZJREFUeNrVltuO7iAIhaFqPRRZ7/+2OzVU/N2dTCaZm1lXuAof1GhT+mPKChT29XkB0Ha6ww2QYIsCdHsWBCi0qyGTos/iDrQbCY2ecostvrijj4UC/xNPaBLzjXdSxtBpHoQB5DuOQD4B9FHqjVzSK4ZsiY7YgJUYUW7nGgPq0WGDWWHegIWW4hOZGlyH7dotuWN/ziQYatsWFlp8FQowTUgFd4sjDprTi+csKg9QR366a7cRRUhtU7JSsif9C2AUwtzcqlTwoXoDK8OAVXxH+AugPp0iUW88UjgAPreUiFsjpA5TEgvoQ4xYJxAl3VEgOuFzSylPYS+ER629Aj0hU4SM/qsdP4C4MqbKN8BCcdmU7kdR+jWBq/RHQHlcD3cg3oHi1yL9CrDDFF8nzD8GTj88QKzASFR/BGT3J/BYSoPf5W+ARa5IRAmm7vmJKHj2ChSscp/sPcrBfb1kOr8TzdzLeu5A3YEHdiVyTIjrFzF6YZn+DkzY9e6yN2+03MgogB+spdVmY1MbrmeECfTe+R3Ir/YxXPWW+gBHZCH5vmxtiN/GJvGFf2HO7dTo9mqm/HIgqNok/s7qhMuS0s4zNXc705ANE7Zpo58Dz1q9nViZTGxD+XnjSeg0ddQOQK+T6UPxuvPqsVrqvyJBoBYnhTD9Cf0DMr9OUe7hyd4AAAAASUVORK5CYII='},
        kindly_b02={width=109,height=32,data='iVBORw0KGgoAAAANSUhEUgAAAG0AAAAgCAMAAAAv4AbWAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAADBQTFRFAAAA/////v7+/v7+/////////v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+////dQ4vlgAAAA90Uk5TAAwZJjNATlxreoucrsPatbiyGAAAAqhJREFUeNrdlNGy6yAIRVFjNAbZ//+3d9Qo2HYmc1/PetMiC6iG/jwxM6NTOceX4AvgQJ/4dAsA4eSok4F6UicwkJdLUH3EQqzvZEAyKbfkEiR8uBgtDB3fdgpuV1G7WoClO5CJGZaDHkIFGEB1awcuIFQmS0CNSZqiUXpSpBNAbQWjM1JkoQs792wMkOBknBrkq6/RJfzMQapr+Ss63FoTP1aZZvY0Ugrhty0C4Cf2ogEfGY1Vc2itRbr200hUZkuM2XKDT8ZOnPPxHpNAHRzy2M6VO4HSfvqAJwzOaWMaZIFFEnVqdaFiwtOGRh2y4S1MPYP2kIQiBlVthjmwRUYIMPjRL4+UAWpj9jrGo78SpoIH99u2b3kUh4Ep5MAgiWkFtTSPpwVnqniIjAEpbvY9KQh32/C+avSaX7Utz2ej1EyYlLLbbNHaGsKTzJl7krEjbXM2qeBOWORvW9KUnWwme6GTv223o2WDMAM4+45Fvm0F+zxEDXSq+YKBn2BsaLcfkMKwL54CjC1qOGNRAj1gI9O7zcaaHmogiqJVq606+m3z7zanF7pT8YPT2iA/e7sDvduOz0+GxfTNu72hm9FT490W1abyT25js4O4Va7+L5gWWfdU/gl/pWFnDh+9ztNbm7za7BLVu7KOftlQndZ20XEBgDfnz/+zBXODsIaGqvEaoPNdkoMxye822S6o/hAwSRqgKcKyRRM40WLyfksu+/hYbZRsPenTRjJtJEv84wWk/flFe2cujTP/oNNwrbBgYPogA/avMmvhWqkn8uiwMXjtXjeCnpf1fJRi0mt0fFay3lNFI+8JyQkWyZSbdWwnGdzHcMMN1EiTmJM3L9Hrf31qdUtAcwhuxVXa8AWQSK8kWWEHQ2bJrggATn6Vy+tLGgXs6I/zD9ylaqwD4LFtAAAAAElFTkSuQmCC'},
        title_v05={width=262,height=28,data='iVBORw0KGgoAAAANSUhEUgAAAQYAAAAcAQMAAAC5wYM2AAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAAAZQTFRFAAAA////pdmf3QAAAAF0Uk5TAEDm2GYAAACYSURBVHjavdNRCgMxCATQAQ/ghQSvLvQAvcpAfoUpGxro/mWXpROCKA/8Ek8k1ZixAkH8xAnppoirYvU5CjgLOohN4UpNMbdky1VT5DVhZa8iqJuCHhhLWEUAcbzx3hdSgGkdhDDUAfVXuHYFT6KWaN8XnH9UcBaEI2CvakeBm8JPIpbgBeEKDNkhJGRbqeeckcJfxCMn9wGK/R3QhRYZ9AAAAABJRU5ErkJggg=='},
        rainbow={width=138,height=28,data='iVBORw0KGgoAAAANSUhEUgAAAIoAAAAcAQMAAACEdrV5AAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAAAZQTFRFAAAA////pdmf3QAAAAF0Uk5TAEDm2GYAAABcSURBVHjardGxCcAwEANAgQfQQoJfXSM9uA18CE77xCRRI7hCjbCXqASQgL6TwKueieVZKYDZUVTeFGYK7AjQNBVOdqRh1DHNsLaJDUFc8/iBhtd8mTmqXtPm2ScznJBt+AygFwAAAABJRU5ErkJggg=='},
        silver={width=90,height=28,data='iVBORw0KGgoAAAANSUhEUgAAAFoAAAAcAQMAAADbZzowAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAAAZQTFRFAAAA////pdmf3QAAAAF0Uk5TAEDm2GYAAABPSURBVHjalcrBCcAwDATBAxWghg7UeiAFuBWBv4ELhrwcK8T7G1jUmXrbBQGvYGNz8ZpgehBagGB62ASgD0hEgVzCziNRwl8IWQPh+o2Pblj2U6HuiTvnAAAAAElFTkSuQmCC'},
        golden={width=106,height=28,data='iVBORw0KGgoAAAANSUhEUgAAAGoAAAAcAQMAAACzlLgIAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOwwAADsMBx2+oZAAAAAZQTFRFAAAA////pdmf3QAAAAF0Uk5TAEDm2GYAAABLSURBVHjandGxCcAwDETRgxtACwmyujbwKga1hkuRVhzEv3v1h48SEGBdMAFPnqBKrT1QnsmVXOiKgfFRnnSEZw+kNk88Kv2lf4AX6hF1zXpaH2gAAAAASUVORK5CYII='}
    }
    local mutationSprites={}
    do
        local asset=getcustomasset or getsynasset
        if type(asset)=='function' and type(writefile)=='function' then
            local alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            local values={}
            for i=1,#alphabet do values[alphabet:sub(i,i)]=i-1 end
            local function decode(value)
                local out,buffer,bits={},0,0
                for i=1,#value do
                    local digit=values[value:sub(i,i)]
                    if digit then
                        buffer=buffer*64+digit;bits+=6
                        if bits>=8 then
                            bits-=8;out[#out+1]=string.char(math.floor(buffer/2^bits)%256);buffer=buffer%2^bits
                        end
                    end
                end
                return table.concat(out)
            end
            D.decodeAsset=decode
            for key,spec in pairs(mutationSpriteData) do
                local ok,uri=pcall(function()
                    local filename='tenshi_minecraft_'..key..'_v1.png'
                    writefile(filename,decode(spec.data))
                    return asset(filename)
                end)
                if ok and type(uri)=='string' then mutationSprites[key]={image=uri,width=spec.width,height=spec.height} end
            end
        end
    end
    local function styleRaisedButton(button)
        do return end -- Replace the previous block-style controls.
        if button:FindFirstChild('StuddedSurface') then return end
        local corner=button:FindFirstChildOfClass('UICorner')
        if corner then corner.CornerRadius=UDim.new(0,3) end
        button.ClipsDescendants=true
        local spec=mutationSprites.studs_v05
        local texture=D.make('ImageLabel',{Name='StuddedSurface',Image=spec and spec.image or '',Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
            ImageTransparency=0.65,ImageColor3=button.BackgroundColor3,ScaleType=Enum.ScaleType.Tile,TileSize=UDim2.fromOffset(256,256),Active=false,ZIndex=button.ZIndex},button)
        local function tint() texture.ImageColor3=button.BackgroundColor3 end
        button:GetPropertyChangedSignal('BackgroundColor3'):Connect(tint)
        D.make('UIStroke',{Color=Color3.fromRGB(5,12,24),Thickness=2,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},button)
        D.make('UIGradient',{Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(165,175,195)),Rotation=90},button)
        D.make('Frame',{Position=UDim2.fromOffset(3,2),Size=UDim2.new(1,-6,0,1),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.55,BorderSizePixel=0,Active=false,ZIndex=button.ZIndex+1},button)
        D.make('Frame',{Position=UDim2.new(0,3,1,-3),Size=UDim2.new(1,-6,0,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.25,BorderSizePixel=0,Active=false,ZIndex=button.ZIndex+1},button)
        local caption=D.make('TextLabel',{Name='RaisedCaption',Text=button.Text,RichText=button.RichText,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
            TextColor3=button.TextColor3,TextSize=button.TextSize,Font=button.Font,TextScaled=button.TextScaled,TextWrapped=false,
            TextTransparency=0,TextStrokeColor3=Color3.fromRGB(5,10,20),TextStrokeTransparency=0.35,Active=false,ZIndex=button.ZIndex+5},button)
        local function sync()
            local glyph=button:FindFirstChild('CustomButtonFont')
            caption.Text=button.Text;caption.TextColor3=button.TextColor3
            caption.TextTransparency=glyph and glyph.ImageTransparency==0 and 1 or 0
            if button.TextTransparency~=1 then button.TextTransparency=1 end
        end
        local glyph=button:FindFirstChild('CustomButtonFont')
        if glyph then glyph:GetPropertyChangedSignal('ImageTransparency'):Connect(sync) end
        sync()
        button:GetPropertyChangedSignal('Text'):Connect(sync)
        button:GetPropertyChangedSignal('TextTransparency'):Connect(sync)
        button:GetPropertyChangedSignal('TextColor3'):Connect(sync)
        for _,child in ipairs(button:GetDescendants()) do
            if child:IsA('GuiObject') and child~=texture and child~=caption and child.Name~='StuddedSurface' then child.ZIndex=math.max(child.ZIndex,button.ZIndex+3) end
        end
    end

    -- Keep the title and Discord header strip solid black; no gray texture or gradient.
    local buttonFontLookup={
        ["FULL"]='kindly_full',
        ["JOINING..."]='varesco_b12',
        ["MATCHMAKING..."]='varesco_b13',
        ["MIN RARITY: Eternal"]='varesco_b05',
        ["MIN RARITY: Any"]='varesco_b07',
        ["MIN RARITY: Secret"]='varesco_b04',
        ["MIN RARITY: Cosmic"]='varesco_b03',
        ["MIN RARITY: Mythic"]='varesco_b02',
        ["TRY AGAIN"]='varesco_b14',
        ["ALL SERVERS"]='varesco_b00',
        ["MY SERVER"]='varesco_b01',
        ["MIN RARITY: Divine"]='varesco_b06',
        ["SEARCHING..."]='varesco_b11',
        ["HERE"]='kindly_b01',
        ["JOIN"]='kindly_b00',
        ["TAKEN"]='kindly_b02',
    }
    local function applyButtonFont(button)
        local glyph=D.make('ImageLabel',{Name='CustomButtonFont',Image='',ImageTransparency=1,BackgroundTransparency=1,ImageColor3=Color3.new(1,1,1),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.new(1,-14,0,20),ScaleType=Enum.ScaleType.Fit,Active=false},button)
        local function ready()
            local key=buttonFontLookup[button.Text]
            local spec=key and mutationSprites[key]
            if spec and glyph.Image==spec.image and glyph.IsLoaded then
                button.TextTransparency=1;glyph.ImageTransparency=0
            end
        end
        local function refreshFont()
            button.TextTransparency=0;glyph.ImageTransparency=1
            local key=buttonFontLookup[button.Text]
            local spec=key and mutationSprites[key]
            if not spec then glyph.Image='';return end
            glyph.Image=spec.image
            ready()
        end
        button:GetPropertyChangedSignal('Text'):Connect(refreshFont)
        glyph:GetPropertyChangedSignal('IsLoaded'):Connect(ready)
        refreshFont()
    end
    -- Bottom options use crisp native rounded text instead of bitmap captions.
    for _,button in ipairs({scope,myScope,rarity,refreshButton}) do styleRaisedButton(button) end
    for _,button in ipairs({scope,myScope,rarity}) do
        button.Font=Enum.Font.FredokaOne
        local caption=button:FindFirstChild('RaisedCaption')
        if caption then
            caption.Font=Enum.Font.FredokaOne;caption.TextScaled=true;caption.TextSize=20
            caption.TextStrokeTransparency=1
            caption.Position=UDim2.fromOffset(6,2);caption.Size=UDim2.new(1,-12,1,-4)
            D.make('UITextSizeConstraint',{MinTextSize=10,MaxTextSize=20},caption)
            D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=2},caption)
        end
    end
    do
    -- Header title and subtitle styling.
    heading.Text='UNKNOWN'
    heading.AnchorPoint=Vector2.new(0.5,0)
    heading.Position=UDim2.new(0.5,-10,0,2);heading.Size=UDim2.new(1,-112,0,24)
    heading.TextXAlignment=Enum.TextXAlignment.Center
    heading.Font=Enum.Font.Arcade;heading.TextTransparency=0
    discordSubtitle.AnchorPoint=Vector2.new(0,0)
    discordSubtitle.Position=UDim2.fromOffset(57,27);discordSubtitle.Size=UDim2.new(1,-112,0,14)
    discordSubtitle.TextXAlignment=Enum.TextXAlignment.Left
    do
        local service=game:GetService('TextService')
        heading.Font=discordSubtitle.Font
        local available=(panel.Size.X.Offset>0 and panel.Size.X.Offset or 402)-100
        local fontSize=22
        local textWidth
        repeat
            textWidth=math.ceil(service:GetTextSize(heading.Text,fontSize,discordSubtitle.Font,Vector2.new(1000,1000)).X)+4
            if textWidth<=available or fontSize<=14 then break end
            fontSize-=1
        until false
        heading.AnchorPoint=Vector2.new(0.5,0);heading.Position=UDim2.new(0.5,0,0,1);heading.Size=UDim2.fromOffset(textWidth,26)
        heading.TextSize=fontSize;heading.TextScaled=false;heading.TextXAlignment=Enum.TextXAlignment.Center;heading.TextStrokeTransparency=1
        local limit=heading:FindFirstChildOfClass('UITextSizeConstraint');if limit then limit.MaxTextSize=22 end
        D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=1.4},heading)
        discordSubtitle.TextSize=15;discordSubtitle.TextScaled=false;discordSubtitle.TextWrapped=false;discordSubtitle.TextTruncate=Enum.TextTruncate.None;discordSubtitle.Size=UDim2.new(1,-79,0,16)
        discordSubtitle.AnchorPoint=Vector2.new(0,0);discordSubtitle.Position=UDim2.fromOffset(57,27);discordSubtitle.TextXAlignment=Enum.TextXAlignment.Center;discordSubtitle.TextStrokeTransparency=1
        local discordLimit=discordSubtitle:FindFirstChildOfClass('UITextSizeConstraint');if discordLimit then discordLimit:Destroy() end
        D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=1.3},discordSubtitle)
    end
    refreshButton.Font=Enum.Font.FredokaOne
    local refreshCaption=refreshButton:FindFirstChild('RaisedCaption')
    if refreshCaption then
        refreshCaption.Font=Enum.Font.FredokaOne;refreshCaption.TextSize=20;refreshCaption.TextScaled=true;refreshCaption.TextStrokeTransparency=1
        refreshCaption.Position=UDim2.fromOffset(4,2);refreshCaption.Size=UDim2.new(1,-8,1,-4)
        D.make('UITextSizeConstraint',{MinTextSize=12,MaxTextSize=20},refreshCaption)
        D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=1.7},refreshCaption)
    end
    resetTimer.Font=Enum.Font.FredokaOne;resetTimer.TextSize=16;resetTimer.TextScaled=true;resetTimer.TextStrokeTransparency=1
    D.make('UITextSizeConstraint',{MinTextSize=10,MaxTextSize=16},resetTimer)
    D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=1.4},resetTimer)
    local hotkeyConnection=Input.InputBegan:Connect(function(input,processed)
        if processed or Input:GetFocusedTextBox() then return end
        if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==menuHotkey then
            panel.Visible=not panel.Visible
            D.localPanel.Visible=not panel.Visible
        end
    end)
    D.gui.Destroying:Connect(function() hotkeyConnection:Disconnect() end)
    end
    local mutationPalettes={
        title={Color3.fromRGB(223,221,221),Color3.fromRGB(225,223,223),Color3.fromRGB(226,225,225),Color3.fromRGB(228,227,227),Color3.fromRGB(230,229,229),Color3.fromRGB(231,231,231),Color3.fromRGB(233,233,233),Color3.fromRGB(236,236,236),Color3.fromRGB(239,239,239),Color3.fromRGB(242,242,242),Color3.fromRGB(246,246,246),Color3.fromRGB(249,249,249),Color3.fromRGB(252,252,252),Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255),Color3.fromRGB(252,252,252),Color3.fromRGB(249,249,249),Color3.fromRGB(246,246,246),Color3.fromRGB(242,242,242),Color3.fromRGB(239,239,239),Color3.fromRGB(236,236,236),Color3.fromRGB(233,233,233),Color3.fromRGB(230,230,230),Color3.fromRGB(227,227,227),Color3.fromRGB(224,224,224),Color3.fromRGB(220,220,220),Color3.fromRGB(217,217,217),Color3.fromRGB(214,214,214)},
        discord={Color3.fromRGB(255,0,225),Color3.fromRGB(251,0,226),Color3.fromRGB(247,0,227),Color3.fromRGB(244,0,229),Color3.fromRGB(240,0,230),Color3.fromRGB(236,0,231),Color3.fromRGB(232,0,232),Color3.fromRGB(229,0,233),Color3.fromRGB(225,0,235),Color3.fromRGB(221,0,236),Color3.fromRGB(217,0,237),Color3.fromRGB(214,0,238),Color3.fromRGB(210,0,239),Color3.fromRGB(206,0,241),Color3.fromRGB(202,0,242),Color3.fromRGB(199,0,243),Color3.fromRGB(195,0,244),Color3.fromRGB(191,0,245),Color3.fromRGB(187,0,247),Color3.fromRGB(184,0,248),Color3.fromRGB(180,0,249),Color3.fromRGB(176,0,250),Color3.fromRGB(172,0,251),Color3.fromRGB(169,0,253),Color3.fromRGB(165,0,254),Color3.fromRGB(161,0,255)},
        golden={Color3.fromRGB(206,164,0),Color3.fromRGB(222,173,0),Color3.fromRGB(239,182,0),Color3.fromRGB(255,191,0),Color3.fromRGB(254,209,46),Color3.fromRGB(253,227,92)},
        rainbow={Color3.fromRGB(255,0,0),Color3.fromRGB(255,113,0),Color3.fromRGB(255,169,0),Color3.fromRGB(255,248,0),Color3.fromRGB(139,255,0),Color3.fromRGB(0,255,7),Color3.fromRGB(0,255,154)},
        silver={Color3.fromRGB(71,71,71),Color3.fromRGB(104,104,104),Color3.fromRGB(137,137,137),Color3.fromRGB(170,170,170),Color3.fromRGB(137,137,137),Color3.fromRGB(104,104,104),Color3.fromRGB(71,71,71)}
    }
    local mutationGradients={golden={},silver={},rainbow={},discord={},title={}}
    local function mutationSequence(palette,now)
        local phase=(now/4)%1
        local points={}
        for i=0,16 do
            local sample=((i/16-phase)%1)*#palette
            local index=math.floor(sample)
            points[#points+1]=ColorSequenceKeypoint.new(i/16,palette[index+1]:Lerp(palette[(index+1)%#palette+1],sample-index))
        end
        return ColorSequence.new(points)
    end
    local function mutationStyle(object,name)
        local key=name:lower()
        if key=='gold' then key='golden' end
        local palette=mutationPalettes[key]
        if not palette then return end
        if object:IsA('TextLabel') then
            object.TextColor3=Color3.new(1,1,1);object.TextStrokeTransparency=1
        else object.ImageColor3=Color3.new(1,1,1) end
        local gradient=D.make('UIGradient',{Color=mutationSequence(palette,os.clock()),Rotation=0},object)
        local bucket=mutationGradients[key];bucket[#bucket+1]=gradient
    end
    mutationStyle(discordSubtitle,'discord')
    mutationStyle(heading,'discord')
    local filterPalettes={
        cosmic={Color3.fromRGB(67,37,239),Color3.fromRGB(113,29,255),Color3.fromRGB(90,37,230),Color3.fromRGB(67,44,204),Color3.fromRGB(63,44,244),Color3.fromRGB(41,12,217)},
        secret={Color3.fromRGB(40,40,40),Color3.fromRGB(66,62,59),Color3.fromRGB(90,90,87),Color3.fromRGB(118,124,118),Color3.fromRGB(144,152,152),Color3.fromRGB(195,195,201)},
        eternal={Color3.fromRGB(143,203,193),Color3.fromRGB(179,236,227),Color3.fromRGB(192,236,229),Color3.fromRGB(205,236,230),Color3.fromRGB(216,236,232),Color3.fromRGB(227,236,234),Color3.fromRGB(182,165,198),Color3.fromRGB(82,28,125),Color3.fromRGB(141,92,164),Color3.fromRGB(183,125,193),Color3.fromRGB(216,151,220),Color3.fromRGB(230,171,234),Color3.fromRGB(227,187,236),Color3.fromRGB(218,202,236),Color3.fromRGB(212,216,236)}
    }
    local filterWords=D.make('Frame',{Name='RarityFontParts',AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(1,26),BackgroundTransparency=1,Active=false,ZIndex=rarity.ZIndex+5},rarity)
    local function filterLabel(text)
        local label=D.make('TextLabel',{Text=text,Font=Enum.Font.FredokaOne,TextSize=20,TextColor3=Color3.new(1,1,1),TextStrokeTransparency=1,BackgroundTransparency=1,TextWrapped=false,TextScaled=false,Active=false,ZIndex=filterWords.ZIndex},filterWords)
        D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=2},label)
        return label
    end
    local filterPrefix=filterLabel('MIN RARITY:')
    local filterWord=filterLabel('Any')
    local filterGradient=D.make('UIGradient',{Enabled=false,Rotation=0},filterWord)
    local filterName=rarityOptions[rarityIndex].name:lower()
    local function updateFilterColor(now)
        local palette=filterPalettes[filterName]
        if palette then
            filterWord.TextColor3=Color3.new(1,1,1);filterGradient.Enabled=true
            filterGradient.Color=mutationSequence(palette,now)
        else
            filterGradient.Enabled=false;filterWord.TextColor3=rarityColors[filterName] or Color3.new(1,1,1)
        end
    end
    local function refreshFilterWord()
        local name=rarityOptions[rarityIndex].name
        filterName=name:lower();filterWord.Text=name
        filterGradient.Rotation=filterName=='eternal' and 90 or 0
        rarity.TextTransparency=1
        local caption=rarity:FindFirstChild('RaisedCaption');if caption then caption.Visible=false end
        local panelWidth=panel.Size.X.Offset>0 and panel.Size.X.Offset or 402
        local available=math.max(20,panelWidth*rarity.Size.X.Scale+rarity.Size.X.Offset-20)
        local service=game:GetService('TextService')
        local size,prefixWidth,wordWidth=22,0,0
        repeat
            prefixWidth=math.ceil(service:GetTextSize(filterPrefix.Text,size,Enum.Font.FredokaOne,Vector2.new(1000,1000)).X)+4
            wordWidth=math.ceil(service:GetTextSize(name,size,Enum.Font.FredokaOne,Vector2.new(1000,1000)).X)+4
            if prefixWidth+wordWidth+6<=available or size<=10 then break end
            size-=1
        until false
        filterWords.Size=UDim2.fromOffset(prefixWidth+wordWidth+6,26)
        filterPrefix.Position=UDim2.new();filterPrefix.Size=UDim2.fromOffset(prefixWidth,26);filterPrefix.TextSize=size
        filterWord.Position=UDim2.fromOffset(prefixWidth+6,0);filterWord.Size=UDim2.fromOffset(wordWidth,26);filterWord.TextSize=size
        updateFilterColor(os.clock())
    end
    rarity:GetPropertyChangedSignal('Text'):Connect(refreshFilterWord)
    refreshFilterWord()
    -- Keep the internal rarity filter at Any, but remove its control from the visible UI.
    rarity.Visible=false
    rarity.Active=false
    rarity.Size=UDim2.fromOffset(0,0)
    local rarityGradientBuckets={cosmic={},secret={},eternal={}}
    local function styleRarityLabel(label,key)
        local palette=filterPalettes[key]
        if not palette then return end
        label.TextColor3=Color3.new(1,1,1)
        if key=='secret' then label.TextStrokeColor3=Color3.new(0,0,0);label.TextStrokeTransparency=0.25 end
        local gradient=D.make('UIGradient',{Color=mutationSequence(palette,os.clock()),Rotation=key=='eternal' and 90 or 0},label)
        rarityGradientBuckets[key][gradient]=true
    end
    local lastMutationUpdate=0
    local mutationMotion=game:GetService('RunService').Heartbeat:Connect(function()
        local now=os.clock()
        if now-lastMutationUpdate<1/20 then return end
        lastMutationUpdate=now
        if loadingVisible and aliveMessage.Visible then
            local text=loadingText(now);if aliveMessage.Text~=text then aliveMessage.Text=text end
        end
        updateFilterColor(now)
        for key,bucket in pairs(rarityGradientBuckets) do
            if next(bucket) then
                local colors=mutationSequence(filterPalettes[key],now)
                for gradient in pairs(bucket) do
                    if gradient.Parent then gradient.Color=colors else bucket[gradient]=nil end
                end
            end
        end
        for key,bucket in pairs(mutationGradients) do
            if #bucket>0 then
                local colors=mutationSequence(mutationPalettes[key],now)
                for i=#bucket,1,-1 do
                    local gradient=bucket[i]
                    if not gradient.Parent then table.remove(bucket,i) else gradient.Color=colors end
                end
            end
        end
    end)
    D.gui.Destroying:Connect(function() mutationMotion:Disconnect() end)
    local function mutationWidth(name,textService,available)
        local spec=mutationSpriteData[name:lower()]
        if spec then return math.min(available,math.ceil(spec.width/spec.height*24)+8) end
        return math.min(available,math.ceil(textService:GetTextSize(name,22,Enum.Font.Arcade,Vector2.new(1000,28)).X)+8)
    end
    local function mutationWord(row,name,position,width)
        local word=D.label(row,name,position,UDim2.fromOffset(width,28),Color3.fromRGB(245,210,125),22)
        word.Font=Enum.Font.Arcade
        word.TextXAlignment=Enum.TextXAlignment.Center
        word.TextTruncate=Enum.TextTruncate.None;word.TextScaled=true;word.TextWrapped=false
        D.make('UITextSizeConstraint',{MinTextSize=1,MaxTextSize=22},word)
        mutationStyle(word,name)
        word.TextStrokeColor3=Color3.new(0,0,0);word.TextStrokeTransparency=0
        local fallbackStroke=D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=1.1},word)
        local spec=mutationSprites[name:lower()]
        if spec then
            local glyph=D.make('ImageLabel',{Image=spec.image,ImageTransparency=1,BackgroundTransparency=1,ImageColor3=Color3.new(1,1,1),Size=UDim2.new(1,-4,1,-4),Position=UDim2.fromOffset(2,2),ScaleType=Enum.ScaleType.Fit,Active=false,ZIndex=word.ZIndex+2},word)
            pcall(function() glyph.ResampleMode=Enum.ResamplerMode.Pixelated end)
            local shadows={}
            for _,offset in ipairs({{-1,0},{1,0},{0,-1},{0,1}}) do
                local shadow=D.make('ImageLabel',{Image=spec.image,ImageTransparency=1,ImageColor3=Color3.new(0,0,0),BackgroundTransparency=1,Size=UDim2.new(1,-4,1,-4),Position=UDim2.fromOffset(2+offset[1],2+offset[2]),ScaleType=Enum.ScaleType.Fit,Active=false,ZIndex=word.ZIndex+1},word)
                pcall(function() shadow.ResampleMode=Enum.ResamplerMode.Pixelated end)
                shadows[#shadows+1]=shadow
            end
            mutationStyle(glyph,name)
            local function ready()
                if glyph.IsLoaded then fallbackStroke.Enabled=false;word.TextStrokeTransparency=1;word.TextTransparency=1;glyph.ImageTransparency=0;for _,shadow in ipairs(shadows) do shadow.ImageTransparency=0 end end
            end
            glyph:GetPropertyChangedSignal('IsLoaded'):Connect(ready)
            ready()
        end
        return word
    end
    local joiningKey=nil
    local joinRetryAt=0
    local cardsByKey={}
    local function compactCardHeight()
        return 90
    end
    local function joinPresentation(entry)
        local here=entry.isLocal or entry.jobId==game.JobId
        if entry.takenConfirmed then return L('TAKEN','تم أخذه'),Color3.fromRGB(235,55,65),false end
        if here then return L('HERE','هنا'),Color3.fromRGB(205,205,210),false end
        if entry.full or entry.unavailable then return L('FULL','ممتلئ'),Color3.fromRGB(255,75,85),false end
        if joining and joiningKey==entry.key then return L('JOINING...','جارٍ الانضمام...'),Color3.fromRGB(40,160,85),false end
        return L('JOIN','انضمام'),Color3.fromRGB(40,160,85),true
    end
    local rankWidthCache={}
    local raritySizeCache={}
    local function cardSignature(entry)
        return Http:JSONEncode({tostring(entry.rarity),tostring(entry.mutations),tostring(entry.mutationText),tostring(entry.traitsKnown),tostring(entry.isEvent),tostring(entry.source)})
    end
    local function compactWeightToFit(text,available,size,service)
        local function fits(value) return service:GetTextSize(value,size,Enum.Font.GothamBlack,Vector2.new(1000,1000)).X<=available end
        local result=text
        while not fits(result) do
            local prefix,whole,fraction,suffix=result:match('^(.-)(%d+)%.(%d+)(.*)$')
            if not fraction then break end
            fraction=fraction:sub(1,-2)
            result=prefix..whole..(#fraction>0 and '.'..fraction or '')..suffix
        end
        return result
    end
    local function fitFinanceText(card)
        local rowWidth=math.max(220,list.AbsoluteSize.X / math.max(responsiveScale.Scale,0.01)-18)
        local width=rowWidth-198
        local service=game:GetService('TextService')
        local weightSize=13
        local weightAvailable=width*0.46-10
        local text=weightPresentation(card.entry)
        card.weightLabel.Text=compactWeightToFit(text,weightAvailable,weightSize,service)
        for _,spec in ipairs({{card.incomeLabel,width*0.54-30,13},{card.weightLabel,weightAvailable,weightSize}}) do
            local label,available,size=spec[1],spec[2],spec[3]
            while size>8 and service:GetTextSize(label.Text,size,Enum.Font.GothamBlack,Vector2.new(1000,1000)).X>available do size-=1 end
            label.TextSize=size
        end
    end
    local function updateCard(card,entry,i)
        local height=compactCardHeight()
        if card.compactHeight~=height or card.renderScale~=responsiveScale.Scale then
            card.renderScale=responsiveScale.Scale
            card.compactHeight=height;card.row.Size=UDim2.new(1,-15,0,height)
            local renderScale=responsiveScale.Scale
            if type(renderScale)~='number' or renderScale<=0 then renderScale=1 end
            local iconSize=math.floor(math.min(60,height-40)*renderScale)/renderScale
            card.icon.Size=UDim2.fromOffset(iconSize,iconSize);card.icon.Position=UDim2.fromOffset(math.floor((10+(70-iconSize)/2)*renderScale)/renderScale,7)
            card.spotlight.Position=card.icon.Position
            card.spotlight.Size=card.icon.Size
            card.join.Position=UDim2.new(1,-113.5,0,(height-35)/2)
        end
        local rank=tonumber(entry.displayRank or entry.globalRank or i)
        local rankText='#'..tostring(entry.displayRank or entry.globalRank or i)
        local rankColors={[1]=Color3.fromRGB(255,209,65),[2]=Color3.new(1,1,1),[3]=Color3.fromRGB(199,123,72)}
        card.rankLabel.TextColor3=rankColors[rank] or Color3.fromRGB(220,224,235)
        card.rankShine.Enabled=rank==2
        card.rankStar.Visible=rankColors[rank]~=nil
        for _,part in ipairs({card.rankStarVertical,card.rankStarHorizontal,card.rankStarCore}) do part.BackgroundColor3=rankColors[rank] or Color3.new(1,1,1) end
        card.rankStar.Position=UDim2.fromOffset(82.5+card.rankLabel.Size.X.Offset-5,6)
        if card.rankLabel.Text~=rankText then
            local width=rankWidthCache[rankText]
            if not width then
                width=math.ceil(game:GetService('TextService'):GetTextSize(rankText,17,Enum.Font.FredokaOne,Vector2.new(1000,28)).X)+4
                rankWidthCache[rankText]=width
            end
            card.rankLabel.Text=rankText;card.rankLabel.Size=UDim2.fromOffset(width,26);card.rankStar.Position=UDim2.fromOffset(82.5+width-5,6)
            card.nameLabel.Position=UDim2.fromOffset(84+width,8.4);card.nameLabel.Size=UDim2.new(1,-188-width,0,26)
        end
        if card.nameLabel.Text~=tostring(entry.name) then card.nameLabel.Text=tostring(entry.name) end
        card.nameLabel.Size=UDim2.new(1,-188-card.rankLabel.Size.X.Offset,0,26)
        if card.icon.Image~=(entry.icon or '') then card.icon.Image=entry.icon or '' end
        if not card.financeReady or card.rate~=entry.rate or card.missingRate~=entry.missingRate then
            card.incomeLabel.Text=entry.missingRate and 'Income unavailable' or D.money(entry.rate)
            card.rate=entry.rate;card.missingRate=entry.missingRate
        end
        if not card.financeReady or card.scale~=entry.scale or card.weight~=entry.weight then
            local text,color=weightPresentation(entry)
            local isScale=type(entry.weight)~='number' and type(entry.scale)=='number'
            card.weightLabel.Text=text;card.weightLabel.TextColor3=color
            card.weightLabel.Font=Enum.Font.GothamBlack
            card.weightLabel.TextSize=13
            card.weightLimit.MaxTextSize=13
            card.scale=entry.scale;card.weight=entry.weight
        end
        if not card.financeReady or card.fittedRate~=entry.rate or card.fittedWeight~=entry.weight or card.fittedScale~=entry.scale then
            fitFinanceText(card);card.fittedRate=entry.rate;card.fittedWeight=entry.weight;card.fittedScale=entry.scale
        end
        card.financeReady=true
        local text,color,enabled=joinPresentation(entry)
        -- Keep the local taken state label-only; never append an elapsed-time counter.
        if entry.takenConfirmed then text=L('TAKEN','تم أخذه') end
        card.join.TextWrapped=false
        card.join.Font=currentLanguage=='Arabic' and Enum.Font.GothamBold or Enum.Font.FredokaOne
        if card.join.Text~=text then card.join.Text=text end
        -- Always apply the current status color, even when the label/enabled state is unchanged.
        local here=entry.isLocal or entry.jobId==game.JobId
        local split=here and entry.takenConfirmed and not othersOnly
        local plainHere=here and not entry.takenConfirmed
        local gradient=card.statusGradient
        if split then
            card.join.BackgroundColor3=Color3.new(1,1,1)
            gradient.Rotation=35
            gradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(235,55,65)),ColorSequenceKeypoint.new(.499,Color3.fromRGB(235,55,65)),ColorSequenceKeypoint.new(.501,Color3.fromRGB(205,205,210)),ColorSequenceKeypoint.new(1,Color3.fromRGB(205,205,210))})
        else
            card.join.BackgroundColor3=color
            gradient.Rotation=90
            gradient.Color=plainHere and ColorSequence.new(Color3.new(1,1,1)) or ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(.72,Color3.fromRGB(225,225,225)),ColorSequenceKeypoint.new(1,Color3.fromRGB(135,135,135))})
        end
        card.join.TextTransparency=split and 1 or 0
        card.join.TextColor3=plainHere and Color3.new(0,0,0) or Color3.new(1,1,1)
        card.join.TextStrokeTransparency=plainHere and 1 or 0
        card.takenHalf.Visible=split;card.hereHalf.Visible=split
        card.takenHalf.Text=L('TAKEN','تم أخذه');card.hereHalf.Text=L('HERE','هنا')
        card.takenHalf.Font=currentLanguage=='Arabic' and Enum.Font.GothamBold or Enum.Font.FredokaOne
        card.hereHalf.Font=card.takenHalf.Font
        if card.buttonText~=text or card.buttonEnabled~=enabled then
            card.join.Active=enabled;card.join.AutoButtonColor=enabled;card.join.Selectable=enabled
            card.buttonText=text;card.buttonEnabled=enabled
        end
    end
    -- Top5 cache state grouped to reduce outer-scope local register pressure.
    local top5State={
        cache={},
        pendingCache=nil,
        retired={},
        cacheFile='tenshi_beta_top5_cycle_v2.json',
        saved='',
        writeAt=-math.huge
    }
    if type(readfile)=='function' then
        pcall(function()
            local saved=Http:JSONDecode(readfile(top5State.cacheFile))
            if saved.version==1 and type(saved.items)=='table' and type(saved.retired)=='table' then
                top5State.pendingCache=saved
            end
        end)
    end
    local function saveTop5Cache()
        if type(writefile)~='function' or os.clock()-top5State.writeAt<1 then return end
        top5State.writeAt=os.clock()
        pcall(function()
            local bytes=Http:JSONEncode({version=1,items=top5State.cache,retired=top5State.retired})
            if bytes~=top5State.saved then writefile(top5State.cacheFile,bytes);top5State.saved=bytes end
        end)
    end

    top5State.retainedLocal={}
    top5State.myLocalRetained={}
    top5State.retiredLocal={}
    top5State.render=nil
    top5State.rendering,top5State.renderPending,top5State.renderQueued=false,false,false
    sharedRuntime.__UNKNOWN_RENDER_ONCE=function()
        local passEpoch,passScope=queryEpoch,othersOnly
        local batchStarted=os.clock()
        local passDeadline=math.huge
        local function checkpoint()
            if os.clock()-batchStarted<0.003 then return true end
            task.wait()
            batchStarted=os.clock()
            if not active then return false end
            if queryEpoch~=passEpoch or othersOnly~=passScope or (os.clock()+clockOffset)*1000>=passDeadline then
                top5State.renderPending=true
                return false
            end
            return true
        end
        local now=(os.clock()+clockOffset)*1000
        local entries={}
        local source,seen={},{}
        local stateByKey={}
        for key,e in pairs(localStates) do if e.expiresAt>now then stateByKey[key]=e end end
        for _,e in ipairs(feed) do if e.expiresAt>now and not isHalloweenEgg(e) then stateByKey[e.key]=e end end
        local metadata=D.metadata and D.metadata()
        local gameNow=workspace:GetServerTimeNow()*1000
        local validLocal=not metadata or not metadata.resetAt or metadata.resetAt-2000>gameNow
        local current=validLocal and D.entries() or {}
        -- Remember locally observed eggs until this cycle's reset. A confirmed
        -- claimed/carried state or two complete missing scans marks one TAKEN.
        do
            local cache=top5State.myLocalRetained
            local localCycle=cycleInfo()
            local resetAt=(metadata and tonumber(metadata.resetAt)) or (localCycle and tonumber(localCycle.resetAt))
            local present,states={},{}
            for _,state in ipairs(metadata and metadata.states or {}) do states[tostring(state.uid)]=state.state end
            for _,e in ipairs(current) do
                local uid=tostring(e.uid or e.key)
                local key=game.PlaceId..':'..game.JobId..':'..uid
                present[key]=true
                local old=cache[key]
                if not old then
                    old={key=key,uid=uid,placeId=game.PlaceId,jobId=game.JobId,isLocal=true,missingScans=0}
                    cache[key]=old
                end
                old.name=e.name;old.rate=e.rate or 0;old.missingRate=e.rate==nil;old.scale=e.scale;old.weight=e.weight
                old.icon=e.icon;old.rarity=e.rarity;old.rank=e.tier or 0;old.localTier=e.tier or 0
                old.mutations=e.mutationText;old.traitsKnown=e.traitsKnown~=false;old.area=e.areaKey or e.area
                old.source=e.isEvent and 'event' or 'field';old.estimated=e.estimated or e.unmutatedRate~=nil
                old.resetAt=old.resetAt or resetAt or (gameNow+300000)
                old.missingScans=0
                if states[uid]=='Claimed' or states[uid]=='Carried' then old.takenConfirmed=true end
            end
            for key,old in pairs(cache) do
                if gameNow>=old.resetAt then
                    cache[key]=nil
                elseif not present[key] then
                    local state=states[tostring(old.uid)]
                    if state=='Claimed' or state=='Carried' then old.takenConfirmed=true end
                    if metadata and type(metadata.scanAt)=='number' and type(D.ready)=='function' and D.ready() and old.lastMissingScan~=metadata.scanAt then
                        old.lastMissingScan=metadata.scanAt;old.missingScans=(old.missingScans or 0)+1
                        if old.missingScans>=2 then old.takenConfirmed=true end
                    end
                end
            end
        end
        if othersOnly then
            -- MY SERVER is a live local view. ALL-only cache/tombstone rules
            -- must never suppress a record returned by the current field scan.
            local live=D.entries()
            local localCycle=cycleInfo()
            for _,e in ipairs(live) do
                if (e.rate or 0)>=minRate and (e.tier or 0)>=minRank then
                    local uid=tostring(e.uid or e.key)
                    source[#source+1]={key=game.PlaceId..':'..game.JobId..':'..uid,uid=uid,
                        name=e.name,rate=e.rate or 0,missingRate=e.rate==nil,scale=e.scale,weight=e.weight,
                        icon=e.icon,rarity=e.rarity,rank=e.tier,localTier=e.tier,mutations=e.mutationText,
                        traitsKnown=e.traitsKnown~=false,area=e.areaKey or e.area,model=e.model,isLocal=true,
                        source=e.isEvent and 'event' or 'field',estimated=e.estimated or e.unmutatedRate~=nil,
                        placeId=game.PlaceId,jobId=game.JobId,expiresAt=now+5000,seenAt=0,
                        spawnedAt=not e.isEvent and localCycle and localCycle.respawnAt or nil}
                    for _,state in ipairs(metadata and metadata.states or {}) do
                        if tostring(state.uid)==uid and (state.state=='Claimed' or state.state=='Carried') then
                            source[#source].takenConfirmed=true;break
                        end
                    end
                    seen[source[#source].key]=true
                end
            end
            for key,saved in pairs(top5State.myLocalRetained) do
                if saved.takenConfirmed and not seen[key] and (saved.rate or 0)>=minRate and (saved.localTier or 0)>=minRank and saved.resetAt>gameNow then
                    local retained=table.clone(saved)
                    retained.expiresAt=now+math.min(saved.resetAt-gameNow,5000)
                    retained.seenAt=0;retained.trackedTaken=true
                    source[#source+1]=retained;seen[key]=true
                end
            end
            local tracked=D.joinedEgg
            if tracked and not isHalloweenEgg(tracked) and tracked.placeId==game.PlaceId and tracked.jobId==game.JobId then
                local scan=D.metadata and D.metadata()
                if type(D.ready)=='function' and D.ready() and scan and type(scan.scanAt)=='number' and tracked._lastScanAt~=scan.scanAt then
                    tracked._lastScanAt=scan.scanAt
                    local present=false
                    for _,e in ipairs(D.entries()) do
                        if tostring(e.uid or e.key)==tracked.uid then present=true;break end
                    end
                    if present then
                        tracked._missingScans=0
                    else
                        tracked._missingScans=(tracked._missingScans or 0)+1
                    end
                    if tracked._missingScans>=2 and not tracked.takenAt then
                        tracked.takenAt=os.time()
                        local saved=table.clone(tracked)
                        saved._lastScanAt=nil;saved._missingScans=nil
                        pcall(function() Teleports:SetTeleportSetting(joinedEggSettingKey,saved) end)
                    end
                end
                if type(tracked.takenAt)=='number' and not seen[game.PlaceId..':'..game.JobId..':'..tostring(tracked.uid)] then
                    source[#source+1]={
                        key=game.PlaceId..':'..game.JobId..':joined-taken:'..tracked.uid,uid=tracked.uid,
                        name=tracked.name,rate=tracked.rate or 0,missingRate=tracked.missingRate,
                        scale=tracked.scale,weight=tracked.weight,icon=tracked.icon,rarity=tracked.rarity,
                        rank=tracked.rank or 0,localTier=tracked.rank or 0,mutations=tracked.mutations,
                        traitsKnown=tracked.traitsKnown,area=tracked.area,isLocal=true,source=tracked.source,
                        placeId=game.PlaceId,jobId=game.JobId,expiresAt=now+5000,seenAt=0,
                        takenConfirmed=true,takenAt=tracked.takenAt,trackedTaken=true
                    }
                end
            end
            if D.gui then pcall(function() D.gui:SetAttribute('TenshiLocalScanCount',#live);D.gui:SetAttribute('TenshiLocalVisibleCount',#source) end) end
        else
        for key,e in pairs(top5State.retainedLocal) do
            if e.expiresAt<=now then top5State.retainedLocal[key]=nil;top5State.retiredLocal[key]=now+600000 end
        end
        for key,expiry in pairs(top5State.retiredLocal) do if expiry<=now then top5State.retiredLocal[key]=nil end end
        if not othersOnly then
            local tracked=D.joinedEgg
            if tracked and tracked.takenAt and not isHalloweenEgg(tracked) and tracked.placeId==game.PlaceId and tracked.jobId==game.JobId and (tracked.rate or 0)>=minRate and (tracked.rank or 0)>=minRank then
                local key=game.PlaceId..':'..game.JobId..':'..tostring(tracked.uid)
                source[#source+1]={key=key,uid=tracked.uid,name=tracked.name,rate=tracked.rate or 0,missingRate=tracked.missingRate,scale=tracked.scale,weight=tracked.weight,icon=tracked.icon,rarity=tracked.rarity,rank=tracked.rank or 0,localTier=tracked.rank or 0,mutations=tracked.mutations,traitsKnown=tracked.traitsKnown,area=tracked.area,isLocal=true,source=tracked.source,placeId=game.PlaceId,jobId=game.JobId,expiresAt=now+5000,seenAt=0,takenConfirmed=true,takenAt=tracked.takenAt,trackedTaken=true}
                seen[key]=true
            end
            for _,e in ipairs(feed) do
                if not seen[e.key] and not isHalloweenEgg(e) and (e.jobId~=game.JobId or e.unavailable) and (e.rate or 0)>=minRate and (e.rank or 0)>=minRank and type(e.expiresAt)=='number' and e.expiresAt>now then source[#source+1]=e;seen[e.key]=true end
            end
        end
        local fieldStateByUid={}
        if metadata and metadata.resetAt and metadata.resetAt>gameNow then
            local states={}
            for _,state in ipairs(metadata.states or {}) do
                states[state.uid]=state.state
                fieldStateByUid[tostring(state.uid)]=state.state
            end
            for key,e in pairs(top5State.retainedLocal) do
                if not isHalloweenEgg(e) and (not states[e.uid] or states[e.uid]=='Claimed' or states[e.uid]=='Carried') then
                    e.unavailable=true;e.full=true;e.takenConfirmed=true
                    stateByKey[key]=e
                    if not othersOnly and not seen[key] and e.rate>=minRate and (e.localTier or 0)>=minRank then source[#source+1]=e;seen[key]=true end
                end
            end
        end
            local localCycle=cycleInfo()
            for _,e in ipairs(current) do
                if (e.rate or 0)>=minRate and (e.tier or 0)>=minRank then
                    local key=game.PlaceId..':'..game.JobId..':'..tostring(e.uid or e.key)
                    local state=not othersOnly and stateByKey[key] or nil
                    if state and state.unavailable and top5State.cache[key] then top5State.cache[key].unavailable=true;top5State.cache[key].full=true end
                    if not seen[key] and not top5State.retiredLocal[key] and not (state and state.unavailable) then
                        seen[key]=true
                        local localState=fieldStateByUid[tostring(e.uid or e.key)]
                    local taken=localState=='Carried' or localState=='Claimed'
                    source[#source+1]={key=key,uid=tostring(e.uid or e.key),name=e.name,rate=e.rate or 0,missingRate=e.rate==nil,scale=e.scale,weight=e.weight,icon=e.icon,rarity=e.rarity,mutations=e.mutationText,traitsKnown=e.traitsKnown~=false,area=e.areaKey or e.area,model=e.model,isLocal=true,localTier=e.tier,full=taken or (not othersOnly and state and state.full or false),unavailable=taken,takenConfirmed=taken,source=e.isEvent and 'event' or 'field',estimated=e.estimated or e.unmutatedRate~=nil,placeId=game.PlaceId,jobId=game.JobId,expiresAt=now+5000,seenAt=0,spawnedAt=not e.isEvent and localCycle and localCycle.respawnAt or nil,spawnTimeKnown=not e.isEvent and localCycle~=nil and type(localCycle.respawnAt)=='number'}
                        if metadata and metadata.resetAt and not e.isEvent then
                            local saved=table.clone(source[#source]);saved.expiresAt=now+metadata.resetAt-gameNow-2000;saved.localTier=e.tier
                            top5State.retainedLocal[key]=saved
                        end
                    end
                end
            end
            local cycle=cycleInfo()
            if top5State.pendingCache and feedAt>0 then
                top5State.cache=top5State.pendingCache.items;top5State.retired=top5State.pendingCache.retired;top5State.pendingCache=nil
            end
            local cycleEnd=cycle and type(cycle.resetAt)=='number' and now+cycle.resetAt-gameNow-2000 or nil
            local cycleStart=cycleEnd and cycleEnd-298000 or nil
            -- Keep deadlines in the host clock across teleports. Never assign
            -- an old sighting to the next world just because it became FULL late.
            for key,expiry in pairs(top5State.retired) do if type(expiry)~='number' or expiry<=now then top5State.retired[key]=nil end end
            for key,saved in pairs(top5State.cache) do
                if type(saved)~='table' or type(saved.expiresAt)~='number' or saved.expiresAt<=now or saved.expiresAt>now+305000 then
                    top5State.cache[key]=nil;top5State.retired[key]=now+600000
                end
            end
            local combined,live={},{}
            for _,e in ipairs(source) do
                local old=top5State.cache[e.key]
                local expiredLegacy=not e.retentionPinned and e.resetEstimated==true and cycleStart and type(e.seenAt)=='number' and e.seenAt>0 and e.seenAt<cycleStart
                if not top5State.retired[e.key] and not expiredLegacy then
                    if old and not e.retentionPinned and not othersOnly then
                        e.expiresAt=math.min(e.expiresAt>now and e.expiresAt or old.expiresAt,old.expiresAt)
                        -- A 90s feed TTL is not the retained card's reset deadline.
                        if old.resetEstimated then e.expiresAt=old.expiresAt end
                        if old.unavailable then e.unavailable=true;e.full=true;e.takenConfirmed=old.takenConfirmed end
                    end
                    combined[#combined+1]=e;live[e.key]=true
                elseif expiredLegacy then
                    top5State.cache[e.key]=nil;top5State.retired[e.key]=now+600000
                end
            end
            if not othersOnly then
                for key,saved in pairs(top5State.cache) do
                    if not live[key] and not top5State.retired[key] and saved.expiresAt>now and (saved.rate or 0)>=minRate and (saved.rank or 0)>=minRank then
                        local e=table.clone(saved);e.full=true;e.isLocal=nil
                        combined[#combined+1]=e
                    end
                end
            end
            table.sort(combined,function(a,b) if a.rate~=b.rate then return a.rate>b.rate end;return a.key<b.key end)
            source={}
            local keep={}
            for rank,e in ipairs(combined) do
                local full=e.full or e.unavailable
                if rank<=5 or not full then
                    if not (othersOnly and e.unavailable) then source[#source+1]=e end
                end
                if not othersOnly and rank<=5 and not top5State.retired[e.key] then
                    local previous=top5State.cache[e.key]
                    local expiry=e.retentionPinned and e.expiresAt or previous and previous.expiresAt
                    if not expiry then
                        if e.isLocal and metadata and metadata.resetAt then expiry=now+metadata.resetAt-gameNow-2000
                        elseif e.resetEstimated==true then expiry=cycleEnd
                        else expiry=e.expiresAt end
                    end
                    if expiry and expiry>now then
                        local saved={}
                        for _,name in ipairs({'key','uid','name','rate','scale','weight','icon','rarity','mutations','traitsKnown','area','source','estimated','placeId','jobId','seenAt','unavailable','resetEstimated','full','retentionPinned','takenConfirmed'}) do saved[name]=e[name] end
                        saved.rank=e.rank or (e.isLocal and e.localTier) or 0
                        saved.expiresAt=expiry;saved.resetEstimated=e.resetEstimated==true
                        top5State.cache[e.key]=saved;keep[e.key]=true
                        e.expiresAt=expiry
                    end
                end
            end
            -- Filters and MY SERVER never erase the saved ALL SERVER cards.
            if not othersOnly and minRate==0 and minRank==0 then
                for key in pairs(top5State.cache) do if not keep[key] then top5State.cache[key]=nil end end
            end
            if not top5State.pendingCache then saveTop5Cache() end

        end
            if not othersOnly then
                for i=#source,1,-1 do
                    if (tonumber(source[i].rate) or 0)<serversMinValue then table.remove(source,i) end
                end
            end
            table.sort(source,function(a,b) if othersOnly and a.trackedTaken~=b.trackedTaken then return a.trackedTaken==true end; if a.rate~=b.rate then return a.rate>b.rate end; return a.key<b.key end)
            local limit=10
            while #source>limit do source[#source]=nil end
            for i,e in ipairs(source) do e.displayRank=i end
        for priorityRank,entry in ipairs(source) do
            if type(entry)=='table' and type(entry.expiresAt)=='number' and now<entry.expiresAt and type(entry.rate)=='number' and type(entry.jobId)=='string' and D.publicEntryAllowed(entry,now) and (othersOnly or D.publicPriorityVisible(entry,priorityRank)) then
                local visible=table.clone(entry)
                visible.displayRank=#entries+1
                entries[#entries+1]=visible
            end
        end
        -- Keep the old canvas extent while rebuilding so Roblox does not clamp
        -- the scroll position to zero when the rows are temporarily removed.
        local savedScroll=list.CanvasPosition
        local canvasHeight=#entries==0 and 48 or 8
        local wanted={}
        for _,entry in ipairs(entries) do wanted[entry.key]=true;passDeadline=math.min(passDeadline,entry.expiresAt) end
        for key,card in pairs(cardsByKey) do
            if not wanted[key] then
                card.row:Destroy();cardsByKey[key]=nil
                if not checkpoint() then return end
            end
        end
        loadingVisible=#entries==0 and (othersOnly and type(D.ready)=='function' and not D.ready() or not othersOnly and feedAt<=0)
        aliveContainer.Visible=#entries==0
        aliveMessage.Visible=#entries==0
        aliveMessage.Position=UDim2.fromOffset(0,(othersOnly and not loadingVisible and (type(D.ready)~='function' or D.ready())) and -8 or 0)
        aliveMessage.Text=loadingVisible and loadingText(os.clock()) or othersOnly and (type(D.ready)=='function' and not D.ready() and L('Reading current server eggs...','جارٍ قراءة البيض في السيرفر الحالي...') or L('No matching eggs in this server','لا يوجد بيض مطابق في هذا السيرفر')) or L('No matching eggs right now','لا يوجد بيض مطابق حاليًا')
        for i,entry in ipairs(entries) do
            local signature=cardSignature(entry)
            local card=cardsByKey[entry.key]
            if not card or not card.row.Parent or card.signature~=signature then
            if card and card.row.Parent then card.row:Destroy() end
            card={entry=entry,signature=signature}
            local row=D.make('Frame',{Size=UDim2.new(1,-15,0,90),LayoutOrder=i,BackgroundColor3=Color3.fromRGB(19,5,35),BackgroundTransparency=0.65,ZIndex=3,BorderSizePixel=0},list)
            card.row=row
            row.ClipsDescendants=false
            D.make('UICorner',{CornerRadius=UDim.new(0,13)},row)
            D.make('UIGradient',{Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(184,148,210)),Rotation=90},row)
            D.make('UIStroke',{Name='ServerOutline',Color=Color3.fromRGB(203,139,255),Thickness=1.3,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},row)
            if D.serverCardGlowUri then
                local glow=Instance.new('ImageLabel');glow.Name='CardGlow'
                glow.BackgroundTransparency=1;glow.Active=false;glow.Position=UDim2.fromOffset(-7,-7)
                glow.Size=UDim2.new(1,14,1,14);glow.Image=D.serverCardGlowUri
                glow.ScaleType=Enum.ScaleType.Slice;glow.SliceCenter=Rect.new(40,40,88,88)
                glow.SliceScale=.5;glow.ZIndex=3;glow.Parent=row
            end
            -- Static native UI rays: no downloads, image compression or animation work.
            local spotlight=D.make('Frame',{Name='PetSpotlight',Position=UDim2.fromOffset(2,0),Size=UDim2.new(0,82,1,-22),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=false,Active=false,ZIndex=row.ZIndex+1},row)
            -- Pet icon intentionally has no white rays or center-glow overlay.
            card.spotlight=spotlight
            card.icon=D.make('ImageLabel',{Name='PetIcon',Image=entry.icon or '',ZIndex=spotlight.ZIndex+1,BackgroundTransparency=1,Size=UDim2.fromOffset(88,88),Position=UDim2.fromOffset(4,4),ScaleType=Enum.ScaleType.Fit},row)
            local rarityKey=tostring(entry.rarity):lower():gsub('%s+','')
            local nameColor=rarityColors[rarityKey] or Color3.fromRGB(225,225,235)
            local rankText='#'..tostring(entry.displayRank or entry.globalRank or i)
            local textService=game:GetService('TextService')
            local rankWidth=rankWidthCache[rankText]
            if not rankWidth then
                rankWidth=math.ceil(textService:GetTextSize(rankText,17,Enum.Font.FredokaOne,Vector2.new(1000,28)).X)+4
                rankWidthCache[rankText]=rankWidth
            end
            local rankLabel=D.label(row,rankText,UDim2.fromOffset(82.5,8.4),UDim2.fromOffset(rankWidth,26),Color3.fromRGB(220,224,235),17)
            rankLabel.Font=Enum.Font.FredokaOne
            D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=1.5},rankLabel)
            card.rankLabel=rankLabel
            card.rankShine=D.make('UIGradient',{Name='RankSilverShine',Enabled=false,Rotation=90,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(.4,Color3.fromRGB(172,185,200)),ColorSequenceKeypoint.new(.6,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(165,178,195))})},rankLabel)
            -- Native four-point sparkle, no font glyph dependency.
            card.rankStar=D.make('Frame',{Name='RankStar',BackgroundTransparency=1,Size=UDim2.fromOffset(9,9),Active=false,ZIndex=row.ZIndex+4},row)
            card.rankStarVertical=D.make('Frame',{Name='Vertical',BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Position=UDim2.fromOffset(4,0),Size=UDim2.fromOffset(1,9),Active=false,ZIndex=row.ZIndex+5},card.rankStar)
            card.rankStarHorizontal=D.make('Frame',{Name='Horizontal',BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Position=UDim2.fromOffset(0,4),Size=UDim2.fromOffset(9,1),Active=false,ZIndex=row.ZIndex+5},card.rankStar)
            card.rankStarCore=D.make('Frame',{Name='Core',BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Position=UDim2.fromOffset(3,3),Size=UDim2.fromOffset(3,3),Rotation=45,Active=false,ZIndex=row.ZIndex+5},card.rankStar)
            rankLabel.TextTruncate=Enum.TextTruncate.None
            local nameLabel=D.label(row,tostring(entry.name),UDim2.fromOffset(84+rankWidth,8.4),UDim2.new(1,-188-rankWidth,0,26),nameColor,16)
            card.nameLabel=nameLabel
            rankLabel.TextYAlignment=Enum.TextYAlignment.Center;nameLabel.TextYAlignment=Enum.TextYAlignment.Center
            nameLabel.Font=Enum.Font.GothamBold;nameLabel.TextTruncate=Enum.TextTruncate.AtEnd
            D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=1.1},nameLabel)
            nameLabel.TextStrokeColor3=Color3.new(0,0,0);nameLabel.TextStrokeTransparency=1
            rankLabel.TextStrokeColor3=Color3.new(0,0,0);rankLabel.TextStrokeTransparency=1
            pcall(function() card.icon.ResampleMode=Enum.ResamplerMode.Default end)
            local rarityCell=D.make('Frame',{Name='RarityCell',Position=UDim2.new(0,10,1,rarityKey=='secret' and -31 or -28),Size=UDim2.fromOffset(74,22),BackgroundTransparency=1,ClipsDescendants=true},row)
            local rarityText=tostring(entry.rarity)
            local rarityTextSize=raritySizeCache[rarityText]
            if not rarityTextSize then
                rarityTextSize=20
                while rarityTextSize>1 do
                    local bounds=textService:GetTextSize(rarityText,rarityTextSize,Enum.Font.GothamBlack,Vector2.new(1000,1000))
                    if bounds.X<=76 and bounds.Y<=20 then break end
                    rarityTextSize-=1
                end
                raritySizeCache[rarityText]=rarityTextSize
            end
            local rarityLabel=D.label(rarityCell,rarityText,UDim2.fromOffset(3,1),UDim2.new(1,-6,1,-2),nameColor,rarityTextSize)
            rarityLabel.Font=Enum.Font.GothamBlack
            rarityLabel.TextStrokeColor3=Color3.new(0,0,0);rarityLabel.TextStrokeTransparency=0.2
            rarityLabel.TextXAlignment=Enum.TextXAlignment.Center
            rarityLabel.TextYAlignment=Enum.TextYAlignment.Center
            rarityLabel.TextTruncate=Enum.TextTruncate.None
            rarityLabel.TextScaled=false
            rarityLabel.TextWrapped=false
            styleRarityLabel(nameLabel,rarityKey)
            local finance=D.make('Frame',{Name='IncomeAndWeight',Position=UDim2.fromOffset(86,34),Size=UDim2.new(1,-198,0,22),BackgroundTransparency=1},row)
            local incomeCell=D.make('Frame',{Name='IncomeCell',Position=UDim2.fromOffset(-3.5,-0.7),Size=UDim2.new(0.54,-12,1,0),BackgroundTransparency=1,ClipsDescendants=false},finance)
            local incomeLabel=D.label(incomeCell,entry.missingRate and 'Income unavailable' or D.money(entry.rate),UDim2.fromOffset(3,2),UDim2.new(1,-6,1,-4),Color3.fromRGB(135,240,140),20)
            card.incomeLabel=incomeLabel;incomeLabel.TextSize=13
            incomeLabel.TextStrokeColor3=Color3.new(0,0,0);incomeLabel.TextStrokeTransparency=1
            incomeLabel.Font=Enum.Font.GothamBlack
            D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=1.1},incomeLabel)
            incomeLabel.TextTruncate=Enum.TextTruncate.None
            incomeLabel.TextScaled=false
            incomeLabel.TextWrapped=false
            D.make('UITextSizeConstraint',{MinTextSize=1,MaxTextSize=13},incomeLabel)
            local weightText,weightColor=weightPresentation(entry)
            local isScale=type(entry.weight)~='number' and type(entry.scale)=='number'
            local weightCell=D.make('Frame',{Name='WeightCell',Position=UDim2.new(0.54,-29.5,0,-0.7),Size=UDim2.new(0.46,-4,1,0),BackgroundTransparency=1,ClipsDescendants=false},finance)
            local weightLabel=D.label(weightCell,weightText,UDim2.fromOffset(3,2),UDim2.new(1,-6,1,-4),weightColor,13)
            card.weightLabel=weightLabel
            D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=1.1},weightLabel)
            weightLabel.TextStrokeColor3=Color3.new(0,0,0);weightLabel.TextStrokeTransparency=1
            weightLabel.Font=Enum.Font.GothamBlack
            weightLabel.TextTruncate=Enum.TextTruncate.None
            weightLabel.TextScaled=false
            weightLabel.TextWrapped=false
            card.weightLimit=D.make('UITextSizeConstraint',{MinTextSize=1,MaxTextSize=13},weightLabel)
            rarityLabel.TextColor3=nameLabel.TextColor3
            local nameGradient=nameLabel:FindFirstChildOfClass('UIGradient')
            if nameGradient then
                local gradient=nameGradient:Clone();gradient.Parent=rarityLabel
                rarityGradientBuckets[rarityKey][gradient]=true
            end

            local names=mutationNames(entry)
            local available=math.max(70,list.AbsoluteSize.X / math.max(responsiveScale.Scale,0.01)-130)
            local widths,total={},0
            for i,name in ipairs(names) do widths[i]=mutationWidth(name,textService,available);total+=widths[i];if i<#names then total+=20 end end
            local strip=D.make('Frame',{Name='MutationStrip',Position=UDim2.new(0,86,1,-34),Size=UDim2.new(1,-100,0,28),BackgroundTransparency=1,ClipsDescendants=true},row)
            local words=D.make('Frame',{Name='MutationWords',Position=UDim2.fromOffset(4,0),Size=UDim2.fromOffset(math.max(1,total),28),BackgroundTransparency=1},strip)
            D.make('UIScale',{Scale=math.min(1,available/math.max(1,total))},words)
            local x=0
            for i,name in ipairs(names) do
                mutationWord(words,name,UDim2.fromOffset(x,0),widths[i]);x+=widths[i]
                if i<#names then
                    local plus=D.label(words,'+',UDim2.fromOffset(x,0),UDim2.fromOffset(20,28),Color3.new(1,1,1),21)
                    plus.Font=Enum.Font.GothamBold;plus.TextXAlignment=Enum.TextXAlignment.Center
                    plus.TextStrokeColor3=Color3.new(0,0,0);plus.TextStrokeTransparency=0
                    plus.TextYAlignment=Enum.TextYAlignment.Center
                    x+=20
                end
            end
            row.Size=UDim2.new(1,-15,0,compactCardHeight())
            local here=entry.isLocal or entry.jobId==game.JobId
            local join=D.make('TextButton',{Name='JoinStatusButton',Text=select(1,joinPresentation(entry)),Position=UDim2.new(1,-113.5,0,27.5),Size=UDim2.fromOffset(96,35),BackgroundColor3=entry.takenConfirmed and Color3.fromRGB(235,55,65) or (entry.full or entry.unavailable) and Color3.fromRGB(255,75,85) or here and Color3.fromRGB(86,90,100) or Color3.fromRGB(40,160,85),TextColor3=Color3.new(1,1,1),TextSize=13},row)
            card.join=join
            local joinCorner=join:FindFirstChildOfClass('UICorner') or Instance.new('UICorner')
            joinCorner.CornerRadius=UDim.new(0,8);joinCorner.Parent=join
            join.Font=Enum.Font.FredokaOne
            -- Native controls preserve live labels, colors, and click behavior.
            join.Font=Enum.Font.FredokaOne;join.TextScaled=true;join.TextWrapped=false;join.TextXAlignment=Enum.TextXAlignment.Center;join.TextYAlignment=Enum.TextYAlignment.Center
            join.TextColor3=Color3.new(1,1,1);join.TextStrokeColor3=Color3.new(0,0,0);join.TextStrokeTransparency=0
            local edge=join:FindFirstChildOfClass('UIStroke') or Instance.new('UIStroke')
            edge.Name='ReferenceButtonBorder';edge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            edge.Color=Color3.fromRGB(122,67,159);edge.Thickness=2;edge.Parent=join
            local bevel=Instance.new('UIGradient');bevel.Rotation=90
            bevel.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(.72,Color3.fromRGB(225,225,225)),ColorSequenceKeypoint.new(1,Color3.fromRGB(135,135,135))});bevel.Parent=join
            card.statusGradient=bevel
            card.takenHalf=D.make('TextLabel',{Name='TakenHalf',Position=UDim2.new(0,2,0,0),Size=UDim2.new(.48,-3,1,0),BackgroundTransparency=1,Text='TAKEN',TextColor3=Color3.new(1,1,1),TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=0,Font=Enum.Font.FredokaOne,TextScaled=true,TextWrapped=false,Visible=false,ZIndex=join.ZIndex+1},join)
            card.hereHalf=D.make('TextLabel',{Name='HereHalf',Position=UDim2.new(.57,0,0,0),Size=UDim2.new(.43,-2,1,0),BackgroundTransparency=1,Text='HERE',TextColor3=Color3.new(0,0,0),TextStrokeTransparency=1,Font=Enum.Font.FredokaOne,TextScaled=true,TextWrapped=false,Visible=false,ZIndex=join.ZIndex+1},join)
            D.make('UITextSizeConstraint',{MinTextSize=1,MaxTextSize=11},card.takenHalf)
            D.make('UITextSizeConstraint',{MinTextSize=1,MaxTextSize=13},card.hereHalf)
            local caption=join:FindFirstChild('RaisedCaption')
            if caption then
                caption.Font=Enum.Font.FredokaOne;caption.TextScaled=true;caption.TextSize=20
                caption.TextStrokeTransparency=1
                caption.Position=UDim2.fromOffset(5,2);caption.Size=UDim2.new(1,-10,1,-4)
                D.make('UITextSizeConstraint',{MinTextSize=10,MaxTextSize=20},caption)
                D.make('UIStroke',{Color=Color3.new(0,0,0),Thickness=2},caption)
            end
            join.Active=not (entry.full or entry.unavailable)
            join.AutoButtonColor=not (entry.full or entry.unavailable)
            join.Selectable=not (entry.full or entry.unavailable)
            join.Activated:Connect(function()
                local entry=card.entry
                if not D.publicEntryAllowed(entry,(os.clock()+clockOffset)*1000) or entry.takenConfirmed or entry.full or entry.unavailable or joining or os.clock()<joinRetryAt or entry.jobId==game.JobId then return end
                if (os.clock()+clockOffset)*1000>=entry.expiresAt then queryStatus='Report expired; refreshing'; feedAt=0; return end
                joining=true;joiningKey=entry.key;joinRetryAt=os.clock()+0.25
                currentJoinSource='JOIN'
                joinAttemptSerial+=1
                local thisAttempt=joinAttemptSerial
                queryStatus='Joining '..entry.name
                updateCard(card,entry,card.row.LayoutOrder or 1)
                -- removed unnecessary pre-join delay
                entry=card.entry
                if not active then joining=false;joiningKey=nil;return end
                if not D.publicEntryAllowed(entry,(os.clock()+clockOffset)*1000) or entry.takenConfirmed or entry.full or entry.unavailable then
                    joining=false;joiningKey=nil;updateCard(card,entry,card.row.LayoutOrder or 1);return
                end
                if (os.clock()+clockOffset)*1000>=entry.expiresAt then
                    joining=false;joiningKey=nil;feedAt=-math.huge;top5State.render();return
                end
                if not config then
                    recordJoinError('JOIN','CONNECTION','Finder is not connected.')
                    joining=false;joiningKey=nil;queryStatus='Finder not connected';return
                end
                local claim,claimError=network(config.endpoint..'/v1/join','POST',Http:JSONEncode({placeId=entry.placeId,jobId=entry.jobId,uid=entry.uid,reporterId=reporterId,userId=D.player.UserId}),headers())
                if claim and claim.allowed~=true and (claim.unavailable or claim.full) then
                    recordJoinError('JOIN','RESERVATION',claim.error or (claim.full and 'The target server is full.' or 'The egg is no longer available.'))
                    joining=false;joiningKey=nil;joinAttemptSerial+=1;entry.full=true;entry.unavailable=claim.unavailable==true;entry.takenConfirmed=claim.takenConfirmed==true;lastRender=nil
                    queryStatus='Egg no longer available';top5State.render();return
                end
                if not claim or claim.allowed~=true then
                    recordJoinError('JOIN','RESERVATION',claim and (claim.error or 'Reservation was denied.') or claimError or 'Reservation request failed.')
                    joining=false;joiningKey=nil;joinAttemptSerial+=1;feedAt=-math.huge
                    if claim and not claim.retryable then
                        for _,item in ipairs(feed) do if item.jobId==entry.jobId then item.full=true end end
                        top5State.render()
                    end
                    queryStatus=claim and (claim.error or 'Server reserved; choose another') or ('Join reservation failed: '..tostring(claimError))
                    return
                end
                -- Best-effort background report; never block a successful JOIN on reporting.
                task.spawn(function()
                    local shared,shareError=report()
                    if not shared then warn('Pre-teleport report: '..tostring(shareError)) end
                end)
                local joinExpiry=math.min(entry.expiresAt,tonumber(claim.expiresAt) or entry.expiresAt)
                if (os.clock()+clockOffset)*1000>=joinExpiry then
                    recordJoinError('JOIN','EXPIRED','The server report expired before teleport could begin.')
                    joining=false;joiningKey=nil;joinAttemptSerial+=1;feedAt=-math.huge;entry.expiresAt=joinExpiry;top5State.render()
                    queryStatus='Reset reached; refreshing';return
                end
                queueAutoExecute()
                D.saveGuiBeforeTeleport()
                D.stopFarm()
                rememberJoinedEgg(entry)
                local ok,err=pcall(function() Teleports:TeleportToPlaceInstance(80978566387592,entry.jobId,D.player) end)
                if not ok then
                    recordJoinError('JOIN','TELEPORT',err)
                    queryStatus='Join failed: '..tostring(err)
                    joining=false;joiningKey=nil;joinAttemptSerial+=1
                else
                    task.delay(12,function()
                        if joining and joinAttemptSerial==thisAttempt then
                            recordJoinError('JOIN','TIMEOUT','Teleport was requested, but Roblox did not start the server transition within 12 seconds.')
                            joining=false;joiningKey=nil;joinAttemptSerial+=1
                        end
                    end)
                end
            end)
            end
            for _,element in ipairs(card.row:GetDescendants()) do
                if element:IsA('GuiObject') and element.Name~='CardGlow' then element.ZIndex=math.max(element.ZIndex,4) end
            end
            card.entry=entry
            updateCard(card,entry,i)
            card.row.LayoutOrder=i
            cardsByKey[entry.key]=card
            canvasHeight+=card.row.Size.Y.Offset+12
            if not checkpoint() then return end
        end
        list.CanvasSize=UDim2.fromOffset(0,canvasHeight)
        list.CanvasPosition=savedScroll
        list.Visible=true
    end
    top5State.render=function()
        if not active then return end
        if top5State.rendering then top5State.renderPending=true;return end
        top5State.rendering=true
        local ok,err=pcall(sharedRuntime.__UNKNOWN_RENDER_ONCE)
        top5State.rendering=false
        if top5State.renderPending then top5State.renderPending=false;if not top5State.renderQueued and active then
            top5State.renderQueued=true
            task.defer(function() top5State.renderQueued=false;if active then top5State.render() end end)
        end end
        if not ok then list.Visible=true;error(err) end
    end
    requestScopeRender=function()
        -- Hide old-tab rows immediately; never expose remote JOINs as MY SERVER.
        list.Visible=false
        list.CanvasPosition=Vector2.new(0,0)
        if not top5State.renderQueued and active then
            top5State.renderQueued=true
            task.defer(function() top5State.renderQueued=false;if active then top5State.render() end end)
        end
    end
    -- Old button effects disabled.
    -- Old scrollbar effects disabled.


    -- UNKNOWN reference appearance. Separate function keeps its temporary locals
    -- out of the main UI builder register budget used by Delta's Luau compiler.
    do
      local function installReferenceAppearance()
        local artwork = {
            launcherstatic = [==[]==],
            cardglow = [==[]==],
            settingsgalaxy = [==[]==],
            settingsgear = [==[]==],
            background = [==[]==],
            frame = [==[]==],
            moonback = [==[]==],
            blackhole = [==[]==],
            moon = [==[]==],
            sun = [==[]==],
        }
        local customAsset = getcustomasset or getsynasset
        local function getArt(name)
            if type(D.decodeAsset)~='function' or type(writefile)~='function' or type(readfile)~='function' or type(customAsset)~='function' then return nil end
            local artStarted=os.clock()
            local sourceType='cache'
            local ok,uri=pcall(function()
                local filename='unknown_picture_repo_v1_'..name..'.png'
                local present,bytes=pcall(readfile,filename)
                if not present or type(bytes)~='string' or bytes:sub(1,8)~='\137PNG\13\10\26\10' then
                    sourceType='download'
                    bytes=game:HttpGet('https://raw.githubusercontent.com/mostafaezzatrqm700-droid/UNKNOWN/main/'..name..'.png')
                    assert(type(bytes)=='string' and bytes:sub(1,8)=='\137PNG\13\10\26\10','Image download failed or invalid PNG: '..name)
                    writefile(filename,bytes)
                end
                return customAsset(filename)
            end)
            __mark(string.format('Image %s: %.2fs (%s%s)', name, os.clock()-artStarted, sourceType, ok and '' or ', error'))
            if not ok then warn('UNKNOWN image '..name..': '..tostring(uri)) end
            return ok and type(uri)=='string' and uri or nil
        end
        local launcherUri=getArt('launcherstatic')
        if launcherUri then
            open.Image=launcherUri;open.ImageRectSize=Vector2.new(0,0);open.ImageRectOffset=Vector2.new(0,0)
            open.ScaleType=Enum.ScaleType.Fit;open.BackgroundTransparency=1;fallback.Visible=false
        else
            warn('UNKNOWN: launcher image requires writefile and getcustomasset/getsynasset')
        end
        D.serverCardGlowUri=getArt('cardglow')
        local backgroundUri=getArt('background')
        if backgroundUri then
            panel.BackgroundTransparency=1;panel.ClipsDescendants=false
            local edge=panel:FindFirstChildOfClass('UIStroke');if edge then edge.Enabled=false end
            local background=Instance.new('ImageLabel')
            background.Name='ReferenceBackground';background.Size=UDim2.fromScale(1,1)
            background.BackgroundTransparency=1;background.ScaleType=Enum.ScaleType.Stretch
            background.Image=backgroundUri;background.Active=false;background.ZIndex=1;background.Parent=panel
            local frameUri=getArt('frame')
            if frameUri then
                local frame=Instance.new('ImageLabel');frame.Name='CurvedReferenceFrame'
                frame.BackgroundTransparency=1;frame.Active=false;frame.Image=frameUri
                frame.Position=UDim2.fromScale(-124/796,-137/1378)
                frame.Size=UDim2.fromScale(1045/796,1568/1378)
                frame.ScaleType=Enum.ScaleType.Stretch;frame.ZIndex=35;frame.Parent=panel
            end
            local function foreground(obj)
                if obj:IsA('GuiObject') and obj~=background and obj.Name~='CurvedReferenceFrame' and obj.Name~='MoonOpeningBacking' and obj.Name~='ServerDecorFrame' and obj.ZIndex<3 then obj.ZIndex=3 end
            end
            for _,obj in ipairs(panel:GetDescendants()) do foreground(obj) end
            panel.DescendantAdded:Connect(function(obj)
                if obj~=background then task.defer(function() if obj.Parent then foreground(obj) end end) end
            end)
            bar.Visible=false;heading.Visible=true;discordSubtitle.Visible=true;status.Visible=false;brandLogo.Visible=false
            local dragHandle=Instance.new('Frame');dragHandle.Name='ReferenceDragHandle'
            dragHandle.Position=UDim2.fromScale(.29,.065);dragHandle.Size=UDim2.fromScale(.42,.08)
            dragHandle.BackgroundTransparency=1;dragHandle.Active=true;dragHandle.ZIndex=15;dragHandle.Parent=panel
            draggable(panel,dragHandle,false)
            local function bounds(obj,x,y,w,h)
                obj.AnchorPoint=Vector2.new(0,0);obj.Position=UDim2.fromScale(x/832,y/1248);obj.Size=UDim2.fromScale(w/832,h/1248)
            end
            bounds(settingsButton,33,53,175,58)
            bounds(refreshButton,38,178,759,63)
            bounds(list,42,264,797,638)
            bounds(scope,33,924,374,63)
            bounds(myScope,424,924,374,63)
            bounds(serversValueFrame,33,1005,765,64)
            bounds(minValueFrame,33,1072,765,63)
            bounds(autoJoinButton,33,1146,373,70)
            bounds(smartAutoJoinButton,425,1146,373,70)
            bounds(heading,200,95,432,38)
            heading.Text='UNKNOWN';heading.Font=Enum.Font.GothamBold
            heading.TextColor3=Color3.new(1,1,1);heading.TextScaled=false;heading.TextSize=22
            heading.TextXAlignment=Enum.TextXAlignment.Center;heading.TextStrokeTransparency=1
            bounds(discordSubtitle,101,134,630,24)
            discordSubtitle.Text=DISCORD;discordSubtitle.TextXAlignment=Enum.TextXAlignment.Center
            discordSubtitle.TextColor3=Color3.new(1,1,1);discordSubtitle.Font=Enum.Font.GothamBold
            discordSubtitle.TextScaled=true;discordSubtitle.TextStrokeTransparency=1
            local limit=discordSubtitle:FindFirstChildOfClass('UITextSizeConstraint') or Instance.new('UITextSizeConstraint')
            limit.MinTextSize=7;limit.MaxTextSize=15;limit.Parent=discordSubtitle
            -- Opaque settings screen, 98% of the main panel, beneath its decorative frame.
            settingsOverlay.AnchorPoint=Vector2.new(.5,.5);settingsOverlay.Position=UDim2.fromScale(.5,.5)
            settingsOverlay.Size=UDim2.fromScale(.98,.98);settingsOverlay.BackgroundTransparency=0
            settingsOverlay.BackgroundColor3=Color3.fromRGB(8,5,15);settingsOverlay.ClipsDescendants=true
            local overlayCorner=settingsOverlay:FindFirstChildOfClass('UICorner');if overlayCorner then overlayCorner.CornerRadius=UDim.new(0,13) end
            local galaxyUri=getArt('settingsgalaxy')
            if galaxyUri then
                local galaxy=Instance.new('ImageLabel');galaxy.Name='SettingsGalaxy';galaxy.Size=UDim2.fromScale(1,1)
                galaxy.BackgroundTransparency=1;galaxy.Image=galaxyUri;galaxy.ScaleType=Enum.ScaleType.Stretch
                galaxy.Active=false;galaxy.ZIndex=30;galaxy.Parent=settingsOverlay
            end
            settingsTitle.Visible=false
            local closeSettings=Instance.new('ImageButton');closeSettings.Name='CloseSettings'
            closeSettings.BackgroundTransparency=1;closeSettings.AutoButtonColor=false
            closeSettings.Position=UDim2.fromOffset(11,4.5);closeSettings.Size=UDim2.fromOffset(48,48)
            closeSettings.Image=getArt('settingsgear') or '';closeSettings.ZIndex=33;closeSettings.Parent=settingsOverlay
            closeSettings.Activated:Connect(function() settingsOverlay.Visible=false end)
            stopScriptButton.AnchorPoint=Vector2.new(1,0);stopScriptButton.Position=UDim2.new(1,-17,0,13)
            stopScriptButton.Size=UDim2.fromOffset(92,36);stopScriptButton.Text='STOP'
            stopScriptButton.BackgroundColor3=Color3.fromRGB(180,16,49);stopScriptButton.TextSize=currentLanguage=='Arabic' and 20 or 16;stopScriptButton.Text=L('STOP','إيقاف')
            stopScriptButton.TextScaled=false;stopScriptButton.TextXAlignment=Enum.TextXAlignment.Center;stopScriptButton.ZIndex=32
            local stopCorner=stopScriptButton:FindFirstChildOfClass('UICorner') or Instance.new('UICorner')
            stopCorner.CornerRadius=UDim.new(0,10);stopCorner.Parent=stopScriptButton
            for _,button in ipairs({languageButton,autoExecuteToggle,discordAccountButton}) do
                button.BackgroundTransparency=0;button.AutoButtonColor=false;button.TextXAlignment=Enum.TextXAlignment.Center
                button.TextYAlignment=Enum.TextYAlignment.Center;button.TextStrokeTransparency=1;button.ZIndex=32
                local corner=button:FindFirstChildOfClass('UICorner') or Instance.new('UICorner')
                corner.CornerRadius=UDim.new(0,11);corner.Parent=button
            end
            languageButton.BackgroundColor3=Color3.new(0,0,0);languageButton.TextScaled=true
            local langConstraint=languageButton:FindFirstChildOfClass('UITextSizeConstraint') or Instance.new('UITextSizeConstraint')
            langConstraint.MinTextSize=10;langConstraint.MaxTextSize=20;langConstraint.Parent=languageButton
            local langEdge=languageButton:FindFirstChildOfClass('UIStroke') or Instance.new('UIStroke')
            langEdge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;langEdge.Color=Color3.fromRGB(130,120,143);langEdge.Thickness=1;langEdge.Parent=languageButton
            local autoEdge=autoExecuteToggle:FindFirstChildOfClass('UIStroke') or Instance.new('UIStroke')
            autoEdge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;autoEdge.Parent=autoExecuteToggle
            discordAccountButton.BackgroundColor3=Color3.fromRGB(47,53,142)
            local discordEdge=discordAccountButton:FindFirstChildOfClass('UIStroke') or Instance.new('UIStroke')
            discordEdge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;discordEdge.Color=Color3.fromRGB(100,107,204);discordEdge.Thickness=1;discordEdge.Parent=discordAccountButton
            refreshAutoExecuteToggle()
            settingsButton.BackgroundTransparency=1;settingsButton.TextTransparency=1
            settingsButton.AnchorPoint=Vector2.new(0,0);settingsButton.Position=UDim2.fromOffset(16,14)
            settingsButton.Size=UDim2.fromOffset(48,48)
            local gearUri=getArt('settingsgear')
            if gearUri then
                local gear=Instance.new('ImageLabel');gear.Name='SettingsGear'
                gear.BackgroundTransparency=1;gear.Active=false;gear.Size=UDim2.fromScale(1,1)
                gear.Image=gearUri;gear.ScaleType=Enum.ScaleType.Fit;gear.ZIndex=settingsButton.ZIndex+1;gear.Parent=settingsButton
            else settingsButton.TextTransparency=0;settingsButton.Text='⚙' end
            refreshButton.AnchorPoint=Vector2.new(.5,0)
            refreshButton.Position=UDim2.new(.5,0,178/1248,0)
            refreshButton.Size=UDim2.fromOffset(347,34)
            refreshButton.BackgroundColor3=Color3.new(1,1,1);refreshButton.BackgroundTransparency=.60;refreshButton.Active=false
            local fill=Instance.new('UIGradient');fill.Name='ResetPurpleFill';fill.Rotation=90
            fill.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(34,0,80)),ColorSequenceKeypoint.new(.45,Color3.fromRGB(66,10,130)),ColorSequenceKeypoint.new(1,Color3.fromRGB(43,8,88))});fill.Parent=refreshButton
            local resetCorner=refreshButton:FindFirstChildOfClass('UICorner') or Instance.new('UICorner')
            resetCorner.CornerRadius=UDim.new(1,0);resetCorner.Parent=refreshButton
            local resetEdge=refreshButton:FindFirstChildOfClass('UIStroke') or Instance.new('UIStroke')
            resetEdge.Name='ResetOutline';resetEdge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            resetEdge.Color=Color3.fromRGB(125,75,161);resetEdge.Thickness=2.05;resetEdge.Parent=refreshButton
            resetTimer.TextXAlignment=Enum.TextXAlignment.Center;resetTimer.Font=Enum.Font.GothamBold
            resetTimer.TextScaled=false;resetTimer.TextSize=14;resetTimer.TextStrokeTransparency=1
            list.BackgroundTransparency=1;list.ScrollBarThickness=0 -- preserve touch scrolling
            local function style(button)
                button.BackgroundColor3=Color3.fromRGB(25,13,40);button.TextColor3=Color3.fromRGB(248,238,255)
                button.Font=Enum.Font.GothamBold;button.AutoButtonColor=false;button.TextStrokeTransparency=1
                local corner=button:FindFirstChildOfClass('UICorner') or Instance.new('UICorner')
                for _,child in ipairs(button:GetChildren()) do if child:IsA('UICorner') and child~=corner then child:Destroy() end end
                corner.CornerRadius=UDim.new(0,11);corner.Parent=button
                local stroke=button:FindFirstChildOfClass('UIStroke') or Instance.new('UIStroke')
                stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;stroke.Color=Color3.fromRGB(112,62,149);stroke.Thickness=1;stroke.Parent=button
            end
            for _,button in ipairs({scope,myScope,autoJoinButton,smartAutoJoinButton}) do style(button) end
            for _,button in ipairs({autoJoinButton,smartAutoJoinButton}) do
                button.TextScaled=false;button.TextSize=12;button.TextStrokeColor3=Color3.new(0,0,0);button.TextStrokeTransparency=0
            end
            styleScope();paintAutoJoin()
            for _,frame in ipairs({serversValueFrame,minValueFrame}) do
                frame.BackgroundColor3=Color3.fromRGB(23,18,31);frame.BackgroundTransparency=0
                frame.ClipsDescendants=true
                local corner=frame:FindFirstChildOfClass('UICorner');if corner then corner.CornerRadius=UDim.new(0,11) end
            end
            for _,label in ipairs({serversValueLabel,minValueLabel}) do
                label.Position=UDim2.new(0,currentLanguage=='Arabic' and (label==serversValueLabel and 6 or 1) or 8,0,0);label.Size=UDim2.new(.61,-12,1,0)
                label.TextXAlignment=Enum.TextXAlignment.Left;label.TextScaled=false;label.TextSize=13
                label.Font=Enum.Font.GothamBold;label.TextStrokeTransparency=1
            end
            for _,input in ipairs({serversValueInput,minValueInput}) do
                input.Position=UDim2.new(.64,4,0,5);input.Size=UDim2.new(.36,-13,1,-10)
                input.BackgroundTransparency=0;input.TextScaled=false;input.TextSize=15
                local corner=input:FindFirstChildOfClass('UICorner') or Instance.new('UICorner');corner.CornerRadius=UDim.new(0,12);corner.Parent=input
            end
            for _,input in ipairs({serversValueInput,minValueInput}) do input.BackgroundColor3=Color3.fromRGB(38,16,58);input.TextColor3=Color3.new(1,1,1) end
            local function ornament(name,pos,size)
                local uri=getArt(name);if not uri then warn('UNKNOWN: could not load artwork: '..name);return end
                local image=Instance.new('ImageLabel');image.Name='Ornament_'..name
                image.BackgroundTransparency=1;image.Active=false;image.AnchorPoint=Vector2.new(.5,.5)
                image.Position=pos;image.Size=size;image.ScaleType=Enum.ScaleType.Fit
                image.Image=uri;image.ZIndex=36;image.Parent=panel
            end
            -- Backing belongs only to the crescent opening; it stays behind the frame and moon.
            local moonBackingUri=getArt('moonback')
            if moonBackingUri then
                local backing=Instance.new('ImageLabel');backing.Name='MoonOpeningBacking'
                backing.AnchorPoint=Vector2.new(.5,.5);backing.Position=UDim2.new(0,0,.475,0)
                backing.Size=UDim2.fromOffset(70,70);backing.BackgroundTransparency=1
                backing.Image=moonBackingUri;backing.ScaleType=Enum.ScaleType.Fit
                backing.Active=false;backing.ZIndex=2;backing.Parent=panel
            end
            ornament('blackhole',UDim2.new(.5,0,0,0),UDim2.fromOffset(185,109))
            ornament('moon',UDim2.new(0,0,.475,0),UDim2.fromOffset(70,70))
            ornament('sun',UDim2.new(1,0,.475,0),UDim2.fromOffset(80,80))
        else
            warn('UNKNOWN: image assets unavailable; display requires writefile and getcustomasset/getsynasset')
        end
      end
      __mark("Artwork setup starts")
      installReferenceAppearance()
      __mark("Artwork setup complete")
    end

    fitFinder()
    panel.Visible=true
    Teleports.TeleportInitFailed:Connect(function(who,_,message)
        if active and who==D.player then
            local failureText=tostring(message or 'Teleport failed')
            local lowerFailure=failureText:lower()
            local serverIsFull=lowerFailure:find('full',1,true)~=nil
            local failedJobId=nil
            if joiningKey then
                for _,item in ipairs(feed) do
                    if item.key==joiningKey then failedJobId=item.jobId;break end
                end
                if not failedJobId then
                    for _,item in ipairs(autoJoinFeed) do
                        if item.key==joiningKey then failedJobId=item.jobId;break end
                    end
                end
            end
            recordJoinError(currentJoinSource,'ROBLOX TELEPORT',failureText)
            joining=false;joinAttemptSerial+=1
            if serverIsFull and failedJobId then
                -- Roblox is the final authority: once it rejects this instance as full,
                -- immediately change every visible copy from JOIN to FULL.
                for _,item in ipairs(feed) do
                    if item.jobId==failedJobId then item.full=true end
                end
                for _,item in ipairs(autoJoinFeed) do
                    if item.jobId==failedJobId then item.full=true end
                end
                for _,card in pairs(cardsByKey) do
                    if card.entry and card.entry.jobId==failedJobId then
                        card.entry.full=true
                        updateCard(card,card.entry,card.row.LayoutOrder or 1)
                    end
                end
                lastRender=nil
                queryStatus='Server is FULL (Roblox rejected the join)'
                if (autoJoinEnabled or smartAutoJoinEnabled) and autoJoinCandidateIndex<=#autoJoinCandidates then
                    autoJoinCandidateIndex+=1
                    autoJoinRetryRequested=true
                    queryStatus=(smartAutoJoinEnabled and 'Server FULL; Smart Auto Join is trying the next candidate' or 'Server FULL; Auto Join is trying the next candidate')
                end
            else
                queryStatus='Join failed: '..failureText
                if (autoJoinEnabled or smartAutoJoinEnabled) and autoJoinCandidateIndex<=#autoJoinCandidates then
                    autoJoinCandidateIndex+=1
                    autoJoinRetryRequested=true
                    queryStatus=(smartAutoJoinEnabled and 'Smart Auto Join: teleport failed; trying the next candidate' or 'Auto Join: teleport failed; trying the next candidate')
                end
            end
            joiningKey=nil
            top5State.render()
        end
    end)
    D.gui.Destroying:Connect(function() active=false;if localHighlight then localHighlight:Destroy() end end)
    task.spawn(function()
        local lastReport=-math.huge
        local lastReportAttempt=-math.huge
        local lastPeakSignature=nil
        while active do
            local ok,err=pcall(function()
                if networkBusy then return end
                if not config or os.clock()-configAt>60 then local success,message=loadConfig(); if not success then error(message) end end
                local peak=snapshot()
                local parts={}
                for i=1,math.min(10,#peak) do
                    local egg=peak[i]
                    parts[#parts+1]=table.concat({
                        tostring(egg.uid or ''),
                        tostring(egg.rate or ''),
                        tostring(egg.scale or ''),
                        tostring(egg.weight or ''),
                        tostring(egg.mutations or ''),
                        tostring(egg.traitsKnown),
                        tostring(egg.source or '')
                    },':')
                end
                local signature=table.concat(parts,';')
                local now=os.clock()
                local heartbeatDue=now-lastReport>=broadcastInterval
                local snapshotChanged=#parts>0 and signature~=lastPeakSignature
                local changeDue=snapshotChanged and now-lastReportAttempt>=0.1
                if heartbeatDue or changeDue then
                    lastReportAttempt=now
                    local success,message=report()
                    if success then lastPeakSignature=signature;lastReport=now end
                    reportStatus=message
                    if not success then warn('Tenshi broadcast: '..tostring(message)) end
                end
                if os.clock()-feedAt>=0.1 then local success,message=refresh(autoJoinEnabled); if not success then queryStatus='Finder: '..tostring(message) end end
            end)
            if not ok then reportStatus='BCAST: '..tostring(err);queryStatus=tostring(err);warn('Tenshi broadcast: '..tostring(err)) end
            task.wait(0.1)
        end
    end)
    task.spawn(function()
        while active do
            local gameClockTime=game:GetService('Lighting').ClockTime
            local isNight=gameClockTime>=18 or gameClockTime<6
            if isNight and not takenEggNightCleanupDone then
                local tracked=D.joinedEgg
                if type(tracked)=='table' and type(tracked.takenAt)=='number' then
                    -- Permanently remove this joined egg's TAKEN card at nightfall.
                    takenEggNightCleanupDone=true
                    joinedEgg=nil
                    D.joinedEgg=nil
                    pcall(function() Teleports:SetTeleportSetting(joinedEggSettingKey,false) end)
                end
            end
            status.Text=joining and 'Joining serverâ¦' or tostring(queryStatus)
            local cycle=cycleInfo()
            if cycle then
                local seconds=math.max(0,math.ceil(cycle.remaining))
                resetTimer.Text=cycle.running and string.format(L('Reset','إعادة الضبط')..' %02d:%02d',math.floor(seconds/60),seconds%60) or L('Reset stopped','إعادة الضبط متوقف')
                resetTimer.TextColor3=cycle.running and seconds<=60 and Color3.fromRGB(255,85,85) or cycle.running and seconds<=150 and Color3.fromRGB(255,215,65) or Color3.fromRGB(230,245,255)
            else
                resetTimer.Text=L('Reset --:--','إعادة الضبط --:--')
                resetTimer.TextColor3=Color3.fromRGB(230,245,255)
            end
            sharingNotice.Visible=false
            local ok=pcall(top5State.render)
            if not ok then queryStatus='Unable to display finder feed' end
            task.wait(0.1)
        end
    end)
end


local function run()
    __mark("Game modules start")
    local EggState=module('Client.EggState')
    local Assets=module('Data.Assets')
    local States=module('Shared.Types.AreaEggs').States
    local mutations,eggRecords
    pcall(function() mutations=module('Shared.Modules.Mutations') end)
    pcall(function() eggRecords=module('Shared.Util.EggRecords') end)
    __mark("Game modules loaded")
    assert(type(EggState.ReadFieldEggs)=='function','ReadFieldEggs unavailable')
    assert(type(Assets.Directory)=='table' and States and States.Slot~=nil,'Game schema changed')
    local latestEntries={}
    local latestMetadata=nil
    local scanCycle
    pcall(function() scanCycle=module('Shared.Util.AreaEggCycle') end)
    local function parseValue(text)
        local amount,suffix=tostring(text):gsub(',',''):match('^%s*%$?%s*(%d+%.?%d*)%s*(%a*)%s*$')
        local powers={['']=1,k=1e3,m=1e6,b=1e9,t=1e12,qa=1e15,qi=1e18}
        local factor=suffix and powers[suffix:lower()]
        if not amount or not factor then return nil end
        local value=tonumber(amount)*factor
        return valid(value) and value or nil
    end
    local lastScan=0
    __mark("Interface build starts")
    createFinder({gui=gui,localPanel={Visible=false},player=player,make=make,label=label,entries=function() return os.clock()-lastScan<10 and latestEntries or {} end,metadata=function() return latestMetadata end,ready=function() return lastScan>0 and os.clock()-lastScan<10 end,parseValue=parseValue,money=money,stopFarm=function() end,stopScript=function() alive=false; if errorConnection then pcall(function() errorConnection:Disconnect() end);errorConnection=nil end; if errorGui and errorGui.Parent then pcall(function() errorGui:Destroy() end) end; if gui and gui.Parent then pcall(function() gui:Destroy() end) end end})
    __mark("Interface build complete / ready")
    gui:SetAttribute("UNKNOWN_READY", true)
    local notified={}
    while alive do
        local ok,err=pcall(function()
            local scanStartedClock=os.clock()
            local snapshot=EggState.ReadFieldEggs()
            assert(type(snapshot)=='table' and type(snapshot.Records)=='table','Field snapshot unavailable')
            local eggs,seen={},{}
            local fieldCount,missingIncome=0,0
            local fieldStates={}
            local scanAt=workspace:GetServerTimeNow()*1000
            local resetAt
            if scanCycle then pcall(function() if scanCycle.IsRunning() then resetAt=scanCycle.NextResetTime(scanAt/1000)*1000 end end) end
            for recordKey,record in pairs(snapshot.Records) do
                fieldStates[#fieldStates+1]={uid=tostring(record.Uid or recordKey),state=record.State}
                if record.State==States.Slot or record.State==States.Carried or record.State==States.Dropped or record.State==States.GuardCarried then
                    local asset=Assets.Directory[record.AssetCategory] or {}
                    local rarity=asset.Rarity or {}
                    local uid=record.Uid or recordKey
                    local model=modelFor(uid)
                    local scale=numberField(record,{'AssetScale'})
                    local weight
                    if eggRecords and type(eggRecords.WeightKg)=='function' then
                        local good,result=pcall(eggRecords.WeightKg,record)
                        if good and valid(result) then weight=result end
                    end
                    local rate=displayedRate(model)
                    local estimated=false
                    if not rate then
                        rate=computedRate(asset.EarningRate,scale,record.Mutations or {},mutations)
                        estimated=rate~=nil
                    end
                    fieldCount=fieldCount+1
                    seen[tostring(uid)]=true
                    local traits,traitsKnown=readTraitNames(record)
                    table.insert(eggs,{key='field:'..tostring(uid),uid=uid,fieldState=record.State,bottomCFrame=record.BottomCFrame,traitsKnown=traitsKnown,category=record.AssetCategory,areaKey=record.AreaId,worldPos=typeof(record.BottomCFrame)=='CFrame' and record.BottomCFrame.Position or nil,area=tostring(record.AreaId)..' | Mut: '..(#traits>0 and table.concat(traits,', ') or traitsKnown and 'None' or 'UNKNOWN'),model=model,icon=asset.Icon,name=asset.DisplayName or record.AssetCategory or 'Unknown',rarity=rarity.DisplayName or rarity._id or 'Unknown',tier=tonumber(rarity.Rank) or 0,color=typeof(rarity.Color)=='Color3' and rarity.Color or Color3.new(1,1,1),scale=scale,weight=weight,rate=rate,estimated=estimated})
                end
            end
            -- One numeric value drives both display and ordering.
            for _,entry in ipairs(eggs) do
                entry.rate=entry.rate or entry.unmutatedRate
            end
            for _,entry in ipairs(eggs) do
                entry.mutationText=tostring(entry.area or ''):match('Mut:%s*(.*)') or ''
            end
            latestEntries=eggs
            latestMetadata={states=fieldStates,resetAt=resetAt,scanAt=scanAt,scanClock=scanStartedClock}
            lastScan=os.clock()
        end)
        if not ok then warn('NYX Finder scan:',err) end
        task.wait(1)
    end
end
 task.spawn(function()
    local ok,err=pcall(run)
    if not ok then
        local env = _G
        pcall(function() if type(getgenv) == "function" then env = getgenv() end end)
        if type(env) == "table" then env.__UNKNOWN_START_ERROR = tostring(err) end
        warn('NYX Finder startup:',err)
    end
end)
end

-- Startup; access is controlled by the published LuaProtect loader.
local startupOk, startupError = pcall(startUnknown)
if not startupOk then
    warn("[UNKNOWN STARTUP ERROR] " .. tostring(startupError))
end
