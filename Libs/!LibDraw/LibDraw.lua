-- LubDraw by docbrown on fh-wow.com

--local LibDraw
local sin, cos, atan, atan2, sqrt, rad = math.sin, math.cos, math.atan, math.atan2, math.sqrt, math.rad
local tinsert, tremove = tinsert, tremove


local function WorldToScreen (wX, wY, wZ)
	if wZ == nil then wZ = select(3,GetObjectPosition("player")) end
	local sX, sY = _G.WorldToScreen(wX, wY, wZ);
	if sX and sY then
		return sX, -(WorldFrame:GetTop() - sY);
	else
		return sX, sY;
	end
end

if LibStub then
	-- LibStub version control
	LibDraw = LibStub:NewLibrary("LibDraw-1.0", 3)
	if not LibDraw then return end
else
	-- Pretty much LibStub
	LibDraw = {
		version = 1.3
	}
	if _G['LibDraw'] and _G['LibDraw'].version and _G['LibDraw'].version > LibDraw.version then
		return
	else
		_G['LibDraw'] = LibDraw
	end
end

LibDraw.line = LibDraw.line or { r = 0, g = 1, b = 0, a = 1, w = 1 }
LibDraw.level = "BACKGROUND"
LibDraw.callbacks = { }

if not LibDraw.canvas then
	LibDraw.canvas = CreateFrame("Frame", WorldFrame)
	LibDraw.canvas:SetAllPoints(WorldFrame)
  LibDraw.lines = { }
  LibDraw.lines_used = { }
	LibDraw.textures = { }
	LibDraw.textures_used = { }
	LibDraw.fontstrings = { }
	LibDraw.fontstrings_used = { }
end

function LibDraw.SetColor(r, g, b, a)
	LibDraw.line.r = r * 0.00390625
	LibDraw.line.g = g * 0.00390625
	LibDraw.line.b = b * 0.00390625
	if a then
		LibDraw.line.a = a * 0.01
	else
		LibDraw.line.a = 1
	end
end

function LibDraw.SetColorRaw(r, g, b, a)
	LibDraw.line.r = r
	LibDraw.line.g = g
	LibDraw.line.b = b
	LibDraw.line.a = a
end

function LibDraw.SetWidth(w)
	LibDraw.line.w = w
end

function LibDraw.Line(sx, sy, sz, ex, ey, ez)
	if not WorldToScreen then return end

	local sx, sy = WorldToScreen(sx, sy, sz)
	local ex, ey = WorldToScreen(ex, ey, ez)

	LibDraw.Draw2DLine(sx, sy, ex, ey)
end

function LibDraw.rotateX(cx, cy, cz, px, py, pz, r)
	if r == nil then return px, py, pz end
	local s = sin(r)
	local c = cos(r)
	-- center of rotation
	px, py, pz = px - cx,  py - cy, pz - cz
	local x = px + cx
	local y = ((py * c - pz * s) + cy)
	local z = ((py * s + pz * c) + cz)
	return x, y, z
end

function LibDraw.rotateY(cx, cy, cz, px, py, pz, r)
	if r == nil then return px, py, pz end
	local s = sin(r)
	local c = cos(r)
	-- center of rotation
	px, py, pz = px - cx,  py - cy, pz - cz
	local x = ((pz * s + px * c) + cx)
	local y = py + cy
	local z = ((pz * c - px * s) + cz)
	return x, y, z
end

function LibDraw.rotateZ(cx, cy, cz, px, py, pz, r)
	if r == nil then return px, py, pz end
	local s = sin(r)
	local c = cos(r)
	-- center of rotation
	px, py, pz = px - cx,  py - cy, pz - cz
	local x = ((px * c - py * s) + cx)
	local y = ((px * s + py * c) + cy)
	local z = pz + cz
	return x, y, z
end

function LibDraw.Array(vectors, x, y, z, rotationX, rotationY, rotationZ)
	for _, vector in ipairs(vectors) do
		local sx, sy, sz = x+vector[1], y+vector[2], z+vector[3]
		local ex, ey, ez = x+vector[4], y+vector[5], z+vector[6]

		if rotationX then
			sx, sy, sz = LibDraw.rotateX(x, y, z, sx, sy, sz, rotationX)
			ex, ey, ez = LibDraw.rotateX(x, y, z, ex, ey, ez, rotationX)
		end
		if rotationY then
			sx, sy, sz = LibDraw.rotateY(x, y, z, sx, sy, sz, rotationY)
			ex, ey, ez = LibDraw.rotateY(x, y, z, ex, ey, ez, rotationY)
		end
		if rotationZ then
			sx, sy, sz = LibDraw.rotateZ(x, y, z, sx, sy, sz, rotationZ)
			ex, ey, ez = LibDraw.rotateZ(x, y, z, ex, ey, ez, rotationZ)
		end

		local sx, sy = WorldToScreen(sx, sy, sz)
		local ex, ey = WorldToScreen(ex, ey, ez)
		LibDraw.Draw2DLine(sx, sy, ex, ey)
	end
