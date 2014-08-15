--   _  _   _ ___  ___  ___   _   --
--  /,\| | | | , |/ _ \| , | /,\  --
-- / _ | |_| |   \ (_) |   \/ _ \ --
--/_/ \_\__,_|_|\_\___/|_|\_\/ \_\--
local alpha, useButtonGradientColour
local addon, core = ...

core[1] = {}
core[2] = {}

Aurora = core

AuroraConfig = {}

local F, C = unpack(select(2, ...))

local _G = getfenv(0);
local select = select;
local pairs = pairs;
local pcall = pcall;
local type = type;

C.ClassColors = {
	['HUNTER'] = { r = 0.58, g = 0.86, b = 0.49 },
	['WARLOCK'] = { r = 0.6, g = 0.47, b = 0.85 },
	['PALADIN'] = { r = 1, g = 0.22, b = 0.52 },
	['PRIEST'] = { r = 0.8, g = 0.87, b = .9 },
	['MAGE'] = { r = 0, g = 0.76, b = 1 },
	['ROGUE'] = { r = 1, g = 0.91, b = 0.2 },
	['DRUID'] = { r = 1, g = 0.49, b = 0.04 },
	['SHAMAN'] = { r = 0, g = 0.6, b = 0.6 };
	['WARRIOR'] = { r = 0.9, g = 0.65, b = 0.45 },
	['DEATHKNIGHT'] = { r = 0.77, g = 0.12 , b = 0.23 },
}

C.Media = {
	['ArrowUp'] = [[Interface\AddOns\Aurora\Media\Arrow-Up-Active]],
	['ArrowDown'] = [[Interface\AddOns\Aurora\Media\Arrow-Down-Active]],
	['ArrowLeft'] = [[Interface\AddOns\Aurora\Media\Arrow-Left-Active]],
	['ArrowRight'] = [[Interface\AddOns\Aurora\Media\Arrow-Right-Active]],
	['Backdrop'] = [[Interface\BUTTONS\WHITE8X8]],
	['Checked'] = [[Interface\AddOns\Aurora\Media\CheckButtonHilight]],
	['Font'] = [[Interface\AddOns\Aurora\Media\Font.ttf]],						-- Шрифт
	['Glow'] = [[Interface\AddOns\Aurora\Media\Glow]],
	['Gradient'] = [[Interface\AddOns\Aurora\Media\Gradient]],
	['RoleIcons'] = [[Interface\Addons\Aurora\Media\UI-LFG-ICON-ROLES]]
}

C.Defaults = {
	['alpha'] = 0.5,

	["buttonGradientColour"] = {.3, .3, .3, .3},
	["buttonSolidColour"] = {.2, .2, .2, 1},
	["useButtonGradientColour"] = true,
	["useCustomColour"] = false,
		["customColour"] = {r = 1, g = 1, b = 1},
		
	['enableFont'] = true,
	['QualityColour'] = true,
	
	['Font'] = true,																-- Шрифт
	['Bags'] = true,																-- Сумки
	['ChatBubbles'] = true, 														-- Сообщение в облачках
	['Tooltips'] = true,															-- Подсказки
	['Maps'] = true,																-- Карта мира
	['Loot'] = true,																-- Добыча
}

C.Frames = {}

-- [[ Functions ]]
_, F.Class = UnitClass('player')

if CUSTOM_CLASS_COLORS then
	C.ClassColors = CUSTOM_CLASS_COLORS
end

local r, g, b = C.ClassColors[F.Class].r, C.ClassColors[F.Class].g, C.ClassColors[F.Class].b

F.TexCoords = {.08, .92, .08, .92};
F.dummy = function() end;

function F:StyleButton(Button, NoHover, NoPushed, NoChecked)
	if Button.SetHighlightTexture and not Button.Hover and not NoHover then
		local Hover = Button:CreateTexture('Frame', nil, self);
		Hover:SetTexture(r, g, b, .25);
		Hover:SetPoint('TOPLEFT', 1, -1);
		Hover:SetPoint('BOTTOMRIGHT', -1, 1);
		Button.Hover = Hover;
		Button:SetHighlightTexture(Hover);
	end
	
	if Button.SetPushedTexture and not Button.Pushed and not NoPushed then
		local Pushed = Button:CreateTexture('Frame', nil, self);
		Pushed:SetTexture(0.9, 0.8, 0.1, .25);
		Pushed:SetPoint('TOPLEFT', 1, -1);
		Pushed:SetPoint('BOTTOMRIGHT', -1, 1);
		Button.Pushed = Pushed;
		Button:SetPushedTexture(Pushed);
	end
	
	if Button.SetCheckedTexture and not Button.Checked and not NoChecked then
		local Checked = Button:CreateTexture('Frame', nil, self);
		Checked:SetTexture(1, 1, 1);
		Checked:SetPoint('TOPLEFT', 1, -1);
		Checked:SetPoint('BOTTOMRIGHT', -1, 1);
		Checked:SetAlpha(.25);
		Button.Checked = Checked;
		Button:SetCheckedTexture(Checked);
	end
	
	local Cooldown = Button:GetName() and _G[Button:GetName()..'Cooldown'] 
	if Cooldown then
		Cooldown:ClearAllPoints();
		Cooldown:SetPoint('TOPLEFT', -1, 1);
		Cooldown:SetPoint('BOTTOMRIGHT', -1, 1);
	end
