require_relative '../capsule_helpers'

module CapsuleContentHelpers
  include CapsuleHelpers

  def expect_capsule_search(name, id)
    expect_generic_capsule_search(params: {search: "name = \"#{name}\""}, returns: {'id' => id})
  end

  def expect_lifecycle_environments_list(args = {params: {}, returns: []})
    api_expects(:capsule_content, :lifecycle_environments)
      .with_params(args[:params]).returns(index_response(args[:returns]))
  end

  def expect_lifecycle_environment_add(params = {})
    api_expects(:capsule_content, :add_lifecycle_environment)
      .with_params(params)
  end

  def expect_lifecycle_environment_remove(params = {})
    api_expects(:capsule_content, :remove_lifecycle_environment)
      .with_params(params)
  end
end
