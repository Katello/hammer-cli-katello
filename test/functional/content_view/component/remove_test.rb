require_relative '../../test_helper'
require 'hammer_cli_katello/content_view_component'
module HammerCLIKatello
  describe ContentViewComponent::RemoveComponents do
    before do
      @cmd = %w(content-view component remove)

      @component = ::OpenStruct.new(:id => 6, :name => "component")
      @component2 = ::OpenStruct.new(:id => 7, :name => "component2")

      @content_view_component = ::OpenStruct.new(:id => 1444,
                                               :content_view => @component)

      @content_view_component2 = ::OpenStruct.new(:id => 1445,
                                                :content_view => @component2)

      @composite = ::OpenStruct.new(:id => 2, :name => "composite",
                                  :content_view_components => [@content_view_component])
      @organization = ::OpenStruct.new(:id => 1, :name => "great", :label => "label")
      @content_view_components = [@content_view_component, @content_view_component2]
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
      ret = @content_view_components.map do |cvc|
        { "id" => cvc.id,
          "content_view" => {"id" => cvc.content_view.id,
                             "name" => cvc.content_view.name}}
      end
      cvc_expect.at_least_once.returns(index_response(ret))
    end

    describe 'allows deleting component with' do
      it 'id and component-ids' do
        params = ["--composite-content-view-id=#{@composite.id}",
                  "--component-ids=#{@content_view_components.map(&:id).join(',')}"]

        api_expects(:content_view_components, :remove_components) do |p|
          component_ids = p['component_ids'].map(&:to_s)
          p['composite_content_view_id'].to_s == @composite.id.to_s &&
            component_ids.include?(@content_view_component.id.to_s) &&
            component_ids.include?(@content_view_component2.id.to_s)
        end
        run_cmd(@cmd + params)
      end

      it 'id and component-content-view-id' do
        component_cv_ids = @content_view_components.map do |cvc|
          cvc["content_view"]["id"]
        end

        params = ["--composite-content-view-id=#{@composite.id}",
                  "--component-content-view-ids=#{component_cv_ids.join(',')}"]
        setup_content_view_components_expectations

        api_expects(:content_view_components, :remove_components) do |p|
          component_ids = p['component_ids'].map(&:to_s)
          p['composite_content_view_id'].to_s == @composite.id.to_s &&
            component_ids.include?(@content_view_component.id.to_s) &&
            component_ids.include?(@content_view_component2.id.to_s)
        end
        run_cmd(@cmd + params)
      end

      it 'orgs and component-content-view-names' do
        component_cv_names = @content_view_components.map do |cvc|
          cvc["content_view"]["name"]
        end

        params = ["--composite-content-view=#{@composite.name}",
                  "--component-content-views=#{component_cv_names.join(',')}",
                  "--organization=#{@organization.name}"]
        # 1) Should fetch the org using org name specified in --organization
        # 2) Should fetch composite content view using name in --composite-content-view
        # 3) Should fetch component content view using name in --component-content-view

        setup_org_expectations
        setup_content_view_expectations(@composite)
        setup_content_view_components_expectations

        api_expects(:content_view_components, :remove_components) do |p|
          component_ids = p['component_ids'].map(&:to_s)
          p['composite_content_view_id'].to_s == @composite.id.to_s &&
            component_ids.include?(@content_view_component.id.to_s) &&
            component_ids.include?(@content_view_component2.id.to_s)
        end
        run_cmd(@cmd + params)
      end
    end
  end
end