end

function F:CreateBD(self, A)
	self:SetBackdrop({
		bgFile = C.Media.Backdrop, edgeFile = C.Media.Backdrop, edgeSize = 1
	});
	
	self:SetBackdropColor(0, 0, 0, A or alpha);
	self:SetBackdropBorderColor(0, 0, 0);
	
	if(not A) then
		tinsert(C.Frames, self);
	end
end

function F:CreateBG(self)
	local Frame = self;
	
	if(self:GetObjectType() == 'Texture') then
		Frame = self:GetParent();
	end
	
	local BG = Frame:CreateTexture(nil, 'BACKGROUND');
	BG:SetPoint('TOPLEFT', self, -1, 1);
	BG:SetPoint('BOTTOMRIGHT', self, 1, -1);
	BG:SetTexture(C.Media.Backdrop);
	BG:SetVertexColor(0, 0, 0);
	
	return BG;
end

local ButtonR, ButtonG, ButtonB, ButtonA;

function F:CreateGradient(self)
	local Gradient = self:CreateTexture(nil, 'BORDER');
	Gradient:SetPoint('TOPLEFT', 1, -1);
	Gradient:SetPoint('BOTTOMRIGHT', -1, 1);
	Gradient:SetTexture(useButtonGradientColour and C.Media.Gradient or C.Media.Backdrop);
	Gradient:SetVertexColor(ButtonR, ButtonG, ButtonB, ButtonA);

	return Gradient;
end

local function ColourButton(self)
	if(not self:IsEnabled()) then
		return;
	end
	
	if(useButtonGradientColour) then
		self:SetBackdropColor(r, g, b, .3);
	else
		self.Gradient:SetVertexColor(r / 4, g / 4, b / 4);
	end
	
	self:SetBackdropBorderColor(r, g, b);
end

local function ClearButton(self)
	if(useButtonGradientColour) then
		self:SetBackdropColor(0, 0, 0, 0);
	else
		self.Gradient:SetVertexColor(ButtonR, ButtonG, ButtonB, ButtonA);
	end
	
	self:SetBackdropBorderColor(0, 0, 0);
end

function F:Reskin(self, NoHighlight)
	local Name = self:GetName();
	
	if(Name) then
		local Left = _G[Name..'Left'];
		local Middle = _G[Name..'Middle'];
		local Right = _G[Name..'Right'];
		
		if(Left) then Left:SetAlpha(0); end
		if(Middle) then Middle:SetAlpha(0); end
		if(Right) then Right:SetAlpha(0); end
	end

	if(self.Left) then self.Left:SetAlpha(0); end
	if(self.Right) then self.Right:SetAlpha(0); end	
	if(self.Middle) then self.Middle:SetAlpha(0); end
	if(self.SetNormalTexture) then self:SetNormalTexture(''); end	
	if(self.SetHighlightTexture) then self:SetHighlightTexture(''); end
	if(self.SetPushedTexture) then self:SetPushedTexture(''); end	
	if(self.SetDisabledTexture) then self:SetDisabledTexture(''); end
	
	F:CreateBD(self, 0);

	self.Gradient = F:CreateGradient(self);

	if(not NoHighlight) then
		self:HookScript('OnEnter', ColourButton);
 		self:HookScript('OnLeave', ClearButton);
	end
end

function F:ReskinTab(self)
	self:DisableDrawLayer('BACKGROUND');

	local BG = CreateFrame('Frame', nil, self);
	BG:SetPoint('TOPLEFT', 8, -3);
	BG:SetPoint('BOTTOMRIGHT', -8, 3);
	BG:SetFrameLevel(self:GetFrameLevel() - 1);
	F:CreateBD(BG);

	self:SetHighlightTexture(C.Media.Backdrop);
	self:GetHighlightTexture():ClearAllPoints();
	self:GetHighlightTexture():SetPoint('TOPLEFT', 9, -4);
	self:GetHighlightTexture():SetPoint('BOTTOMRIGHT', -9, 4);
	self:GetHighlightTexture():SetVertexColor(r, g, b, .25);
end

