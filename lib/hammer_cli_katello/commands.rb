module HammerCLIKatello

  class WriteCommand < HammerCLIForeman::WriteCommand; end

  class ReadCommand < HammerCLIForeman::ReadCommand; end

  class ListCommand < HammerCLIForeman::ListCommand; end

  class InfoCommand < HammerCLIForeman::InfoCommand

    identifiers :id

  end

  class CreateCommand < HammerCLIForeman::CreateCommand; end

  class UpdateCommand < HammerCLIForeman::UpdateCommand

    identifiers :id

  end

  class DeleteCommand < HammerCLIForeman::DeleteCommand

    identifiers :id

  end

  class AddAssociatedCommand < HammerCLIForeman::AddAssociatedCommand; end

  class RemoveAssociatedCommand < HammerCLIForeman::RemoveAssociatedCommand
  end

end
