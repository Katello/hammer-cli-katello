require File.join(File.dirname(__FILE__), '../../test_helper')
require 'hammer_cli_katello/activation_key'

describe 'activation-key content-override' do
  before do
    @cmd = %w(activation-key content-override)
  end
  it "attaches a content label" do
    label = "foo"
    value = 'default'
    id = '20'
    params = ["--id=#{id}", "--content-label=#{label}", "--value=#{value}"]
    ex = api_expects(:activation_keys, :content_override) do |par|
      par['id'] == id && par["content_overrides"][0]['content_label'] == label &&
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
    params = ["--id=#{id}", "--content-label=#{label}", "--value=#{value}", "--name=#{name}"]
    ex = api_expects(:activation_keys, :content_override) do |par|
      par['id'] == id && par["content_overrides"][0]['content_label'] == label &&
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
    params = ["--id=#{id}", "--content-label=#{label}", "--remove"]
    ex = api_expects(:activation_keys, :content_override) do |par|
      par['id'] == id && par["content_overrides"][0]['content_label'] == label &&
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
    params = ["--id=#{id}", "--content-label=#{label}", "--name=#{name}", "--remove"]
    ex = api_expects(:activation_keys, :content_override) do |par|
      par['id'] == id && par["content_overrides"][0]['content_label'] == label &&
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
    params = ["--id=#{id}", "--content-label=#{label}", "--name=#{name}"]
    result = run_cmd(@cmd + params)

    assert(result.err[/At least one of options --remove, --value is required/],
               "Remove or Value must be provided")
  end
end
