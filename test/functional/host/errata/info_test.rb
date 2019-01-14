require File.join(File.dirname(__FILE__), '../../test_helper')
require_relative '../../erratum/erratum_helpers'

describe 'host Erratum Info' do
  include ErratumHelpers
  before do
    @cmd = %w(host errata info)
  end

  it "prints module package info on run" do
    api_expects(:host_errata, :show)
      .with_params('id' => erratum_id, 'host_id' => host_id)
      .returns(make_erratum_response)
    params = ["--id=#{erratum_id}", "--host-id=#{host_id}"]
    result = run_cmd(@cmd + params)
    verify_module_packages_and_orphan_packages(result)
  end

  it "prints package info on run" do
    api_expects(:host_errata, :show)
      .with_params('id' => erratum_id, 'host_id' => host_id)
      .returns(make_erratum_response(true, false))
    params = ["--id=#{erratum_id}", "--host-id=#{host_id}"]
    result = run_cmd(@cmd + params)
    verify_no_modules_packages_with_orphan_packages(result)
  end
end