local function ColourScroll(self)
	if(self:IsEnabled()) then
		self.Texture:SetVertexColor(r, g, b);
	end
end

local function ClearScroll(self)
	self.Texture:SetVertexColor(1, 1, 1);
end

function F:ReskinScroll(self)
	local Name = self:GetName();
	local ThumbTexture = _G[Name..'ThumbTexture'];
	local UpButton = _G[Name..'ScrollUpButton'];
	local DownButton = _G[Name..'ScrollDownButton'];
	
	if(_G[Name..'Track']) then _G[Name..'Track']:SetTexture(nil); end
	if(_G[Name..'BG']) then _G[Name..'BG']:SetTexture(nil); end
	if(_G[Name..'Top']) then _G[Name..'Top']:SetTexture(nil); end
	if(_G[Name..'Middle']) then _G[Name..'Middle']:SetTexture(nil); end
	if(_G[Name..'Bottom']) then _G[Name..'Bottom']:SetTexture(nil); end
	
	ThumbTexture:SetTexture(nil);
	ThumbTexture:SetWidth(17);
	
	ThumbTexture.DB = CreateFrame('Frame', nil, self)
	ThumbTexture.DB:SetPoint('TOPLEFT', ThumbTexture, 0, -2);
	ThumbTexture.DB:SetPoint('BOTTOMRIGHT', ThumbTexture, 0, 4);
	F:CreateBD(ThumbTexture.DB, 0);
	
	local Gradient = F:CreateGradient(self)
	Gradient:SetPoint('TOPLEFT', ThumbTexture.DB, 1, -1);
	Gradient:SetPoint('BOTTOMRIGHT', ThumbTexture.DB, -1, 1);
	
	F:Reskin(UpButton, true);
	UpButton:SetWidth(17);
	
	UpButton:SetDisabledTexture(C.Media.Backdrop);
	UpButton:GetDisabledTexture():SetVertexColor(0, 0, 0, .4);
	UpButton:GetDisabledTexture():SetDrawLayer('OVERLAY');
	
	local UpTexture = UpButton:CreateTexture(nil, 'ARTWORK');
	UpTexture:SetTexture(C.Media.ArrowUp);
	UpTexture:SetSize(8, 8);
	UpTexture:SetPoint('CENTER');
	UpTexture:SetVertexColor(1, 1, 1);
	UpButton.Texture = UpTexture;
	
	UpButton:HookScript('OnEnter', ColourScroll);
	UpButton:HookScript('OnLeave', ClearScroll);
	
	F:Reskin(DownButton, true);
	DownButton:SetWidth(17);
	
	DownButton:SetDisabledTexture(C.Media.Backdrop);
	DownButton:GetDisabledTexture():SetVertexColor(0, 0, 0, .4);
	DownButton:GetDisabledTexture():SetDrawLayer('OVERLAY');
	
	local DownTexture = DownButton:CreateTexture(nil, 'ARTWORK');
	DownTexture:SetTexture(C.Media.ArrowDown);
	DownTexture:SetSize(8, 8);
	DownTexture:SetPoint('CENTER');
	DownTexture:SetVertexColor(1, 1, 1);
	DownButton.Texture = DownTexture;
	
	DownButton:HookScript('OnEnter', ColourScroll);
	DownButton:HookScript('OnLeave', ClearScroll);
end

local function ColourArrow(self)
	if(self:IsEnabled()) then
		self.Texture:SetVertexColor(r, g, b);
	end
end

local function ClearArrow(self)
	self.Texture:SetVertexColor(1, 1, 1);
end

F.ColourArrow = ColourArrow;
F.ClearArrow = ClearArrow;

function F:ReskinDropDown(self)
	local Name = self:GetName();
	local Button = _G[Name..'Button'];
	
	F.StripTextures(self);
	
	Button:SetSize(20, 20);
	Button:ClearAllPoints();
	Button:SetPoint('RIGHT', -18, 2);

	F:Reskin(Button, true);

	Button:SetDisabledTexture(C.Media.Backdrop);
	Button:GetDisabledTexture():SetVertexColor(0, 0, 0, .4);
	Button:GetDisabledTexture():SetDrawLayer('OVERLAY');
	Button:GetDisabledTexture():SetAllPoints();

	local Texture = Button:CreateTexture(nil, 'ARTWORK');
	Texture:SetTexture(C.Media.ArrowDown);
	Texture:SetSize(8, 8);
	Texture:SetPoint('CENTER');
	Texture:SetVertexColor(1, 1, 1);
	Button.Texture = Texture;

	Button:HookScript('OnEnter', ColourArrow);
	Button:HookScript('OnLeave', ClearArrow);

	local BD = CreateFrame('Frame', nil, self);
	BD:SetPoint('TOPLEFT', 16, -4);
	BD:SetPoint('BOTTOMRIGHT', -18, 8);
	BD:SetFrameLevel(self:GetFrameLevel() - 1);
	F:CreateBD(BD, 0);

	local Fradient = F:CreateGradient(self);
	Fradient:SetPoint('TOPLEFT', BD, 1, -1);
	Fradient:SetPoint('BOTTOMRIGHT', BD, -1, 1);