end

function LibDraw.Draw2DLine(sx, sy, ex, ey)

	if not WorldToScreen or not sx or not sy or not ex or not ey then return end

	local L = tremove(LibDraw.lines) or false
	if L == false then
		L = CreateFrame("Frame", LibDraw.canvas)
    L.line = L:CreateLine()
		L.line:SetDrawLayer(LibDraw.level)
	end
	tinsert(LibDraw.lines_used, L)

  L:ClearAllPoints()

  if sx > ex and sy > ey or  sx < ex and sy < ey  then
    L:SetPoint("TOPRIGHT", LibDraw.canvas, "TOPLEFT", sx, sy)
    L:SetPoint("BOTTOMLEFT", LibDraw.canvas, "TOPLEFT", ex, ey)
    L.line:SetStartPoint('TOPRIGHT')
    L.line:SetEndPoint('BOTTOMLEFT')
  elseif sx < ex and sy > ey then
    L:SetPoint("TOPLEFT", LibDraw.canvas, "TOPLEFT", sx, sy)
    L:SetPoint("BOTTOMRIGHT", LibDraw.canvas, "TOPLEFT", ex, ey)
    L.line:SetStartPoint('TOPLEFT')
    L.line:SetEndPoint('BOTTOMRIGHT')
  elseif sx > ex and sy < ey then
    L:SetPoint("TOPRIGHT", LibDraw.canvas, "TOPLEFT", sx, sy)
    L:SetPoint("BOTTOMLEFT", LibDraw.canvas, "TOPLEFT", ex, ey)
    L.line:SetStartPoint('TOPLEFT')
    L.line:SetEndPoint('BOTTOMRIGHT')
  else
    -- wat, I don't like this, not one bit
    L:SetPoint("TOPLEFT", LibDraw.canvas, "TOPLEFT", sx, sy)
    L:SetPoint("BOTTOMLEFT", LibDraw.canvas, "TOPLEFT", sx, ey)
    L.line:SetStartPoint('TOPLEFT')
    L.line:SetEndPoint('BOTTOMLEFT')
  end

  L.line:SetThickness(LibDraw.line.w)
	L.line:SetColorTexture(LibDraw.line.r, LibDraw.line.g, LibDraw.line.b, LibDraw.line.a)

	L:Show()

end

local full_circle = rad(365)
local small_circle_step = rad(3)

function LibDraw.Circle(x, y, z, size)
	local lx, ly, nx, ny, fx, fy = false, false, false, false, false, false
	for v=0, full_circle, small_circle_step do
		nx, ny = WorldToScreen( (x+cos(v)*size), (y+sin(v)*size), z )
		LibDraw.Draw2DLine(lx, ly, nx, ny)
		lx, ly = nx, ny
	end
end

local flags = bit.bor(0x100)

function LibDraw.GroundCircle(x, y, z, size)
	local lx, ly, nx, ny, fx, fy, fz = false, false, false, false, false, false, false
	for v=0, full_circle, small_circle_step do
		fx, fy, fz = TraceLine(  (x+cos(v)*size), (y+sin(v)*size), z+100, (x+cos(v)*size), (y+sin(v)*size), z-100, flags )
		if fx == nil then
			fx, fy, fz = (x+cos(v)*size), (y+sin(v)*size), z
		end
		nx, ny = WorldToScreen( (fx+cos(v)*size), (fy+sin(v)*size), fz )
		LibDraw.Draw2DLine(lx, ly, nx, ny)
		lx, ly = nx, ny
	end
end

function LibDraw.Arc(x, y, z, size, arc, rotation)
	local lx, ly, nx, ny, fx, fy = false, false, false, false, false, false
	local half_arc = arc * 0.5
	local ss = (arc/half_arc)
	local as, ae = -half_arc, half_arc
	for v = as, ae, ss do
		nx, ny = WorldToScreen( (x+cos(rotation+rad(v))*size), (y+sin(rotation+rad(v))*size), z )
		if lx and ly then
			LibDraw.Draw2DLine(lx, ly, nx, ny)
		else
			fx, fy = nx, ny
		end
		lx, ly = nx, ny
	end
	local px, py = WorldToScreen(x, y, z)
	LibDraw.Draw2DLine(px, py, lx, ly)
	LibDraw.Draw2DLine(px, py, fx, fy)
