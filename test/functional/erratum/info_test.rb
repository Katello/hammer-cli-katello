require_relative '../test_helper'
require_relative 'erratum_helpers'

describe 'Erratum Info' do
  include ErratumHelpers

  before do
    @cmd = %w(erratum info)
  end

  it "prints module package info on run" do
    api_expects(:errata, :show)
      .with_params('id' => erratum_id)
      .returns(make_erratum_response)
    params = ["--id=#{erratum_id}"]
    result = run_cmd(@cmd + params)
    verify_module_packages_and_orphan_packages(result)
  end

  it "prints package info on run" do
    api_expects(:errata, :show)
      .with_params('id' => erratum_id)
      .returns(make_erratum_response(true, false))

    params = ["--id=#{erratum_id}"]
    result = run_cmd(@cmd + params)
    verify_no_modules_packages_with_orphan_packages(result)
  end
end
