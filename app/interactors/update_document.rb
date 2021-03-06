class UpdateDocument
  include Interactor::Organizer
  include InteractorWithTransaction

  before do
    context.position = 1.0
  end

  organize SaveRecord,
    RemoveExistingCommands,
    BuildSetupCommands,
    BuildCommandsForInstallingCommonGems,
    BuildCommandsForInstallingSpecificGems,
    BuildScaffoldCommands,
    BuildRunCommands
end
