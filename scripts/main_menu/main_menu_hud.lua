-- Updates the hud with relevant information
class 'MainMenuHudSystem' (System)

function MainMenuHudSystem:__init()
    System.__init(self)
end

function MainMenuHudSystem:init(gameState)
    System.init(self, gameState)
    root = gameState:rootGUIWindow()
    local microbeButton = root:getChild("Background"):getChild("MainMenuInteractive"):getChild("NewGameButton")
    local microbeEditorButton = root:getChild("Background"):getChild("MainMenuInteractive"):getChild("EditorMenuButton")
    local optionsButton = root:getChild("Background"):getChild("MainMenuInteractive"):getChild("OptionsButton")
    local optionsToggleFullScreenButton = root:getChild("Background"):getChild("MainMenuInteractive"):getChild("OptionsPanel"):getChild("ToggleFullscreenButton")
    local optionsSaveButton = root:getChild("Background"):getChild("MainMenuInteractive"):getChild("OptionsPanel"):getChild("CloseOptionsButton")
    local quitButton = root:getChild("Background"):getChild("MainMenuInteractive"):getChild("ExitGameButton")
    local loadButton = root:getChild("Background"):getChild("MainMenuInteractive"):getChild("LoadGameButton")   
    microbeButton:registerEventHandler("Clicked", mainMenuMicrobeStageButtonClicked)
    microbeEditorButton:registerEventHandler("Clicked", mainMenuMicrobeEditorButtonClicked)
    optionsButton:registerEventHandler("Clicked", mainMenuOptionsClicked)
    optionsToggleFullScreenButton:registerEventHandler("Clicked", mainMenuOptionsFullScreenClicked)
    optionsSaveButton:registerEventHandler("Clicked", mainMenuOptionsSaveClicked)
    loadButton:registerEventHandler("Clicked", mainMenuLoadButtonClicked)
    quitButton:registerEventHandler("Clicked", quitButtonClicked)
    optionsVisible = false
	updateLoadButton();
end

function MainMenuHudSystem:update(renderTime, logicTime)
    if keyCombo(kmp.screenshot) then
        Engine:screenShot("screenshot.png")
    end
end

function MainMenuHudSystem:activate()
    updateLoadButton();
end
function updateLoadButton()
    if Engine:fileExists("quick.sav") then
        root:getChild("Background"):getChild("MainMenuInteractive"):getChild("LoadGameButton"):enable();
    else
        root:getChild("Background"):getChild("MainMenuInteractive"):getChild("LoadGameButton"):disable();
    end
end

function mainMenuLoadButtonClicked()
    local guiSoundEntity = Entity("gui_sounds")
    guiSoundEntity:getComponent(SoundSourceComponent.TYPE_ID):playSound("button-hover-click")
    Engine:setCurrentGameState(GameState.MICROBE)
    Engine:load("quick.sav")
    print("Game loaded");
end

function mainMenuMicrobeStageButtonClicked()
    local guiSoundEntity = Entity("gui_sounds")
    guiSoundEntity:getComponent(SoundSourceComponent.TYPE_ID):playSound("button-hover-click")
    Engine:setCurrentGameState(GameState.MICROBE)
end

function mainMenuMicrobeEditorButtonClicked()
    local guiSoundEntity = Entity("gui_sounds")
    guiSoundEntity:getComponent(SoundSourceComponent.TYPE_ID):playSound("button-hover-click")
    Engine:setCurrentGameState(GameState.MICROBE_EDITOR)
end

function mainMenuOptionsClicked()
    local guiSoundEntity = Entity("gui_sounds")
    guiSoundEntity:getComponent(SoundSourceComponent.TYPE_ID):playSound("button-hover-click")
    if optionsVisible then
        root:getChild("Background"):getChild("MainMenuInteractive"):getChild("OptionsPanel"):hide()
        optionsVisible = false
    else
        root:getChild("Background"):getChild("MainMenuInteractive"):getChild("OptionsPanel"):show()
        optionsVisible = true
    end
end

function mainMenuOptionsFullScreenClicked()
    local guiSoundEntity = Entity("gui_sounds")
    guiSoundEntity:getComponent(SoundSourceComponent.TYPE_ID):playSound("button-hover-click")
end

function mainMenuOptionsSaveClicked()
    local guiSoundEntity = Entity("gui_sounds")
    guiSoundEntity:getComponent(SoundSourceComponent.TYPE_ID):playSound("button-hover-click")
    root:getChild("Background"):getChild("MainMenuInteractive"):getChild("OptionsPanel"):hide()
    optionsVisible = false
end

-- quitButtonClicked is already defined in microbe_stage_hud.lua