end

function LibDraw.Texture(config, x, y, z, alphaA)

	local texture, width, height = config.texture, config.width, config.height
	local left, right, top, bottom, scale =  config.left, config.right, config.top, config.bottom, config.scale
	local alpha = config.alpha or alphaA

	if not WorldToScreen or not texture or not width or not height or not x or not y or not z then return end
	if not left or not right or not top or not bottom then
		left = 0
		right = 1
		top = 0
		bottom = 1
	end
	if not scale then
		local cx, cy, cz = GetCameraPosition()
		scale = width / LibDraw.Distance(x, y, z, cx, cy, cz)
	end

	local sx, sy = WorldToScreen(x, y, z)
	if not sx or not sy then return end
	local w = width * scale
	local h = height * scale
	sx = sx - w*0.5
	sy = sy + h*0.5
	local ex, ey = sx + w, sy - h

	local T = tremove(LibDraw.textures) or false
	if T == false then
		T = LibDraw.canvas:CreateTexture(nil, "BACKGROUND")
		T:SetDrawLayer(LibDraw.level)
		T:SetTexture(LibDraw.texture)
	end
	tinsert(LibDraw.textures_used, T)
	T:ClearAllPoints()
	T:SetTexCoord(left, right, top, bottom)
	T:SetTexture(texture)
	T:SetWidth(width)
	T:SetHeight(height)
	T:SetPoint("TOPLEFT", LibDraw.canvas, "TOPLEFT", sx, sy)
	T:SetPoint("BOTTOMRIGHT", LibDraw.canvas, "TOPLEFT", ex, ey)
	T:SetVertexColor(1, 1, 1, 1)
	if alpha then T:SetAlpha(alpha) else T:SetAlpha(1) end
	T:Show()

end

function LibDraw.Text(text, font, x, y, z)

	local sx, sy = WorldToScreen(x, y, z)

	if sx and sy then

		local F = tremove(LibDraw.fontstrings) or LibDraw.canvas:CreateFontString(nil, "BACKGROUND")

		F:SetFontObject(font)
		F:SetText(text)
		F:SetTextColor(LibDraw.line.r, LibDraw.line.g, LibDraw.line.b, LibDraw.line.a)

		if p then
			local width = F:GetStringWidth() - 4
			local offsetX = width*0.5
			local offsetY = F:GetStringHeight() + 3.5
			local pwidth = width*p*0.01
			FHAugment.drawLine(sx-offsetX, sy-offsetY, (sx+offsetX), sy-offsetY, 4, r, g, b, 0.25)
			FHAugment.drawLine(sx-offsetX, sy-offsetY, (sx+offsetX)-(width-pwidth), sy-offsetY, 4, r, g, b, 1)
		end

		F:SetPoint("TOPLEFT", UIParent, "TOPLEFT", sx-(F:GetStringWidth()*0.5), sy)
		F:Show()

		tinsert(LibDraw.fontstrings_used, F)

	end

end

local rad90 = math.rad(-90)

function LibDraw.Box(x, y, z, width, height, rotation, offset_x, offset_y)

	if not offset_x then offset_x = 0 end
	if not offset_y then offset_y = 0 end

	if rotation then rotation = rotation + rad90 end

	local half_width = width * 0.5
	local half_height = height * 0.5

	local p1x, p1y = LibDraw.rotateZ(x, y, z, x - half_width + offset_x, y - half_width + offset_y, z, rotation)
	local p2x, p2y = LibDraw.rotateZ(x, y, z, x + half_width + offset_x, y - half_width + offset_y, z, rotation)
	local p3x, p3y = LibDraw.rotateZ(x, y, z, x - half_width + offset_x, y + half_width + offset_y, z, rotation)
	local p4x, p4y = LibDraw.rotateZ(x, y, z, x - half_width + offset_x, y - half_width + offset_y, z, rotation)
	local p5x, p5y = LibDraw.rotateZ(x, y, z, x + half_width + offset_x, y + half_width + offset_y, z, rotation)
	local p6x, p6y = LibDraw.rotateZ(x, y, z, x + half_width + offset_x, y - half_width + offset_y, z, rotation)
	local p7x, p7y = LibDraw.rotateZ(x, y, z, x - half_width + offset_x, y + half_width + offset_y, z, rotation)
	local p8x, p8y = LibDraw.rotateZ(x, y, z, x + half_width + offset_x, y + half_width + offset_y, z, rotation)

	LibDraw.Line(p1x, p1y, z, p2x, p2y, z)
	LibDraw.Line(p3x, p3y, z, p4x, p4y, z)
	LibDraw.Line(p5x, p5y, z, p6x, p6y, z)
	LibDraw.Line(p7x, p7y, z, p8x, p8y, z)

