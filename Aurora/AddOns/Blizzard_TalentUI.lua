local F, C = unpack(select(2, ...));

local _G = getfenv(0);
local unpack = unpack;

local TexCoords = F.TexCoords;

C.Modules['Blizzard_TalentUI'] = function()
	F.SetBD(PlayerTalentFrame, 10, -12, -31, 76);
	PlayerTalentFramePortrait:Hide();
	
	F.ReskinClose(PlayerTalentFrameCloseButton, 'TOPRIGHT', PlayerTalentFrame, 'TOPRIGHT', -35, -16);
	
	F.StripTextures(PlayerTalentFrameStatusFrame);
	
	F.Reskin(PlayerTalentFrameActivateButton, nil, true);
	
	for i = 1, MAX_NUM_TALENTS do
		local Talent = _G['PlayerTalentFrameTalent'..i];
		local IconTexture = _G['PlayerTalentFrameTalent'..i..'IconTexture'];
		
		if Talent then
			F.StripTextures(Talent);
			F.CreateBG(Talent);
			F.StyleButton(Talent);
			
			Talent.Hover:SetAllPoints();
			Talent.Pushed:SetAllPoints();
			
			IconTexture:SetTexCoord(unpack(TexCoords));
		end
	end
	
	F.StripTextures(PlayerTalentFrameScrollFrame, true);
	F.ReskinScroll(PlayerTalentFrameScrollFrameScrollBar);
	
	F.StripTextures(PlayerTalentFramePointsBar);
	F.StripTextures(PlayerTalentFramePreviewBar);
	F.StripTextures(PlayerTalentFramePreviewBarFiller);
	
	F.Reskin(PlayerTalentFrameResetButton);
	PlayerTalentFrameLearnButton:SetPoint('RIGHT', PlayerTalentFrameResetButton, 'LEFT', -1, 0);
	F.Reskin(PlayerTalentFrameLearnButton);
	
	for i = 1, 4 do
		local Tab = _G['PlayerTalentFrameTab'..i];
		
		F.ReskinTab(Tab);
	end
	
	for i = 1, MAX_TALENT_TABS do
		local Tab = _G['PlayerSpecTab'..i];
		
		if Tab then
			local Regions = Tab:GetRegions();
			Regions:Hide();
			
			F.StripTextures(Tab);
			F.CreateBD(Tab);
			F.StyleButton(Tab, nil, true);
			
			Tab:GetNormalTexture():SetPoint('TOPLEFT', 1, -1);
			Tab:GetNormalTexture():SetPoint('BOTTOMRIGHT', -1, 1);
			Tab:GetNormalTexture():SetTexCoord(unpack(TexCoords));
		end
	end
end