end

local function ColourClose(self)
	if(self:IsEnabled()) then
		for _, Pixel in pairs(self.Pixels) do
			Pixel:SetVertexColor(r, g, b)
		end
	end
end

local function ClearClose(self)
	for _, Pixel in pairs(self.Pixels) do
		Pixel:SetVertexColor(1, 1, 1)
	end
end

function F:ReskinClose(self, a1, p, a2, x, y)
	self:SetSize(17, 17);
	
	if(not a1) then
		self:SetPoint('TOPRIGHT', -6, -6);
	else
		self:ClearAllPoints();
		self:SetPoint(a1, p, a2, x, y);
	end
	
	self:SetNormalTexture('');
	self:SetHighlightTexture('');
	self:SetPushedTexture('');
	self:SetDisabledTexture('');
	
	F:CreateBD(self, 0);
	F:CreateGradient(self);
	
	self:SetDisabledTexture(C.Media.Backdrop);
	self:GetDisabledTexture():SetVertexColor(0, 0, 0, .4);
	self:GetDisabledTexture():SetDrawLayer('OVERLAY');
	self:GetDisabledTexture():SetAllPoints();
	
	self.Pixels = {};
	
	for i = 1, 9 do
		local Texture = self:CreateTexture();
		Texture:SetTexture(1, 1, 1);
		Texture:SetSize(1, 1);
		Texture:SetPoint('BOTTOMLEFT', 3 + i, 3 + i);
		tinsert(self.Pixels, Texture);
	end
	
	for i = 1, 9 do
		local Texture = self:CreateTexture();
		Texture:SetTexture(1, 1, 1);
		Texture:SetSize(1, 1);
		Texture:SetPoint('TOPLEFT', 3 + i, -3 - i);
		tinsert(self.Pixels, Texture);
	end
	
	self:HookScript('OnEnter', ColourClose);
 	self:HookScript('OnLeave', ClearClose);
end

function F:ReskinInput(self, Height, Width)
	local Name = self:GetName();
	
	if(_G[Name..'Left']) then _G[Name..'Left']:Hide(); end
	if(_G[Name..'Middle']) then _G[Name..'Middle']:Hide(); end
	if(_G[Name..'Mid']) then _G[Name..'Mid']:Hide(); end
	if(_G[Name..'Right']) then _G[Name..'Right']:Hide(); end
	
	local BD = CreateFrame('Frame', nil, self);
	BD:SetPoint('TOPLEFT', -2, 0);
	BD:SetPoint('BOTTOMRIGHT');
	BD:SetFrameLevel(self:GetFrameLevel() - 1);
	F:CreateBD(BD, 0);
	
	if(Name and Name:find('Silver') or Name:find('Copper')) then
		BD:SetPoint('BOTTOMRIGHT', -10, 0);
	end

	local Gradient = F:CreateGradient(self);
	Gradient:SetPoint('TOPLEFT', BD, 1, -1);
	Gradient:SetPoint('BOTTOMRIGHT', BD, -1, 1);

	if(Height) then self:SetHeight(Height); end
	if(Width) then self:SetWidth(Width); end
end

function F:ReskinArrow(self, Direction)
	self:SetSize(18, 18);
	F:Reskin(self, true);

	self:SetDisabledTexture(C.Media.Backdrop);
	self:GetDisabledTexture():SetVertexColor(0, 0, 0, .3);
	self:GetDisabledTexture():SetDrawLayer('OVERLAY');

	local Texture = self:CreateTexture(nil, 'ARTWORK');
	Texture:SetTexture([[Interface\AddOns\Aurora\Media\Arrow-]]..Direction..[[-Active]]);
	Texture:SetSize(8, 8);
	Texture:SetPoint('CENTER');
	self.Texture = Texture;

	self:HookScript('OnEnter', ColourArrow);
	self:HookScript('OnLeave', ClearArrow);
end

