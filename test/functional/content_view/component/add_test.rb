require_relative '../../test_helper'
require 'hammer_cli_katello/content_view_component'
# rubocop:disable Metrics/ModuleLength
module HammerCLIKatello
  describe ContentViewComponent::AddComponents do
    before do
      @cmd = %w(content-view component add)
      @composite = OpenStruct.new(:id => 2, :name => "composite")
      @component_version = OpenStruct.new(:id => 666, :version => "1.0")
      @component = OpenStruct.new(:id => 6, :name => "component",
                                  :content_view_version => @component_version)
      @organization = OpenStruct.new(:id => 1, :name => "great", :label => "label")
    end

    def setup_org_expectations
      org_expect = api_expects(:organizations, :index) do |par|
        par[:search] == "name = \"#{@organization.name}\""
      end
      org_expect.at_least_once.returns(index_response([{'id' => @organization.id.to_s}]))
    end

    def setup_content_view_expectations(content_view)
      cv_expect = api_expects(:content_views, :index) do |p|
        p['name'] == content_view.name && p["organization_id"].to_s == @organization.id.to_s
      end
      cv_expect.at_least_once.returns(index_response([{'id' => content_view.id}]))
    end

    describe 'allows adding a component with' do
      it 'component-content-view-id and latest=true' do
        latest = true
        params = ["--composite-content-view-id=#{@composite.id}",
                  "--component-content-view-id=#{@component.id}",
                  "--latest"]

        api_expects(:content_view_components, :add_components) do |p|
          component = p['components'].first
          p['composite_content_view_id'] == @composite.id &&
            component[:latest] == latest &&
            component[:content_view_id] == @component.id.to_s
        end
        run_cmd(@cmd + params)
      end

      it 'component-content-view-version-id and latest=false' do
        latest = false
        params = ["--composite-content-view-id=#{@composite.id}",
                  "--component-content-view-version-id=#{@component_version.id}"]

        api_expects(:content_view_components, :add_components) do |p|
          component = p['components'].first
          p['composite_content_view_id'] == @composite.id &&
            component[:latest] == latest &&
            component[:content_view_version_id] == @component_version.id.to_s
        end
        run_cmd(@cmd + params)
      end
    end

    describe 'allows adding a component with composite name and org' do
      before do
        setup_org_expectations
        setup_content_view_expectations(@composite)
      end

      it 'component-content-view-id and latest=true' do
        latest = true
        params = ["--composite-content-view=#{@composite.name}",
                  "--component-content-view-id=#{@component.id}",
                  "--organization=#{@organization.name}",
                  "--latest"]

        api_expects(:content_view_components, :add_components) do |p|
          component = p['components'].first
          p['composite_content_view_id'] == @composite.id &&
            component[:latest] == latest &&
            component[:content_view_id] == @component.id.to_s
        end
        run_cmd(@cmd + params)
      end

      it 'component-content-view-version-id and latest=false' do
        latest = false
        params = ["--composite-content-view=#{@composite.name}",
                  "--organization=#{@organization.name}",
                  "--component-content-view-version-id=#{@component_version.id}"]

        api_expects(:content_view_components, :add_components) do |p|
          component = p['components'].first
          p['composite_content_view_id'] == @composite.id &&
            component[:latest] == latest &&
            component[:content_view_version_id] == @component_version.id.to_s
        end
        run_cmd(@cmd + params)
      end
    end

    describe 'allows adding a component with component name and org' do
      it 'component-content-view and latest=true' do
        latest = true
        params = ["--composite-content-view-id=#{@composite.id}",
                  "--component-content-view=#{@component.name}",
                  "--organization=#{@organization.name}",
                  "--latest"]
        setup_org_expectations
        setup_content_view_expectations(@component)
        api_expects(:content_view_components, :add_components) do |p|
          component = p['components'].first
          p['composite_content_view_id'] == @composite.id &&
            component[:latest] == latest &&
            component[:content_view_id] == @component.id
        end
        run_cmd(@cmd + params)
      end
    end

    describe 'allows adding a component with component version number org component content_view' do
      before do
        cvv_expect = api_expects(:content_view_versions, :index) do |p|
          p['content_view_id'].to_s == @component.id.to_s &&
            p["version"] == @component.content_view_version.version
        end
        cvv_expect.at_least_once.
          returns(index_response([{'id' => @component.content_view_version.id}]))
      end

      it 'component-content-view-id and component version number' do
        latest = false
        params = ["--composite-content-view-id=#{@composite.id}",
                  "--component-content-view-id=#{@component.id}",
                  "--component-content-view-version=#{@component.content_view_version.version}"]

        # 1) Should fetch the component_content_view_version_id
        #    using cv specified in --component-content-view-id and version specified in
        #    --component-content-view-version
        # 2) Should set the component[:content_view_id] && component[:content_view_version_id]
        #    correctly

        api_expects(:content_view_components, :add_components) do |p|
          component = p['components'].first
          p['composite_content_view_id'] == @composite.id &&
            component[:latest] == latest &&
            component[:content_view_id] == @component.id.to_s &&
            component[:content_view_version_id] == @component.content_view_version.id
        end
        run_cmd(@cmd + params)
      end

      it 'component-content-view and component version number' do
        latest = false
        params = ["--composite-content-view=#{@composite.name}",
                  "--component-content-view=#{@component.name}",
                  "--component-content-view-version=#{@component.content_view_version.version}",
                  "--organization=#{@organization.name}"]
        # 1) Should fetch the org using org name specified in --organization
        # 2) Should fetch composite content view using name in --composite-content-view
        # 3) Should fetch component content view using name in --component-content-view
        # 4) Should fetch the component_content_view_version_id
        #    using cv specified in --component-content-view-id and version specified in
        #    --component-content-view-version
        # 5) Should set the component[:content_view_id] && component[:content_view_version_id]
        #    correctly
        setup_org_expectations
        setup_content_view_expectations(@component)
        setup_content_view_expectations(@composite)
        api_expects(:content_view_components, :add_components) do |p|
          component = p['components'].first
          p['composite_content_view_id'] == @composite.id &&
            component[:latest] == latest &&
            component[:content_view_id] == @component.id &&
            component[:content_view_version_id] == @component.content_view_version.id
        end
        run_cmd(@cmd + params)
      end
    end
  end
end
