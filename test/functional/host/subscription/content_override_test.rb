require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../host_helpers')
require 'hammer_cli_katello/host_subscription'

describe 'host subscription content-override' do
  include HostHelpers

  before do
    @cmd = %w(host subscription content-override)
  end

  it "attaches a content label" do
    label = "foo"
    value = 'default'
    id = '20'
    params = ["--host-id=#{id}", "--content-label=#{label}", "--value=#{value}"]
    ex = api_expects(:host_subscriptions, :content_override, "content override") do |par|
      par['host_id'].to_s == id && par["content_overrides"][0]['content_label'] == label &&
        par['content_overrides'][0]['value'] == value &&
        par['content_overrides'][0]['name'] == "enabled"
    end
    ex.returns({})

    expected_result = success_result("Updated content override\n")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "attaches a content label with name" do
    label = "foo"
    value = '1'
    id = '20'
    name = 'protected'
    params = ["--host-id=#{id}", "--content-label=#{label}", "--value=#{value}", "--name=#{name}"]
    ex = api_expects(:host_subscriptions, :content_override, "content override") do |par|
      par['host_id'].to_s == id && par["content_overrides"][0]['content_label'] == label &&
        par['content_overrides'][0]['value'] == value &&
        par['content_overrides'][0]['name'] == name
    end
    ex.returns({})

    expected_result = success_result("Updated content override\n")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "removes override" do
    label = "foo"
    id = '20'
    params = ["--host-id=#{id}", "--content-label=#{label}", "--remove"]
    ex = api_expects(:host_subscriptions, :content_override, "content override") do |par|
      par['host_id'].to_s == id && par["content_overrides"][0]['content_label'] == label &&
        par['content_overrides'][0]['remove'] == true &&
        par['content_overrides'][0]['name'] == "enabled"
    end
    ex.returns({})

    expected_result = success_result("Updated content override\n")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "removes override with name" do
    label = "foo"
    id = '20'
    name = 'protected'
    params = ["--host-id=#{id}", "--content-label=#{label}", "--name=#{name}", "--remove"]
    ex = api_expects(:host_subscriptions, :content_override, "content override") do |par|
      par['host_id'].to_s == id && par["content_overrides"][0]['content_label'] == label &&
        par['content_overrides'][0]['remove'] == true &&
        par['content_overrides'][0]['name'] == name
    end
    ex.returns({})

    expected_result = success_result("Updated content override\n")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "validation fails on no override value or remove" do
    api_expects_no_call
    label = "foo"
    id = '20'
    name = 'protected'
    params = ["--host-id=#{id}", "--content-label=#{label}", "--name=#{name}"]
    result = run_cmd(@cmd + params)

    assert(result.err[/At least one of options --remove, --value is required/],
               "Remove or Value must be provided")
  end
end