function F:ReskinCheck(self)
	self:SetNormalTexture('');
	self:SetPushedTexture('');
	self:SetHighlightTexture(C.Media.Backdrop);
	
	self:GetHighlightTexture():SetPoint('TOPLEFT', 5, -5);
	self:GetHighlightTexture():SetPoint('BOTTOMRIGHT', -5, 5);
	self:GetHighlightTexture():SetVertexColor(r, g, b, .2);

	local BD = CreateFrame('Frame', nil, self);
	BD:SetPoint('TOPLEFT', 4, -4);
	BD:SetPoint('BOTTOMRIGHT', -4, 4);
	BD:SetFrameLevel(self:GetFrameLevel() - 1);
	F:CreateBD(BD, 0);

	local Gradient = F:CreateGradient(self);
	Gradient:SetPoint('TOPLEFT', 5, -5);
	Gradient:SetPoint('BOTTOMRIGHT', -5, 5);

	self:GetCheckedTexture():SetVertexColor(r, g, b);
end

local function ColourRadio(self)
	self.BD:SetBackdropBorderColor(r, g, b);
end

local function ClearRadio(self)
	self.BD:SetBackdropBorderColor(0, 0, 0);
end

function F:ReskinRadio(self)
	self:SetNormalTexture('');
	self:SetHighlightTexture('');
	self:SetCheckedTexture(C.Media.Backdrop);
	
	self:GetCheckedTexture():SetPoint('TOPLEFT', 4, -4);
	self:GetCheckedTexture():SetPoint('BOTTOMRIGHT', -4, 4);
	self:GetCheckedTexture():SetVertexColor(r, g, b, .6);
	
	local BD = CreateFrame('Frame', nil, self);
	BD:SetPoint('TOPLEFT', 3, -3);
	BD:SetPoint('BOTTOMRIGHT', -3, 3);
	BD:SetFrameLevel(self:GetFrameLevel() - 1);
	F:CreateBD(BD, 0);
	self.BD = BD;
	
	local Gradient = F:CreateGradient(self);
	Gradient:SetPoint('TOPLEFT', 4, -4);
	Gradient:SetPoint('BOTTOMRIGHT', -4, 4);
	
	self:HookScript('OnEnter', ColourRadio);
	self:HookScript('OnLeave', ClearRadio);
end

function F:ReskinSlider(self)
	self:SetBackdrop(nil);
	self.SetBackdrop = F.dummy;
	
	local BD = CreateFrame('Frame', nil, self);
	BD:SetPoint('TOPLEFT', 14, -2);
	BD:SetPoint('BOTTOMRIGHT', -15, 3);
	BD:SetFrameLevel(self:GetFrameLevel() - 1);
	F:CreateBD(BD, 0);
	
	F:CreateGradient(BD);
	
	local Slider = select(4, self:GetRegions());
	Slider:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
	Slider:SetBlendMode('ADD');
end

function F:ReskinHeader(self)
	if(self:GetName()) then
		local Left = _G[self:GetName()..'Left'];
		local Middle = _G[self:GetName()..'Middle'];
		local Right = _G[self:GetName()..'Right'];
		
		if(Left) then Left:SetTexture(nil); end
		if(Middle) then Middle:SetTexture(nil); end
		if(Right) then Right:SetTexture(nil); end
	end
	
	self:SetHighlightTexture(C.Media.Backdrop);
	local Highlight = self:GetHighlightTexture();
	Highlight:ClearAllPoints();
	Highlight:SetPoint('TOPLEFT', 3, -4);
	Highlight:SetPoint('BOTTOMRIGHT', -2, 4);
	Highlight:SetVertexColor(r, g, b, .25);
	
	local HeaderBG = CreateFrame('Frame', nil, self);
	HeaderBG:SetPoint('TOPLEFT', 2, -3);
	HeaderBG:SetPoint('BOTTOMRIGHT', -1, 3);
	HeaderBG:SetFrameLevel(self:GetFrameLevel() - 1);
	F:CreateBD(HeaderBG, 0);
	F:CreateGradient(HeaderBG);
	
	return self;
end

local function ColourExpandOrCollapse(self)
	if(self:IsEnabled()) then
		self.Plus:SetVertexColor(r, g, b);
		self.Minus:SetVertexColor(r, g, b);
	end
end

local function ClearExpandOrCollapse(self)
	self.Plus:SetVertexColor(1, 1, 1);
	self.Minus:SetVertexColor(1, 1, 1);
end

F.ColourExpandOrCollapse = ColourExpandOrCollapse;
F.ClearExpandOrCollapse = ClearExpandOrCollapse;

function F:ReskinExpandOrCollapse(self)
	self:SetSize(13, 13);
	
	F:Reskin(self, true);
	self.SetNormalTexture = F.dummy;
	
	self.Minus = self:CreateTexture(nil, 'OVERLAY');
	self.Minus:SetSize(7, 1);
	self.Minus:SetPoint('CENTER');
	self.Minus:SetTexture(C.Media.Backdrop);
	self.Minus:SetVertexColor(1, 1, 1);
	
	self.Plus = self:CreateTexture(nil, 'OVERLAY');
	self.Plus:SetSize(1, 7);
	self.Plus:SetPoint('CENTER');
	self.Plus:SetTexture(C.Media.Backdrop);
	self.Plus:SetVertexColor(1, 1, 1);
	
	self:HookScript('OnEnter', ColourExpandOrCollapse);
	self:HookScript('OnLeave', ClearExpandOrCollapse);