end

local deg45 = math.rad(45)
local arrowX = {
	{ 0  , 0, 0, 1.5,  0,    0   },
	{ 1.5, 0, 0, 1.2,  0.2, -0.2 },
	{ 1.5, 0, 0, 1.2, -0.2,  0.2 }
}
local arrowY = {
	{ 0, 0  , 0,  0  , 1.5,  0   },
	{ 0, 1.5, 0,  0.2, 1.2, -0.2 },
	{ 0, 1.5, 0, -0.2, 1.2,  0.2 }
}
local arrowZ = {
	{ 0, 0, 0  ,  0,    0,   1.5 },
	{ 0, 0, 1.5,  0.2, -0.2, 1.2 },
	{ 0, 0, 1.5, -0.2,  0.2, 1.2 }
}

function LibDraw.DrawHelper()
	local playerX, playerY, playerZ = ObjectPosition("player")
	local old_red, old_green, old_blue, old_alpha, old_width = LibDraw.line.r, LibDraw.line.g, LibDraw.line.b, LibDraw.line.a, LibDraw.line.w

	-- X
	LibDraw.SetColor(255, 0, 0, 100)
	LibDraw.SetWidth(1)
	LibDraw.Array(arrowX, playerX, playerY, playerZ, deg45, false, false)
	LibDraw.Text('X', "GameFontNormal", playerX + 1.75, playerY, playerZ)
	-- Y
	LibDraw.SetColor(0, 255, 0, 100)
	LibDraw.SetWidth(1)
	LibDraw.Array(arrowY, playerX, playerY, playerZ, false, -deg45, false)
	LibDraw.Text('Y', "GameFontNormal", playerX, playerY + 1.75, playerZ)
	-- Z
	LibDraw.SetColor(0, 0, 255, 100)
	LibDraw.SetWidth(1)
	LibDraw.Array(arrowZ, playerX, playerY, playerZ, false, false, false)
	LibDraw.Text('Z', "GameFontNormal", playerX, playerY, playerZ + 1.75)

	LibDraw.line.r, LibDraw.line.g, LibDraw.line.b, LibDraw.line.a, LibDraw.line.w = old_red, old_green, old_blue, old_alpha, old_width
end

function LibDraw.Distance(ax, ay, az, bx, by, bz)
	return math.sqrt(((bx-ax)*(bx-ax)) + ((by-ay)*(by-ay)) + ((bz-az)*(bz-az)))
end

function LibDraw.Camera()
	local fX, fY, fZ = ObjectPosition("player")
	local sX, sY, sZ = GetCameraPosition()
	return sX, sY, sZ, atan2(sY - fY, sX - fX), atan((sZ - fZ) / sqrt(((fX - sX) ^ 2) + ((fY - sY) ^ 2)))
end

function LibDraw.Sync(callback)
	tinsert(LibDraw.callbacks, callback)
end

function LibDraw.clearCanvas()
	-- LibDraw.stats = #LibDraw.textures_used
	for i = #LibDraw.textures_used, 1, -1 do
		LibDraw.textures_used[i]:Hide()
		tinsert(LibDraw.textures, tremove(LibDraw.textures_used))
	end
	for i = #LibDraw.fontstrings_used, 1, -1 do
		LibDraw.fontstrings_used[i]:Hide()
		tinsert(LibDraw.fontstrings, tremove(LibDraw.fontstrings_used))
	end
  for i = #LibDraw.lines_used, 1, -1 do
		LibDraw.lines_used[i]:Hide()
		tinsert(LibDraw.lines, tremove(LibDraw.lines_used))
	end
end

local function OnUpdate()
	LibDraw.clearCanvas()
	for _, callback in ipairs(LibDraw.callbacks) do
		callback()
		if LibDraw.helper then
			LibDraw.DrawHelper()
		end
		LibDraw.helper = false
	end
end

function LibDraw.Enable(interval)
	local timer
	if not interval then
		timer = C_Timer.NewTicker(interval, OnUpdate)
	else
		timer = C_Timer.NewTicker(interval, OnUpdate)
	end
	return timer
end

--LibDraw.canvas:SetScript("OnUpdate", OnUpdate)