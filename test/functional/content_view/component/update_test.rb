require_relative '../../test_helper'
require 'hammer_cli_katello/content_view_component'
module HammerCLIKatello
  describe ContentViewComponent::UpdateCommand do
    before do
      @cmd = %w(content-view component update)
      @component_version = ::OpenStruct.new(:id => 666, :version => "1.0")
      @component = ::OpenStruct.new(:id => 6, :name => "component",
                                    :content_view_version => @component_version)
      @content_view_component = ::OpenStruct.new(:id => 1444,
                                                 :content_view => @component,
                                                 :content_view_version => @component_version)

      @composite = ::OpenStruct.new(:id => 2, :name => "composite",
                                    :content_view_components => [@content_view_component])
      @organization = ::OpenStruct.new(:id => 1, :name => "great", :label => "label")
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
      cv_expect.at_least_once.returns(index_response([{"id" => content_view.id}]))
    end

    def setup_content_view_components_expectations
      cvc_expect = api_expects(:content_view_components, :index) do |p|
        p[:composite_content_view_id].to_s == @composite.id.to_s
      end
      ret = {
        "id" => @content_view_component.id,
        "content_view" => {"id" => @content_view_component.content_view.id},
        "content_view_version" => {"id" => @content_view_component.content_view_version.id}
      }

      cvc_expect.at_least_once.returns(index_response([ret]))
    end

    describe 'allows updating a component with' do
      it 'id and component-content-view-id and latest=true' do
        latest = true
        params = ["--composite-content-view-id=#{@composite.id}",
                  "--id=#{@content_view_component.id}",
                  "--component-content-view-id=#{@component.id}",
                  "--latest"]

        api_expects(:content_view_components, :update) do |p|
          p['composite_content_view_id'].to_s == @composite.id.to_s &&
            p['id'].to_s == @content_view_component.id.to_s &&
            p['latest'] == latest &&
            p['content_view_id'].to_s == @component.id.to_s &&
            !p.key?('content_view_version_id')
        end
        run_cmd(@cmd + params)
      end

      it 'id and component-content-view-version-id and latest=false' do
        latest = false
        params = ["--composite-content-view-id=#{@composite.id}",
                  "--id=#{@content_view_component.id}",
                  "--component-content-view-version-id=#{@component.content_view_version.id}"]

        api_expects(:content_view_components, :update) do |p|
          p['composite_content_view_id'].to_s == @composite.id.to_s &&
            p['id'].to_s == @content_view_component.id.to_s &&
            p['latest'] == latest &&
            p['content_view_version_id'].to_s == @component.content_view_version.id.to_s &&
            !p.key?('content_view_id')
        end
        run_cmd(@cmd + params)
      end

      it 'component-content-view-id and latest=true' do
        latest = true
        params = ["--composite-content-view-id=#{@composite.id}",
                  "--component-content-view-id=#{@component.id}",
                  "--latest"]
        setup_content_view_components_expectations
        api_expects(:content_view_components, :update) do |p|
          p['composite_content_view_id'].to_s == @composite.id.to_s &&
            p['id'].to_s == @content_view_component.id.to_s &&
            p['latest'] == latest &&
            p['content_view_id'].to_s == @component.id.to_s &&
            !p.key?('content_view_version_id')
        end
        run_cmd(@cmd + params)
      end

      it 'by names and orgs' do
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
        setup_content_view_components_expectations
        cvv_expect = api_expects(:content_view_versions, :index) do |p|
          p['content_view_id'].to_s == @component.id.to_s &&
            p["version"].to_s == @component.content_view_version.version.to_s
        end
        cvv_expect.at_least_once.
          returns(index_response([{'id' => @component.content_view_version.id}]))

        api_expects(:content_view_components, :update) do |p|
          p['composite_content_view_id'].to_s == @composite.id.to_s &&
            p['id'].to_s == @content_view_component.id.to_s &&
            p['latest'] == latest &&
            p['content_view_id'].to_s == @component.id.to_s &&
            p['content_view_version_id'].to_s == @component.content_view_version.id.to_s
        end
        run_cmd(@cmd + params)
      end
    end
  end
end