end

function F:SetBD(self, x1, y1, x2, y2)
	local xOfs1 = x1 or 0;
	local yOfs1 = y1 or 0;
	local xOfs2 = x2 or 0;
	local yOfs2 = y2 or 0;
	
	local BD = CreateFrame('Frame', nil, self);
	BD:ClearAllPoints();
	if(xOfs1 == 0 and yOfs1 == 0 and xOfs2 == 0 and yOfs2 == 0) then
	 	BD:SetAllPoints(self);
	else
		BD:SetPoint('TOPLEFT', self, 'TOPLEFT', xOfs1, yOfs1);
		BD:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', xOfs2, yOfs2);
	end
	
	F:CreateBD(BD);
	
	local Success, Err = pcall(LowerFrameLevel, BD);
	if(not Success) then
		RaiseFrameLevel(self);
	end
	
	return BD
end

function F:CreateBDFrame(self, A)
	local Frame;
	
	if(self:GetObjectType() == 'Texture') then
		Frame = self:GetParent();
	else
		Frame = self;
	end
	
	local FrameLevel = Frame:GetFrameLevel();
	
	local BG = CreateFrame('Frame', nil, Frame);
	BG:SetPoint('TOPLEFT', self, -1, 1);
	BG:SetPoint('BOTTOMRIGHT', self, 1, -1);
	BG:SetFrameLevel(FrameLevel == 0 and 1 or FrameLevel - 1);
	
	F:CreateBD(BG, A or .5);
	
	return BG
end

function F:ReskinColourSwatch(self)
	local Name = self:GetName();
	local BG = _G[Name..'SwatchBg'];
	
	self:SetNormalTexture(C.Media.Backdrop);
	self:GetNormalTexture():SetPoint('TOPLEFT', 3, -3);
	self:GetNormalTexture():SetPoint('BOTTOMRIGHT', -3, 3);
	
	BG:SetTexture(0, 0, 0);
	BG:SetPoint('TOPLEFT', 2, -2);
	BG:SetPoint('BOTTOMRIGHT', -2, 2);
end

function F:ColourQuality(self, ID)
	local Quality, Texture, _;
	local Quest = _G[self:GetName()..'IconQuestTexture'];
	
	if(ID) then
		Quality, _, _, _, _, _, _, Texture = select(3, GetItemInfo(ID));
	end
	
	if(Texture) then
		local r, g, b;
		
		if(Quest and Quest:IsShown()) then
			r, g, b = 1, 0, 0;
		else
			r, g, b = GetItemQualityColor(Quality);
			
			if(r == 1 and g == 1) then r, g, b = 0, 0, 0; end
		end
		
		self:SetBackdropBorderColor(r, g, b);
	else
		self:SetBackdropBorderColor(0, 0, 0);
	end
end

F.Kill = function(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	
	object.Show = F.dummy
	object:Hide()
end

F.StripTextures = function(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region and region:GetObjectType() == 'Texture' then
			if kill and type(kill) == 'boolean' then
				F.Kill(region)
			elseif region:GetDrawLayer() == kill then
				region:SetTexture(nil)
			elseif kill and type(kill) == 'string' and region:GetTexture() ~= kill then
				region:SetTexture(nil)
			else
				region:SetTexture(nil)
			end
		end
	end
end

C.Modules = {}
C.Modules['Aurora'] = {}

local Skin = CreateFrame('Frame');
Skin:RegisterEvent('ADDON_LOADED');
Skin:RegisterEvent('PLAYER_LOGIN');
Skin:SetScript('OnEvent', function(self, event, addon)
	if(event == 'ADDON_LOADED') then
		if(not addon == 'Aurora') then
			return;
		end
		
		for key, value in pairs(AuroraConfig) do
			if(C.Defaults[key] == nil) then
				AuroraConfig[key] = nil;
			end
		end
		
		for key, value in pairs(C.Defaults) do
			if(AuroraConfig[key] == nil) then
				if(type(value) == 'table') then
					AuroraConfig[key] = {};
					
					for k, v in pairs(value) do
						AuroraConfig[key][k] = value[k];
					end
				else
					AuroraConfig[key] = value;
				end
			end
		end

		alpha = AuroraConfig.alpha;
		useButtonGradientColour = AuroraConfig.useButtonGradientColour;

		if useButtonGradientColour then
			ButtonR, ButtonG, ButtonB, ButtonA = unpack(AuroraConfig.buttonGradientColour);
		else
			ButtonR, ButtonG, ButtonB, ButtonA = unpack(AuroraConfig.buttonSolidColour);
		end

		if AuroraConfig.useCustomColour then
			r, g, b = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b;
		end
		
		C.r, C.g, C.b = r, g, b;
	elseif(event == 'PLAYER_LOGIN') then
		SetCVar('useUiScale', 1);
		SetCVar('uiScale', 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], '%d+x(%d+)'));
	end

	for module, moduleFunc in pairs(C.Modules) do
		if(type(moduleFunc) == 'function') then
			if(module == addon) then
				moduleFunc();
			end
		elseif(type(moduleFunc) == 'table') then
			if(module == addon) then
				for _, moduleFunc in pairs(C.Modules[module]) do
					moduleFunc();
				end
			end
		end
	end
end);

local Delay = CreateFrame('Frame')
Delay:RegisterEvent('PLAYER_ENTERING_WORLD')
Delay:SetScript('OnEvent', function()
	Delay:UnregisterEvent('PLAYER_ENTERING_WORLD')
	-- Сумки
	if AuroraConfig.Bags == true and not(IsAddOnLoaded('Baggins') or IsAddOnLoaded('Stuffing') or IsAddOnLoaded('Combuctor') or IsAddOnLoaded('cargBags') or IsAddOnLoaded('famBags') or IsAddOnLoaded('ArkInventory') or IsAddOnLoaded('Bagnon')) then
		for i = 1, 12 do
			local Container = _G['ContainerFrame'..i];
			local ContainerCloseButton = _G['ContainerFrame'..i..'CloseButton'];
			
			F.StripTextures(Container, true);
			F:SetBD(Container, 1, -1, -1, 1);
			
			F:ReskinClose(ContainerCloseButton, 'TOPRIGHT', Container, 'TOPRIGHT', -5, -5);

			for k = 1, MAX_CONTAINER_ITEMS do
				local ContainerItem = 'ContainerFrame'..i..'Item'..k;
				local ContainerItemButton = _G[ContainerItem];
				local ContainerItemIconTexture = _G[ContainerItem..'IconTexture'];

				_G[ContainerItem..'IconQuestTexture']:SetAlpha(0);

				F.StripTextures(ContainerItemButton);
				F:StyleButton(ContainerItemButton);
				F:CreateBD(ContainerItemButton, .25);
				
				ContainerItemIconTexture:SetTexCoord(unpack(F.TexCoords));
				ContainerItemIconTexture:SetPoint('TOPLEFT', 1, -1);
				ContainerItemIconTexture:SetPoint('BOTTOMRIGHT', -1, 1);
			end
			
			if i == 1 then
				F.StripTextures(BackpackTokenFrame);
				
				for i = 1, MAX_WATCHED_TOKENS do
					local TokenIcon = _G['BackpackTokenFrameToken'..i..'Icon'];
					
					TokenIcon:SetTexCoord(unpack(F.TexCoords));
				end
			end
		end
		
		if ( AuroraConfig.QualityColour ) then
			hooksecurefunc('ContainerFrame_Update', function(self)
				local ID = self:GetID();
				local Name = self:GetName();

				for i = 1, self.size, 1 do
					local Button = _G[Name..'Item'..i];
					local ItemID = GetContainerItemID(ID, Button:GetID());
					
					F:ColourQuality(Button, ItemID);
				end
			end);
		end
		
		F.StripTextures(BankFrame, true);
		F:SetBD(BankFrame, 10, -11, -25, 91);
		
		F:ReskinClose(BankCloseButton, 'TOPRIGHT', BankFrame, 'TOPRIGHT', -29, -15);
		
		F:Reskin(BankFramePurchaseButton);

		for i = 1, 28 do
			local BankItem = 'BankFrameItem'..i;
			local BankItemButton = _G[BankItem];
			local BankItemIconTexture = _G[BankItem..'IconTexture'];

			_G[BankItem..'IconQuestTexture']:SetAlpha(0);
			
			F.StripTextures(BankItemButton);
			F:StyleButton(BankItemButton);
			F:CreateBD(BankItemButton, .25);
			
			BankItemIconTexture:SetPoint('TOPLEFT', 1, -1);
			BankItemIconTexture:SetPoint('BOTTOMRIGHT', -1, 1);
			BankItemIconTexture:SetTexCoord(unpack(F.TexCoords));
		end

		for i = 1, 7 do
			local BankFrameBag = _G['BankFrameBag'..i];
			local BankFrameBagIconTexture = _G['BankFrameBag'..i..'IconTexture'];
			
			F.StripTextures(BankFrameBag);
			F:StyleButton(BankFrameBag);
			F:CreateBD(BankFrameBag, .25);
			
			BankFrameBagIconTexture:SetPoint('TOPLEFT', 1, -1);
			BankFrameBagIconTexture:SetPoint('BOTTOMRIGHT', -1, 1);
			BankFrameBagIconTexture:SetTexCoord(unpack(F.TexCoords));
		end
		
		if ( AuroraConfig.QualityColour ) then
			hooksecurefunc('BankFrameItemButton_Update', function(self)
				F:ColourQuality(self, GetInventoryItemID('player', self:GetInventorySlot()));
			end);
		end
	end
	-- Сообщения в облачках
	if AuroraConfig.ChatBubbles then
		local ChatBubblesHook = CreateFrame('Frame')

		local function StyleChatBubbles(frame)
			for i = 1, frame:GetNumRegions() do
				local region = select(i, frame:GetRegions())
				if region:GetObjectType() == 'Texture' then
					region:SetTexture(nil)
				elseif region:GetObjectType() == 'FontString' then
					region:SetFont(C.Media.Font, 13)
				end
			end

			frame:SetBackdrop({
				bgFile = C.Media.Backdrop,
				edgeFile = C.Media.Backdrop,
				edgeSize = UIParent:GetScale(),
			})
			frame:SetBackdropColor(0, 0, 0, AuroraConfig.alpha)
			frame:SetBackdropBorderColor(0, 0, 0)
		end

		local function isChatBubble(frame)
			if frame:GetName() then return end
			if not frame:GetRegions() then return end
			return frame:GetRegions():GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
		end

		local last = 0
		local numKids = 0

		ChatBubblesHook:SetScript('OnUpdate', function(self, elapsed)
			last = last + elapsed
			if last > .1 then
				last = 0
				local newNumKids = WorldFrame:GetNumChildren()
				if newNumKids ~= numKids then
					for i=numKids + 1, newNumKids do
						local frame = select(i, WorldFrame:GetChildren())

						if isChatBubble(frame) then
							StyleChatBubbles(frame)
						end
					end
					numKids = newNumKids
				end
			end
		end)
	end
	-- Подсказки
	if AuroraConfig.Tooltips == true and not(IsAddOnLoaded('CowTip') or IsAddOnLoaded('TipTac') or IsAddOnLoaded('FreebTip') or IsAddOnLoaded('lolTip') or IsAddOnLoaded('StarTip') or IsAddOnLoaded('TipTop')) then
		local Tooltips = {'GameTooltip', 'ItemRefTooltip', 'ShoppingTooltip1', 'ShoppingTooltip2', 'ShoppingTooltip3', 'WorldMapTooltip', 'ChatMenu', 'EmoteMenu', 'LanguageMenu', 'VoiceMacroMenu'}

		local Backdrop = {bgFile = C.Media.Backdrop, edgeFile = C.Media.Backdrop, edgeSize = 1}
		local GetBackdrop = function() return Backdrop end
		local GetBackdropColor = function() return 0, 0, 0, .6 end
		local GetBackdropBorderColor = function() return 0, 0, 0 end

		for i = 1, #Tooltips do
			local Tooltips = _G[Tooltips[i]]
			Tooltips:SetBackdrop(nil)
			local bg = CreateFrame('Frame', nil, Tooltips)
			bg:SetPoint('TOPLEFT')
			bg:SetPoint('BOTTOMRIGHT')
			bg:SetFrameLevel(Tooltips:GetFrameLevel()-1)
			bg:SetBackdrop(Backdrop)
			bg:SetBackdropColor(0, 0, 0, .6)
			bg:SetBackdropBorderColor(0, 0, 0)

			Tooltips.GetBackdrop = GetBackdrop
			Tooltips.GetBackdropColor = GetBackdropColor
			Tooltips.GetBackdropBorderColor = GetBackdropBorderColor
		end

		local StatusBar = _G['GameTooltipStatusBar']
		StatusBar:SetHeight(5)
		StatusBar:ClearAllPoints()
		StatusBar:SetPoint('BOTTOMLEFT', GameTooltip, 'BOTTOMLEFT', 1, 1)
		StatusBar:SetPoint('BOTTOMRIGHT', GameTooltip, 'BOTTOMRIGHT', -1, 1)
		StatusBar:SetStatusBarTexture(C.Media.Backdrop)

		local StatusBarTexture = GameTooltipStatusBar:CreateTexture(nil, 'ARTWORK')
		StatusBarTexture:SetHeight(1)
		StatusBarTexture:SetPoint('BOTTOMLEFT', 0, 5)
		StatusBarTexture:SetPoint('BOTTOMRIGHT', 0, 5)
		StatusBarTexture:SetTexture(C.Media.Backdrop)
		StatusBarTexture:SetVertexColor(0, 0, 0)

		F:CreateBD(FriendsTooltip)
	end
end)